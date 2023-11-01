/**
 * Circle Collision with Swapping Velocities
 * by Ira Greenberg. 
 * 
 * Based on Keith Peter's Solution in
 * Foundation Actionscript Animation: Making Things Move!
 
 */
 
final int START_SIZE = 1000;

Particle[] particles;

void setup() {
  size(640, 360);
  particles = new Particle[START_SIZE];
  for(int i = 0; i < START_SIZE; i++){
    particles[i] = new Particle(int(random(width)), int(random(height)), 2);
  }
}

void draw() {
  background(51);

  for (Particle p : particles) {
    p.update();
    p.display();
    p.checkBoundaryCollision();
  }
  
  for(int i = 0; i < particles.length; i++){
     for(int j = i + 1; j < particles.length; j++){
        particles[i].checkCollision(particles[j]); 
     }
  }
}
