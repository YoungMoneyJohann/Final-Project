class EnemyBullet {
  float x, y, sz, dx, dy; //see BossBullet class for related info
  EnemyBullet(float x_, float y_, float sz_, float ang, Grunt2 e2) {
    x = x_;
    y = y_;
    dx = 20*cos(phi2+ang);
    dy = 20*sin(phi2+ang);
    sz = sz_;

  }

  EnemyBullet(Grunt2 e2) {
    x = e2.loc.x;
    y = e2.loc.y;
    dx = 17*cos(phi2);
    dy = 17*sin(phi2);
    sz = 40;
  }

  void display() {
    fill(181,230,29);
    strokeWeight(1.5);
    ellipse(x,y,sz,sz);
    noFill();
    strokeWeight(1);

  }

  void move() {
    x+=dx;
    y+=dy;
  }
  
  boolean contactEBullet(Wall w) {
    if (x+sz/2>w.x && x-sz/2<w.x+w.sx && y-sz/2>w.y && y+sz/2<w.y + w.sy) {
      return true;
    } else {
      return false;
    }
  }
  boolean contactListEBullet(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactEBullet(w)) {
        return true;
      }  
    }
    return false;
  }
}
