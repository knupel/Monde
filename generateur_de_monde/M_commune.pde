/**
* Ville : Project born in the Code Kitchen in Creative Code Paris january session.
* Copyleft (c) 2019-2019
* v 0.2.0
* Stan le Punk > http://stanlepunk.xyz/

* All class, method is in french... C'est la vie, excuse my french!
ville : town
habitation : home
generateur : generator
cadastre : land register
lot : habitation(home) position in the cadastre
urbanisme : management of town
*/


void commune(vec3 world, int surface_habitation, int which_one) {
  int level = 6 ; // midi size
  // int surface_hab = 40;
  urbanisme(surface_habitation,level);

  for (int i = 0 ; i < cadastre.size() ; i++) {
    vec4 cad = cadastre.get(i).copy();
    Home h = town.get(i); 
    float px = cad.x *world.x();
    float py = (cad.y *world.y()) -(h.size.z/2);
    float pz = cad.z *world.z();
    vec3 pos = vec3(px,py,pz);
    show_home(h, pos, which_one);
  }
}


void show_home(Home h, vec3 pos, int which) {
  if(which == 0) {
    h.show(pos);  
  } else {
    strokeWeight(1);
    stroke(r.BLACK);
    fill(h.get_fill());
    if(which == 1) {
      costume(pos,h.get_size(),LINE);
    } else if(which == 2) {
      costume(pos,h.get_size(),TETRAHEDRON);
    } else if(which == 3) {
      costume(pos,h.get_size(),SPHERE_LOW);
    } else if(which == 4) {
      costume(pos,h.get_size(),SPHERE_MEDIUM);
    } else if(which == 5) {
      costume(pos,h.get_size(),CROSS_BOX_2);
    } else if(which == 6) {
      costume(pos,h.get_size(),CROSS_BOX_3);
    } else if(which == 7) {
      costume(pos,h.get_size(),FLOWER);
    } else if(which == 8) {
      costume(pos,h.get_size(),STAR);
    } else if(which == 9) {
      costume(pos,h.get_size(),STAR_3D);
    }
  }
}


ArrayList<Home>town;
void urbanisme(int surface, int max_level) {
  if(town == null) {
    town = new ArrayList<Home>();
  }

  // build new town if necessary
  int fill_ground = r.BLACK;
  int stroke = r.GRAY[4];
  float thickness = 2;
  if(town.size() != cadastre.size()) {
    town.clear();
    for(int i = 0 ; i < cadastre.size() ; i++) {
      vec4 pos = cadastre.get(i).copy();
      float from_center = dist(vec2(pos.x,pos.z),vec2(0));
      Home h = new Home(this,surface,from_center,max_level);

      int fill_roof = color(random(0,30),random(80,100),random(60,90));
      int fill_wall = color(random(360),random(0,10),random(50,100));
      float peak = random(1);
      peak *= peak;
      h.set_architecture(vec2(peak*.5));
      h.set_aspect(fill_roof,fill_wall,fill_ground,stroke,thickness);

      town.add(h);
    }
  }
}




















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
  println("plot use",num-already_occupy,"on",num);
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
  println("plot use",num-already_occupy,"on",num);
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
    ivec2 p = ivec2(temp);
    int c = map.get(p.x(),p.y());
    altitude = brightness(c);
    altitude = map(altitude,0,g.colorModeZ,1,-1);
  }
  cadastre.add(vec4(pos.x,altitude,pos.y,id));

}







/**
* LOT
*/
vec2 lot_street_map(int average_surface, vec2 flat_world, ArrayList<R_Segment> segment) {
  int target = floor(random(segment.size()));
  vec3 a = segment.get(target).get_start();
  vec3 b = segment.get(target).get_end();
  float dist = a.mag(b);
  vec2 dir = vec2(a).dir(vec2(b));
  vec2 tan = vec2(a).tan(vec2(b));
  float new_dist = random(0,dist);
  float side = random(1);

  vec2 where = vec2();
  if(side < .5) {
    where = tan.mult(average_surface);
  } else {
    where = tan.mult(-average_surface);
  }

  vec2 pos = dir.mult(new_dist).add(where).add(b);
  float min_norm = -0.5;
  float max_norm = 0.5;
  pos.div(width,height).map(0,1,min_norm,max_norm);
  boolean occupy_is = cadastre_is(pos, average_surface, flat_world);

  if(occupy_is) {
    return null;
  } else {
    return pos;
  }
  
}







