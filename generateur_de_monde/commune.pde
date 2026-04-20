/**
* Ville : Project born in the Code Kitchen in Creative Code Paris january session.
* Copyleft (c) 2019-2026
* v 0.3.0
* @see http://knupel.art/

* All class, method is in french... C'est la vie, excuse my french!
ville : town
habitation : home
generateur : generator
cadastre : land register
lot : habitation(home) position in the cadastre
urbanisme : management of town
*/
import rope.costume.R_House;

void commune(vec3 world, int surface_habitation, int which_one) {
  int level = 6 ; // midi size
  // int surface_hab = 40;
  urbanisme(surface_habitation,level);

  for (int i = 0 ; i < cadastre.size() ; i++) {
    vec4 cad = cadastre.get(i).copy();
    Home h = town.get(i);
    h.fill_is(show_fill_is);
    h.stroke_is(show_stroke_is);
    float px = cad.x *world.x();
    float py = (cad.y *world.y()) -(h.size.z/2);
    float pz = cad.z *world.z();
    vec3 pos = new vec3(px,py,pz);
    show_home(h, pos, which_one);
  }
}


void show_home(Home h, vec3 pos, int which) {
  if(which == 0) {
    h.show(pos);  
  } else {
    strokeWeight(1);
    rg.stroke(r.BLACK);
    fill(h.get_fill());
    if(which == 1) {
      costume(pos,h.get_size(),r.LINE);
    } else if(which == 2) {
      costume(pos,h.get_size(),r.TETRAHEDRON);
    } else if(which == 3) {
      costume(pos,h.get_size(),r.SPHERE_LOW);
    } else if(which == 4) {
      costume(pos,h.get_size(),r.SPHERE_MEDIUM);
    } else if(which == 5) {
      costume(pos,h.get_size(),r.CROSS_BOX_2);
    } else if(which == 6) {
      costume(pos,h.get_size(),r.CROSS_BOX_3);
    } else if(which == 7) {
      costume(pos,h.get_size(),r.FLOWER);
    } else if(which == 8) {
      costume(pos,h.get_size(),r.STAR);
    } else if(which == 9) {
      costume(pos,h.get_size(),r.STAR_3D);
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
      float from_center = r.dist(new vec2(pos.x,pos.z),new vec2(0));
      Home h = new Home(this,surface,from_center,max_level);
      int fill_roof = color(random(0,30),random(80,100),random(60,90));
      int fill_wall = color(random(360),random(0,10),random(50,100));
      float peak = random(1);
      peak *= peak;
      h.set_architecture(new vec2(peak*.5));
      h.set_aspect(fill_roof,fill_wall,fill_ground,stroke,thickness);
      town.add(h);
    }
  }
}








































/**
* LOT
*/
vec2 lot_street_map(int average_surface, vec2 flat_world, ArrayList<R_Segment> segment) {
  int target = floor(random(segment.size()));
  vec3 a = segment.get(target).get_start();
  vec3 b = segment.get(target).get_stop();
  float dist = a.mag(b);
  vec2 dir = new vec2(a).dir(new vec2(b));
  vec2 tan = new vec2(a).tan(new vec2(b));
  float new_dist = random(0,dist);
  float side = random(1);

  vec2 where = new vec2();
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
  float dist = r.random_next_gaussian(1,3); // make the center of town more occupy
  float angle = random(-PI,PI);
  vec2 pos = r.to_cartesian_2D(angle,dist);
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
    vec2 c_pos = new vec2(cad_pos.x(),cad_pos.z());
    vec2 area = new vec2(sqrt(average_surface));
    // vec2 area = vec2(average_surface).mult(2);
    area.div(flat_world);
    if(r.compare(pos,c_pos,area)) {
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
  R_House house;
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
      size = new vec3(x,z,y);
    } else {
      size = new vec3(y,z,x);
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

  void fill_is(boolean is) {
    if(house != null) {
      house.fill_is(is);
    }
  }

    void stroke_is(boolean is) {
    if(house != null) {
      house.stroke_is(is);
    }
  }

  public void show(vec3 pos) {
    // display house
    if(house == null) {
      house = new R_House(pa);
      house.fill_roof(fill_roof);
      house.fill_wall(fill_wall);
      house.fill_ground(fill_ground);
      house.stroke(stroke);
      house.thickness(thickness);
      house.size(size);
      house.mode(BOTTOM);
      if(peak != null) house.set_peak(peak.x,peak.y);
    }
    pushMatrix();
    rg.translate(pos);
    house.show();
    popMatrix();
  }



  float get_from_center() {
    return from_center;
  }
}


