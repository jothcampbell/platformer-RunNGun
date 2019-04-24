class PlayerCharacter extends PhysicsObject {
  int health = 3;
  int damage;
  int[] inventory = new int[5];
  int weaponType;



  //speed vars, with some hopefull things for powerups and wall jumps
  int baseSpeed = 10;
  int speed = baseSpeed;
  int direction;
  int wallJumpModifier = 0;

  float angle;

  //coordinate vars are handled in the parent class    
  boolean jumpStop = true;
  int fill;

  PlayerCharacter(int initX, int initY) {
    yPosition = initY;
    xPosition = initX;
    objectHeight = 90;
    objectWidth = 90;
    fill = 255;
  }

  void animate() {    
    if (mouseX - xPosition < 0) {
      angle = -asin((mouseY - yPosition)/sqrt(pow(mouseX - xPosition, 2)+pow(mouseY - yPosition, 2))) + PI;
      gunSprite = loadImage("flipped" + weaponName);
    } else {
      angle = asin((mouseY - yPosition)/sqrt(pow(mouseX - xPosition, 2)+pow(mouseY - yPosition, 2)));
      gunSprite = loadImage(weaponName);
    }




    //draws rectangle inside a matrix at the point and dimensions specified by predefinded variables
    pushMatrix();
    //if (landed) fill(255,0,0);
    // if (hitRight) fill(0,255,0);
    // if (hitTop) fill(0,0,255);
    // if (hitLeft) fill(255,255,0);
    fill(0);

    translate(xPosition, yPosition);
    imageMode(CORNER);
    rect(0, 0, objectWidth, objectHeight);
    //image(playerSprite, 0, 0);


    pushMatrix();
    imageMode(CENTER);
    translate(objectWidth/2, objectHeight/2);
    rotate(angle);
    image(gunSprite, 0, 0);//-objectWidth/2, -objectHeight/2);
    popMatrix();
    popMatrix();

    if (keyPressed) {
      //if (key != 'w')speed = baseSpeed + wallJumpModifier;
      if ((key == 'a' && !hitRight) && !(xPosition <0)) xPosition -= speed; // (!hitLeft && landed)
      if ((key == 'd' && !hitLeft) && !(xPosition + objectWidth > width)) xPosition += speed; //(!hitRight && landed)




      //makes the block jump, and decrements the multi-jumpz var
      if ((jumpStop && key == 'w')) {// && (!hitCeiling)) {

        jumpSound = minim.loadFile("jump.mp3");
        time = 0;
        velocity = -10;
        jumpsLeft --;
        jumpStop = false;
        jumpSound.play();

        //keeps the player from getting stuck on the floor of platforms
        hitFloor = false;
      }
    }

    //else if (!keyPressed && speed > 0) speed =0;

    //xPosition += speed * direction;

    //only allows the jump code once per key press, and only as long as the multi jump var hasn't been used up
    if (!keyPressed && jumpsLeft > 0) jumpStop = true;
  }
}