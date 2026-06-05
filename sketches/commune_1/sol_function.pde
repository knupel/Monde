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
* V 0.0.4
*/





void init_sol(int diam, float amplitude) {
  plate = new R_Plate(new ivec2(SIZE.x(), SIZE.y()), new ivec2(diam), amplitude);
  
}

void set_sol() {
  ivec2 cell = plate.cell().copy();
  ivec2 offset = new ivec2(0,cell.x()/2);
  ivec2 tempo = new ivec2(2,0); // nombre de lignes ou de colonnes à sauter pour le décalage
  int r_x = 0;
  int r_y = 0;
  boolean first_is = true;
  // offset
  ivec2 os = new ivec2();

  //
  for(int i = 0 ; i < plate.get().length ; i++) {
    if(r_x > plate.get_cols()) {
      first_is = false;
      r_x = 0;
    }
    if(r_x == 0 && !first_is) {
      r_y++;
    }
    // use offset
    if(tempo.y() != 0 && r_y%tempo.y() == 0) os.x(offset.x()); 
    else os.x(0);
    if(tempo.x() != 0 && r_x%tempo.x() == 0) os.y(offset.y()); 
    else os.y(0);
    // finalize position
    float x = r_x * cell.x() + os.x();
    float y = r_y * cell.y() + os.y();
    plate.get(i).pointer_pos().x(x);
    plate.get(i).pointer_pos().y(y);

    int elements = floor(random(100));
    plate.get(i).set_sous_sol(elements);
    r_x++;
  }

}

void set_sol_altitude() {
  for(R_Lithos lithos : plate.get()) {
    float norm_alt = lithos.pos().z();
    float alt = lithos.pos().z() * plate.amplitude();
    lithos.pointer_pos().z(alt);
    lithos.altitude(norm_alt, alt);
  }
}


R_Lithos [] get_grid_Sol() {
    return plate.get();
}


void show_sol(R_Lithos grid[], String render) {
  rg.fill_is(true);
  rg.stroke_is(true);
  int colour = r.LUNE;
  vec3 hsb = new vec3(hue(colour), saturation(colour), brightness(colour));

  rg.thickness(grid[0].radius());
  for(int i = 0 ; i < grid.length ; i++) {
    float normal_altitude = grid[i].altitude().x();
    int c = color(hsb.hue(), hsb.sat(), hsb.bri() * normal_altitude);
    rg.stroke(c);
    rg.fill(c);
    if(render == P2D) {
      rg.point(grid[i].pos().xy());
    } else rg.point(grid[i].pos());
    
  }
}


void show_target_lithos(R_Lithos grid[]) {
  rg.thickness(grid[0].radius()*4);
  rg.stroke(r.BLOOD);
  rg.point(plate.get(mouseX,mouseY).pos());
}

R_Lithos get_lithos(int target_x, int target_y) {
  return plate.get(target_x, target_y);
}