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
  update_info();
  update_gui();
  // info top window
  String title =  "Cartographe | FPS : " + info_fps + 
                  " | Grille : " + info_grid_size + 
                  " | Routes " + info_num_roads + 
                  " | Échec " + info_num_fail;
  surface.setTitle(title);

  // build map
  build_map(plate, stroller);
  run_stroller();

  // reset stroller
  if(stroller.reset_is()) {
    reset_stroller();
	}

  // build cadastre
  if(build_cadastre_is()) {
    create_cadastre(6, get_roads());
    build_cadastre(false);
  }

  // build maison / commune
  if(build_maison_is()) {
    create_maisons(get_cadastre(), plate);
    build_maison(false);
  }

  // show
  if(use_bg_is()) background(r.TENEBRE); 
  else  background(ciel()); 
  lights();

  // start matrix
  rg.push();
  rg.translate(width/2 + translate_world.x(), height/2 + translate_world.y(), zoom_world);
  rg.rotateXYZ(rotate_world);
  rg.translate(-width/2, -height/2);
  // rg.translateZ(zoom_world);
  // 2D
  if(display_cadastre_is()) show_cadastre();
  if(display_sol_is()) show_sol(get_grid_Sol(), P3D); // possible to choice P2D
  if(display_map_is()) show_map();
  if(display_failure_is()) show_failure();
  
  // INFO 2D
  if(display_dataviz_is()) {
    show_center_town(20, r.BLOOD);
  	boussole(get_center_commune().xy(),80);
    show_intersection();
  }
  if(display_stroller_is()) {
    show_stroller();
  }


  // 3D
  if(display_surface_is()) show_surface();
  if(display_maison_is()) show_commune();
  // end matrix
  rg.pop();


  // INFO
  if(display_info_is()) {
    show_info();
  }
}



































