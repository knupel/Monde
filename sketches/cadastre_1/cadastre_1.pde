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
  draw_shape();
  // show_triangle();
}

void keyPressed() {
  set_map();
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
  // create_cadastre_1(size, offset, roads);
  create_cadastre_2(offset, roads, cadastre_polys);
  println("set_cadastre() cadastre_polys", cadastre_polys.size());
}


void draw_shape() {
  rg.thickness(1);
  rg.stroke_is(true);
  rg.fill_is(true);
  rg.fill(r.GOLD);
  for(R_Shape shape : cadastre_polys) {
    shape.show();
  }
}



void create_cadastre_2(int offset, ArrayList<R_Line2D> lines, ArrayList<R_Shape> cadastre) {
  cadastre.clear();
  float step = 0.1;
  float margin = offset;
  // create lot
  for(R_Line2D line : lines) {
    float abscissa_right = 0;
    float abscissa_left = 0;
    while(abscissa_right < 1) {
      abscissa_right = create_lots(true, abscissa_right, step, margin, line, cadastre);
    }
    while( abscissa_left < 1) {
      abscissa_left = create_lots(false, abscissa_left, step, margin, line, cadastre);
    }
  }
  // remove lot of the road
  remove_lot_crossing_road(lines, cadastre);
  // remove overlapping lots
  check_overlapping_lots(cadastre);
}

void check_overlapping_lots(ArrayList<R_Shape> cadastre) {
  for(R_Shape shape_1 : cadastre) {
      for(R_Shape shape_2 : cadastre) {
        // detect if there is overloapping 

        // cela peut se supperposer 
        // soit partielement : détecté par le croisement des lignes
        // soit supperposition totale et dans ce cas tous les sommets de l'une des formes se situe dans l'aire de l'autre forme
        // soit elle se superpose exactment et dans ce cas le barycentre est le même.


        
        // solution 1 remove the overlap
        // solution 2 join the two overlappings shapes

    }
  }
}

void remove_lot_crossing_road(ArrayList<R_Line2D> roads, ArrayList<R_Shape> cadastre) {
  ArrayList<R_Shape> buf = new ArrayList();
  for(R_Shape shape : cadastre) {
    boolean meet_is = false;
    R_Line2D [] lines = shape.get_lines();
    for(int i = 0 ; i < lines.length ; i++) {
      for(R_Line2D road : roads) {
        if(road.intersection_is(lines[i])) {
          meet_is = true;
          continue;
        }
      }
      if(meet_is) continue;
    }
    if(!meet_is) {
      buf.add(shape);
    }

  }
  cadastre.clear();
  // cadastre = (ArrayList<R_Shape>)buf.clone(); // we cannot use the function clone, else the clone die
  // cadastre =  new ArrayList<R_Shape>(buf); // same that's don't work
  for(R_Shape shape : buf) {
    cadastre.add(shape);
  }
}

float create_lots(boolean side, float abscissa, float step, float margin, R_Line2D line, ArrayList<R_Shape> cadastre) {
  // abscissa += random(step);
  float dir = 1;
  if(side) dir = -1;
  float dist = line.a().dist(line.b());
  float deep = (margin + random(margin, margin *4)) / dist;
  float ordinate = margin / dist;
  // compute point
  vec2 a = line.get_point(abscissa, ordinate *dir);
  vec2 aa = line.get_point(abscissa, deep *dir);
  abscissa += random(step);
  if(abscissa > 1) abscissa = 1;
  vec2 b = line.get_point(abscissa, ordinate *dir);
  vec2 bb = line.get_point(abscissa, deep *dir);
  R_Shape shape = new R_Shape(this);
  shape.add_points(a,b,bb,aa);
  cadastre.add(shape);
  return abscissa;

}
















void create_cadastre_1(int size, int offset, ArrayList<R_Line2D> lines) {
  cadastre_polys.clear();
  for (R_Line2D line : lines) {
    vec2 p1 = line.a();
    vec2 p2 = line.b();
    if (p1 == null || p2 == null) continue;
    float dx = p2.x() - p1.x();
    float dy = p2.y() - p1.y();
    float len = sqrt(dx*dx + dy*dy);
    float value = 0.5;
    if (len < 0.0001) continue;
    float ux = dx / len;
    float uy = dy / len;
    float nx = -uy;
    float ny = ux;
    float mx = (p1.x() + p2.x()) * value;
    float my = (p1.y() + p2.y()) * value;
    float dist_to_center = offset + size * value;
    for (int side = -1; side <= 1; side += 2) {
      float cx = mx + nx * dist_to_center * side;
      float cy = my + ny * dist_to_center * side;
      float hx = ux * size * value;
      float hy = uy * size * value;
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


