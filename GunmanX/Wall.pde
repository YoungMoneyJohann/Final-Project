class Wall {
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
  boolean contactPlayerUp(Player p) {
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


 
 
  



