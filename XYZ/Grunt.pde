class Grunt {
  PVector loc, vel;
  float  sz, scan;
  boolean wallUg;
  boolean wallDg;
  boolean wallRg;
  boolean wallLg;
  PImage grunt;
  Grunt(float x_, float y_, float dx_, float dy_, float sz_, float scan_) {
    loc = new PVector(x_, y_);
    vel = new PVector(dx_, dy_);
    sz = sz_;
    scan = scan_;
    grunt = loadImage("enemy_grunt.png");
  }

  Grunt() {
    loc = new PVector(random(50, height-50), random(50, height-50));
    vel = new PVector(0, 0);
    sz = 50;
    scan = 250;
    grunt = loadImage("enemy_grunt.png");
  }
  void display() {
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(phi);
    image(grunt, -(grunt.width)/2, -(grunt.height)/2);
    popMatrix();
  }

  void move() {
    float scalex = (this.wallLg || this.wallRg) ? 0 : 1;
    float scaley = (this.wallUg || this.wallDg) ? 0 : 1;

    if (dist(p.loc.x, p.loc.y, loc.x, loc.y)<scan) {
      vel = new PVector(2*(p.loc.x-loc.x) * scalex, 2*(p.loc.y-loc.y) * scaley);
      vel.limit(7);
      loc.x+=vel.x;
      loc.y+=vel.y;
    } else {
      vel = new PVector(0, 0);
    }
    
    this.wallLg = false;
    this.wallRg = false;
    this.wallUg = false;
    this.wallDg = false;
  }

  boolean contact(Player p) {
    if (dist(p.loc.x, p.loc.y, loc.x, loc.y)<20) {
      return true;
    } else {
      return false;
    }
  }
  //  boolean contactList(ArrayList<Grunt> grunts) {
  //    for (int i = 0; i < grunts.size (); i++) {
  //      Grunt e = grunts.get(i);
  //      if (contact(e)) {
  //        return true;
  //      }
  //    }
  //    return false;
  //  }

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

  boolean contactGruntUp(Wall w) {
    if (loc.y-grunt.height/2<w.y+w.sy && loc.x<w.x+w.sx &&
      loc.x>w.x && loc.y-grunt.width/2>w.y+w.sy/2) {
      return true;
    } else {
      return false;
    }
  }
  boolean contactGruntDown(Wall w) {
    if (loc.y+grunt.height/2>w.y && loc.x<w.x+w.sx &&
      loc.x>w.x && loc.y+grunt.width/2<w.y+w.sy/2) {
      return true;
    } else {
      return false;
    }
  }
  boolean contactGruntRight(Wall w) {
    if (loc.x+grunt.width/2>w.x && loc.y>w.y &&
      loc.y<w.y+w.sy && loc.x+grunt.width/2<w.x+w.sx/2) {
      return true;
    } else {
      return false;
    }
  }
  boolean contactGruntLeft(Wall w) {
    if (loc.x-grunt.width/2<w.x+w.sx && loc.y>w.y &&
      loc.y<w.y+w.sy && loc.x-grunt.width/2>w.x+w.sx/2) {
      return true;
    } else {
      return false;
    }
  }

  boolean contactListGruntUp(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactGruntUp(w)) {
        return true;
      }
    }
    return false;
  }
  boolean contactListGruntDown(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactGruntDown(w)) {
        return true;
      }
    }
    return false;
  }
  boolean contactListGruntRight(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactGruntRight(w)) {
        return true;
      }
    }
    return false;
  }
  boolean contactListGruntLeft(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactGruntLeft(w)) {
        return true;
      }
    }
    return false;
  }
}

