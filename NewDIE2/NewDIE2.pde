import processing.video.*;
import gab.opencv.*;
import java.awt.*;
import processing.sound.*;
PGraphics topLayer;
PImage img;
PImage img2;
PImage img3;
PImage img4;
PImage descimg3;
int scl = 2;
int sclx=scl;
int scly=scl;
//int sclx = displayWidth/640;
//int scly = displayHeight/480;
Capture cam;
String[] words;
boolean firstPress = false;
boolean savePress = false;
boolean sendPress = false;
SoundFile startSound;
SoundFile interactSound;
SoundFile reflectSound;

String text1 = "a";
String text2 = "b";
String text3 = "Around 1700s when the piano was invented, it was considered a luxury item because of how expensive it was. The piano was mainly owned by royalties like kings, expressed as a status symbol and beyond the reach of most people.";
String text4 = "d";

Assets a1 = new Assets(false, 0,0,100,100);//CIP,AX,AY,AW,AH
Assets a2 = new Assets(false, 0,100,100,100);
Assets a3 = new Assets(false, 0,200,100,100);
Assets a4 = new Assets(false, 0,300,100,100);

Button cap = new Button(false,600,50,30,30,1,255,0,0);//P, BX, BY,BW,BH,T, colr,  colg, colb
Button sav = new Button(false,600,100,30,30,2,0,255,0);
Button send = new Button(false,600,150,30,30,3,0,0,255);

void setup (){
 //fullScreen();

 size(displayWidth,displayHeight);
    
cam = new Capture(this,640,480);
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

void draw(){
  if (firstPress == false && savePress == false){
  cam.read();
  }
  scale(sclx,scly);
   image(cam,0,0);
 
   if (firstPress == true){
     println("hoi");
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
   if (savePress==true){
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
void drawAssets(){
  topLayer.clear();
  topLayer.rect(0, 0, width/10, height);
  topLayer.image(img, a1.AssetX, a1.AssetY, a1.AssetW, a1.AssetH);
  topLayer.image(img2, a2.AssetX, a2.AssetY, a2.AssetW, a2.AssetH);
  topLayer.image(img3, a3.AssetX, a3.AssetY, a3.AssetW, a3.AssetH);
  topLayer.image(img4, a4.AssetX, a4.AssetY, a4.AssetW, a4.AssetH);
  if (a3.AssetX > 100){
  topLayer.image(descimg3, a3.AssetX-100, a3.AssetY, 300,50 );}
}

void captureEvent(Capture c) {
  c.read();
}

void mousePressed (){
cap.pressed();
sav.pressed();
send.pressed();

}
//mirroring
//assets+scaling
class Assets {
  boolean CursorInPlace;
  float AssetX, AssetY, AssetW, AssetH;

  Assets(boolean CIP,float AX,float AY,float AW,float AH){
  CursorInPlace = CIP;
  AssetX = AX;
  AssetY = AY;
  AssetW = AW;
  AssetH = AH;
  }

void update(){
  if (mousePressed ==true) {
    CheckInPlace();
     if(CursorInPlace == true){
     move();
   }
  }
  drawAssets();
}

void CheckInPlace(){
  if (mouseX > AssetX*scl && mouseX < AssetX*scl + AssetW*scl 
    && mouseY > AssetY*scl && mouseY < AssetY*scl +AssetH*scl){//if cursor in boundingbox of Asset
    CursorInPlace = true; 
    }
    else {
    CursorInPlace = false;
    }
}
void move(){
  AssetX = (mouseX - AssetW)/sclx;
  AssetY= (mouseY -AssetH)/scly;
}

//void info(){
  //if (AssetX>100){
//image();
  
 // }
//}

} //end of assetclass

class Button{
boolean buttonPressed;
float ButtonX, ButtonY, ButtonW,ButtonH, Type,colr, colg, colb;
color c;
Button(boolean P, float BX, float BY, float BW, float BH, float T, float cr, float cg, float cb){
buttonPressed = P;
ButtonX = BX;
ButtonY = BY;
ButtonW = BW;
ButtonH = BH;
Type = T;
colr=cr;
colg=cg;
colb=cb;
c = color (cr,cg,cb);
}
void pressed(){
 if (mouseX > ButtonX*scl && mouseX < ButtonX*scl + ButtonW*scl
    && mouseY > ButtonY*scl && mouseY < ButtonY*scl +ButtonH*scl){//if cursor in boundingbox of Button
      if (Type == 1){//capture
      cam.stop();
      firstPress = true;
      startSound.stop();
      interactSound.play();
      println("thegameison!");
          }
      if (Type == 2){//Save
      savePress=true;
      println("im saved!");
      interactSound.stop();
      reflectSound.play();
          }
      if (Type == 3){//Send
      sendPress = true;
      println("i need email to actually send it");
          }
    }
  }

void drawButtons(){
  fill(c);
  ellipseMode(CORNER);
  ellipse(ButtonX,ButtonY,ButtonW,ButtonH);
  }
} //end of buttonclass



//nondrawing area
//audio
//colortracking
    //bindingbox max size
//buttons (save, capture, email adress)
//facetracking
//mailclient
