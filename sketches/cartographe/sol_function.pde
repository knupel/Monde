/**
* ground 
* 2026-2026
* v 0.0.1
* @author Knupel
* https://github.com/knupel
* http://knupel.art
*/

R_Lithos sols[];


/**
* Function sol
* 2026-2026
* V 0.0.2
*/
void set_sol(int radius) {
  int cols = 0;
  int rows = 0;
  ivec2 step = new ivec2(radius*2);
  cols = width/step.x() + 1; // un peu bizarre, mais ça permets de faire les bordures
  rows = height/step.y() + 2; // juste bizarre de rajouter 2, mais ça permets de faire les bordures
  int num = cols * rows + rows;
  sols = new R_Lithos[num];
  int pos_x = 0;
  int pos_y = 0;
  boolean first_is = true;
  //
  for(int i = 0 ; i < num ; i++) {
    if(pos_x > cols) {
      first_is = false;
      pos_x = 0;
    }
    if(pos_x == 0 && !first_is) pos_y++;
    sols[i] = new R_Lithos();
    sols[i].pos(pos_x * step.x(), pos_y * step.y(),0);
    sols[i].radius(radius);
    int elements = floor(random(100));
    sols[i].set_sol(elements);
    pos_x++;
  }
}


R_Lithos [] get_grid_Sol() {
    return sols;
}


void show_sol(R_Lithos grid[]) {
  rg.fill_is(true);
  rg.stroke_is(true);
  // int colour = r.BLOOD;
  int colour = r.LUNE;
  vec3 hsb = new vec3(hue(colour), saturation(colour), brightness(colour));

  rg.thickness(grid[0].radius());
  for(int i = 0 ; i < grid.length ; i++) {
    int c = color(hsb.hue(), hsb.sat(), hsb.bri() * grid[i].pos().z());
    rg.stroke(c);
    rg.fill(c);
    rg.point(grid[i].pos());
  }
}