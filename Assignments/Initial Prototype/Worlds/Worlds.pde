import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.volume.*;
import toxi.color.*;
import toxi.processing.*;
import java.util.*;

ToxiclibsSupport gfx;
ParticleWorld worldOne;
MeshWorld worldTwo;
boolean keepParticleOnly = false;
boolean moveParticle = false;
Vec3D offset = new Vec3D(10, 10, 10);
Vec3D vecReceived; 

void setup() {
  size(1200, 700, P3D);
  gfx  = new ToxiclibsSupport(this);
  worldOne = new ParticleWorld(gfx);
  worldTwo = new MeshWorld(gfx);

  //store initial location of points
  worldOne.getInitialVecLocations();
}

void draw() {
  background(0);

  //worldTwo.displayMeshWorld();
  //how to draw them one by one when certain key pressed?
  if (keepParticleOnly) {
    worldOne.displayParticleWorld();
  }
  //why is meshworld two not displaying?
  else {
    worldTwo.displayMeshWorld();
  }

  if (mousePressed && keepParticleOnly) {
    worldOne.activateMovingParticles();
    worldOne.tmp.computeFaceNormals();
    worldOne.tmp.computeVertexNormals();
  }
  
  if(mousePressed && !keepParticleOnly){
    worldTwo.activateMovingParticles();
    worldTwo.mesh.computeFaceNormals();
    worldTwo.mesh.computeVertexNormals();
  }
}

void keyPressed() {
  if (keyCode == ENTER) {
    keepParticleOnly = !keepParticleOnly;
    //while (keepParticleOnly) {
  }
}