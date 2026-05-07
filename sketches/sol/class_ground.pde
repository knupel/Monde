/**
* Ground 
* 2026-2026
* v 0.0.1
*/
class Ground {
  private vec3 pos = new vec3();
  private int radius = 1;
  private vec3 size = new vec3(1);
  private int water = 0;
  private int ground = 0;
  private int elements = 0;
  
  Ground() {
  }

  // position
  void pos(int x, int y, int z) {
    this.pos.x(x);
    this.pos.y(y);
    this.pos.z(z);
  }

  vec3 pos() {
    return this.pos.copy();
  }

  // radius
  void radius(int radius) {
    this.radius = radius;
  }

  int radius() {
    return this.radius;
  }
  
  // size
  void size(int x, int y, int z) {
    this.size.x(x);
    this.size.y(y);
    this.size.z(z);
  }

  vec3 size() {
    return this.size.copy();
  }

  void set_ground(int ground) {
    this.ground = ground;
  }

  void set_elements(int elements) {
    this.elements = elements;
  }



  int get_ground() {
    return this.ground;
  }

  int get_elements() {
    return this.elements;
  }

  int get_water() {
    return this.water;
  }
}