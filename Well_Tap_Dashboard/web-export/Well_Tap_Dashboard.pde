import processing.serial.*;
Serial myPort;

//Classes
Wave dropWave = new Wave();
Info dashboardInfo = new Info();
Lines dashLines = new Lines();

PImage dashboard;
PImage tip;
PImage plus;
PImage minus;
PImage tab;

void setup() {

  dashboard = loadImage("drop.png");
  tip = loadImage("lightbulb.png");
  plus = loadImage("plus.png");
  minus = loadImage("minus.png");
  tab = loadImage("tab.png");
  imageMode(CENTER);
  size(dashboard.width, dashboard.height);
  smooth();
  dashboardInfo.loadText();

  // String portName = "/dev/tty.usbmodem1421"; // name of the port you want to use
  // myPort = new Serial(this, portName, 9600); // initiatlize the port
  // myPort.bufferUntil('\n'); // only generate a serialEvent when you see a new line
  // myPort.clear(); // clear buffer
}
// 
void draw() {
  background(255);
  
  dropWave.display();
  dropWave.move();
  
  image(dashboard, width/2, height/2);
  
  dashLines.displayBottom();
  dashLines.displayRight();

  dashboardInfo.checkDrop();
  dashboardInfo.dropText ();
  
  dashboardInfo.sensorsWT();
  
  dashboardInfo.toiletText();
  dashboardInfo.buttonDrawFlush();
  
  dashboardInfo.washingMachine();
  dashboardInfo.buttonDrawLaundry ();
  
  dashboardInfo.dishWasher();
  dashboardInfo.averagePC();
  dashboardInfo.yesterdayTotal();
  dashboardInfo.waterTips();
}



// void serialEvent (Serial myPort) {
//   dashboardText.kitchenWellTap = myPort.readString();
//   println(dashboardText.kitchenWellTap);
//   dashboardText.kitchenWellTap = trim(dashboardText.kitchenWellTap);
//   //int XXXX [] = int(split(fsrs, ','));
//   dashboardText.sensorRead=int(dashboardText.kitchenWellTap);
//   //dashboardText.incrementWT ();
// }
class Info {

  int sensorRead=0;
  int toiletFlushes=0;
  int toiletLiters=0;
  int laundryLiters=0;
  int laundryLoads=0;
  int dishes =0;
  int dropCounter=0;

  int average=302;
  int yesterday= 0;

  PFont font;
  PFont font2;
  PFont font3;
  PFont font4;

  String kitchenWellTap;

  void loadText () {
    textAlign(CENTER, CENTER);
    font = loadFont("Raleway-ExtraBold-100.vlw");
    font2 = loadFont("Raleway-ExtraBold-48.vlw");
    font3 = loadFont("Raleway-Bold-18.vlw");
    font4 = loadFont("Raleway-ExtraLight-48.vlw");
  }

  void dropText () {
    // Drop -Total Liters
    textFont(font);
    fill (108, 171, 224, 170);
    textSize(75);
    text(dropCounter, 370, 312);
    textFont(font2);
    textSize(31);
    text("LITERS", 370, 378);
  }

  void checkDrop () {
    // constantly check the drop value
    boolean check=true;
    if (check==true) {
      dropCounter = sensorRead+toiletLiters+laundryLiters+dishes;
      toiletLiters = toiletFlushes*13;
      laundryLiters = laundryLoads*151;
    }
  }

  void sensorsWT () {
    // Well Tap Sensors 
    textFont(font);
    fill (255);
    textSize(65);
    text(sensorRead, 88, 699);
    textFont(font3);
    textSize(18);
    String WT = "WellTap Sensors";
    text(WT, 88, 756);
  }

  void incrementWT () {
    // Drop - Increment Well Tap Sensors
    sensorRead += 1;
  }

  void toiletText () {
    //  toilet flushes
    textFont(font);
    fill (255);
    textSize(65);
    text(toiletLiters, 272, 699);
    textFont(font3);
    textSize(18);
    String f = "Flushes";
    text(f, 272, 756);
  }

  void buttonDrawFlush () {
    // Drop - Increment Flush Literage with button
    image(tab, 272, 627);
    image(plus, 318, 630, 24, 24);
    textFont(font2);
    fill (209, 209, 210);
    textSize(38);
    text(toiletFlushes, 272, 626);
    image(minus, 224, 630, 24, 24);
  }

  void incrementFLush () {
    // Drop - Increment Flush Literage with button

    if (dist(320, 629, mouseX, mouseY)<14) {
      toiletFlushes += 1;
    }

    if (dist(224, 629, mouseX, mouseY)<14) {
      toiletFlushes -= 1;
    }
  }

