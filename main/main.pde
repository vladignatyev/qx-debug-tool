Copter copter;
float baseEngineLevel = 0.5;
float engineMouseSensitivity = 0.01;
float engine1 = 0.0;
float engine2 = 0.0;
float engine3 = 0.0;
float engine4 = 0.0;

int viewWidth = 800;
int viewHeight = 600;

void setup()
{
  size (viewWidth, viewHeight, P3D);
  colorMode(RGB, 1); 
  
  copter = new Copter(1.0, new Vector(400, 300, -130), 1.0, 1.0, 1.0,
                           new ArrayList<Engine>(){{
                             add(new Engine(new Vector(-1.0, 0.0, -1.0), 2.4526 * 2.0, 0.1, 1000, 1.0));
                             add(new Engine(new Vector( 1.0, 0.0, -1.0), 2.4526 * 2.0, 0.1, 1000, -1.0));
                             add(new Engine(new Vector( 1.0, 0.0,  1.0), 2.4526 * 2.0, 0.1, 1000, -1.0));
                             add(new Engine(new Vector(-1.0, 0.0,  1.0), 2.4526 * 2.0, 0.1, 1000, 1.0));
                           }});
  updateEnginesLevers();
}

void updateEnginesLevers()
{
  copter.setEngineLever(0, baseEngineLevel + engine1);
  copter.setEngineLever(1, baseEngineLevel + engine2);
  copter.setEngineLever(2, baseEngineLevel + engine3);
  copter.setEngineLever(3, baseEngineLevel + engine4);
}

void draw()
{
  background(0.2);
  copter.clean();
 if (keys['t']) {
   baseEngineLevel = 1.0;
 } else if (keys['g']) {
   baseEngineLevel = 0.4;
 } else {
   baseEngineLevel = 0.5;
 }
 
 engine1 = keys['u']? engineMouseSensitivity : (keys['w']? -engineMouseSensitivity : 0.0);
 engine2 = keys['i']? engineMouseSensitivity : (keys['e']? -engineMouseSensitivity : 0.0);
 engine3 = keys['k']? engineMouseSensitivity : (keys['s']? -engineMouseSensitivity : 0.0);
 engine4 = keys['j']? engineMouseSensitivity : (keys['d']? -engineMouseSensitivity : 0.0);
  
 updateEnginesLevers();
   
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
