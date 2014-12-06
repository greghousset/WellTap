class Info {

  int sensorRead=0;
  int sensorReadWeek=689;
  int toiletFlushes=0;
  int toiletLiters=0;
  int toiletLitersWeek=176;
  int laundryLiters=0;
  int laundryLitersWeek=605;
  int laundryLoads=0;
  int dishLiters =0;
  int dishLitersWeek=377;
  int dishLoads=0;
  int dropCounter=0;
  int weekDropCounter=0;
  String weekDropCounterContainer;
  String liters="";
  int counterFontSize;

  int dropCounterR=108;
  int dropCounterG=171;
  int dropCounterB=224;
  int dropCounterOpacity=170;

  int average=302;
  int averageWeek=2114;
  int yesterday= 270;
  int lastWeek= 1900;

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

  void drawToggleButton() {
    image(toggleButton, 97, 95);
    if (pageCounter==0) {
      image(chartIcon, 95, 88);
      textFont(font3);
      fill(210);
      textSize(18);
      text("WEEK", 96, 120);
    }
    if (pageCounter==1) {
      image(dayDrop, 100, 84);
      textFont(font3);
      fill(210);
      textSize(18);
      text("DAY", 96, 120);
    }
  }

  void incrementToggleButton() {
    if (pageCounter==0) {
      if (dist(97, 95, mouseX, mouseY)<55) {
        pageCounter=1;
      }
    } else if (pageCounter==1) {
      if (dist(97, 95, mouseX, mouseY)<55) {
        pageCounter=0;
      }
    }
  }

  void dropText () {
    // Drop -Total Liters
    textFont(font);
    fill (dropCounterR, dropCounterG, dropCounterB, dropCounterOpacity);
    textSize(counterFontSize);

    if (pageCounter==0) {
      counterFontSize=75;
      text(dropCounter, 370, 312);
      liters = "LITERS";
    }

    if (pageCounter==1) {
      text(weekDropCounterContainer, 370, 312);
    }
    textFont(font2);
    textSize(31);
    //liters = "LITERS";
    text(liters, 370, 378);
  }

  void checkDrop () {
    // constantly check the drop value
    boolean check=true;
    if (check==true) {
      if (pageCounter==0) {
        dropCounter = sensorRead+toiletLiters+laundryLiters+dishLiters;
        toiletLiters = toiletFlushes*13;
        laundryLiters = laundryLoads*151;
        dishLiters= dishLoads*22;
      }
      if (pageCounter==1) {
        weekDropCounter = sensorReadWeek+toiletLitersWeek+laundryLitersWeek+dishLitersWeek;
        // toiletLiters = toiletFlushes*13;
        // laundryLiters = laundryLoads*151;
        // dishLiters= dishLoads*22;
      }
    }
  }

  void averageTab() {

    dropWave.y= map(sin(dropWave.angle), -1, 1, 198, 208);
    if (mouseX>725 && mouseX<900) {
      if (mouseY>0 && mouseY<166) {
        if (pageCounter==0) {
          image(averageTab, 550, dropWave.y);
        }
        if (pageCounter==1) {
          image(weekAverageTab, 362.5, dropWave.y-12);
        }
      }
    }
  }

  void yesterdayTab() {
    dropWave.y= map(sin(dropWave.angle), -1, 1, 230, 240);
    if (mouseX>725 && mouseX<900) {
      if (mouseY>166 && mouseY<332) {
        if (pageCounter==0) {
          image(yesterdayTab, 569, dropWave.y);
        }
        if (pageCounter==1) {
          image(lastWeekTab, 362.5, dropWave.y);
        }
      }
    }
  }

  void sensorsWT () {
    // Well Tap Sensors 
    textFont(font);
    fill (255);
    textSize(65);
    if (pageCounter==0) {
      text(sensorRead, 88, 693);
    }
    if (pageCounter==1) {
      text(sensorReadWeek, 88, 693);
    }
    textFont(font3);
    textSize(18);
    String WT = "WellTap Sensors";
    text(WT, 88, 748);
    text("(liters)", 88, 774);
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
    if (pageCounter==0) {
      text(toiletLiters, 272, 693);
    }
    if (pageCounter==1) {
      text(toiletLitersWeek, 272, 693);
    }
    textFont(font3);
    textSize(18);
    String f = "Flushes";
    text(f, 272, 748);
    text("(liters)", 272, 774);
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
    if (pageCounter==0) {
      text(laundryLiters, 450, 693);
    }
    if (pageCounter==1) {
      text(laundryLitersWeek, 450, 693);
    }
    textFont(font3);
    textSize(18);
    String l = "Laundry";
    text(l, 450, 748);
    text("(liters)", 450, 774);
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
    if (pageCounter==0) {
      text(dishLiters, 630, 693);
    }
    if (pageCounter==1) {
      text(dishLitersWeek, 630, 693);
    }
    textFont(font3);
    textSize(18);
    String d = "Dishes";
    text(d, 630, 748);
    text("(liters)", 630, 774);
  }

  void buttonDrawDishes () {
    // Drop - Increment Flush Literage with button
    image(tab, 634, 628, 179, 48);
    image(plus, 682, 630, 24, 24);
    textFont(font2);
    fill (209, 209, 210);
    textSize(38);
    text(dishLoads, 632, 626);
    image(minus, 588, 630, 24, 24);
  }

  void incrementDishes () {
    // Drop - Increment Flush Literage with button
    if (dist(682, 629, mouseX, mouseY)<14) {
      dishLoads += 1;
    }
    if (dist(587, 629, mouseX, mouseY)<14) {
      dishLoads -= 1;
    }
  }

  void averagePC() {
    // Average liters PC daily
    textFont(font);
    fill (255);
    textSize(65);
    if (pageCounter==0) {
      text(average, 810, 50);
    }
    if (pageCounter==1) {
      text(averageWeek, 810, 50);
    }
    textFont(font3);
    textSize(18);
    String av; 
    String us;
    if (pageCounter==0) {
      av= "Daily Average";
      text(av, 810, 107);
    }
    if (pageCounter==1) {
      av= "Weekly Average"; 
      text(av, 810, 107);
    }
    us= "in United States";
    text(us,810,132);
  }

  void yesterdayTotal() {
    // liters Consumed Previous Day
    textFont(font);
    fill (255);
    textSize(65);
    if (pageCounter==0) {
      text(yesterday, 810, 225);
    }
    if (pageCounter==1) {
      text(lastWeek, 810, 225);
    }
    textFont(font3);
    textSize(18);
    String yt;
    if (pageCounter==0) {
      yt= "Yesterday"; 
      text(yt, 810, 282);
    }
    if (pageCounter==1) {
      yt= "Last Week"; 
      text(yt, 810, 282);
    }
  }


  void waterTips() {
    // Tips to conserve water
    String tip0 = "Don't rinse dishes before loading dishwasher. Water saved: 20 gallons per load.";
    String tip1 = "A small drip from a worn faucet washer can waste 20 gallons of water per day.";
    String tip2 = "Spend only 5 minutes in the shower: saves up to 8 gallons each time.";
    String tip3 = "Turn off the water while you brush your teeth: saves up to 2.5 gallons per minute.";
    String tip4 = "Washing dishes by hand uses four times the water that energy efficient dishwashers use.";
    String tip5 = "The average bath uses 35 to 50 gallons of water, while a 10 minute shower uses 25 gallons.";
    String[] waterTips = {
      tip0, tip1, tip2, tip3, tip4, tip5
    };
    fill(255);
    strokeWeight(3);
    stroke(158, 197, 164, 150);
    arc(725, 334, 90, 90, 0, HALF_PI);
    image(tip, 743, 352);
    textFont(font3);
    textSize(18);
    textLeading(30);

    if (randomTip>5) {
      randomTip=0;
    }

    text(waterTips[randomTip], 745, 295, 140, 400);
  }

  void iterateTip() {
    if (dist(743, 352, mouseX, mouseY)<25) {
      randomTip++;
    }
  }
}
