//**********************FLOW METER LIBRARY


#define FLOWSENSORPIN 2
volatile uint16_t pulses = 0;
// track the state of the pulse pin
volatile uint8_t lastflowpinstate;
// you can try to keep time of how long it is between pulses
volatile uint32_t lastflowratetimer = 0;
// and use that to calculate a flow rate
volatile float flowrate;
// Interrupt is called once a millisecond, looks for any pulses from the sensor!
SIGNAL(TIMER0_COMPA_vect) {
  uint8_t x = digitalRead(FLOWSENSORPIN);
  if (x == lastflowpinstate) {
    lastflowratetimer++;
    return; // nothing changed!
  }
  if (x == HIGH) {
    //low to high transition!
    pulses++;
  }
  lastflowpinstate = x;
  flowrate = 1000.0;
  flowrate /= lastflowratetimer;  // in hertz
  lastflowratetimer = 0;
}
void useInterrupt(boolean v) {
  if (v) {
    // Timer0 is already used for millis() - we'll just interrupt somewhere
    // in the middle and call the "Compare A" function above
    OCR0A = 0xAF;
    TIMSK0 |= _BV(OCIE0A);
  } 
  else {
    // do not call the interrupt function COMPA anymore
    TIMSK0 &= ~_BV(OCIE0A);
  }
}

//***********************CC3000 Libraries
#include <Adafruit_CC3000.h>
#include <ccspi.h>
#include <SPI.h>
#include <avr/wdt.h>
//#include <string.h>
//#include "utility/debug.h"

// These are the interrupt and control pins
#define ADAFRUIT_CC3000_IRQ   3  // MUST be an interrupt pin!
// These can be any two pins
#define ADAFRUIT_CC3000_VBAT  5
#define ADAFRUIT_CC3000_CS    10
// Use hardware SPI for the remaining pins
// On an UNO, SCK = 13, MISO = 12, and MOSI = 11

//Adafruit_CC3000 cc3000 = Adafruit_CC3000(ADAFRUIT_CC3000_CS, ADAFRUIT_CC3000_IRQ, ADAFRUIT_CC3000_VBAT, SPI_CLOCK_DIVIDER); // you can change this clock speed but DI
Adafruit_CC3000 cc3000 = Adafruit_CC3000(ADAFRUIT_CC3000_CS, ADAFRUIT_CC3000_IRQ, ADAFRUIT_CC3000_VBAT, SPI_CLOCK_DIV2);

#define WLAN_SSID       "DG1670A32"        // cannot be longer than 32 characters!
#define WLAN_PASS       "DG1670AEA4A32"
#define WLAN_SECURITY   WLAN_SEC_WPA2      // Security can be WLAN_SEC_UNSEC, WLAN_SEC_WEP, WLAN_SEC_WPA or WLAN_SEC_WPA2

// Dweet parameters
#define thing_name  "wellTapFaucet1"

#include "LiquidCrystal.h"
LiquidCrystal lcd(8, 7, 21, 20, 19, 18);

//*************************WELLTAP CODE

boolean flow = false;
float lastPulse; // for determining flow state
float lastPulseRead=0; // for determining literage of individual session
float totalPulseCount;
int ledFeedback=9;
float pulsesInLiters;
float kitchenLitersTotal;
float sessionPulseDifference;
float kitchenLitersSession;
int toggle=0; //for setting previousMillis to static current millis value once water stops (1). Then trigger timer (2) 

long previousMillis = 0;  // will store last time lcd was reset
long interval = 3500;    // interval at which to reset (milliseconds)
unsigned long currentMillis = 0;

uint32_t ip;

void setup() {
  lcd.begin(16, 2);
  pinMode(FLOWSENSORPIN, INPUT);
  digitalWrite(FLOWSENSORPIN, HIGH);
  lastflowpinstate = digitalRead(FLOWSENSORPIN);
  useInterrupt(true);
  pinMode(ledFeedback, OUTPUT);

  Serial.begin(9600);


  //Initialize CC3000
  Serial.println(F("\nInitializing..."));
  if (!cc3000.begin()) {
    Serial.println(F("Couldn't begin()! Check your wiring?"));
    while(1);
  }
  // Connect to WiFi network
  Serial.print(F("Connecting to WiFi network ..."));
  cc3000.connectToAP(WLAN_SSID, WLAN_PASS, WLAN_SECURITY);
  Serial.println(F("done!"));

  /* Wait for DHCP to complete */
  Serial.println(F("Request DHCP"));
  while (!cc3000.checkDHCP())
  {
    //delay(100);
  }
}

