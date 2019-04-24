import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;


//import processing.sound.*;




//set of for loop incrementing vars 
int i;
int k = 0;
int h;


//the font, sound effects, and other aesthetic variables
AudioPlayer shotSound;
AudioPlayer explosionSound;
AudioPlayer jumpSound;
AudioPlayer reloadSound;
Minim minim = new Minim(this);

PImage gunSprite;
PImage background;
PImage playerSprite;
PImage blockSprite;
PFont font;
//keeps the collision detection hit vars from reseting until the for loop ends so that the collision detection will work on other platforms in the array
boolean loopDone =true;

SystemFunctions sys = new SystemFunctions();

boolean hitFloor;
boolean hitCeiling;
boolean hitLeft;
boolean hitRight;
boolean ranOnce;

//controls the for loop that does the shotgun mode
int j = 0;

//boolean that keeps the bullet generating if statement from running constantly
boolean fire = true;

//int controls the rate of automatic fire
int rateOfFire;
//int that allows automatic fire
int autoShot;

//int var that determines what kind of bullet the player will shoot
int weaponType = 1;
String weaponName = "minigun.jpg";
String reloadName = "silence.mp3";

//player character object defined
PlayerCharacter player1 = new PlayerCharacter(550, 200);

//platform array
int platformNumber = 18;
Platform[] platforms = new Platform[platformNumber];

//bullet array and number
int bulletNumber = 35;
Bullet[] bullets = new Bullet[bulletNumber];

//keeps track of how many bullets the player has left
int bulletsLeftDefault = 30;
int bulletsLeft = bulletsLeftDefault;

//keeps track of how many platforms the player has left
int platformsLeft = platformNumber * 5;


void setup() {

  //prints available fonts on this computer
  //printArray(PFont.list());



  //sets screen size
  size(960, 600);

  //assigns font type of menues
  font = createFont("HomeRem.ttf", 30);

  //assign sound effect vars to their sound. all the sounds I found on Freesound.org
  explosionSound = minim.loadFile("explosionBetter.wav");
  shotSound = minim.loadFile("smoothLaserShot.wav");
  jumpSound = minim.loadFile("jump.mp3");
  reloadSound = minim.loadFile("silence.mp3");

  //gun sprite I found on pintrest :https://www.reddit.com/r/NuclearThrone/comments/39qbv4/more_tf2_sprites/?st=iwgygtx6&sh=c98e33d9
  gunSprite = loadImage("minigun.jpg");
  //the robot player character sprite is from http://vignette2.wikia.nocookie.net/castlevania/images/b/b3/KD_Master_Robot_Sprite.jpg/revision/latest?cb=20100620155854
  playerSprite = loadImage("robotSprite.jpg");

  //background I found at https://lhsgd.wikispaces.com/file/view/Pixel-Art-Game-Background-Example-320x200.jpg/540404034/Pixel-Art-Game-Background-Example-320x200.jpg
  background = loadImage("background.jpg");
}



