class EngineSound
{
  //todo implement for debugging purpose
}

class Engine
{ 
  
  /** position relative to the mass center*/
  Engine (Vector position, float maxTraction, float maxTorsion, float maxRevolutions, float revolutionDirection)
  { 
    this.maxTorsion = maxTorsion;
    this.maxTraction = maxTraction;
    this.maxRevolutions = maxRevolutions;
    
    leverPosition = 0.0;
    engineSpeedRevolutions = 0.0;
    this.position = position;
    
    _revolutionDirection = revolutionDirection > 0 ? 1.0 : -1.0 ;
  }
  
  float maxTorsion, maxTraction, maxRevolutions;
  float engineSpeedRevolutions;
  public float leverPosition;
  
  public Vector momentum;
  public Vector force;
  public Vector position;
  
  float _revolutionDirection;
  
  void update(float deltaTime)
  {
    engineSpeedRevolutions = leverPosition * maxRevolutions;
    
    final Vector up = new Vector(0.0, -1.0, 0.0);
    final Vector torsion = up.scaledBy(leverPosition * maxTorsion * _revolutionDirection);
    force = up.scaledBy(leverPosition * maxTraction);
        
    momentum = torsion.add(force.dotProduct(position)); 
  }
  
  void setLever(float newValue)
  {
    if (newValue >= 0.0 && newValue <= 1.0){
      leverPosition = newValue;
    } else if (newValue < 0.0) {
      leverPosition = 0.0;
    } else if (newValue > 1.0) {
      leverPosition = 1.0;
    }
  }
}

class Copter extends InertialObject
{
  Copter (float mass, Vector position, float ix, float iy, float iz,
          ArrayList<Engine> engines) 
  {
    super(mass, position, ix, iy, iz);
    
    this.engines = engines;
  }
  
  ArrayList<Engine> engines;
  
  void update (float deltaTime)
  {
    for (int i = 0; i < this.engines.size(); i++)
    {
      Engine e = this.engines.get(i);
      e.update(deltaTime);
      
      applyLocalForce(e.force);
      applyLocalMomentum(e.momentum);
    }
    
    applyGravity();
    super.update(deltaTime);
    print("Copter");
  }
  
  void setEngineLever(int engineId, float position) {
    Engine engine = this.engines.get(engineId);
    engine.setLever(position);
  }
  
  void print(String name)
  {
    System.out.printf("Copter [%s]:\n", name);
    for (int i = 0; i < this.engines.size(); i++)
    {
      Engine e = this.engines.get(i);
//      System.out.printf("  Engine # %u:\n", i);
      System.out.printf("     Lever position: %f\n", e.leverPosition);
          e.force.print("     Force:");
       e.momentum.print("     Momentum:");
    }
  }
}

