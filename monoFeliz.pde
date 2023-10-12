class monoFeliz {
  FCircle circle;
  PImage monoFeliz;
  float yPosition; // Variable para controlar la posición vertical
  
  monoFeliz(FWorld world, float x, float y, float radius) {
    monoFeliz = loadImage("monofeliz.png");
    circle = new FCircle(radius);
    yPosition = y;
    circle.setPosition(x, y);
    circle.attachImage(monoFeliz);
    world.add(circle);
  }
}
