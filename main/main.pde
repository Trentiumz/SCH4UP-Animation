/**
 * Circle Collision with Swapping Velocities
 * by Ira Greenberg. 
 * 
 * Based on Keith Peter's Solution in
 * Foundation Actionscript Animation: Making Things Move!
 
 */
import javax.swing.*;
import java.awt.*;

//Graph g;
Window graph;
Simulation simulation;

// global variables
Particle[] parts = {};

void setup() {
  graph = new Window(1000, 720);
  simulation = new Simulation(1280, 720);
  simulation.setup();
  
  loadImages();
  
  args = new String[] {"Simulation"};
  PApplet.runSketch(args, simulation);
  
  String[] args = {"Graph"};
  PApplet.runSketch(args, graph);
}

public class Simulation extends PApplet {
   int w, h;
   
    final int[] START_SIZE = {1000, 0, 500, 0, 500, 0};
    int TOTAL_SIZE;
    final int BORDER = 25;
    double[][] prob = new double[Type.TYPES][Type.TYPES];
    int[][][] results = new int[Type.TYPES][Type.TYPES][2];
    Collider[] collisionTypes = {
       new Collider(Type.H2O, Type.H2O, 0.05, Type.H3O, Type.OH),
       new Collider(Type.H3O, Type.OH, 0.005, Type.H2O, Type.H2O),
       new Collider(Type.HCO3, Type.H2O, 0.05, Type.H2CO3, Type.OH),
       new Collider(Type.H2CO3, Type.H2O, 0.01, Type.HCO3, Type.H3O),
       new Collider(Type.HCO3, Type.H3O, 0.05, Type.H2CO3, Type.H2O),
       new Collider(Type.H2CO3, Type.OH, 0.01, Type.HCO3, Type.H2O)
    };
   
   public Simulation(int w, int h){
      this.w = w;
      this.h = h;
   }
   
   public void settings() {
      size(w, h); 
   }
   
   public void setup(){
      for(Collider c : collisionTypes) {
        prob[c.r1][c.r2] = prob[c.r2][c.r1] = c.p;
        results[c.r1][c.r2] = results[c.r2][c.r1] = new int[]{c.p1, c.p2};
      }
      
      TOTAL_SIZE = 0;
      for(int i : START_SIZE){
         TOTAL_SIZE += i; 
      }
      parts = new Particle[TOTAL_SIZE];
      for(int type = 0, i=0; type < START_SIZE.length; type++){ 
        for(int j = 0; j < START_SIZE[type]; i++, j++){
          parts[i] = new Particle(int(random(width)), int(random(height)), 3, type, width - 2 * BORDER, height - 2 * BORDER, this);
        }
      }
   }
   
   public void draw() {
    background(0); //<>//
    
    pushMatrix();
    translate(BORDER, BORDER);
    
    fill(30);
    rect(0, 0, width - 2 * BORDER, height - 2 * BORDER);
  
    for (Particle p : parts) {
      p.update();
    }
    
    for(int i = 0; i < parts.length; i++){
       for(int j = i + 1; j < parts.length; j++){
          if(parts[i].checkCollision(parts[j])) {
              if(random(1) < prob[parts[i].type][parts[j].type]){
                 int[] become = results[parts[i].type][parts[j].type];
                 parts[i].type = become[0];
                 parts[j].type = become[1];
              }
          }
       }
    }
    
    for(Particle p : parts){
      p.checkBoundaryCollision();
      p.display();
    }
    
    popMatrix();  //<>//
   }
}

public class Window extends PApplet{
  int w, h,x;
  int m;
  
  public Window(int w, int h){
    this.w = w;
    this.h = h;
    x = 0;
    this.m = millis();
  }
  
  public void settings() {
    size(w, h);
  }
  
  public void draw() {
    if(x==0) {
      background(255);
      fill(255);
    }
    stroke(0);
    line(0.1*w, 0.1*h, 0.1*w, 0.9*h);// y-axis
    line(0.1*w, 0.9*h, 0.9*w, 0.9*h);//x-axis
    x+=1;
    if (x >= 0.8*w){
      x = 0;   
    }
    plot();
  }
  
  public void plot(){
    int bicarbonate=0, carbonic=0, water=0, hydronium =0, hydroxide = 0;
    for (int i = 0; i < parts.length; i++){
      switch(parts[i].type){
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
        case 5:
          hydroxide += 1;
          break;
      }
    }
    int total = bicarbonate + carbonic + water + hydronium + hydroxide;
    stroke(colors[Type.HCO3]);
    //point(0.1*w+(millis()*100)%0.8*w, 0.9*h-0.8*h*bicarbonate);
    point(0.1*w+x,0.8*h - 0.8 * h * bicarbonate / total);
    stroke(colors[Type.H2CO3]);
    // point(0.1*w+(millis()*100)%0.8*w, 0.9*h-0.8*h*carbonic);
    point(0.1*w+x,0.8*h-0.8 * h * carbonic / total);
    stroke(colors[Type.H2O]);
     //point(0.1*w+(millis()*100)%0.8*w, 0.9*h-0.8*h*water);
     point(0.1*w+x,0.8*h-0.8 * h * water / total);
    stroke(colors[Type.H3O]);
     //point(0.1*w+(millis()*100)%0.8*w, 0.9*h-0.8*h*hydronium);
     //point(w/2+millis(), h/2);
     point(0.1*w+x,0.8*h-0.8 * h * hydronium / total);
     stroke(colors[Type.OH]);
     //point(0.1*w+(millis()*100)%0.8*w, 0.9*h-0.8*h*hydronium);
     //point(w/2+millis(), h/2);
     point(0.1*w+x,0.8*h-0.8 * h * hydroxide / total);
     
     textSize(28);
     fill(0, 0, 0);
     text("Legend", 800, 40);
     int cy = 60;
     int[] amounts = {water, hydronium, carbonic, bicarbonate, hydroxide};
     int[] indices = {Type.H2O, Type.H3O, Type.H2CO3, Type.HCO3, Type.OH};
     for(int i = 0; i < indices.length; i++){
       textSize(14);
       fill(0, 0, 0);
       text(names[indices[i]], 800, cy);
       fill(colors[indices[i]]);
       rect(950, cy-14, 14, 14);
       cy += 20;
     }

   }
}
