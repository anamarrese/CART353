class ParticleWorld {

  ToxiclibsSupport gfx;
  WETriangleMesh mesh;
  WETriangleMesh tmp;
  SphereFunction sf;
  List <Face> sphereFaces;
  List <Vec3D> initialLocArray;
  float rot = 1;
  Vec3D centerPoint;

  ParticleWorld(ToxiclibsSupport input) {
    gfx = input;
    SphereFunction sf =new SphereFunction(new Sphere(250));
    sf.setMaxTheta(300);
    Mesh3D hemi=new SurfaceMeshBuilder(sf).createMesh(null, 60, 1, false);
    tmp =new WETriangleMesh().addMesh(hemi);
    sphereFaces =  tmp.getFaces();
    // update normals (for shading)
    tmp.computeVertexNormals();
  }

  void displayParticleWorld() {
    lights();
    pushMatrix();
    translate(width/2, height/2, 0);
    //popMatrix();
    noFill();
    stroke(0);
    strokeWeight(0.25);
    rotateX(rot++*0.001);
    rotateY(rot++*0.001);
    rotateZ(rot++*0.001);
    for (int i =0; i<sphereFaces.size(); i++) {
      Face f = tmp.faces.get(i);
      Vec3D a = f.a;
      float xLoc = a.x;
      float yLoc = a.y;
      float zLoc = a.z;
      pushMatrix();
      translate(xLoc, yLoc, zLoc);
      fill(255);
      stroke(243, 237, 236);
      ellipse(0, 0, 2, 2);
      popMatrix();
    }
    popMatrix();
  }

//---------!!!!!
  void getInitialVecLocations() {
    //MAKE 3 VEC3D ARAYS FOR A B AND C THEN WITHIN THEM AX AY AZ
    List <Vec3D> locArrayAs = new ArrayList<Vec3D>();
    for (int i =0; i<sphereFaces.size(); i++) {
      Face f = tmp.faces.get(i);
      locArrayAs.add(new Vec3D(f.a.x, f.a.y, f.a.z));
    }
    initialLocArray = locArrayAs;
  }
  
  void placeBackDots(){
    
  }
 /////----!!!

  public Vec3D getMouseLocation(Vec3D mouseInput) {
    centerPoint = mouseInput;
    return centerPoint;
  }

  void activateMovingParticles() {
    for (Face f : tmp.faces) {
      Triangle3D triangle = f.toTriangle();
      Vec3D t = triangle.computeCentroid();
      PVector mP= new PVector(mouseX, mouseY);
      PVector tCenter = new PVector(t.x+(width/2), t.y+(height/2)); 
      Vec3D offset = new Vec3D();

      if (PVector.dist(mP, tCenter)<20)
      {

        //println(mouse);
        fill(255);
        pushMatrix();
        fill(0);
        stroke(0);
        translate(width/2, height/2);
        triangle(triangle.a.x, triangle.a.y, triangle.b.x, triangle.b.y, triangle.c.x, triangle.c.y);
        popMatrix();

        PVector dist = PVector.sub(mP, tCenter);
        dist.normalize();
        dist.mult(1.01);
        offset.x=dist.x;
        offset.y=dist.y;

        translateFace(f, offset);
      }
    }
  }

  void translateFace(Face f, Vec3D offset) {
    f.a.addSelf(offset);
    f.b.addSelf(offset);
    f.c.addSelf(offset);
  }
}



/*
  
 void getChunk(Vec3D offsetInput){
 for (int i =0; i<sphereFaces.size(); i++) {
 Face f = tmp.faces.get(i);
 if (f.a == offsetInput){
 easeInParticles(f.a);
 }
 }
 }
 
 
 //get mouse to drag out some particles
 void easeInParticles(Vec3D offsetInput) {
 println(offsetInput);
 Vec3D offset = offsetInput;
 // for (int i = 3000; i<sphereFaces.size(); i++) {
 Face f = tmp.faces.get(50);
 translateFace(f, offset);
 //}
 }
 
 void translateFace(Face f, Vec3D offset) {
 Vec3D difOffSet = new Vec3D(0,0,0);
 float worldX = f.a.x+ width/2;
 float worldY = f.a.y+ height/2;
 float worldZ = f.a.z+ 0;
 difOffSet.x = offset.x - worldX;
 difOffSet.y = offset.y -worldY;
 difOffSet.z = offset.z - worldZ;
 f.a.addSelf(difOffSet);
 //f.a.x = offset.x;
 //f.a.y = offset.y;
 //f.a.z = offset.z;
 // f.b.addSelf(offset);
 // f.c.addSelf(offset);
 tmp.computeFaceNormals();
 tmp.computeVertexNormals();
 }
 
 void easeOutParticles(Vec3D offsetInput) {
 Vec3D offset = offsetInput;
 for (int i = 3000; i<sphereFaces.size(); i++) {
 Face f = tmp.faces.get(i);
 translateBack(f, offset);
 }
 }
 
 void translateBack(Face f, Vec3D offset) {
 f.a.subSelf(offset);
 f.b.subSelf(offset);
 f.c.subSelf(offset);
 tmp.computeFaceNormals();
 tmp.computeVertexNormals();
 }
 }*/