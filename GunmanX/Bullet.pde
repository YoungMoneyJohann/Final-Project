class Bullet {
  float x, y, sz, dx, dy;
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
    fill(255,255,0);
    ellipse(x, y, sz, sz);
  }

  void move() {
    x+=dx;
    y+=dy;
  }
}

