import java.util.*;


import rope.core.Rope;
import rope.core.R_Graphic;

import rope.mesh.R_Shape;
import rope.vector.vec2;
import rope.vector.vec3;
import rope.mesh.R_Line2D;

ArrayList<R_Shape> raw_list = new ArrayList();
ArrayList<R_Shape> final_list = new ArrayList();
Rope r = new Rope();
R_Graphic rg;

void setup() {
  size(600,600);
  rg = new R_Graphic(this);
  create_shapes(raw_list);
  clear_shapes(raw_list, final_list);
}

void draw() {
  background(255);
  rg.fill_is(true);
  rg.fill(r.GOLD);
  show_shapes(raw_list);
  rg.fill(r.BLOOD);
  show_shapes(final_list);
}


void keyPressed() {
  create_shapes(raw_list);
  clear_shapes(raw_list, final_list);

}


void create_shapes(ArrayList<R_Shape> list) {
  list.clear();
  set_shapes(list, new vec2(0), new vec2(width/2, height/2));
  set_shapes(list, new vec2(width/2, height/2), new vec2(width, height));
  set_shapes(list, new vec2(0, height/2), new vec2(width/2, height));
  set_shapes(list, new vec2(width/2, 0), new vec2(width, height/2));
    
}

void set_shapes(ArrayList<R_Shape> list, vec2 min, vec2 max) {
  int num = 3;
  for(int k = 0 ; k < num ; k++) {
    vec2 a = new vec2(random(min.x(), max.x()), random(min.y(), max.y()));
    vec2 b = new vec2(random(min.x(), max.x()), random(min.y(), max.y()));
    vec2 c = new vec2(random(min.x(), max.x()), random(min.y(), max.y()));
    R_Shape shape = new R_Shape(this);
    shape.add_points(a,b,c);
    list.add(shape);
  }
}



// Main function: group overlapping shapes and merge them, add results to end list
void clear_shapes(ArrayList<R_Shape> start, ArrayList<R_Shape> end) {
  end.clear();
  // création de la liste des formes qui se supperposent.
  select_overlaps_shapes(start, end);
  group_overlap_shape(end);
}


void group_overlap_shape(ArrayList<R_Shape> overlaps) {
  int id = 1;
  for(R_Shape sa : overlaps) {
    R_Line2D [] sal = sa.get_lines();
    boolean is = false;
    for(R_Shape sb : overlaps) {
      R_Line2D [] sbl = sb.get_lines();
       for(int i = 0 ; i < sal.length ; i++) {
        for(int k = 0 ; k < sbl.length ; k++) {
          // on ajoute des exceptions pour éciter la superposition des points de jonction des segments des formes
          vec2 a = sal[i].a();
          vec2 b = sal[i].b();
          vec2 c = sbl[k].a();
          vec2 d = sbl[k].b();

        }
      }
    }

  }
  

}

void select_overlaps_shapes(ArrayList<R_Shape> start, ArrayList<R_Shape> end) {
  // un systeme de 4 boucles sera peut-être trop lent ?
  int id = 0;
  for(R_Shape sa : start) {
    R_Line2D [] sal = sa.get_lines();
    boolean is = false;
    for(R_Shape sb : start) { 
      R_Line2D [] sbl = sb.get_lines();
      for(int i = 0 ; i < sal.length ; i++) {
        for(int k = 0 ; k < sbl.length ; k++) {
          // on ajoute des exceptions pour éviter la superposition des points de jonction des segments des formes
          vec2 a = sal[i].a();
          vec2 b = sal[i].b();
          vec2 c = sbl[k].a();
          vec2 d = sbl[k].b();
          if(sal[i].intersection_is(sbl[k], a, b, c, d)) {
            is = true;
            //
            // le résultat de tout ce boulot
            if(sa.id().a() == Integer.MIN_VALUE && sb.id().a() == Integer.MIN_VALUE) sa.id_a(id);
            if(sb.id().a() != Integer.MIN_VALUE) {
              sa.id_a(sb.id().a());
              id++;
            }
            // sa.id_a(0);
            println("id", sa.id().a());
            end.add(sa);
            //
            //
            break;
          }
          if(is) break;
        }
        if(is) break;
      }
      if(is) break;
    }
  }
}


void show_shapes(ArrayList<R_Shape> list) {
  for(R_Shape s : list) {
    s.show();
  }
}
