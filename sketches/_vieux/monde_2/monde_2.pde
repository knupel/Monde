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
import rope.geo.R_Plate;
import rope.mesh.R_Face;
import rope.colour.R_Colour;

Rope r = new Rope();

R_Tectos tectos;
R_Graphic rg;
R_Plate plate;
ArrayList<R_Face> faces = new ArrayList();


int CELL = 12;
float ALTITUDE = 120;
float NOISE_ALT = 0.02;

int SURFACE_HOME = 100;


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
  // fullScreen(P3D,1);
  size(1300,800, P3D);
  // size(1300,800, P2D);
  tectos = new R_Tectos(this, width, height);

  init_sol(CELL, ALTITUDE);
  set_sol();

  // BESOIN DE TRAVAILLER SUR LA DISTRIBUTION DE POINTS
  // BESOIN DE TRAVAILLER SUR LA DISTRIBUTION DE POINTS
  // BESOIN DE TRAVAILLER SUR LA DISTRIBUTION DE POINTS
  // BESOIN DE TRAVAILLER SUR LA DISTRIBUTION DE POINTS
  // BESOIN DE TRAVAILLER SUR LA DISTRIBUTION DE POINTS
  tectonique(tectos, get_grid_Sol(), NOISE_ALT);
  // BESOIN DE TRAVAILLER SUR LA DISTRIBUTION DE POINTS
  // BESOIN DE TRAVAILLER SUR LA DISTRIBUTION DE POINTS
  // BESOIN DE TRAVAILLER SUR LA DISTRIBUTION DE POINTS
  // BESOIN DE TRAVAILLER SUR LA DISTRIBUTION DE POINTS
  set_sol_altitude();
  init_stroller();
  init_map(get_stroller());
  set_stroller();
  create_surface(plate,faces);
}

void draw() {
  // info top window
  String title =  "Cartographe | FPS : " + (int)frameRate + 
                  " | Grille : " + get_grid_Sol().length + 
                  " | Routes " + get_roads().size() + 
                  " | Échec " + stroller.get_failure().size();
  surface.setTitle(title);

  // build
  build_map(plate, stroller);
  run_stroller();

  // cadastre
  vec3 size_world = new vec3(3*width,width,3*width);
  int urban_mode = 0;
  int min_lot = 10;
  int max_lot = 20;
  int tempo_build = 20; // tempo is a modulo of the size of the street map.
  boolean use_relief_is = true;
  cadastre_update(urban_mode,min_lot,max_lot,tempo_build,size_world, use_relief_is);

  // reset stroller
  if(stroller.reset_is()) {
    reset_stroller();
	}

  // show
  background(r.BLACK);
  lights();
  
  if(display_sol_is()) show_sol(get_grid_Sol(), P3D); // possible to choice P2D
  if(display_map_is()) show_map();
  if(display_failure_is()) show_failure();
  show_stroller();
  if(display_info_is()) {
  	show_center_town(20, r.BLOOD);
  	boussole(new vec2(grid_nodes_monde.get(0).pos()),80);
    show_intersection();
  }
  // 3D part
  if(display_surface_is()) show_surface();
}




void keyPressed() {
	if(key == 'n') {
    tectonique(tectos, get_grid_Sol(), NOISE_ALT);
    set_sol_altitude();
    set_stroller();
    init_map(stroller);
	}
  if(key == 'N') {
    reset_stroller();
  }

  if(key == ' '){
    freeze();
  }

	if(key == 'i') display_info_switch();
  if(key == 's') display_sol_switch();
  if(key == 'S') display_surface_switch();
  if(key == 'm') display_map_switch();
  if(key == 'f') display_failure_switch();




  if(key == 'p') {
    close_dead_end(15);
  }
}































