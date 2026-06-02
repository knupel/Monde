/**
* class Maison
* v 0.2.0
* 2019-2026
*/
import rope.costume.R_House;


public class Maison {
  int id;
  int level = 1;
  int surface;
  float angle = 0;
  vec3 pos;
  vec3 size;
  vec2 peak;

  int fill_roof = r.BLOOD;
  int fill_wall = r.GRAY[6];
  int fill_ground = r.BLACK;
  int stroke = r.BLACK;
  float thickness = 1;

  float from_center;
  R_House house;
  public Maison(PApplet pa, vec pos, int surface, float from_center, int max_level) {
    house = new R_House(pa);
    this.pos = pos.xyz();
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

  ///////////////////
  // GEOMETRY
  /////////////////
  public vec3 pos() {
    return this.pos;
  }

  public void angle(float angle) {
    this.angle = angle;
  }

  public float angle() {
    return this.angle;
  }


  ////////////
  // DESIGN
  ////////////
  public void set_architecture(vec2 peak) {
    if(this.peak == null) {
      this.peak = peak.copy();
    } else {
      this.peak.set(peak);
    }
  }

  vec3 get_size() {
    return size;
  }


  ////////////
  // ASPECT
  ////////////
  public void set_aspect(int fill_roof, int fill_wall, int fill_ground, int stroke, float thickness) {
    this.fill_roof = fill_roof;
    this.fill_wall = fill_wall;
    this.fill_ground = fill_ground;
    this.stroke = stroke;
    this.thickness = thickness;
  }


  ////////////
  // FILL
  //////////
  int fill_roof() {
    return this.fill_roof;
  }

  int fill_wall() {
    return this.fill_wall;
  }

  int fill_ground() {
    return this.fill_ground;
  }

  void fill_is(boolean is) {
    if(house != null) {
      house.fill_is(is);
    }
  }


  /////////////////////
  // STROKE / THICKNESS
  ///////////////////////

  int stroke() {
    return this.stroke;
  }

  float thickness() {
    return this.thickness;
  }

  void thickness(float thickness) {
    this.thickness = thickness;
  }

  void stroke_is(boolean is) {
    if(house != null) {
      house.stroke_is(is);
    }
  }






  ////////////////
  // SHOW
  /////////////////
  public void show() {
    // PI * 1.5 >>> maison vue du dessus dans ce contexte.
    float rot_x = 4.712389;
    // display house
    house.fill_roof(fill_roof);
    house.fill_wall(fill_wall);
    house.fill_ground(fill_ground);
    house.stroke(stroke);
    house.thickness(thickness);
    house.size(size);
    house.mode(BOTTOM);
    if(peak != null) house.set_peak(peak.x,peak.y);
    rg.push();
    rg.rotateX(rot_x);
    house.show();
    rg.pop();
  }

  /////////////////
  // UTILS
  ////////////////
  float get_from_center() {
    return from_center;
  }
}


