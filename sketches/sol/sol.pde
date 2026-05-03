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
  for(R_Line2D line : ridges) {
    line.show();
  }
  for(vec3 pos : tops) {
    rg.ellipse(pos,20);
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
  int points_high = 100;
  int points_low = 30;
  ridges.clear();
  talwegs.clear();
  tops.clear();
  bottoms.clear();

  // medium points : : altitude = 0.5
  for(Ground elem : ground) {
    elem.pos.z(0.5);
  }
  // hight points : altitude = 1
  for(int i = 0 ; i < points_high ; i++) {
    int which = floor(random(ground.length));
    ground[which].pos.z(1);
    tops.add(ground[which].pos().copy());
  }
  // low points : altitude = 0
  for(int i = 0 ; i < points_low ; i++) {
    int which = floor(random(ground.length));
    ground[which].pos.z(0);
    bottoms.add(ground[which].pos().copy());
  }

  // créer des lignes de crêtes pour les points hauts et des lignes de talwegs pour les points bas
  create_ridge_network(ground, tops, ridges);

  // lissage final autour du réseau
  smooth_altitudes(ground, 100, 0.9);
}

void create_ridge_network(Ground[] ground, ArrayList<vec3> tops, ArrayList<R_Line2D> ridges) {
  create_ridge(tops, ridges);
}


void create_ridge(ArrayList<vec3> tops, ArrayList<R_Line2D> ridges) {
  if (tops.size() < 2) return; // Need at least 2 points

  // Create all possible edges
  ArrayList<Edge> edges = new ArrayList<>();
  for (int i = 0; i < tops.size(); i++) {
    for (int j = i + 1; j < tops.size(); j++) {
      vec3 a = tops.get(i);
      vec3 b = tops.get(j);
      float dist = a.dist(b);
      edges.add(new Edge(i, j, dist));
    }
  }

  // Sort edges by distance
  edges.sort((e1, e2) -> Float.compare(e1.d, e2.d));

  // Union-Find
  // UnionFind uf = new UnionFind(tops.size());

  // Process edges
  println("tops size", tops.size());
  println("edge size", edges.size());
  for (Edge e : edges) {
      // Check if adding this edge would cross existing ridges
      R_Line2D candidate = new R_Line2D(this, tops.get(e.i), tops.get(e.j));
      boolean crosses = false;
      for (R_Line2D existing : ridges) {
        if (candidate.intersection_is(existing)) {
          crosses = true;
          break;
        }
      }
      if (!crosses) {
        ridges.add(candidate);

      }

  }
  // for (Edge e : edges) {
  //   if (uf.find(e.i) != uf.find(e.j)) {
  //     // Check if adding this edge would cross existing ridges
  //     R_Line2D candidate = new R_Line2D(this, tops.get(e.i), tops.get(e.j));
  //     boolean crosses = false;
  //     for (R_Line2D existing : ridges) {
  //       if (candidate.intersection_is(existing)) {
  //         crosses = true;
  //         break;
  //       }
  //     }
  //     if (!crosses) {
  //       ridges.add(candidate);
  //       uf.union(e.i, e.j);
  //     }
  //   }
  // }
}

class Edge {
  int i, j;
  float d;
  Edge(int i, int j, float d) {
    this.i = i;
    this.j = j;
    this.d = d;
  }
}

class UnionFind {
  int[] parent;
  UnionFind(int n) {
    parent = new int[n];
    for (int i = 0; i < n; i++) parent[i] = i;
  }
  int find(int x) {
    if (parent[x] != x) parent[x] = find(parent[x]);
    return parent[x];
  }
  void union(int x, int y) {
    int px = find(x), py = find(y);
    if (px != py) parent[px] = py;
  }
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

