import fisica.*;
import java.util.ArrayList;
import processing.sound.*;

SoundFile fondoMusical;
SoundFile perdiste;
SoundFile ganar;
SoundFile lanzamiento;
SoundFile monoalimentado;

ArrayList<FBox> balas = new ArrayList<FBox>();

FWorld mundo;
Canion c;
Pantallas p;
Corazon corazon;
monoFeliz monofeliz;
FBox mouse;
PImage Fondo, Enemigo, Cartel, Banana;
PFont miFuente; // Declarar una variable para la fuente
int estado;
int tiempoInicio;
int duracionEsperada = 30000; //un minuto
int contadorMonoFeliz = 0; // Inicialmente, el contador está en 0
boolean disparoRealizado = false;
float currentTargetX;
float currentTargetY;

int PUERTO_OSC = 12345;

Receptor receptor;

Administrador admin;

void setup() {
  size(1000, 700);
  estado = 0; // Inicializa en el estado 0
  Fondo = loadImage("Selva.jpg");
  Enemigo = loadImage("MonoMalo.png");
  Cartel = loadImage("cartel.png");
  Banana = loadImage("banana.png");
  Fisica.init(this);
  mundo = new FWorld();
  mundo.setEdges();
  c = new Canion( 100, 600);
  p = new Pantallas();
  // Cargar la fuente desde el archivo en la carpeta del sketch
  miFuente = createFont("HoltwoodOneSC-Regular.ttf", 12);
  // Establecer la fuente para el texto
  textFont(miFuente);
  fondoMusical = new SoundFile(this, "jugando.wav"); // Reemplaza "nombre_del_archivo_de_audio.mp3" con el nombre de tu archivo de audio
  perdiste = new SoundFile(this, "perdiste.wav");
  ganar = new SoundFile(this, "ganar.wav");
  lanzamiento = new SoundFile(this, "lanzamiento.wav");
  monoalimentado = new SoundFile(this, "monofeliz.wav");
  monoalimentado.amp(0.3);
  fondoMusical.loop();
  // Establece el volumen inicial (un valor entre 0.0 y 1.0)
  fondoMusical.amp(0.3); // Esto establece el volumen al 50%
  mouse = boX(0, 0, 10, 10, "mouse", false);
  mouse.attachImage(Banana);
  
  setupOSC(PUERTO_OSC);

  receptor = new Receptor();
  
  admin = new Administrador(mundo);

  for (int i = 0; i < 1; i++)
  {
    FBox Mono1 = new FBox ( 75, 150);
    Mono1.setName( "mono1" );
    Mono1.setPosition ( 350, 150);
    Mono1.setStatic(true);
    Mono1.attachImage(Enemigo);
    mundo.add( Mono1 );
  }
  for (int i = 0; i < 1; i++)
  {
    FBox Mono2 = new FBox ( 75, 150);
    Mono2.setName( "mono2" );
    Mono2.setPosition ( 500, 600);
    Mono2.setStatic(true);
    Mono2.attachImage(Enemigo);
    mundo.add( Mono2 );
  }
  for (int i = 0; i < 1; i++)
  {
    FBox Mono3 = new FBox ( 75, 150);
    Mono3.setName( "mono3" );
    Mono3.setPosition ( 600, 100);
    Mono3.setStatic(true);
    Mono3.attachImage(Enemigo);
    mundo.add( Mono3 );
  }
  for (int i = 0; i < 1; i++)
  {
    FBox Mono4 = new FBox ( 75, 150);
    Mono4.setName( "mono4" );
    Mono4.setPosition ( 600, 400);
    Mono4.setStatic(true);
    Mono4.attachImage(Enemigo);
    mundo.add( Mono4 );
  }
  for (int i = 0; i < 1; i++)
  {
    FBox Mono5 = new FBox ( 75, 150);
    Mono5.setName( "mono5" );
    Mono5.setPosition ( 800, 300);
    Mono5.setStatic(true);
    Mono5.attachImage(Enemigo);
    mundo.add( Mono5 );
  }
}

