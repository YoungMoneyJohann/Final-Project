import ddf.minim.spi.*; //minim
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

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

void setup() {
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

void draw() {
  background(255);
  noCursor();

  image(Poster, 0, 0, width, height); //background
  if (level==0) { //initial level or starting screen
    IntroSong.play();
    fill(0, 255, 0, 100);
    rectMode(CENTER);
    rect(.4283*width, .234*height, .129*width, .072*height);
    fill(#FF9900, 175);
    rect(.4*width, .93*height, .2*width, .072*height);
    rectMode(CORNER);
    fill(0);
    textSize(42);
    fill(40, 40, 255, 220);
    text("Start", .4283*width-50, .234*height-25, .22*width, .456*height);
    fill(0);
    text("Instructions", .4*width-120, .93*height-25, .22*width, .456*height); //start button
    noFill();


    if (mousePressed && mouseX<.4283*width+.129*width/2 && mouseX>.4283*width-.129*width/2
      && mouseY>.234*height-.072*height/2 && mouseY<.234*height+.072*height/2) { // button function
      level=-1;
      IntroSong.close();
      IntroSong = minim.loadFile("Beat2.mp3");
      MainSong.play();
    }

    if (mousePressed && mouseX<.4*width+.2*width/2 && mouseX>.4*width-.2*width/2
      && mouseY>.93*height-.072*height/2 && mouseY<.93*height+.072*height/2) { // button function
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
    background(#989898);

    for (int i = 0; i < cols; i++) { //tile flooring
      for (int j = 0; j < rows; j++) { 
        int x = i*2*scale;
        int y = j*2*scale;
        fill(#6CC2E3, 50);
        noStroke();
        rect(x, y, scale, scale); 
        rect(x+scale, y+scale, scale, scale);
        stroke(0);
      }
    }

    fill(#BCBCBC);
    rect(0, .5*height, width, .278*height);
    fill(0);
    rect(0, .722*height, width, .555*height);

    fill(#FFF700); 
    rect(0, .867*height, .0903*width, .0389*height); // yellow lines
    rect(.181*width, .867*height, .0903*width, .0389*height); 
    rect(.361*width, .867*height, .0903*width, .0389*height);
    rect(.542*width, .867*height, .0903*width, .0389*height);
    rect(.722*width, .867*height, .0903*width, .0389*height);
    rect(.903*width, .867*height, .0903*width, .0389*height); 
    fill(#A7815A);
    rect(.4*width, 0, .208*width, .222*height); //carpet

      image(Elevator1, .417*width, 0, .174*width, .067*height);

    image(Plant, .035*width, .056*height, .052*width, .083*height);
    image(Plant, .913*width, .056*height, .052*width, .083*height);


    if (p.loc.x >= .417*width && p.loc.x <= .59*width && p.loc.y <= .067*height) { //elevator function
      level = -2;
      p.loc.y = .089*height;
      p.loc.x = .503*width;
      Ding.play();
      Ding = minim.loadFile("Ding.mp3");
    }
  }

  if (level==2) { // actual level
    background(#989898);

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) { 
        int x = i*2*scale;
        int y = j*2*scale;
        fill(#21FF00, 50);
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

    image(Elevator2R, .417*width, .933*height, .174*width, .067*height);

    image(ElevatorB, .417*width, 0, .174*width, .067*height);

    if (p.loc.x >= .417*width && p.loc.x <= .59*width && p.loc.y >= .933*height) {
      level = -3;
      p.loc.y = .911*height;
      p.loc.x = .503*width;
      Ding.play(); //elevator sound
      Ding = minim.loadFile("Ding.mp3");
    }
  }

  if (level==3) { // actual level
    background(#989898);

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) { 
        int x = i*2*scale;
        int y = j*2*scale;
        fill(#FF8400, 50);
        noStroke();
        rect(x, y, scale, scale); 
        rect(x+scale, y+scale, scale, scale);
        stroke(0);
      }
    }

    image(Elevator1R, .417*width, .933*height, .174*width, .067*height);

    image(Elevator3, .417*width, 0, .174*width, .067*height);

    if (p.loc.x >= .417*width && p.loc.x <= .59*width && p.loc.y <= .067*height) {
      level = -4;
      p.loc.y = .089*height;
      p.loc.x = .503*width;
      Ding.play();
      Ding = minim.loadFile("Ding.mp3");
    }
  }

  if (level==4) { // actual level
    background(#989898);

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) { 
        int x = i*2*scale;
        int y = j*2*scale;
        fill(#9400FF, 50);
        noStroke();
        rect(x, y, scale, scale); 
        rect(x+scale, y+scale, scale, scale);
        stroke(0);
      }
    }

    image(DRDPOSTER, .139*width, .222*height, .729*width, .555*height); //poster

    image(Elevator2, .417*width, 0, .174*width, .067*height);
    image(Elevator4R, .417*width, .933*height, .174*width, .067*height);


    if (p.loc.x >= 600 && p.loc.x <= .59*width && p.loc.y >= .933*height) {
      level = -5;
      p.loc.y = .911*height;
      p.loc.x = .503*width;
      Ding.play();
      Ding = minim.loadFile("Ding.mp3");
    }
  }

  if (level==5) {
    background(#989898);
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) { 
        int x = i*2*scale;
        int y = j*2*scale;
        fill(#A56117, 50);
        noStroke();
        rect(x, y, scale, scale); 
        rect(x+scale, y+scale, scale, scale);
        stroke(0);
      }
    }

    image(Elevator5, .417*width, 0, .174*width, .067*height);
    image(Elevator3R, .417*width, .933*height, .174*width, .067*height);

    if (p.loc.x >= .417*width && p.loc.x <= .59*width && p.loc.y <= .067*height) {
      level = -6;
      p.loc.y = .089*height;
      p.loc.x = .503*width;
      Ding.play();
      Ding = minim.loadFile("Ding.mp3");
    }
  }

  if (level==6) {
    background(#7C7C7C);
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) { 
        int x = i*2*scale;
        int y = j*2*scale;
        fill(#FF0000, 50);
        noStroke();
        rect(x, y, scale, scale); 
        rect(x+scale, y+scale, scale, scale);
        stroke(0);
      }
    }
    if (frameCount%12 <6) { //animation
      image(ElevatorBoss1, .417*width, .933*height, .174*width, .067*height);
    } else if (frameCount%12 >=6) {
      image(ElevatorBoss1, .417*width, .933*height, .174*width, .067*height);
    } 

    image(Elevator4, .417*width, 0, .174*width, .067*height);

    if (p.loc.x >= 600 && p.loc.x <= .59*width && p.loc.y >= .933*height) {
      level = -7;
      p.loc.y = .911*height;
      p.loc.x = .503*width;
      Ding.play();
      Ding = minim.loadFile("Ding.mp3");
    }
  }

  if (level==7) { // actual level
    background(#7C7C7C);
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) { 
        int x = i*2*scale;
        int y = j*2*scale;
        fill(#FF0000, 50);
        noStroke();
        rect(x, y, scale, scale); 
        rect(x+scale, y+scale, scale, scale);
        stroke(0);
      }
      if (frameCount%12 <6) {
        image(ElevatorBoss1, .417*width, .933*height, .174*width, .067*height);
      } else if (frameCount%12 >=6) {
        image(ElevatorBoss1, .417*width, .933*height, .174*width, .067*height);
      }
    }

    MainSong.close();
    FinalSong.play();

    imageMode(CENTER);
    image(Graf, width/2, height/2, 758.5, 123); //image (says "Dr D Baby")
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
      bossbullet2s.add(new BossBullet2(boss.loc.x, boss.loc.y, 20, 15, random(-.22, .22), boss));
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
        fill(#0074BF, 225);
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
    grunts.add(new Grunt(.454*width, .111*height, 0, 0, 50, 350));
    grunt2s.add(new Grunt2(.506*width, .111*height, 0, 0, 50, 350, 500));
    grunts.add(new Grunt(.558*width, .111*height, 0, 0, 50, 350));
    walls.add(new Wall(0, .444*height, .465*width, .056*height, 200, 200, 200, 255, 255));
    walls.add(new Wall(.535*width, .444*height, width, .056*height, 200, 200, 200, 255, 255));

    infos.add(new Info(.84*width, .447*height, "   Your archenemy, Dr. Diabolical, has kidnapped your girlfriend again!! You need to enter his headquarters, defeat him and his robot minions, and resque her! First, defeat his 3 guards and enter the elevator to go to the next floor.", 40, 30));

    level = 1; //transition to actual level
  }

  if (level == -2) { //objects to be loaded in the preparation level\
    grunt2s.add(new Grunt2(.292*width, .333*height, 0, 0, 50, 300, 325));
    grunt2s.add(new Grunt2(.708*width, .333*height, 0, 0, 50, 300, 325));
    grunts.add(new Grunt(.431*width, .333*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.569*width, .333*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.153*width, .333*height, 0, 0, 50, 450));
    grunts.add(new Grunt(.847*width, .333*height, 0, 0, 50, 450));

    grunt2s.add(new Grunt2(.292*width, .555*height, 0, 0, 50, 300, 325));
    grunt2s.add(new Grunt2(.708*width, .555*height, 0, 0, 50, 300, 325));
    grunts.add(new Grunt(.431*width, .555*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.569*width, .555*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.153*width, .555*height, 0, 0, 50, 450));
    grunts.add(new Grunt(.847*width, .555*height, 0, 0, 50, 450));

    grunt2s.add(new Grunt2(.292*width, .778*height, 0, 0, 50, 300, 325));
    grunt2s.add(new Grunt2(.708*width, .778*height, 0, 0, 50, 300, 325));
    grunts.add(new Grunt(.431*width, .778*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.569*width, .778*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.153*width, .778*height, 0, 0, 50, 450));
    grunts.add(new Grunt(.847*width, .778*height, 0, 0, 50, 450));

    walls.add(new Wall(.1042*width, .167*height, .361*width, .056*height, 191, 138, 73, 255, 255));
    walls.add(new Wall(.535*width, .167*height, .361*width, .056*height, 191, 138, 73, 255, 255));

    walls.add(new Wall(.1042*width, .389*height, .361*width, .056*height, 191, 138, 73, 255, 255));
    walls.add(new Wall(.535*width, .389*height, .361*width, .056*height, 191, 138, 73, 255, 255));

    walls.add(new Wall(.1042*width, .611*height, .361*width, .056*height, 191, 138, 73, 255, 255));
    walls.add(new Wall(.535*width, .611*height, .361*width, .056*height, 191, 138, 73, 255, 255));

    healths.add(new Health(.92*width, .7*height, 10, 40));
    infos.add(new Info(.92*width, .62*height, "   Bellow here is a health box. There are a few of them in Dr. D's HQ and each one will heal you for a different amount. To use it, simply interact or touch the center of the box.", 40, 30));
    infos.add(new Info(.36*width, .043*height, "   There are two kinds of robots: Chargers, which are fast and ram into you before self-destructing, and Blasters, which are Chargers that have less speed but can fire energy blasts. Defeat these guys and go to the next floor!", 40, 30));
    level = 2; //transition to actual level
  }

  if (level == -3) { //objects to be loaded in the preparation level

    for (int i = 0; i<=7; i++) {
      walls.add(new Wall(.052*width + .139*width*i, .133*height, .063*width, .1*height, 200, 200, 200, 255, 255));
    }
    for (int i = 0; i<=7; i++) {
      walls.add(new Wall(.052*width + .139*width*i, .355*height, .063*width, .1*height, 200, 200, 200, 255, 255));
    }
    for (int i = 0; i<=7; i++) {
      walls.add(new Wall(.052*width + .139*width*i, .577*height, .063*width, .1*height, 200, 200, 200, 255, 255));
    }
    for (int i = 0; i<3; i++) {
      walls.add(new Wall(.052*width + .139*width*i, .8*height, .063*width, .1*height, 200, 200, 200, 255, 255));
    }
    for (int i = 4; i<=7; i++) {
      walls.add(new Wall(.052*width + .139*width*i, .8*height, .063*width, .1*height, 200, 200, 200, 255, 255));
    }


    for (int i = 0; i<=5; i++) {
      grunts.add(new Grunt(.1528*width + .139*width*i, .1833*height, 0, 0, 50, 520));
    }
    for (int i = 0; i<=5; i++) {
      grunt2s.add(new Grunt2(.1528*width + .139*width*i, .406*height, 0, 0, 50, 250, 600));
    }
    for (int i = 0; i<=5; i++) {
      grunts.add(new Grunt(.1528*width + .139*width*i, .628*height, 0, 0, 50, 250));
    }
    for (int i = 0; i<=1; i++) {
      grunts.add(new Grunt(.1528*width + .139*width*i, .85*height, 0, 0, 50, 250));
    }
    for (int i = 4; i<=5; i++) {
      grunts.add(new Grunt(.1528*width + .139*width*i, .85*height, 0, 0, 50, 250));
    }
    level = 3;
  }

  if (level == -4) { //objects to be loaded in the preparation level

    walls.add(new Wall(.0694*width, .111*height, .0694*width, .777*height, 200, 200, 200, 255, 255));
    walls.add(new Wall(.139*width, .111*height, .799*width, .111*height, 200, 200, 200, 255, 255));
    walls.add(new Wall(.868*width, .111*height, .0694*width, .777*height, 200, 200, 200, 255, 255));
    walls.add(new Wall(.0694*width, .777*height, .868*width, .111*height, 200, 200, 200, 255, 255));
    walls.add(new Wall(.45*width, .888*height, .1*width, .045*height, 200, 200, 200, 255, 255));

    for (int i = 0; i<5; i++) { //enemys will be stacked on top of each other
      grunts.add(new Grunt(.0347*width, .111*height, 0, 0, 50, 20));
      grunts.add(new Grunt(.0347*width, .222*height, 0, 0, 50, 20));
      grunts.add(new Grunt(.0347*width, .333*height, 0, 0, 50, 20));
      grunts.add(new Grunt(.0347*width, .444*height, 0, 0, 50, 20));
    }
    grunt2s.add(new Grunt2(.0347*width, .555*height, 0, 0, 50, 400, 800));
    grunt2s.add(new Grunt2(.0347*width, .666*height, 0, 0, 50, 400, 900));
    grunt2s.add(new Grunt2(.0347*width, .777*height, 0, 0, 50, 400, 900));
    grunt2s.add(new Grunt2(.0347*width, .888*height, 0, 0, 50, 400, 900));
    for (int i = 0; i<5; i++) {
      grunts.add(new Grunt(.965*width, .111*height, 0, 0, 50, 20));
      grunts.add(new Grunt(.965*width, .222*height, 0, 0, 50, 20));
      grunts.add(new Grunt(.965*width, .333*height, 0, 0, 50, 20));
      grunts.add(new Grunt(.965*width, .444*height, 0, 0, 50, 20));
    }
    grunt2s.add(new Grunt2(.965*width, .555*height, 0, 0, 50, 400, 800));
    grunt2s.add(new Grunt2(.965*width, .666*height, 0, 0, 50, 400, 900));
    grunt2s.add(new Grunt2(.965*width, .777*height, 0, 0, 50, 400, 900));
    grunt2s.add(new Grunt2(.965*width, .888*height, 0, 0, 50, 400, 900));

    healths.add(new Health(.6585*width, .925*height, 3, 40));
    healths.add(new Health(.35*width, .925*height, 10, 40));
    healths.add(new Health(.63*width, .925*height, 2, 40));
    
    infos.add(new Info(.37*width, .035*height, "   Be carefull, Dr. D is using broken Chargers as shields for the Blasters. There may seem like there are only 4 on each side, but each one actually is a stack of 4! Do not to touch them, their self-destruct function still works and you will take serious damage.", 40, 30));

    level = 4; //transition to actual level
  }

  if (level == -7) { //objects to be loaded in the preparation level
    boss = new Boss(width/2, height/20, 0, 0, 50, 950, 200);
    walls.add(new Wall(.104*width, .111*height, .139*width, .056*height, 200, 200, 200, 255, 255));
    walls.add(new Wall( .069*width, .167*height, .035*width, .222*height, 200, 200, 200, 255, 255));

    walls.add(new Wall(.104*width, .833*height, .139*width, .056*height, 200, 200, 200, 255, 255));
    walls.add(new Wall( .069*width, .611*height, .035*width, .222*height, 200, 200, 200, 255, 255));

    walls.add(new Wall(.757*width, .111*height, .139*width, .056*height, 200, 200, 200, 255, 255));
    walls.add(new Wall( .896*width, .167*height, .035*width, .222*height, 200, 200, 200, 255, 255));

    walls.add(new Wall(.757*width, .833*height, .139*width, .056*height, 200, 200, 200, 255, 255));
    walls.add(new Wall( .896*width, .611*height, .035*width, .222*height, 200, 200, 200, 255, 255));
    level = 7; //transition to actual level
  }

  if (level == -5) {
    walls.add(new Wall(0, .2*height, .25*width, .1*height, 200, 200, 200, 0, 0));
    walls.add(new Wall(.45*width, .2*height, .2*width, .1*height, 200, 200, 200, 0, 0));
    walls.add(new Wall(.65*width, .2*height, .35*width, .1*height, 200, 200, 200, 0, 0));
    walls.add(new Wall(.2*width, .4*height, .15*width, .1*height, 200, 200, 200, 0, 0));
    walls.add(new Wall(.35*width, .4*height, .3*width, .1*height, 200, 200, 200, 0, 0));
    walls.add(new Wall(.75*width, .4*height, .1*width, .1*height, 200, 200, 200, 0, 0));
    walls.add(new Wall(0, .6*height, .25*width, .1*height, 200, 200, 200, 0, 0));
    walls.add(new Wall(.45*width, .6*height, .1*width, .1*height, 200, 200, 200, 0, 0));
    walls.add(new Wall(.65*width, .6*height, .35*width, .1*height, 200, 200, 200, 0, 0));

    for (int i = 0; i<=5; i++) {
      grunt2s.add(new Grunt2(.1528*width + .139*width*i, .55*height, 0, 0, 50, 75, 200));
    }
    for (int i = 0; i<=5; i++) {
      grunt2s.add(new Grunt2(.1528*width + .139*width*i, .35*height, 0, 0, 50, 75, 250));
    }
    for (int i = 0; i<=5; i++) {
      grunt2s.add(new Grunt2(.1528*width + .139*width*i, .15*height, 0, 0, 50, 75, 300));
    }

    infos.add(new Info(.61*width, .94*height, "   Watch out! Dr. D placed invisible force fields on this floor.", 40, 30));
    level = 5;
  }
  if (level == -6) {
    healths.add(new Health(.49*width, .45*height, 18, 40));
    infos.add(new Info(.49*width, .55*height, "   The time has come for you to face your archenemy once again. Dr. D uses the power of fire, and his attacks are incredibly powerful. To avoid them, try hiding behind the lava walls on the corners of the room. However, be carefull; Dr. D can climb over these walls.", 40, 30));
    MainSong.close();
    level = 6;
  }
  if (level == 7) {
    if (frameCount%12<=3) {
      image(hfwall1, .104*width, .111*height, .139*width, .056*height); //animations (see bellow as well)
    } else if (frameCount%12>=4 && frameCount%12<=7) {
      image(hfwall2, .104*width, .111*height, .139*width, .056*height);
    } else if (frameCount%12>=8 && frameCount%12<=11) {
      image(hfwall3, .104*width, .111*height, .139*width, .056*height);
    }
    if (frameCount%12<=3) {
      image(vfwall1, .069*width, .167*height, .035*width, .222*height);
    } else if (frameCount%12>=4 && frameCount%12<=7) {
      image(vfwall2, .069*width, .167*height, .035*width, .222*height);
    } else if (frameCount%12>=8 && frameCount%12<=11) {
      image(vfwall3, .069*width, .167*height, .035*width, .222*height);
    }

    if (frameCount%12<=3) {
      image(hfwall1, .104*width, .833*height, .139*width, .056*height);
    } else if (frameCount%12>=4 && frameCount%12<=7) {
      image(hfwall2, .104*width, .833*height, .139*width, .056*height);
    } else if (frameCount%12>=8 && frameCount%12<=11) {
      image(hfwall3, .104*width, .833*height, .139*width, .056*height);
    }
    if (frameCount%12<=3) {
      image(vfwall1, .069*width, .611*height, .035*width, .222*height);
    } else if (frameCount%12>=4 && frameCount%12<=7) {
      image(vfwall2, .069*width, .611*height, .035*width, .222*height);
    } else if (frameCount%12>=8 && frameCount%12<=11) {
      image(vfwall3, .069*width, .611*height, .035*width, .222*height);
    }

    if (frameCount%12<=3) {
      image(hfwall1, .757*width, .111*height, .139*width, .056*height);
    } else if (frameCount%12>=4 && frameCount%12<=7) {
      image(hfwall2, .757*width, .111*height, .139*width, .056*height);
    } else if (frameCount%12>=8 && frameCount%12<=11) {
      image(hfwall3, .757*width, .111*height, .139*width, .056*height);
    }
    if (frameCount%12<=3) {
      image(vfwall1, .896*width, .167*height, .035*width, .222*height);
    } else if (frameCount%12>=4 && frameCount%12<=7) {
      image(vfwall2, .896*width, .167*height, .035*width, .222*height);
    } else if (frameCount%12>=8 && frameCount%12<=11) {
      image(vfwall3, .896*width, .167*height, .035*width, .222*height);
    }

    if (frameCount%12<=3) {
      image(hfwall1, .757*width, .833*height, .139*width, .056*height);
    } else if (frameCount%12>=4 && frameCount%12<=7) {
      image(hfwall2, .757*width, .833*height, .139*width, .056*height);
    } else if (frameCount%12>=8 && frameCount%12<=11) {
      image(hfwall3, .757*width, .833*height, .139*width, .056*height);
    }
    if (frameCount%12<=3) {
      image(vfwall1, .896*width, .611*height, .035*width, .222*height);
    } else if (frameCount%12>=4 && frameCount%12<=7) {
      image(vfwall2, .896*width, .611*height, .035*width, .222*height);
    } else if (frameCount%12>=8 && frameCount%12<=11) {
      image(vfwall3, .896*width, .611*height, .035*width, .222*height);
    }
  }

  if (level == 3) {
    for (int i = 0; i<=7; i++) {
      if (frameCount%12<=3) {
        image(ElectroBall1, .052*width + .139*width*i, .133*height, .063*width, .1*height);
      } else if (frameCount%12>=4 && frameCount%12<=7) {
        image(ElectroBall2, .052*width + .139*width*i, .133*height, .063*width, .1*height);
      } else if (frameCount%12>=8 && frameCount%12<=11) {
        image(ElectroBall3, .052*width + .139*width*i, .133*height, .063*width, .1*height);
      }
    }
    for (int i = 0; i<=7; i++) {
      if (frameCount%12<=3) {
        image(ElectroBall1, .052*width + .139*width*i, .355*height, .063*width, .1*height);
      } else if (frameCount%12>=4 && frameCount%12<=7) {
        image(ElectroBall2, .052*width + .139*width*i, .355*height, .063*width, .1*height);
      } else if (frameCount%12>=8 && frameCount%12<=11) {
        image(ElectroBall3, .052*width + .139*width*i, .355*height, .063*width, .1*height);
      }
    }
    for (int i = 0; i<=7; i++) {
      if (frameCount%12<=3) {
        image(ElectroBall1, .052*width + .139*width*i, .577*height, .063*width, .1*height);
      } else if (frameCount%12>=4 && frameCount%12<=7) {
        image(ElectroBall2, .052*width + .139*width*i, .577*height, .063*width, .1*height);
      } else if (frameCount%12>=8 && frameCount%12<=11) {
        image(ElectroBall3, .052*width + .139*width*i, .577*height, .063*width, .1*height);
      }
    }
    for (int i = 0; i<3; i++) {
      if (frameCount%12<=3) {
        image(ElectroBall1, .052*width + .139*width*i, .8*height, .063*width, .1*height);
      } else if (frameCount%12>=4 && frameCount%12<=7) {
        image(ElectroBall2, .052*width + .139*width*i, .8*height, .063*width, .1*height);
      } else if (frameCount%12>=8 && frameCount%12<=11) {
        image(ElectroBall3, .052*width + .139*width*i, .8*height, .063*width, .1*height);
      }
    }
    for (int i = 4; i<=7; i++) {
      if (frameCount%12<=3) {
        image(ElectroBall1, .052*width + .139*width*i, .8*height, .063*width, .1*height);
      } else if (frameCount%12>=4 && frameCount%12<=7) {
        image(ElectroBall2, .052*width + .139*width*i, .8*height, .063*width, .1*height);
      } else if (frameCount%12>=8 && frameCount%12<=11) {
        image(ElectroBall3, .052*width + .139*width*i, .8*height, .063*width, .1*height);
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
    rect(.2*width, .2*height, .6*width, .6*height);
    textAlign(CENTER);
    textSize(40);
    fill(0);
    text("Instructions", .22*width, .23*height, .56*width, .56*height);
    textSize(30);
    text("Use the WASD keys to move around. Use your cursor or mouse to aim or look around. Once you have an aim on something, click to shoot at it. For important hints throughout the game, place your cursor over the purple bubbles with exclamation marks (you will see these later on). To begin, click 'Start'.", .22*width, .33*height, .56*width, .56*height);
    textAlign(CORNER);
    rectMode(CENTER);
    fill(#7F8081, 100);
    rect(.5*width, .75*height, .129*width, .072*height);
    rectMode(CORNER);
    textSize(42);
    fill(0);
    text("Close", .5*width-50, .75*height-25, .22*width, .456*height); //when closed
    if (mousePressed && mouseX<.5*width+.129*width/2 && mouseX>.5*width-.129*width/2
      && mouseY>.75*height-.072*height/2 && mouseY<.75*height+.072*height/2) { // button function
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
    fill(#0074BF, 225);
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

void mousePressed() {
  if (End==false) { //when game is over no bullets can be shot
    pShot.play();
    pShot = minim.loadFile("pshot2.mp3");
    bullets.add(new Bullet(p)); //bullets are added with click
  }
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

