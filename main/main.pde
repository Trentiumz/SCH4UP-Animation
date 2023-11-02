/**
 * Circle Collision with Swapping Velocities
 * by Ira Greenberg. 
 * 
 * Based on Keith Peter's Solution in
 * Foundation Actionscript Animation: Making Things Move!
 
 */
 
final int START_SIZE = 1000;
final int BORDER = 25;

Particle[] parts;
double[][] prob = new double[Type.TYPES][Type.TYPES];
int[][][] results = new int[Type.TYPES][Type.TYPES][2];
Collider[] collisionTypes = {
   new Collider(Type.H2O, Type.H2O, 0.002, Type.H3O, Type.OH),
   new Collider(Type.H3O, Type.OH, 0.01, Type.H2O, Type.H2O),
   new Collider(Type.HCO3, Type.H2O, 0.05, Type.H2CO3, Type.OH),
   new Collider(Type.H2CO3, Type.H2O, 0.7, Type.HCO3, Type.H3O),
   new Collider(Type.HCO3, Type.H3O, 0.95, Type.H2CO3, Type.H2O),
   new Collider(Type.H2CO3, Type.OH, 0.95, Type.HCO3, Type.H2O)
};

void setup() {
  size(1280, 720);
  for(Collider c : collisionTypes) {
    prob[c.r1][c.r2] = prob[c.r2][c.r1] = c.p;
    results[c.r1][c.r2] = results[c.r2][c.r1] = new int[]{c.p1, c.p2};
  }
  
  parts = new Particle[START_SIZE];
  for(int i = 0; i < START_SIZE; i++){
    parts[i] = new Particle(int(random(width)), int(random(height)), 10, 0, width - 2 * BORDER, height - 2 * BORDER);
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
               int[] become = results[parts[i].type][parts[j].type];
               parts[i].type = become[0]; //<>//
               parts[j].type = become[1];
            }
        }
     }
  }
  
  int[] cnt = new int[Type.TYPES];
  for(Particle p : parts){
     ++cnt[p.type]; 
  }
  //System.out.println(cnt[Type.H2O] + " " + cnt[Type.H3O] + " " + cnt[Type.OH]);
  System.out.println((double) cnt[Type.H3O] / START_SIZE);
  
  popMatrix();
}
