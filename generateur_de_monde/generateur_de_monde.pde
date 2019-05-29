/**
* Code Kitchen
* Copyleft (c) 2019-2019
* Stan le Punk
* https://github.com/StanLepunK
* http://stanlepunk.xyz/
*/

vec2 size_world;
int surface_habitation = 100;
void setup() {
  colorMode(HSB,360,100,100,100);
  fullScreen(P3D,2);
  //size(800,800,P3D);
  size_world = vec2(3*width,3*width);

  cadastre_generator(10,surface_habitation,size_world);
}

float dir_x,dir_y;
void draw() {
  background(0);
  // background_rope(0);

  pushMatrix();
  if(mousePressed) { 
    dir_y = map(mouseY,0,height,PI/8,-PI/8);
  }
  rotateX(dir_y);
  translate(width/2,height/2);
  if(mousePressed) {
    dir_x = map(mouseX,0,width,-PI,PI);
  } else {
    dir_x += .005;
  }
  rotateY(dir_x);
  

  commune(size_world,surface_habitation);
  popMatrix();
}




void keyPressed() {
  if(key == 'n') {
    int num = (int)random(100,1500);
    cadastre_generator(num,surface_habitation,size_world);
  }
}














































