// GUI VARAIBLE
boolean build_cadastre_is = false;
boolean display_cadastre_is = false;
boolean display_info_is = false;
boolean display_sol_is = false;
boolean display_surface_is = false;
boolean display_map_is = true;
boolean display_failure_is = false;


// GUI
void key_pressed_gui() {
    if(key == 'n') reset_stroller();
    if(key == 'N') {
        tectonique(tectos, get_grid_Sol(), NOISE_ALT);
        set_sol_altitude();
        set_stroller();
        init_map(stroller);
        clear_cadastre(cadastre_polys);
	}

    if(key== 'C') build_cadastre(true);
    if(key== 'c') display_cadastre_switch();
    if(key == 'i') display_info_switch();
    if(key == 's') display_sol_switch();
    if(key == 'S') display_surface_switch();
    if(key == 'm') display_map_switch();
    if(key == 'f') display_failure_switch();

    if(key == 'p')  close_dead_end(15);

    // FREEZE
    if(key == ' ') freeze();
}

// CADASTRE
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
void display_info_switch() {
    display_info_is = !display_info_is;
}

boolean display_info_is() {
    return  display_info_is;
}

// SOL
void display_sol_switch() {
    display_sol_is = !display_sol_is;
}

boolean display_sol_is() {
    return  display_sol_is;
}


// SURFACE
void display_surface_switch() {
    display_surface_is = !display_surface_is;
}

boolean display_surface_is() {
    return  display_surface_is;
}

// MAP / CARTE
void display_map_switch() {
    display_map_is = !display_map_is;
}

boolean display_map_is() {
    return  display_map_is;
}


// FAILURE
void display_failure_switch() {
    display_failure_is = !display_failure_is;
}

boolean display_failure_is() {
    return  display_failure_is;
}