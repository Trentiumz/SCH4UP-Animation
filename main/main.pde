/**  //<>//
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
Loading preScreen;

// global variables
ArrayList<Particle> parts = new ArrayList<Particle>();

void setup() {
  loadImages();
  
  preScreen = new Loading(640, 320);
  String[] args = new String[] {"Loading"};
  PApplet.runSketch(args, preScreen);
  
  surface.setVisible(false);
}

void loop(){
  rect(0, 0, 100, 100);
}

public class Loading extends PApplet {
  int w, h;
  Button buffered, unBuffered;
  final int buttonWidth = 400;
  final int buttonHeight = 30;
  
  class Button{
     int x, y, w, h;
     String text;
     
     public Button(int x, int y, int w, int h, String text){
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.text = text;
     }
     
     void draw(){
        fill(inBound() ? 220 : 255);
        stroke(0);
        strokeWeight(3);
        rect(x, y, w, h);
        
        textAlign(CENTER, CENTER);
        textSize(18);
        fill(0);
        text(text, x, y, w, h);
     }
     
     boolean inBound(int curX, int curY){
        return x <= curX && curX <= x+w && y <= curY && curY <= y+h; 
     }
     
     boolean inBound(){
        return inBound(mouseX, mouseY); 
     }
  }
  
  public Loading(int w, int h){
    this.w = w;
    this.h = h;
    
    this.buffered = new Button(w / 2 - buttonWidth / 2, 100, buttonWidth, buttonHeight, "Begin Buffered Simulation");
    this.unBuffered = new Button(w / 2 - buttonWidth / 2, 100 + (int) (buttonHeight * 1.3), buttonWidth, buttonHeight, "Begin Non-Buffered Simulation");
  }
  
  void settings(){
     size(w, h); 
  }
  
  void draw(){
     background(255);
     
     buffered.draw();
     unBuffered.draw();
  }
  
  void mousePressed(){
    if(buffered.inBound() || unBuffered.inBound()){
      int[] startSize;
      if(buffered.inBound()){
        startSize = new int[]{1000, 0, 600, 0, 800, 0};
      } else {
        startSize = new int[]{1000, 50, 0, 0, 0, 0};
      }
      
      this.getSurface().setVisible(false);

      graph = new Window(1000, 720);
      simulation = new Simulation(1280, 720, startSize);
      simulation.setup();
      
      args = new String[] {"Simulation"};
      PApplet.runSketch(args, simulation);
      simulation.getSurface().setLocation(-20,0);
      
      String[] args = {"Graph"};
      PApplet.runSketch(args, graph); 
      graph.getSurface().setLocation(910, 0);
    }
  }
}

public class Simulation extends PApplet {
   int w, h;
   
    int[] START_SIZE = {1000, 50, 0, 0, 0, 0};
    final int BORDER = 100;
    final int VESSEL = 25;
    double[][] prob = new double[Type.TYPES][Type.TYPES];
    int[][][] results = new int[Type.TYPES][Type.TYPES][2];
    Collider[] collisionTypes = {
       new Collider(Type.H2O, Type.H2O, 0.001, Type.H3O, Type.OH),
       new Collider(Type.H3O, Type.OH, 0.1, Type.H2O, Type.H2O),
       new Collider(Type.HCO3, Type.H2O, 0.02, Type.H2CO3, Type.OH),
       new Collider(Type.H2CO3, Type.H2O, 0.01, Type.HCO3, Type.H3O),
       new Collider(Type.HCO3, Type.H3O, 0.05, Type.H2CO3, Type.H2O),
       new Collider(Type.H2CO3, Type.OH, 0.05, Type.HCO3, Type.H2O)
    };
   
   public Simulation(int w, int h){
      this.w = w;
      this.h = h;
   }
   
   public Simulation(int w, int h, int[] START_SIZE){
       this(w, h);
       this.START_SIZE = START_SIZE;
   }
   
   public void settings() {
      size(w, h); 
   }
   
   public void setup(){
      for(Collider c : collisionTypes) {
        prob[c.r1][c.r2] = prob[c.r2][c.r1] = c.p;
        results[c.r1][c.r2] = results[c.r2][c.r1] = new int[]{c.p1, c.p2};
      }
      
      parts = new ArrayList<Particle>();
      for(int type = 0; type < START_SIZE.length; type++){ 
        for(int j = 0; j < START_SIZE[type]; j++){
          parts.add(new Particle(int(random(width)), int(random(height)), 3, type, width, height - 2 * BORDER, this));
        }
      }
   }
   
   public void draw() {
    background(#c74f37);
    fill(0, 0, 0);
    textSize(32);
    textAlign(CENTER, CENTER);
    text("Blood Buffers by Daniel and Ryan", 0, 0, width, BORDER - VESSEL);
    
    pushMatrix();
    translate(0, BORDER);
    
    fill(#fdf4b1);
    strokeWeight(0);
    rect(0, -VESSEL, width, VESSEL);
    rect(0, height - 2 * BORDER, width, VESSEL);
    
    fill(30, 0, 0);
    rect(0, 0, width, height - 2 * BORDER);
  
    for (Particle p : parts) {
      p.update();
    }
    
    for(int i = 0; i < parts.size(); i++){
       for(int j = i + 1; j < parts.size(); j++){
          Particle a = parts.get(i);
          Particle b = parts.get(j);
          if(a.checkCollision(b)) {
              if(random(1) < prob[a.type][b.type]){
                 int[] become = results[a.type][b.type];
                 a.type = become[0];
                 b.type = become[1];
              }
          }
       }
    }
    
    for(int i = 0; i < parts.size(); i++){
      parts.get(i).checkBoundaryCollision();
      parts.get(i).display();
    }
    
    popMatrix(); 
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
    for (int i = 0; i < parts.size(); i++){
      switch(parts.get(i).type){
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
    
    strokeWeight(2);
    stroke(colors[Type.HCO3]);
    //point(0.1*w+(millis()*100)%0.8*w, 0.9*h-0.8*h*bicarbonate);
    point(0.1*w+x,0.9*h - 0.9 * h * bicarbonate / total);
    stroke(colors[Type.H2CO3]);
    // point(0.1*w+(millis()*100)%0.8*w, 0.9*h-0.8*h*carbonic);
    point(0.1*w+x,0.9*h-0.9 * h * carbonic / total);
    stroke(colors[Type.H2O]);
     //point(0.1*w+(millis()*100)%0.8*w, 0.9*h-0.8*h*water);
     point(0.1*w+x,0.9*h-0.9 * h * water / total);
    stroke(colors[Type.H3O]);
     //point(0.1*w+(millis()*100)%0.8*w, 0.9*h-0.8*h*hydronium);
     //point(w/2+millis(), h/2);
     point(0.1*w+x,0.9*h-0.9 * h * hydronium / total);
     stroke(colors[Type.OH]);
     //point(0.1*w+(millis()*100)%0.8*w, 0.9*h-0.8*h*hydronium);
     //point(w/2+millis(), h/2);
     point(0.1*w+x,0.9*h-0.9 * h * hydroxide / total);
     
     textAlign(LEFT, BOTTOM);
     textSize(28);
     fill(0, 0, 0);
     text("Legend", 800, 40);
     textSize(18);
     text("Time", 0.5*w, 0.95*h);
     pushMatrix();
     translate( 0.06*w, 0.52*h);
     rotate(3*PI/2);
     fill(0, 0, 0);
     text("Number of Particles",0,0);
     popMatrix();
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

     float H3OConc = (float) hydronium /29;
     fill(255, 255, 255);
     rect(600, 25, 155, 20);
     fill(0, 0, 0);
     text("[H3O] = " + nf(H3OConc, 0, 5)+"*10^-8", 600, 40);
     
     float HCO3Conc = (float) bicarbonate /29;
     fill(255, 255, 255);
     rect(600, 55, 155, 20);
     fill(0, 0, 0);
     text("[HCO3] = " + nf(HCO3Conc, 0, 5)+"*10^-8", 600, 70);
     
     float H2CO3Conc = (float) carbonic /29;
     fill(255, 255, 255);
     rect(600, 85, 155, 20);
     fill(0, 0, 0);
     text("[H2CO3] = " + nf(H2CO3Conc, 0,5)+"*10^-8", 600, 100);
     
     float pH = -1*log(H3OConc*pow(10, -8))/log(10);
     fill(255, 255, 255);
     rect(600, 115, 155, 20);
     fill(0, 0, 0);
     text("pH = " + nf(pH, 0,6), 600, 130);
     
     button(450, 25, 80, 20, "HCO3");
     if ( button(450, 25, 80, 20, "HCO3")){
       for (int i =0; i< 30; i++){
          parts.add(new Particle(int(random(width)), int(random(height)), 3, Type.HCO3, width - 2 * 25, height - 2 * 25, simulation));
       }
     }
     button(350, 25, 80, 20, "H2CO3");
     if ( button(350, 25, 80, 20, "H2CO3")){
       for (int i =0; i< 30; i++){
          parts.add(new Particle(int(random(width)), int(random(height)), 3, Type.H2CO3, width - 2 * 25, height - 2 * 25, simulation));
       }
     }
     button(250, 25, 80, 20, "H3O");
     if ( button(250, 25, 80, 20, "H3O")){
       for (int i =0; i< 30; i++){
          parts.add(new Particle(int(random(width)), int(random(height)), 3, Type.H3O, width - 2 * 25, height - 2 * 25, simulation));
       }
     }
     button(150, 25, 80, 20, "OH");
     if ( button(150, 25, 80, 20, "OH")){
       for (int i =0; i< 30; i++){
          parts.add(new Particle(int(random(width)), int(random(height)), 3, Type.OH, width - 2 * 25, height - 2 * 25, simulation));
       }
     }

   }
   public boolean button(int x, int y, int w, int h, String text){
     textAlign(CENTER, CENTER);
     
     if (mouseX > x && mouseX <x+w && mouseY > y &&mouseY <y+h){
       fill(200);
       rect(x, y, w, h);
       fill(0);
       text(text, x, y, w, h);
       if (mousePressed){
         return true;
       }
       else{
         return false;
       }
     }
     fill(255);
     rect(x, y, w, h);
     fill(0);
     text(text, x, y, w, h);
     return false;
   }
}
