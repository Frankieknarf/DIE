import processing.video.*;
//import gab.opencv.*;
import java.awt.Rectangle;
import java.awt.*;
import processing.sound.*;
PGraphics topLayer;
PImage img, img2, img3, img4, img5, img6, img7, img8, img9, img10, img11;
PImage descimg3;
PImage pica;
int scl = 3;
int sclx=scl;
int scly=scl;
int currentTime = 0;

//int sclx = displayWidth/640;
//int scly = displayHeight/480;
Capture cam;
//OpenCV opencv;
String[] words;
Rectangle[] faces;
boolean firstPress = false;
boolean savePress = false;
boolean sendPress = false;
boolean time = false;
boolean cT = false;
boolean detected = false;
boolean one = false;
boolean two = false;
boolean three = false;
SoundFile startSound;
SoundFile interactSound;
SoundFile reflectSound;
int Scene = int(random(1,1));

Assets a1 = new Assets(false, 10, 0, 120, 120, 200, 200);//CIP,AX,AY,AW,AH
Assets a2 = new Assets(false, 10, 100, 100, 100, 120, 120);
Assets a3 = new Assets(false, 10, 200, 120, 120,400, 400);
Assets a4 = new Assets(false, 10, 300, 120, 120, 200, 200);
Assets a5 = new Assets(false, 10, 400, 100, 120, 200, 200);
Assets a6 = new Assets(false, 10, 0, 120, 120, 200, 200);
Assets a7 = new Assets(false, 10, 200, 120, 120, 200, 200);
Assets a8 = new Assets(false, 10, 400, 120, 120, 300, 300);
Assets a9 = new Assets(false, 10, 0, 120, 120, 200, 200);
Assets a10 = new Assets(false, 10, 200, 120, 120, 200, 200);
Assets a11 = new Assets(false, 10, 400, 120, 120, 500, 500);

Button cap = new Button(false, 1100, 50, 100, 30, 1, 50, 200, 100, "Take Photo");//P, BX, BY,BW,BH,T, colr, colg, colb
Button sav = new Button(false, 1100, 100, 100, 30, 2, 250, 250, 120, "Save");
Button send = new Button(false,1100, 150, 100, 30, 3, 100, 150, 250, "Reset");


void setup () {
  fullScreen();

  //size(displayWidth, displayHeight);
  
  cam = new Capture(this, width/scl, height/scl);
  cam.start();
  img=loadImage("hat.png");
  img2=loadImage("beard.png");
  img3=loadImage("piano.png");
  img4=loadImage("tulips.png");
  img5=loadImage("pineapple.png");
  img6=loadImage("scratch.png");
  img7=loadImage("frame.png");
  img8=loadImage("chair.png");
  img9=loadImage("frame2.png");
  img10=loadImage("angel.png");
  img11=loadImage("wings.png");

  descimg3=loadImage("PianoDesc.png");

  topLayer = createGraphics(width, height);

  startSound = new SoundFile(this, "Intro.mp3");
  println("Scene = "+Scene);
  if (Scene == 1) {
  interactSound = new SoundFile(this, "Interact.mp3");
  } else if (Scene == 2) {
    interactSound = new SoundFile(this, "Interact3.mp3");
  } else {
    interactSound = new SoundFile(this, "Interact2.mp3");
  }
  reflectSound = new SoundFile(this, "Reflect.mp3");
  startSound.play();
}

