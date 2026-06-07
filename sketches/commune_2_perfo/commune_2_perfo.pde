/**
* Projet MONDEccc
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
ivec2 SIZE = new ivec2(100);


/**
* ROAD MAP / ROAD NETWORK implementation
* @see http://martindevans.me/game-development/2015/12/11/Procedural-Generation-For-Dummies-Roads/
* @see http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.85.6659&rep=rep1&type=pdf
* @see https://graphics.ethz.ch/Downloads/Publications/Papers/2001/p_Par01.pdf
*/

/////////
// SETUP
/////////
void setup() {
  rg = new R_Graphic(this);
  colorMode(HSB,360,100,100);
  println(r.VERSION);
  background(0);
  // fullScreen(P3D,1);
  size(1920,1100, P3D);
  // surface.setResizable(true);
  // fullScreen(P3D,1);
  
  SIZE.set(int(width*1.5), int(height*1.5));
  tectos = new R_Tectos(this, SIZE.x(), SIZE.y());

  init_sol(CELL, ALTITUDE);
  set_sol();
  tectonique(tectos, get_grid_Sol(), NOISE_ALT);
  set_sol_altitude();
  init_stroller();
  init_map(get_stroller());
  set_stroller();
  create_surface(plate,faces);
}
/////////
// DRAW
/////////
void draw() {
  update_info();
  update_gui();
  update_aspect();
  update_move();
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
    ivec3 fill_maison = new ivec3(r.BLOOD, r.BLUE, r.TENEBRE);
    create_maisons(get_cadastre(), plate, fill_maison, r.TENEBRE, 1);
    build_maison(false);
  }

  // show
  if(use_bg_is()) background(r.TENEBRE); 
  else  background(ciel(r.BLOOD)); 
  lights();
  
  // start matrix
  float tx_1 = width/2;
  float ty_1 =  height/2;
  float tx_2 = SIZE.x()*0.5;
  float ty_2 =  SIZE.y()*0.5;
  rg.push();
  rg.translate(tx_1 + translate_world.x(), ty_1 + translate_world.y(), zoom_world);
  rg.rotateXYZ(rotate_world);
  rg.translate(-tx_2, -ty_2);
  // 2D
  if(display_cadastre_is()) show_cadastre(r.GOLD, get_stroke_color(), 1);
  if(display_sol_is()) show_sol(get_grid_Sol(), P3D, r.LUNE, 1); // possible to choice P2D
  if(display_map_is()) show_map(r.GOLD, 1);
  if(display_failure_is()) show_failure();
  
  // INFO 2D
  if(display_dataviz_is()) {
    show_center_town(20, r.BLOOD);
  	boussole(get_center_commune().xy(),80);
    show_intersection();
  }
  if(display_stroller_is()) {
    show_stroller(r.GOLD, get_stroke_color(),1);
  }


  // 3D
  if(display_surface_is()) show_surface(r.GREEN, get_stroke_color(), 0.2);
  //if(display_surface_is()) show_surface(r.BLOOD, get_stroke_color(), 0.2);
  //if(display_surface_is()) show_surface(r.GOLD, get_stroke_color(), 0.2);
  if(display_maison_is()) {
    // these setting make a global color for the town, 
    // very diffrent of the one created in function create_maisons()
    ivec3 fill_maison = new ivec3(r.GOLD, r.BLOOD, r.TENEBRE);
    show_commune(fill_maison, get_stroke_color(), 1);
  }
  // end matrix
  rg.pop();


  // INFO
  if(display_info_is()) {
    show_info();
  }
}





