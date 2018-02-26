//Ice class
class Ice {

  //int variables to store x and y location of ice puddle
  int middlePointX;
  int middlePointY;
  //float c to store coefficient of friction
  float c;
  //PImage variable to store ice image
  PImage iceImage;

  //Ice constructor
  Ice(int x, int y, PImage iceInput) {
    //assign x and y parameters input to middlePointX and middlePointY values
    middlePointX = x;
    middlePointY = y;
    //set coefficient of friction to 0.1
    c = 0.1;
    //set ice image file to iceImage variable
    iceImage = iceInput;
  }

  //this function displays the PImage on the canvas
  void displayIceBlock() {
    //set x and y location to be at center point of image
    imageMode(CENTER);
    //display image
    image(iceImage, middlePointX, middlePointY);
    //resize to make it smaller
    iceImage.resize(250, 80);
  }
}