void loop() {
  convertPulses();
  lcdDisplay();
  calculateFlowState();
  flowStateAction();
  sensorSerialPrints();
}


void sensorSerialPrints (){
  Serial.print(currentMillis);
  Serial.print("\t");
  Serial.print(previousMillis);
  Serial.print("\t");
  Serial.print(kitchenLitersTotal);
  Serial.print("\t");
  Serial.print(kitchenLitersSession);
  Serial.print("\t");
  Serial.print(pulses);
  Serial.print("\t");
  Serial.print(lastPulseRead);
  Serial.print("\t");
  Serial.println(toggle);
  Serial.print("\t");
}

void dweetConnectSend() {
  // Get IP
  uint32_t ip = 0;
  Serial.print(F("www.dweet.io -> "));
  while  (ip  ==  0)  {
    if  (!  cc3000.getHostByName("www.dweet.io", &ip))  {
      Serial.println(F("Couldn't resolve!"));
    }
    delay(500);
  }  
  cc3000.printIPdotsRev(ip);
  Serial.println(F(""));

  // Check connection to WiFi
  Serial.print(F("Checking WiFi connection ..."));
  if(!cc3000.checkConnected()){
    while(1){
    }
  }
  Serial.println(F("done."));

  // Send request
  Adafruit_CC3000_Client client = cc3000.connectTCP(ip, 80);
  if (client.connected()) {
    Serial.print(F("Sending request... "));

    client.fastrprint(F("GET /dweet/for/"));
    client.print("wellTapFaucet1");
    client.fastrprint(F("?total_Liters="));
    client.print(kitchenLitersTotal);
    client.fastrprint(F("&session_Liters="));
    client.print(kitchenLitersSession);
    client.fastrprintln(F(" HTTP/1.1"));

    client.fastrprintln(F("Host: dweet.io"));
    client.fastrprintln(F("Connection: close"));
    client.fastrprintln(F(""));

    Serial.println(F("done."));
  } 
  else {
    Serial.println(F("Connection failed"));    
    return;
  }

  Serial.println(F("Reading answer..."));
  while (client.connected()) {
    while (client.available()) {
      char c = client.read();
      Serial.print(c);
    }
  }
}

void convertPulses (){

  pulsesInLiters = pulses;
  pulsesInLiters /= 7.5;
  pulsesInLiters /= 60.0;

  kitchenLitersTotal = pulsesInLiters;

  sessionPulseDifference = pulses - lastPulseRead;
  sessionPulseDifference /= 7.5;
  sessionPulseDifference /= 60.0;

  kitchenLitersSession = sessionPulseDifference;

}

void lcdDisplay () {
  lcd.setCursor(0,0);
  lcd.print("Kitchen Sink");
  lcd.setCursor(0, 1);
  lcd.print(kitchenLitersSession); 
  lcd.print(" Liters        ");
}

void calculateFlowState () {

  if (pulses != lastPulse) {
    flow = true;
    toggle=1;
  }

  if (pulses == lastPulse) {
    flow = false;
  }

  lastPulse = pulses;
  delay(125);
}

void flowStateAction () {

  // check to see if it's time to reset the LCD; that is, if the 
  // difference between the current time and last time you last reset 
  // is bigger than the interval 
  currentMillis = millis();

  if (flow==true) {
    digitalWrite(ledFeedback, HIGH);
  }

  if (flow==false) {
    digitalWrite(ledFeedback, LOW);

    if(flow==false && toggle==1){
      previousMillis = currentMillis;
      toggle=2;
    } 

    if(toggle==2){
      if(currentMillis - previousMillis > interval) {
        // save the last time you reset 
        previousMillis = currentMillis;
        lastPulseRead = pulses;
        dweetConnectSend();
        toggle=0; 
        //Serial.println("hit");
      }
    }
  }
}



























































