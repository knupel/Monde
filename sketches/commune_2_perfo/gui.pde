/**
 * GUI
 * 2026-2026
 * v 0.0.2
 * 
 * */

// GUI VARIABLE
boolean build_cadastre_is = false;
boolean build_maison_is = false;
// display object
boolean display_maison_is = true;
boolean display_cadastre_is = true;
boolean display_sol_is = false;
boolean display_surface_is = true;
boolean display_map_is = true;
boolean display_failure_is = false;
// display info
boolean display_info_is = false;
boolean display_stroller_is = true;
boolean display_dataviz_is = false;
// display aspect
boolean use_temp_aspect_is = false;
boolean use_fill_is = true;
boolean use_stroke_is = true;
boolean use_bg_is = true;
boolean stroke_dark_is = true;
// camera
boolean use_cam_is = false;
// move
boolean move_world_is = false;
boolean move_rot_house_is = false;
boolean move_trans_house_is = false;



// variable 3D
vec3 translate_house = new vec3();
vec3 rotate_house = new vec3();
vec3 rotate_town = new vec3();
vec3 rotate_surface = new vec3();

vec2 translate_world = new vec2();
vec3 rotate_world = new vec3();
float zoom_world = 0;

float mouse_speed = 0.01;
float mouse_wheel_count = 0;

////////////////////////
// PROCESSING FUNCTION
////////////////////////
boolean mouse_clicked = false;
// translate world
vec2 mouse_translate_buf = new vec2();
vec2 mouse_translate_offset = new vec2();
vec2 translate_offset = new vec2();
vec2 ref_translate_offset = new vec2();
// rotate world
vec2 mouse_rotate_buf = new vec2();
vec2 mouse_rotate_offset = new vec2();
vec2 rotate_offset = new vec2();
vec2 ref_rotate_offset = new vec2();

void mouseWheel(MouseEvent event) {
    boolean is = false;
    if(keyPressed && key == k_cam) is = true;
    if(use_cam_is()) is = true;
    if(is) mouse_wheel_count += (event.getCount() * 0.1);
}

void mouseReleased() {
  mouse_clicked = false;
  mouse_translate_buf.set(mouseX, mouseY);
  mouse_rotate_buf.set(mouseX, mouseY);
}

void mousePressed() {
    if(!mouse_clicked) {
        mouse_translate_buf.set(mouseX, mouseY);
        mouse_rotate_buf.set(mouseX, mouseY);
    }
    mouse_clicked = true;  
}


void keyPressed() {
  key_pressed_gui();
}



///////////////////////
// GUI FUNCTION
/////////////////////
void update_gui() {
    update_translate(mousePressed, mouseButton == LEFT);
    update_rotate(mousePressed, mouseButton == RIGHT);
    update_keyboard();
    mouse_wheel_count = 0;
}

// common function to update offset
// the offset can be for any data like translate, rotate, etc.
// maybe mouseX, mouseY can be passed more universaly like a global position ????
void update_offset(boolean is_a, boolean is_b, vec2 offset, vec2 buf) {
    if(is_a && is_b) {
        offset.x(mouseX - buf.x());
        offset.y(mouseY - buf.y());
    } else {
        offset.set(0);
    }
}


/////////////////////////////////
// specific function for rotate
/////////////////////////////////

void update_rotate(boolean is_a, boolean is_b) {
    update_offset(is_a, is_b, mouse_rotate_offset, mouse_rotate_buf);
    update_rotate_impl(is_a, is_b, rotate_offset, ref_rotate_offset, mouse_rotate_offset);
}

void update_rotate_impl(boolean is_a, boolean is_b, vec2 arg, vec2 ref, vec2 offset) {
    if(is_a && is_b) {
        arg.x(ref.x() + offset.x() * mouse_speed); 
        arg.y(ref.y() + offset.y() * mouse_speed);
    } else {
        ref.x(arg.x());
        ref.y(arg.y());
    }
}


