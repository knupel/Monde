import rope.vector.*;
import rope.core.Rope;
import rope.core.R_Graphic;
import rope.mesh.R_Line2D;

Rope r = new Rope();
R_Graphic rg;
Ground ground[];
ArrayList<R_Line2D> links = new ArrayList();
int cols = 0;
int rows = 0;

int diam = 100;

void setup() {
  rg = new R_Graphic(this);
  // fullScreen(P3D);
  println("width ", width, "| height ", height);
  size(800,600,P3D);

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

  create_link_no_cross(ground, links);
}

void draw () {
  background(0);
  rg.fill_is(true);
  rg.stroke_is(true);
  rg.stroke(r.BLOOD);
  rg.fill(r.BLOOD);
  rg.thickness(diam/4);
  for(int i = 0 ; i < ground.length ; i++) {
    rg.point(ground[i].pos());
  }
 
  // println("links", links.size());
  for(int i = 0 ; i < links.size() ; i++) {
    R_Line2D line = links.get(i);
    line.stroke_is(true);
    line.stroke(r.NANKIN);
    line.thickness(4);
    line.show();
  }
}


void create_link(Ground grid[], ArrayList<R_Line2D> list) {
  list.clear();
  int num_of_lines = 10;
  for(int i = 0 ; i < num_of_lines ; i++) {
    int a = floor(random(grid.length));
    int b = floor(random(grid.length)); // il y a une probabilité que a == b
    float ax = grid[a].pos().x();
    float ay = grid[a].pos().y();
    float bx = grid[b].pos().x();
    float by = grid[b].pos().y();
    R_Line2D line = new R_Line2D(this, ax, ay, bx, by);
    println("line", line);
    list.add(line);
  }

}

void create_link_no_cross(Ground grid[], ArrayList<R_Line2D> list) {
  list.clear();
  int num_of_lines = 10;
  int maxAttempts = num_of_lines * 40;
  int attempts = 0;
  ArrayList<float[]> segments = new ArrayList<float[]>();

  while(list.size() < num_of_lines && attempts < maxAttempts) {
    attempts++;
    int a = floor(random(grid.length));
    int b = floor(random(grid.length));
    if (a == b) continue;

    float ax = grid[a].pos().x();
    float ay = grid[a].pos().y();
    float bx = grid[b].pos().x();
    float by = grid[b].pos().y();

    boolean crosses = false;
    for(int i = 0; i < segments.size(); i++) {
      float[] s = segments.get(i);
      if (segmentsIntersect(ax, ay, bx, by, s[0], s[1], s[2], s[3])) {
        crosses = true;
        break;
      }
    }
    if (crosses) continue;

    R_Line2D line = new R_Line2D(this, ax, ay, bx, by);
    list.add(line);
    segments.add(new float[] { ax, ay, bx, by });
  }

  println("create_link_no_cross: created", list.size(), "lines after", attempts, "attempts");
}

boolean segmentsIntersect(float x1, float y1, float x2, float y2,
                          float x3, float y3, float x4, float y4) {
  if ((x1 == x3 && y1 == y3) || (x1 == x4 && y1 == y4) ||
      (x2 == x3 && y2 == y3) || (x2 == x4 && y2 == y4)) {
    return false;
  }

  int o1 = orientation(x1, y1, x2, y2, x3, y3);
  int o2 = orientation(x1, y1, x2, y2, x4, y4);
  int o3 = orientation(x3, y3, x4, y4, x1, y1);
  int o4 = orientation(x3, y3, x4, y4, x2, y2);

  if (o1 != o2 && o3 != o4) return true;
  if (o1 == 0 && onSegment(x1, y1, x3, y3, x2, y2)) return true;
  if (o2 == 0 && onSegment(x1, y1, x4, y4, x2, y2)) return true;
  if (o3 == 0 && onSegment(x3, y3, x1, y1, x4, y4)) return true;
  if (o4 == 0 && onSegment(x3, y3, x2, y2, x4, y4)) return true;

  return false;
}

int orientation(float ax, float ay, float bx, float by, float cx, float cy) {
  float value = (bx - ax) * (cy - ay) - (by - ay) * (cx - ax);
  if (abs(value) < 0.00001) return 0;
  return (value > 0) ? 1 : 2;
}

boolean onSegment(float ax, float ay, float bx, float by, float cx, float cy) {
  return min(ax, bx) <= cx && cx <= max(ax, bx) &&
         min(ay, by) <= cy && cy <= max(ay, by);
}





