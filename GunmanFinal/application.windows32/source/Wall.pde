class Wall {
  float x, y, sx, sy;
  int r, g, b; //red, green, blue
  float trans, strans;
  Wall(float x_, float y_, float sx_, float sy_, int r_, int g_, int b_, float trans_, float strans_) {
    x=x_;
    y=y_;
    sx=sx_;
    sy=sy_;
    r=r_;
    g=g_;
    b=b_;
    trans=trans_; //opacity
    strans=strans_; //stroke opacity
  }
  void display() {
    stroke(0, 0, 0, strans); 
    fill(r, g, b,trans);
    rect(x, y, sx, sy);
    stroke(0, 0, 0, 255);
  }
  boolean contactPlayerUp(Player p) { //boolean when wall contacts player
    if (p.loc.y-p.Player.height/2<y+sy && p.loc.x<x+sx &&
      p.loc.x>x && p.loc.y-p.Player.width/2>y+sy/2) {
      return true;
    } else {
      return false;
    }
  }
  boolean contactPlayerDown(Player p) {
    if (p.loc.y+p.Player.height/2>y && p.loc.x<x+sx &&
      p.loc.x>x && p.loc.y+p.Player.width/2<y+sy/2) {
      return true;
    } else {
      return false;
    }
  }
  boolean contactPlayerRight(Player p) {
    if (p.loc.x+p.Player.width/2>x && p.loc.y>y &&
      p.loc.y<y+sy && p.loc.x+p.Player.width/2<x+sx/2) {
      return true;
    } else {
      return false;
    }
  }
  boolean contactPlayerLeft(Player p) {
    if (p.loc.x-p.Player.width/2<x+sx && p.loc.y>y &&
      p.loc.y<y+sy && p.loc.x-p.Player.width/2>x+sx/2) {
      return true;
    } else {
      return false;
    }
  }
}








