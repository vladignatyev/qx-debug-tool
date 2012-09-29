void setup()
{
  size (800, 600, P3D);
  colorMode(RGB, 1); 
}

class DuoCopter extends InertialObject
{
  DuoCopter(float mass, Vector position, float ix, float iy, float iz)
  {
    super(mass, position, ix, iy, iz);
//    angles.x = (float) Math.PI / 4.0;
//    angles.y = (float) Math.PI / 4;
//    angles.z = (float) Math.PI / 4.0;
  }
  
  void update(float deltaTime)
  {
    // applying internal forces and momentum
    applyLocalForce(A);//A
    applyLocalForce(B);//B
    applyLocalMomentum(A.dotproduct(Ar));
    applyLocalMomentum(B.dotproduct(Br));
   
//    applyGravity();
    
    super.update(deltaTime);
  }
  // forces in local CS
  Vector A = new Vector();
  Vector B = new Vector();
  
  // force A radius vector
  Vector Ar = new Vector(1.0, 0.0, 0.0);
  Vector Br = new Vector(-1.0, 0.0, 0.0);
  
}

DuoCopter copter = new DuoCopter(1.0, new Vector(400, 300, -130), 1.0, 1.0, 1.0);



void draw()
{
  background(0.2);
  
copter.clean();
 if (keys['t']) {
   copter.A = new Vector(0.0, -1.0, 0.0);
   copter.B = new Vector(0.0, -1.001, 0.0);
//copter.applyLocalMomentum(new Vector(0.9, 0.1, 0.0));
 } else {
   copter.A = new Vector();
   copter.B = new Vector();
 }
   
  copter.applyGravity();
  copter.update(0.1);
  
  copter.drawCS(100.0, 1.0, 1.0, 1.0);
copter.drawUp(100.0);
drawGlobalCS(1000.0);
}

boolean[] keys = new boolean[65536]; 

void handleKeys(char key)
{
}

void drawGlobalCS(float size)
{
  pushMatrix();
    noFill();
      beginShape(LINES);
        stroke(1.0, 0.0, 0.0);
        vertex(0.0, 0.0, 0.0);
        vertex(size, 0.0, 0.0);
        stroke(0.0, 1.0, 0.0);
        vertex(0.0, 0.0, 0.0);
        vertex(0.0, size, 0.0);
        stroke(0.0, 0.0, 1.0);
        vertex(0.0, 0.0, 0.0);
        vertex(0.0, 0.0, size);
      endShape();
  popMatrix();
}

void keyReleased()
{
  keys[key] = false;
  handleKeys(key);
}

void keyPressed()
{
  keys[key] = true;
  handleKeys(key);
}
