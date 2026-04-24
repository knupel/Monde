/**
* ground 
* 2026-2026
* v 0.0.1
*/

int cols = 0;
int rows = 0;
Ground ground[];


void set_ground(int radius) {
    ivec2 step = new ivec2(radius);
    cols = width/step.x() + 1; // un peu bizarre, mais ça permets de faire les bordures
    rows = height/step.y() + 2; // juste bizarre de rajouter 2, mais ça permets de faire les bordures
    int num = cols * rows + rows;
    ground = new Ground[num];

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
        ground[i] = new Ground();
        ground[i].set_radius(radius);
        ground[i].pos(pos_x * step.x(), pos_y * step.y(),0);
        int elements = floor(random(100));
        ground[i].set_elements(elements);
        pos_x++;
    }
}


void show_ground() {
      rg.fill_is(true);
  rg.stroke_is(true);
  rg.stroke(r.BLOOD);
  rg.fill(r.BLOOD);
  rg.thickness(ground[0].get_radius()/4);
  for(int i = 0 ; i < ground.length ; i++) {
    rg.point(ground[i].pos());
  }
}