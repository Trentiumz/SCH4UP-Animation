/**
 * Circle Collision with Swapping Velocities
 * by Ira Greenberg. 
 * 
 * Based on Keith Peter's Solution in
 * Foundation Actionscript Animation: Making Things Move!
 
 */
import javax.swing.*;
import java.awt.*;
final int START_SIZE = 40;
final int BORDER = 25;
//Graph g;
Window w;
int m;

public Particle[] particles;

void setup() {
  size(1280, 720);
  particles = new Particle[START_SIZE];
  for(int i = 0; i < START_SIZE; i++){
    particles[i] = new Particle(int(random(width)), int(random(height)), 10, int(random(4)), width - 2 * BORDER, height - 2 * BORDER);
  }
  w = new Window(1000, 720);
  String[] args = {"Graph"};
  PApplet.runSketch(args, w);
  m = millis();
  //g = new Graph(640, 360,360, 640 );
  loadImages();
}

void draw() {
  background(0);
  
  pushMatrix();
  translate(BORDER, BORDER);
  
  fill(30);
  rect(0, 0, width - 2 * BORDER, height - 2 * BORDER);

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
  popMatrix();
}
//public class Graph {
//  public int x, y, w, h;
//  public Graph(int x, int y, int w, int h){
//     this.x = x;
//     this.y = y;
//     this.w = w;
//     this.h = h;
//  }
//  public void init(){
    
//  }
//  public void update(){
    
//  }
//}

public class Window extends PApplet{
  int w, h;
  public Window(int w, int h){
    this.w = w;
    this.h = h;
  }
  public void settings() {
    size(w, h);
  }
  public void draw() {
    stroke(0);
    line(0.1*w, 0.1*h, 0.1*w, 0.9*h);// y-axis
    line(0.1*w, 0.9*h, 0.9*w, 0.9*h);//x-axis
    if (abs((millis()*100) % 0.8*w) <0.0001){
      background(255);
      fill(255);
    }
    plot();
    
  }
  public void plot(){
    int bicarbonate=0, carbonic=0, water=0, hydronium =0;
    for (int i = 0; i < START_SIZE; i++){
      switch(particles[i].type){
        case 0:
          water+=1;
          break;
        case 1:
          hydronium+=1;
          break;
        case 2:
          carbonic +=1;
          break;
        case 4:
          bicarbonate+=1;
          break;
      }
    }
    stroke(255, 0, 0);
    point(0.1*w+(millis()*100)%0.8*w, 0.9*h-0.8*h*bicarbonate);
    stroke(0, 255, 0);
     point(0.1*w+(millis()*100)%0.8*w, 0.9*h-0.8*h*carbonic);
    stroke(0, 0, 255);
     point(0.1*w+(millis()*100)%0.8*w, 0.9*h-0.8*h*water);
    stroke(255, 0, 255);
     point(0.1*w+(millis()*100)%0.8*w, 0.9*h-0.8*h*hydronium);
  }
}
