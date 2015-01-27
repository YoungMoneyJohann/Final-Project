import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.spi.*; 
import ddf.minim.signals.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.ugens.*; 
import ddf.minim.effects.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class GunmanZ extends PApplet {

 //minim






Minim minim; //variables for sound
AudioPlayer MainSong;
AudioPlayer IntroSong;
AudioPlayer pShot;
AudioPlayer Ding;
AudioPlayer Hboost;
AudioPlayer FinalSong;

ArrayList<Bullet> bullets = new ArrayList<Bullet>(); //arraylists
ArrayList<Grunt> grunts = new ArrayList<Grunt>();
ArrayList<Wall> walls = new ArrayList<Wall>();
ArrayList<Boss> bosses = new ArrayList<Boss>();
ArrayList<BossBullet> bossbullets = new ArrayList<BossBullet>();
ArrayList<BossBullet2> bossbullet2s = new ArrayList<BossBullet2>();
ArrayList<EnemyBullet> enemybullets = new ArrayList<EnemyBullet>();
ArrayList<Grunt2> grunt2s = new ArrayList<Grunt2>();
ArrayList<Health> healths = new ArrayList<Health>();
ArrayList<Info> infos = new ArrayList<Info>();

Player p; //player and boss
Boss boss;
int score;

int count; //count for boss attack switch

int level;

int scale = 40; //scale for tile flooring
int cols, rows; //ints used for tile flooring

float theta; //Rotation Angle for Player
float phi; //Rotation Angle for Grunt and other Enemies
float phi2; //Rotation Angle for Grunt and other Enemies

boolean wallU; //Wall contact booleans (see wall class)
boolean wallD;
boolean wallR;
boolean wallL;

boolean End; //when game over or win

boolean InstructionsOpen;
boolean InstructionsClosed;

boolean keys[] = new boolean[255]; //Multiple key input boolean

PImage Poster; //images
PImage DRDPOSTER;
PImage Plant;
PImage Floor;
PImage ElectroBall1;
PImage ElectroBall2;
PImage ElectroBall3;
PImage Elevator1;
PImage Elevator1R;
PImage Elevator2;
PImage Elevator2R;
PImage Elevator3;
PImage Elevator3R;
PImage Elevator4;
PImage Elevator4R;
PImage Elevator5;
PImage Elevator5R;
PImage ElevatorB;
PImage ElevatorBR;
PImage ElevatorBoss1;
PImage ElevatorBoss2;
PImage vfwall1;
PImage vfwall2;
PImage vfwall3;
PImage hfwall1;
PImage hfwall2;
PImage hfwall3;
PImage Graf;

public void setup() {
  size(displayWidth, displayHeight);
  score = 0;
  level = 0;
  count = 0;

  cols = width/scale;
  rows = height/scale;

  //  wallU=false;
  //  wallD=false;
  //  wallR=false;
  //  wallL=false;

  p = new Player();
  Poster = loadImage("Poster.png"); //loaded images
  DRDPOSTER = loadImage("DRDPOSTER.png");
  Plant = loadImage("Plant.png");
  ElectroBall1 = loadImage("EL1.png");
  ElectroBall2 = loadImage("EL2.png");
  ElectroBall3 = loadImage("EL3.png");
  Elevator1 = loadImage("Elevator1.png");
  Elevator1R = loadImage("Elevator1R.png");
  Elevator2 = loadImage("Elevator2.png");
  Elevator2R = loadImage("Elevator2R.png");
  Elevator3 = loadImage("Elevator3.png");
  Elevator3R = loadImage("Elevator3R.png");
  Elevator4 = loadImage("Elevator4.png");
  Elevator4R = loadImage("Elevator4R.png");
  Elevator5 = loadImage("Elevator5.png");
  Elevator5R = loadImage("Elevator5R.png");
  ElevatorB = loadImage("ElevatorB.png");
  ElevatorBR = loadImage("ElevatorBR.png");
  ElevatorBoss1 = loadImage("ElevatorBoss1.png");
  ElevatorBoss2 = loadImage("ElevatorBoss2.png");
  vfwall1 = loadImage("vfwall1.png");
  vfwall2 = loadImage("vfwall2.png");
  vfwall3 = loadImage("vfwall3.png");
  hfwall1 = loadImage("hfwall1.png");
  hfwall2 = loadImage("hfwall2.png");
  hfwall3 = loadImage("hfwall3.png");
  Graf = loadImage("Graf.png");


  minim = new Minim(this); //initialized sound
  IntroSong = minim.loadFile("Beat2.mp3");
  MainSong = minim.loadFile("song2.mp3");
  pShot = minim.loadFile("pshot2.mp3");
  Ding = minim.loadFile("Ding.mp3");
  Hboost = minim.loadFile("Hboost.mp3");
  FinalSong = minim.loadFile("FinalSong.mp3");

  End = false;
}

public void draw() {
  background(255);
  noCursor();

  image(Poster, 0, 0, width, height); //background
  if (level==0) { //initial level or starting screen
    IntroSong.play();
    fill(0, 255, 0, 100);
    rectMode(CENTER);
    rect(.4283f*width, .234f*height, .129f*width, .072f*height);
    fill(0xffFF9900, 175);
    rect(.4f*width, .93f*height, .2f*width, .072f*height);
    rectMode(CORNER);
    fill(0);
    textSize(42);
    fill(40, 40, 255, 220);
    text("Start", .4283f*width-50, .234f*height-25, .22f*width, .456f*height);
    fill(0);
    text("Instructions", .4f*width-120, .93f*height-25, .22f*width, .456f*height); //start button
    noFill();


    if (mousePressed && mouseX<.4283f*width+.129f*width/2 && mouseX>.4283f*width-.129f*width/2
      && mouseY>.234f*height-.072f*height/2 && mouseY<.234f*height+.072f*height/2) { // button function
      level=-1;
      IntroSong.close();
      IntroSong = minim.loadFile("Beat2.mp3");
      MainSong.play();
    }

    if (mousePressed && mouseX<.4f*width+.2f*width/2 && mouseX>.4f*width-.2f*width/2
      && mouseY>.93f*height-.072f*height/2 && mouseY<.93f*height+.072f*height/2) { // button function
      InstructionsOpen = true;
    }
  }



  if (level==-1) { //loading/preperation levels (they have '-' signs)
    p.loc.y=height-200; //new player positions
    p.loc.x=width-200;
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
    background(0xff989898);

    for (int i = 0; i < cols; i++) { //tile flooring
      for (int j = 0; j < rows; j++) { 
        int x = i*2*scale;
        int y = j*2*scale;
        fill(0xff6CC2E3, 50);
        noStroke();
        rect(x, y, scale, scale); 
        rect(x+scale, y+scale, scale, scale);
        stroke(0);
      }
    }

    fill(0xffBCBCBC);
    rect(0, .5f*height, width, .278f*height);
    fill(0);
    rect(0, .722f*height, width, .555f*height);

    fill(0xffFFF700); 
    rect(0, .867f*height, .0903f*width, .0389f*height); // yellow lines
    rect(.181f*width, .867f*height, .0903f*width, .0389f*height); 
    rect(.361f*width, .867f*height, .0903f*width, .0389f*height);
    rect(.542f*width, .867f*height, .0903f*width, .0389f*height);
    rect(.722f*width, .867f*height, .0903f*width, .0389f*height);
    rect(.903f*width, .867f*height, .0903f*width, .0389f*height); 
    fill(0xffA7815A);
    rect(.4f*width, 0, .208f*width, .222f*height); //carpet

      image(Elevator1, .417f*width, 0, .174f*width, .067f*height);

    image(Plant, .035f*width, .056f*height, .052f*width, .083f*height);
    image(Plant, .913f*width, .056f*height, .052f*width, .083f*height);


    if (p.loc.x >= .417f*width && p.loc.x <= .59f*width && p.loc.y <= .067f*height) { //elevator function
      level = -2;
      p.loc.y = .089f*height;
      p.loc.x = .503f*width;
      Ding.play();
      Ding = minim.loadFile("Ding.mp3");
    }
  }

  if (level==2) { // actual level
    background(0xff989898);

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) { 
        int x = i*2*scale;
        int y = j*2*scale;
        fill(0xff21FF00, 50);
        noStroke();
        rect(x, y, scale, scale); 
        rect(x+scale, y+scale, scale, scale);
        stroke(0);
      }
    }

    image(Plant, 50, 50, 75, 75);
    image(Plant, width-125, 50, 75, 75);
    image(Plant, 50, height-125, 75, 75);
    image(Plant, width-125, height-125, 75, 75);

    image(Elevator2R, .417f*width, .933f*height, .174f*width, .067f*height);

    image(ElevatorB, .417f*width, 0, .174f*width, .067f*height);

    if (p.loc.x >= .417f*width && p.loc.x <= .59f*width && p.loc.y >= .933f*height) {
      level = -3;
      p.loc.y = .911f*height;
      p.loc.x = .503f*width;
      Ding.play(); //elevator sound
      Ding = minim.loadFile("Ding.mp3");
    }
  }

  if (level==3) { // actual level
    background(0xff989898);

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) { 
        int x = i*2*scale;
        int y = j*2*scale;
        fill(0xffFF8400, 50);
        noStroke();
        rect(x, y, scale, scale); 
        rect(x+scale, y+scale, scale, scale);
        stroke(0);
      }
    }

    image(Elevator1R, .417f*width, .933f*height, .174f*width, .067f*height);

    image(Elevator3, .417f*width, 0, .174f*width, .067f*height);

    if (p.loc.x >= .417f*width && p.loc.x <= .59f*width && p.loc.y <= .067f*height) {
      level = -4;
      p.loc.y = .089f*height;
      p.loc.x = .503f*width;
      Ding.play();
      Ding = minim.loadFile("Ding.mp3");
    }
  }

  if (level==4) { // actual level
    background(0xff989898);

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) { 
        int x = i*2*scale;
        int y = j*2*scale;
        fill(0xff9400FF, 50);
        noStroke();
        rect(x, y, scale, scale); 
        rect(x+scale, y+scale, scale, scale);
        stroke(0);
      }
    }

    image(DRDPOSTER, .139f*width, .222f*height, .729f*width, .555f*height); //poster

    image(Elevator2, .417f*width, 0, .174f*width, .067f*height);
    image(Elevator4R, .417f*width, .933f*height, .174f*width, .067f*height);


    if (p.loc.x >= 600 && p.loc.x <= .59f*width && p.loc.y >= .933f*height) {
      level = -5;
      p.loc.y = .911f*height;
      p.loc.x = .503f*width;
      Ding.play();
      Ding = minim.loadFile("Ding.mp3");
    }
  }

  if (level==5) {
    background(0xff989898);
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) { 
        int x = i*2*scale;
        int y = j*2*scale;
        fill(0xffA56117, 50);
        noStroke();
        rect(x, y, scale, scale); 
        rect(x+scale, y+scale, scale, scale);
        stroke(0);
      }
    }

    image(Elevator5, .417f*width, 0, .174f*width, .067f*height);
    image(Elevator3R, .417f*width, .933f*height, .174f*width, .067f*height);

    if (p.loc.x >= .417f*width && p.loc.x <= .59f*width && p.loc.y <= .067f*height) {
      level = -6;
      p.loc.y = .089f*height;
      p.loc.x = .503f*width;
      Ding.play();
      Ding = minim.loadFile("Ding.mp3");
    }
  }

  if (level==6) {
    background(0xff7C7C7C);
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) { 
        int x = i*2*scale;
        int y = j*2*scale;
        fill(0xffFF0000, 50);
        noStroke();
        rect(x, y, scale, scale); 
        rect(x+scale, y+scale, scale, scale);
        stroke(0);
      }
    }
    if (frameCount%12 <6) { //animation
      image(ElevatorBoss1, .417f*width, .933f*height, .174f*width, .067f*height);
    } else if (frameCount%12 >=6) {
      image(ElevatorBoss1, .417f*width, .933f*height, .174f*width, .067f*height);
    } 

    image(Elevator4, .417f*width, 0, .174f*width, .067f*height);

    if (p.loc.x >= 600 && p.loc.x <= .59f*width && p.loc.y >= .933f*height) {
      level = -7;
      p.loc.y = .911f*height;
      p.loc.x = .503f*width;
      Ding.play();
      Ding = minim.loadFile("Ding.mp3");
    }
  }

  if (level==7) { // actual level
    background(0xff7C7C7C);
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) { 
        int x = i*2*scale;
        int y = j*2*scale;
        fill(0xffFF0000, 50);
        noStroke();
        rect(x, y, scale, scale); 
        rect(x+scale, y+scale, scale, scale);
        stroke(0);
      }
      if (frameCount%12 <6) {
        image(ElevatorBoss1, .417f*width, .933f*height, .174f*width, .067f*height);
      } else if (frameCount%12 >=6) {
        image(ElevatorBoss1, .417f*width, .933f*height, .174f*width, .067f*height);
      }
    }

    MainSong.close();
    FinalSong.play();

    imageMode(CENTER);
    image(Graf, width/2, height/2, 758.5f, 123); //image (says "Dr D Baby")
    imageMode(CORNER);

    if (frameCount%20==0 && count <= 9) { //boss attack switching
      bossbullets.add(new BossBullet(boss.loc.x, boss.loc.y, 32, PI/4, boss));
      bossbullets.add(new BossBullet(boss.loc.x, boss.loc.y, 36, PI/8, boss));
      bossbullets.add(new BossBullet(boss.loc.x, boss.loc.y, 40, 0, boss));
      bossbullets.add(new BossBullet(boss.loc.x, boss.loc.y, 36, -PI/4, boss));
      bossbullets.add(new BossBullet(boss.loc.x, boss.loc.y, 32, -PI/8, boss));
      count++;
    }
    if (frameCount%1==0 && count > 9 && count <=99) {
      bossbullet2s.add(new BossBullet2(boss.loc.x, boss.loc.y, 20, 15, random(-.22f, .22f), boss));
      count++;
    }
    if (count == 100) {
      count = 0;
    }

    if (boss.contact(p)==true) { //when boss is contacted
      p.lives--;
    } 
    if (boss.hitList(bullets)==true) { 
      boss.lives-=2;
      score+=5;
      if (boss.lives <= 0) {
        score+=200;
        fill(0xff0074BF, 225);
        rectMode(CENTER);
        rect(width/2, height/2, 350, 150);
        rectMode(CORNER);
        textSize(60);
        fill(0, 255); // when boss is defeated
        textAlign(CENTER, CENTER);
        text("You Win!", width/2, height/2);
        textAlign(CORNER);
        End=true;
        noLoop();
      }
    }
  }


  String Lives = "Lives: " + str(p.lives); //strings to be utilized in text 
  String Score = "Score: " + str(score);


  fill(255);

  textSize(20);
  text(Lives, 10, 10, 120, 120);
  text(Score, width-130, 10, 120, 120);


  if (p.hitList(bossbullets)==true) { //when player is contacted
    p.lives-=8;
  }
  if (p.ehitList(enemybullets)==true) { 
    p.lives-=4;
  }
  if (p.hit2List(bossbullet2s)==true) {
    p.lives-=3;
  }

  for (int i = bullets.size () -1; i>=0; i--) { //forLoop to create bullets
    Bullet b = bullets.get(i);
    b.display();
    b.move();
    if (b.contactListBullet(walls)) {
      bullets.remove(i);
    } else if (level==-1) { //when level changes all bullets are erased
      bullets.remove(i);
    } else if (b.x<0 || b.x>width || b.y<0 || b.y>height) { //when bullet hits wall it disappears
      bullets.remove(i);
    }
  }

  for (int i = bossbullets.size () -1; i>=0; i--) { //forLoop to create bossbullets
    BossBullet bb = bossbullets.get(i);
    bb.display();
    bb.move();

    if (bb.contactListBBullet(walls)) {
      bossbullets.remove(i);
    } else if (level==-1) { //when level changes all bossbullets are erased
      bossbullets.remove(i);
    } else if (bb.x<0 || bb.x>width || bb.y<0 || bb.y>height) { //when bossbullet hits wall it disappears
      bossbullets.remove(i);
    }
  }
  for (int i = bossbullet2s.size () -1; i>=0; i--) { //forLoop to create bossbullets2
    BossBullet2 bb2 = bossbullet2s.get(i);
    bb2.display(boss);
    bb2.move();

    if (bb2.contactListB2Bullet(walls)) {
      bossbullet2s.remove(i);
    } else if (level==-1) { //when level changes all bossbullets2 are erased
      bossbullet2s.remove(i);
    } else if (bb2.x<0 || bb2.x>width || bb2.y<0 || bb2.y>height) { //when bossbullet2 hits wall it disappears
      bossbullet2s.remove(i);
    }
  }

  for (int i = enemybullets.size () -1; i>=0; i--) { //forLoop to create enemybullets
    EnemyBullet eb = enemybullets.get(i);
    eb.display();
    eb.move();

    if (eb.contactListEBullet(walls)) {
      enemybullets.remove(i);
    } else if (level==-1 || level==-2 || level ==-3 || level ==-4 || level ==-5 || level ==-6 || level ==-7) { //when level changes all bullets are erased
      enemybullets.remove(i);
    } else if (eb.x<0 || eb.x>width || eb.y<0 || eb.y>height) { //when enemybullet hits wall it disappears
      enemybullets.remove(i);
    }
  }


  for (int i = grunts.size () -1; i>=0; i--) { //forLoop to create grunts
    Grunt e = grunts.get(i);
    phi=atan2(p.loc.y-e.loc.y, p.loc.x-e.loc.x); //rotation angle for enemies
    e.display();
    if (level==-1 || level==-2 || level ==-3 || level ==-4 || level ==-5 || level ==-6 || level ==-7) { //when bullets hit grunts, they disappear
      grunts.remove(i);
    }
    if (e.contact(p)==true) { //when grunts hit Player, they disappear
      grunts.remove(i);
      p.lives-=7;
    } 
    if (e.hitList(bullets)==true) { //when bullets hit grunts, they disappear
      grunts.remove(i);
      score+=10;
    }

    PVector dir = new PVector(e.loc.x - p.loc.x, e.loc.y - p.loc.y); //wall sliding fixer

    for (Wall w : walls) //wall stopping
    {
      if (e.contactGruntRight(w) && dir.x <= 0)
      {         
        e.wallRg = true;
      } else if (e.contactGruntLeft(w) && dir.x >= 0)
      {
        e.wallLg = true;
      }

      if (e.contactGruntUp(w) && dir.y >= 0)
      {
        e.wallUg = true;
      } else if (e.contactGruntDown(w) && dir.y <= 0)
      {
        e.wallDg = true;
      }
    }

    e.move();
  }
  for (int i = grunt2s.size () -1; i>=0; i--) { //forLoop to create grunts
    Grunt2 e2 = grunt2s.get(i);
    phi2=atan2(p.loc.y-e2.loc.y, p.loc.x-e2.loc.x); //rotation angle for enemies
    e2.display();

    if (level==-1 || level==-2 || level ==-3 || level ==-4 || level ==-5 || level ==-6 || level ==-7) { //when bullets hit grunts, they disappear
      grunt2s.remove(i);
    } else if (e2.contact(p)==true) { //when grunts hit Player, they disappear
      grunt2s.remove(i);
      p.lives-=7;
    } else if (e2.hitList(bullets)==true) { //when bullets hit grunts, they disappear
      grunt2s.remove(i);
      score+=15;
    }
    if (e2.shoot(p)) {
      if (frameCount%30==0) {
        enemybullets.add(new EnemyBullet(e2.loc.x, e2.loc.y, 8, 0, e2));
      }
    }
    PVector dir = new PVector(e2.loc.x - p.loc.x, e2.loc.y - p.loc.y); //wall sliding fixer
    for (Wall w : walls) //wall stopping
    {
      if (e2.contactGruntRight(w) && dir.x <= 0)
      {         
        e2.wallRg = true;
      } else if (e2.contactGruntLeft(w) && dir.x >= 0)
      {
        e2.wallLg = true;
      }

      if (e2.contactGruntUp(w) && dir.y >= 0)
      {
        e2.wallUg = true;
      } else if (e2.contactGruntDown(w) && dir.y <= 0)
      {
        e2.wallDg = true;
      }
    }
    e2.move();
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
    if (level==-1 || level==-2 || level ==-3 || level ==-4 || level ==-5 || level ==-6 || level ==-7) { 
      walls.remove(i);
    }
  }

  for (int i = healths.size () -1; i>=0; i--) { //health box forLoop
    Health h = healths.get(i);
    h.display();
    if (h.contactPlayer(p)) {
      healths.remove(i);
      Hboost.play();
      Hboost = minim.loadFile("Hboost.mp3");
      if (p.lives<=100-h.lives) {
        p.lives+=h.lives;
      }
      if (p.lives>100-h.lives) {
        p.lives=100;
      }
    }
    if (level==-1 || level==-2 || level ==-3 || level ==-4 || level ==-5 || level ==-6 || level ==-7) { //when bullets hit grunts, they disappear
      healths.remove(i);
    }
  }

  for (int j = infos.size () -1; j>=0; j--) { //info forLoop
    Info z = infos.get(j);
    z.display();
    if (level==-1 || level==-2 || level ==-3 || level ==-4 || level ==-5 || level ==-6 || level ==-7) { //when bullets hit grunts, they disappear
      infos.remove(j);
    }
  }

  p.move(); //player move

    wallU = false; //player wall booleans set to false if there is no player wall interaction
  wallD = false;
  wallR = false;
  wallL = false;

  if (level == -1) { //objects to be loaded in the preparation level
    grunts.add(new Grunt(.454f*width, .111f*height, 0, 0, 50, 350));
    grunt2s.add(new Grunt2(.506f*width, .111f*height, 0, 0, 50, 350, 500));
    grunts.add(new Grunt(.558f*width, .111f*height, 0, 0, 50, 350));
    walls.add(new Wall(0, .444f*height, .465f*width, .056f*height, 200, 200, 200, 255, 255));
    walls.add(new Wall(.535f*width, .444f*height, width, .056f*height, 200, 200, 200, 255, 255));

    infos.add(new Info(.84f*width, .447f*height, "   Your archenemy, Dr. Diabolical, has kidnapped your girlfriend again!! You need to enter his headquarters, defeat him and his robot minions, and resque her! First, defeat his 3 guards and enter the elevator to go to the next floor.", 40, 30));

    level = 1; //transition to actual level
  }

  if (level == -2) { //objects to be loaded in the preparation level\
    grunt2s.add(new Grunt2(.292f*width, .333f*height, 0, 0, 50, 300, 325));
    grunt2s.add(new Grunt2(.708f*width, .333f*height, 0, 0, 50, 300, 325));
    grunts.add(new Grunt(.431f*width, .333f*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.569f*width, .333f*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.153f*width, .333f*height, 0, 0, 50, 450));
    grunts.add(new Grunt(.847f*width, .333f*height, 0, 0, 50, 450));

    grunt2s.add(new Grunt2(.292f*width, .555f*height, 0, 0, 50, 300, 325));
    grunt2s.add(new Grunt2(.708f*width, .555f*height, 0, 0, 50, 300, 325));
    grunts.add(new Grunt(.431f*width, .555f*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.569f*width, .555f*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.153f*width, .555f*height, 0, 0, 50, 450));
    grunts.add(new Grunt(.847f*width, .555f*height, 0, 0, 50, 450));

    grunt2s.add(new Grunt2(.292f*width, .778f*height, 0, 0, 50, 300, 325));
    grunt2s.add(new Grunt2(.708f*width, .778f*height, 0, 0, 50, 300, 325));
    grunts.add(new Grunt(.431f*width, .778f*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.569f*width, .778f*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.153f*width, .778f*height, 0, 0, 50, 450));
    grunts.add(new Grunt(.847f*width, .778f*height, 0, 0, 50, 450));

    walls.add(new Wall(.1042f*width, .167f*height, .361f*width, .056f*height, 191, 138, 73, 255, 255));
    walls.add(new Wall(.535f*width, .167f*height, .361f*width, .056f*height, 191, 138, 73, 255, 255));

    walls.add(new Wall(.1042f*width, .389f*height, .361f*width, .056f*height, 191, 138, 73, 255, 255));
    walls.add(new Wall(.535f*width, .389f*height, .361f*width, .056f*height, 191, 138, 73, 255, 255));

    walls.add(new Wall(.1042f*width, .611f*height, .361f*width, .056f*height, 191, 138, 73, 255, 255));
    walls.add(new Wall(.535f*width, .611f*height, .361f*width, .056f*height, 191, 138, 73, 255, 255));

    healths.add(new Health(.92f*width, .7f*height, 10, 40));
    infos.add(new Info(.92f*width, .62f*height, "   Bellow here is a health box. There are a few of them in Dr. D's HQ and each one will heal you for a different amount. To use it, simply interact or touch the center of the box.", 40, 30));
    infos.add(new Info(.36f*width, .043f*height, "   There are two kinds of robots: Chargers, which are fast and ram into you before self-destructing, and Blasters, which are Chargers that have less speed but can fire energy blasts. Defeat these guys and go to the next floor!", 40, 30));
    level = 2; //transition to actual level
  }

  if (level == -3) { //objects to be loaded in the preparation level

    for (int i = 0; i<=7; i++) {
      walls.add(new Wall(.052f*width + .139f*width*i, .133f*height, .063f*width, .1f*height, 200, 200, 200, 255, 255));
    }
    for (int i = 0; i<=7; i++) {
      walls.add(new Wall(.052f*width + .139f*width*i, .355f*height, .063f*width, .1f*height, 200, 200, 200, 255, 255));
    }
    for (int i = 0; i<=7; i++) {
      walls.add(new Wall(.052f*width + .139f*width*i, .577f*height, .063f*width, .1f*height, 200, 200, 200, 255, 255));
    }
    for (int i = 0; i<3; i++) {
      walls.add(new Wall(.052f*width + .139f*width*i, .8f*height, .063f*width, .1f*height, 200, 200, 200, 255, 255));
    }
    for (int i = 4; i<=7; i++) {
      walls.add(new Wall(.052f*width + .139f*width*i, .8f*height, .063f*width, .1f*height, 200, 200, 200, 255, 255));
    }


    for (int i = 0; i<=5; i++) {
      grunts.add(new Grunt(.1528f*width + .139f*width*i, .1833f*height, 0, 0, 50, 520));
    }
    for (int i = 0; i<=5; i++) {
      grunt2s.add(new Grunt2(.1528f*width + .139f*width*i, .406f*height, 0, 0, 50, 250, 600));
    }
    for (int i = 0; i<=5; i++) {
      grunts.add(new Grunt(.1528f*width + .139f*width*i, .628f*height, 0, 0, 50, 250));
    }
    for (int i = 0; i<=1; i++) {
      grunts.add(new Grunt(.1528f*width + .139f*width*i, .85f*height, 0, 0, 50, 250));
    }
    for (int i = 4; i<=5; i++) {
      grunts.add(new Grunt(.1528f*width + .139f*width*i, .85f*height, 0, 0, 50, 250));
    }
    level = 3;
  }

  if (level == -4) { //objects to be loaded in the preparation level

    walls.add(new Wall(.0694f*width, .111f*height, .0694f*width, .777f*height, 200, 200, 200, 255, 255));
    walls.add(new Wall(.139f*width, .111f*height, .799f*width, .111f*height, 200, 200, 200, 255, 255));
    walls.add(new Wall(.868f*width, .111f*height, .0694f*width, .777f*height, 200, 200, 200, 255, 255));
    walls.add(new Wall(.0694f*width, .777f*height, .868f*width, .111f*height, 200, 200, 200, 255, 255));
    walls.add(new Wall(.45f*width, .888f*height, .1f*width, .045f*height, 200, 200, 200, 255, 255));

    for (int i = 0; i<5; i++) { //enemys will be stacked on top of each other
      grunts.add(new Grunt(.0347f*width, .111f*height, 0, 0, 50, 20));
      grunts.add(new Grunt(.0347f*width, .222f*height, 0, 0, 50, 20));
      grunts.add(new Grunt(.0347f*width, .333f*height, 0, 0, 50, 20));
      grunts.add(new Grunt(.0347f*width, .444f*height, 0, 0, 50, 20));
    }
    grunt2s.add(new Grunt2(.0347f*width, .555f*height, 0, 0, 50, 400, 800));
    grunt2s.add(new Grunt2(.0347f*width, .666f*height, 0, 0, 50, 400, 900));
    grunt2s.add(new Grunt2(.0347f*width, .777f*height, 0, 0, 50, 400, 900));
    grunt2s.add(new Grunt2(.0347f*width, .888f*height, 0, 0, 50, 400, 900));
    for (int i = 0; i<5; i++) {
      grunts.add(new Grunt(.965f*width, .111f*height, 0, 0, 50, 20));
      grunts.add(new Grunt(.965f*width, .222f*height, 0, 0, 50, 20));
      grunts.add(new Grunt(.965f*width, .333f*height, 0, 0, 50, 20));
      grunts.add(new Grunt(.965f*width, .444f*height, 0, 0, 50, 20));
    }
    grunt2s.add(new Grunt2(.965f*width, .555f*height, 0, 0, 50, 400, 800));
    grunt2s.add(new Grunt2(.965f*width, .666f*height, 0, 0, 50, 400, 900));
    grunt2s.add(new Grunt2(.965f*width, .777f*height, 0, 0, 50, 400, 900));
    grunt2s.add(new Grunt2(.965f*width, .888f*height, 0, 0, 50, 400, 900));

    healths.add(new Health(.6585f*width, .925f*height, 3, 40));
    healths.add(new Health(.35f*width, .925f*height, 10, 40));
    healths.add(new Health(.63f*width, .925f*height, 2, 40));
    
    infos.add(new Info(.37f*width, .035f*height, "   Be carefull, Dr. D is using broken Chargers as shields for the Blasters. There may seem like there are only 4 on each side, but each one actually is a stack of 4! Do not to touch them, their self-destruct function still works and you will take serious damage.", 40, 30));

    level = 4; //transition to actual level
  }

  if (level == -7) { //objects to be loaded in the preparation level
    boss = new Boss(width/2, height/20, 0, 0, 50, 950, 200);
    walls.add(new Wall(.104f*width, .111f*height, .139f*width, .056f*height, 200, 200, 200, 255, 255));
    walls.add(new Wall( .069f*width, .167f*height, .035f*width, .222f*height, 200, 200, 200, 255, 255));

    walls.add(new Wall(.104f*width, .833f*height, .139f*width, .056f*height, 200, 200, 200, 255, 255));
    walls.add(new Wall( .069f*width, .611f*height, .035f*width, .222f*height, 200, 200, 200, 255, 255));

    walls.add(new Wall(.757f*width, .111f*height, .139f*width, .056f*height, 200, 200, 200, 255, 255));
    walls.add(new Wall( .896f*width, .167f*height, .035f*width, .222f*height, 200, 200, 200, 255, 255));

    walls.add(new Wall(.757f*width, .833f*height, .139f*width, .056f*height, 200, 200, 200, 255, 255));
    walls.add(new Wall( .896f*width, .611f*height, .035f*width, .222f*height, 200, 200, 200, 255, 255));
    level = 7; //transition to actual level
  }

  if (level == -5) {
    walls.add(new Wall(0, .2f*height, .25f*width, .1f*height, 200, 200, 200, 0, 0));
    walls.add(new Wall(.45f*width, .2f*height, .2f*width, .1f*height, 200, 200, 200, 0, 0));
    walls.add(new Wall(.65f*width, .2f*height, .35f*width, .1f*height, 200, 200, 200, 0, 0));
    walls.add(new Wall(.2f*width, .4f*height, .15f*width, .1f*height, 200, 200, 200, 0, 0));
    walls.add(new Wall(.35f*width, .4f*height, .3f*width, .1f*height, 200, 200, 200, 0, 0));
    walls.add(new Wall(.75f*width, .4f*height, .1f*width, .1f*height, 200, 200, 200, 0, 0));
    walls.add(new Wall(0, .6f*height, .25f*width, .1f*height, 200, 200, 200, 0, 0));
    walls.add(new Wall(.45f*width, .6f*height, .1f*width, .1f*height, 200, 200, 200, 0, 0));
    walls.add(new Wall(.65f*width, .6f*height, .35f*width, .1f*height, 200, 200, 200, 0, 0));

    for (int i = 0; i<=5; i++) {
      grunt2s.add(new Grunt2(.1528f*width + .139f*width*i, .55f*height, 0, 0, 50, 75, 200));
    }
    for (int i = 0; i<=5; i++) {
      grunt2s.add(new Grunt2(.1528f*width + .139f*width*i, .35f*height, 0, 0, 50, 75, 250));
    }
    for (int i = 0; i<=5; i++) {
      grunt2s.add(new Grunt2(.1528f*width + .139f*width*i, .15f*height, 0, 0, 50, 75, 300));
    }

    infos.add(new Info(.61f*width, .94f*height, "   Watch out! Dr. D placed invisible force fields on this floor.", 40, 30));
    level = 5;
  }
  if (level == -6) {
    healths.add(new Health(.49f*width, .45f*height, 18, 40));
    infos.add(new Info(.49f*width, .55f*height, "   The time has come for you to face your archenemy once again. Dr. D uses the power of fire, and his attacks are incredibly powerful. To avoid them, try hiding behind the lava walls on the corners of the room. However, be carefull; Dr. D can climb over these walls.", 40, 30));
    MainSong.close();
    level = 6;
  }
  if (level == 7) {
    if (frameCount%12<=3) {
      image(hfwall1, .104f*width, .111f*height, .139f*width, .056f*height); //animations (see bellow as well)
    } else if (frameCount%12>=4 && frameCount%12<=7) {
      image(hfwall2, .104f*width, .111f*height, .139f*width, .056f*height);
    } else if (frameCount%12>=8 && frameCount%12<=11) {
      image(hfwall3, .104f*width, .111f*height, .139f*width, .056f*height);
    }
    if (frameCount%12<=3) {
      image(vfwall1, .069f*width, .167f*height, .035f*width, .222f*height);
    } else if (frameCount%12>=4 && frameCount%12<=7) {
      image(vfwall2, .069f*width, .167f*height, .035f*width, .222f*height);
    } else if (frameCount%12>=8 && frameCount%12<=11) {
      image(vfwall3, .069f*width, .167f*height, .035f*width, .222f*height);
    }

    if (frameCount%12<=3) {
      image(hfwall1, .104f*width, .833f*height, .139f*width, .056f*height);
    } else if (frameCount%12>=4 && frameCount%12<=7) {
      image(hfwall2, .104f*width, .833f*height, .139f*width, .056f*height);
    } else if (frameCount%12>=8 && frameCount%12<=11) {
      image(hfwall3, .104f*width, .833f*height, .139f*width, .056f*height);
    }
    if (frameCount%12<=3) {
      image(vfwall1, .069f*width, .611f*height, .035f*width, .222f*height);
    } else if (frameCount%12>=4 && frameCount%12<=7) {
      image(vfwall2, .069f*width, .611f*height, .035f*width, .222f*height);
    } else if (frameCount%12>=8 && frameCount%12<=11) {
      image(vfwall3, .069f*width, .611f*height, .035f*width, .222f*height);
    }

    if (frameCount%12<=3) {
      image(hfwall1, .757f*width, .111f*height, .139f*width, .056f*height);
    } else if (frameCount%12>=4 && frameCount%12<=7) {
      image(hfwall2, .757f*width, .111f*height, .139f*width, .056f*height);
    } else if (frameCount%12>=8 && frameCount%12<=11) {
      image(hfwall3, .757f*width, .111f*height, .139f*width, .056f*height);
    }
    if (frameCount%12<=3) {
      image(vfwall1, .896f*width, .167f*height, .035f*width, .222f*height);
    } else if (frameCount%12>=4 && frameCount%12<=7) {
      image(vfwall2, .896f*width, .167f*height, .035f*width, .222f*height);
    } else if (frameCount%12>=8 && frameCount%12<=11) {
      image(vfwall3, .896f*width, .167f*height, .035f*width, .222f*height);
    }

    if (frameCount%12<=3) {
      image(hfwall1, .757f*width, .833f*height, .139f*width, .056f*height);
    } else if (frameCount%12>=4 && frameCount%12<=7) {
      image(hfwall2, .757f*width, .833f*height, .139f*width, .056f*height);
    } else if (frameCount%12>=8 && frameCount%12<=11) {
      image(hfwall3, .757f*width, .833f*height, .139f*width, .056f*height);
    }
    if (frameCount%12<=3) {
      image(vfwall1, .896f*width, .611f*height, .035f*width, .222f*height);
    } else if (frameCount%12>=4 && frameCount%12<=7) {
      image(vfwall2, .896f*width, .611f*height, .035f*width, .222f*height);
    } else if (frameCount%12>=8 && frameCount%12<=11) {
      image(vfwall3, .896f*width, .611f*height, .035f*width, .222f*height);
    }
  }

  if (level == 3) {
    for (int i = 0; i<=7; i++) {
      if (frameCount%12<=3) {
        image(ElectroBall1, .052f*width + .139f*width*i, .133f*height, .063f*width, .1f*height);
      } else if (frameCount%12>=4 && frameCount%12<=7) {
        image(ElectroBall2, .052f*width + .139f*width*i, .133f*height, .063f*width, .1f*height);
      } else if (frameCount%12>=8 && frameCount%12<=11) {
        image(ElectroBall3, .052f*width + .139f*width*i, .133f*height, .063f*width, .1f*height);
      }
    }
    for (int i = 0; i<=7; i++) {
      if (frameCount%12<=3) {
        image(ElectroBall1, .052f*width + .139f*width*i, .355f*height, .063f*width, .1f*height);
      } else if (frameCount%12>=4 && frameCount%12<=7) {
        image(ElectroBall2, .052f*width + .139f*width*i, .355f*height, .063f*width, .1f*height);
      } else if (frameCount%12>=8 && frameCount%12<=11) {
        image(ElectroBall3, .052f*width + .139f*width*i, .355f*height, .063f*width, .1f*height);
      }
    }
    for (int i = 0; i<=7; i++) {
      if (frameCount%12<=3) {
        image(ElectroBall1, .052f*width + .139f*width*i, .577f*height, .063f*width, .1f*height);
      } else if (frameCount%12>=4 && frameCount%12<=7) {
        image(ElectroBall2, .052f*width + .139f*width*i, .577f*height, .063f*width, .1f*height);
      } else if (frameCount%12>=8 && frameCount%12<=11) {
        image(ElectroBall3, .052f*width + .139f*width*i, .577f*height, .063f*width, .1f*height);
      }
    }
    for (int i = 0; i<3; i++) {
      if (frameCount%12<=3) {
        image(ElectroBall1, .052f*width + .139f*width*i, .8f*height, .063f*width, .1f*height);
      } else if (frameCount%12>=4 && frameCount%12<=7) {
        image(ElectroBall2, .052f*width + .139f*width*i, .8f*height, .063f*width, .1f*height);
      } else if (frameCount%12>=8 && frameCount%12<=11) {
        image(ElectroBall3, .052f*width + .139f*width*i, .8f*height, .063f*width, .1f*height);
      }
    }
    for (int i = 4; i<=7; i++) {
      if (frameCount%12<=3) {
        image(ElectroBall1, .052f*width + .139f*width*i, .8f*height, .063f*width, .1f*height);
      } else if (frameCount%12>=4 && frameCount%12<=7) {
        image(ElectroBall2, .052f*width + .139f*width*i, .8f*height, .063f*width, .1f*height);
      } else if (frameCount%12>=8 && frameCount%12<=11) {
        image(ElectroBall3, .052f*width + .139f*width*i, .8f*height, .063f*width, .1f*height);
      }
    }
  }

  p.display();   //player display

    if (level==7) {
    boss.display(); //boss display and move
    boss.move();
  }
  if (level==0);
  if (InstructionsOpen == true) { //instruction pop up
    fill(255);
    rect(.2f*width, .2f*height, .6f*width, .6f*height);
    textAlign(CENTER);
    textSize(40);
    fill(0);
    text("Instructions", .22f*width, .23f*height, .56f*width, .56f*height);
    textSize(30);
    text("Use the WASD keys to move around. Use your cursor or mouse to aim or look around. Once you have an aim on something, click to shoot at it. For important hints throughout the game, place your cursor over the purple bubbles with exclamation marks (you will see these later on). To begin, click 'Start'.", .22f*width, .33f*height, .56f*width, .56f*height);
    textAlign(CORNER);
    rectMode(CENTER);
    fill(0xff7F8081, 100);
    rect(.5f*width, .75f*height, .129f*width, .072f*height);
    rectMode(CORNER);
    textSize(42);
    fill(0);
    text("Close", .5f*width-50, .75f*height-25, .22f*width, .456f*height); //when closed
    if (mousePressed && mouseX<.5f*width+.129f*width/2 && mouseX>.5f*width-.129f*width/2
      && mouseY>.75f*height-.072f*height/2 && mouseY<.75f*height+.072f*height/2) { // button function
      InstructionsOpen = false;
    }
  }

  stroke(255, 0, 0); //new cursor
  strokeWeight(3);
  line(mouseX-8, mouseY-8, mouseX-3, mouseY-3);
  line(mouseX-8, mouseY+8, mouseX-3, mouseY+3);
  line(mouseX+8, mouseY+8, mouseX+3, mouseY+3);
  line(mouseX+8, mouseY-8, mouseX+3, mouseY-3);
  stroke(0);
  strokeWeight(1);

  if (p.lives<=0) { //Game over 
    fill(0xff0074BF, 225);
    rectMode(CENTER);
    rect(width/2, height/2, 350, 150);
    rectMode(CORNER);
    textSize(60);
    fill(0, 255);
    textAlign(CENTER, CENTER);
    text("Game Over", width/2, height/2);
    textAlign(CORNER);
    End=true;
    noLoop();
  }
}

