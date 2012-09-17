class Matrix
{
           float _a, _b, _c,
                 _e, _f, _g,
                 _i, _j, _k;

   Matrix (float a, float b, float c, 
           float e, float f, float g, 
           float i, float j, float k)
   {
     _a = a;
     _b = b;
     _c = c;
     _e = e;
     _f = f;
     _g = g;
     _i = i;
     _j = j;
     _k = k;
   } 
   
   public Vector multiply(Vector v)
   {
     Vector result = new Vector(
     _a * v.x + _b * v.y + _c * v.z,
     _e * v.x + _f * v.y + _g * v.z,
     _i * v.x + _j * v.y + _k * v.z);
     return result;
   }
   
   public void multiply(Vector v, Vector result)
  {
    result.x = _a * v.x + _b * v.y + _c * v.z;
    result.y = _e * v.x + _f * v.y + _g * v.z;
    result.z =  _i * v.x + _j * v.y + _k * v.z;
  }
 }

