//Ana-Maria Arrese - 40005914
//FINAL PROJECT - Worlds
//Audio-visual representation
//INSTRUCTIONS:
//Enjoy the visuals and if you wish to change the sound and distort the
//world, drag a part of the world out with your mouse. Drag to the left for a slower
//pitch/frequency, and drag to the right for a faster pitch/frequency.
//If you want to put the song back to it's original frequency after having played with it,
//just press ENTER.
//Enjoy! 



//import libraries from toxic libs to create the two main meshes
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.volume.*;
import toxi.color.*;
import toxi.processing.*;
import java.util.*;

//variables for changing worlds based on time
int timer = 0;

//timer variable to determine when the mouse was released
int dragTimer = 0;

//interval time(in seconds -> 0.2s) to have the mouse release back into place within that time
int interval = 200;

//import a few libraries for the background song and frequencies of song
import processing.sound.*; 
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//declare Minim object variables to play our song file
Minim minim;
//declare AudioPlayer object for song 
AudioPlayer song; 
//declare object for song frequency
ddf.minim.analysis.FFT frequency;

//I used two ways to upload the song files, one using AudioPlayer and the other one using Fileplayer
//AudioPlayer was used to detect the frequency of the song and FilePlayer was used to play the song and 
//get it left and right tick rate

//object declaration for tickRate
TickRate rateControl;
//Fileplayer declarations
FilePlayer filePlayer;
//Fileplayer declaration for sound output
AudioOutput out;

//write song fileName 
String fileName = "ODESZA - Memories That You Call (feat. Monsoonsiren).mp3";

//float variable to store the value of the the right noise channel of the song
float x2;

//declare toxiclibs mesh objects for both worlds (particle world and mesh world)
ToxiclibsSupport gfx_Particle;
ToxiclibsSupport gfx_Mesh;

//create ONE particle world object called worldOne
ParticleWorld worldOne;

//create ONE mesh world object called worldTwo
MeshWorld worldTwo;

//boolean will determine wether we will be in the particle frame or in the mesh world frame
boolean keepParticleOnly = true;

//Vector that will be used to analyze the offset between the mesh/particle world and the
//mouse position or sin value(depending when we call it)
Vec3D offset = new Vec3D(10, 10, 10);

//I created a int variable called mouseIsPressed that will determine the status of the mouse
//0 when it has is not pressed, 1 when it is pressing, and 2 when it has been released, this is
//to let the program know that only when it has been released or is not pressed can the frames switch from one world
//to another.
int mouseIsPressed = 0;

//I instantiate all my song, file and world objects in the void setup()
void setup() {
  //set canvas size to 1200 for the width and 700 for the height, and include P3D to allow
  //3D object to be created in the program
  size(1200, 700, P3D);

  //instantiate first the toxic libs meshes
  gfx_Particle  = new ToxiclibsSupport(this);
  gfx_Mesh  = new ToxiclibsSupport(this);

  //Then instantiate the particle world and the mesh world by including the toxic libs mesh object name in their constructor
  //This needs to be done so that each Class recognizes it as a gfx mesh (toxic libs mesh)
  worldOne = new ParticleWorld(gfx_Particle);
  worldTwo = new MeshWorld(gfx_Mesh);

  //the Minim loads files from the data directory
  minim = new Minim(this);

  //load song and assign its value to the AudioPlayer variable
  song = minim.loadFile("ODESZA - Memories That You Call (feat. Monsoonsiren).mp3");

  //Opens the file and minim loads the song file and assigns it to the fileplayer variable            
  filePlayer = new FilePlayer( minim.loadFileStream(fileName));
  //Puts it in the "loop" state to never stop playing, always repeating once the song is finished
  filePlayer.loop();

  //then we create a TickRate with a default playback speed of 1.
  rateControl = new TickRate(1.f);

  //gets a line out from minim 
  out = minim.getLineOut();

  //then we patch the file player through the TickRate to the output
  filePlayer.patch(rateControl).patch(out);

  //Fast Fourier Transform (FFT) analyzer
  //FFT constructor needs as parameter length of audio song and sample rate.
  //bufferSize = the internal buffer size of this sound object in sample frames.
  //sampleRate = returns the sample rate of this sound object.
  frequency = new ddf.minim.analysis.FFT(song.bufferSize(), song.sampleRate());
}