public void mousePressed() {
  if (End==false) { //when game is over no bullets can be shot
    pShot.play();
    pShot = minim.loadFile("pshot2.mp3");
    bullets.add(new Bullet(p)); //bullets are added with click
  }
}


public void keyPressed() { //key/keyCode identification 
  if (key==CODED) {
    keys[keyCode] = true;
  } else if (key!=CODED) {
    keys[key] = true;
  }
}

public void keyReleased() { //key/keyCode identification 
  if (key==CODED) {
    keys[keyCode] = false;
  } else if (key!=CODED) {
    keys[key] = false;
  }
  p.vel.x=0; //when release, speed = 0 so object doesn't continue to move
  p.vel.y=0;
}

class Boss {
  PVector loc, vel;
  float  sz, scan;
  int lives;
  float phip;
  PImage Boss;
  Boss(float x_, float y_, float dx_, float dy_, float sz_, float scan_,int lives_) {
    loc = new PVector(x_, y_);
    vel = new PVector(dx_, dy_);
    sz = sz_;
    scan = scan_;
    Boss = loadImage("enemy_Boss.png");
    lives = lives_;

  }

  Boss() {
    loc = new PVector(width/2, random(50, height-50));
    vel = new PVector(0, 0);
    sz = 50;
    scan = 250;
    Boss = loadImage("enemy_Boss.png");
    lives = 20;
  }
  public void display() {
    phip=atan2(p.loc.y-loc.y, p.loc.x-loc.x); 
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(phip);
    image(Boss, -(Boss.width)/2, -(Boss.height)/2);
    popMatrix();
    fill(0);
    rect(loc.x-40,loc.y-32,80,4); //health bar
    fill(255-lives*1.025f,lives*1.025f,0);
    rect(loc.x-40,loc.y-32,.4f*lives,4);
    noFill();
  }

