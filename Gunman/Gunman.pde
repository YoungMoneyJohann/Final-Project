ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Grunt> grunts = new ArrayList<Grunt>();
ArrayList<Wall> walls = new ArrayList<Wall>();

Player p;
int lives;
int score;

int level;

float theta; //Rotation Angle for Player
float phi; //Rotation Angle for Grunt and other Enemies

boolean wallU; //Wall contact booleans (see wall class)
boolean wallD;
boolean wallR;
boolean wallL;
boolean keys[] = new boolean[255]; //Multiple key input boolean

void setup() {
  size(displayWidth, displayHeight);
  lives = 5;
  score = 0;
  level = 0;
  wallU=false;
  wallD=false;
  wallR=false;
  wallL=false;

  p = new Player();
}

void draw() {
  background(255);
  if (level==0) { //initial level or starting screen
    fill(255, 255, 0, 100);
    rectMode(CENTER);
    rect(width/2, height/2, 700, 500);
    rectMode(CORNER);
    fill(0);
    textSize(50);
    fill(255, 0, 0, 220);
    text("Start", width/2-50, height/2-50, 300, 350); //start button


    if (mousePressed && mouseX<width/2+350 && mouseX>width/2-350
      && mouseY>height/2-250 && mouseY<height/2+250) { // button function
      level=-1;
    }
  }

  if (level==-1) { //loading/preperation levels (they have '-' signs)
    background(0);
  }
  if (level==1) { // actual level
    background(#989898);
  }

  String Lives = "Lives: " + str(lives); //strings to be utilized in text
  String Score = "Score: " + str(score);

  textSize(20);
  text(Lives, 10, 10, 120, 120);
  text(Score, width-130, 10, 120, 120);




  for (int i = bullets.size () -1; i>=0; i--) { //forLoop to create bullets
    Bullet b = bullets.get(i);
    b.display();
    b.move();

    if (level==-1) { //when level changes all bullets are erased
      bullets.remove(i);
    }
    if (b.x<0 || b.x>width || b.y<0 || b.y>height) { //when bullet hits wall it disappears
      bullets.remove(i);
    }
  }

  for (int i = grunts.size () -1; i>=0; i--) { //forLoop to create grunts
    Grunt e = grunts.get(i);
    phi=atan2(p.loc.y-e.loc.y, p.loc.x-e.loc.x); //rotation angle for enemies
    e.display();
    e.move();
    if (level==-1) { //when level changes all grunts are erased
      grunts.remove(i);
    }
    if (e.contactList(grunts)==true) { //when grunts hit Player, they disappear
      grunts.remove(i);
      lives--;
    } 
    if (e.hitList(bullets)==true) { //when bullets hit grunts, they disappear
      grunts.remove(i);
      score+=10;
    }
  }

  for (int i = walls.size () -1; i>=0; i--) { //forLoop to create walls
    Wall w = walls.get(i);
    w.display();
    if (w.contactPlayerUp(p)) { //When Player is moving up when it contacts wall
      wallU=true;
    } else {
      wallU=false;
    }
    if (w.contactPlayerDown(p)) { //When Player is moving down when it contacts wall
      wallD=true;
    } else {
      wallD=false;
    }
    if (w.contactPlayerRight(p)) { //When Player is moving right when it contacts wall
      wallR=true;
    } else {
      wallR=false;
    }
    if (w.contactPlayerLeft(p)) { //When Player is moving left when it contacts wall
      wallL=true;
    } else {
      wallL=false;
    }
  }

  p.display();   //PLAYER JUNK
  p.move();

  if (level == -1) { //objects to be loaded in the preparation level
    grunts.add(new Grunt(200, 200, 0, 0, 50, 350));
    grunts.add(new Grunt(400, 200, 0, 0, 50, 350));
    grunts.add(new Grunt(200, 400, 0, 0, 50, 350));
    walls.add(new Wall(500, 300, 50, 400));
    walls.add(new Wall(200, 200, 50, 400));

    p.loc.y=height-200; //new player positions
    p.loc.x=width-200;
    level = 1; //transition to actual level
  }

  if (lives==0) { //Game over 
    textSize(30);
    text("Game Over", width/2-30, height/2-30, 120, 120);
    noLoop();
  }
}

void mousePressed() {
  bullets.add(new Bullet(p)); //bullets are added with click
}


void keyPressed() { //key/keyCode identification 
  if (key==CODED) {
    keys[keyCode] = true;
  } else if (key!=CODED) {
    keys[key] = true;
  }
}

void keyReleased() { //key/keyCode identification 
  if (key==CODED) {
    keys[keyCode] = false;
  } else if (key!=CODED) {
    keys[key] = false;
  }
  p.vel.x=0; //when release, speed = 0 so object doesn't continue to move
  p.vel.y=0;
}

