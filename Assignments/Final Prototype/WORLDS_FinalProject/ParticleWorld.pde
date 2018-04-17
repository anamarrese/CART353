//class for particle world
class ParticleWorld {

  //variables for the properties of the particle world
  ToxiclibsSupport gfx;

  //weTriangleMesh is a class from toxic libs that allows you to build, manipulate & export triangle meshes
  //We need this to create both our worlds
  WETriangleMesh mesh;
  WETriangleMesh tmp;
  SphereFunction sf;

  //ArrayList of faces to keep track of each face and their vector locations
  List <Face> sphereFaces;

  //rotation variable
  float rot = 1;

  //ArrayList of vectors to keep track of the offsets of vectors
  List <Vec3D> globalOffsets ;

  //variable for sin function
  float theta =0;

  //color for world particles
  color c = (255);

  //constructor for particle world
  ParticleWorld(ToxiclibsSupport input) {

    //need to instantiate all these objects from toxic libs below to later be able to manipulate every face of the mesh 
    gfx = input;
    SphereFunction sf =new SphereFunction(new Sphere(250));
    sf.setMaxTheta(300);
    Mesh3D hemi=new SurfaceMeshBuilder(sf).createMesh(null, 60, 1, false);

    //tmp is our official world mesh name
    tmp =new WETriangleMesh().addMesh(hemi);

    //get the faces from the tmp mesh and store them into the arraylist
    sphereFaces =  tmp.getFaces();

    // update normals (for shading)
    tmp.computeVertexNormals();

    //reset vectors at the very beginning
    resetGlobalOffsetList();
  }

  //this function is used to reset every vector's offset back to to 0 after the user has distorted the world
  void resetGlobalOffsetList() {
    //instantiate vector offset arraylist
    globalOffsets = new ArrayList<Vec3D>();
    for (int i =0; i<sphereFaces.size(); i++) {
      //go through every face
      Face f = tmp.faces.get(i);
      //set the offset back to 0 for every face
      globalOffsets.add(new Vec3D(0, 0, 0));
    }
  }

  //function to display the particle world on the canvas
  void displayParticleWorld() {
    //give a slight light shading
    lights();

    //push and pop matrix used to keep everything in their own location without moving other things
    pushMatrix();
    //move to the middle of the canvas
    translate(width/2, height/2, 0);

    //no fill and no stroke for the mesh
    noFill();
    noStroke();

    //set the strokeweight to 0.25 pixels
    strokeWeight(0.25);

    //rotate the mesh x, y and z directions slightly throughout the whole program
    rotateX(rot++*0.001);
    rotateY(rot++*0.0001);
    rotateZ(rot++*0.0001);

    //iterate through every face of the mesh 
    for (int i =0; i<sphereFaces.size(); i++) {
      //for each face get the 'a' location vector
      Face f = tmp.faces.get(i);
      Vec3D a = f.a;

      //declare float variables for x, y and z locations
      float xLoc;
      float yLoc;
      float zLoc;

      //give the vector a's x, y and z location to the xLoc, yLoc and zLoc
      xLoc = a.x;
      yLoc = a.y;
      zLoc = a.z;

      pushMatrix();
      //we use this xLoc, yLoc and zLoc to translate the mesh location with every movement
      translate(xLoc, yLoc, zLoc);

      //choose fill and stroke color white for ellipses (particles for world)
      fill(c);
      stroke(255, 255, 255);

      //create small ellipses that will be the "particles" of the particle world
      ellipse(0, 0, 2, 2);
      popMatrix();
    }
    popMatrix();
  }