  public void move() {
    if (dist(p.loc.x, p.loc.y, loc.x, loc.y)<scan) {
      vel = new PVector((p.loc.x-loc.x)/(10), (p.loc.y-loc.y)/(10));
      vel.limit(2.5f);
      loc.x+=vel.x;
      loc.y+=vel.y;
    } else {
      vel = new PVector(0, 0);
    }
  }
  
  public boolean contact(Player p) { //contact player boolean
    if (dist(p.loc.x,p.loc.y,loc.x,loc.y)<20) {
      return true;
    } else {
      return false;
    }
  }
  
  public boolean hit(Bullet b) { //contact bullet boolean
    if (dist(b.x, b.y, loc.x, loc.y)<b.sz/2+sz/2) {
      return true;
    } else {
      return false;
    }
  }
  public boolean hitList(ArrayList<Bullet> bullets) {
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
class BossBullet {
  float x, y, sz, dx, dy; //dx dy is speed
  PImage fire1, fire2;
  BossBullet(float x_, float y_, float sz_, float ang, Boss b) { //ang is an angle alteration variable
    x = x_;
    y = y_;
    dx = 17*cos(b.phip+ang); //speed
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

  public void display() {
    fill(50);
    
    if (frameCount%8 <4) { //animation
      image(fire1,x,y,sz,sz);
    } else if (frameCount%8 >=4) {
      image(fire2,x,y,sz,sz);
    } 
  }

  public void move() {
    x+=dx;
    y+=dy;
  }
  
  public boolean contactBBullet(Wall w) { //contact wall booleans
    if (x+sz/2>w.x && x-sz/2<w.x+w.sx && y-sz/2>w.y && y+sz/2<w.y + w.sy) {
      return true;
    } else {
      return false;
    }
  }
  public boolean contactListBBullet(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactBBullet(w)) {
        return true;
      }  
    }
    return false;
  }
}

class BossBullet2 {
  float x, y, sx, sy, dx, dy, ang; //see BossBullet class for related info
  PImage fireball1, fireball2;
  BossBullet2(float x_, float y_, float sx_, float sy_, float ang_, Boss b) {
    x = x_;
    y = y_;
    ang = ang_;
    dx = 30*cos(b.phip+ang);
    dy = 30*sin(b.phip+ang);
    sx = sx_;
    sy = sy_;
    fireball1=loadImage("fireb1.png");
    fireball2=loadImage("fireb2.png");
  }

