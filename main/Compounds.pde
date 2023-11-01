class CompoundType {
  final static int water = 0;
  final static int hydronium = 1;
  final static int carbonicAcid = 2;
  final static int CO2 = 3;
}

PImage[] images;

void loadImages() {
 images = new PImage[]{loadImage("water.png"), loadImage("hydronium.png"), loadImage("carbonic.png"), loadImage("CO2.png")}; 
}

void drawImage(int type, float x, float y, float s){
   image(images[type], x, y, s, s);
}