  //this function is to separate the mesh into different parts that will warp in and out depending on their sin value
  void colorSections() {
    //increase theta variable for sin movement
    theta += 0.05;

    //for loop to go through every face
    for (Face f : tmp.faces) {

      //set the mesh to a triangle3D mesh
      Triangle3D triangle = f.toTriangle();

      //compute the middle vector point of the whole mesh
      Vec3D t = triangle.computeCentroid();

      //create 15 different specific points that will be used to separate the world into different areas
      PVector colorSection1= new PVector(600, 200);
      PVector colorSection2= new PVector(800, 200);
      PVector colorSection3= new PVector(400, 200);
      PVector colorSection4= new PVector(600, 500);
      PVector colorSection5= new PVector(400, 500);
      PVector colorSection6= new PVector(800, 500);
      PVector colorSection7= new PVector(600, 350);
      PVector colorSection8= new PVector(400, 300);
      PVector colorSection9= new PVector(800, 300);
      PVector colorSection10= new PVector(410, 400);
      PVector colorSection11= new PVector(790, 400);
      PVector colorSection12= new PVector(500, 250);
      PVector colorSection13= new PVector(700, 250);
      PVector colorSection14= new PVector(500, 450);
      PVector colorSection15= new PVector(700, 450);

      //declare the middle point vector of the mesh
      PVector tCenter = new PVector(t.x+(width/2), t.y+(height/2)); 

      //For every different point that we declared above, if a section of the mesh is less than 100 pixels far from the point (or more or less it 
      //varies depending on the section), then
      //that area will do different things; some will warp in, some will warp out, some will remain the same to give a fluid-like movement, 
      //almost like a jellyfish.

      //area 1
      if (PVector.dist(colorSection1, tCenter)< 100) {
        pushMatrix();
        noStroke();
        noFill();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();

        //keep x and z offset to 0 to only enable y movement
        offset.x =0;
        offset.z=0;
        //change offset of y to change based on the sin wave (in and out movement)
        offset.y = (sin(theta)/10);
        //update the faces every time
        translateFace(f, offset);
      }

      //area 2
      if (PVector.dist(colorSection2, tCenter)< 100) {
        pushMatrix();
        noStroke();
        noFill();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();
      }

      //area 3
      if (PVector.dist(colorSection3, tCenter)< 100) {
        pushMatrix();
        noStroke();
        noFill();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();
      }

      //area 4
      if (PVector.dist(colorSection4, tCenter)< 100) {
        pushMatrix();
        noStroke();
        noFill();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();
        offset.y =0;
        offset.z=0;
        //change offset of y to change based on the sin wave (in and out movement)
        offset.y = sin(theta)/10;
        //update the faces every time
        translateFace(f, offset);
      }

      //area 5
      if (PVector.dist(colorSection5, tCenter)< 100) {
        pushMatrix();
        noStroke();
        noFill();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();
        offset.x =0;
        offset.z=0;
        //change offset of y to change based on the sin wave (in and out movement)
        offset.y = -(sin(theta)/8);
        //update the faces every time
        translateFace(f, offset);
      }

      //area 6
      if (PVector.dist(colorSection6, tCenter)< 100) {
        pushMatrix();
        noStroke();
        noFill();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();
      }

      //area 7
      if (PVector.dist(colorSection7, tCenter)< 100) {
        pushMatrix();
        noStroke();
        noFill();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();
      } 

      //area 8
      if (PVector.dist(colorSection8, tCenter)< 70) {
        pushMatrix();
        noStroke();
        noFill();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();
      } 

      //area 9
      if (PVector.dist(colorSection9, tCenter)< 70) {
        pushMatrix();
        noStroke();
        noFill();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();
        offset.y =0;
        offset.z=0;
        //change offset of x to change based on the sin wave (in and out movement)
        offset.x = sin(theta)/10;
        //update the faces every time
        translateFace(f, offset);
      }

      //area 10
      if (PVector.dist(colorSection10, tCenter)< 70) {
        pushMatrix();
        noStroke();
        noFill();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();
        offset.y =0;
        offset.z=0;
        //change offset of y to change based on the sin wave (in and out movement)
        offset.y = sin(theta)/10;
        //update the faces every time
        translateFace(f, offset);
      } 

      //area 11
      if (PVector.dist(colorSection11, tCenter)< 70) {
        pushMatrix();
        noFill();
        noStroke();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();
        offset.y =0;
        offset.z=0;
        //change offset of x to change based on the sin wave (in and out movement)
        offset.x = -(sin(theta)/10);
        //update the faces every time
        translateFace(f, offset);
      } 

      //area 12
      if (PVector.dist(colorSection12, tCenter)< 80) {
        pushMatrix();
        noStroke();
        noFill();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();
        offset.y =0;
        offset.z=0;
        //change offset of x to change based on the sin wave (in and out movement)
        offset.x = -(sin(theta)/10);
        //update the faces every time
        translateFace(f, offset);
      } 

      //area 13
      if (PVector.dist(colorSection13, tCenter)< 80) {
        pushMatrix();
        noStroke();
        noFill();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();
      } 

      //area 14
      if (PVector.dist(colorSection14, tCenter)< 80) {
        pushMatrix();
        noStroke();
        noFill();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();
      } 

      //area 15
      if (PVector.dist(colorSection15, tCenter)< 80) {
        pushMatrix();
        noStroke();
        noFill();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();
      }
    }
  }