  BossBullet2(Boss b) {
    x = b.loc.x;
    y = b.loc.y;
    dx = 25*cos(b.phip);
    dy = 25*sin(b.phip);
    sx = 22;
    sy = 18;
  }

  public void display(Boss b) {
    fill(50);
    pushMatrix();
    translate(x, y);
    rotate(b.phip + ang);
    if (frameCount%12 <6) {
      image(fireball1,-sx/2,-sy/2,sx,sy);
    } else if (frameCount%12 >=6) {
      image(fireball2,-sx/2,-sy/2,sx,sy);
    } 
    popMatrix();
  }

  public void move() {
    x+=dx;
    y+=dy;
  }
  
  public boolean contactB2Bullet(Wall w) {
    if (x+sy/2>w.x && x-sy/2<w.x+w.sx && y-sy/2>w.y && y+sy/2<w.y + w.sy) {
      return true;
    } else {
      return false;
    }
  }
  public boolean contactListB2Bullet(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactB2Bullet(w)) {
        return true;
      }  
    }
    return false;
  }
}

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

  public void display() {
    fill(50);
    ellipse(x, y, sz, sz);
  }

  public void move() {
    x+=dx;
    y+=dy;
  }
  
  public boolean contactBullet(Wall w) {
    if (x+sz/2>w.x && x-sz/2<w.x+w.sx && y-sz/2>w.y && y+sz/2<w.y + w.sy) {
      return true;
    } else {
      return false;
    }
  }
  public boolean contactListBullet(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactBullet(w)) {
        return true;
      }  
    }
    return false;
  }
}

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

  public void display() {
    fill(181,230,29);
    strokeWeight(1.5f);
    ellipse(x,y,sz,sz);
    noFill();
    strokeWeight(1);

  }

  public void move() {
    x+=dx;
    y+=dy;
  }
  
  public boolean contactEBullet(Wall w) {
    if (x+sz/2>w.x && x-sz/2<w.x+w.sx && y-sz/2>w.y && y+sz/2<w.y + w.sy) {
      return true;
    } else {
      return false;
    }
  }
  public boolean contactListEBullet(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactEBullet(w)) {
        return true;
      }  
    }
    return false;
  }
}
class Grunt {
  PVector loc, vel;
  float  sz, scan;
  boolean wallUg; //wall booleans
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
  public void display() {
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(phi);
    image(grunt, -(grunt.width)/2, -(grunt.height)/2);
    popMatrix();
  }

