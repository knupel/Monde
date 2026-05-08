/**
* Function sol
* 2026-2026
* V 0.0.1
*/
void set_sol(int diam) {
  ivec2 step = new ivec2(diam);
  cols = width/step.x() + 1; // un peu bizarre, mais ça permets de faire les bordures
  rows = height/step.y() + 2; // juste bizarre de rajouter 2, mais ça permets de faire les bordures
  int num = cols * rows + rows;
  sol = new Sol[num];
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
    sol[i] = new Sol();
    sol[i].pos(pos_x * step.x(), pos_y * step.y(),0);
    sol[i].radius(diam/2);
    int elements = floor(random(100));
    sol[i].set_elements(elements);
    pos_x++;
  }
}