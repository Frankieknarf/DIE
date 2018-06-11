import gab.opencv.*;
import processing.video.*;
import java.awt.*;
PGraphics pg;


Assets a1 = new Assets (false, false,true, 10, 0, 150, 150, 0, 0, 0, 0, 0, 0);
Assets a2 = new Assets (false, false,true, 10, 200, 100, 100, 0, 0, 0, 0, 0, 0);

// Static vars, these don't change. 
int rangeLow = 20;
int rangeHigh = 35;
int acc = 50;
int minBbox = 10;
int maxBbox = 200;
int scl = 2;
PImage img;
PImage img2;


//Initialize all other stuff the code needs to function
PGraphics topLayer;
Capture video;
OpenCV opencv;
PImage src, colorFilteredImage;
ArrayList<Contour> contours;


void setup() {
  fullScreen();
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);  

  //  video = new Capture(this, width/(scl), height/scl);
  //  opencv = new OpenCV(this, width/(scl), height/scl);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  contours = new ArrayList<Contour>();
  //pg = createGraphics(width, height);
  topLayer = createGraphics(width, height);
//  reset();
  img = loadImage("hat.png");
  img2 = loadImage("beard.png");

  video.start();
}

void draw() {

  if (video.available() == true) {
    video.read();
  }

  scale(scl);
  opencv.loadImage(video);
  image(video, 0, 0);



  noFill();
  noStroke();

  topLayer.beginDraw();
  topLayer.fill(50, 100, 200, 200);
  a1.update();
  a2.update();
  topLayer.endDraw();
  image(topLayer, 0, 0);
}

/*void mousePressed() {
  if (mouseX > squareX*scl && mouseX < squareX*scl + squareWidth*scl && mouseY > squareY*scl && mouseY < squareY*scl + squareHeight*scl) {
    mouseInSquare = true;
  } else if (mouseX > squareX2*scl && mouseX <squareX2*scl + squareWidth2*scl && mouseY > squareY2*scl && mouseY < squareY2*scl + squareHeight2*scl) {
    mouseInSquare2 = true;
  }
}

void mouseReleased() {
  mouseInSquare = false;
  mouseInSquare2 = false;
}

void mouseDragged() {
  if (mouseInSquare) {
    float deltaX = mouseX - pmouseX;
    float deltaY = mouseY - pmouseY;

    squareX += deltaX/scl;
    squareY += deltaY/scl;
  }

  if (mouseInSquare2) {
    float deltaX = mouseX - pmouseX;
    float deltaY = mouseY - pmouseY;

    squareX2 += deltaX/scl;
    squareY2 += deltaY/scl;
  }
}
*/


void captureEvent(Capture c) {
  c.read();
}

void drawAssets() {
  topLayer.clear();
  topLayer.rect(0, 0, width/10, height);
  topLayer.image(img, a1.squareX, a1.squareY, a1.squareWidth, a1.squareHeight);
  topLayer.image(img2, a2.squareX, a2.squareY, a2.squareWidth, a2.squareHeight);
}

class Assets {
  boolean mouseInSquare, onHead,faceTrack;
  float squareX, squareY, squareWidth, squareHeight, deltaX, deltaY, faceX, faceY, faceW, faceH;
  Assets(boolean MIS, boolean oH,boolean fTrack, float sX, float sY, float sW, float sH, float dX, float dY, float fX, float fY, float fW, float fH) {
    mouseInSquare = MIS;
    onHead = oH;
    faceTrack =fTrack;
    squareX = sX;
    squareY = sY;
    squareWidth = sW;
    squareHeight = sH;
    deltaX = dX;
    deltaY = dY;
    faceX = fX;
    faceY = fY;
    faceW = fW;
    faceH = fH;
  }
  void update() {
    colortrack();
    if (faceTrack == true){
    CheckOnHead();
  }
  }
  
  void reset(){
    
  }
void findFaces(Rectangle[] faces) {
  for (int i = 0; i < faces.length; i++) {
    if (mouseX > faces[i].x && mouseX < faces[i].x+(faces[i].width)*1.5
      && mouseY > faces[i].y && mouseY < faces[i].y+(faces[i].height)*2) {
      stroke(255, 0, 0);
      ellipse(faces[i].x+(faces[i].width)/2, faces[i].y+(faces[i].height)/2, faces[i].width*1.5, faces[i].height*2);
    }
    //is hat on head?

    if (squareX > (width/10)) {
      if (((squareX+(squareWidth/2)+100) > ((faces[i].x+(faces[i].width)/2)-110)) && ((squareY+(squareHeight/2)*3+100) > (faces[i].y+(faces[i].height)/2)) && ((squareX+(squareWidth/2)-100) < ((faces[i].x+(faces[i].width)/2)+faces[i].width)) && ((squareY+(squareHeight/2)*3-100) < (((faces[i].y+(faces[i].height)/2)+(faces[i].height))))) 
      { 
        println("I'm a hat and I'm on a head");
        faceX = (faces[i].x+(faces[i].width)/2);
        faceY = (faces[i].y+(faces[i].height/2));
        faceW = faces[i].width; 
        faceH = faces[i].height;
        onHead = true;
      }
    }
  }
}

void CheckOnHead() {
  findFaces(opencv.detect());

  if (onHead == true) {  
    squareX = faceX - (squareWidth/2);
    squareY = faceY - squareHeight+10;
    squareWidth = faceW*1.8;
    squareHeight = faceH*1.8;

    if (squareHeight > 1000 || squareHeight < 50) {
      squareHeight = 150;
    }
    if (squareWidth > 1000 || squareWidth < 50) {
      squareWidth = 150;
    }
    drawAssets();
  }

  if (mouseInSquare == false) {
    drawAssets();
  }
  if (mouseInSquare == true) {
    onHead = false;
    println("back");
    if (squareX < (width/10)) {
      squareWidth = 150;
      squareHeight = 150;
    }
    drawAssets();
  }
}

void colortrack() { //find a bounding box of a certain size within the color range
  opencv.useColor();
  src = opencv.getSnapshot();
  opencv.useColor(HSB);
  opencv.setGray(opencv.getH().clone());
  colorthing();
  opencv.inRange(rangeLow, rangeHigh);
  colorFilteredImage = opencv.getSnapshot();

  contours = opencv.findContours(true, true);

  if (contours.size() > 0) {
    for (int i=0; i<contours.size(); i++) {
      Contour biggestContour = contours.get(i);
      Rectangle r = biggestContour.getBoundingBox();
      if (r.width > minBbox && r.width < maxBbox && r.height < maxBbox && r.height > minBbox) {
        if (squareX <r.x  + r.width/2 - squareWidth/2 + acc && squareX> r.x +r.width/2  - squareWidth/2 - acc &&   squareY< r.y+ r.height/2 - squareHeight/2 + acc &&  squareY>r.y + r.height/2  - squareHeight/2- acc) {
          squareX = r.x+ r.width/2  - squareWidth/2;
          squareY = r.y+ r.height/2 - squareHeight/2;
          topLayer.clear();
          break;
        }
      }
    }
  }
}

void colorthing() {

  color c = color(27, 73, 112);//get(mouseX, mouseY);
  println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));

  int hue = int(map(hue(c), 0, 255, 0, 180));
  println("hue to detect: " + hue);

  rangeLow = hue - 5;
  rangeHigh = hue + 5;
}
}
