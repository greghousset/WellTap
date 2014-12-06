void mouseClicked() {

  dashboardInfo.incrementFLush();
  dropWave.flushWaveIncrement();

  dashboardInfo.incrementLaundry();
  dropWave.laundryWaveIncrement();

  dashboardInfo.incrementDishes();
  dropWave.dishesWaveIncrement();
  
  dashboardInfo.iterateTip();
  
  dashboardInfo.incrementToggleButton();
  
}
