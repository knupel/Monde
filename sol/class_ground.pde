class Ground {
  private vec3 pos = new vec3();
  private int water = 0;
  private int ground = 0;
  private int elements = 0;
  
  Ground() {
  }

  void pos(int x, int y, int z) {
    pos.x(x);
    pos.y(y);
    pos.z(z);
  }

  void set_ground(int ground) {
    this.ground = ground;
  }

  void set_elements(int elements) {
    this.elements = elements;
  }

  vec3 pos() {
    return this.pos;
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