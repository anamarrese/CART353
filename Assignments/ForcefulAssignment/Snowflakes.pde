//Snowflakes class
class Snowflakes {

  //set PVectors for location, velocity and acceleration variables
  PVector location;
  PVector velocity;
  PVector acceleration;
  //mass float variable
  float mass;
  //PImage variable to store snowflake image
  PImage snowflakeImg;

  //constructor
  Snowflakes(int massInput, PVector locationInput, PImage snowflakeInput) {
    //set parameter values to its corresponding variable
    mass = massInput;
    location = locationInput;
    //set velocity and acceleration to start both at 0
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    //set snowflake image file to snowflakeImg variable
    snowflakeImg = snowflakeInput;
  }

  //this function displays the PImage on the canvas
  void display() {
    //display image
    image(snowflakeImg, location.x, location.y);
    //resize to make it smaller
    snowflakeImg.resize(15, 15);
  }

  // Newton’s second law.
  void applyForce(PVector force) {
    //Receive a force, divide by mass, and add to acceleration. (The Nature of Code - Forces)
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

  //this function makes sure the object stays within the canvas dimensions.
  void checkEdges() {
    //check the x location
    if (location.x > width + 30) {
      location.x = width + 30;
      //change velocity direction and location to make it bounce back
      velocity.x *= -1;
    } else if (location.x < -30) {
      //change velocity direction and location  to make it bounce back
      velocity.x *= -1;
      location.x = -30;
    }
    //check the y location
    if (location.y > height + 30) {
      //change velocity direction and location to make it bounce back
      velocity.y *= -1;
      location.y = height + 30;
    } else if (location.y < -30) {
      //change velocity direction and location to make it bounce back
      velocity.y *= -1;
      location.y = -30;
    }
  }
}