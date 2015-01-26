import ddf.minim.spi.*;
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

ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Grunt> grunts = new ArrayList<Grunt>();
ArrayList<Wall> walls = new ArrayList<Wall>();
ArrayList<Boss> bosses = new ArrayList<Boss>();
ArrayList<BossBullet> bossbullets = new ArrayList<BossBullet>();
ArrayList<BossBullet2> bossbullet2s = new ArrayList<BossBullet2>();
ArrayList<EnemyBullet> enemybullets = new ArrayList<EnemyBullet>();
ArrayList<Grunt2> grunt2s = new ArrayList<Grunt2>();
ArrayList<Health> healths = new ArrayList<Health>();
ArrayList<Info> infos = new ArrayList<Info>();

Player p;
Boss boss;
int score;

int count;

int level;

float theta; //Rotation Angle for Player
float phi; //Rotation Angle for Grunt and other Enemies
float phi2; //Rotation Angle for Grunt and other Enemies

boolean wallU; //Wall contact booleans (see wall class)
boolean wallD;
boolean wallR;
boolean wallL;

boolean wallUg; //Wall contact booleans for grunts (see wall class)
boolean wallDg;
boolean wallRg;
boolean wallLg;

boolean keys[] = new boolean[255]; //Multiple key input boolean

PImage Poster;
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
PImage vfwall1;
PImage vfwall2;
PImage vfwall3;
PImage hfwall1;
PImage hfwall2;
PImage hfwall3;

void setup() {
  size(displayWidth, displayHeight);
  score = 0;
  level = 0;
  count = 0;
  //  wallU=false;
  //  wallD=false;
  //  wallR=false;
  //  wallL=false;

  p = new Player();
  Poster = loadImage("Poster.png");
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
  vfwall1 = loadImage("vfwall1.png");
  vfwall2 = loadImage("vfwall2.png");
  vfwall3 = loadImage("vfwall3.png");
  hfwall1 = loadImage("hfwall1.png");
  hfwall2 = loadImage("hfwall2.png");
  hfwall3 = loadImage("hfwall3.png");

  minim = new Minim(this); //initialized sound
  IntroSong = minim.loadFile("Beat2.mp3");
  MainSong = minim.loadFile("song2.mp3");
  pShot = minim.loadFile("pshot2.mp3");
  Ding = minim.loadFile("Ding.mp3");
}

