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
Rope r = new Rope();
R_Graphic rg;

// grille du sol
Sol sols[];
int cols = 0;
int rows = 0;
ivec2 cell = new ivec2(20,40);
ivec2 offset = new ivec2(0,20);
ivec2 tempo_offset = new ivec2(0,1); // nombre de ligne ou de colonne à sauter pour le décalage
// élément du maillage

void setup() {
	rg = new R_Graphic(this);
	size(1200,1200, P3D);
	sols = new Sol[init_sol(cell)];
	set_sol(sols, cell, offset, tempo_offset);
}


void draw() {
	background(r.WHITE);
	display_sol(sols);

}