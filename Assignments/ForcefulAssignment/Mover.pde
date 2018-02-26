//Mover class
class Mover {

  //set PVectors for location, velocity and acceleration variables
  PVector location;
  PVector velocity;
  PVector acceleration;
  //mass float variable
  float mass;
  //color variable to store color input
  color c;
  //PImage variable to store pink gummy bubble image
  PImage bubbleImg;

  //first constructor (for snowballs)
  Mover(float massInput, PVector locationInput, color colorInput) {
    //set mass, location and color values
    mass = massInput;
    location = locationInput;
    //velocity and acceleration start at 0
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    c = colorInput;
  }

  //second constructor (for main mover - pink gummy)
  Mover(int massInput, PVector locationInput, PImage imageInput) {
    //set mass and location values
    mass = massInput;
    location = locationInput;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    //set gummy image file to bubbleImg variable
    bubbleImg = imageInput;
  }

  //this function displays the PImage on the canvas
  void displayImage() {
    //set x and y location to be at center point of image
    imageMode(CENTER);
    //display image
    image(bubbleImg, location.x, location.y);
    //resize to make it smaller
    bubbleImg.resize(60, 60);
  }

  // Newton’s second law.
  void applyForce(PVector force) {
    //[full] Receive a force, divide by mass, and add to acceleration.
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  //update object's velocity, acceleration and location over time
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    //clear the acceleration every time to add next value
    acceleration.mult(0);
  }

  //this function displays the snowballs on the canvas
  void display() {
    noStroke();
    fill(c);  
    //scaling mass according to size
    ellipse(location.x, location.y, mass*16, mass*16);
  }

  //this function makes sure the object stays within the canvas dimensions.
  void checkEdges() {
    //check the x location
    if (location.x > width) {
      location.x = width;
      //change velocity direction and location to make it bounce back
      velocity.x *= -1;
    } else if (location.x < 0) {
      //change velocity direction and location to make it bounce back
      velocity.x *= -1;
      location.x = 0;
    }
    //check the y location
    if (location.y > height) {
      //change velocity direction and location to make it bounce back
      velocity.y *= -1;
      location.y = height;
    } else if (location.y < 0) {
      //change velocity direction and location to make it bounce back
      velocity.y *= -1;
      location.y = 0;
    }
  }

  //this function is called when the user presses the arrow keys
  void pressedKeys() {
    //it is used to direct the pink gummy and move it
    if (key == CODED) {
      //move position to the left with left arrow key
      if (keyCode == LEFT) {
        location.x -= 3;
        location.y += 0;
      }
      //move position to the right with right arrow key
      else if (keyCode == RIGHT) {
        location.x += 3;
        location.y += 0;
      } 
      //move position up with up arrow key
      else if (keyCode == UP) { 
        location.x += 0;
        location.y -= 3;
      } 
      //move position down with down arrow key
      else if (keyCode == DOWN) {
        location.x += 0;
        location.y += 3;
      }
    }
  }

  //this function checks to see if a mover object is passing through a black cloud
  //returns boolean value
  boolean isInsideOil(Oil spill) {
    //returns true if it is in the same position as the black cloud's position
    if (location.x >(spill.middlePointX - 100) && location.x < (spill.middlePointX + 100) 
      && location.y>(spill.middlePointY - 75) && location.y<(spill.middlePointY + 75)) {
      return true;
    } 
    //returns false otherwise
    else {
      return false;
    }
  }

  //this function checks to see if a mover object is passing through the ice puddle
  //returns boolean value
  boolean isInsideIce(Ice block) {
    //returns true if it is in the same position as the ice puddle's position
    if (location.x >(block.middlePointX - 100) && location.x < (block.middlePointX + 100) 
      && location.y>(block.middlePointY - 10) && location.y<(block.middlePointY + 10)) {
      return true;
    } 
    //returns false otherwise
    else {
      return false;
    }
  }

  //this function is used to accelerate the velocity of the object passing through the
  //ice puddle (slide effect) - less friction
  void slide(Ice blockTest) {
    //get the velocity value and store it in a new PVector variable
    PVector boost = velocity.get();
    float normal = 1;  

    //get magnitude of friction using formula
    float boostMag = blockTest.c*normal;
    
    //multiply and normalize
    boost.mult(1);
    boost.normalize();

    //multiply PVector by magnitude to get the force vector
    boost.mult(boostMag);
    
    //call apply force to apply the friction force
    applyForce(boost);
  }

  //this function is used to slow down the velocity of the object passing through the
  //oil - black cloud (thick liquid effect) - more friction
  void drag(Oil spillTest) {
    //get magnitude of velocity PVector
    float speed = velocity.mag();
    // Get force’s magnitude: Cd * v~2~
    float dragMagnitude = spillTest.c * speed * speed;
    
    //get velocity variable
    PVector drag = velocity.get();
    //multiply by -1 to chnage force's direction
    drag.mult(-1);
    //normalize
    drag.normalize();

    //multiply magnitude and direction together.
    drag.mult(dragMagnitude);

    // Apply the force.
    applyForce(drag);
  }

  //this function is called when a snowball and the main gummy are in the same location
  //this function attracts the snowball to the gummy's location 
  void attract(Mover test) {
    //store gummy's location in PVector variable
    PVector gummyLoc = new PVector(location.x, location.y);
    
    //subtract the vectors of the gummy to the snowballs locations and store it in variable 
    PVector dir = PVector.sub(gummyLoc, location);
    // Normalize.
    dir.normalize();
    // Scale.
    dir.mult(0.5);
    // Set to acceleration.
    acceleration = dir;
    
    //update snowball's new x and y location
    test.location.x = location.x;
    test.location.y = location.y;
    //Change and update acceleration and location
    test.velocity.add(acceleration);
    //limit magnitude to 4
    test.velocity.limit(4);
    test.location.add(velocity);
  }

 //this function check to see if the pink gummy has "touched" a snowball (have the same location)
 //it returns a boolean value
  boolean hasTouchedMainCircle(Mover circleTouched) {
    //returns true if gummy is in the same position as the still snowball
    if ((circleTouched.location.x > (location.x -30 )) && (circleTouched.location.x < (location.x + 30)) 
      && (circleTouched.location.y > (location.y -30 ))  && (circleTouched.location.y < (location.y + 30))) {
      return true;
    } 
    //returns false otherwise
    else {
      return false;
    }
  }
}