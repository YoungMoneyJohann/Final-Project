class Boss {
  PVector loc, vel;
  float  sz, scan;
  PImage Boss;
  Boss(float x_, float y_, float dx_, float dy_, float sz_, float scan_) {
    loc = new PVector(x_, y_);
    vel = new PVector(dx_, dy_);
    sz = sz_;
    scan = scan_;
    Boss = loadImage("enemy_Boss.png");
  }

  Boss() {
    loc = new PVector(width/2, random(50, height-50));
    vel = new PVector(0, 0);
    sz = 50;
    scan = 250;
    Boss = loadImage("enemy_Boss.png");
  }
  void display() {
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(phi);
    image(Boss, -(Boss.width)/2, -(Boss.height)/2);
    popMatrix();
  }

  void move() {
    if (dist(p.loc.x, p.loc.y, loc.x, loc.y)<scan) {
      vel = new PVector((p.loc.x-loc.x)/(10), (p.loc.y-loc.y)/(10));
      vel.limit(5.5);
      loc.x+=vel.x;
      loc.y+=vel.y;
    } else {
      vel = new PVector(0, 0);
    }
  }
  
  boolean contact(Boss e) {
    if (dist(p.loc.x,p.loc.y,loc.x,loc.y)<20) {
      return true;
    } else {
      return false;
    }
  }
  boolean contactList(ArrayList<Boss> Bosss) {
    for (int i = 0; i < Bosss.size (); i++) {
      Boss e = Bosss.get(i);
      if (contact(e)) {
        return true;
      }
    }
    return false;
  }
  
  boolean hit(Bullet b) {
    if (dist(b.x, b.y, loc.x, loc.y)<b.sz/2+sz/2) {
      return true;
    } else {
      return false;
    }
  }
  boolean hitList(ArrayList<Bullet> bullets) {
    for (int i = 0; i < bullets.size (); i++) {
      Bullet b = bullets.get(i);
      if (hit(b)) {
        bullets.remove(i);
        return true;
      }
    }
    return false;
  }
  
}
