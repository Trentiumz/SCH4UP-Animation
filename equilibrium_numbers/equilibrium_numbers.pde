class Equilibrium {
   float H3O, H2CO3, HCO3;
   float Ka;
   
   public Equilibrium(float h3o, float hco3, float h2co3, float ka){
      H3O = h3o;
      H2CO3 = h2co3;
      HCO3 = hco3;
      Ka = ka;
   }
   
   void tick(){
      float Qa = H3O * HCO3 / H2CO3;
      float diff = abs(Qa - Ka);
      if(Qa > Ka){
         float dx = min(H3O, HCO3, min(pow(diff, 2.0 / 3), max(1e-8, pow(diff, 4.0 / 3))));
         H3O -=  dx;
         HCO3 -= dx;
         H2CO3 += dx;
         System.out.println(dx);
      } else if(Qa < Ka){
        float dx = min(H2CO3, pow(diff, 2.0 / 3), max(1e-9, pow(diff, 4.0 / 3)));
         H3O +=  dx;
         HCO3 += dx;
         H2CO3 -= dx;        
         System.out.println(dx);
      }
   }
   
   void render(){
       strokeWeight(1);
       textSize(20);
       fill(255, 0, 0);
       text("[H3O]", 0, 20);
       fill(0, 255, 0);
       text("[HCO3]", 55, 20);
       fill(0, 0, 255);
       text("[H2CO3]", 15, 45);
       
       fill(0, 0, 0);
       strokeWeight(2);
       line(0, 25, 120, 25);
       text("=", 130, 33);
       
       fill(255, 0, 0);
       text(nf(H3O, 0, 5), 150, 20);
       fill(0, 0, 0);
       text("* ", 240, 20);
       fill(0, 255, 0);
       text(nf(HCO3, 0, 5), 260, 20);
       fill(0, 0, 255);
       text(nf(H2CO3, 0, 5), 200, 45);
       
       strokeWeight(2);
       line(150, 25, 340, 25);
       
       fill(0, 0, 0);
       text("=", 345, 33);
       text(nf((float) H3O * HCO3 / H2CO3, 0, 7), 360, 35);
   }
}

Equilibrium eq;

void setup() {
   size(500, 240);
   eq = new Equilibrium(0.0025, 1, 1, 1e-4);
}

void draw() {
    background(255);
    eq.tick();
    eq.render();
    delay(10);
}
