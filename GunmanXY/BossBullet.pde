class BossBullet {
  float x, y, sz, dx, dy;
  PImage fire1, fire2;
  BossBullet(float x_, float y_, float sz_, float ang, Boss b) {
    x = x_;
    y = y_;
    dx = 17*cos(b.phip+ang);
    dy = 17*sin(b.phip+ang);
    sz = sz_;
    fire1=loadImage("fire1.png");
    fire2=loadImage("fire2.png");
  }

  BossBullet(Boss b) {
    x = b.loc.x;
    y = b.loc.y;
    dx = 17*cos(b.phip);
    dy = 17*sin(b.phip);
    sz = 40;
  }

  void display() {
    fill(50);
    
    if (frameCount%8 == 0 || (frameCount+1)%8 == 0 || (frameCount+2)%8 == 0 || (frameCount+3)%8 == 0) {
      image(fire1,x,y,sz,sz);
    } else if ((frameCount+4)%8 == 0 ||(frameCount+5)%8 == 0 || (frameCount+6)%8 == 0 || (frameCount+7)%8 == 0) {
      image(fire2,x,y,sz,sz);
    } 
  }

  void move() {
    x+=dx;
    y+=dy;
  }
  
  boolean contactBBullet(Wall w) {
    if (x+sz/2>w.x && x-sz/2<w.x+w.sx && y-sz/2>w.y && y+sz/2<w.y + w.sy) {
      return true;
    } else {
      return false;
    }
  }
  boolean contactListBBullet(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactBBullet(w)) {
        return true;
      }  
    }
    return false;
  }
}