/////////////////////////////////
// specific function for translate
/////////////////////////////////

void update_translate_impl(boolean is_a, boolean is_b, vec2 arg, vec2 ref, vec2 offset) {
    if(is_a && is_b) {
        arg.x(ref.x() + offset.x());
        arg.y(ref.y() + offset.y());
    } else {
        ref.x(arg.x());
        ref.y(arg.y());
    }
}

void update_translate(boolean is_a, boolean is_b) {
    update_offset(is_a, is_b, mouse_translate_offset, mouse_translate_buf);
    update_translate_impl(is_a, is_b, translate_offset, ref_translate_offset, mouse_translate_offset);
}











//
void update_keyboard() {
    // touche @
    if(key == k_reset_cam) {
        rotate_house.set(0);
        rotate_town.set(0);
        rotate_surface.set(0);
        rotate_world.set(0);
        translate_world.set(0);
        zoom_world = 0;
    }
    // touche 1 / 2 / 3
    if(keyPressed) {
        if(key == k_rot_house_x) rotate_house.x(mouseX * mouse_speed); // 1
        if(key == k_rot_house_y) rotate_house.y(mouseX * mouse_speed); // 2
        if(key == k_rot_house_z) rotate_house.z(mouseX * mouse_speed); // 3
    }

    // touche 4 / 5 / 6
    if(keyPressed) {
        // Je dois séparer les valeurs pour de la cohérence, pas comme Surface, bizarre
        if(key == k_rot_town_x) rotate_town.x(mouseX * mouse_speed); // 4
        if(key == k_rot_town_y)  rotate_town.y(mouseX * mouse_speed); // 5
        if(key == k_rot_town_z)  rotate_town.z(mouseX * mouse_speed); // 6
    }


     // touche 7 / 8  / 9
    if(keyPressed) {
        // 7
        if(key == k_rot_surface_xz) {
            rotate_surface.x(mouseY * mouse_speed);
            rotate_surface.z(mouseX * mouse_speed);
        }
        if(key == k_rot_surface_y) rotate_surface.y(mouseX * mouse_speed); // 8
    }

    // MOUSE ACTION
    if((keyPressed && key == k_cam) || use_cam_is()) {
        if(mousePressed) {
            if(mouseButton == LEFT) {
                translate_world.set(translate_offset);
            }
            if(mouseButton == RIGHT) {
                rotate_world.x(rotate_offset.y());
                rotate_world.z(rotate_offset.x());
            }
        }
        zoom_world -= mouse_wheel_count;
    }
}



// GUI
void key_pressed_gui() {
    if(key == k_reset_world) {
        tectonique(tectos, get_grid_Sol(), NOISE_ALT);
        set_sol_altitude();
        set_stroller();
        init_map(stroller);
        clear_cadastre();
        clear_maisons();
	}

    // CAMERA
    if(key == k_use_cam_lock) use_cam_switch();
    // MOVE
    if(key == k_move_world) move_world_switch();
    if(key == k_move_rot_house) move_rot_house_switch();
    if(key == k_move_trans_house) move_trans_house_switch();

    
    // OBJECT
    if(key== k_build_maison) build_maison(true); // T for town > Commune
    if(key== k_display_maison) display_maison_switch(); // t for town > Commune
    if(key== k_build_cadastre) build_cadastre(true);
    if(key== k_display_cadastre) display_cadastre_switch();

    // SURFACE
    if(key == k_display_sol) display_sol_switch();
    if(key == k_display_surface) display_surface_switch();
    if(key == k_display_road) display_map_switch();

    // DEV TOOL
    if(key == k_fail) display_failure_switch();

    // ASPECT
    if(key == k_temp_aspect) aspect_temp_switch();
    if(key == k_fill) use_fill_switch();
    if(key == k_stroke) use_stroke_switch();
    if(key == k_stroke_dark_is) stroke_dark_switch();
    if(key == k_background) use_bg_switch();
   
    // INFO
    if(key == k_dataviz) display_dataviz_switch();
    if(key == k_info) display_info_switch();
    if(key == k_display_stroller) display_stroller_switch();

    // MISC
    if(key == k_new_pos_stroller) reset_stroller();
    // if(key == 'p')  close_dead_end(15);

    // FREEZE
    if(key == k_pause) freeze();
}



