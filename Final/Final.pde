import processing.sound.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

PGraphics topLayer;
PGraphics topLayer2;
Capture video;
PFont font;

int hover = 0;
int qnum = 0;
int qboxW = width;
int qboxH = height/7;
int qboxX = 0;
int qboxY = 0;

PImage img1, img2, img3, img4, img5, img6;

IntList order;
String[] text = {"It's not nice to scratch someone out of a painting..", 
  "Mirror, mirror, on the wall. Who's the fairest of them all?", 
  "Who would fit best in the royal family?", 
  "Who thinks he/she is the smartest?", 
  "Who thinks he/she is the most fashionable?", 
  "Who wants to live forever?"};
PImage[] images = {img1, img2, img3, img4, img5, img6};
Assets[] assetArray = new Assets[6];
SoundFile BackGroundSound;
boolean start = false;
boolean start1 = false;
boolean players = false;
boolean click = false;



void setup() {
  fullScreen();

  order = new IntList();
  order.append(0);
  order.append(1);
  order.append(2);
  order.append(3);
  order.append(4);
  order.append(5);


  font = createFont("font.ttf", 50);
  textFont(font);

  topLayer = createGraphics(width, height);
  topLayer2 = createGraphics(width, height);
  initialize();

  img1 = loadImage("scratch.png");
  img2 = loadImage("mirror.png");
  img3 = loadImage("piano.png");
  img4 = loadImage("books.png");
  img5 = loadImage("hat.png");
  img6 = loadImage("frame.png");

  BackGroundSound = new SoundFile(this, "Background.mp3");
  assetArray[0] = new Assets(img1, 0, height/10*3, 700, 700);
  assetArray[1] = new Assets(img2, width/5, height/4, 200, 300);
  assetArray[2] = new Assets(img3, 0, height/10*7, 400, 400);
  assetArray[3] = new Assets(img4, width/6, height/10*7, 300, 300);
  assetArray[4] = new Assets(img5, width/13, height/3, 400, 400);
  assetArray[5] = new Assets(img6, 0, height/10*3, 600, 600);

  BackGroundSound.loop(); 
  video = new Capture(this, 1600, 1200 );

  video.start();
}

void draw() {
  //  println("aaaaah"+qnum);
  if (qnum>=0) {
    if (video.available() == true) {
      video.read();
    }


    noFill();
    noStroke();
    pushMatrix();
    translate(width, 0);
    scale(-1, 1);
    image(video, 0, 0);
    popMatrix();

    topLayer.beginDraw(); 



    topLayer.fill(50, 100, 200, 200);
    topLayer.strokeWeight(1);
    mouseLocation();
    topLayer.endDraw();
    image(topLayer2, 0, 0);
    image(topLayer, 0, 0);
  }
}

void captureEvent(Capture c) {
  c.read();
}

void initialize() {
  order.shuffle();
  // println(order); 
  qnum=-1;
  topLayer.beginDraw();
  topLayer.endDraw();
  topLayer2.beginDraw();
  topLayer2.clear();
  textAlign(CENTER);
  textSize(180);
  background(100);
  text("START", width/2, height/2);
  mouseLocation();
}

void quizScene() {

  topLayer2.beginDraw();
  topLayer2.textFont(font);
  threePlayers();
  topLayer2.endDraw();
  topLayer.beginDraw();
  topLayer.textFont(font);
  topLayer.fill(100);
  topLayer.textSize(40);
  topLayer.rect(0, 0, width, height/8);
  topLayer.fill(255);
  topLayer.endDraw();
}

void quizQuestions() {  //show the randomized order 
  topLayer.beginDraw();
  topLayer.fill(255);
  topLayer.textSize(45);
  if (order.size()>qnum &&qnum>=0) {
    //   println("osize"+order.size()+"sadgf"+qnum);
    topLayer.text(text[order.get(qnum)], 20, 70);
  } else {
    //    println("you reached the end");
    topLayer.fill(200, 50, 50);
    topLayer.rect(0, 0, width, height/8);
    topLayer.fill(255);
    topLayer.text("Click again to start over!", 20, 70);
    //show picture of the end
  }
  topLayer.endDraw();
}

void mouseLocation() {
  if (mouseX < width/3) {
    hover = 3;
  } else if (mouseX < width/3*2) {
    hover = 2;
  } else {
    hover = 1;
  }

  if (mouseX > width/3 && mouseX < width/3*2 &&
    mouseY > height/2-200 && mouseY < height/2+200) {
    start1 = true;
  }
}

void mousePressed() {

  quizScene();
  topLayer2.beginDraw();
  if (qnum >=0 && qnum < order.size()) {
    //  println("qnum = "+qnum);
    if (hover == 3) {
      Assets a1 = assetArray[order.get(qnum)];
      topLayer2.image(a1.image, a1.xpos, a1.ypos, a1.owidth, a1.oheight);
    } else if (hover == 2) {
      Assets a1 = assetArray[order.get(qnum)];
      topLayer2.image(a1.image, a1.xpos+width/3, a1.ypos, a1.owidth, a1.oheight);
    } else {
      Assets a1 = assetArray[order.get(qnum)];
      topLayer2.image(a1.image, a1.xpos+width/3*2, a1.ypos, a1.owidth, a1.oheight);
    }
  } else if (qnum > order.size()) {
    initialize();
    qnum--;
  }
  topLayer2.endDraw();
  qnum++;
  quizQuestions();
}

void threePlayers() {

  topLayer2.fill(255);
  topLayer2.line(width/3, height/8, width/3+5, height);
  topLayer2.line(width/3*2, height/8, width/3*2+5, height);
  topLayer2.line(0, height/6+5, width, height/6+5);
  topLayer2.rect(0, height/8+5, width/3-5, height/8);    
  topLayer2.rect(width/3+5, height/8+5, width/3-10, height/8);
  topLayer2.rect(width/3*2+5, height/8+5, width/3-5, height/8);
  topLayer2.textSize(50);
  topLayer2.fill(0, 0, 0);
  topLayer2.text("Player 1", width/20, height/10*2.2);
  topLayer2.text("Player 2", width/20*8, height/10*2.2);
  topLayer2.text("Player 3", width/20*15, height/10*2.2);
}

class Assets {
  PImage image;
  int xpos; 
  int ypos; 
  int owidth; 
  int oheight;

  Assets(PImage im, int xp, int yp, int ow, int oh) {
    image = im;
    xpos = xp;
    ypos = yp;
    owidth = ow;
    oheight = oh;
  }
}
