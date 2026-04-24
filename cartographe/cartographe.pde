/**
* Projet MONDE
* Chapitre : Le Cartographe
* 2019-2026
* v 2.0.0
* @author Knupel
* https://github.com/knupel
* http://knupel.art
*/
import rope.core.*;
import rope.vector.*;
import rope.image.R_Pattern;

Rope r = new Rope();

R_Graphic rg;


/**
* ROAD MAP / ROAD NETWORK implementation
* @see http://martindevans.me/game-development/2015/12/11/Procedural-Generation-For-Dummies-Roads/
* @see http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.85.6659&rep=rep1&type=pdf
* @see https://graphics.ethz.ch/Downloads/Publications/Papers/2001/p_Par01.pdf
*/


void setup() {
  rg = new R_Graphic(this);
  println(r.VERSION);
  background(0);
  fullScreen(P2D,1);
  set_ground(10);
  // size(1300,800, P2D);
  init_street_map();
}


void draw() {
  background(0);
  show_ground();
  map();
  urbanist();
  if(show_info_is) {
  	show_center_world();
  	boussole(new vec2(grid_nodes_monde.get(0).pos()),80);
    show_intersection();
  }

}



boolean show_info_is = true;
void keyPressed() {
	if(key == 'n') {
		init_street_map();
	}

  if(key == ' '){
    freeze();
  }

	if(key == 'i') {
		if(show_info_is) {
			show_info_is = false;
		} else {
			show_info_is = true;
		}
	}
}































