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
import rope.mesh.R_Shape;

Rope r = new Rope();

R_Tectos tectos;
R_Graphic rg;
R_Plate plate;
ArrayList<R_Face> faces = new ArrayList();
ArrayList<R_Shape> cadastre_polys = new ArrayList();


int CELL = 12;
float ALTITUDE = 120;
float NOISE_ALT = 0.02;


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

  // reset stroller
  if(stroller.reset_is()) {
    reset_stroller();
	}

  // build cadastre
  if(build_cadastre_is()) {
    create_cadastre(6, get_roads(), cadastre_polys);
    build_cadastre(false);
  }

  // show
  background(r.BLACK);
  lights();
  
  if(display_cadastre_is()) show_cadastre(cadastre_polys);
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
  key_pressed_gui();
}































