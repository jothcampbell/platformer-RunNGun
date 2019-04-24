class PhysicsObject {

  //physics variables
  float yPosition;
  int velocity = 0;
  int acceleration = 2;
  float time;

  //multiple jump limit variables
  int numberOfJumps = 5;
  int jumpsLeft = numberOfJumps;

  //collision detection varaibles
  boolean leftAlign;
  boolean rightAlign;
  boolean topAlign;
  boolean bottomAlign;

  //boolean that keeps the "jump to top of platform" piece of collision detection from working on 
  boolean isPlatform = false;

  boolean ranOnce = false;

  boolean hitFloor;
  boolean hitCeiling;
  boolean hitLeft;
  boolean hitRight;

  int xPosition;
  //yPosition is already handled in the physics varaibles
  boolean collided;
  int objectHeight;
  int objectWidth;

  //stops object from getting stuck in the ceiling when it hits it
  boolean roofStop = false;

  void fall() {

    //adds the velocity function to the position value    
    yPosition += time*acceleration + velocity;    
    time = time + .1;

    //stops object if it on the bottom of the screen or if its on a platform
    if (yPosition >= 530 - objectHeight || (hitFloor && (!hitLeft && !hitRight))) { //(landed && !(hitLeft || hitRight))

      //resets the multi-jump var whenever the player lands
      jumpsLeft = numberOfJumps;

      //stops object from falling when it hits the floor
      time = 0;
      velocity = 0;
      if(yPosition >= 530 - objectHeight) yPosition = 530 - objectHeight;
    }   

    //stops object when it hits the ceiling
    if (((hitCeiling) && roofStop)){//&& (!hitLeft && !hitRight)) {// 
      time = 0;
      velocity = 0;
      roofStop = false;
      //yPosition = otherObjectY - objectHeight;
    }

    if (!hitCeiling) roofStop = true;
    //println(time*acceleration + velocity);
  }


  void collisionDetection(int otherObjectX, float otherObjectY, int otherWidth, int otherHeight, boolean loopDone) {// boolean loopDone


    //aa bb collision detection if statement set that checks the other object's position in relation to the current one
    if ( otherObjectX >= xPosition && otherObjectX <= xPosition + objectWidth) rightAlign = true;

    if ( otherObjectX + otherWidth >= xPosition && otherObjectX + otherWidth <= xPosition + objectWidth) leftAlign = true;

    if ( otherObjectY >= yPosition && otherObjectY <= yPosition + objectHeight) topAlign = true;

    if ( otherObjectY + otherHeight >= yPosition && otherObjectY + otherHeight <= yPosition + objectHeight) bottomAlign = true;


    //aa bb collision detection if statement that checks the current object's position in relation to the other one
    if ( xPosition >= otherObjectX && xPosition <= otherObjectX + otherWidth) leftAlign = true;

    if ( xPosition + objectWidth >= otherObjectX && xPosition + otherWidth <= otherObjectX + otherWidth) rightAlign = true;

    if ( yPosition >= otherObjectY && yPosition <= otherObjectY + otherHeight) bottomAlign = true;

    if ( yPosition + objectHeight > otherObjectY && yPosition + objectHeight < otherObjectY + otherHeight) topAlign = true;


    //if statement that turns the "collided" var true whenever there is any contact between this object and the other
    if ((leftAlign || rightAlign) && (topAlign ||bottomAlign))  collided = true;



    //if statement that resets all the collided vars to false when there is no contact between the two objects
    if ((!(leftAlign || rightAlign) || !(topAlign || bottomAlign)) && loopDone) {
      collided = false;

      hitFloor = false;
      hitCeiling = false;
      hitLeft = false;
      hitRight = false;
    }

    //if statement that detects when the current object's right side is being hit
    if ((leftAlign && (xPosition - (otherObjectX + otherWidth) >=0 && xPosition - (otherObjectX + otherWidth) <=15)) && (topAlign || bottomAlign)) {
      hitRight = true;
      //if (!isPlatform && (!hitCeiling && !hitFloor))xPosition = otherObjectX + otherWidth;
    }
    //if statement that detects when the current object's left side is being hit
    if ((rightAlign && (otherObjectX - (xPosition + objectWidth) >=0 && otherObjectX - (xPosition + objectWidth) <=15)) && (topAlign || bottomAlign)) {
      hitLeft = true; 
      //if (!isPlatform && (!hitCeiling && !hitFloor))xPosition = otherObjectX - objectWidth;
    }

    //if statement that detects when the current object's top side is being hit
    if ((bottomAlign)  && (leftAlign || rightAlign)) { //||  (yPosition - (otherObjectY + otherHeight) >=0 && yPosition - (otherObjectY + otherHeight) <=15))

      //if statement that keeps the player object from getting stuck inside of platforms when falling onto them
      if (!isPlatform && (!hitLeft && !hitRight)){
        yPosition = otherObjectY + otherHeight;
      }
      hitCeiling = true;
    }

    //if statement that detects when the current object's bottom side is being hit
    if (((topAlign ) && (leftAlign || rightAlign))) { //|| (otherObjectY - (yPosition + objectHeight) >=0 && otherObjectY - (yPosition + objectHeight) <=5)


      //if statement that keeps the player object from getting stuck inside of platforms when jumping into the ceiling
      if (!isPlatform && (!hitLeft && !hitRight))
        yPosition = otherObjectY - objectHeight;
      hitFloor = true;
    }



    
    //resets all the collision detection vars for next time
    topAlign = false;
    bottomAlign = false;
    rightAlign = false;
    leftAlign = false;
  }
}