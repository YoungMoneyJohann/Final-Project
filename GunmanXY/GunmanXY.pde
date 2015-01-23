import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim; //variables for sound
AudioPlayer sound;

ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Grunt> grunts = new ArrayList<Grunt>();
ArrayList<Wall> walls = new ArrayList<Wall>();
ArrayList<Boss> bosses = new ArrayList<Boss>();
ArrayList<BossBullet> bossbullets = new ArrayList<BossBullet>();

Player p;
Boss boss;
int lives;
int score;

int level;

float theta; //Rotation Angle for Player
float phi; //Rotation Angle for Grunt and other Enemies


boolean wallU; //Wall contact booleans (see wall class)
boolean wallD;
boolean wallR;
boolean wallL;

boolean wallbU; //Wall contact booleans for bullets (see wall class)
boolean wallbD;
boolean wallbR;
boolean wallbL;

boolean keys[] = new boolean[255]; //Multiple key input boolean

PImage Poster;
PImage DRDPOSTER;
PImage Plant;

void setup() {
  size(displayWidth, displayHeight);
  lives = 20;
  score = 0;
  level = 4;
  wallU=false;
  wallD=false;
  wallR=false;
  wallL=false;

  p = new Player();
  Poster = loadImage("Poster.png");
  DRDPOSTER = loadImage("DRDPOSTER.png");
  Plant = loadImage("Plant.png");
  
  minim = new Minim(this); //initialized sound
  sound = minim.loadFile("song.mp3");
}

