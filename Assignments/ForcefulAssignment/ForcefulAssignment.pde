/*
 -Forceful Assignment
 -Presented to Rilla Khaled
 -By Ana-Maria Arrese - 40005914
 */

//Declare the main mover object (pink gummy)
Mover m1;

//Declare mover array that will contain all the snow bubbles
Mover[] movers = new Mover[25];

//Declare snowflake array that will contain all the snowflakes
Snowflakes[] snowflakeImages = new Snowflakes[200];

//declare three oil spills "thick clouds" 
Oil spillOne;
Oil spillTwo;
Oil spillThree;

//declare ice object
Ice iceBlockOne;

//declare different PVectors for different forces on entities (wind and gravity)
PVector wind = new PVector(-0.01, 0);
PVector wind2 = new PVector(0, 0);
PVector gravity = new PVector(0, 0.5);
PVector gravityForBubbles = new PVector(0, 1);


void setup() {
  //canvas size
  size(1300, 600);

  //load and instantiate PImage for ice puddle
  PImage icePuddle = loadImage("puddle.png");
  iceBlockOne = new Ice(800, 350, icePuddle);

  //load and instantiate PImage for 3 black clouds
  PImage blackCloud = loadImage("black cloud.png");
  spillOne = new Oil(350, 450, blackCloud);
  spillTwo = new Oil(150, 150, blackCloud);
  spillThree = new Oil(1100, 200, blackCloud);

  //load and instantiate PImage for pink gummy mouth
  PImage mouthImg = loadImage("mouth.png");
  m1 = new Mover(4, new PVector(300, 300), mouthImg);

  //load and instantiate PImage for all snowflakes
  PImage snowf = loadImage("snowflake.png");

  //create for loop to go through each element and instantiate it individually
  //different masses and locations
  for (int i = 0; i < snowflakeImages.length; i++) {
    snowflakeImages[i] = new Snowflakes(int(random(0, 3)), new PVector(int(random(-100, 1400)), int(random(-100, 700))), snowf);
  }

  //create for loop to go through each mover element and instantiate it individually
  //different sizes, colors and locations
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(random(1, 5), new PVector(random(0, 1300), random(0, 600)), color(int (random(0, 50)), int (random(100, 250)), 200, 60));
  }
}

void draw() {
  //background color light grey-pink
  background(235, 234, 239);

  //text for instructions
  textSize(16); // Set text size to 32
  fill(0);
  textAlign(CENTER);
  text("Move pink gummy with arrow keys!", 600, 40);
  text("Eat all of the snowballs!", 600, 70);
  text("Black thick clouds slow you down &", 600, 100);
  text("ice puddles speed you up.", 600, 130);

  //display 3 thick clouds (oil spills) on canvas
  spillOne.displayOilSpill();
  spillTwo.displayOilSpill();
  spillThree.displayOilSpill();

  //display ice puddle on canvas
  iceBlockOne.displayIceBlock();

  //for loop will go through each element in the snowflakes array and will display them
  //on the canvas, update their location and movement, and assign different forces
  //on them, gravity and wind.
  for (int i = 0; i < snowflakeImages.length; i++) {

    //create two different gravity vectors to have snowflakes vary
    PVector gravityDown = new PVector((random(0, 0.005)), 0);
    PVector gravityUp = new PVector(0, (random(0, 0.005)));

    //create two wind forces to vary snowflake direction
    PVector windRight = new PVector(0.009, 0);
    PVector windLeft = new PVector(0, 0.009);

    //display and update each snowflake
    snowflakeImages[i].display();
    snowflakeImages[i].update();

    //if snowflake element index number is positive, then apply windRight and GravityDown
    //force on them (most likely will fly to the right and downwards on canvas
    if (i%2 == 0) {
      snowflakeImages[i].applyForce(windRight);
      snowflakeImages[i].applyForce(gravityDown);
    } 
    //Otherwise apply windleft and gravity up force on them
    //this means that they will most likely fly to the left and upwards on canvas
    else {
      snowflakeImages[i].applyForce(windLeft);
      snowflakeImages[i].applyForce(gravityUp);
    }

    //Always check each snowflake element edges to make sure the don't dissapear from canvas
    //They bounce back in canvas after reaching a certain location.
    snowflakeImages[i].checkEdges();
  }

  //for loop goes through each snowball (mover element) and displays it on canvas,
  //starting with no wind movement so they keep still.
  for (int i = 0; i < movers.length; i++) {
    movers[i].update();
    movers[i].display();
    movers[i].checkEdges();
    movers[i].applyForce(wind2);
  }

  //for loop goes through each snowball (mover element)
  for (int i = 0; i < movers.length; i++) {
    //if the main pink gummy has passed through the same location in which a snowball stands,
    //then we enter the if statement and the snowball latches onto the gummy.
    if (m1.hasTouchedMainCircle(movers[i])) {
      //call attract method onto the main gummy to assign the snowball's location 
      //to follow the gummy's location
      m1.attract(movers[i]);
      //apply a force onto the snowball so it still has a floating feel to it
      movers[i].applyForce(gravityForBubbles);
      //update the snowball's movement (velocity, acceleration)
      movers[i].update();
      //keep checking snowball's position to make sure they stay in canvas
      movers[i].checkEdges();
    }

    //enter the if statement if the snowballs pass through the black cloud's location
    if (movers[i].isInsideOil(spillOne)) {
      //call the drag function to slow the snowball down (liquid friction)
      movers[i].drag(spillOne);
      //update the snowball's location and movement
      movers[i].update();
    }

    //we do the same thing for the two other black clouds (spillTwo and spillThree)
    if (movers[i].isInsideOil(spillTwo)) {
      movers[i].drag(spillTwo);
      movers[i].update();
    }
    if (movers[i].isInsideOil(spillThree)) {
      movers[i].drag(spillThree);
      movers[i].update();
    }

    //now we check if the snowballs pass through the ice puddle's location
    if (movers[i].isInsideIce(iceBlockOne)) {
      //call the slide function to speed up the snowball down 
      movers[i].slide(iceBlockOne);
      //update the snowball's location and movement
      movers[i].update();
    }
  }
  
  //display pink gummy PImage on canvas, apply forces on it (gravity and wind)
  //this will make it move around the canvas in a natural form
  m1.displayImage();
  m1.applyForce(wind);
  m1.applyForce(gravity);
  //check its location edges to make sure the gummy stays within the canvas
  m1.checkEdges();
  //call the pressedKeys() function to enable key movements on gummy
  m1.pressedKeys();
  //update the pink gummy's movement and location
  m1.update();

  //check if the main pink gummy passes through the ice puddle's location
  if (m1.isInsideIce(iceBlockOne)) {
    //call the slide function to speed up the pink gummy down 
    m1.slide(iceBlockOne);
    m1.checkEdges();
    m1.pressedKeys();
    m1.update();
  } 

  //check if the pink gummy passes through one of the 3 black cloud's location
  //always check for each cloud

  //cloud 1
  if (m1.isInsideOil(spillOne)) {
    //if it passes through the first black cloud, call the drag function to
    //slow the gummy down (liquid friction) 
    m1.drag(spillOne);
    m1.update();
  }

  //cloud 2
  if (m1.isInsideOil(spillTwo)) {
    //if it passes through the second black cloud, call the drag function to
    //slow the gummy down (liquid friction) 
    m1.drag(spillTwo);
    m1.update();
  }

  //cloud 3
  if (m1.isInsideOil(spillThree)) {
    //if it passes through the third black cloud, call the drag function to
    //slow the gummy down (liquid friction) 
    m1.drag(spillThree);
    m1.update();
  }
}