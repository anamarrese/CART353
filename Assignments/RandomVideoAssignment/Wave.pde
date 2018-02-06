//class wave
class Wave {

  //declare instance variables
  int heightValue;
  int locationValueTop;
  int locationValueBottom;

  //declare constructor with height and length locations
  Wave(int heightInput, int locationValueT, int locationValueB) {
    heightValue = heightInput;
    locationValueTop = locationValueT;
    locationValueBottom = locationValueB;
  }
  
  //create function to display wave on canvas
  void displayWave() {
    //begin the wave shape for a more complex form
    beginShape();
    //x offsett for more wave-like distribution
    float xoff = 0;  

    //set wave color to white
    fill(255);
    //for each 10 pixels on width of canvas
    for (float x = 0; x <= width; x += 10) {
      //use 2D perlin noise to map the x and y offset value to the top and bottom location
      //of the wave, and store it in float y value
      float y = map(noise(xoff, yoff), 0, 1, locationValueTop, locationValueBottom); 
      //create first vertex point of shape with the x value and the obtained y value
      vertex(x, y); 
      // Increment x offset for more "noise" wavy pattern
      xoff += 0.05;
    }

    fill(255);
    // Increment y offset for more "noise" wavy pattern
    yoff += 0.01;
    
    //set next vertices of shape
    vertex(width, heightValue);
    vertex(0, heightValue);
    //end wave shape form
    endShape(CLOSE);
  }
}