public class Vector
{
  Vector ()
  {
    x = 0.0;
    y = 0.0;
    z = 0.0;
  }
  
  Vector (float x, float y, float z)
  {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public Vector scaledBy(float value)
  {
    return new Vector(x * value, y * value, z * value);
  }
  
  public Vector scaleBy(float value)
  {
    x = x * value;
    y = y * value;
    z = z * value;
    return this;
  }
  
  public float length()
  {
    return (float) Math.sqrt(x*x + y*y + z*z);
  }
  
  public Vector negatiate()
  {
    x = -x;
    y = -y;
    z = -z;
    return this;
  }
  
  public Vector normalized()
  {
    float l = length();
    return new Vector(x / l, y / l, z / l);
  }
  
  public Vector multiplied(Matrix m)
  {
    Vector result = new Vector();
    result.x = x * m._a + y * m._e + z * m._i;
    result.y = x * m._b + y * m._f + z * m._g;
    result.z = x * m._i + y * m._j + z * m._k;
    return result;
  }
  
  public Vector subtract(Vector v)
  {
    x = x - v.x;
    y = y - v.y;
    z = z - v.z;
    return this;
  }
  
  public Vector add (Vector v)
  {
    x = x + v.x;
    y = y + v.y;
    z = z + v.z;
    return this;
  }
  
  public Vector subtracted(Vector v)
  {
    return new Vector(x - v.x, y - v.y, z - v.z);
  }
  
  public Vector dotproduct(Vector v)
  {
    return new Matrix(0.0,   -z,   y,
                 z,  0.0,  -x,
                -y,    x,  0.0).multiply (v);  
  }
  
  public void print (String name)
  {
    System.out.printf("\n%s = \n %8.4f %8.4f %8.4f\n", name, x, y, z);
  }
  
  public float x, y, z;  
}

