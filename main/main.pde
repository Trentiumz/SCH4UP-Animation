/**
 * Circle Collision with Swapping Velocities
 * by Ira Greenberg. 
 * 
 * Based on Keith Peter's Solution in
 * Foundation Actionscript Animation: Making Things Move!
 
 */
 
final int START_SIZE = 100;
final int BORDER = 25;

Particle[] parts;
double[][] prob = new double[Type.TYPES][Type.TYPES];
int[][][] results = new int[Type.TYPES][Type.TYPES][2];
Collider[] collisionTypes = {
   new Collider(Type.H2O, Type.H2O, 0.2, Type.H3O, Type.OH),
   new Collider(Type.H3O, Type.OH, 0.6, Type.H2O, Type.H2O)
};

void setup() {
  size(1280, 720);
  for(Collider c : collisionTypes) {
    prob[c.r1][c.r2] = prob[c.r2][c.r1] = c.p;
    results[c.r1][c.r2] = results[c.r2][c.r1] = new int[]{c.p1, c.p2};
  }
  
  parts = new Particle[START_SIZE];
  for(int i = 0; i < START_SIZE; i++){
    parts[i] = new Particle(int(random(width)), int(random(height)), 30, 0, width - 2 * BORDER, height - 2 * BORDER);
  }
  loadImages();
}

void draw() {
  background(0);
  
  pushMatrix();
  translate(BORDER, BORDER);
  
  fill(30);
  rect(0, 0, width - 2 * BORDER, height - 2 * BORDER);

  for (Particle p : parts) {
    p.update();
    p.display();
    p.checkBoundaryCollision();
  }
  
  for(int i = 0; i < parts.length; i++){
     for(int j = i + 1; j < parts.length; j++){
        if(parts[i].checkCollision(parts[j])) {
            if(random(1) < prob[parts[i].type][parts[j].type]){
               parts[i].type = results[parts[i].type][parts[j].type][0];
               parts[j].type = results[parts[i].type][parts[j].type][1];
            }
        }
     }
  }
  
  popMatrix();
}
