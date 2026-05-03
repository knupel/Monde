import rope.vector.*;
import rope.core.Rope;
import rope.core.R_Graphic;
import rope.mesh.R_Line2D;

Rope r = new Rope();
R_Graphic rg;
Ground ground[];
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
  tectonique(ground);
}


void draw () {
  background(0);
  rg.fill_is(true);
  rg.stroke_is(true);
  vec3 hsb = new vec3(hue(r.BLOOD), saturation(r.BLOOD), brightness(r.BLOOD));

  rg.thickness(diam/2);
  for(int i = 0 ; i < ground.length ; i++) {
    int c = color(hsb.hue(), hsb.sat(), hsb.bri() * ground[i].pos().z());
    rg.stroke(c);
    rg.fill(c);
    rg.point(ground[i].pos());
  }
}


/**
* Create a normal altitude from 0 to 1
 */
void tectonique(Ground ground[]) {
  int points_high = 30;
  int points_low = 30;

  // medium points : : altitude = 0.5
  for(Ground elem : ground) {
    elem.pos.z(0.5);
  }
  // hight points : altitude = 1
  for(int i = 0 ; i < points_high ; i++) {
    int which = floor(random(ground.length));
    ground[which].pos.z(1);
  }
  // low points : altitude = 0
  for(int i = 0 ; i < points_low ; i++) {
    int which = floor(random(ground.length));
    ground[which].pos.z(0);
  }

  // create link altitude between the high and low points
  smooth_altitudes(ground, 40, 0.8);
}

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