void draw() {
  
  receptor.actualizar(mensajes); //  
  receptor.dibujarBlobs(width, height);


  // --------- Captura de movimiento --------- \\
  // Eventos de entrada y salida de blobs
  for (Blob b : receptor.blobs) {

    if (b.entro) {
      admin.crearPuntero(b);
      println("--> entro blob: " + b.id);
    }

    if (b.salio) {
      admin.removerPuntero(b);
      println("<-- salio blob: " + b.id);
    }

    admin.actualizarPuntero(b);
  }


  if (!receptor.blobs.isEmpty()) {
    Blob blob = receptor.blobs.get(0); // Sup primer blob en la lista

    float targetX = blob.centroidX * width;
    float targetY = blob.centroidY * height;

    // lerp para suavizar el movimiento
    float lerpAmount = 0.1; // Ajusta este valor según la velocidad de suavizado deseada
    currentTargetX = lerp(currentTargetX, targetX, lerpAmount);
    currentTargetY = lerp(currentTargetY, targetY, lerpAmount);
  }
  if (receptor.blobs.isEmpty()) {
  }


  if (estado == 0) {
    p.dibujarInicio();
    noFill();
    noStroke();
    rect(640, 450, 230, 100);
  }
  if (estado == 1) {
    if (!disparoRealizado) {
      if (tiempoInicio == 0) {
        tiempoInicio = millis(); // Inicia el temporizador al entrar en el estado 1
      }
    }
    image(Fondo, 0, 0);
    fill(255, 182, 0);
    stroke(255, 182, 0);  // Establece el color del borde a naranja (255, 182, 0)
    fill(0);  // Establece el color de relleno a negro
    ellipse(100, 100, 100, 100);  // Dibuja el óvalo en las coordenadas (100, 100)
    image(Banana, 75, 70);
    // Coloca aquí la lógica de disparo para el estado 1
    c.actualizarAngulo();
    mundo.step();
    mundo.draw();
    c.dibujar();
    int tiempoTranscurrido = millis() - tiempoInicio;
    int segundosTranscurridos = tiempoTranscurrido / 1000;
    image(Cartel, 720, 25, 257, 145);
    fill(241, 243, 71);
    // Restablece el tamaño del texto para otros textos
    textSize(64); // Cambia el tamaño según tus necesidades
    text(segundosTranscurridos, 850, 120);
     // Establecer el valor inicial del contador de tiempo en el estado 1
    if (millis() - tiempoInicio >= duracionEsperada) {
      fondoMusical.stop();
      estado = 3;
      perdiste.play();
      noLoop();
    }
    for (int i = balas.size() - 1; i >= 0; i--) {
      FBox bala = balas.get(i);
      if (millis() - c.tiempoDisparoBala >= 8000) {
        // Elimina la bala de la lista y del mundo
        mundo.remove(bala);
        balas.remove(i);
      }
    }
  }
  if (estado == 2) {
    p.dibujarVictoria();
    noFill();
    noStroke();
    rect(595, 575, 235, 100);
    fondoMusical.stop();
    ganar.play();
    noLoop();
  }
  if (estado == 3) {
    p.dibujarDerrota();
    noFill();
    noStroke();
    rect(610, 575, 235, 100);
  }
}


void contactStarted(FContact contacto) {
  FBody body1 = contacto.getBody1();
  FBody body2 = contacto.getBody2();

  // Verificar si los objetos que colisionan son balas
  if (body1.getName() != null && body2.getName() != null) {
    if (body1.getName().equals("bala") && body2.getName().equals("bala")) {
      // No hagas nada si son balas
      return;
    }

    println("body1= " + body1.getName());
    println("body2= " + body2.getName());
    mundo.remove(body1);
    mundo.remove(body2);
    println(contadorMonoFeliz++); // Aumenta el contador cada vez que colisiona 
    monoalimentado.play();

    // Crea y agrega un Corazon en la posición de body2
    corazon = new Corazon(mundo, body1.getX()+5, body1.getY()-110, 0);
    monofeliz = new monoFeliz(mundo, body1.getX(), body1.getY(), 0);
  }

  // Si el contador llega a 5, cambia al estado de pantalla número 2 (victoria)
  if (contadorMonoFeliz >= 10) {
    estado = 2;
  }
}

void mouseMoved() {
  if (estado == 0) {
    // Verifica si el mouse está sobre el rectángulo
    if (currentTargetX >= 640 && currentTargetX <= 640 + 230 && currentTargetY >= 450 && currentTargetY <= 450 + 100) {
      estado = 1;
    }
  }
  else if (estado == 1) {
    float ellipseX = 100; // Coordenada X del centro del óvalo
    float ellipseY = 100; // Coordenada Y del centro del óvalo
    float radius = 50; // Radio del óvalo
    
    float d = dist(currentTargetX, currentTargetY, ellipseX, ellipseY); // Calcula la distancia entre el mouse y el centro del óvalo
    
    if (d <= radius && !disparoRealizado) {
      c.disparar(mundo);
      lanzamiento.play();
      disparoRealizado = true;
    } else if (d > radius) {
      disparoRealizado = false;
    }
  }
  else if (estado == 2) {
    // Verifica si el mouse está sobre el rectángulo en el estado 2
    if (currentTargetX >= 595 && currentTargetX <= 595 + 235 && currentTargetY >= 575 && currentTargetY <= 575 + 100) {
      resetJuego();
    }
  }
  else if (estado == 3) {
    // Verifica si el mouse está sobre el rectángulo en el estado 2
    if (currentTargetX >= 610 && currentTargetX <= 610 + 235 && currentTargetY >= 575 && currentTargetY <= 575 + 100) {
      resetJuego();
    }
  }
}

void resetJuego() {
  estado = 0;
  tiempoInicio = millis();
  contadorMonoFeliz = 0;
  fondoMusical.loop();
  loop();
}


FBox boX(float px, float py, float tw, float th, String nombre, boolean b) {
  FBox main = new FBox (tw, th);
  main.setPosition(px, py);
  main.setName(nombre);
  main.setStatic(b);
  main.setNoStroke();
  return main;
}
