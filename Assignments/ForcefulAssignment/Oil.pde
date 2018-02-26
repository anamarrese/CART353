//Oil class
class Oil {

  //int variables to store x and y location of oil spill(black cloud)
  int middlePointX;
  int middlePointY; 
  //float c to store coefficient of friction
  float c;
  //PImage variable to store black cloud image
  PImage blackCloud;

  //Oil constructor
  Oil(int x, int y, PImage blackCloudImg) {
    //assign x and y parameters input to middlePointX and middlePointY values
    middlePointX = x;
    middlePointY = y;
    //set coefficient of friction to 0.1
    c = 0.5;
    //set black cloud image file to blackCloud variable
    blackCloud = blackCloudImg;
  }

  //this function displays the PImage on the canvas
  void displayOilSpill() {
    //set x and y location to be at center point of image
    imageMode(CENTER);
    //display image
    image(blackCloud, middlePointX, middlePointY);
    //resize to make it smaller
    blackCloud.resize(180, 130);
  }
}