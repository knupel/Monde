import rope.vector.*;
import rope.core.Rope;
import rope.core.R_Graphic;

Rope r = new Rope();
R_Graphic rg;
Ground ground[];
int cols = 0;
int rows = 0;


void setup() {
  rg = new R_Graphic(this);
  size(600,600,P3D);
  ivec2 step = new ivec2(50);
  cols = width/step.x();
  rows = height/step.y();
  int num = cols * rows;
  ground = new Ground[num];
  int pos_x = 0;
  int pos_y = 0;
  //
  for(int i = 0 ; i < num ; i++) {
    if(pos_x > cols) {
      pos_x = 0;
    }
    ground[i] = new Ground();
    ground[i].pos(pos_x * step.x(), pos_y * step.y(),0);
    int elements = floor(random(100));
    ground[i].set_elements(elements);
    if(pos_x == 0) pos_y++;
    // pos_y++;
    pos_x++;
    println(ground[i].pos());
  }
}

void draw () {
  background(0);
  rg.fill_is(true);
  rg.stroke_is(true);
  rg.stroke(r.BLOOD);
  rg.fill(r.BLOOD);
  rg.thickness(10);
  for(int i = 0 ; i < ground.length ; i++) {
    rg.point(ground[i].pos());
  }
}




class Ground {
  private ivec3 pos = new ivec3();
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

  ivec3 pos() {
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
