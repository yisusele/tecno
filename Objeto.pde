class Objeto {

  boolean actualizado;
  boolean entro;
  boolean salio;

  int vida;

  int ultimaActualizacion;

  int limite_tiempo_salir;

  // datos del blob
  int id; 
  float centerX;
  float centerY;
  float velocityX;
  float velocityY;
  float boundingRectX;
  float boundingRectY;
  float boundingRectW;
  float boundingRectH;

  Objeto() {

    entro =  true;
    actualizado = false;
    salio = false;

    vida = 0;
    ultimaActualizacion = 0;

    limite_tiempo_salir = -5;

    id = -1;

    centerX = 0;
    centerY = 0;
    velocityX = 0;
    velocityY = 0;
    boundingRectX = 0;
    boundingRectY = 0;
    boundingRectW = 0;
    boundingRectH = 0;
  }

  void actualizar() {
    if (vida > 0) {
      entro = false;
    }
    vida++;
    vida = vida % 100;

    salio = ultimaActualizacion == limite_tiempo_salir ? true : false;
  }
  void actualizarDatos(OscMessage m) {
    
    velocityX = m.get(1).floatValue();
    velocityY = m.get(2).floatValue();
    boundingRectX = m.get(3).floatValue();
    boundingRectY = m.get(4).floatValue();
    boundingRectW = m.get(5).floatValue();
    boundingRectH = m.get(6).floatValue();
    centerX = boundingRectX + boundingRectW / 2;
    centerY = boundingRectY + boundingRectH / 2;
  }

  void setID( int id) {
    this.id = id;
  }

  void dibujar(float w, float h) {

    // Centro - ID
    float x = centerX * w;
    float y = centerY * h;

    stroke(255, 255, 0);
    pushMatrix();
    translate(x, y);
    ellipse(0, 0, 5, 5);
    stroke(255, 0, 0);
    line(0, 0, velocityX * w, velocityY * h);
    fill(0);
    text("id: " + id, 5, 5);
    popMatrix();

    // Bounding Rect
    float rx = boundingRectX * w;
    float ry = boundingRectY * h;

    noFill();
    stroke(0, 0, 255);
    pushMatrix();
    translate(rx, ry);
    rect( 0, 0, boundingRectW * w, boundingRectH * h);
    popMatrix();
  }
}
