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
  }

  // show tops, bottoms, ridges, talwegs

  rg.noFill();
  rg.thickness(2);
  // // ligne de crète
  rg.stroke(r.BLOOD);
  show_ridges();
    rg.stroke(r.GOLD);
    show_talwegs();



}

void keyPressed() {
  tectonique(ground, tops, bottoms, ridges, talwegs);
}


void show_talwegs() {
     // talwegs
  for(R_Line2D line : talwegs) {
    line.show();
  }
  int rank = 0;
  for(vec3 pos : bottoms) { 
    rg.ellipse(pos,20);
    rg.textAlign(CENTER);
    rg.text(rank++, pos.x(), pos.y());
  }
}

void show_ridges() {
  for(R_Line2D line : ridges) {
    line.show();
  }
  int rank = 0;
  for(vec3 pos : tops) { 
    rg.ellipse(pos,20);
    rg.textAlign(CENTER);
    rg.text(rank++, pos.x(), pos.y());
  }
}

/**
* Create a normal altitude from 0 to 1
 */
void tectonique(Ground ground[], ArrayList<vec3> tops, ArrayList<vec3> bottoms, ArrayList<R_Line2D> ridges, ArrayList<R_Line2D> talwegs) {
  int points_high = 30;
  int points_low = 30;
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
  // smooth_altitudes(ground, 100, 0.9);
}

/**
* Create Talwegs and Ridges
 */
void create_ridges(ArrayList<vec3> points, ArrayList<R_Line2D> lines, int num) {
  create_key_points(points, lines, num, 1);
}

void create_talwegs(ArrayList<vec3> points, ArrayList<R_Line2D> lines, int num) {
  create_key_points(points, lines, num, 0);
}

void create_key_points(ArrayList<vec3> points, ArrayList<R_Line2D> lines, int num, float altitude) {
  points.clear();
  lines.clear();
  int max_to_next_point = (int)(r.min(height, width) * 0.4);
  vec3 seed = new vec3(random(width), random(height), altitude);
  // need to make .copy() along the algorithm to avoid the pointer effect
  points.add(seed.copy());
  for(int i = 0 ; i < num ; i++) {
    vec3 next_point = next_point(seed.copy(), max_to_next_point);
    R_Line2D next_line = new R_Line2D(this, seed.copy(), next_point.copy());
    points.add(next_point);
    // check for crossing line, if that's don't cross we can add the ridge
    if(lines.size() > 0) {
      boolean crossing_is = false;
      for(R_Line2D previous_line : lines) {
        // need add the seed coordonanate as exception to avoid the intersection on this point, if we don't do that we cannot link the segment
        if(previous_line.intersection_is(next_line, seed.xy())) {
          crossing_is = true;
          seed.x(random(width));
          seed.y(random(height));
          break;
        }
      }
      if(!crossing_is) {
        lines.add(next_line.copy());
      } 
    } else {
      lines.add(next_line.copy());
    }
    // check if the next top is out of the range
    if(next_point.xy().in_rect(0,0,width,height)) {
      seed.set(next_point.copy());
    } else {
      seed.set(random(width), random(height), altitude);
      points.add(seed.copy());
    }
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
* Clean talwegs and ridges
*/
void clean_talwegs_ridges(ArrayList<R_Line2D> talwegs,  ArrayList<R_Line2D> ridges) {
  for(int i = talwegs.size() -1 ; i >= 0; i--) {
    for(int k = ridges.size() -1 ; k >= 0; k--) {
      // avoid the Array out bounds
      if(i >= talwegs.size() || k >= ridges.size()) {
        continue;
      }
      R_Line2D talweg = talwegs.get(i);
      R_Line2D ridge = ridges.get(k);
      if(ridge.intersection_is(talweg)) {
        float pile_ou_face = random(1);
        if(pile_ou_face > 0.5) {
          talwegs.remove(i);
        } else {
          ridges.remove(k);
        }
      }
    }
  }
}

/**
*
 */


void up_point_on_the_ridge(Ground grid[], ArrayList<R_Line2D> lines) {
  level_lines_grid(grid, lines, 1);
}
void down_point_on_the_talweg(Ground grid[], ArrayList<R_Line2D> lines){
  level_lines_grid(grid, lines, 0);
}

void level_lines_grid(Ground grid[], ArrayList<R_Line2D> lines, float level) {
  int count = 0;
  for(Ground elem : grid) {
    for(R_Line2D line : lines) {
      count++;
      if(count > 200 && count < 300) {
        println("count", count);
        println("line", line);
        println("elem pos", elem.pos());
      }
      if(line.meet_is(elem.pos())) {
        if(count == 200) println("je suis là");
        elem.pos().z(level);
      }
    }

  }
  println("count", count);

}


// // Essayer ça demain matin :

// double EPSILON = 1e-9;

// boolean point_segment_is(R_Line2D line, vec p) {
//   return between_is(line.a(), line.b(), p, EPSILON);
// }

// boolean between_is(vec a, vec b, vec p, double epsilon) {
//   // Edge case: If a and b are the same point, p must equal a (or b)
//   if (same_point_is(a, b, epsilon)) {
//     return same_point_is(a, p, epsilon);
//   }

//   // Step 1: Check collinearity
//   boolean collinear = collinear_is(a, b, p, epsilon);
//   if (!collinear) return false;

//   // Step 2: Check bounding box
//   return inside_is(a, b, p, epsilon);
// }
    

// boolean same_point_is(vec a, vec b, double epsilon) {
//   return Math.abs(a.x() - b.x()) < epsilon && Math.abs(a.y() - b.y()) < epsilon;
// }

// boolean collinear_is(vec a, vec b, vec p, double epsilon) {
//   double crossProduct = (b.x() - a.x()) * (p.y() - a.y()) - 
//                         (b.y() - a.y()) * (p.x() - a.x());
//   return Math.abs(crossProduct) < epsilon;
// }

// boolean inside_is(vec a, vec b, vec p, double epsilon) {
//   double minX = Math.min(a.x(), b.x());
//   double maxX = Math.max(a.x(), b.x());
//   double minY = Math.min(a.y(), b.y());
//   double maxY = Math.max(a.y(), b.y());
//   return  (p.x() >= minX - epsilon && p.x() <= maxX + epsilon) && 
//           (p.y() >= minY - epsilon && p.y() <= maxY + epsilon);
// }










// // old segment is
// boolean old_point_segment_is(R_Line2D line, vec2 p) {
//     vec2 a = line.a().copy();
//     vec2 b = line.b().copy();
//     // Check if C is between A and B
//     return (p.x() <= Math.max(a.x(), b.x()) && p.x() >= Math.min(a.x(), b.x()) &&
//             p.y() <= Math.max(a.y(), b.y()) && p.y() >= Math.min(a.y(), b.y()) &&
//             (b.x() - a.x()) * (p.y() - a.y()) == (p.x() - a.x()) * (b.y() - a.y()));
// }







/**
* smooth altitude
 */
void smooth_altitudes(Ground grid[], int passes, float convergence) {
  int row_width = cols + 1;
  float[] values = new float[grid.length];
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

  for(int i = 0; i < grid.length; i++) {
    grid[i].pos.z(values[i]);
  }
}

