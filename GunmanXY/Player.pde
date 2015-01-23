class Player {
  PVector loc, vel;
  PImage Player;
  Player(float x_, float y_, float dx_, float dy_) {
    loc = new PVector(x_, y_);
    vel = new PVector(dx_, dy_);
    Player = loadImage("Main.png");
  }

  Player() {
    loc = new PVector(width/2, height/2);
    vel = new PVector(0, 0);
    Player = loadImage("Main.png");
  }

  void display() {
    theta=atan2(mouseY-loc.y, mouseX-loc.x); //rotation angle for Player

    pushMatrix(); //<--rotation starts here
    translate(loc.x, loc.y);
    rotate(theta);
    image(Player, -(Player.width)/2, -(Player.height)/2);
    popMatrix(); //<--rotation ends here
    fill(0);
    rect(loc.x-20,loc.y-32,40,4);
    fill(255-lives*12.75,lives*12.75,0);
    rect(loc.x-20,loc.y-32,2*lives,4);
    noFill();
  }
  
  boolean hit(BossBullet q) {
    if (dist(q.x, q.y, loc.x, loc.y)<q.sz/3+Player.width/2) {
      return true;
    } else {
      return false;
    }
  }
  boolean hitList(ArrayList<BossBullet> bossbullets) {
    for (int i = 0; i < bossbullets.size (); i++) {
      BossBullet q = bossbullets.get(i);
      if (hit(q)) {
        bossbullets.remove(i);
        return true;
      }
    }
    return false;
  }




  void move() {
    loc.x += vel.x;
    loc.y += vel.y;

    if (keys['w']) {
      if (loc.y-Player.height/2<=0) { //if bullets hits an end of the screen
        loc.y+=6;
      } else {
        vel.y=-6; //regular speed
      }
      if (wallU==true) { //if wallCollision
        vel.y=0;
      }
    }
    if (keys['s']) {
      if (loc.y+Player.height/2>=height) { //if bullets hits an end of the screen
        loc.y-=6;
      } else {
        vel.y=6; //regular speed
      }
      if (wallD==true) { //if wallCollision
        vel.y=0;
      }
    }
    if (keys['a']) {
      if (loc.x-Player.width/2<=0) { //if bullets hits an end of the screen
        loc.x+=6;
      } else {
        vel.x=-6; //regular speed
      }
      if (wallL==true) { //if wallCollision
        vel.x=0;
      }
    }
    if (keys['d']) {
      if (loc.x+Player.width/2>=width) { //if bullets hits an end of the screen
        loc.x-=6;
      } else { //regular speed
        vel.x=6;
      }
      if (wallR==true) { //if wallCollision
        vel.x=0;
      }
    } 
    if (keys['e']) {
      grunts.add(new Grunt());
      keys['e']=false;
    }
  }
}

