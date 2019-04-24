class Platform extends PhysicsObject {
  //At the moment, all the nescessary vars are in the parent class
  //I'll add some vars to enable crumble and spike platforms later
  
  //boolean hitByBullet = false;
  int hitByBullet = 5;

  PImage platformSprite;






  Platform(int initX, int initY) {
    yPosition = initY;
    xPosition = initX;
    objectHeight = 50;
    objectWidth = 50;
    isPlatform = true;
    
    platformSprite = loadImage("platfromSprite.png");
    
    
    //load the sprite that I got from http://www.mariowiki.com/images/archive/f/f9/20150913110922%21SMM-SMB-Spikes.png
  }

  void display() {
    pushMatrix();
    
    //moves platform off screen when it runs out of health
    if(hitByBullet < 0) yPosition = height*2;
    
    //changes color when the player object lands on the platform
    if (collided) fill(213,0,253);
            
    else fill(0);
    translate(xPosition, yPosition);
    //rect(0, 0, objectWidth, objectHeight);
    image(platformSprite, 0, 0, objectHeight, objectWidth);
    popMatrix();
  }
}