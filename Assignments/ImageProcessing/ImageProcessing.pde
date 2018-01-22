/*
 -Image Processing Assignment
 -Presented to Rilla Khaled
 -By Ana-Maria Arrese - 40005914
*/

//Declare two new objects of the Image class
Image img1;
Image img2;

//boolean to know when to activate mouseMoved() 
//right now it is at false, so nothing happens
boolean unlock = false;

//boolean to know when we are back at the main menu page
boolean mainPage = true;

//int variable to hold saved image frame number
int savedImage = 0;

//create offset variable to hold image location (while mouseX moves)
float offset = 0;

//create a variable that holds the speed at which the transparent image will move
float transparentEasing = 0.05;

void setup() {
  //set canvas to have a white background, with a width of 500 pixels and a height of 
  //500 pixels as well
  background(255);
  size(500, 500);

  //Instantiate the two Image objects 
  //Their constructor takes as input their image file and their initial 
  //location on the canvas.
  img1 = new Image(loadImage("img1.jpg"), -250, 0);
  img2 = new Image(loadImage("img2.jpg"), 250, 0);
}

void draw() {
  
  //resize images  to fit canvas and display them on canvas
  img2.resizeImage(501, 0);
  img2.display();
  img1.resizeImage(501, 0);
  img1.display();  

  //if statement to show the menu instruction ONLY if we are at the main menu page
  //when we are at the menu page, mainPage boolean will be true and we will enter
  //this statement that displays the text
  if (mainPage) {
    
    //Title
    String title = "REMIX CHALLENGE";
    textSize(16);
    fill(255);
    textAlign(LEFT);
    text(title, 270, 17, 200, 300);

    //Instructions
    String text = "-\nPress spacebar for remix 1\nPress backspace for remix 2\nPress 'a' for remix 3";
    textSize(14);
    fill(255);
    textAlign(LEFT);
    text(text, 270, 40, 250, 315);

    String text1 = "-\nAfter each remix, press ENTER to come back to this main menu page.";
    textSize(14);
    fill(255);
    textAlign(LEFT);
    text(text1, 270, 125, 180, 315);

    String text2 = "-\nPress 's' to save remixed image frame in the sketch's folder.";
    textSize(14);
    fill(255);
    textAlign(LEFT);
    text(text2, 270, 210, 180, 315);
  }

  //if user presses a key, enter this if statement
  if (keyPressed) {
    
    //set mainPage boolean to false to hide text
    mainPage = false;

    //if user presses spacebar key, enter this if statement
    if (key == 32) {
      //change both images position
      img2.update(0, 0);
      img1.update(0, 0);
      //call method to make horizontal line pixels appear of both images
      img1.makeLinesAppear2();
      img2.makeLinesAppear1();
    }

    //if user presses ENTER key, enter this if statement
    if (key == ENTER) {
      //we go back to original main menu
      //clear canvas
      background(255);
      
      //set mainPage boolean to true to display text instructions
      mainPage = true;
      
      //load images again - reupdate them to their initial position on canvas
      img1 = new Image(loadImage("img1.jpg"), -250, 0);
      img2 = new Image(loadImage("img2.jpg"), 250, 0);
      
      //prevent mouseMoved() to work by setting boolean to false
      unlock = false;
    }

    //if user presses BACKSPACE key, enter this if statement
    if (key == BACKSPACE) {
      //go to mouseMoved() function
      mouseMoved();
      //set unlock boolean to true to let mouseMoved() work
      unlock = true;
    }

    //if user presses 'a' key, enter this if statement
    if (key == 97) {
      //clear canvas
      background(255);
      
      //Update both images location on canvas
      //Call the changeBrightness() function to set only some parts of the image's pixels
      //to black and white
      img1.update(0, 250);
      img1.changeBrightness(250, 250);
      img2.update(0, -250);
      img2.changeBrightness(250, 750);
    }

    //if user presses 's' key, enter this if statement
    if (key == 115) {
      //store images by number, up until 100 frames maximum
      if ( savedImage< 100) {
        line(savedImage, 0, savedImage, 100);
        savedImage = savedImage + 1;
      } 
      //saveFrame() function takes a screenshot of the canvas
      //when the user presses 's' key, and saves it to the sketch's folder.
      saveFrame("remixImage-###.png");
    }
  }
}


void mouseMoved() {
  //mouseMoved() will activate only if unlock boolean is true
  if (unlock) {

    //inspired by Processing - transparency example
    //source: https://processing.org/examples/transparency.html
    
    //float variable to stroe by how much we will move transparent image
    float moveImage = (mouseX-500/2) - offset;
    
    //offset variable that will change X location of transparent image
    //every time mouse moves
    offset += moveImage * transparentEasing; 
    
    //set image 2 transparency
    tint(255, 127); 
    
    //update img2's X location everytime the mouse is moving
    img2.update(offset, 0);
  }
}