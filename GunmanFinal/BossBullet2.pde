class BossBullet2 {
  float x, y, sx, sy, dx, dy, ang; //see BossBullet class for related info
  PImage fireball1, fireball2;
  BossBullet2(float x_, float y_, float sx_, float sy_, float ang_, Boss b) {
    x = x_;
    y = y_;
    ang = ang_;
    dx = 30*cos(b.phip+ang);
    dy = 30*sin(b.phip+ang);
    sx = sx_;
    sy = sy_;
    fireball1=loadImage("fireb1.png");
    fireball2=loadImage("fireb2.png");
  }

  BossBullet2(Boss b) {
    x = b.loc.x;
    y = b.loc.y;
    dx = 25*cos(b.phip);
    dy = 25*sin(b.phip);
    sx = 22;
    sy = 18;
  }

  void display(Boss b) {
    fill(50);
    pushMatrix();
    translate(x, y);
    rotate(b.phip + ang);
    if (frameCount%12 <6) {
      image(fireball1,-sx/2,-sy/2,sx,sy);
    } else if (frameCount%12 >=6) {
      image(fireball2,-sx/2,-sy/2,sx,sy);
    } 
    popMatrix();
  }

  void move() {
    x+=dx;
    y+=dy;
  }
  
  boolean contactB2Bullet(Wall w) {
    if (x+sy/2>w.x && x-sy/2<w.x+w.sx && y-sy/2>w.y && y+sy/2<w.y + w.sy) {
      return true;
    } else {
      return false;
    }
  }
  boolean contactListB2Bullet(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactB2Bullet(w)) {
        return true;
      }  
    }
    return false;
  }
}