void draw() {
  if (firstPress == false && savePress == false) {
    cam.read();
  }
  scale(sclx, scly);
  pushMatrix();
  scale(-1, 1);
  translate(-cam.width, 0);
  image(cam, 0, 0, cam.width, cam.height);
  fill(100);
  popMatrix();
  rect(0, 0, width/25, height);
  if (time == true) {
    timer(3000);
  }

  if (firstPress == true) {
    pica = loadImage("snap.png");
    //opencv = new OpenCV(this, "snap.png");
    //opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  //  pushMatrix();
 //   scale(-1, 1);
 //   translate(-cam.width, 0);
    image(pica, cam.width*1.5, 0, cam.width*1.5, cam.height*1.125); // IDK why 1.125 but it works
  //  popMatrix();
    topLayer.beginDraw();
    topLayer.fill(100);
    if (Scene == 1) {
    a1.update();
    a2.update();
    a3.update();
    a4.update();
    a5.update();
    } else if (Scene == 2) {
    a6.update();
    a7.update();
    a8.update();
    } else if (Scene == 3) {
    a9.update();
    a10.update();
    a11.update();
    }
      
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
  println("Scene ="+Scene);
  if (Scene == 1) {
    println("drawassets1");
  topLayer.image(img, a1.AssetX, a1.AssetY, a1.AssetW, a1.AssetH);
  topLayer.image(img2, a2.AssetX, a2.AssetY, a2.AssetW, a2.AssetH);
  topLayer.image(img3, a3.AssetX, a3.AssetY, a3.AssetW, a3.AssetH);
  topLayer.image(img4, a4.AssetX, a4.AssetY, a4.AssetW, a4.AssetH);
  topLayer.image(img5, a5.AssetX, a5.AssetY, a5.AssetW, a5.AssetH);
  } else if (Scene == 2) {
  println("drawassets2");
  topLayer.image(img6, a6.AssetX, a6.AssetY, a6.AssetW, a6.AssetH);
  topLayer.image(img7, a7.AssetX, a7.AssetY, a7.AssetW, a7.AssetH);
  topLayer.image(img8, a8.AssetX, a8.AssetY, a8.AssetW, a8.AssetH);    
  } else if (Scene == 3) {
    println("drawassets3");
  topLayer.image(img9, a9.AssetX, a9.AssetY, a9.AssetW, a9.AssetH);
  topLayer.image(img10, a10.AssetX, a10.AssetY, a10.AssetW, a10.AssetH);
  topLayer.image(img11, a11.AssetX, a11.AssetY, a11.AssetW, a11.AssetH);    
  }
  image(topLayer,0,0); 
  //FRANK why is there only a3 here?
  if (a3.AssetX > 100 && savePress ==true) {
    a3.CheckInPlace();
    if (a3.CursorInPlace ==true) {
      topLayer.image(descimg3, a3.AssetX-100, a3.AssetY, 600, 100);
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
  if (Scene == 1) {
  a1.CheckInPlace();
  a2.CheckInPlace();
  a3.CheckInPlace();
  a4.CheckInPlace();
  a5.CheckInPlace();
  } else if (Scene == 2) {
  a6.CheckInPlace();
  a7.CheckInPlace();
  a8.CheckInPlace(); 
  } else if (Scene == 3) {
  a9.CheckInPlace();
  a10.CheckInPlace();
  a11.CheckInPlace();
  }
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

  /*void scaleAssets() {
    if (detected == false) {
      faces = opencv.detect();
      detected = true;
    }

    println(faces.length);
    for (int i = 0; i < faces.length; i++) {
      noFill();
      rect(faces[i].x/3, faces[i].y*0.2, faces[i].width/3, faces[i].height*0.6);

      if (AssetX > width/25) {
        if ((AssetX+AssetW/3) > faces[i].x/3 && (AssetX+AssetW/3) < faces[i].x/3 + faces[i].width/3 &&
          (AssetY+AssetH/3) > faces[i].y*0.2 && (AssetY+AssetH/2) < (faces[i].y*0.2 + faces [i].height*0.6)) {
          println("Scale");
          AssetW = (faces[i].width/2)*(AssetScaleW/150);
          AssetH = (faces[i].height/2)*(AssetScaleH/150);
        }
      }
    }
  }*/

  void update() {
    if (mousePressed ==true) {
      if (CursorInPlace == true) {
        mouseDragged();
      }
    }
    if (mousePressed == false) {
      CursorInPlace = false;
    }
  //  scaleAssets();
    drawAssets();
  }

  void CheckInPlace() {
    if (mouseX > AssetX*scl && mouseX < AssetX*scl + AssetW*scl 
      && mouseY > AssetY*scl && mouseY < AssetY*scl +AssetH*scl) {//if cursor in boundingbox of Asset
      CursorInPlace = true;
    }
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
  String S;
  Button(boolean P, float BX, float BY, float BW, float BH, float T, float cr, float cg, float cb, String s) {
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
    S=s;
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
    //ellipseMode(CORNER);
    rect(ButtonX, ButtonY, ButtonW, ButtonH);
    fill(70);
    textSize(12);
    text(S, ButtonX+10, ButtonY+ButtonH/4,ButtonX+ButtonW,ButtonY+ButtonH);
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
      textSize(100);
       fill(0);
       rect(width/2-20, height/2-32, 50, 50);
       fill(255);
       text("3", 650, 400);
      //println("3");
    } else if (remainingTime < timerLength/3*2 && remainingTime > timerLength/3) {
      textSize(100);
       fill(0);
       rect(width/2-20, height/2-32, 50, 50);
       fill(255);
       text("2", 650, 400);
      //println("2");
    } else if (remainingTime < timerLength/3 && remainingTime > 50) {
      textSize(100);
      fill(0);
       rect(width/2-20, height/2-32, 50, 50);
       fill(255);
       text("1", 650, 400);
       //popMatrix();
      //println("1");
    }else  {
       fill(0);
       rect(width/2-20, height/2-32, 50, 50);
       fill(255);
       text(" ", 650, 400);
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
