import rope.vector.*;
import rope.core.Rope;
import rope.core.R_Graphic;
import rope.mesh.R_Line2D;
import rope.geo.R_Lithos;
import rope.geo.R_Tectos;

Rope r = new Rope();
R_Graphic rg;
// sol
R_Lithos sol[];
R_Tectos tectos;

int diam = 4;

void setup() {
  rg = new R_Graphic(this);
  colorMode(HSB,360,100,100);
  // fullScreen(P3D);
  println("width ", width, "| height ", height);
  size(1200,1200,P2D);
  tectos = new R_Tectos(this, width, height);
  set_sol(diam);
  tectonique(tectos, sol);
}




void draw () {
  background(0);
  if(display_sol_is()) {
    show_sol();
  }

  // ligne de crète et talwegs
  if(display_skeleton_is()) {
    rg.noFill();
    rg.thickness(2);
    rg.stroke(r.BLOOD);
    show_ridges(tectos);
    rg.stroke(r.GOLD);
    show_talwegs(tectos);
  }
}




void keyPressed() {
  // if(key == 'n') tectonique(sol, tops, bottoms, ridges, talwegs);
  if(key == 'n') tectonique(tectos, sol);
  if(key == 'i') display_skeleton();
  if(key == 'm') display_sol();
}























