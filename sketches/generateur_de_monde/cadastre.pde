/**
* CADASTRE
* v 0.3.0
*/
ArrayList<vec4>cadastre;
boolean new_commune = true;
void init_commune_street_map() {
  new_commune = true;
}

void init_cadastre() {
  if(cadastre == null) {
    cadastre = new ArrayList<vec4>();
  }
  cadastre.clear();
}


void cadastre_update(int mode, int min_habitation, int max_habitation, int tempo, vec3 world, PImage map, boolean use_altitude_is) {
  int num = (int)random(min_habitation,max_habitation);

  if(segment_monde.size()%tempo == 0) {
    new_commune = true;
  }

  if(mode == 0) {   
    if(new_commune) {
      cadastre_random_generator(num, surface_habitation, world.xz(), map, use_altitude_is);
      new_commune = false;
    }
  } else if(mode == 1) {
    if(new_commune) {
      new_commune = false; 
      cadastre_map_generator(num, surface_habitation, world.xz(), map, use_altitude_is, segment_monde);
    }
  }
}




/**
*  CADASTRE random system generator of cadastre, with more concentration of lots in the center town
*/
void cadastre_random_generator(int num, int average_surface, vec2 flat_world, PImage map, boolean use_altitude_is) {
  // that's can be change when the noise map will be introduce
  int already_occupy = 0;
  for(int i = 0 ; i < num ; i++) {
    vec2 pos = lot_random(average_surface,flat_world);
    if(pos == null) {
      already_occupy++;
    } else {
      int id = (int)random(MAX_FLOAT); // use in futur to attribute habitation
      set_cadastre(pos,map,id,use_altitude_is);
    }
  }
  // println("plot use",num-already_occupy,"on",num);
}





void cadastre_map_generator(int num, int average_surface, vec2 flat_world, PImage map, boolean use_altitude_is, ArrayList<R_Segment> segment) {
  int already_occupy = 0;
  for(int i = 0 ; i < num ; i++) {
    vec2 pos = lot_street_map(average_surface, flat_world, segment);
    if(pos == null) {
      already_occupy++;
    } else {
      int id = (int)random(MAX_FLOAT); // use in future to attribute habitation
      set_cadastre(pos,map,id,use_altitude_is);
    }
  }
  // println("plot use",num-already_occupy,"on",num);
}







/**
* CADASTRE ALLOCATION by lot
* cadastre scale value is between - 1 > 1 
*/
void set_cadastre(vec2 pos, PImage map, int id, boolean use_altitude_is) {
  float altitude = 0;
  if(map != null && use_altitude_is) {
    vec2 temp = pos.copy();
    temp.map(-1,1,0,1).mult(map.width,map.height);
    if(temp.x() < 0) temp.x(0);
    if(temp.y() < 0) temp.y(0);
    if(temp.x() > map.width) temp.x(map.width);
    if(temp.y() > map.height) temp.y(map.height);
    ivec2 p = new ivec2((int)temp.x(), (int)temp.y());
    int c = map.get(p.x(),p.y());
    altitude = brightness(c);
    altitude = map(altitude,0,g.colorModeZ,1,-1);
  }
  cadastre.add(new vec4(pos.x,altitude,pos.y,id));
}