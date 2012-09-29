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