  public void move() {
    float scalex = (this.wallLg || this.wallRg) ? 0 : 1; //function that stops grunt when it is contacting the wall
    float scaley = (this.wallUg || this.wallDg) ? 0 : 1;

    if (dist(p.loc.x, p.loc.y, loc.x, loc.y)<scan) {
      vel = new PVector(2*(p.loc.x-loc.x) * scalex, 2*(p.loc.y-loc.y) * scaley); //velocity that allows grunt to move towards the player
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

  public boolean contact(Player p) { //contact Player boolean
    if (dist(p.loc.x, p.loc.y, loc.x, loc.y)<20) {
      return true;
    } else {
      return false;
    }
  }

  public boolean hit(Bullet b) { //contact Bullet booleans
    if (dist(b.x, b.y, loc.x, loc.y)<b.sz/2+sz/2) {
      return true;
    } else {
      return false;
    }
  }
  public boolean hitList(ArrayList<Bullet> bullets) {
    for (int i = 0; i < bullets.size (); i++) {
      Bullet b = bullets.get(i);
      if (hit(b)) {
        bullets.remove(i);
        return true;
      }
    }
    return false;
  }

  public boolean contactGruntUp(Wall w) { //contact wall booleans
    if (loc.y-grunt.height/2<w.y+w.sy && loc.x<w.x+w.sx &&
      loc.x>w.x && loc.y-grunt.width/2>w.y+w.sy/2) {
      return true;
    } else {
      return false;
    }
  }
  public boolean contactGruntDown(Wall w) {
    if (loc.y+grunt.height/2>w.y && loc.x<w.x+w.sx &&
      loc.x>w.x && loc.y+grunt.width/2<w.y+w.sy/2) {
      return true;
    } else {
      return false;
    }
  }
  public boolean contactGruntRight(Wall w) {
    if (loc.x+grunt.width/2>w.x && loc.y>w.y &&
      loc.y<w.y+w.sy && loc.x+grunt.width/2<w.x+w.sx/2) {
      return true;
    } else {
      return false;
    }
  }
  public boolean contactGruntLeft(Wall w) {
    if (loc.x-grunt.width/2<w.x+w.sx && loc.y>w.y &&
      loc.y<w.y+w.sy && loc.x-grunt.width/2>w.x+w.sx/2) {
      return true;
    } else {
      return false;
    }
  }

  public boolean contactListGruntUp(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactGruntUp(w)) {
        return true;
      }
    }
    return false;
  }
  public boolean contactListGruntDown(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactGruntDown(w)) {
        return true;
      }
    }
    return false;
  }
  public boolean contactListGruntRight(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactGruntRight(w)) {
        return true;
      }
    }
    return false;
  }
  public boolean contactListGruntLeft(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactGruntLeft(w)) {
        return true;
      }
    }
    return false;
  }
}