void draw() {


  //
  //noStroke makes for a cleaner look
  noStroke();
  //switching to radius mode makes the explosion's center be at the point where contact is made rather than the explosion's edge
  ellipseMode(RADIUS);  
  //sets background to white and fill to black
  background(255);  
  fill(0);
  imageMode(CORNER);



  //displays the opening menu when its startGame bool is false
  if (!sys.startGame) sys.openingMenu();




  //resets all the arrays when the player clicks reset in the game over menu
  if (sys.retry) {
    //fills the bullet array and puts them offscreen
    for (i = 0; i < bulletNumber; i ++) {
      bullets[i] = new Bullet(-500, 500, true, 0);
    }

    //resets the row and collumn vars for the platform setup array
    j=0;
    k=0;

    //fills platform array and places them in a grid formation
    for (i = 0; i < platformNumber; i ++) {
      platforms[i] = new Platform(200 + 100*k, 100 * j);

      //every 5 platforms the row number var increments one, while the collumn var resets back to 0
      k ++;
      if (k > 5) {
        j ++;
        k = 0;
      }
    }


    //puts PC back into original spot
    player1 = new PlayerCharacter(960/2, 530-90);


    //platformsLeft = platformNumber;
    //resets the menu control and win/lose vars
    bulletsLeft = bulletsLeftDefault;
    sys.startGame = true;
    sys.retry = false;
    sys.won = false;
    ranOnce = false;

    //resets the sound vars to keep memory usage down
    shotSound = null;
    explosionSound = null;
    j=1;
  }





  // displays the game itself when the menu's starGame bool is true
  if (sys.startGame) {





    //displays the background while the game is running
    image(background, 0, 0);

    textSize(20);
    text(" Ammo:" + bulletsLeft, 20, 20);

    //since the platformsLeft var gets decremented each time the for loop is run, it has to be reset before the loop
    platformsLeft = platformNumber;

    //for loop that runs the platform array through the player character and bullet collision detection code
    for (i = 0; i < platformNumber; i++) {



      //shows each platform in the array
      platforms[i].display();

      //for loop that puts the bullets and platforms in their mutual collision detection methods
      for (h = 0; h < bulletNumber; h++) {
        //makes sure that collision from the player character won't affect the hitByBulllet if statement
        platforms[i].collided = false;

        //bullets and platforms take collision detection data from eachother
        bullets[h].collisionDetection(platforms[i].xPosition, platforms[i].yPosition, platforms[i].objectWidth, platforms[i].objectHeight, false);
        platforms[i].collisionDetection(bullets[h].xPosition, bullets[h].yPosition, bullets[h].objectHeight, bullets[h].objectWidth, true);

        //every time a bullet hits a platform, that platforms health, kept track by the hitByBullet int, is decremented
        if ((platforms[i].collided && bullets[h].collided)) {
          platforms[i].hitByBullet -= bullets[h].damage;
          //platformsLeft--;
        }
      }

      //if/else pair that keeps the loopDone var from switching true until the loop is done. The loopDone var in turn keeps the collision detection hit vars from reseting until the loop is done
      if (i > platformNumber -1) loopDone = true;           
      else loopDone = false;

      //collision detection methods for platforms and player character 
      player1.collisionDetection(platforms[i].xPosition, platforms[i].yPosition, platforms[i].objectWidth, platforms[i].objectHeight, loopDone);




      //keeps the PC from falling through the platforms when it's in contact with more than one
      sys.ranOnce = true;
      sys.collisionDetection(platforms[i], player1);
      sys.ranOnce = false;

      //println(sys.collisionDetection(platforms[i], player1));
      platforms[i].collisionDetection(player1.xPosition, player1.yPosition, player1.objectWidth, player1.objectHeight, true);

      //if statement that checks if the platform has been removed from play, and decrements a var if it has. If it counts all the way down, then the menu control if statements direct the menu to display the win screen
      if (platforms[i].yPosition > height) platformsLeft --;
    }




    //after the collision detection for loop gathers the data, the animate and fall methods are run for the player character
    player1.animate();
    player1.fall();
    //resets the collision detection hit vars after the for loop is done
    player1.collisionDetection(1, 2*height, 1, 1, true);





    //switch statement that allows for weapon selection
    switch(key) {
      //minigun
    case '1': 
      //changes the weponType var so that the bullet will change its properties to match
      weaponType = 1;
      //changes the sprite name used in the PC object
      weaponName = "minigun.jpg";    
      reloadName = "silence.mp3";
      reloadSound = minim.loadFile(reloadName);
      break;
      //shotgun
    case '2': 
      weaponType = 2;
      weaponName = "shotgun.jpg";
      //reloadName = "shotgunReload.mp3";
      reloadName = "silence.mp3";
      reloadSound = minim.loadFile(reloadName);
      println("this is VERY a problem switch");
      break;
      //sniper
    case '3': 
      weaponType = 3;
      weaponName = "sniper.jpg";
      reloadName = "sniperReload.mp3";
      reloadSound = minim.loadFile(reloadName);
      break;
      //pistol
    case '4': 
      weaponType = 4;
      weaponName = "pistol.jpg";
      reloadName = "silence.mp3";
      reloadSound = minim.loadFile(reloadName);
      break;
      //the default is do nothing, because otherwise the move keys would interfere
    default: 
      // println("this is not a problem");
      break;
    }

    j = 0;
    println(j);



    //resets the incrementing var when all the bullets have been shot so that the bullet making if statement doesn't put in out of bounds intex numbers
    if (k >= bulletNumber-1) k = 0;

    //makes the new bullet and increments the k var so that it will move to the next index in the array when making the new bullet
    if (mousePressed && fire) {

      //the k var moves the bullet selection in the array up one so that all the arrays are used
      k++;
      //keeps this code from running continuosly
      fire = false;

      //resets the timer var whenever a shot is fired so that the time given from last shot fired is accurate
      autoShot = 0;

      //for shot type, 1 is machine gun, 2 is shotgun, 3 is sniper, and default is pistol
      switch(weaponType) {
        //machine gun
      case 1:
        bullets[k] = new Bullet(player1.xPosition  + player1.objectWidth/2, int(player1.yPosition) + player1.objectHeight/2, false, weaponType);//  
        rateOfFire = 5;
        bulletsLeft--;
        shotSound.play();
        break;

        //shotgun
      case 2:

        ranOnce = true;

        //for loop that fires a cluster of bullets in a shotgun formation
        for ( j = k -1; (j < k+9) && bulletsLeft > 0; j++) {

          bulletsLeft --;
          bullets[j] = new Bullet(player1.xPosition + player1.objectWidth/2, int(player1.yPosition) + player1.objectHeight/2, false, weaponType);

          if (ranOnce) {
            shotSound.play();
            ranOnce = false;
          }
        }
        k = j;

        rateOfFire = 60;

        break;

        //sniper       
      case 3:
        //since the sniper bullet uses 5 ammo, an if statement makes sure that the bullet won't get shot if the player has less than 5 ammo
        if (bulletsLeft -5 >= 0) {
          bullets[k] = new Bullet(player1.xPosition + player1.objectWidth/2, int(player1.yPosition) + player1.objectHeight/2, false, weaponType);
          rateOfFire = 120;
          bulletsLeft-= 5;
          shotSound.play();
        }
        break;


        //pistol
      default:
        bullets[k] = new Bullet(player1.xPosition + player1.objectWidth/2, int(player1.yPosition) + player1.objectHeight/2, false, weaponType);
        rateOfFire = 20;
        shotSound.play();
        bulletsLeft--;
      }
    }

    //constantly incrementing var keeps track of how much time has passes since the last shot was fired
    autoShot ++;

    //

    //allows for "reload time" by keeping track of the timer var. When more time has passes than the rate of fire var given in the weapon select, then another shot can be fired. not before.
    if (( autoShot > rateOfFire) && bulletsLeft > 0) {
      fire = true;
      reloadSound.rewind();
      //println(k);
    }

    //makes the reload sound effect play whenever a bullet has been shot
    if (autoShot == 20) {
      reloadSound.play();
    }



    //initiates bullet movement
    //if statement keeps the last bullet shot from going twice as fast from being "shot" by both this method and the method inside the for loop
    if (mousePressed)
      //bullets[k].shoot();
      bullets[k].display();


    //keeps the bullets from dissapearing when more than one is fired at once 
    for (i = 0; i < bulletNumber; i ++) {
      if (bullets[i] != null) {
        bullets[i].explode();
        bullets[i].shoot();
        bullets[i].display();
      }
    }

    //if statements that direct the menus to win/lose screens 
    //redirects code to menu function, and inside the menu funtion  directs it to display game over page
    if ( bulletsLeft <= 0 && autoShot > 100) {
      sys.startGame = false;
      sys.gameOver = true;
    }

    //if the decrement var is 0, then all the targets must have been removed, direct menu to display win screen
    else if (platformsLeft == 0) {
      sys.startGame = false;
      sys.gameOver = true;
      sys.won = true;
    }
    //println(autoShot);
  }
}