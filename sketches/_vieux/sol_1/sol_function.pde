/**
* Function sol
* 2026-2026
* V 0.1.0
*/
void set_sol(int diam) {
  int cols = 0;
  int rows = 0;
  ivec2 step = new ivec2(diam);
  cols = width/step.x() + 1; // un peu bizarre, mais ça permets de faire les bordures
  rows = height/step.y() + 2; // juste bizarre de rajouter 2, mais ça permets de faire les bordures
  int num = cols * rows + rows;
  sol = new R_Lithos[num];
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
    sol[i] = new R_Lithos();
    sol[i].pos(pos_x * step.x(), pos_y * step.y(),0);
    sol[i].radius(diam/2);
    int elements = floor(random(100));
    sol[i].set_sol(elements);
    pos_x++;
  }
}



void show_sol() {
  rg.fill_is(true);
  rg.stroke_is(true);
  // int colour = r.BLOOD;
  int colour = r.LUNE;
  vec3 hsb = new vec3(hue(colour), saturation(colour), brightness(colour));

  rg.thickness(diam/2);
  for(int i = 0 ; i < sol.length ; i++) {
    int c = color(hsb.hue(), hsb.sat(), hsb.bri() * sol[i].pos().z());
    rg.stroke(c);
    rg.fill(c);
    rg.point(sol[i].pos());
  }
}