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