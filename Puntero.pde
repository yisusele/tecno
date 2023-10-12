class Puntero {

  float id;
  float x;
  float y;

  float diametro;

  FWorld mundo; // puntero al mundo de fisica que está en el main


  FCircle body;

  FMouseJoint mj;

  Puntero(FWorld _mundo, float _id, float _x, float _y) {
    mundo = _mundo;
    id = _id;
    x = _x;
    y = _y;
    diametro = 10;

    body = new FCircle(diametro);
    body.setPosition(x, y);
    mj = new FMouseJoint(body, x, y);

    mundo.add(body);
    mundo.add(mj);
  }

  void setTarget(float nx, float ny) {
    mj.setTarget(nx, ny);
  }

  void setID(float id) {
    this.id = id;
  }

  void borrar() {
    mundo.remove(mj);
    mundo.remove(body);
  }
  
  void dibujar() {

    
  }
}
