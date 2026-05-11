///////////////
// SURFACE
///////////////


void create_surface(Sol grid[], ArrayList<R_Face> list) {
    // r_x and r_y it's the rank in the grid
    int rx = 0;
    int ry = 0;
    boolean first_is = true;
    int cols = get_cols();
    int rows = get_rows();

    for(int i = 0 ; i < grid.length ; i++) {
        if(rx > get_cols()) {
        first_is = false;
        rx = 0;
        }
        if(rx == 0 && !first_is) ry++;
        // les lignes principales
        if(rx < cols - 2) {
            vec3 a = grid[i].pointer_pos();
            vec3 b = grid[i+1].pointer_pos();
            vec3 c = grid[i+2].pointer_pos();
            R_Face face = new R_Face(this);
            face.pointer(a,b,c);
            list.add(face);
        }
        // les lignes intermédiaires
        if(ry > 0 && ry < get_rows() && rx < get_cols() -2) {
            if(rx%2 == 0) {
                vec3 a = grid[i -cols -1].pointer_pos();
                vec3 b = grid[i +1].pointer_pos();
                vec3 c = grid[i -cols +1].pointer_pos();
                R_Face face = new R_Face(this);
                face.pointer(a,b,c);
                list.add(face);
            } else {
                vec3 a = grid[i].pointer_pos();
                vec3 b = grid[i -cols].pointer_pos();
                vec3 c = grid[i +2].pointer_pos();
                R_Face face = new R_Face(this);
                face.pointer(a,b,c);
                list.add(face);     
            }

        }
        rx++;
    }

}









void display_surface(ArrayList<R_Face> list) {
    rg.thickness(1);
    rg.fill_is(true);
    rg.stroke(r.BLOOD);
    rg.fill(r.CYAN);
    for(R_Face elem : list) {
        elem.show();
    }
}

