//class for mesh world
class MeshWorld {

  //variables for the properties of the mesh world
  int voxelRes;
  float voxelStrokeWeight;
  int sphereRes;
  int smoother;
  ToxiclibsSupport gfx;
  boolean isWireframe;

  //weTriangleMesh is a class from toxic libs that allows you to build, manipulate & export triangle meshes
  //We need this to create both our worlds
  WETriangleMesh mesh;
  WETriangleMesh tmp;
  SphereFunction sf;

  //rotation variable
  float rot = 1;

  //ArrayList of faces to keep track of each mesh face and their vector locations
  List <Face> sphereFaces;

  //float to keep song beat value
  float b;

  //ArrayList of vectors to keep track of the offsets of vectors
  List <Vec3D> globalOffsets ;

  //variable for sin function
  float theta =0;

  //constructor for mesh world
  MeshWorld(ToxiclibsSupport input) {
    //need to instantiate all these objects from toxic libs below to later be able to manipulate every face of the mesh 
    gfx = input;

    //voxel variables determine how the mesh lines will be, thicker, slimmer, wider or thinner
    //also how many "holes" there will be in mesh
    //I wanted to go with a more web-like mesh.
    voxelRes = 90;
    voxelStrokeWeight = 1;
    sphereRes = 12;
    smoother = 40;

    SphereFunction sf=new SphereFunction(new Sphere(250));
    sf.setMaxTheta(360);
    Mesh3D hemi=new SurfaceMeshBuilder(sf).createMesh(null, sphereRes, 1, false);
    WETriangleMesh tmp=new WETriangleMesh().addMesh(hemi);

    //mesh is our official world mesh name
    mesh=MeshLatticeBuilder.build(tmp, voxelRes, voxelStrokeWeight);

    //get the faces from the mesh and store them into the arraylist
    sphereFaces =  mesh.getFaces();
    // update normals (for shading)
    mesh.computeVertexNormals();

    //laplacian smooth mesh filter that enables us to make the look of the mesh, web-like look almost like stretched gum
    //This smooths out every face of the mesh
    for (int i=0; i<smoother; i++) {
      new LaplacianSmooth().filter(mesh, 1);
    }

    //reset vectors at the very beginning
    resetGlobalOffsetList();
  }

  //this function is to separate the mesh into different parts that will warp in and out depending on their sin value
  void colorSections() {
    //increase theta variable for sin movement
    theta += 0.05;

    //for loop to go through every face
    for (Face f : mesh.faces) {

      //set the mesh to a triangle3D mesh
      Triangle3D triangle = f.toTriangle();

      //compute the middle vector point of the whole mesh
      Vec3D t = triangle.computeCentroid();

      //create 15 different specific points that will be used to separate the world into different areas
      PVector colorSection1= new PVector(600, 100);
      PVector colorSection2= new PVector(600, 500);
      PVector colorSection3= new PVector(800, 350);
      PVector colorSection4= new PVector(400, 350);

      //declare the middle point vector of the mesh
      PVector tCenter = new PVector(t.x+(width/2), t.y+(height/2)); 

      //For every different point that we declared above, if a section of the mesh is less than 100 (or more or less it varies depending on the section)
      //pixels far from the point, then
      //that area will do different things; it will either BOUNCE IN, or BOUNCE OUT with the beat and the sin wave function
      //This will be more of a hard bounce as compared to the particle world which is more of a fluid movement


      //area 1
      if (PVector.dist(colorSection1, tCenter)< 200) {
        pushMatrix();
        noFill();
        noStroke();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();

        //keep x and z offset to 0 to only enable y movement
        offset.x =0;
        offset.z=0;
        //change offset of y to change based on the sin wave (in and out movement) and the beat variable 'b'
        offset.y = (-(sin(theta)/45)*(b));

        //update the faces every time
        translateFace(f, offset);
      }

      //area 2
      if (PVector.dist(colorSection2, tCenter)< 200) {
        pushMatrix();
        fill(255);
        stroke(255);
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();

        //keep x and z offset to 0 to only enable y movement
        offset.x =0;
        offset.z=0;
        //change offset of y to change based on the sin wave (in and out movement) and the beat variable 'b'
        offset.y = ((sin(theta)/45)*(b/2));

        //update the faces every time
        translateFace(f, offset);
      }

      //area 3
      if (PVector.dist(colorSection3, tCenter)< 200) {
        //println(mouse);
        pushMatrix();
        noFill();
        noStroke();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();

        //keep y and z offset to 0 to only enable y movement
        offset.y =0;
        offset.z=0;

        //change offset of x to change based on the sin wave (in and out movement) and the beat variable 'b'
        offset.x = ((sin(theta)/45)*(b/2));

        //update the faces every time
        translateFace(f, offset);
      }

      //area 4
      if (PVector.dist(colorSection4, tCenter)< 200) {
        pushMatrix();
        noFill();
        noStroke();
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();

        //keep y and z offset to 0 to only enable y movement
        offset.y =0;
        offset.z=0;

        //change offset of x to change based on the sin wave (in and out movement) and the beat variable 'b
        offset.x = -((sin(theta)/45)*(-b/2));

        //update the faces every time
        translateFace(f, offset);
      }
    }
  }

  //this function is used to reset every vector's offset back to to 0 after the user has distorted the world
  void resetGlobalOffsetList() {
    //instantiate vector offset arraylist
    globalOffsets = new ArrayList<Vec3D>();
    for (int i =0; i<sphereFaces.size(); i++) {

      //go through every face
      Face f = mesh.faces.get(i);

      //set the offset back to 0 for every face
      globalOffsets.add(new Vec3D(0, 0, 0));
    }
  }


  //function to display the mesh world on the canvas
  void displayMeshWorld() {
    //give a slight light shading
    lights();

    //push and pop matrix used to keep everything in their own location without moving other things
    pushMatrix();

    //move to the middle of the canvas
    translate(width/2, height/2, 0);

    //rotate the mesh x and z directions slightly throughout the whole program
    //for the x rotation, move also to the beat frequency
    rotateX(b++*0.001);
    rotateZ(rot++*0.003);

    // apply wireframe/filled render settings
    gfx.chooseStrokeFill(isWireframe, TColor.newRGB(243, 237, 236), TColor.WHITE);

    // draw lattice mesh
    gfx.mesh(mesh);

    popMatrix();
  }

  //use this function to place back every mesh vector to its original place 
  void resetMovingParticles() {
    int i=0;

    //go through every face of the mesh
    for (Face f : mesh.faces) {

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
    for (Face f : mesh.faces) {
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
      if (PVector.dist(mP, tCenter)<25)
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

  //this method gets the right noise channel of the song and stores it into the b float variable 
  //for it to be used in the MeshWorld class 
  void getSoundBeat(float x) {
    b = x;
  }
}