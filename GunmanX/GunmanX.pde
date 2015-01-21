ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Grunt> grunts = new ArrayList<Grunt>();
ArrayList<Wall> walls = new ArrayList<Wall>();
ArrayList<Boss> bosses = new ArrayList<Boss>();

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

PImage Poster;

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
  Poster = loadImage("Poster.png");
}

void draw() {
  background(255);
  image(Poster,0,0,width,height);
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

    if (p.loc.x >= 600 && p.loc.x <= 850 && p.loc.y <= 60) {
      level = -2;
    }
  }

  if (level==2) { // actual level
    background(#989898);


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
    if (level==-1 || level==-2) { //when level changes all grunts are erased
      grunts.remove(i);
    }
    if (e.contact(p)==true) { //when grunts hit Player, they disappear
      grunts.remove(i);
      lives--;
    } 
    if (e.hitList(bullets)==true) { //when bullets hit grunts, they disappear
      grunts.remove(i);
      score+=10;
    }
  }

  for (int i = bosses.size () -1; i>=0; i--) { //forLoop to create grunts
    Boss b = bosses.get(i);
    phi=atan2(p.loc.y-b.loc.y, p.loc.x-b.loc.x); //rotation angle for enemies
    b.display();
    b.move();
    if (level==-1 || level==-2) { //when level changes all grunts are erased
      bosses.remove(i);
    }
    if (b.contactList(bosses)==true) { //when grunts hit Player, they disappear
      bosses.remove(i);
      lives--;
    } 
    if (b.hitList(bullets)==true) { //when bullets hit grunts, they disappear
      bosses.remove(i);
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
    if (level==-1 || level==-2 || level ==-3 || level ==-4) { //when bullets hit grunts, they disappear
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



    level = 3; //transition to actual level

    if (lives==0) { //Game over 
      textSize(30);
      text("Game Over", width/2-30, height/2-30, 120, 120);
      noLoop();
    }
  }
  if (level == -4) { //objects to be loaded in the preparation level
    grunts.add(new Grunt(625, 100, 0, 0, 50, 350));
    grunts.add(new Grunt(700, 100, 0, 0, 50, 350));
    grunts.add(new Grunt(775, 100, 0, 0, 50, 350));
    walls.add(new Wall(0, 400, width/2-50, 50));
    walls.add(new Wall(width/2+50, 400, width, 50));

    p.loc.y=height-200; //new player positions
    p.loc.x=width-200;
    level = 1; //transition to actual level
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

