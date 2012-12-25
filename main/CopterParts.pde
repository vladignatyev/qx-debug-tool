class Engine
{ 
  final public float draw_size = 50.0; // эталонный размер движка
  
  float maxTorsion, maxTraction, maxRevolutions;
  float engineSpeedRevolutions;
  public float leverPosition;
  
  public Vector momentum;
  public Vector force;
  public Vector position;
  
  float _revolutionDirection;
  
  float _eff;
  
  /** position relative to the mass center*/
  Engine (Vector position, float maxTraction, float maxTorsion, float maxRevolutions, float revolutionDirection, float eff)
  { 
    this.maxTorsion = maxTorsion;//кручение
    this.maxTraction = maxTraction;//тяга
    this.maxRevolutions = maxRevolutions;//Обороты
    
    leverPosition = 0.0;//рычаг
    engineSpeedRevolutions = 0.0;
    this.position = position;
    
    _eff = eff;
    
    _revolutionDirection = revolutionDirection > 0 ? 1.0 : -1.0 ; 
  }
  
  // Отрисовка движка
  void drawEN (Vector pos) // pos - in world coordinates
  {    
    // установка цвета в зависимости от мощности
    float current_color=leverPosition + 100*(leverPosition - 0.5);
    if (current_color > 1.0)
      current_color = 1.0;
   
    float current_height=leverPosition*draw_size; 
    pushMatrix();
      translate(pos.x, pos.y, pos.z);
      fill(current_color,current_color,current_color,1.0);
      box(draw_size,current_height,draw_size);
      noFill();
    popMatrix();
  }  
  
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
    leverPosition *= _eff;
  }
}
//END class ENGINE

class Copter extends InertialObject
{
  ArrayList<Engine> engines;
  public boolean _shouldStabilize;
  Vector _normal;
  Vector _destNormal; // Целевое направление нормали
  
  Copter (float mass, Vector position, float ix, float iy, float iz,
          ArrayList<Engine> engines) 
  {
    super(mass, position, ix, iy, iz);
    this.engines = engines;
    
    _normal = new Vector(0, -1, 0);
    _destNormal = new Vector(0, -1, 0);
  }
  
  public void setMoveDirection(Vector direction)
  {
    _destNormal = new Vector (0, -1, 0);
    _destNormal.add(direction).normalize();
  }
  
  // Устанавливает прирощение силы движков для стабилизации поворота относительно destinationNormal. Предполагает, что значение силы на них (на всех) в текущий момент одинаково.
  // Предполагает, что нормаль актуальна на начало апдейта.
  void stabilize (float deltaTime)
  {
    if ( ! _shouldStabilize )
    {
      return;
    }
    
    //Vector dNormal = _normal.subtracted(_prevNormal);
    //Vector normalSpeed = dNormal.scaleBy(deltaTime);
    
    Vector normalSpeed = angularSpeeds;
    Vector dNormal = _destNormal.subtracted(_normal);
    float sqrt2 = (float)Math.sqrt(2);
    
    Vector engine02axis = new Vector( sqrt2/2, 0, sqrt2/2 );
    engine02axis.rotate(angles);
    Vector engine13axis = new Vector( -sqrt2/2, 0, sqrt2/2 );
    engine13axis.rotate(angles);
    
    float dNormalProection02 = dNormal.scalarMultiply(engine02axis);
    float dNormalProection13 = dNormal.scalarMultiply(engine13axis);
    
    Vector localAngularSpeed = new Vector(angularSpeeds);
    localAngularSpeed.rotate(0, 3.14 / 4, 0).rotate(angles.negatiated());
    
    float kV = -0.1;
    float kR = 0.2;
    setEngineLever(0, engines.get(0).leverPosition + kR * dNormalProection02 + kV * localAngularSpeed.x);
    setEngineLever(2, engines.get(2).leverPosition - kR * dNormalProection02 - kV * localAngularSpeed.x);
    setEngineLever(1, engines.get(1).leverPosition + kR * dNormalProection13 + kV * localAngularSpeed.z);
    setEngineLever(3, engines.get(3).leverPosition - kR * dNormalProection13 - kV * localAngularSpeed.z);
  }
  
  void update (float deltaTime)
  {
    stabilize(deltaTime);
    
    for (int i = 0; i < this.engines.size(); i++)
    {
      Engine e = this.engines.get(i);
      e.update(deltaTime);
      
      applyLocalForce(e.force);
      applyLocalMomentum(e.momentum);
      String str;
    }
    
    applyGravity();
    super.update(deltaTime);

    // Обновляем нормаль
    _normal = new Vector(0, -1, 0);
    _normal.rotate(angles);
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
      /*System.out.printf("  Engine # %u:, Lever position: %f, Forse: %f, Momentum: %f\n", 
                          String.valueOf(i), String.valueOf(e.leverPosition), String.valueOf(e.momentum));*/
    }
  } 
  
  /* draw helicopter with size and color specified */
  void drawCS(float size, float r, float g, float b)
  { 
    pushMatrix();

    
      translate(position.x, position.y, position.z); //Смещение фигуры в глобальной СК      
      //Поворот фигуры в глобальной СК
      rotateX(-angles.x);
      rotateY(-angles.y);
      rotateZ(-angles.z);
          
      beginShape(QUADS);
        stroke(1.0,1.0,1.0, 1.0);
        fill(r,g,b,0.1);  
        vertex(-size/2,-size/2,-size/2);
        vertex(-size/2,size/2,-size/2);
        vertex(size/2,size/2,-size/2);
        vertex(size/2,-size/2,-size/2); //back
        
        vertex(-size/2,-size/2,size/2);
        vertex(-size/2,size/2,size/2);
        vertex(size/2,size/2,size/2);
        vertex(size/2,-size/2,size/2); //front
        
        vertex(-size/2, -size/2, -size/2);
        vertex(-size/2, -size/2, size/2);
        vertex(-size/2, size/2, size/2);
        vertex(-size/2, size/2, -size/2);//left
        
        vertex(size/2, -size/2, -size/2);
        vertex(size/2, -size/2, size/2);
        vertex(size/2, size/2, size/2);
        vertex(size/2, size/2, -size/2);//right
        
        vertex(-size/2, size/2, -size/2);
        vertex(-size/2, size/2, size/2);
        vertex(size/2, size/2, size/2);
        vertex(size/2, size/2, -size/2);//top
        
        vertex(-size/2, -size/2, -size/2);
        vertex(-size/2, -size/2, size/2);
        vertex(size/2, -size/2, size/2);
        vertex(size/2, -size/2, -size/2);//bottom
        
      endShape();
      

	  noFill();
      
	  /* engines drawing */
      //Координаты двигателей
      this.engines.get(0).drawEN(new Vector(-50,0,-50));
      this.engines.get(1).drawEN(new Vector(50,0,-50));
      this.engines.get(2).drawEN(new Vector(50,0,50));
      this.engines.get(3).drawEN(new Vector(-50,0,50));

    popMatrix();
  }	

 public void WritetoFile(String str) {
   RandomAccessFile aFile;
        try{
            aFile=new RandomAccessFile("D:\\Myfile","rw");//открываем для чтения/записи
                aFile.seek(aFile.length());
                aFile.writeChars(str);
            }
        catch (Exception e){
            e.printStackTrace();
        }
  }
}

