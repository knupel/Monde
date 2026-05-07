import rope.vector.*;
import rope.core.Rope;
import rope.core.R_Graphic;
import rope.mesh.R_Line2D;

Rope r = new Rope();
R_Graphic rg;
Ground ground[];
ArrayList<R_Line2D> ridges = new ArrayList<>();
ArrayList<R_Line2D> talwegs = new ArrayList<>();
ArrayList<vec3> tops = new ArrayList<>();
ArrayList<vec3> bottoms = new ArrayList<>();

int cols = 0;
int rows = 0;

int diam = 4;

void setup() {
  rg = new R_Graphic(this);
  colorMode(HSB,360,100,100);
  // fullScreen(P3D);
  println("width ", width, "| height ", height);
  size(1200,700,P3D);

  ivec2 step = new ivec2(diam);
  cols = width/step.x() + 1; // un peu bizarre, mais ça permets de faire les bordures
  rows = height/step.y() + 2; // juste bizarre de rajouter 2, mais ça permets de faire les bordures
  int num = cols * rows + rows;
  ground = new Ground[num];
  int pos_x = 0;
  int pos_y = 0;
  boolean first_is = true;
  //
  for(int i = 0 ; i < num ; i++) {
    if(pos_x > cols) {
      first_is = false;
      pos_x = 0;
    }
    if(pos_x == 0 && !first_is) pos_y++;
    ground[i] = new Ground();
    ground[i].pos(pos_x * step.x(), pos_y * step.y(),0);
    ground[i].radius(diam/2);
    int elements = floor(random(100));
    ground[i].set_elements(elements);
    pos_x++;
  }
  // réglage tectonique
  tectonique(ground, tops, bottoms, ridges, talwegs);
  // println("ridges", ridges.size());
  // println("talwegs", talwegs.size());
}


void draw () {
  background(0);
  rg.fill_is(true);
  rg.stroke_is(true);
  // int colour = r.BLOOD;
  int colour = r.LUNE;
  vec3 hsb = new vec3(hue(colour), saturation(colour), brightness(colour));

  rg.thickness(diam/2);
  for(int i = 0 ; i < ground.length ; i++) {
    int c = color(hsb.hue(), hsb.sat(), hsb.bri() * ground[i].pos().z());
    rg.stroke(c);
    rg.fill(c);
    rg.point(ground[i].pos());
    // rg.plot(ground[i].pos());
  }

  // show tops, bottoms, ridges, talwegs

  rg.noFill();
  rg.thickness(2);
  // // ligne de crète
  // rg.stroke(r.BLOOD);
  // show_ridges();
  // rg.stroke(r.GOLD);
  // show_talwegs();
}

void keyPressed() {
  tectonique(ground, tops, bottoms, ridges, talwegs);
}




/**
* Create a normal altitude from 0 to 1
 */
void tectonique(Ground ground[], ArrayList<vec3> tops, ArrayList<vec3> bottoms, ArrayList<R_Line2D> ridges, ArrayList<R_Line2D> talwegs) {
  int points_high = 100;
  int points_low = 100;
  ridges.clear();
  talwegs.clear();
  tops.clear();
  bottoms.clear();

  // medium points : : altitude = 0.5
  for(Ground elem : ground) {
    elem.pos.z(0.5);
  }

  // créer des lignes de crêtes pour les points hauts et des lignes de talwegs pour les points bas
  create_talwegs(bottoms, talwegs, points_low);
  create_ridges(tops, ridges, points_high);
  clean_talwegs_ridges(talwegs, ridges);
  up_point_on_the_ridge(ground, ridges);
  down_point_on_the_talweg(ground, talwegs);



  // lissage final autour du réseau
  smooth_altitudes(ground, 100, 0.9);
}


