class Grunt2 {
  PVector loc, vel; //see Grunt class for related info
  float  sz, scan, bscan; //scan is regular scan, and bscan is bullet scan
  boolean wallUg;
  boolean wallDg;
  boolean wallRg;
  boolean wallLg;
  PImage grunt2;
  Grunt2(float x_, float y_, float dx_, float dy_, float sz_, float scan_, float bscan_) {
    loc = new PVector(x_, y_);
    vel = new PVector(dx_, dy_);
    sz = sz_;
    scan = scan_;
    bscan = bscan_;
    grunt2 = loadImage("enemy_grunt2.png");
  }

  Grunt2() {
    loc = new PVector(width/2, random(50, height-50));
    vel = new PVector(0, 0);
    sz = 50;
    scan = 250;
    bscan=600;
    grunt2 = loadImage("enemy_grunt2.png");
  }
  public void display() {
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(phi2);
    image(grunt2, -(grunt2.width)/2, -(grunt2.height)/2);
    popMatrix();
  }

  public void move() {
    float scalex = (this.wallLg || this.wallRg) ? 0 : 1;
    float scaley = (this.wallUg || this.wallDg) ? 0 : 1;
    
    if (dist(p.loc.x, p.loc.y, loc.x, loc.y)<scan) {
      vel = new PVector((p.loc.x-loc.x)/(10)*scalex, (p.loc.y-loc.y)/(10)*scaley);
      vel.limit(3);
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

  public boolean shoot(Player p) {
    if (dist(p.loc.x, p.loc.y, loc.x, loc.y)<bscan) {
      return true;
    }
    return false;
  }

  public boolean contact(Player p) {
    if (dist(p.loc.x, p.loc.y, loc.x, loc.y)<20) {
      return true;
    } else {
      return false;
    }
  }  
  public boolean hit(Bullet b) {
    if (dist(b.x, b.y, loc.x, loc.y)<b.sz/2+sz/2) {
      return true;
    } else {
      return false;
    }
  }
  public boolean hitList(ArrayList<Bullet> bullets) {
    for (int i = 0; i < bullets.size (); i++) {
      Bullet b = bullets.get(i);
      if (hit(b)) {
        bullets.remove(i);
        return true;
      }
    }
    return false;
  }
  public boolean contactGruntUp(Wall w) {
    if (loc.y-grunt2.height/2<w.y+w.sy && loc.x<w.x+w.sx &&
      loc.x>w.x && loc.y-grunt2.width/2>w.y+w.sy/2) {
      return true;
    } else {
      return false;
    }
  }
  public boolean contactGruntDown(Wall w) {
    if (loc.y+grunt2.height/2>w.y && loc.x<w.x+w.sx &&
      loc.x>w.x && loc.y+grunt2.width/2<w.y+w.sy/2) {
      return true;
    } else {
      return false;
    }
  }
  public boolean contactGruntRight(Wall w) {
    if (loc.x+grunt2.width/2>w.x && loc.y>w.y &&
      loc.y<w.y+w.sy && loc.x+grunt2.width/2<w.x+w.sx/2) {
      return true;
    } else {
      return false;
    }
  }
  public boolean contactGruntLeft(Wall w) {
    if (loc.x-grunt2.width/2<w.x+w.sx && loc.y>w.y &&
      loc.y<w.y+w.sy && loc.x-grunt2.width/2>w.x+w.sx/2) {
      return true;
    } else {
      return false;
    }
  }

  public boolean contactListGruntUp(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactGruntUp(w)) {
        return true;
      }
    }
    return false;
  }
  public boolean contactListGruntDown(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactGruntDown(w)) {
        return true;
      }
    }
    return false;
  }
  public boolean contactListGruntRight(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactGruntRight(w)) {
        return true;
      }
    }
    return false;
  }
  public boolean contactListGruntLeft(ArrayList<Wall> walls) {
    for (int i = 0; i < walls.size (); i++) {
      Wall w = walls.get(i);
      if (contactGruntLeft(w)) {
        return true;
      }
    }
    return false;
  }
}

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
  
  public void display() {
    image(Health, x, y, sz, sz);
  }
  
  public boolean contactPlayer(Player p) { //boolean for contact with player
    if (p.loc.x>x && p.loc.x<x+sz && p.loc.y>y && p.loc.y<y + sz) {
      return true;
    } else {
      return false;
    }
  }
}
class Info {
  float x, y, sz, tsz;
  String info;
  PImage Info;
  Info(float x_, float y_, String info_, float sz_, float tsz_) { //tsz is text size
    x=x_;
    y=y_;
    info=info_;
    sz=sz_;
    tsz=tsz_;
    Info = loadImage("Info.png");
  }

