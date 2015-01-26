class Health {
  float x, y, lives, sz;
  PImage Health;
  Health(float x_, float y_, float lives_, float sz_) {
    x=x_;
    y=y_;
    lives=lives_;
    sz=sz_;
    Health = loadImage("Health.png");
  }
  
  void display() {
    image(Health, x, y, sz, sz);
  }
  
  boolean contactPlayer(Player p) {
    if (p.loc.x>x && p.loc.x<x+sz && p.loc.y>y && p.loc.y<y + sz) {
      return true;
    } else {
      return false;
    }
  }
}
