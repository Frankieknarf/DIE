import gab.opencv.*;
import processing.video.*;
import java.awt.*;

PGraphics topLayer;
PGraphics topLayer2;
Capture video;

int hover = 0;
int qnum = 0;
int qboxW = width;
int qboxH = height/7;
int qboxX = 0;
int qboxY = 0;

PImage img1, img2, img3, img4, img5, img6;

IntList order;
String[] text = {"Who is the richest?", "Who is most ambituous?", "Who is most academic?", "Who is most fashionable?", "Who has the highest status?", "Who is most self-confident?"};
PImage[] images = {img1, img2, img3, img4, img5, img6};
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
  //order.append(6);
  textMode(CORNER);
  topLayer = createGraphics(width, height);
  topLayer2 = createGraphics(width, height);
  initialize();

  images[0] = loadImage("pineapple.png");
  images[1] = loadImage("piano.png");
  images[2] = loadImage("books.png");
  images[3] = loadImage("hat.png");
  images[4] = loadImage("dog.png");
  images[5] = loadImage("mirror.png");

  video = new Capture(this, width, height);

  video.start();
}

void draw() {
 //  println("aaaaah"+qnum);
  if (qnum>=0){
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
  
}}

void captureEvent(Capture c) {
  c.read();
}

void initialize() {
  order.shuffle();
  println(order); 
  qnum=-1;
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
      threePlayers();
      topLayer2.endDraw();
  topLayer.beginDraw();
  topLayer.fill(100);
  topLayer.textSize(40);
  topLayer.rect(0, 0, width, height/8);
  topLayer.fill(255);
  topLayer.endDraw();
}

void quizQuestions() {  //show the randomized order 
  topLayer.beginDraw();
  topLayer.fill(255);
  topLayer.textSize(50);
  if (order.size()>qnum &&qnum>=0) {
    println("osize"+order.size()+"sadgf"+qnum);
    topLayer.text(text[order.get(qnum)], 20, 70);
  } else {
    println("you reached the end");
    topLayer.text("you reached the end of the list,reshuffling", 20, 70); 
    initialize();
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
 // mouseLocation();
  quizScene();
  
  println("woot");

  topLayer2.beginDraw();
  if (qnum >=0) {
    if (hover == 3) {
      //if (count1 == 0) {
      //object goes to player 1     
      topLayer2.image(images[order.get(qnum)], 10, height/10*7, 200, 200);
     /* count1 = 1; 
      } else if (count 1 == 1) {
      topLayer2.image(images[order.get(qnum-1)], 10, height/10*7, 200, 200);*/
      
      
    } else if (hover == 2) {
      //object goes to player 2
      //if (place2 = false) {
      println("player2");
      topLayer2.image(images[order.get(qnum)], width/3+10, height/10*8, 200, 200);
     // place2 = true;
      
    } else {
      //object goes to player 3
      println("player3");
      //if (place3 = false) {
      topLayer2.image(images[order.get(qnum)], width/3*2+10, height/10*8, 200, 200);
    //  place3 = true;
      
    }
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
  topLayer2.text("Player 1", width/20, height/10*2);
  topLayer2.text("Player 2", width/20*8, height/10*2);
  topLayer2.text("Player 3", width/20*15, height/10*2);
}