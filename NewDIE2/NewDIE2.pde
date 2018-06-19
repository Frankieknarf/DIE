import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;
import java.awt.*;
import processing.sound.*;
PGraphics topLayer;
PImage img;
PImage img2;
PImage img3;
PImage img4;
PImage descimg3;
PImage pica;
int scl = 2;
int sclx=scl;
int scly=scl;
int currentTime = 0;
//int sclx = displayWidth/640;
//int scly = displayHeight/480;
Capture cam;
OpenCV opencv;
String[] words;
Rectangle[] faces;
boolean firstPress = false;
boolean savePress = false;
boolean sendPress = false;
boolean time = false;
boolean cT = false;
SoundFile startSound;
SoundFile interactSound;
SoundFile reflectSound;

Assets a1 = new Assets(false, 0, 0, 100, 100, 100, 100);//CIP,AX,AY,AW,AH
Assets a2 = new Assets(false, 0, 100, 100, 100, 100, 100);
Assets a3 = new Assets(false, 0, 200, 100, 100, 300, 300);
Assets a4 = new Assets(false, 0, 300, 100, 100, 100, 100);

Button cap = new Button(false, 600, 50, 30, 30, 1, 255, 0, 0);//P, BX, BY,BW,BH,T, colr,  colg, colb
Button sav = new Button(false, 600, 100, 30, 30, 2, 0, 255, 0);
Button send = new Button(false, 600, 150, 30, 30, 3, 0, 0, 255);

void setup () {
  //fullScreen();

  size(displayWidth, displayHeight);

  cam = new Capture(this, 640, 480);
  cam.start();
  img=loadImage("hat.png");
  img2=loadImage("beard.png");
  img3=loadImage("piano.png");
  img4=loadImage("hoed.png");

  descimg3=loadImage("PianoDesc.png");

  topLayer = createGraphics(width, height);

  startSound = new SoundFile(this, "Intro.mp3");
  interactSound = new SoundFile(this, "Interact.mp3");
  reflectSound = new SoundFile(this, "Reflect.mp3");
  startSound.play();
}

