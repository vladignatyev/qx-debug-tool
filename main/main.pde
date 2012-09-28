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
  
  void update(float deltaTime)
  {
    super.clean();
    // applying internal forces and momentum
    applyLocalForce(A);//A
    applyLocalForce(B);//B
    applyLocalMomentum(A.dotproduct(Ar));
    applyLocalMomentum(B.dotproduct(Br));
    
//    angles.z += 0.02;
    
    applyGravity();
    super.update(deltaTime);
  }
  // forces in local CS
  Vector A = new Vector(0.0, 0.0, 0.0);
  Vector B = new Vector(0.0, 0.0, 0.0);
  
  // force A radius vector
  Vector Ar = new Vector(1.0, 0.0, 0.0);
  Vector Br = new Vector(-1.0, 0.0, 0.0);
  
}

DuoCopter copter = new DuoCopter(1.0, new Vector(400, 300, -130), 1.0, 1.0, 1.0);

void draw()
{
  background(0.2);
  copter.update(0.1);
  copter.drawUp(100.0);  
}

boolean[] keys = new boolean[256]; 

void handleKeys(char key)
{
  if (key == 't' || key == 'g'){
    if (keys['t']) {
      copter.A = new Vector(0.0, -0.5, 0.0);
    } else if (keys['g']) {
      copter.A = new Vector(0.0, 0.5, 0.0);
    } else {
      copter.A = new Vector(0.0, 0.0, 0.0);
    }
  }
  
  if (key == 'y' || key == 'h'){
    if (keys['y']) {
      copter.B = new Vector(0.0, -0.5, 0.0);
    } else if (keys['h']) {
      copter.B = new Vector(0.0, 0.5, 0.0);
    } else {
      copter.B = new Vector(0.0, 0.0, 0.0);
    }
  }
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
