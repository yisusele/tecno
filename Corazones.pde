class Corazon {
  FCircle circle;
  PImage corazon;
  boolean fueraDePantalla = false;
  
  Corazon(FWorld world, float x, float y, float radius) {
    corazon = loadImage("corazon.png");
    circle = new FCircle(radius);
    circle.setPosition(x, y);
    circle.attachImage(corazon);
    world.add(circle);
  }
}
