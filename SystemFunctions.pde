class SystemFunctions {
  


  //menu bools
  boolean startGame;
  boolean gameOver;
  boolean retry = false;
  boolean backToMenu;
  boolean won;





  //collision detection varaibles
  boolean leftAlign;
  boolean rightAlign;
  boolean topAlign;
  boolean bottomAlign;

  //boolean that keeps the "jump to top of platform" piece of collision detection from working on 
  boolean isPlatform = false;
  boolean collided;
  boolean ranOnce = false;

  boolean hitFloor;
  boolean hitCeiling;
  boolean hitLeft;
  boolean hitRight;


  SystemFunctions() {
  }


  int collisionDetection( Platform initPlatform, PlayerCharacter initPlayerCharacter) {

    Platform platform = initPlatform;
    PlayerCharacter player = initPlayerCharacter;




    //aa bb collision detection if statement set that checks the other object's position in relation to the current one
    if ( platform.xPosition >=player.xPosition && platform.xPosition <=player.xPosition +player.objectWidth) rightAlign = true;

    if ( platform.xPosition + platform.objectWidth >=player.xPosition && platform.xPosition + platform.objectWidth <=player.xPosition +player.objectWidth) leftAlign = true;

    if ( platform.yPosition >=player.yPosition && platform.yPosition <=player.yPosition +player.objectHeight) topAlign = true;

    if ( platform.yPosition + platform.objectHeight >=player.yPosition && platform.yPosition + platform.objectHeight <=player.yPosition +player.objectHeight) bottomAlign = true;


    //aa bb collision detection if statement that checks the current object's position in relation to the other one
    if (player.xPosition >= platform.xPosition &&player.xPosition <= platform.xPosition + platform.objectWidth) leftAlign = true;

    if (player.xPosition +player.objectWidth >= platform.xPosition &&player.xPosition + platform.objectWidth <= platform.xPosition + platform.objectWidth) rightAlign = true;

    if (player.yPosition >= platform.yPosition &&player.yPosition <= platform.yPosition + platform.objectHeight) bottomAlign = true;

    if (player.yPosition +player.objectHeight > platform.yPosition &&player.yPosition +player.objectHeight < platform.yPosition + platform.objectHeight) topAlign = true;


    //if statement that turns the "collided" var true whenever there is any contact between this object and the other
    if ((leftAlign || rightAlign) && (topAlign ||bottomAlign))  collided = true;

    //if statement that resets all the collided vars to false when there is no contact between the two objects
    if ((!(leftAlign || rightAlign) || !(topAlign || bottomAlign)) || ranOnce) {
      collided = false;

      hitFloor = false;
      hitCeiling = false;
      hitLeft = false;
      hitRight = false;
    }



    //if statement that detects when the current object's right side is being hit
    if ((leftAlign && player.xPosition - (platform.xPosition + platform.objectWidth) == 0) && (topAlign || bottomAlign)) {// && (player.xPosition - (platform.xPosition + platform.objectWidth) >=0 &&player.xPosition - (platform.xPosition + platform.objectWidth) <=15))
      hitRight = true;
    }
    //if statement that detects when the current object's left side is being hit
    if ((rightAlign && platform.xPosition - (player.xPosition +player.objectWidth) == 0) && (topAlign || bottomAlign)) {// && (platform.xPosition - (player.xPosition +player.objectWidth) >=0 && platform.xPosition - (player.xPosition +player.objectWidth) <=15)
      hitLeft = true;
    }

    //if statement that detects when the current object's top side is being hit
    if ((bottomAlign)  && (leftAlign || rightAlign)) { //||  (yPosition - (platform.yPosition + platform.objectHeight) >=0 &&player.yPosition - (platform.yPosition + platform.objectHeight) <=15))

      //if statement that keeps the player object from getting stuck inside of platforms when falling onto them
      if (!isPlatform && (!hitLeft && !hitRight))
        player.yPosition = platform.yPosition + platform.objectHeight;
      hitCeiling = true;
    }

    //if statement that detects when the current object's bottom side is being hit
    if (((topAlign ) && (leftAlign || rightAlign))) { //|| (platform.yPosition - (yPosition +player.objectHeight) >=0 && platform.yPosition - (yPosition +player.objectHeight) <=5)


      //if statement that keeps the player object from getting stuck inside of platforms when jumping into the ceiling
      if (!isPlatform && (!hitLeft && !hitRight))
        player.yPosition = platform.yPosition -player.objectHeight;
      hitFloor = true;
    }





    //resets all the collision detection vars for next time
    topAlign = false;
    bottomAlign = false;
    rightAlign = false;
    leftAlign = false;

    if (hitFloor) return 1;
    if (hitRight) return 2;
    if (hitCeiling) return 3;
    if (hitLeft) return 4;
    else return 0;
  }


  void openingMenu() {

    textFont(font);

    textSize(30);


    if (!gameOver) {
      //Displays the main menu when the instruction page var is false
      if (!collided) {
        //textAlign(CENTER, BOTTOM);
        text("Welcome to Laser Sword Attack!!!", 10, 250);
        //textAlign(RIGHT);
        text("Start", 600, 300);

        text("Help", 600, 400);
        
        text("Quit", 600 ,500);
        if (mousePressed && (mouseX > 570 && mouseY> 370) && (mouseY < 500) && (mouseY > 400)) exit();
      }


      //displays instruction page when var is true
      if (collided) {
        textSize(20);
        text("Aim with the mouse, destroy all the blocks. Do so before running out of bullets to win", 50, 50, 500, 100);
        text("Back", 600, 550);

        //resets the instruction page select vars
        if (mousePressed && (mouseX > 570 && mouseY> 470) && mouseY < 600) {
          collided = false;
          hitCeiling = false;
        }
      }

      //if statement set that detects when menu option the player clicks and sets the first bool imediatly to true
      if (mousePressed && (mouseX > 570 && mouseY> 270) && mouseY < 300) hitFloor = true;

      if (mousePressed && (mouseX > 570 && mouseY> 370) && mouseY < 400) hitCeiling = true;
      
      

      //if else statement that sets the second bool to true once the mouse button has been released
      if (!mousePressed && hitCeiling) collided = true;

      else if (!mousePressed && hitFloor) {
        startGame = true;
        retry = true;
      }
    }
    
    
//game over screen displays when its bool is true
    if (gameOver) {
      if(won)
      text("You won!",10,300);
      else      
      text("Game Over", 10, 300);
      text("Try again?", 600, 300);
      text("Main Menu", 600, 500);
      
      //if statement set that detects when menu option the player clicks and sets the first bool imediatly to true
      if (mousePressed && (mouseX > 570 && mouseY> 270) && mouseY < 300) hitFloor = true;

      if (mousePressed && (mouseX > 570 && mouseY> 470) && mouseY < 500) hitCeiling = true;

      //if else statement that sets the second bool to true once the mouse button has been released
      if (!mousePressed && hitFloor) retry = true;

      else if (!mousePressed && hitCeiling) {
        gameOver = false;
        startGame = false;
        hitFloor = false;
        collided = false;
        hitCeiling = false;       
      }            
    }

    
    
  }
}