import processing.video.*;
//import gab.opencv.*;
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
String[] words;
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
  image(cam, 0, 0);

  if (time == true) {
    timer(3000);
  }


  if (firstPress == true) {
    println("hoi");
    pica = loadImage("snap.png");
    image(pica, 0, 0, displayWidth/2, displayHeight/2);
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
        cam.stop();
        time = true;
        // wait for timer to be done..
        saveFrame("snap.png");
        firstPress = true;
        startSound.stop();
        interactSound.play();
        println("thegameison!");
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
  println("timer");
  if (cT == false) {
    currentTime = millis();
    cT = true;
  }
  int remainingTime = timerLength+currentTime-millis();
  println(remainingTime);
  if (remainingTime > 0) {
    int actualTime = (remainingTime);
    if (remainingTime <3001 && remainingTime>2000) {
      println("3");
    } else if (remainingTime <2000 && remainingTime > 1000) {
      println("2");
    } else if (remainingTime < 1000) {
      println("1");
    } 
    return actualTime;
  } else {
    time = false;
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