  public void display() {
    image(Info, x, y, sz, sz);
    if (dist(mouseX, mouseY, x+sz/2, y+sz/2) <= sz/2) {
      fill(255);
      rect(.2f*width, .2f*height, .6f*width, .6f*height);
      textAlign(CENTER);
      textSize(40);
      fill(0);
      text("Hints", .22f*width, .23f*height, .56f*width, .56f*height);
      textSize(tsz);
      text(info, .22f*width, .35f*height, .56f*width, .56f*height);
      textAlign(CORNER);
    }
  }

}

class Player {
  PVector loc, vel;
  PImage Player;
  int lives;
  Player(float x_, float y_, float dx_, float dy_, int lives_) {
    loc = new PVector(x_, y_);
    vel = new PVector(dx_, dy_);
    Player = loadImage("Main.png");
    lives=lives_;
  }

  Player() {
    loc = new PVector(width/2, height/2);
    vel = new PVector(0, 0);
    Player = loadImage("Main.png");
    lives=100;
  }

  public void display() {
    theta=atan2(mouseY-loc.y, mouseX-loc.x); //rotation angle for Player

    pushMatrix(); //<--rotation starts here
    translate(loc.x, loc.y);
    rotate(theta);
    image(Player, -(Player.width)/2, -(Player.height)/2);
    popMatrix(); //<--rotation ends here
    fill(0);
    rect(loc.x-20, loc.y-32, 40, 4); //health bar
    fill(255-lives*2.55f, lives*2.55f, 0);
    rect(loc.x-20, loc.y-32, .4f*lives, 4);
    noFill();
  }

