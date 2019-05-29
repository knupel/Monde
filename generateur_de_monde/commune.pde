/**
* Ville : Project born in the Code Kitchen in Creative Code Paris january session.
* Copyleft (c) 2019-2019
* v 0.0.1
* Stan le Punk > http://stanlepunk.xyz/

* All class, method is in french...C'est la vie, excuse my french !
ville : town
habitation : home
generateur : generator
cadastre : land register
lot : habitation(home) position in the cadastre
urbanisme : management of town

*/


void commune(vec2 size_world, int surface_habitation) {
  int level = 6 ; // midi size
  // int surface_hab = 40;
  urbanisme(surface_habitation,level);

  for (int i = 0 ; i < cadastre.size() ; i++) {
    vec4 cad = cadastre.get(i).copy();
    Habitation h = town.get(i); 
    float px = cad.x *size_world.x;
    float py = cad.y -(h.size.z/2);
    float pz = cad.z *size_world.y;
    h.show(vec3(px,py,pz)); 
    // h.show(vec3(px,py,pz),true); 
  }
}


ArrayList<Habitation>town;
void urbanisme(int surface, int max_level) {
  if(town == null) {
    town = new ArrayList<Habitation>();
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
      Habitation h = new Habitation(this,surface,from_center,max_level);

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
HABITATION
*/
public class Habitation {
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
  public Habitation(PApplet pa, int surface, float from_center, int max_level) {
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






/**
CADASTRE
*/
ArrayList<vec4>cadastre;
void cadastre_generator(int num, int average_surface, vec2 size_world) {
  if(cadastre == null) {
    cadastre = new ArrayList<vec4>();
  }
  cadastre.clear();

  // that's can be change when the noise map will be introduce
  int altitude = 0;
  int already_occupy = 0;
  for(int i = 0 ; i < num ; i++) {
    vec2 pos = lot(average_surface,size_world);
    if(pos == null) {
      already_occupy++;
    } else {
      int id = (int)random(MAX_FLOAT); // use in futur to attribute habitation
      cadastre.add(vec4(pos.x,altitude,pos.y,id));
    }
  }
  println("plot use",num-already_occupy,"on",num);
}

vec2 lot(int average_surface, vec2 size_world) {
  float dist = random_next_gaussian(1,3); // make the center of town more occupy
  float angle = random(-PI,PI);
  vec2 pos = to_cartesian_2D(angle,dist);
  
  // check if the surface is already occupy
  boolean occupy = false;
  for(vec4 cad_pos : cadastre) {
    vec2 c_pos = vec2(cad_pos.x,cad_pos.z);
    vec2 area = vec2(sqrt(average_surface));
    // vec2 area = vec2(average_surface).mult(2);
    area.div(size_world);
    if(compare(pos,c_pos,area)) {
      occupy = true;;
      break;
    }
  }
  if(occupy) return null;
  else return vec2(pos.x,pos.y);
}








