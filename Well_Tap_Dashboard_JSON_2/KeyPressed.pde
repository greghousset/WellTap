void keyPressed () { //<>//

  println(keyCode);
  if (keyCode==UP) {
    // dropWave.sensorWaveIncrement();
    // dashboardInfo.incrementWT ();
  }

  if (keyCode==82) {
    dashboardInfo.sensorRead=0;
    dashboardInfo.toiletLiters= 0;
    dashboardInfo.toiletFlushes= 0;
    dashboardInfo.laundryLoads=0;
    dashboardInfo.laundryLiters=0;
    dashboardInfo.dishLiters =0;
    dashboardInfo.dishLoads =0;
    dashboardInfo.dropCounter=0;
    dropWave.waveIncrease=0;
  }
}