void draw() {
  background(255);
  noCursor();

  println(infos.size());

  image(Poster, 0, 0, width, height);
  if (level==0) { //initial level or starting screen
    IntroSong.play();
    fill(0, 255, 0, 100);
    rectMode(CENTER);
    rect(.4283*width, .234*height, .129*width, .072*height);
    rectMode(CORNER);
    fill(0);
    textSize(42);
    fill(40, 40, 255, 220);
    text("Start", .4283*width-50, .234*height-25, .22*width, .456*height); //start button
    noFill();


    if (mousePressed && mouseX<.4283*width+.129*width/2 && mouseX>.4283*width-.129*width/2
      && mouseY>.234*height-.072*height/2 && mouseY<.234*height+.072*height/2) { // button function
      level=-1;
      IntroSong.close();
      IntroSong = minim.loadFile("Beat2.mp3");
      MainSong.play();
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
    fill(255, 0, 200);
    rect(.4*width, 0, .208*width, .222*height); //carpet

      image(Elevator1, .417*width, 0, .174*width, .067*height);

    image(Plant, .035*width, .056*height, .052*width, .083*height);
    image(Plant, .913*width, .056*height, .052*width, .083*height);


    if (p.loc.x >= .417*width && p.loc.x <= .59*width && p.loc.y <= .067*height) {
      level = -2;
      p.loc.y = .089*height;
      p.loc.x = .503*width;
      Ding.play();
      Ding = minim.loadFile("Ding.mp3");
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
    image(Elevator2R, 600, height-60, 250, 60);

    if (p.loc.x >= 600 && p.loc.x <= 850 && p.loc.y >= height-60) {
      level = -3;
      p.loc.y = .911*height;
      p.loc.x = .503*width;
      Ding.play();
      Ding = minim.loadFile("Ding.mp3");
    }
  }

  if (level==3) { // actual level
    background(#989898);


    fill(#E8E8E8);
    rect(600, 0, 250, 60); //elevator lv 3
    image(Elevator3, 600, 0, 250, 60);

    if (p.loc.x >= 600 && p.loc.x <= 850 && p.loc.y <= 60) {
      level = -4;
      p.loc.y = .089*height;
      p.loc.x = .503*width;
      Ding.play();
      Ding = minim.loadFile("Ding.mp3");
    }
  }

  if (level==4) { // actual level
    background(#989898);

    image(DRDPOSTER, .139*width, .222*height, .729*width, .555*height);

    fill(#E8E8E8);
    rect(600, height-60, 250, 60); //elevator lv 2
    image(Elevator4R, 600, height-60, 250, 60);


    if (p.loc.x >= 600 && p.loc.x <= 850 && p.loc.y >= height-60) {
      level = -5;
      p.loc.y = .911*height;
      p.loc.x = .503*width;
      Ding.play();
      Ding = minim.loadFile("Ding.mp3");
    }
  }

  if (level==5) { // actual level
    background(#989898);
    boss.display();
    boss.move();
    MainSong.close();
    IntroSong.play();

    if (frameCount%30==0 && count <= 5) {
      bossbullets.add(new BossBullet(boss.loc.x, boss.loc.y, 32, PI/4, boss));
      bossbullets.add(new BossBullet(boss.loc.x, boss.loc.y, 36, PI/8, boss));
      bossbullets.add(new BossBullet(boss.loc.x, boss.loc.y, 40, 0, boss));
      bossbullets.add(new BossBullet(boss.loc.x, boss.loc.y, 36, -PI/4, boss));
      bossbullets.add(new BossBullet(boss.loc.x, boss.loc.y, 32, -PI/8, boss));
      count++;
    }
    if (frameCount%2==0 && count > 5 && count <=54) {
      bossbullet2s.add(new BossBullet2(boss.loc.x, boss.loc.y, 18, 14, random(-.4, .4), boss));
      count++;
    }
    if (count == 55) {
      count = 0;
    }

    if (boss.contact(p)==true) { //when grunts hit Player, they disappear
      p.lives--;
    } 
    if (boss.hitList(bullets)==true) { //when bullets hit grunts, they disappear
      boss.lives-=2;
      score+=5;
      if (boss.lives <= 0) {
        score+=200;
        textSize(30);
        text("You Win", width/2-30, height/2-30, 120, 120);
        noLoop();
      }
    }
  }


  String Lives = "Lives: " + str(p.lives); //strings to be utilized in text
  String Score = "Score: " + str(score);

  textSize(20);
  text(Lives, 10, 10, 120, 120);
  text(Score, width-130, 10, 120, 120);


  if (p.hitList(bossbullets)==true) { //when bullets hit grunts, they disappear
    p.lives-=8;
  }
  if (p.ehitList(enemybullets)==true) { //when bullets hit grunts, they disappear
    p.lives-=3;
  }
  if (p.hit2List(bossbullet2s)==true) {
    p.lives-=1;
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
    BossBullet bb = bossbullets.get(i);
    bb.display();
    bb.move();

    if (bb.contactListBBullet(walls)) {
      bossbullets.remove(i);
    }

    if (level==-1) { //when level changes all bullets are erased
      bossbullets.remove(i);
    }
    if (bb.x<0 || bb.x>width || bb.y<0 || bb.y>height) { //when bullet hits wall it disappears
      bossbullets.remove(i);
    }
  }
  for (int i = bossbullet2s.size () -1; i>=0; i--) { //forLoop to create bullets
    BossBullet2 bb2 = bossbullet2s.get(i);
    bb2.display(boss);
    bb2.move();

    if (bb2.contactListB2Bullet(walls)) {
      bossbullet2s.remove(i);
    }
    if (level==-1) { //when level changes all bullets are erased
      bossbullet2s.remove(i);
    }
    if (bb2.x<0 || bb2.x>width || bb2.y<0 || bb2.y>height) { //when bullet hits wall it disappears
      bossbullet2s.remove(i);
    }
  }

  for (int i = enemybullets.size () -1; i>=0; i--) { //forLoop to create bullets
    EnemyBullet eb = enemybullets.get(i);
    eb.display();
    eb.move();

    if (eb.contactListEBullet(walls)) {
      enemybullets.remove(i);
    }

    if (level==-1 || level==-2 || level ==-3 || level ==-4 || level ==-5) { //when level changes all bullets are erased
      enemybullets.remove(i);
    }
    if (eb.x<0 || eb.x>width || eb.y<0 || eb.y>height) { //when bullet hits wall it disappears
      enemybullets.remove(i);
    }
  }

  //  for(Grunt e : grunts)
  //  {
  //    boolean r = false;
  //    phi=atan2(p.loc.y-e.loc.y, p.loc.x-e.loc.x); //rotation angle for enemies
  //    e.display();
  //    if (level==-1 || level==-2 || level ==-3 || level ==-4 || level ==-5) { //when bullets hit grunts, they disappear
  //      grunts.remove(e);
  //      r = true;
  //    }
  //    if (e.contact(p)==true) { //when grunts hit Player, they disappear
  //      if(!r)
  //        grunts.remove(e);
  //      r = true;
  //      p.lives-=6;
  //    } 
  //    if (e.hitList(bullets)==true) { //when bullets hit grunts, they disappear
  //      if(!r)
  //        grunts.remove(e);
  //      score+=10;
  //    }
  //    
  //    for(Wall w : walls)
  //    {
  //       if(e.contactGruntRight(w))
  //       {         
  //         wallRg = true;
  //       }
  //       
  //       else if(e.contactGruntLeft(w))
  //       {
  //         wallLg = true;
  //       }
  //       
  //       if(e.contactGruntUp(w))
  //       {
  //         wallUg = true;
  //       }
  //       
  //       else if(e.contactGruntDown(w))
  //       {
  //         wallDg = true;
  //       }
  //    }
  //    e.move();
  //  }

  for (int i = grunts.size () -1; i>=0; i--) { //forLoop to create grunts
    Grunt e = grunts.get(i);
    phi=atan2(p.loc.y-e.loc.y, p.loc.x-e.loc.x); //rotation angle for enemies
    e.display();
    if (level==-1 || level==-2 || level ==-3 || level ==-4 || level ==-5) { //when bullets hit grunts, they disappear
      grunts.remove(i);
    }
    if (e.contact(p)==true) { //when grunts hit Player, they disappear
      grunts.remove(i);
      p.lives-=6;
    } 
    if (e.hitList(bullets)==true) { //when bullets hit grunts, they disappear
      grunts.remove(i);
      score+=10;
    }

    PVector dir = new PVector(e.loc.x - p.loc.x, e.loc.y - p.loc.y); 

    for (Wall w : walls)
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

    //    if (!wallUg && !wallDg && !wallRg && !wallLg) {
    //      if (e.contactListGruntUp(walls)) { //When Player is moving up when it contacts wall
    //        wallUg=true;
    //      } else {
    //        wallUg=false;
    //      }
    //      if (e.contactListGruntDown(walls)) { //When Player is moving down when it contacts wall
    //        wallDg=true;
    //      } else {
    //        wallDg=false;
    //      }
    //      if (e.contactListGruntRight(walls)) { //When Player is moving right when it contacts wall
    //        wallRg=true;
    //      } else {
    //        wallRg=false;
    //      }
    //      if (e.contactListGruntLeft(walls)) { //When Player is moving left when it contacts wall
    //        wallLg=true;
    //      } else {
    //        wallLg=false;
    //      }
    //    }
    e.move();
  }
  for (int i = grunt2s.size () -1; i>=0; i--) { //forLoop to create grunts
    Grunt2 e2 = grunt2s.get(i);
    phi2=atan2(p.loc.y-e2.loc.y, p.loc.x-e2.loc.x); //rotation angle for enemies
    e2.display();
    
    if (level==-1 || level==-2 || level ==-3 || level ==-4 || level ==-5) { //when bullets hit grunts, they disappear
      grunt2s.remove(i);
    }
    if (e2.contact(p)==true) { //when grunts hit Player, they disappear
      grunt2s.remove(i);
      p.lives-=6;
    } 
    if (e2.hitList(bullets)==true) { //when bullets hit grunts, they disappear
      grunt2s.remove(i);
      score+=10;
    }
    if (e2.shoot(p)) {
      if (frameCount%30==0) {
        enemybullets.add(new EnemyBullet(e2.loc.x, e2.loc.y, 5, 0, e2));
      }
    }
    PVector dir = new PVector(e2.loc.x - p.loc.x, e2.loc.y - p.loc.y); 
   for (Wall w : walls)
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
    if (level==-1 || level==-2 || level ==-3 || level ==-4 || level ==-5) { //when bullets hit grunts, they disappear
      walls.remove(i);
    }
  }

  for (int i = healths.size () -1; i>=0; i--) {
    Health h = healths.get(i);
    h.display();
    if (h.contactPlayer(p)) {
      healths.remove(i);
      if (p.lives<=100-h.lives) {
        p.lives+=h.lives;
      }
      if (p.lives>100-h.lives) {
        p.lives=100;
      }
    }
  }

  for (int j = infos.size () -1; j>=0; j--) {
    Info z = infos.get(j);
    z.display();
    println("show the info");
    if (level==-1 || level==-2 || level ==-3 || level ==-4 || level ==-5) { //when bullets hit grunts, they disappear
      infos.remove(j);
    }
  }




  p.move();

  wallU = false;
  wallD = false;
  wallR = false;
  wallL = false;

  if (level == -1) { //objects to be loaded in the preparation level
    grunts.add(new Grunt(.434*width, .111*height, 0, 0, 50, 350));
    grunt2s.add(new Grunt2(.486*width, .111*height, 0, 0, 50, 350, 500));
    grunts.add(new Grunt(.538*width, .111*height, 0, 0, 50, 350));
    walls.add(new Wall(0, .444*height, .465*width, .056*height));
    walls.add(new Wall(.535*width, .444*height, width, .056*height));

    infos.add(new Info(.84*width, .447*height, "   Your archenemy, Dr. Diabolical, has stolen your Girlfriend again!! You need to enter his headquarters, defeat him and his robot minions, and resque her! First, defeat his 3 guards and enter the elevator to go to the next floor.", 40, 30));

    healths.add(new Health(200, 200, 10, 40));

    level = 1; //transition to actual level
  }

  if (level == -2) { //objects to be loaded in the preparation level\
    grunt2s.add(new Grunt2(.292*width, .333*height, 0, 0, 50, 300, 275));
    grunt2s.add(new Grunt2(.708*width, .333*height, 0, 0, 50, 300, 275));
    grunts.add(new Grunt(.431*width, .333*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.569*width, .333*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.153*width, .333*height, 0, 0, 50, 450));
    grunts.add(new Grunt(.847*width, .333*height, 0, 0, 50, 450));

    grunt2s.add(new Grunt2(.292*width, .555*height, 0, 0, 50, 300, 275));
    grunt2s.add(new Grunt2(.708*width, .555*height, 0, 0, 50, 300, 275));
    grunts.add(new Grunt(.431*width, .555*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.569*width, .555*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.153*width, .555*height, 0, 0, 50, 450));
    grunts.add(new Grunt(.847*width, .555*height, 0, 0, 50, 450));

    grunt2s.add(new Grunt2(.292*width, .778*height, 0, 0, 50, 300, 275));
    grunt2s.add(new Grunt2(.708*width, .778*height, 0, 0, 50, 300, 275));
    grunts.add(new Grunt(.431*width, .778*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.569*width, .778*height, 0, 0, 50, 200));
    grunts.add(new Grunt(.153*width, .778*height, 0, 0, 50, 450));
    grunts.add(new Grunt(.847*width, 7.778*height, 0, 0, 50, 450));

    walls.add(new Wall(.1042*width, .167*height, .361*width, .056*height));
    walls.add(new Wall(.535*width, .167*height, .361*width, .056*height));

    walls.add(new Wall(.1042*width, .389*height, .361*width, .056*height));
    walls.add(new Wall(.535*width, .389*height, .361*width, .056*height));

    walls.add(new Wall(.1042*width, .611*height, .361*width, .056*height));
    walls.add(new Wall(.535*width, .611*height, .361*width, .056*height));
    level = 2; //transition to actual level
  }

  if (level == -3) { //objects to be loaded in the preparation level

    for (int i = 0; i<=7; i++) {
      walls.add(new Wall(.052*width + .139*width*i, .133*height, .063*width, .1*height));
    }
    for (int i = 0; i<=7; i++) {
      walls.add(new Wall(.052*width + .139*width*i, .355*height, .063*width, .1*height));
    }
    for (int i = 0; i<=7; i++) {
      walls.add(new Wall(.052*width + .139*width*i, .577*height, .063*width, .1*height));
    }
    for (int i = 0; i<3; i++) {
      walls.add(new Wall(.052*width + .139*width*i, .8*height, .063*width, .1*height));
    }
    for (int i = 4; i<=7; i++) {
      walls.add(new Wall(.052*width + .139*width*i, .8*height, .063*width, .1*height));
    }


    for (int i = 0; i<=5; i++) {
      grunts.add(new Grunt(.1528*width + .139*width*i, .1833*height, 0, 0, 50, 250));
    }
    for (int i = 0; i<=5; i++) {
      grunt2s.add(new Grunt2(.1528*width + .139*width*i, .406*height, 0, 0, 50, 250, 500));
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

    walls.add(new Wall(.0694*width, .111*height, .0694*width, .777*height));
    walls.add(new Wall(.139*width, .111*height, .799*width, .111*height));
    walls.add(new Wall(.868*width, .111*height, .0694*width, .777*height));
    walls.add(new Wall(.0694*width, .777*height, .868*width, .111*height));

    grunts.add(new Grunt(.0347*width, .111*height, 0, 0, 50, 300));
    grunts.add(new Grunt(.0347*width, .222*height, 0, 0, 50, 300));
    grunts.add(new Grunt(.0347*width, .333*height, 0, 0, 50, 300));
    grunts.add(new Grunt(.0347*width, .444*height, 0, 0, 50, 300));
    grunts.add(new Grunt(.0347*width, .555*height, 0, 0, 50, 300));
    grunts.add(new Grunt(.0347*width, .666*height, 0, 0, 50, 300));
    grunts.add(new Grunt(.0347*width, .777*height, 0, 0, 50, 300));
    grunts.add(new Grunt(.0347*width, .888*height, 0, 0, 50, 300));

    grunts.add(new Grunt(.965*width, .111*height, 0, 0, 50, 300));
    grunts.add(new Grunt(.965*width, .222*height, 0, 0, 50, 300));
    grunts.add(new Grunt(.965*width, .333*height, 0, 0, 50, 300));
    grunts.add(new Grunt(.965*width, .444*height, 0, 0, 50, 300));
    grunts.add(new Grunt(.965*width, .555*height, 0, 0, 50, 300));
    grunts.add(new Grunt(.965*width, .666*height, 0, 0, 50, 300));
    grunts.add(new Grunt(.965*width, .777*height, 0, 0, 50, 300));
    grunts.add(new Grunt(.965*width, .888*height, 0, 0, 50, 300));

    level = 4; //transition to actual level
  }

  if (level == -5) { //objects to be loaded in the preparation level
    boss = new Boss(width/2, height/20, 0, 0, 50, 950, 200);
    walls.add(new Wall(.104*width, .111*height, .139*width, .056*height));
    walls.add(new Wall( .069*width, .167*height, .035*width, .222*height));
    level = 5; //transition to actual level
  }
  if (level == 5) {
    if (frameCount%12<=3) {
      image(hfwall1, .104*width, .111*height, .139*width, .056*height);
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

  p.display();   //PLAYER JUNK

  stroke(255, 0, 0);
  strokeWeight(3);
  line(mouseX-8, mouseY-8, mouseX-3, mouseY-3);
  line(mouseX-8, mouseY+8, mouseX-3, mouseY+3);
  line(mouseX+8, mouseY+8, mouseX+3, mouseY+3);
  line(mouseX+8, mouseY-8, mouseX+3, mouseY-3);
  stroke(0);
  strokeWeight(1);

  if (p.lives<=0) { //Game over 
    textSize(30);
    text("Game Over", width/2-30, height/2-30, 120, 120);
    noLoop();
  }
}

void mousePressed() {
  pShot.play();
  pShot = minim.loadFile("pshot2.mp3");
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

