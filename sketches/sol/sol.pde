import rope.vector.*;
import rope.core.Rope;
import rope.core.R_Graphic;
import rope.mesh.R_Line2D;

Rope r = new Rope();
R_Graphic rg;
// sol
Sol sol[];
int cols = 0;
int rows = 0;
int diam = 4;
// relief
ArrayList<R_Line2D> ridges = new ArrayList<>();
ArrayList<R_Line2D> talwegs = new ArrayList<>();
ArrayList<vec3> tops = new ArrayList<>();
ArrayList<vec3> bottoms = new ArrayList<>();

void setup() {
  rg = new R_Graphic(this);
  colorMode(HSB,360,100,100);
  // fullScreen(P3D);
  println("width ", width, "| height ", height);
  size(1200,1200,P2D);

  set_sol();
  // réglage tectonique
  tectonique(sol, tops, bottoms, ridges, talwegs);
}




void draw () {
  background(0);
  if(display_map_is) {
    rg.fill_is(true);
    rg.stroke_is(true);
    // int colour = r.BLOOD;
    int colour = r.LUNE;
    vec3 hsb = new vec3(hue(colour), saturation(colour), brightness(colour));

    rg.thickness(diam/2);
    for(int i = 0 ; i < sol.length ; i++) {
      int c = color(hsb.hue(), hsb.sat(), hsb.bri() * sol[i].pos().z());
      rg.stroke(c);
      rg.fill(c);
      rg.point(sol[i].pos());
      // rg.plot(ground[i].pos());
    }
  }

  // ligne de crète et talwegs
  if(display_skeleton_is) {
    rg.noFill();
    rg.thickness(2);
    rg.stroke(r.BLOOD);
    show_ridges();
    rg.stroke(r.GOLD);
    show_talwegs();
  }
}

void keyPressed() {
  if(key == 'n') tectonique(sol, tops, bottoms, ridges, talwegs);
  if(key == 'i') display_skeleton();
  if(key == 'm') display_map();
}




/**
* Create a normal altitude from 0 to 1
 */
void tectonique(Sol ground[], ArrayList<vec3> tops, ArrayList<vec3> bottoms, ArrayList<R_Line2D> ridges, ArrayList<R_Line2D> talwegs) {
  int points_high = 50;
  int points_low = 50;
  ridges.clear();
  talwegs.clear();
  tops.clear();
  bottoms.clear();
  // medium points : : altitude = 0.5
  for(Sol elem : ground) {
    elem.pos.z(0.5);
  }
  // créer des lignes de crêtes pour les points hauts et des lignes de talwegs pour les points bas
  create_talwegs(bottoms, talwegs, points_low);
  create_ridges(tops, ridges, points_high);
  clean_talwegs_ridges(talwegs, ridges);
  up_point_on_the_ridge(ground, ridges);
  down_point_on_the_talweg(ground, talwegs);
  level_points_grid(ground, bottoms);
  level_points_grid(ground, tops);

  // lissage final autour du réseau
  smooth_altitudes(ground, 1000,0.9);
  add_noise_altitures(ground, 0.1);
}


