  //use this function to place back every mesh vector to its original place 
  void resetMovingParticles() {
    int i=0;
    //go through every face of the mesh
    for (Face f : tmp.faces) {

      //place them back by changing the direction of their offset (if it had and offset of 20 and moved 20 pixels, then give them another offset of
      //-20, to place them back
      globalOffsets.get(i).x = globalOffsets.get(i).x*-1;
      globalOffsets.get(i).y = globalOffsets.get(i).y*-1;

      //for the vectors that DID move, update the face by calling translateFace method
      //and don't do anything for those who did not move
      if (globalOffsets.get(i).x !=0 && globalOffsets.get(i).y!=0) {
        translateFace(f, globalOffsets.get(i));
      }
      i++;
    }
  }

  //This function is used to move the mesh once the user wants to distort it by dragging the mouse
  void activateMovingParticles() {
    int i =0;
    //go through the mesh faces
    for (Face f : tmp.faces) {
      //change the mesh to a triangle3D object
      Triangle3D triangle = f.toTriangle();

      //compute the central point of the triangle3D object
      Vec3D t = triangle.computeCentroid();

      //store the mouse x and y location into a PVector variable
      PVector mP= new PVector(mouseX, mouseY);

      //declare the center point of the mesh 
      PVector tCenter = new PVector(t.x+(width/2), t.y+(height/2));

      //declare a vector variable for the offset
      Vec3D offset = new Vec3D();

      //If the user drags the mouse out and the distance between the mouse's first click location and the mesh is less than 30, then
      //enter the if statement
      if (PVector.dist(mP, tCenter)< 30)
      {

        //move the specific ellipses towards the mouse location and use push and pop to avoid moving anything else
        pushMatrix();

        //the extra faces that will be created when pulling out the mesh will have no color and no stroke to not be seen
        noFill();
        noStroke();
        translate(width/2, height/2);

        //create the extra triangles that will enable the mesh to expand
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();

        //find the distance between the mouse and the vector center point
        PVector dist = PVector.sub(mP, tCenter);
        //normalize it
        dist.normalize();
        //muliply it for more impact (to have more distortion)
        dist.mult(10.01);

        //set the x and y offset to the distance between the two vectors above
        offset.x=dist.x;
        offset.y=dist.y;

        //add the offsets into the offset arraylist to know how much they moved
        globalOffsets.get(i).x+= offset.x;
        globalOffsets.get(i).y+= offset.y;

        //update faces and vectors 
        translateFace(f, offset);
      }
      i++;
    }
  }

  //this function is what actually enables the movement to happen within the mesh
  //It updates the vectors with the addSelf() function from toxicLibs
  void translateFace(Face f, Vec3D offset) {
    //update each face's vectors with their corresponding offset
    f.a.addSelf(offset);
    f.b.addSelf(offset);
    f.c.addSelf(offset);
  }
}