void draw() {
  background(255);
  sound.play();
  image(Poster, 0, 0, width, height);
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
  if (level==-2) {
    background(0);
  }
  if (level==-3) {
    background(0);
  }
  if (level==-4) {
    background(0);
  }
  if (level==-5) {
    background(0);
  }


  if (level==1) { // actual level
    background(#989898);
    fill(#BCBCBC);
    rect(0, 450, width, 250);
    fill(0);
    rect(0, 650, width, 500);
    rect(600, 0, 250, 60); 
    fill(#FFF700); 
    rect(0, 780, 130, 35); // yellow lines
    rect(260, 780, 130, 35); 
    rect(520, 780, 130, 35);
    rect(780, 780, 130, 35);
    rect(1040, 780, 130, 35);
    rect(1300, 780, 130, 35); 
    fill(255, 0, 200);
    rect(575, 0, 300, 200); //carpet

    fill(#E8E8E8);
    rect(600, 0, 250, 60); //elevator

    textMode(CENTER);
    fill(255, 0, 0);
    text("You are at the headquarters of your arch enemy Dr. Diabolical. Enter the building and find him", 500, 200, 500, 100); 
    fill(0);
    text("Elevator --->", 470, 20, 300, 300);

    image(Plant, 50, 50, 75, 75);
    image(Plant, width-125, 50, 75, 75);

    if (p.loc.x >= 600 && p.loc.x <= 850 && p.loc.y <= 60) {
      level = -2;
    }
  }

  if (level==2) { // actual level
    background(#989898);

    image(Plant, 50, 50, 75, 75);
    image(Plant, width-125, 50, 75, 75);
    image(Plant, 50, height-125, 75, 75);
    image(Plant, width-125, height-125, 75, 75);

    fill(#E8E8E8);
    rect(600, height-60, 250, 60); //elevator lv 2

    if (p.loc.x >= 600 && p.loc.x <= 850 && p.loc.y >= height-60) {
      level = -3;
    }
  }

  if (level==3) { // actual level
    background(#989898);


    fill(#E8E8E8);
    rect(600, 0, 250, 60); //elevator lv 3

    if (p.loc.x >= 600 && p.loc.x <= 850 && p.loc.y <= 60) {
      level = -4;
    }
  }

  if (level==4) { // actual level
    background(#989898);

    image(DRDPOSTER, 200, 200, 1050, 500);

    fill(#E8E8E8);
    rect(600, height-60, 250, 60); //elevator lv 2


    if (p.loc.x >= 600 && p.loc.x <= 850 && p.loc.y >= height-60) {
      level = -5;
    }
  }

  if (level==5) { // actual level
    background(#989898);

    if (frameCount%20==0) {
      bossbullets.add(new BossBullet(boss.loc.x, boss.loc.y, 32, PI/4, boss));
      bossbullets.add(new BossBullet(boss.loc.x, boss.loc.y, 36, PI/8, boss));
      bossbullets.add(new BossBullet(boss.loc.x, boss.loc.y, 40, 0, boss));
      bossbullets.add(new BossBullet(boss.loc.x, boss.loc.y, 36, -PI/4, boss));
      bossbullets.add(new BossBullet(boss.loc.x, boss.loc.y, 32, -PI/8, boss));
    }
    //rotation angle for enemies
    boss.display();
    boss.move();
    if (boss.contact(p)==true) { //when grunts hit Player, they disappear
      lives--;
    } 
    if (boss.hitList(bullets)==true) { //when bullets hit grunts, they disappear
      boss.lives-=3;
      score+=5;
      if (boss.lives <= 0) {
        score+=200;
        textSize(30);
        text("You Win", width/2-30, height/2-30, 120, 120);
        noLoop();
      }
    }
  }


  String Lives = "Lives: " + str(lives); //strings to be utilized in text
  String Score = "Score: " + str(score);

  textSize(20);
  text(Lives, 10, 10, 120, 120);
  text(Score, width-130, 10, 120, 120);


  if (p.hitList(bossbullets)==true) { //when bullets hit grunts, they disappear
    lives-=3;
  }

  for (int i = bullets.size () -1; i>=0; i--) { //forLoop to create bullets
    Bullet b = bullets.get(i);
    b.display();
    b.move();
    if (b.contactListBullet(walls)) {
      bullets.remove(i);
    }

    if (level==-1) { //when level changes all bullets are erased
      bullets.remove(i);
    }
    if (b.x<0 || b.x>width || b.y<0 || b.y>height) { //when bullet hits wall it disappears
      bullets.remove(i);
    }
  }

  for (int i = bossbullets.size () -1; i>=0; i--) { //forLoop to create bullets
    BossBullet a = bossbullets.get(i);
    a.display();
    a.move();
    
    if (a.contactListBBullet(walls)) {
      bossbullets.remove(i);
    }

    if (level==-1) { //when level changes all bullets are erased
      bossbullets.remove(i);
    }
    if (a.x<0 || a.x>width || a.y<0 || a.y>height) { //when bullet hits wall it disappears
      bossbullets.remove(i);
    }
  }

  for (int i = grunts.size () -1; i>=0; i--) { //forLoop to create grunts
    Grunt e = grunts.get(i);
    phi=atan2(p.loc.y-e.loc.y, p.loc.x-e.loc.x); //rotation angle for enemies
    e.display();
    e.move();
    if (e.contact(p)==true) { //when grunts hit Player, they disappear
      grunts.remove(i);
      lives-=2;
    } 
    if (e.hitList(bullets)==true) { //when bullets hit grunts, they disappear
      grunts.remove(i);
      score+=10;
    }
  }






  for (int i = walls.size () -1; i>=0; i--) { //forLoop to create walls
    Wall w = walls.get(i);
    w.display();
    //check walls only if  not already touching a wall
    if (!wallU && !wallD && !wallR && !wallL) {
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
    if (level==-1 || level==-2 || level ==-3 || level ==-4 || level ==-5) { //when bullets hit grunts, they disappear
      walls.remove(i);
    }
  }

  p.display();   //PLAYER JUNK
  p.move();

  wallU = false;
  wallD = false;
  wallR = false;
  wallL = false;

  if (level == -1) { //objects to be loaded in the preparation level
    grunts.add(new Grunt(625, 100, 0, 0, 50, 350));
    grunts.add(new Grunt(700, 100, 0, 0, 50, 350));
    grunts.add(new Grunt(775, 100, 0, 0, 50, 350));
    walls.add(new Wall(0, 400, width/2-50, 50));
    walls.add(new Wall(width/2+50, 400, width, 50));

    p.loc.y=height-200; //new player positions
    p.loc.x=width-200;
    level = 1; //transition to actual level
  }

  if (level == -2) { //objects to be loaded in the preparation level\
    grunts.add(new Grunt(420, 300, 0, 0, 50, 300));
    grunts.add(new Grunt(width-420, 300, 0, 0, 50, 300));
    grunts.add(new Grunt(620, 300, 0, 0, 50, 200));
    grunts.add(new Grunt(width-620, 300, 0, 0, 50, 200));
    grunts.add(new Grunt(220, 300, 0, 0, 50, 450));
    grunts.add(new Grunt(width-220, 300, 0, 0, 50, 450));

    grunts.add(new Grunt(420, 500, 0, 0, 50, 300));
    grunts.add(new Grunt(width-420, 500, 0, 0, 50, 300));
    grunts.add(new Grunt(620, 500, 0, 0, 50, 200));
    grunts.add(new Grunt(width-620, 500, 0, 0, 50, 200));
    grunts.add(new Grunt(220, 500, 0, 0, 50, 450));
    grunts.add(new Grunt(width-220, 500, 0, 0, 50, 450));

    grunts.add(new Grunt(420, 700, 0, 0, 50, 300));
    grunts.add(new Grunt(width-420, 700, 0, 0, 50, 300));
    grunts.add(new Grunt(620, 700, 0, 0, 50, 200));
    grunts.add(new Grunt(width-620, 700, 0, 0, 50, 200));
    grunts.add(new Grunt(220, 700, 0, 0, 50, 450));
    grunts.add(new Grunt(width-220, 700, 0, 0, 50, 450));

    walls.add(new Wall(150, 150, width/2-200, 50));
    walls.add(new Wall(width/2+50, 150, width/2-200, 50));

    walls.add(new Wall(150, 350, width/2-200, 50));
    walls.add(new Wall(width/2+50, 350, width/2-200, 50));

    walls.add(new Wall(150, 550, width/2-200, 50));
    walls.add(new Wall(width/2+50, 550, width/2-200, 50));
    level = 2; //transition to actual level
  }

  if (level == -3) { //objects to be loaded in the preparation level

    for (int i = 0; i<=7; i++) {
      walls.add(new Wall(75 + 200*i, 120, 90, 90));
    }
    for (int i = 0; i<=7; i++) {
      walls.add(new Wall(75 + 200*i, 320, 90, 90));
    }
    for (int i = 0; i<=7; i++) {
      walls.add(new Wall(75 + 200*i, 520, 90, 90));
    }
    for (int i = 0; i<3; i++) {
      walls.add(new Wall(75 + 200*i, 720, 90, 90));
    }
    for (int i = 4; i<=7; i++) {
      walls.add(new Wall(75 + 200*i, 720, 90, 90));
    }


    for (int i = 0; i<=5; i++) {
      grunts.add(new Grunt(220 + 200*i, 165, 0, 0, 50, 250));
    }
    for (int i = 0; i<=5; i++) {
      grunts.add(new Grunt(220 + 200*i, 365, 0, 0, 50, 250));
    }
    for (int i = 0; i<=5; i++) {
      grunts.add(new Grunt(220 + 200*i, 565, 0, 0, 50, 250));
    }
    for (int i = 0; i<=1; i++) {
      grunts.add(new Grunt(220 + 200*i, 765, 0, 0, 50, 250));
    }
    for (int i = 4; i<=5; i++) {
      grunts.add(new Grunt(220 + 200*i, 765, 0, 0, 50, 250));
    }
    level = 3;
  }

  if (level == -4) { //objects to be loaded in the preparation level

    walls.add(new Wall(width-width+100, height-height+100, 100, 700));
    walls.add(new Wall(200, 100, 1150, 100));
    walls.add(new Wall(1250, height-height+100, 100, 700));
    walls.add(new Wall(width-width+100, 700, 1250, 100));

    grunts.add(new Grunt(50, 100, 0, 0, 50, 250));
    grunts.add(new Grunt(50, 200, 0, 0, 50, 350));
    grunts.add(new Grunt(50, 300, 0, 0, 50, 450));
    grunts.add(new Grunt(50, 400, 0, 0, 50, 550));
    grunts.add(new Grunt(50, 500, 0, 0, 50, 650));
    grunts.add(new Grunt(50, 600, 0, 0, 50, 750));
    grunts.add(new Grunt(50, 700, 0, 0, 50, 850));
    grunts.add(new Grunt(50, 800, 0, 0, 50, 950));

    grunts.add(new Grunt(width-50, 100, 0, 0, 50, 250));
    grunts.add(new Grunt(width-50, 200, 0, 0, 50, 350));
    grunts.add(new Grunt(width-50, 300, 0, 0, 50, 450));
    grunts.add(new Grunt(width-50, 400, 0, 0, 50, 550));
    grunts.add(new Grunt(width-50, 500, 0, 0, 50, 650));
    grunts.add(new Grunt(width-50, 600, 0, 0, 50, 750));
    grunts.add(new Grunt(width-50, 700, 0, 0, 50, 850));
    grunts.add(new Grunt(width-50, 800, 0, 0, 50, 950));

    level = 4; //transition to actual level
  }

  if (level == -5) { //objects to be loaded in the preparation level
    boss = new Boss(width/2, height/20, 0, 0, 50, 950, 200);
    walls.add(new Wall(150,100,200,50));
    walls.add(new Wall(100,150,50,200));
    level = 5; //transition to actual level
  }

  if (lives<=0) { //Game over 
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

