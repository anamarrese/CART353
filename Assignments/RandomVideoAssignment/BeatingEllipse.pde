//class beatingEllipse that creates the ellipse on the screen
class BeatingEllipse{
  
  //set instance variables
  float meanValue;
  int xLocation;
  int yLocation;
  Random numGenerator;
  
  //create constructor that takes in random Gaussian generator, ellipse x and y location
  BeatingEllipse(Random numberGenerator, int xLoc, int yLoc){
    numGenerator  = numberGenerator;
    xLocation = xLoc;
    yLocation = yLoc;
    //initialize the Gaussian generator
    numGenerator = new Random();
  }
  
  //function to display the ellipse on canvas
  //with x and y location parameters
  void displayEllipse(int x, int y){
    
      //generate Gaussian distribution mean value
      meanValue = (float) numGenerator.nextGaussian();
      
      //adjust mean value and expand "beating"
      meanValue = meanValue*20;
      meanValue = meanValue + 200;

      //fill ellipse color with rgb green (track color)
      fill(trackColor);
      //create ellipse with x and y location that follow the pixels similar to tracked color.
      //width and height will vary based on Gaussian distribution.
      ellipse(x, y, meanValue, meanValue);
    
  }
  
}