  void washingMachine () {
    // laundry loads (liters)
    textFont(font);
    fill (255);
    textSize(65);
    text(laundryLiters, 450, 699);
    textFont(font3);
    textSize(18);
    String l = "Laundry";
    text(l, 450, 756);
  }

  void buttonDrawLaundry () {
    // Drop - Increment Flush Literage with button
    image(tab, 454, 627);
    image(plus, 500, 630, 24, 24);
    textFont(font2);
    fill (209, 209, 210);
    textSize(38);
    text(laundryLoads, 450, 626);
    image(minus, 406, 630, 24, 24);
  }

  void incrementLaundry () {
    // Drop - Increment Flush Literage with button

    if (dist(502, 629, mouseX, mouseY)<14) {
      laundryLoads += 1;
    }

    if (dist(406, 629, mouseX, mouseY)<14) {
      laundryLoads -= 1;
    }
  }

  void dishWasher() {
    // Number liters from dishwasher
    textFont(font);
    fill (255);
    textSize(65);
    text(dishes, 630, 699);
    textFont(font3);
    textSize(18);
    String d = "Dishes";
    text(d, 630, 756);
  }

  void incrementDishes () {
    // Drop - Increment Flush Literage
    dishes += 19;
  }

  void averagePC() {
    // Average liters PC daily
    textFont(font);
    fill (255);
    textSize(65);
    text(average, 810, 60);
    textFont(font3);
    textSize(18);
    String av = "Daily Average";
    text(av, 810, 117);
  }

  void yesterdayTotal() {
    // liters Consumed Previous Day
    textFont(font);
    fill (255);
    textSize(65);
    text(yesterday, 810, 225);
    textFont(font3);
    textSize(18);
    String yt = "Yesterday";
    text(yt, 810, 282);
  }

  void waterTips() {
    // Tips to conserve water
    strokeWeight(3);
    stroke(158, 197, 164, 150);
    arc(725, 334, 90, 90, 0, HALF_PI);
    image(tip, 743, 352);
    // tip.resize(100, 50);


    textFont(font3);
    textSize(18);
    String tips = "Don't rinse dishes before loading dishwasher. Water saved: 20 gallons per load.";
    textLeading(30);
    text(tips, 745, 280, 140, 400);
  }
}
void keyPressed () {

  println(keyCode); //<>//

  // if (keyCode==UP) {
  // dropWave.sensorWaveIncrement();
  //   dashboardInfo.incrementWT ();
  // }

  if (keyCode==82) {
    dashboardInfo.sensorRead=0;
    dashboardInfo.toiletLiters= 0;
    dashboardInfo.toiletFlushes= 0;
    dashboardInfo.laundryLoads=0;
    dashboardInfo.laundryLiters=0;
    dashboardInfo.dishes =0;
    dashboardInfo.dropCounter=0;
    dropWave.waveIncrease=0;
  }
}
class Lines {

  void displayBottom() {
    for (float x=181.5; x<=689; x+=181.5) {
      stroke(224,119,140,110);
      strokeWeight(2);
      line(x, 655, x, height);
    }
  }
  
    void displayRight() {
    for (float y=166.25; y<=400; y+=166.25) {
      stroke(158,197,164,150);
      strokeWeight(2);
      line(725, y, width, y);
    }
  }
  
}
class Wave {
  float waveIncrease = 0;
  float startAngle = 0;
  float angleVel = 0.3;

  void display () {
    float angle = startAngle;
    // Draw polygon out of wave points
    fill(174, 210, 240, 100);
    stroke(108, 171, 224, 180);
    strokeWeight(3);
    beginShape();
    // Iterate over horizontal pixel
    for (float x = -50; x <= width+50; x += 12) {

      float y = map(sin(angle), -1, 1, 500, 510); // Calculate y value according to sine angle and map
      vertex(x, y+waveIncrease); // Set the vertex
      angle +=angleVel; // Determine angle of wave
    }
    vertex(width, height+50); // extend shape down to bottom of screen
    vertex(0, height+50);
    endShape(CLOSE);
  }

  void move () {
    startAngle += 0.03;
  }

  void sensorWaveIncrement () {
    // waveIncrease -= int(dashboardText.kitchenWellTap);
    waveIncrease -= 1;
  }

  void flushWaveIncrement () {
    
    if (dist(320, 629, mouseX, mouseY)<14) {
      waveIncrease -= 13;
    }

    if (dist(224, 629, mouseX, mouseY)<14) {
      waveIncrease += 13;
    }
  }

  void laundryWaveIncrement () {
    waveIncrease -= 151;
  }

  void dishesWaveIncrement () {
    waveIncrease -= 19;
  }
}
void mouseClicked() {
  dashboardInfo.incrementFLush ();
  dropWave.flushWaveIncrement ();
  
  dashboardInfo.incrementLaundry ();
}

