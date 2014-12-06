class Wave {
  float waveIncrease = 0;
  float waveIncreaseWeek=0;
  float startAngle = 0;
  float angleVel = 0.3;
  float angle;

  float r=174;
  float g=210;
  float b=240;
  float opacity=100;
  float strokeR=108;
  float strokeG=171;
  float strokeB=224;

  float y; 
  float baseSin;
  float topSin;

  void display () {
    //adjust water height for each page
    if (pageCounter==0) {
      baseSin=500; 
      topSin=510;
    }
    if (pageCounter==1) {
      baseSin=630; 
      topSin=640;
    }

    // Draw polygon out of wave points
    angle = startAngle;
    fill(r, g, b, opacity);
    stroke(strokeR, strokeG, strokeB, 180);
    strokeWeight(3);
    beginShape();

    // Iterate over horizontal pixel
    for (float x = -50; x <= width+50; x += 12) {
      y = map(sin(angle), -1, 1, baseSin, topSin); // Calculate y value according to sine angle and map
      if (pageCounter==0) {
        vertex(x, y+waveIncrease);
      } // Set the vertex for day
      if (pageCounter==1) {
        vertex(x, y+waveIncreaseWeek);
      } // Set the vertex for week
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
    waveIncrease = -1*dashboardInfo.dropCounter;
    //waveIncrease -= 1;
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
    if (dist(502, 629, mouseX, mouseY)<14) {
      waveIncrease -= 151;
    }

    if (dist(406, 629, mouseX, mouseY)<14) {
      waveIncrease += 151;
    }
  }

  void dishesWaveIncrement () {
    if (dist(682, 629, mouseX, mouseY)<14) {
      waveIncrease -= 22;
    }
    if (dist(587, 629, mouseX, mouseY)<14) {
      waveIncrease += 22;
    }
  }

  void weekWaveIncrement () {
    waveIncreaseWeek= -1*(dashboardInfo.weekDropCounter/4.76126126126126);
  }

  void AverageBenchmark() {

    // draw benchmark
    if (pageCounter==0) {
      if (mouseX>725 && mouseX<900) {
        if (mouseY>0 && mouseY<166) {
          for (float x = -50; x <= width+50; x += 12) {
            y= map(sin(angle), -1, 1, 198, 208); // Calculate y value according to sine angle and map
            noStroke();
            fill(255, 149, 0);
            ellipse(x, y, 3, 3); 
            angle +=angleVel; // Determine angle of wave
          }
        }
      }
    } else if (pageCounter==1) {
      if (mouseX>725 && mouseX<900) {
        if (mouseY>0 && mouseY<166) {
          for (float x = -50; x <= width+50; x += 12) {
            y= map(sin(angle), -1, 1, 186, 196); // Calculate y value according to sine angle and map
            noStroke();
            fill(255, 149, 0);
            ellipse(x, y, 3, 3); 
            angle +=angleVel; // Determine angle of wave
          }
        }
      }
    }

    if (pageCounter==0) {
      if (dashboardInfo.dropCounter>302) {
        r=255;
        g=149;
        b=0;
        opacity=200;
        strokeR=255;
        strokeG=102;
        strokeB=0;
        dashboardInfo.dropCounterR =255;
        dashboardInfo.dropCounterG=255;
        dashboardInfo.dropCounterB=255;
        dashboardInfo.dropCounterOpacity=255;

        image(caution, 370, 450);
      } else {
        dashboardInfo.dropCounterR =108;
        dashboardInfo.dropCounterG=171;
        dashboardInfo.dropCounterB=224;
        dashboardInfo.dropCounterOpacity=170;
        r=174;
        g=210;
        b=240;
        strokeR=108;
        strokeG=171;
        strokeB=224;
        opacity=100;
      }
    }

    if (pageCounter==1) {
      if (dashboardInfo.weekDropCounter>2114) {
        r=255;
        g=149;
        b=0;
        opacity=200;
        strokeR=255;
        strokeG=102;
        strokeB=0;
        dashboardInfo.dropCounterR =255;
        dashboardInfo.dropCounterG=255;
        dashboardInfo.dropCounterB=255;
        dashboardInfo.dropCounterOpacity=255;

        image(caution, 370, 450);
      } else {
        dashboardInfo.dropCounterR =108;
        dashboardInfo.dropCounterG=171;
        dashboardInfo.dropCounterB=224;
        dashboardInfo.dropCounterOpacity=170;
        r=174;
        g=210;
        b=240;
        strokeR=108;
        strokeG=171;
        strokeB=224;
        opacity=100;
      }
    }
  }

  void yesterdayBenchmark() {

    // draw benchmark
    if (mouseX>725 && mouseX<900) {
      if (mouseY>166 && mouseY<332) {
        for (float x = -50; x <= width+50; x += 12) {

          y = map(sin(angle), -1, 1, 230, 240); // Calculate y value according to sine angle and map
          noStroke();
          fill(2, 93, 173);
          ellipse(x, y, 3, 3); 
          angle +=angleVel; // Determine angle of wave
        }
      }
    }
    if (mouseX>725 && mouseX<900) {
      if (mouseY>166 && mouseY<332) {
        for (float x = -50; x <= width+50; x += 12) {
          y = map(sin(angle), -1, 1, dashboardInfo.lastWeek-5, dashboardInfo.lastWeek+5); // Calculate y value according to sine angle and map
          noStroke();
          fill(2, 93, 173);
          ellipse(x, y, 3, 3); 
          angle +=angleVel; // Determine angle of wave
        }
      }
    }
  }
}
