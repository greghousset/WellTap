import java.util.*;
import java.text.*;
import http.requests.*;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

//Classes
Wave dropWave = new Wave();
Info dashboardInfo = new Info();
Lines dashLines = new Lines();
LineGraph lineData = new LineGraph();
JSON JSONData = new JSON();

// Timer
long previousMillis = 0;  // will store last time lcd was reset
long interval = 5*1000;    // interval at which to reset (milliseconds)
long currentMillis = 0;

// Images
PImage dashboard;
PImage tip;
PImage plus;
PImage minus;
PImage tab;
PImage weekDashboard;
PImage toggleButton;
PImage chartIcon;
PImage dayDrop;
PImage caution;
PImage averageTab;
PImage weekAverageTab;
PImage yesterdayTab;
PImage lastWeekTab;
PImage chartBG;

// Page Counter
int pageCounter=0;

// Tip number in array of water tips
int randomTip;

//for http surveillance
boolean isRequesting;

void setup() {
  loadImages();
  httpRequestsInitial();
  dashboardInfo.loadText();
  lineData.processData();

  imageMode(CENTER);
  size(dashboard.width, dashboard.height);
  smooth();

  randomTip = int(random(0, 5)); //random tip generator
  dashboardInfo.weekDropCounterContainer=""+dashboardInfo.weekDropCounter; // week drop counter
}


void draw() {
  background(255);
  httpRequestTimer();

  if (pageCounter==0) {
    dropWave.display();
    dropWave.move();
    dropWave.sensorWaveIncrement();

    dropWave.AverageBenchmark();
    dropWave.yesterdayBenchmark();

    image(dashboard, width/2, height/2);

    dashLines.displayBottom();
    dashLines.displayRight();

    dashboardInfo.drawToggleButton();

    dashboardInfo.checkDrop();
    dashboardInfo.dropText();
    dashboardInfo.averageTab();
    dashboardInfo.yesterdayTab();

    dashboardInfo.sensorsWT();

    dashboardInfo.toiletText();
    dashboardInfo.buttonDrawFlush();

    dashboardInfo.washingMachine();
    dashboardInfo.buttonDrawLaundry();

    dashboardInfo.dishWasher();
    dashboardInfo.buttonDrawDishes();

    dashboardInfo.averagePC();
    dashboardInfo.yesterdayTotal();
    dashboardInfo.waterTips();
  }

  if (pageCounter==1) {

    dropWave.display();
    dropWave.move();
    lineData.drawGUI();

    dropWave.AverageBenchmark();
    dropWave.yesterdayBenchmark();

    image(weekDashboard, width/2, height/2);

    dashLines.displayBottom();
    dashLines.displayRight();

    dashboardInfo.drawToggleButton();

    dashboardInfo.dropText();
    dashboardInfo.checkDrop();
    dropWave.weekWaveIncrement();

    dashboardInfo.sensorsWT();
    dashboardInfo.toiletText();
    dashboardInfo.washingMachine();
    dashboardInfo.dishWasher();

    dashboardInfo.averagePC();
    dashboardInfo.averageTab();
    dashboardInfo.yesterdayTotal();
    dashboardInfo.yesterdayTab();

    dashboardInfo.waterTips();
  }
}

void loadImages() {
  dashboard = loadImage("drop.png");
  weekDashboard = loadImage("weekdashboard.png");
  tip = loadImage("lightbulb.png");
  plus = loadImage("plus.png");
  minus = loadImage("minus.png");
  tab = loadImage("tab.png");
  toggleButton = loadImage("dayweekbutton.png");
  chartIcon = loadImage("charticon.png");
  dayDrop = loadImage("daydrop.png");
  caution = loadImage("caution.png");
  averageTab = loadImage("averagetab.png");
  weekAverageTab = loadImage("weeklyaveragetab.png");
  yesterdayTab = loadImage("yesterdaytab.png");
  lastWeekTab = loadImage("lastweektabs.png");
  chartBG = loadImage("chartBG.png");
}

void httpRequestsInitial() {

  String content;
  //GetRequest get = new GetRequest("https://dweet.io/get/dweets/for/wellTapFaucet1");
  //get.send(); // program will wait untill the request is completed

  try {
    println("start");
    isRequesting=true;
    // get.send(); // program will wait untill the request is completed
    content = send("https://dweet.io/get/dweets/for/wellTapFaucet1");
    isRequesting=false;
    println("end");
  }

  catch(Exception exception) {
    println("error");
    isRequesting=false;
    println(exception.getMessage());
    return;
  }

  if (content==null) {
    println("null content");
    return;
  }

  //println("response: " + get.getContent())
  // println(get.getHeader("Status"));
  float literSum=0;
  // JSONObject response = parseJSONObject(get.getContent());
  JSONObject response = parseJSONObject(content);
  JSONArray nameDates = response.getJSONArray("with");
  for (int i=0; i<nameDates.size (); i++) {

    JSONObject nameDate = nameDates.getJSONObject(i);
    //print("  date: " + nameDate.getString("created"));
    //print(", ");
    JSONObject literData = nameDate.getJSONObject("content");
    //println("  Session Liters: " + literData.getFloat("session_Liters"));
    literSum += literData.getFloat("session_Liters", 0);
    dashboardInfo.sensorRead = literSum;

    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.ENGLISH);
    dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
    try {
      Date result = dateFormat.parse(nameDate.getString("created"));
      //println(result);
    }
    catch(ParseException exception) {
      println(exception.getMessage());
    }
  }
}

void httpRequestTimer() {

  currentMillis = millis();
  if (currentMillis - previousMillis > interval) {
    // save the last time you reset 
    previousMillis = currentMillis;
    // scrap JSON
    if (!isRequesting){
    httpRequestsInitial();
    }
  }
}
//modified http request library to determine exception on request failure

String send(String url) throws Exception
{
  DefaultHttpClient httpClient = new DefaultHttpClient();

  HttpGet httpGet = new HttpGet(url);

  HttpResponse response = httpClient.execute( httpGet );
  HttpEntity entity = response.getEntity();
  String content = EntityUtils.toString(response.getEntity());

  if ( entity != null ) EntityUtils.consume(entity);
  httpClient.getConnectionManager().shutdown();
  return content;
}


// void doStuff() throws Exception {

// }
