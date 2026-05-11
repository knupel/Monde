/**
* Surface
* Création d'un maillage triangulaire 
* à partir d'une grille de points représentant le sol
* Copyleft (c) 2026-2026
* Artiste : Knupel
*/

import rope.core.Rope;
import rope.core.R_Graphic;
import rope.vector.ivec2;
import rope.mesh.R_Face;

Rope r = new Rope();
R_Graphic rg;

// grille du sol
Sol sols[];

ivec2 cell = new ivec2(20,40);
ivec2 offset = new ivec2(0,20);
ivec2 tempo_offset = new ivec2(2,0); // nombre de ligne ou de colonne à sauter pour le décalage
// élément du maillage
ArrayList<R_Face> faces = new ArrayList();

void setup() {
	rg = new R_Graphic(this);
	size(600,600, P3D);
	sols = new Sol[init_sol(cell)];
	set_sol(sols, cell, offset, tempo_offset);
	create_surface(sols,faces);
}


void draw() {
	background(r.WHITE);
	display_sol(sols);
	display_surface(faces);

}