vec2 lot_random(int average_surface, vec2 flat_world) {
  float dist = random_next_gaussian(1,3); // make the center of town more occupy
  float angle = random(-PI,PI);
  vec2 pos = to_cartesian_2D(angle,dist);
  // println("pos normal",pos);
  
  // check if the surface is already occupy
  boolean occupy_is = cadastre_is(pos, average_surface, flat_world);
  if(occupy_is) {
    return null;
  } else {
    return pos;
  }
}





boolean cadastre_is(vec2 pos, int average_surface, vec2 flat_world) {
  boolean occupy = false;
  for(vec4 cad_pos : cadastre) {
    vec2 c_pos = vec2(cad_pos.x,cad_pos.z);
    vec2 area = vec2(sqrt(average_surface));
    // vec2 area = vec2(average_surface).mult(2);
    area.div(flat_world);
    if(compare(pos,c_pos,area)) {
      occupy = true;;
      break;
    }
  }
  return occupy;
}












/**
HABITATION
*/
public class Home {
  PApplet pa;
  int id;
  int level = 1;
  int surface;
  vec3 size;
  vec2 peak;

  int fill_roof = r.BLOOD;
  int fill_wall = r.GRAY[6];
  int fill_ground = r.BLACK;
  int stroke = r.BLACK;
  float thickness = 1;

  float from_center;
  House house;
  public Home(PApplet pa, int surface, float from_center, int max_level) {
    this.pa = pa;
    this.from_center = from_center;
    this.surface = surface;
    float avg_side = sqrt(surface) ;
    float add_length = avg_side* .75;
    float max_side = avg_side + random(add_length);

    float x = random(avg_side,max_side);
    float y = 2*avg_side -x;

    float center_ratio = 1. -from_center;
    if(center_ratio < .1) center_ratio = .1;
    float z = random(max_level /2,max_level) *center_ratio *y;

    // switch house orientation
    if(random(1) < .5) {
      size = vec3(x,z,y);
    } else {
      size = vec3(y,z,x);
    }
  }

  public void set_aspect(int fill_roof, int fill_wall, int fill_ground, int stroke, float thickness) {
    this.fill_roof = fill_roof;
    this.fill_wall = fill_wall;
    this.fill_ground = fill_ground;
    this.stroke = stroke;
    this.thickness = thickness;
  }

  public void set_architecture(vec2 peak) {
    if(this.peak == null) {
      this.peak = peak.copy();
    } else {
      this.peak.set(peak);
    }
  }

  int get_fill() {
    return this.fill_wall;
  }

  int get_fill_roof() {
    return this.fill_roof;
  }

  int get_fill_wall() {
    return this.fill_wall;
  }

  int get_fill_ground() {
    return this.fill_ground;
  }

  int get_stroke() {
    return this.stroke;
  }

  float get_thickness() {
    return this.thickness;
  }

  vec3 get_size() {
    return size;
  }

  public void show(vec3 pos) {
    // display house
    if(house == null) {
      house = new House(pa);
      house.set_fill_roof(fill_roof);
      house.set_fill_wall(fill_wall);
      house.set_fill_ground(fill_ground);
      house.set_stroke(stroke);
      house.set_thickness(thickness);
      house.size(size);
      house.mode(BOTTOM);
      if(peak != null) house.set_peak(peak.x,peak.y);
    }
    pushMatrix();
    translate(pos);
    house.show();
    popMatrix();
  }





  float get_from_center() {
    return from_center;
  }
}


