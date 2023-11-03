class Type {
  final static int TYPES = 6;
  
  final static int H2O = 0;
  final static int H3O = 1;
  final static int H2CO3 = 2;
  final static int CO2 = 3;
  final static int HCO3 = 4;
  final static int OH = 5;
}

PImage[] images;

void loadImages() {
 images = new PImage[]{loadImage("water.png"), loadImage("hydronium.png"), loadImage("carbonic.png"), loadImage("CO2.png"), loadImage("bicarbonate.png"), loadImage("OH.png")}; 
}

void drawImage(int type, float x, float y, float s, PApplet context){
   context.image(images[type], x, y, s, s);
}

class Collider {
   int r1, r2;
   double p;
   int p1, p2;
   public Collider(int r1, int r2, double p, int p1, int p2){
      this.r1 = r1;
      this.r2 = r2;
      this.p = p;
      this.p1 = p1;
      this.p2 = p2;
   }
}
