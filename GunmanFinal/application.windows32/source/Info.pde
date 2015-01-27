class Info {
  float x, y, sz, tsz;
  String info;
  PImage Info;
  Info(float x_, float y_, String info_, float sz_, float tsz_) { //tsz is text size
    x=x_;
    y=y_;
    info=info_;
    sz=sz_;
    tsz=tsz_;
    Info = loadImage("Info.png");
  }

  void display() {
    image(Info, x, y, sz, sz);
    if (dist(mouseX, mouseY, x+sz/2, y+sz/2) <= sz/2) {
      fill(255);
      rect(.2*width, .2*height, .6*width, .6*height);
      textAlign(CENTER);
      textSize(40);
      fill(0);
      text("Hints", .22*width, .23*height, .56*width, .56*height);
      textSize(tsz);
      text(info, .22*width, .35*height, .56*width, .56*height);
      textAlign(CORNER);
    }
  }

}

