boolean show_info_is = false;
boolean show_commune_is = true;
boolean show_fill_is = true;
boolean show_stroke_is = true;
boolean show_background_image_relief_is = false;
boolean use_noise_map_is = true;
boolean use_relief_is = false;

void keyPressed() {
  if(key == 'n') {  
    reset();
  }

  if(key == 'b') {
    show_background_image_relief_is = !show_background_image_relief_is;
  }

  if(key == 'r') {
    use_relief_is = !use_relief_is;
    reset();
  }

  if(key == 'm') {
    use_noise_map_is = !use_noise_map_is;
  }

  if(key == 'i') {
    show_info_is = !show_info_is;
  }

  if(key == 's') {
    show_commune_is = !show_commune_is;
  }

  if(key == 'd') {
    show_fill_is = !show_fill_is;
  }

  if(key == 'f') {
    show_stroke_is = !show_stroke_is;
  }

  if(key == '0') {
    urban_mode = 0;
  }

  if(key == '1') {
    urban_mode = 1;
  }

  if(key == CODED) {
    if(keyCode == UP) {
      which_costume ++;
    }
    if(keyCode == DOWN) {
      which_costume --;
    }
  }

  if(key == 'o') {
    select_input();
    use_noise_map_is = false;
  }

}