////////////////////////
// KEY CONTROL FUNCTION
////////////////////////
void use_cam_switch() {
    use_cam_is = !use_cam_is;
}

boolean use_cam_is() {
    return use_cam_is;
}

void move_world_switch() {
    move_world_is = !move_world_is;
}

boolean move_world_is() {
    return move_world_is;
}

void move_trans_house_switch() {
    move_trans_house_is = !move_trans_house_is;
}

boolean move_trans_house_is() {
    return move_trans_house_is;
}

void move_rot_house_switch() {
    move_rot_house_is = !move_rot_house_is;
}

boolean move_rot_house_is() {
    return move_rot_house_is;
}

////////////////////
// DESIGN
// INFO
/////////////////////
// aspect
// stroke
void aspect_temp_switch() {
    use_temp_aspect_is = !use_temp_aspect_is;
}

boolean aspect_temp_is() {
    return  use_temp_aspect_is;
}
// fill
void use_fill_switch() {
    use_fill_is = !use_fill_is;
}

boolean use_fill_is() {
    return  use_fill_is;
}

// stroke
void use_stroke_switch() {
    use_stroke_is = !use_stroke_is;
}

boolean use_stroke_is() {
    return  use_stroke_is;
}

void stroke_dark_switch() {
    stroke_dark_is = !stroke_dark_is;
}

boolean stroke_dark_is() {
    return  stroke_dark_is;
}

// background
void use_bg_switch() {
    use_bg_is = !use_bg_is;
}

boolean use_bg_is() {
    return  use_bg_is;
}




// COMMUNE / MAISON / TOWN
////////////////////////////////
void build_maison(boolean is) {
    build_maison_is = is;
}

boolean build_maison_is() {
    return build_maison_is;
}

void display_maison_switch() {
    display_maison_is = !display_maison_is;
}

boolean display_maison_is() {
    return  display_maison_is;
}





// CADASTRE
////////////////////////////////
void build_cadastre(boolean is) {
    build_cadastre_is = is;
}

boolean build_cadastre_is() {
    return build_cadastre_is;
}

void display_cadastre_switch() {
    display_cadastre_is = !display_cadastre_is;
}

boolean display_cadastre_is() {
    return  display_cadastre_is;
}




// INFO
////////////////////////////////
void display_info_switch() {
    display_info_is = !display_info_is;
}

boolean display_info_is() {
    return  display_info_is;
}

void display_dataviz_switch() {
    display_dataviz_is = !display_dataviz_is;
}

boolean display_dataviz_is() {
    return  display_dataviz_is;
}

void display_stroller_switch() {
    display_stroller_is = !display_stroller_is;
}

boolean display_stroller_is() {
    return  display_stroller_is;
}



// SOL
////////////////////////////////
void display_sol_switch() {
    display_sol_is = !display_sol_is;
}

boolean display_sol_is() {
    return  display_sol_is;
}


// SURFACE
////////////////////////////////
void display_surface_switch() {
    display_surface_is = !display_surface_is;
}

boolean display_surface_is() {
    return  display_surface_is;
}



// MAP / CARTE
////////////////////////////////
void display_map_switch() {
    display_map_is = !display_map_is;
}

boolean display_map_is() {
    return  display_map_is;
}


// FAILURE
////////////////////////////////
void display_failure_switch() {
    display_failure_is = !display_failure_is;
}

boolean display_failure_is() {
    return  display_failure_is;
}