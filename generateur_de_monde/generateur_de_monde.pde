/**
* Code Kitchen
* Copyleft (c) 2019-2019
* Stan le Punk
* https://github.com/StanLepunK
* http://stanlepunk.xyz/
*/

vec3 size_world;
int surface_habitation = 100;
int urban_mode = 0;
// 0 is random
// 1 is streep_map ;
int min_lot = 10;
int max_lot = 20;
int tempo_build = 20; // tempo is a modulo of the size of the street map.


int which_costume ;
int max_costume_available = 9;

PImage img_map;

void setup() {
  colorMode(HSB,360,100,100,100);
  // fullScreen(P3D,1);
  size(1200,800,P3D);

  // x,z is the flat map
  // y is the altitude
  size_world = vec3(3*width,width,3*width);
  
  init_map_relief();
  init_map_street();
  init_cadastre();
}

float dir_x,dir_y;
void draw() {
  manage_gui();

  if(show_background_image_relief_is) {
    background(img_map,CENTER);
  } else {
    background(r.NUIT);
  }

  // println(brightness(get(mouseX,mouseY)));

  cartographe();
  cadastre_update(urban_mode,min_lot,max_lot,tempo_build,size_world,img_map,use_relief_is);

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
    commune(size_world,surface_habitation,which_costume);
  }
  
  popMatrix();

}




String input_ref;
void manage_gui() {
  if(which_costume < 0) which_costume = max_costume_available;
  if(which_costume > max_costume_available) which_costume = 0;
  if(input_path() != null) {
    if(extension_is(input_path(), "jpg", "jpeg") && input_ref != input_path() && !use_noise_map_is) {
      input_ref = input_path();
      img_map = loadImage(input_ref);
    } else if(use_noise_map_is) {
      input_ref = " ";
      img_map = relief_map;
    }
  } else {
    img_map = relief_map;
  }
  
}

void reset() {
  init_map_relief();
  init_map_street();
  init_commune_street_map();
  init_cadastre(); 
}



boolean show_info_is = false;
boolean show_commune_is = true;
boolean show_background_image_relief_is = false;
boolean use_noise_map_is = true;
boolean use_relief_is = false;

void keyPressed() {
  if(key == 'n') {  
    reset();
  }

  if(key == 'b') {
    show_background_image_relief_is = !show_background_image_relief_is;
  }

  if(key == 'r') {
    use_relief_is = !use_relief_is;
    reset();
  }

  if(key == 'm') {
    use_noise_map_is = !use_noise_map_is;
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

  if(key == CODED) {
    if(keyCode == UP) {
      which_costume ++;
    }
    if(keyCode == DOWN) {
      which_costume --;
    }
  }

  if(key == 'o') {
    select_input();
    use_noise_map_is = false;
  }

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