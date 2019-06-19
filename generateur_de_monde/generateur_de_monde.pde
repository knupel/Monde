/**
* Code Kitchen
* Copyleft (c) 2019-2019
* Stan le Punk
* https://github.com/StanLepunK
* http://stanlepunk.xyz/
*/

vec2 size_world;
int surface_habitation = 100;
int urban_mode = 1;
// 0 is random
// 1 is streep_map ;
int min_lot = 10;
int max_lot = 20;
int tempo_build = 20; // tempo is a modulo of the size of the street map.

void setup() {
  colorMode(HSB,360,100,100,100);
  // fullScreen(P3D,1);
  size(1200,800,P3D);
  size_world = vec2(3*width,3*width);
  
  init_street_map();
  init_cadastre();
}

float dir_x,dir_y;
void draw() {
  background(0);
  cartographe();
  cadastre_update(urban_mode,min_lot,max_lot,tempo_build);

  pushMatrix();
  if(mousePressed) { 
    dir_y = map(mouseY,0,height,PI/5,-PI/5);
  }
  rotateX(dir_y);
  translate(width/2,height/2);
  if(mousePressed) {
    dir_x = map(mouseX,0,width,-PI,PI);
  } else {
    dir_x += .005;
  }
  rotateY(dir_x);

  if(show_commune_is) {
    commune(size_world,surface_habitation);
  }
  
  popMatrix();

}


void reset() {
  init_street_map();
  init_commune_street_map();
  init_cadastre(); 
}



boolean show_info_is = true;
boolean show_commune_is = true;
void keyPressed() {
  if(key == 'n') {  
    init_street_map();
    init_commune_street_map();
    init_cadastre(); 
  }

  if(key == 'i') {
    show_info_is = !show_info_is;
  }

  if(key == 's') {
    show_commune_is = !show_commune_is;
  }

  if(key == '0') {
    urban_mode = 0;
  }

  if(key == '1') {
    urban_mode = 1;
  }
  println("urban mode", urban_mode);
}




void cartographe() {
  map(show_info_is);
  urbanist();
  if(show_info_is) {
    show_urbanist();
    show_map();
    show_center_world();
    boussole(vec2(grid_nodes_monde.get(0).pos()),80);
    show_intersection();
  }
}