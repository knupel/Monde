/**
* Sol
* 2026-2026
* v 0.1.0
* @author Knupel
* https://github.com/knupel
* http://knupel.art
*/



/**
* Function sol
* 2026-2026
* V 0.0.3
*/
void set_sol(int diam) {
  float amplitude = 40;
  plate = new R_Plate(new ivec2(width, height), new ivec2(diam), amplitude);
}


R_Lithos [] get_grid_Sol() {
    return plate.get();
}


void show_sol(R_Lithos grid[]) {
  rg.fill_is(true);
  rg.stroke_is(true);
  int colour = r.LUNE;
  vec3 hsb = new vec3(hue(colour), saturation(colour), brightness(colour));

  // rg.thickness(2);
  rg.thickness(grid[0].radius());
  for(int i = 0 ; i < grid.length ; i++) {
    int c = color(hsb.hue(), hsb.sat(), hsb.bri() * grid[i].pos().z());
    rg.stroke(c);
    // if(plate.get(mouseX,mouseY))
    rg.fill(c);
    rg.point(grid[i].pos());
  }
  // detection test
}


void show_target_lithos(R_Lithos grid[]) {
  rg.thickness(grid[0].radius()*4);
  rg.stroke(r.BLOOD);
  rg.point(plate.get(mouseX,mouseY).pos());
}

R_Lithos get_lithos(int target_x, int target_y) {
  return plate.get(target_x, target_y);
}