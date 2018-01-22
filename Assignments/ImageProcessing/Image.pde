//Image class
class Image {

  //PImage variable to store image
  PImage fruitImage;
  //float variables to store x and y position of image
  float xpos, ypos;

  //Image constructor with parameters: image file, x positon, y position
  Image(PImage img, float xPosition, float yPosition) {

    //set imagefile to fruitImage variable
    fruitImage = img;
    //set x and y position to x and y instance float variables
    xpos = xPosition;
    ypos = yPosition;
  }

  //this function displays the image on the canvas
  void display() {
    image(fruitImage, xpos, ypos);
  } 

  //this function updates the position of the image on the canvas
  //based on the values given through the parameters.
  void update(float xPosition, float yPosition) {
    xpos = xPosition;
    ypos = yPosition;
  }

  //this function resizes an image to fit the values inputed by the user
  //through its parameters.
  void resizeImage(int x, int y) {
    //use of resize() function from Processing
    fruitImage.resize(x, y);
  }

  //This function display only specific horizontal lines of pixels of an image, the rest are white
  void makeLinesAppear1() {

    //reset position of image
    xpos = 0;
    ypos = 0;

    //load image pixels
    fruitImage.loadPixels();

    //only go through some columns of pixels
    for (int x = 9; x < 500; x += 10) { 
      for (int y = 0; y < 500; y += 1) {

        //find location of pixel with the help of the formula
        int loc = x + y*fruitImage.width;

        //set the pixels chosen to white
        //choose up until 4 pixels less to create a thicker column
        fruitImage.pixels[loc] = color(255, 255, 255);
        fruitImage.pixels[loc-1] = color(255, 255, 255);
        fruitImage.pixels[loc-2] = color(255, 255, 255);
        fruitImage.pixels[loc-3] = color(255, 255, 255);
        fruitImage.pixels[loc-4] = color(255, 255, 255);

        //lower their transparency
        tint(255, 30);
      }
    }

    //update image pixels
    fruitImage.updatePixels();
  }

  //this function is exactly like the one above it except that it displays the 
  //columns that the other function does not display
  void makeLinesAppear2() {

    //reset position of image
    xpos = 0;
    ypos = 0;

    //load image pixels
    fruitImage.loadPixels();

    //only go through some columns of pixels
    for (int x = 4; x < 500; x += 10) { 
      for (int y = 0; y < 500; y += 1) {

        //find location of pixel with the help of the formula
        int loc = x + y*fruitImage.width;

        //set the pixels chosen to white
        //choose up until 4 pixels less to create a thicker column
        fruitImage.pixels[loc] = color(255, 255, 255);
        fruitImage.pixels[loc-1] = color(255, 255, 255);
        fruitImage.pixels[loc-2] = color(255, 255, 255);
        fruitImage.pixels[loc-3] = color(255, 255, 255);
        fruitImage.pixels[loc-4] = color(255, 255, 255);

        //lower their transparency
        tint(255, 30);
      }
    }

    //update image pixels
    fruitImage.updatePixels();
  }

  //This function changes the brightness of a part of the image to the point where
  //it turns black and white.
  //The parameters give the section of the image to modify.
  void changeBrightness(int xLength, int yLength) {
    
    //Create float variable to determine whether the pixel should be white or black
    //depending if its greater than or less than the threshold.
    float threshold = 210;

    //Go through each of the image's pixels and check their brightness.
    for (int x = xLength - 250; x < xLength; x++) {
      for (int y = yLength - 250; y < yLength; y++) {
        
        //find location of pixel with the help of the formula
        int loc = x+y*250;
        
        //Check pixel brightness with the help of Processing's brightness() function
        //If brightness is greater than threshold, set that pixel's color to white,
        //otherwise, if it's less than the threshold, set it to black.
        if (brightness(fruitImage.pixels[loc]) > threshold) {
          fruitImage.pixels[loc] = color(255);
        } else {
          fruitImage.pixels[loc] = color(0);
        }
      }
    }
    //set a light transparency setting
    tint(255, 200);
    
    //update image pixels
    fruitImage.updatePixels();
  }
}