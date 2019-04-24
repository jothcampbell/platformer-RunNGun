class Bullet extends PhysicsObject {
  //the various booleans that control the explosion animation
  boolean shotOff = true;
  boolean explosionStart = false;
  boolean arrayFiller;

  //origin of the translation from which the bullets are rotated around
  int originX;
  int originY;

  //start and end points of the bullet line with relation to the origin of the rotate/translate matrix
  int bulletX;
  int bulletY;

  int damage = 1;


  //float that allows for mouse aiming
  float angle;

  //ints that store the converted x and y value of the bullet
  float trueX;
  float trueY;

  //float that determines the width of the spray of the bullets
  float sprayWidth = .07;

  boolean offScreen = false;

  //controls how fast the bullets move
  int speed = 20;

  //controls how long the bullets are
  int bulletLeangth = 25;
  int bulletWidth = 5;

  //provides radius for inner part of explosion
  int explosion = 0;


  //distance between bullets and the other objects
  int distanceBetween;

  //var for controlling how big the explosions get
  int explosionSize = 40;

  Bullet(int initX, int initY, boolean initArrayFiller, int shotType) {

    //for shot type, 1 is machine gun, 2 is shotgun, 3 is sniper, and default is pistol
    switch(shotType) {      
      //machine gune
    case 1:
      //in each of the cases, I define what 
      shotSound = minim.loadFile("smoothLaserShot.wav");
      explosionSound = minim.loadFile("explosionBetter.wav");
      sprayWidth = .07;
      speed = 20;
      damage = 2;
      break;

      //shotgun
    case 2:
      sprayWidth = .2;
      speed = 20;
      explosionSound = minim.loadFile("explosionBetter.wav");
      shotSound = minim.loadFile("shotgunShot.wav");
      break;

      //Sniper
    case 3:
      sprayWidth = 0;
      speed = 50;
      explosionSound = minim.loadFile("silence.mp3");
      shotSound = minim.loadFile("rifleShot.wav");
      break;
      
      //pistol
    default:
      sprayWidth = .03;
      speed = 20;
      shotSound = minim.loadFile("pistolShot.wav");
      explosionSound = minim.loadFile("singleBulletHit.mp3");
    }





    //determines the starting point from which the bullets' matrix will have its origin
    originX =initX;
    originY = initY;

    //puts the bullets' x and y at the origin and randomizes the xPosition so that when in shotgun mode the bullets aren't in a neat arc
    bulletX = int(random(-sprayWidth, sprayWidth)*100);
    bulletY = 0;

    //keeps the array filler bullets from interfereing with the game
    arrayFiller = initArrayFiller;

    //loads the sound file for each bullet individually for the explosion and shot sound effect



    //since the arcsin function has a range of 0 to PI, it only convers half a circle. This if/else determines which half to do depending on which side of the initial point the mouse is
    if (mouseX - initX < 0) angle = -asin((mouseY - initY)/sqrt(pow(mouseX - initX, 2)+pow(mouseY - initY, 2))) + PI + random(-sprayWidth, sprayWidth);

    else  angle = asin((mouseY - initY)/sqrt(pow(mouseX - initX, 2)+pow(mouseY - initY, 2))) + random(-sprayWidth, sprayWidth);

    objectWidth = 1;
    objectHeight = 1;
  }


  void display() {
    pushMatrix();
    translate(originX, originY);
    rotate(angle);
    //fill(255);

    //bullet is a line while it isn't exploding
    if (!explosionStart) {
      fill(0);
      rect(bulletX, bulletY, bulletLeangth, bulletWidth);
    }

    //chagnes to an ellipse when it goes explosionStart (explosion start var)
    else {
      fill(255, 171, 0);
      ellipse(bulletX + bulletLeangth/2, bulletY, bulletLeangth, bulletLeangth);
    }


    fill(255);
    if (bulletLeangth > explosionSize/4) {
      ellipse(bulletX + bulletLeangth/2, bulletY, explosion, explosion);
    }

    popMatrix();
  }




  void shoot() {                
    if (mousePressed) {
      //shotSound.play();
      //if(!shotSound.isPlaying())shotSound.rewind();
    }     
    //with the movement code for the bullets dependent on the explosion control var, the explsoin ellipses won't keep moving at the same speed as the bullets
    if (shotOff && !arrayFiller) {
      bulletX += speed;
    }    

    //resets the movement initializing variable when the key is no longer being pressed
    if (abs(bulletX) > width*2 || abs(bulletY) > height*2) {
      offScreen = true;
      
    }



    //converting  the angle and bullletX position into the real coordinate system to use for the collision detection
    trueY = sin(angle)*bulletX + originY;
    trueX = cos(angle)*bulletX + originX;
    yPosition = trueY;
    xPosition = int(trueX);
    
    //gets rid of the loaded sound file when the bullet exits the game to keep the memory usage low
    if(offScreen){
      shotSound = null;
      //explosionSound = null;
    }
  }




  void explode() {//int otherObjectX, int otherObjectY) {
    //distanceBetween = int(sqrt(pow(originX - otherObjectX, 2)+pow(originY - otherObjectY, 2)));




    //right now its set to explode when the bullet gets 300 pixels away from thier origin
    //the shotOff acts as the control variable to make this start of explosion code run once
    if ( collided && shotOff) {
      explosionSound.play();
      explosionStart = true;
      shotOff = false;
      bulletLeangth = 0;
      //explosion.play();
    }

    //the bulletLeangth var is used as the radius of the explosion, and thus set to 0 is incremented to have the exlposion ellipse expand once a frame until it gets bigger than the explosionSize var
    if (bulletLeangth < explosionSize && explosionStart) {
      bulletLeangth +=5;
    }
    //inner explosion ellipse starts expanding when the radius of the first circle is 1/4th the size of the max explosion radius
    else if ((explosion <= explosionSize && bulletLeangth > explosionSize/4) && explosionStart) {
      explosion += 5;
    }

    //"turns off" the explosion elipses when the other else ifs are done and turn false
    else if (explosionStart) {
      bulletLeangth = 0;
      explosion = 0;
      yPosition = height*3;
      collided = false;
      //bulletX = 0;
      //bulletY = 0;
      //originX = -500;
      //originY = -500;
      explosionStart = false;
      offScreen = true;
      

    }
  }
}