//draw function
void draw() {

  //We put an if statement that enters only when 9 seconds have passed after the start of the program
  //to avoid lagging between the switching of frames
  if (millis()>9000) {
    //only if the mouse is not pressed(mouseIsPressed = 0) and the right noise channel frequency is greater than 20 then 
    //enter the if statement)
    if ((x2 > 20) && mouseIsPressed == 0) {
      timer = millis();
      //switch frames from one world to another
      keepParticleOnly = !keepParticleOnly;
    } else {
      //otherwise keep it to the frame in which it is at the moment, do not change it
      keepParticleOnly = keepParticleOnly;
    }
  } else {
    timer =millis();
  }

  //if the keepParticleOnly boolean is true, then we are showing the particle world
  if (keepParticleOnly) {

    //put the background soft dark pastel pink
    background(165, 154, 154); 

    //call the display function on the particle world
    worldOne.displayParticleWorld();

    //call the colorSections function on the particle world to separate the world in different areas and move then
    //with the sin value
    worldOne.colorSections();

    //call the next two functions to recompute back the vertices and faces of the particle world if they have been "distorted" 
    worldOne.tmp.computeFaceNormals();
    worldOne.tmp.computeVertexNormals();
  }
  //if the keepParticleOnly boolean is false, then we are showing the mesh world
  else {
    //set background to white
    background(255);
    //call the display function on the mesh world
    worldTwo.displayMeshWorld();

    //call the colorSections function on the mesh world to separate the world in different areas and move then
    //with the sin value
    //(to activate movement)
    worldTwo.colorSections();

    //call the next two functions to recompute back the vertices and faces of the mesh world if they have been "distorted" 
    worldTwo.mesh.computeFaceNormals();
    worldTwo.mesh.computeVertexNormals();
  }

  //The next if statements are to check whether or not the user is distorting the worlds

  //enter is statement if the user is dragging out the mouse and we are in the particle world frame
  if (mousePressed && keepParticleOnly) { 
    if (mouseIsPressed ==0) {
      //change the state of the mouse to 1 since it has just started being pressed
      mouseIsPressed = 1;

      //Get the original locations of all the vectors of the worlds to know where to place them back once the mouse has been let go
      //Do this for both worlds to avoid any bugs
      worldOne.resetGlobalOffsetList();
      worldTwo.resetGlobalOffsetList();
    }

    //if the mouse is pressed, call activateMovingParticles() to enable the faces to distort with the mouse's position
    worldOne.activateMovingParticles();

    //recompute the faces and vertex of the mesh that is being distorted
    worldOne.tmp.computeFaceNormals();
    worldOne.tmp.computeVertexNormals();
  }

  //enter is statement if the user is dragging out the mouse and we are in the mesh world frame
  if (mousePressed && !keepParticleOnly) {
    if (mouseIsPressed ==0) {
      //change the state of the mouse to 1 since it has just started being pressed
      mouseIsPressed = 1;

      //Get the original locations of all the vectors of the worlds to know where to place them back once the mouse has been let go
      //Do this for both worlds to avoid any bugs
      worldOne.resetGlobalOffsetList();
      worldTwo.resetGlobalOffsetList();
    }

    //if the mouse is pressed, call activateMovingParticles() to enable the faces to distort with the mouse's position
    worldTwo.activateMovingParticles();

    //recompute the faces and vertex of the mesh that is being distorted
    worldTwo.mesh.computeFaceNormals();
    worldTwo.mesh.computeVertexNormals();
  }

  //get the right noise channel of the song file continuously while it is playing and store it into the x2 variable
  for (int i = 0; i < out.bufferSize() - 1; i++) {
    x2 = out.right.get(i)*50;
  }

  //send the right noise channel value to the getSoundBeat function of the mesh world
  worldTwo.getSoundBeat(x2);

  //to make sure we are resetting the meshes back to their original form after every distort, I call again
  //the reset functions on them once the mouse has been released.
  //I also give a small interval of time to reset them once the mouse is released so that if ever the program
  //wanted to switch frames, it would have time to set the meshes back to their original place
  if ((millis() - dragTimer < interval) && mouseIsPressed == 2) {
    worldOne.resetMovingParticles();
    worldTwo.resetMovingParticles();
    worldOne.resetGlobalOffsetList();
    worldTwo.resetGlobalOffsetList();
  } 
  //change back the mouseIsPressed variable to 0 since 2 indicates that the mouse has just been released
  else if (mouseIsPressed ==2) {
    mouseIsPressed = 0;
  }
}


void keyPressed() {
  //if the ENTER key is pressed, the music will go back to its original rate (normal pitch and speed)
  if (key == ENTER) {
    rateControl.value.setLastValue(1);
  }
}

//When the mouse is dragged, the value of the mouse position that has been pressed right before the dragging 
//will determine what change of pitch/frequency will occur to the song
void mousePressed() {
  //Change the rate control value based on mouse position
  float rate = map(mouseX, 0, width, 0.0f, 3.f); 

  //set the value to the rate we just mapped above
  rateControl.value.setLastValue(rate);
}

//When the mouse is released...
void mouseReleased() {
  //set the dragTimer to the value of millis() at the specific moment the mouse was released
  dragTimer = millis();

  //change the status of the mouseIsPressed boolean to 2
  mouseIsPressed = 2;
}