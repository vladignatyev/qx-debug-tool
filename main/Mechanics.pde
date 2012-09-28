class MassPoint
{
  MassPoint(float mass, Vector position)
  {
    this.mass = mass;
    this.position = position;
    velocity = new Vector(0.0, 0.0, 0.0);
    appliedForce = new Vector(0.0, 0.0, 0.0);
  }
  
  void clean()
  {
    appliedForce.x = 0.0;
    appliedForce.y = 0.0;
    appliedForce.z = 0.0;
  }
  
  void update(float deltaTime)
  {
    position.add(velocity.add(appliedForce.scaleBy(deltaTime * deltaTime / mass)));
  }
  
  void applyForce(Vector force)
  {
    appliedForce.add(force);
  }
  
  void applyGravity(Vector down)
  {
    final float g = 9.81; 
    applyForce(down.scaledBy(mass*g)); 
  }
  
  void drawCS (float size, float r, float g, float b)
  {
    pushMatrix();
      translate(position.x, position.y, position.z);
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
        vertex(size/2, size/2, -size/2);//tpo
        
        vertex(-size/2, -size/2, -size/2);
        vertex(-size/2, -size/2, size/2);
        vertex(size/2, -size/2, size/2);
        vertex(size/2, -size/2, -size/2);//bottom
      endShape();
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
  
  float mass;
  Vector position;
  Vector velocity;
  Vector appliedForce;
}

class InertialObject extends MassPoint
{
  InertialObject(float mass, Vector position, float ix, float iy, float iz)
  {
    super(mass, position);
    this.ix = ix;
    this.iy = iy;
    this.iz = iz;
    angles = new Vector(0.0,0.0,0.0);
    angularSpeeds = new Vector(0.0,0.0,0.0);
    localMomentum = new Vector(0.0,0.0,0.0);
    localForce = new Vector(0.0, 0.0, 0.0);
  }
  
  void clean()
  {
    super.clean();
    
    localMomentum.x = 0.0;
    localMomentum.y = 0.0;
    localMomentum.z = 0.0;
    
    localForce.x = 0.0;
    localForce.y = 0.0;
    localForce.z = 0.0;
  }
  
  void applyLocalForce(Vector force) // force in global CS
  {
    localForce.add(force);
  }
  
  void update(float deltaTime)
  {
    updateCS();
    
    position.add(velocity.add(appliedForce.scaleBy(deltaTime * deltaTime / mass)));
    position.add(velocity.add(localForce.multiplied(coordinateSystem).scaleBy(deltaTime * deltaTime / mass)));
    
    final float omegaX = localMomentum.x / ix;
    final float omegaY = localMomentum.y / iy;
    final float omegaZ = localMomentum.z / iz;
    
    angularSpeeds.add(new Vector(omegaX, omegaY, omegaZ).scaleBy(deltaTime));
    angles.add(angularSpeeds.scaledBy(deltaTime));
  }
  
  void applyLocalMomentum(Vector momentum)
  {
    localMomentum.add(momentum);
  } 
  
  void drawUp(float size)
  {
    pushMatrix();
      translate(position.x, position.y, position.z);
      Vector localUp = new Vector(0, -1, 0);
      Vector globalUp = localUp.multiplied(coordinateSystem).scaleBy(size);
      noFill();
      beginShape(LINES);
        stroke(1.0, 0.0, 0.0);
        vertex(0.0, 0.0, 0.0);
        vertex(globalUp.x, globalUp.y, globalUp.z);
        vertex(globalUp.x, globalUp.y, globalUp.z);
        vertex(globalUp.x+size/8.0, globalUp.y, globalUp.z);
      endShape();
    popMatrix();    
  }  
  void drawCS(float size, float r, float g, float b)
  {
    pushMatrix();
      translate(position.x, position.y, position.z);
      rotateX(angles.x);
      rotateY(angles.y);
      rotateZ(angles.z);
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
        vertex(size/2, size/2, -size/2);//tpo
        
        vertex(-size/2, -size/2, -size/2);
        vertex(-size/2, -size/2, size/2);
        vertex(size/2, -size/2, size/2);
        vertex(size/2, -size/2, -size/2);//bottom
        
      endShape();
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
  
  void applyGravity()
  {
    final float g = 9.81; 
    applyForce((new Vector(0.0, 1.0, 0.0)).scaleBy(mass * g));
  }

  void updateCS()
  {
    Matrix mx = new Matrix(); 
    mx.rotationX(angles.x);
    
    Matrix my = new Matrix();
    my.rotationY(angles.y);
    
    Matrix mz = new Matrix();
    mz.rotationZ(angles.z);
    
    // mx*my*mz
    mx.multiplyBy(my);
    mx.multiplyBy(mz);
    
    coordinateSystem = mx; 
  }
  
  Matrix coordinateSystem;
  
  Vector localForce;    //force in local CS
  //Vector appliedForce; // force in global CS
  Vector localMomentum; // momentum in local CS
  Vector angularSpeeds;
  Vector angles;
  
  float ix, iy, iz;
}

