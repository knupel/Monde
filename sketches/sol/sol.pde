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

int diam = 5;

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
    int elements = floor(random(100));
    ground[i].set_elements(elements);
    pos_x++;
  }
  // réglage tectonique
  tectonique(ground, tops, bottoms, ridges, talwegs);
  println("ridges", ridges.size());
  println("talwegs", talwegs.size());
}


void draw () {
  background(0);
  rg.fill_is(true);
  rg.stroke_is(true);
  // int colour = r.BLOOD;
  int colour = r.LUNE;
  vec3 hsb = new vec3(hue(colour), saturation(colour), brightness(colour));

  rg.thickness(diam/2);
  // for(int i = 0 ; i < ground.length ; i++) {
  //   int c = color(hsb.hue(), hsb.sat(), hsb.bri() * ground[i].pos().z());
  //   rg.stroke(c);
  //   rg.fill(c);
  //   rg.point(ground[i].pos());
  // }

  // show tops, bottoms, ridges, talwegs

  rg.noFill();
  rg.thickness(2);
  // rg.fill(r.BLOOD);
  rg.stroke(r.BLOOD);

  // ligne de crète
  int rank = 0;
  for(R_Line2D line : ridges) {
    // if(rank == 0) println("ridge rank", rank, line);
    // rank++;
    line.show();
  }
  rank = 0;
  for(vec3 pos : tops) { 
    rg.ellipse(pos,20);
    rg.textAlign(CENTER);
    // if(rank == 0) println("tops rank", rank, pos);
    // if(rank == 1) println("tops rank", rank, pos);
    rg.text(rank++, pos.x(), pos.y());
  }

  // talwegs
  // for(R_Line2D line : talwegs) {
  //   line.show();
  // }
  // for(vec3 pos : bottoms) {
  //   rg.ellipse(pos,20);
  // }
}

void keyPressed() {
  tectonique(ground, tops, bottoms, ridges, talwegs);
}


/**
* Create a normal altitude from 0 to 1
 */
void tectonique(Ground ground[], ArrayList<vec3> tops, ArrayList<vec3> bottoms, ArrayList<R_Line2D> ridges, ArrayList<R_Line2D> talwegs) {
  int points_high = 20;
  int points_low = 30;
  ridges.clear();
  talwegs.clear();
  tops.clear();
  bottoms.clear();

  // medium points : : altitude = 0.5
  for(Ground elem : ground) {
    elem.pos.z(0.5);
  }


  // low points : altitude = 0
  // for(int i = 0 ; i < points_low ; i++) {
  //   int which = floor(random(ground.length));
  //   ground[which].pos.z(0);
  //   bottoms.add(ground[which].pos().copy());
  // }

  // créer des lignes de crêtes pour les points hauts et des lignes de talwegs pour les points bas
  create_ridge_network(ground, tops, ridges, points_high);

  // lissage final autour du réseau
  smooth_altitudes(ground, 100, 0.9);
}

void create_ridge_network(Ground[] ground, ArrayList<vec3> tops, ArrayList<R_Line2D> ridges, int points_high) {
  create_ridge(tops, ridges, points_high);
}


void create_ridge(ArrayList<vec3> tops, ArrayList<R_Line2D> ridges, int points_high) {
  tops.clear();
  ridges.clear();
  int max_to_next_point = (int)(r.min(height, width) * 0.4);
  vec3 seed = new vec3(random(width), random(height), 1);
  // need to make .copy() along the algorithm to avoid the pointer effect
  tops.add(seed.copy());
  for(int i = 0 ; i < points_high ; i++) {
    vec3 next_top = next_point(seed.copy(), max_to_next_point);
    R_Line2D next_ridge = new R_Line2D(this, seed.copy(), next_top.copy());
    tops.add(next_top);
    // check for crossing line, if that's don't cross we can add the ridge
    if(ridges.size() > 0) {
      boolean crossing_is = false;
      for(R_Line2D previous_ridge : ridges) {
        // need add the seed coordonanate as exception to avoid the intersection on this point, if we don't do that we cannot link the segment
        if(previous_ridge.intersection_is(next_ridge, seed.xy())) {
          crossing_is = true;
          break;
        }
      }
      if(!crossing_is) {
        ridges.add(next_ridge.copy());
      } 
    } else {
      ridges.add(next_ridge.copy());
    }
    seed.set(next_top.copy());
  }
}

vec3 next_point(vec3 origin, int max) {
  float dist = random(max);
  float angle = random(TAU);
  float x = sin(angle);
  float y = cos(angle);
  x = x * dist + origin.x();
  y = y * dist + origin.y();
  return new vec3(x,y,origin.z());
}















/**
* smooth altitude
 */
void smooth_altitudes(Ground ground[], int passes, float convergence) {
  int row_width = cols + 1;
  float[] values = new float[ground.length];
  boolean[] locked = new boolean[ground.length];

  for(int i = 0; i < ground.length; i++) {
    values[i] = ground[i].pos().z();
    locked[i] = values[i] == 1 || values[i] == 0;
  }

  for(int pass = 0; pass < passes; pass++) {
    float[] next = new float[ground.length];

    for(int i = 0; i < ground.length; i++) {
      if(locked[i]) {
        next[i] = values[i];
        continue;
      }

      int x = i % row_width;
      int y = i / row_width;
      float sum = 0;
      int count = 0;

      if(x > 0) {
        sum += values[i - 1];
        count++;
      }
      if(x < row_width - 1) {
        sum += values[i + 1];
        count++;
      }
      if(y > 0) {
        sum += values[i - row_width];
        count++;
      }
      if(y < rows - 1) {
        sum += values[i + row_width];
        count++;
      }

      float neighbor_avg = sum / max(count, 1);
      next[i] = lerp(values[i], neighbor_avg, convergence);
    }

    values = next;
  }

  for(int i = 0; i < ground.length; i++) {
    ground[i].pos.z(values[i]);
  }
}

