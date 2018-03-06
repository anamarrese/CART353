class MeshWorld {

  int voxelRes;
  float voxelStrokeWeight;
  int sphereRes;
  int smoother;
  ToxiclibsSupport gfx;
  WETriangleMesh mesh;
  boolean isWireframe;
  WETriangleMesh tmp;
  SphereFunction sf;
  float rot = 1;
  List <Face> sphereFaces;

  MeshWorld(ToxiclibsSupport input) {
    gfx = input;
    voxelRes = 90;
    voxelStrokeWeight = 1;
    sphereRes = 10;
    smoother = 40;
    SphereFunction sf=new SphereFunction(new Sphere(250));
    sf.setMaxTheta(360);
    Mesh3D hemi=new SurfaceMeshBuilder(sf).createMesh(null, sphereRes, 1, false);
    WETriangleMesh tmp=new WETriangleMesh().addMesh(hemi);
    mesh=MeshLatticeBuilder.build(tmp, voxelRes, voxelStrokeWeight);
    sphereFaces =  mesh.getFaces();
    // update normals (for shading)
    mesh.computeVertexNormals();
    //laplacian smooth mesh filter
    for (int i=0; i<smoother; i++) {
      new LaplacianSmooth().filter(mesh, 1);
    }
  }

  void displayMeshWorld() {
    lights();
    pushMatrix();
    translate(width/2, height/2,0);
    
    

    rotateX(rot++*0.001);
    rotateY(rot++*0.001);
    rotateZ(rot++*0.001);
 

    // apply wireframe/filled render settings
    gfx.chooseStrokeFill(isWireframe, TColor.newRGB(243, 237, 236), TColor.WHITE);
    // draw lattice mesh
    gfx.mesh(mesh);
    popMatrix();
  }
  
  
  void activateMovingParticles() {
    for (Face f : mesh.faces) {
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