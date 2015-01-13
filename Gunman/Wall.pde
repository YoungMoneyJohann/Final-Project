class Wall {
  Player p;
  float x,y,sx,sy;
  Wall(float x_, float y_, float sx_, float sy_) {
  x=x_;
  y=y_;
  sx=sx_;
  sy=sy_;
  }
  void display() {
    fill(200);
    rect(x,y,sx,sy);
  }
//  boolean contactPlayerUp() {
//    if (py-Player.height/2<y+sy && px<x+sx &&
//    px>x && py-Player.width/2>y+sy/2) {
//      return true;
//    } else {
//      return false;
//    }
//  }
//  boolean contactPlayerDown() {
//    if (py+Player.height/2>y && px<x+sx &&
//    px>x && py+Player.width/2<y+sy/2) {
//      return true;
//    } else {
//      return false;
//    }
//  }
//  boolean contactPlayerRight() {
//    if (px+Player.width/2>x && py>y &&
//    py<y+sy && px+Player.width/2<x+sx/2) {
//      return true;
//    } else {
//      return false;
//    }
//  }
//  boolean contactPlayerLeft() {
//    if (px-Player.width/2<x+sx && py>y &&
//    py<y+sy && px-Player.width/2>x+sx/2) {
//      return true;
//    } else {
//      return false;
//    }
//  }
}