  public boolean hit(BossBullet q) { //contact with bossbullets and enemybullets
    if (dist(q.x, q.y, loc.x, loc.y)<q.sz/3+Player.width/2) {
      return true;
    } else {
      return false;
    }
  }
  public boolean hitList(ArrayList<BossBullet> bossbullets) {
    for (int i = 0; i < bossbullets.size (); i++) {
      BossBullet q = bossbullets.get(i);
      if (hit(q)) {
        bossbullets.remove(i);
        return true;
      }
    }
    return false;
  }
  
    public boolean hit2(BossBullet2 bb) {
    if (dist(bb.x, bb.y, loc.x, loc.y)<bb.sy/2+Player.width/2) {
      return true;
    } else {
      return false;
    }
  }
  public boolean hit2List(ArrayList<BossBullet2> bossbullet2s) {
    for (int i = 0; i < bossbullet2s.size (); i++) {
      BossBullet2 bb = bossbullet2s.get(i);
      if (hit2(bb)) {
        bossbullet2s.remove(i);
        return true;
      }
    }
    return false;
  }
  
  public boolean ehit(EnemyBullet eb) {
    if (dist(eb.x, eb.y, loc.x, loc.y)<eb.sz/2+Player.width/2) {
      return true;
    } else {
      return false;
    }
  }
  public boolean ehitList(ArrayList<EnemyBullet> enemybullets) {
    for (int i = 0; i < enemybullets.size (); i++) {
     EnemyBullet eb = enemybullets.get(i);
      if (ehit(eb)) {
        enemybullets.remove(i);
        return true;
      }
    }
    return false;
  }



  public void move() {
    loc.x += vel.x;
    loc.y += vel.y;

    if (keys['w']) { //key boolean list
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

class Wall {
  float x, y, sx, sy;
  int r, g, b; //red, green, blue
  float trans, strans;
  Wall(float x_, float y_, float sx_, float sy_, int r_, int g_, int b_, float trans_, float strans_) {
    x=x_;
    y=y_;
    sx=sx_;
    sy=sy_;
    r=r_;
    g=g_;
    b=b_;
    trans=trans_; //opacity
    strans=strans_; //stroke opacity
  }
  public void display() {
    stroke(0, 0, 0, strans); 
    fill(r, g, b,trans);
    rect(x, y, sx, sy);
    stroke(0, 0, 0, 255);
  }
  public boolean contactPlayerUp(Player p) { //boolean when wall contacts player
    if (p.loc.y-p.Player.height/2<y+sy && p.loc.x<x+sx &&
      p.loc.x>x && p.loc.y-p.Player.width/2>y+sy/2) {
      return true;
    } else {
      return false;
    }
  }
  public boolean contactPlayerDown(Player p) {
    if (p.loc.y+p.Player.height/2>y && p.loc.x<x+sx &&
      p.loc.x>x && p.loc.y+p.Player.width/2<y+sy/2) {
      return true;
    } else {
      return false;
    }
  }
  public boolean contactPlayerRight(Player p) {
    if (p.loc.x+p.Player.width/2>x && p.loc.y>y &&
      p.loc.y<y+sy && p.loc.x+p.Player.width/2<x+sx/2) {
      return true;
    } else {
      return false;
    }
  }
  public boolean contactPlayerLeft(Player p) {
    if (p.loc.x-p.Player.width/2<x+sx && p.loc.y>y &&
      p.loc.y<y+sy && p.loc.x-p.Player.width/2>x+sx/2) {
      return true;
    } else {
      return false;
    }
  }
}








  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#FF4400", "GunmanZ" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
