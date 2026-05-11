/**
* Function sol
* 2026-2026
* V 0.0.2
*/
import rope.vector.ivec2;

///////////////
// SOL
///////////////
int cols = 0;
int rows = 0;
int get_cols() {
  return cols;
}

int get_rows() {
  return rows;
}

int init_sol(ivec2 cell) {
  // ivec2 step = new ivec2(diam);
  cols = width/cell.x() + 1; // un peu bizarre, mais ça permets de faire les bordures
  rows = height/cell.y() + 2; // juste bizarre de rajouter 2, mais ça permet de faire les bordures
  int num = cols * get_rows() + get_rows();
  return num;
}

void set_sol(Sol grid[], ivec2 cell, ivec2 offset, ivec2 tempo) {
  // r_x and r_y it's the rank in the grid
  int r_x = 0;
  int r_y = 0;
  boolean first_is = true;
  // offset
  ivec2 os = new ivec2();

  //
  int radius = cell.min() /2 ;
  for(int i = 0 ; i < grid.length ; i++) {
    if(r_x > get_cols()) {
      first_is = false;
      r_x = 0;
    }
    if(r_x == 0 && !first_is) r_y++;
    grid[i] = new Sol();
    // use offset
    if(tempo.y() != 0 && r_y%tempo.y() == 0) os.x(offset.x()); else os.x(0);
    if(tempo.x() != 0 && r_x%tempo.x() == 0) os.y(offset.y()); else os.y(0);
    // finalize position
    grid[i].pos(r_x * cell.x() + os.x(), r_y * cell.y() + os.y(),0);

    grid[i].radius(radius);
    int elements = floor(random(100));
    grid[i].set_elements(elements);
    r_x++;
  }
}



void display_sol(Sol grid[]) {
  rg.thickness(5);
  rg.stroke_is(true);
  rg.stroke(r.GOLD);
  for(Sol elem : grid) {
    rg.point(elem.pos.xy());
  }
}

void update_sol(Sol grid[]) {
  float x = sin(frameCount * 0.01);
  float y = cos(frameCount * 0.02);
  for(Sol elem : grid) {
    float z = cos(frameCount * 0.005);
    elem.x(elem.x() + x);
    elem.y(elem.y() + y);
    elem.z(elem.z() + z);
  }
}