void draw() {
  if (firstPress == false && savePress == false) {
    cam.read();
  }
  scale(sclx, scly);
  image(cam, cam.width, 0, -cam.width, cam.height);
  println(cam.width);

  if (time == true) {
    timer(3000);
  }


  if (firstPress == true) {
    println("hoi");
    pica = loadImage("snap.png");
    image(pica, cam.width*1.5, 0, -cam.width*1.5, cam.height*1.125); // IDK why 1.125 but it works
    
    /*
    opencv = new OpenCV(this, "snap.png");
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
    faces = opencv.detect();
    for (int i = 0; i < faces.length; i++) {
      //rect(faces[i].x/2, faces[i].y/2, faces[i].width/2, faces[i].height/2);
      
      //Sooooo I can't access the AssetX, AssetY, AssetW and AssetH here :(
      
      if (AssetX > faces[i].x/2 && AssetX < (faces[i].x/2 + faces[i].width/2) &&
      AssetY > faces[i].y/2 && AssetY < (faces[i].y/2 + faces [i].height/2)) {
        AssetW = faces[i].width/2;
        AssetH = faces[i].height/2;
      }
    }
    */
    topLayer.beginDraw();
    topLayer.fill(50, 100, 200, 200);
    a1.update();
    a2.update();
    a3.update();
    a4.update();
    drawAssets();
    topLayer.endDraw();
    image(topLayer, 0, 0);
  }
  if (savePress==true) {
    firstPress = false;
    topLayer.beginDraw();
    drawAssets();
    //    a1.info();
    topLayer.endDraw();
    image(topLayer, 0, 0);
  }
  cap.drawButtons();
  sav.drawButtons();
  send.drawButtons();
}
void drawAssets() {
  topLayer.clear();
  topLayer.rect(0, 0, width/20, height);
  topLayer.image(img, a1.AssetX, a1.AssetY, a1.AssetW, a1.AssetH);
  topLayer.image(img2, a2.AssetX, a2.AssetY, a2.AssetW, a2.AssetH);
  topLayer.image(img3, a3.AssetX, a3.AssetY, a3.AssetW, a3.AssetH);
  topLayer.image(img4, a4.AssetX, a4.AssetY, a4.AssetW, a4.AssetH);
  if (a3.AssetX > 100 && savePress ==true) {
    a3.CheckInPlace();
    if (a3.CursorInPlace ==true) {
      topLayer.image(descimg3, a3.AssetX-100, a3.AssetY, 600, 100 );
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}

void mousePressed () {
  cap.pressed();
  sav.pressed();
  send.pressed();
}
//mirroring
//assets+scaling
class Assets {
  boolean CursorInPlace;
  float AssetX, AssetY, AssetW, AssetH, AssetScaleW, AssetScaleH, OldAssetW, OldAssetH;

  Assets(boolean CIP, float AX, float AY, float AW, float AH, float ASW, float ASH) {
    CursorInPlace = CIP;
    AssetX = AX;
    AssetY = AY;
    AssetW = AW;
    AssetH = AH;
    AssetScaleW =ASW;
    AssetScaleH=ASH;
    OldAssetW=AW;
    OldAssetH=AH;
  }

  void update() {
    if (mousePressed ==true) {
      CheckInPlace();
      if (CursorInPlace == true) {
        mouseDragged();
      }
    }
    if (mousePressed == false) {
      CursorInPlace = false;
    }
    drawAssets();
  }

  void CheckInPlace() {
    if (mouseX > AssetX*scl && mouseX < AssetX*scl + AssetW*scl 
      && mouseY > AssetY*scl && mouseY < AssetY*scl +AssetH*scl) {//if cursor in boundingbox of Asset
      CursorInPlace = true;
    }
    //else {
    //CursorInPlace = false;
    // }
  }
  void mouseDragged() {
    AssetX = (mouseX - AssetW)/sclx;
    AssetY= (mouseY -AssetH)/scly;
    if (AssetX > width/20) {
      AssetW=AssetScaleW;
      AssetH=AssetScaleH;
    } else {
      AssetW=OldAssetW;
      AssetH=OldAssetH;
    }
  }

  //void info(){
  //if (AssetX>100){
  //image();

  // }
  //}
} //end of assetclass

class Button {
  boolean buttonPressed;
  float ButtonX, ButtonY, ButtonW, ButtonH, Type, colr, colg, colb;
  color c;
  Button(boolean P, float BX, float BY, float BW, float BH, float T, float cr, float cg, float cb) {
    buttonPressed = P;
    ButtonX = BX;
    ButtonY = BY;
    ButtonW = BW;
    ButtonH = BH;
    Type = T;
    colr=cr;
    colg=cg;
    colb=cb;
    c = color (cr, cg, cb);
  }

  void pressed() {
    if (mouseX > ButtonX*scl && mouseX < ButtonX*scl + ButtonW*scl
      && mouseY > ButtonY*scl && mouseY < ButtonY*scl +ButtonH*scl) {//if cursor in boundingbox of Button
      if (Type == 1) {//capture
        time = true;
        timer(3000);
      }
      if (Type == 2) {//Save
        savePress=true;
        println("im saved!");
        interactSound.stop();
        reflectSound.play();
      }
      if (Type == 3) {//Send
        sendPress = true;
        println("i need email to actually send it");
      }
    }
  }

  void drawButtons() {
    fill(c);
    ellipseMode(CORNER);
    ellipse(ButtonX, ButtonY, ButtonW, ButtonH);
  }
} //end of buttonclass

int timer(int timerLength) {
  if  (cT == false) {
    currentTime = millis();
    cT = true;
  }
  int remainingTime = timerLength+currentTime-millis();
  if (remainingTime>0) {
    int actualTime = (remainingTime);
    if (remainingTime < timerLength && remainingTime > timerLength/3*2) {
      /*textSize(20);
       fill(0);
       rect(width/2-20, height/2-32, 50, 50);
       fill(255);
       text("3", width/2, height/2);*/
      println("3");
    } else if (remainingTime < timerLength/3*2 && remainingTime > timerLength/3) {
      /*textSize(20);
       fill(0);
       rect(width/2-20, height/2-32, 50, 50);
       fill(255);
       text("2", width/2, height/2);*/
      println("2");
    } else if (remainingTime < timerLength/3) {
      /*textSize(20);
       fill(0);
       rect(width/2-20, height/2-32, 50, 50);
       fill(255);
       text("1", width/2, height/2);*/
      println("1");
    }
    return actualTime;
  } else {
    println("CLICK");
    cam.stop();
    time = false;
    saveFrame("snap.png");
    firstPress = true;
    startSound.stop();
    interactSound.play();
    println("thegameison!");
    return 0;
  }
}

//nondrawing area
//audio
//colortracking
//bindingbox max size
//buttons (save, capture, email adress)
//facetracking
//mailclient
