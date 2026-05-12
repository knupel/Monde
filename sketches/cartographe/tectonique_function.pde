/**
* Create a normal altitude from 0 to 1
 */
void tectonique(R_Tectos tectos, R_Lithos ground[]) {
  int bottom_points = 20;
  int tops_points = 20;
  float global_level_of_tectonite_plate = 0.3;
  tectos.clear();
  tectos.init_plate(ground, global_level_of_tectonite_plate);
  tectos.create_ridges_and_talwegs(bottom_points, tops_points);
  tectos.up_point_on_the_ridge(ground);
  tectos.down_point_on_the_talweg(ground);
  tectos.level_points_grid(ground);
  // lissage final autour du réseau
  tectos.smooth_altitudes(ground, 1000,0.9);
  tectos.add_noise_altitudes(ground, 0.1);
}





void show_talwegs(R_Tectos tectos) {
     // talwegs
  for(R_Line2D line : tectos.get_talwegs()) {
    line.show();
  }
  int rank = 0;
  for(vec3 pos : tectos.get_bottoms()) { 
    rg.ellipse(pos,20);
    rg.textAlign(CENTER);
    rg.text(rank++, pos.x(), pos.y());
  }
}

void show_ridges(R_Tectos tectos) {
  for(R_Line2D line : tectos.get_ridges()) {
    line.show();
  }
  int rank = 0;
  for(vec3 pos : tectos.get_tops()) { 
    rg.ellipse(pos,20);
    rg.textAlign(CENTER);
    rg.text(rank++, pos.x(), pos.y());
  }
}




