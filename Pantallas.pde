class Pantallas {
  
  PImage Primera;
  PImage Segunda;
  PImage Tercera;
  
  
  Pantallas() {
    textSize(30);
    textAlign(CENTER);
    background(0);
    Primera = loadImage("Menu.png");
    Segunda = loadImage("Ganar.png");
    Tercera = loadImage("Perder.png");
  }
  
  void dibujarInicio() {
    background(0);
    image(Primera, 0, 0);
  }
  void dibujarVictoria() {
    background(0);
    image(Segunda, 0, 0);
  }
  void dibujarDerrota() {
    background(0);
    image(Tercera, 0, 0);
  }
  
  
}
