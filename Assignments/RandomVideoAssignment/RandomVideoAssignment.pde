/*
 -Rando Video Assignment
 -Presented to Rilla Khaled
 -By Ana-Maria Arrese - 40005914
 -CONCEPT: My rando video assignment demonstrates using 2D Perlin noise to create
 a smooth wave effect on various occasions on the canvas. For the Gaussian distribution,
 I applied it to the circle in order to create a "beating" effect. For the video, the color
 of the beating circle will be the color that it will try to find on the video pixels.It will 
 track a similar color to GREEN and attach itself to it. I suggest you google an rgb green
 image on your and show it to the webcam up close to see how the circle reacts and follows it. :) 
*/

//import library for Gaussian function
import java.util.Random;
//import library for video processing
import processing.video.*;

Capture video;

//set the y Offset of the wave (seen in wave class)
float yoff = 0.0; 

//initialize random Gaussian generator
Random numGen;

//initialize record for track color
float record = 500;

//initialize tracked color
color trackColor;

//initialize 3 wave objects
Wave wave1;
Wave wave2;
Wave wave3;

//initialize 1 beating ellipse
BeatingEllipse ellipse1;

//initialize int variables for x and y location values near the tracked color
int nearestXvalue;
int nearestYvalue;

//create capture event function for video processing
void captureEvent(Capture video) {
  video.read();
}

void setup() {
  //set background white
  background(255);
  //set canvas size
  size(1280, 720);
  
  //declare video variable
  video = new Capture(this, width, height);
  
  //start video from the beginning
  video.start();
  
  //declare the 3 wave objects
  wave1 = new Wave(500, 500, 600);
  wave2 = new Wave(200, 100, 200);
  wave3 = new Wave(350, 250, 450);
  
  //declare beating ellipse object
  ellipse1 = new BeatingEllipse(numGen, nearestXvalue, nearestYvalue);

  //declare track color to rgb green
  trackColor = color(0, 255, 0);
}

void draw() {
  
  //display video
  image(video, 0, 0);

  //display wave objects on canvas
  wave1.displayWave();
  wave2.displayWave();
  wave3.displayWave();

  //load video pixels
  video.loadPixels();
  
  //go through each video pixel with this nested for loop
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      //int variable for video pixel location
      int loc = x + y * video.width;
      //get pixel color
      color currentColor = video.pixels[loc];
      
      //get red, blue and green value of current pixel color
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      
      //get red, blue and green value of tracker color
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      //Distance function and the record was inspired by Daniel Schiffman's 
      //color tracking video
      //https://www.youtube.com/watch?v=nCVZHROb_dE
      
      //check the distance between each rgb value of the current color and the tracker
      //color and store it in a float variable.
      float d = dist(r1, g1, b1, r2, g2, b2);

      //check if the distance variable is smaller than the record
      if (d < record) {
        //assign the distance value to the record variable
        record = d;
        //set the x and y value of the pixel to the x and y value of the 
        //track color ellipse location
        nearestXvalue = x; 
        nearestYvalue = y;
      }
    }
  }
  
  //update the pixels
  updatePixels();
  
  //call the ellipse function move the beating ellipse where it tracks its similar color
  //on the video webcam.
  ellipse1.displayEllipse(nearestXvalue, nearestYvalue);
}