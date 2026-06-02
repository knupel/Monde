/**
* SURFACE
* 2026-2026
* v 0.0.2
*
*/


void create_surface(R_Plate plate, ArrayList<R_Face> list) {
    int rx = 0;
    int ry = 0;
    boolean first_is = true;
    int cols = plate.get_cols();
    int rows = plate.get_rows();

    for(int i = 0 ; i < plate.get().length ; i++) {
        if(rx > plate.get_cols()) {
        first_is = false;
        rx = 0;
        }
        if(rx == 0 && !first_is) ry++;
        // les lignes principales
        if(rx < cols - 2) {
            vec3 a = plate.get(i).pointer_pos();
            vec3 b = plate.get(i +1).pointer_pos();
            vec3 c = plate.get(i +2).pointer_pos();
            R_Face face = new R_Face(this);
            face.pointer(a,b,c);
            list.add(face);
        }
        // les lignes intermédiaires
        if(ry > 0 && ry < plate.get_rows() && rx < plate.get_cols() -2) {
            if(rx%2 == 0) {
                vec3 a = plate.get(i -cols -1).pointer_pos();
                vec3 b = plate.get(i +1).pointer_pos();
                vec3 c = plate.get(i -cols +1).pointer_pos();
                R_Face face = new R_Face(this);
                face.pointer(a,b,c);
                list.add(face);
            } else {
                vec3 a = plate.get(i).pointer_pos();
                vec3 b = plate.get(i -cols).pointer_pos();
                vec3 c = plate.get(i +2).pointer_pos();
                R_Face face = new R_Face(this);
                face.pointer(a,b,c);
                list.add(face);     
            }

        }
        rx++;
    }

}




void show_surface() {
    rg.push();
    rg.translate(width/2, height/2);
	rg.push();
    rg.rotateXYZ(rotate_surface);
	rg.translate(-width/2, -height/2);
    render_surface(faces);
    rg.pop();
    rg.pop();
}




void render_surface(ArrayList<R_Face> list) {
    rg.thickness(1);
    rg.stroke_is(false);
    rg.fill_is(true);
    rg.stroke(r.TENEBRE);
    rg.fill(r.BLOOD); // need to write this line, if not there is a colour by default :(
    for(R_Face elem : list) {
        elem.show();
    }
}

