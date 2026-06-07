// MOVE
vec3 wave_world = new vec3();
vec3 wave_house = new vec3();
void update_move() {
    if(move_world_is()) {
        wave_world.wave(frameCount, 0.003, 0.003, 0.003).mult(TAU);
        // AMELIORER AFIN de REPRENDRE LA CAMERA EN MANUELLE avec .add() cela ne fonctionne pas
        // Besoin de créer un buffer
        rotate_world.set(wave_world);
    }

    
    if(move_rot_house_is() || move_trans_house_is()) {
        wave_house.wave(frameCount, 0.002, 0.005, 0.001);
        if(move_rot_house_is() ) {
            rotate_house.x(wave_house.x() * TAU);
            rotate_house.y(wave_house.y() * TAU);
            rotate_house.z(wave_house.z() * TAU);
        }

        if(move_trans_house_is()) {
            translate_house.x(wave_house.x() * ALTITUDE);
        }
    }
}


// ASPECT
int stroke_color = 0;

void update_aspect() {
    if(stroke_dark_is()) {
        stroke_color = r.TENEBRE;
    } else {
        stroke_color = r.LUNE;
    }
}

// get color
int get_stroke_color() {
    return stroke_color;
}