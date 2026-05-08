/**
* Function sol
* 2026-2026
* V 0.0.2
*/
import rope.vector.ivec2;

int init_sol(ivec2 cell) {
  // ivec2 step = new ivec2(diam);
  cols = width/cell.x() + 1; // un peu bizarre, mais ça permets de faire les bordures
  rows = height/cell.y() + 2; // juste bizarre de rajouter 2, mais ça permet de faire les bordures
  int num = cols * rows + rows;
  return num;
}

void set_sol(Sol grid[], ivec2 cell, ivec2 offset, ivec2 tempo) {
  // ivec2 step = new ivec2(diam);
  // cols = width/step.x() + 1; // un peu bizarre, mais ça permets de faire les bordures
  // rows = height/step.y() + 2; // juste bizarre de rajouter 2, mais ça permet de faire les bordures
  // int num = cols * rows + rows;
  // grid = new Sol[num];
  int num = grid.length;
  int pos_x = 0;
  int pos_y = 0;
  boolean first_is = true;
  // offset
  ivec2 os = new ivec2();

  //
  int radius = cell.min() /2 ;
  for(int i = 0 ; i < num ; i++) {
    if(pos_x > cols) {
      first_is = false;
      pos_x = 0;
    }
    if(pos_x == 0 && !first_is) pos_y++;
    grid[i] = new Sol();
    // use offset
    if(pos_x > 0 && pos_x%tempo.x() == 0) os.x(offset.x()); else os.x(0);
    if(pos_y > 0 && pos_y%tempo.y() == 0) os.y(offset.y()); else os.y(0);
    // finalize position
    grid[i].pos(pos_x * cell.x() + os.x(), pos_y * cell.y() + os.y(),0);

    grid[i].radius(radius);
    int elements = floor(random(100));
    grid[i].set_elements(elements);
    pos_x++;
  }
}

void display_sol(Sol grid[]) {
  println("grid size", grid.length);
  rg.thickness(5);
  rg.stroke_is(true);
  rg.stroke(r.GOLD);
  for(Sol elem : grid) {
    rg.point(elem.pos.xy());
  }
}