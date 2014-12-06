import processing.serial.*;
Serial myPort;

//Classes
Wave dropWave = new Wave();
Info dashboardInfo = new Info();
Lines dashLines = new Lines();
LineGraph lineData = new LineGraph();

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

void setup() {

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


  imageMode(CENTER);
  size(dashboard.width, dashboard.height);
  smooth();
  dashboardInfo.loadText();
  lineData.processData();

  // String portName = "/dev/tty.usbmodem1421"; // name of the port you want to use
  // myPort = new Serial(this, portName, 9600); // initiatlize the port
  // myPort.bufferUntil('\n'); // only generate a serialEvent when you see a new line
  // myPort.clear(); // clear buffer

  //random tip generator
  randomTip = int(random(0, 5));
    // week drop counter
  dashboardInfo.weekDropCounterContainer=""+dashboardInfo.weekDropCounter;
}

void draw() {
  background(255);


  if (pageCounter==0) {
    dropWave.display();
    dropWave.move();
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



// void serialEvent (Serial myPort) {
//   dashboardText.kitchenWellTap = myPort.readString();
//   println(dashboardText.kitchenWellTap);
//   dashboardText.kitchenWellTap = trim(dashboardText.kitchenWellTap);
//   //int XXXX [] = int(split(fsrs, ','));
//   dashboardText.sensorRead=int(dashboardText.kitchenWellTap);
//   //dashboardText.incrementWT ();
// }
