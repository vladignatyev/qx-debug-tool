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
  
  /**
   * Apply gravity in CS of object
   */
  void applyGravity(Vector direction)
  {
    final float g = 9.81;
    applyForce(gravity.scaledBy(mass*g));
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
    appliedMomentum = new Vector(0.0,0.0,0.0);
    coordinateSystem = new Matrix( 1.0, 0.0, 0.0, 
                                   0.0, 1.0, 0.0,
                                   0.0, 0.0, 1.0);
  }
  
  void clean()
  {
    super.clean();
    
    appliedMomentum.x = 0.0;
    appliedMomentum.y = 0.0;
    appliedMomentum.z = 0.0;
  }
  
  void update(float deltaTime)
  {
    super.update(deltaTime);
    
    final float omegaX = appliedMomentum.x / ix;
    final float omegaY = appliedMomentum.y / iy;
    final float omegaZ = appliedMomentum.z / iz;
    
    angularSpeeds.add(new Vector(omegaX, omegaY, omegaZ).scaleBy(deltaTime));
    angles.add(angularSpeeds.scaledBy(deltaTime));
  }
  
  void applyMomentum(Vector momentum)
  {
    appliedMomentum.add(momentum);
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
  
  /**
   * Update CS of object
   */
  void updateCS()
  {
    final float x = (float) (Math.cos(angles.x)); //todo:
  }
  
  Matrix coordinateSystem;
  
  Vector appliedMomentum;
  Vector angularSpeeds;
  Vector angles;
  
  float ix, iy, iz;
}

