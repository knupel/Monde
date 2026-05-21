import rope.mesh.R_Line2D;
import rope.vector.vec2;
import rope.core.Rope;
import rope.core.R_Graphic;
import rope.mesh.R_Shape;
import java.util.ArrayList;

Rope r = new Rope();
R_Graphic rg;
vec2 a, b, c;
R_Line2D ab, bc, ca;
ArrayList<R_Line2D> roads = new ArrayList();
ArrayList<R_Shape> cadastre_polys = new ArrayList();



void setup() {
  size(800,800, P2D);
  rg = new R_Graphic(this);
  background(255);
  set_map();
  show_triangle();
}


void draw() {
  background(255);
  drawCadastrePolygons();
  show_triangle();
}

void keyPressed() {
  set_map();
}

void create_cadastre(int size, int offset, ArrayList<R_Line2D> lines) {
  cadastre_polys.clear();
  for (R_Line2D line : lines) {
    vec2 p1 = line.a();
    vec2 p2 = line.b();

    if (p1 == null || p2 == null) continue;
    float dx = p2.x() - p1.x();
    float dy = p2.y() - p1.y();
    float len = sqrt(dx*dx + dy*dy);
    if (len < 0.0001) continue;
    float ux = dx / len;
    float uy = dy / len;
    float nx = -uy;
    float ny = ux;
    float mx = (p1.x() + p2.x()) * 0.5;
    float my = (p1.y() + p2.y()) * 0.5;
    float dist_to_center = offset + size * 0.5;
    for (int side = -1; side <= 1; side += 2) {
      float cx = mx + nx * dist_to_center * side;
      float cy = my + ny * dist_to_center * side;
      float hx = ux * size * 0.5;
      float hy = uy * size * 0.5;
      float sx = -hy;
      float sy = hx;
      vec2[] v = new vec2[4];
      v[0] = new vec2(cx - hx - sx, cy - hy - sy);
      v[1] = new vec2(cx + hx - sx, cy + hy - sy);
      v[2] = new vec2(cx + hx + sx, cy + hy + sy);
      v[3] = new vec2(cx - hx + sx, cy - hy + sy);
      R_Shape shape = new R_Shape(this);
      shape.add_points(v[0],v[1],v[2],v[3]);
      cadastre_polys.add(shape);
    }
  }
}



void show_triangle() {
  ab.show();
  bc.show();
  ca.show();
}

void set_map() {
  set_triangle();
  set_cadastre();
}

void set_triangle() {
  a = new vec2().rand(new vec2(0,0),new vec2(width,height));
  b = new vec2().rand(new vec2(0,0),new vec2(width,height));
  c = new vec2().rand(new vec2(0,0),new vec2(width,height));
  println(a,b,c);
  ab = new R_Line2D(this,a,b);
  bc = new R_Line2D(this,b,c);
  ca = new R_Line2D(this,c,a);
  roads.clear();
  roads.add(ab);
  roads.add(bc);
  roads.add(ca);

}

void set_cadastre() {
  // regenerate cadastre polygons for the current triangle
  int size = 5;
  int offset = 5;
  create_cadastre(size, offset, roads);
}


void drawCadastrePolygons() {
  for(R_Shape shape : cadastre_polys) {
    shape.show();
  }
}
