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
