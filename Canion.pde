class Canion {

  float altoBala = 40;
  float largoBala = 20;
  float velocidad = 700;
  float x, y;
  float largo = 90;
  float ancho = 40;
  PImage Platano;
  PImage Canion;
  PImage Simio;
  float angulo = radians(-45); // Ángulo inicial
  float anguloVel = 1; // Velocidad de cambio del ángulo
  boolean haciaAbajo = true; // Dirección de la rotación
  long tiempoDisparoBala = 0; // Inicializa en cero


  Canion( float x_, float y_) {
    x = x_;
    y = y_;
    angulo = radians (-90);
    Platano = loadImage("banana.png");
    Canion = loadImage("CanionBanana.png");
    Simio = loadImage("monitoCamisa.png");
  }

  void dibujar() {
    pushMatrix();
    translate( x, y);
    rotate( angulo);
    image(Canion, -ancho/2, -ancho/2, largo, ancho);
    popMatrix();
    image(Simio, 10, 500);
  }

 void actualizarAngulo() {
    // Cambia el ángulo de manera constante en función de la velocidad y la dirección
    if (haciaAbajo) {
      angulo += radians(anguloVel);
      if (angulo >= radians(0)) {
        haciaAbajo = false;
      }
    } else {
      angulo -= radians(anguloVel);
      if (angulo <= radians(-90)) {
        haciaAbajo = true;
      }
    }
  }

  void disparar ( FWorld mundo) {

    FBox bala = new FBox (largoBala, altoBala);
    bala.setPosition ( x, y);
    bala.setName( "bala" );

    float vx = velocidad * cos( angulo );
    float vy = velocidad * sin( angulo );

    bala.setVelocity ( vx, vy);
    bala.attachImage(Platano);
    mundo.add( bala );
    // Registra el tiempo en que se disparó la bala
    tiempoDisparoBala = millis();
    balas.add(bala);
  }
  
}
