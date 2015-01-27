class Bullet {
  float x, y, sz, dx, dy; //see BossBullet class for related info
  Bullet(float x_, float y_, float sz_, float dx_, float dy_) {
    x = x_;
    y = y_;
    dx = dx_;
    dy = dy_;
    sz = sz_;
  }

  Bullet(Player p) {
    x = p.loc.x;
    y = p.loc.y;
    dx = 20*cos(theta);
    dy = 20*sin(theta);
    sz = 4;
  }

  void display() {
    fill(50);
    ellipse(x, y, sz, sz);
  }

  void move() {
    x+=dx;
    y+=dy;
  }
  
  boolean contactBullet(Wall w) {
    if (x+sz/2>w.x && x-sz/2<w.x+w.sx && y-sz/2>w.y && y+sz/2<w.y + w.sy) {
      return true;
    } else {
      return false;
    }
  }
  boolean contactListBullet(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactBullet(w)) {
        return true;
      }  
    }
    return false;
  }
}

