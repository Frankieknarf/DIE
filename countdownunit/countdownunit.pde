PFont f;
tekst t1 = new tekst("1");
tekst t2 = new tekst("2");
tekst t3 = new tekst("3");


void setup() {
  size(400, 400);
  f = createFont("Arial",20,true);
}

void draw() { 
  
  background(255);
  fill(0);
  textFont(f); // Set the font
translate(width/2,height/2);
  //for (int i = 0; i<50;i++){

    t3.textscale();
    if (millis()>2000){
  t2.textscale();
    }
    if (millis()>3000){
  t1.textscale();
    }
  
  }
//}

class tekst{
String draadje;
float theta;
tekst(String s){
  draadje = s;
}

void textscale(){
  // Translate to the center
   pushMatrix();
  
    scale(1/theta);                // Rotate by theta
   
    textAlign(CENTER);            
    text(draadje,0,0);            
    theta += 0.1;                // decrease size    
popMatrix();
}
}
