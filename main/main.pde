/*
class Copter
{
  float x, y, z = 0.0;    // position
  float ox, oy, oz = 0.0; // angles
  
  private float colorR, colorG, colorB; // base color
  
  Copter(float r, float g, float b)
  {
    this.colorR = r;
    this.colorG = g;
    this.colorB = b;
  }
  
  void update(float deltaTime)
  {
    ox = ox + 0.02;
    oy = oy + 0.03;
    oz = oz + 0.04;
  }
  
  abstract void draw();
//    noStroke();
//    pushMatrix();
//    translate(x, y, z);
//    
//    beginShape(QUADS);
//      fill (colorR, colorG, colorB); 
//      vertex(-10, -10, 1);
//      vertex(-10,  10, 1);
//      vertex( 10,  10, 1);
//      vertex( 10, -10, 1);
//    endShape(); 
//    
//    popMatrix();
  /*
  void drawCS(float size) // draw coordinate system of this copter
  {
    pushMatrix();
      translate(x, y, z);
      rotateX(ox);
      rotateY(oy);
      rotateZ(oz);
      beginShape(LINES);
      stroke(1,0,0);
      vertex(0,0,0);
      vertex(size,0,0);

      stroke(0,1,0);
      vertex(0,0,0);
      vertex(0,size,0);
      stroke(0,0,1);
      vertex(0,0,0);
      vertex(0,0,size);   
      endShape();
    popMatrix();
  }
}
*/


/*
class Engine
{ 
  Engine (Vector traction, float maxTraction, float maxTorsion, float maxRevolutions)
  {
    _traction = traction;
    _torsion = traction.normalized().negatiate();
    torsionValue = 0.0;
    tractionValue = 0.0;
    this.maxTorsion = maxTorsion;
    this.maxTraction = maxTraction;
    this.maxRevolutions = maxRevolutions;
    this.engineSpeedRevolutions = 0.0;
  }
  
  Vector _traction;
  Vector _torsion;
  float tractionValue;
  float torsionValue;
  float maxTorsion;
  float maxTraction;
  float maxRevolutions;
  float engineSpeedRevolutions;
  
  void updateState()
  {
    final float rate = engineSpeedRevolutions / maxRevolutions;
    torsionValue = maxTorsion * rate;
    tractionValue = maxTraction * rate;
  }
  
  
  public Vector getTraction()
  {
    return _traction.scaledBy(tractionValue);
  }
  
  public Vector getTorsion()
  {
    return _torsion.scaledBy(torsionValue);
  }
  
  void setRate(float value)
  {
    if (value > maxRevolutions)
      engineSpeedRevolutions = value;
    else if (value < 0.0)
      engineSpeedRevolutions = 0.0;
    else
      engineSpeedRevolutions = value;
  }
}

//Copter copter = new QuadroCopter(1.0, 0.0, 0.0);

//Engine e = new Engine(new Vector(), );
*/
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
  }
  
  
  /*
  
  ^ A                     ^ B
  |                       |
  *-----------------------*
              |
              |
              V mg
  
  */
  void update(float deltaTime)
  {
    super.clean();
    applyForce(A);//A
    applyForce(B);//B
    applyMomentum(A.dotproduct(Ar));
    applyMomentum(B.dotproduct(Br));
    super.update(deltaTime);
  }
  
  Vector A = new Vector(0.0, 2.0, 0.0);
  Vector B = new Vector(0.0, 1.0, 0.0);
  Vector Ar = new Vector(1.0, 0.0, 0.0);
  Vector Br = new Vector(-1.0, 0.0, 0.0);
}

//InertialObject m = new InertialObject (1.0, new Vector(400, 0,-30), 10.0, 1.0, 1.0);
DuoCopter copter = new DuoCopter(1.0, new Vector(400, 0, -30), 1.0, 1.0, 1.0);
Boolean down = false;
void draw()
{
  background(0.2);
  copter.update(0.1);
  copter.drawCS(100, 1.0, 0.0, 0.0);
}

void keyReleased()
{
   if (key == 't')
  { 
    down = false; 
  }
}
// key up handler
void keyPressed()
{
  if (key == 't')
  { 
    down = true; 
  }
}
