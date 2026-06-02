// GUI VARIABLE
boolean build_cadastre_is = false;
boolean build_maison_is = false;

boolean display_maison_is = true;
boolean display_cadastre_is = false;
boolean display_info_is = false;
boolean display_sol_is = false;
boolean display_surface_is = false;
boolean display_map_is = true;
boolean display_failure_is = false;

// variable 3D
vec3 rotate_house = new vec3(0);
vec3 rotate_town = new vec3(0);
vec3 rotate_surface = new vec3(0);

vec3 rotate_world = new vec3(0);


void update_gui() {
    // touche 1 / 2 / 3
    if(keyPressed) {
        if(key == '&') rotate_house.x(mouseX * 0.1); // 1
        if(key == 'é') rotate_house.y(mouseX * 0.1); // 2
        if(key == '"') rotate_house.z(mouseX * 0.1); // 3
    }

    // touche 4 / 5 / 6
    if(keyPressed) {
        // JE dois séparer les valeurs pour de la cohérence, pas comme Surface, bizarre
        if(key == '\'') rotate_town.x(mouseX * 0.01); // 4
        if(key == '(')  rotate_town.y(mouseX * 0.1); // 5
        if(key == '§')  rotate_town.z(mouseX * 0.01); // 6
    }


     // touche 7 / 8  / 9
    if(keyPressed) {
        // 7
        if(key == 'è') {
            rotate_surface.x(mouseY * 0.01);
            rotate_surface.z(mouseX * 0.01);
        }
        if(key == '!') rotate_surface.y(mouseX * 0.1); // 8
    }

    // 0 ) -
    if(keyPressed) {
        // JE dois séparer les valeurs pour de la cohérence, pas comme Surface, bizarre
        if(key == 'à') rotate_world.x(mouseX * 0.01); // 4
        if(key == ')')  rotate_world.y(mouseX * 0.1); // 5
        if(key == '-')  rotate_world.z(mouseX * 0.01); // 6
    }

}

// GUI
void key_pressed_gui() {
    if(key == 'n') reset_stroller();
    if(key == 'N') {
        tectonique(tectos, get_grid_Sol(), NOISE_ALT);
        set_sol_altitude();
        set_stroller();
        init_map(stroller);
        clear_cadastre();
	}

    if(key== 'T') build_maison(true); // T for town > Commune
    if(key== 't') display_maison_switch(); // t for town > Commune
    if(key== 'C') build_cadastre(true);
    if(key== 'c') display_cadastre_switch();
    if(key == 'i') display_info_switch();
    if(key == 's') display_sol_switch();
    if(key == 'S') display_surface_switch();
    if(key == 'm') display_map_switch();
    if(key == 'f') display_failure_switch();

    // if(key == 'p')  close_dead_end(15);

    // FREEZE
    if(key == 'p') freeze();
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