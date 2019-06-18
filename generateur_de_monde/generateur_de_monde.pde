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

void setup() {
  colorMode(HSB,360,100,100,100);
  //fullScreen(P3D,2);
  size(800,800,P3D);
  size_world = vec2(3*width,3*width);
  
  init_street_map();
  init_cadastre();
}

float dir_x,dir_y;
void draw() {
  background(0);
  cartographe();
  /*
  if(urban_mode == 1) {
    generate_map_commune();
  }
  */

  cadastre_update(urban_mode,min_lot,max_lot);


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



boolean show_info_is = true;
void keyPressed() {
  if(key == 'n') {  
    init_street_map();
    init_commune_street_map();
    init_cadastre(); 
  }

  if(key == 'i') {
    if(show_info_is) {
      show_info_is = false;
    } else {
      show_info_is = true;
    }
  }
}




void cartographe() {
  map();
  urbanist();
  if(show_info_is) {
    show_center_world();
    boussole(vec2(grid_nodes_monde.get(0).pos()),80);
    show_intersection();
  }
}