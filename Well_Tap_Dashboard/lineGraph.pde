class LineGraph {
  String testweek = "testweek.csv";
  String[] rawData;
  String [] day = new String[7];

  int [] wellTapData = new int[7];
  int [] toiletData = new int[7];
  int [] laundryData = new int[7];
  int [] dishData = new int[7];
  int [] totalData = new int[7];

  int overallMin, overallMax;

  int margin, graphHeight;
  float xSpacer;
  PVector[] positions = new PVector[7];

  String chartDisplay;


  void drawGUI() {
    image(chartBG, 523, 560);
    for (int i=0; i<positions.length; i++) {
      stroke(210);
      strokeWeight(1);
      line(positions[i].x, 510, positions[i].x, 610);
      fill(255);
      stroke(108, 171, 224, 180);
      strokeWeight(2);

      if (i>0) {
        stroke(108, 171, 224, 180);
        line(positions[i].x, positions[i].y, positions[i-1].x, positions[i-1].y);
      }
    }
    //resets for IF statement below
    dashboardInfo.weekDropCounterContainer=""+dashboardInfo.weekDropCounter;
    dashboardInfo.liters="LITERS";
    dashboardInfo.counterFontSize=75;
    dashboardInfo.sensorReadWeek=wellTapData[1]+wellTapData[2]+wellTapData[3]+wellTapData[4]+wellTapData[5]+wellTapData[6];
    dashboardInfo.toiletLitersWeek=toiletData[1]+toiletData[2]+toiletData[3]+toiletData[4]+toiletData[5]+toiletData[6];
    dashboardInfo.laundryLitersWeek=laundryData[1]+laundryData[2]+laundryData[3]+laundryData[4]+laundryData[5]+laundryData[6];
    dashboardInfo.dishLitersWeek=dishData[1]+dishData[2]+dishData[3]+dishData[4]+dishData[5]+dishData[6];
    
    for (int i=0; i<positions.length; i++) {
      fill(255);
      ellipse(positions[i].x, positions[i].y, 15, 15);

      //fill(108, 171, 224, 180);
      if (dist(positions[i].x, positions[i].y, mouseX, mouseY)<8) {
        chartDisplay= day[i]+", "+totalData[i]+" Liters";
        dashboardInfo.weekDropCounterContainer=chartDisplay;
        dashboardInfo.liters="";
        dashboardInfo.counterFontSize=46;
        
        dashboardInfo.sensorReadWeek=wellTapData[i];
        dashboardInfo.toiletLitersWeek=toiletData[i];
        dashboardInfo.laundryLitersWeek=laundryData[i];
        dashboardInfo.dishLitersWeek=dishData[i];
        
      }
    }
  }

  void processData () {
    rawData = loadStrings(testweek);
    for (int i=1; i<rawData.length; i++) {
      String[] thisRow = split(rawData[i], ",");
      day[i-1] = thisRow[0];
      wellTapData[i-1] = int(thisRow[1]);
      toiletData[i-1] = int(thisRow[2]);
      laundryData[i-1] = int(thisRow[3]);
      dishData[i-1] = int(thisRow[4]);
      totalData[i-1] = int(thisRow[5]);
    }

    overallMin = min(totalData);
    overallMax = max(totalData);
    margin=50;
    graphHeight= 100;
    xSpacer= (300) / (day.length-1);

    for (int i =0; i<totalData.length; i++) {
      float adjTotal = map(totalData[i], overallMin, overallMax, 0, graphHeight);
      float yPos = (609)-adjTotal;
      float xPos = 372 + (xSpacer*i);
      positions[i] = new PVector(xPos, yPos);
    }
  }
}
