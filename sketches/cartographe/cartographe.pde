/**
* Projet MONDE
* Chapitre : Le Cartographe
* 2019-2026
* v 2.1.0
* @author Knupel
* https://github.com/knupel
* http://knupel.art
*/
import rope.core.*;
import rope.vector.*;
import rope.geo.R_Lithos;
import rope.geo.R_Tectos; 

Rope r = new Rope();

R_Tectos tectos;
R_Graphic rg;
R_Plate plate;



/**
* ROAD MAP / ROAD NETWORK implementation
* @see http://martindevans.me/game-development/2015/12/11/Procedural-Generation-For-Dummies-Roads/
* @see http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.85.6659&rep=rep1&type=pdf
* @see https://graphics.ethz.ch/Downloads/Publications/Papers/2001/p_Par01.pdf
*/


void setup() {
  rg = new R_Graphic(this);
  colorMode(HSB,360,100,100);
  println(r.VERSION);
  background(0);
  // fullScreen(P2D,1);
  size(1300,800, P2D);
  tectos = new R_Tectos(this, width, height);
  set_sol(7);
  tectonique(tectos, get_grid_Sol());
  init_stroller();
  init_map(get_stroller());
  set_stroller();
}


void draw() {
  String title = "Cartographe | FPS : " + (int)frameRate + " | Grille : " + get_grid_Sol().length + " | Routes " + get_roads().size();
  surface.setTitle(title);
  // build
  build_map(plate, get_stroller());
  run_stroller();

  // show
  background(0);
  if(display_sol_is()) show_sol(get_grid_Sol());
  if(display_map_is()) show_map();
  if(display_failure_is()) show_failure();
  show_stroller();
  if(display_info_is()) {
  	show_center_town(20, r.BLOOD);
  	boussole(new vec2(grid_nodes_monde.get(0).pos()),80);
    show_intersection();
  }
}




void keyPressed() {
	if(key == 'n') {
		init_map(get_stroller());
    tectonique(tectos, get_grid_Sol());
    set_stroller();
	}

  if(key == ' '){
    freeze();
  }

	if(key == 'i') display_info_switch();
  if(key == 's') display_sol_switch();
  if(key == 'm') display_map_switch();
  if(key == 'f') display_failure_switch();




  if(key == 'p') {
    close_dead_end(15);
  }
}































