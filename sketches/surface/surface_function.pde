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
        // code
        println(rx, ry);
        // les lignes principales
        if(rx < cols - 2) {
            vec3 a = grid[i].pos();
            vec3 b = grid[i+1].pos();
            vec3 c = grid[i+2].pos();
            R_Face face = new R_Face(this,a,b,c);
            list.add(face);
        }
        // les lignes intermédiaires
        if(ry > 0 && ry < get_rows() -1 && rx < get_cols() - 2) {
            if(rx%2 == 0) {
                vec3 a = grid[i - cols -1].pos();
                vec3 b = grid[i + 1].pos();
                vec3 c = grid[i- cols +1].pos();
                R_Face face = new R_Face(this,a,b,c);
                list.add(face);
            } else {
                vec3 a = grid[i].pos();
                vec3 b = grid[i -cols].pos();
                vec3 c = grid[i +2].pos();
                R_Face face = new R_Face(this,a,b,c);
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



// ARCHIVE IA test

void create_surface_agent_1(Sol grid[], ArrayList<R_Face> list) {
    // Génère des triangles R_Face pour couvrir la surface sans trous ni chevauchements
    // Chaque triangle = cellule courante + voisin droit + voisin bas
    
    int cols = get_cols();
    int rows = get_rows();
    
    // Itérer sur chaque cellule sauf la dernière colonne et dernière ligne
    for (int ry = 0; ry < rows - 1; ry++) {
        for (int rx = 0; rx < cols - 1; rx++) {
            // Récupérer les 3 points du triangle
            Sol current = get_Sol(grid, rx, ry);
            Sol right = get_Sol(grid, rx + 1, ry);
            Sol bottom = get_Sol(grid, rx, ry + 1);
            
            // Vérifier que tous les points existent
            if (current != null && right != null && bottom != null) {
                // Créer le triangle avec les 3 positions
                vec3 p1 = current.pos();
                vec3 p2 = right.pos();
                vec3 p3 = bottom.pos();
                
                // Créer et ajouter la face triangulaire
                R_Face face = new R_Face(this, p1, p2, p3);
                list.add(face);
            }
        }
    }
}


Sol get_Sol(Sol grid[], int rx, int ry) {
  // Accède à une cellule par ses coordonnées (rx, ry) dans la grille
  if (rx < 0 || rx >= get_cols() || ry < 0 || ry >= get_rows()) {
    return null; // Hors limites
  }
  int index = ry * get_cols() + rx;
  if (index >= 0 && index < grid.length) {
    return grid[index];
  }
  return null;
}