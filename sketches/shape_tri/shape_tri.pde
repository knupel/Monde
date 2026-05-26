import java.util.*;


import rope.core.Rope;
import rope.core.R_Graphic;
import rope.utils.R_Utils.Ru;

import rope.mesh.R_Shape;
import rope.vector.vec2;
import rope.vector.vec3;
import rope.mesh.R_Line2D;

ArrayList<R_Shape> raw_list = new ArrayList();
ArrayList<R_Shape> final_list = new ArrayList();
ArrayList<ArrayList> group = new ArrayList();
ArrayList<R_Shape> union = new ArrayList();
Rope r = new Rope();
R_Graphic rg;

void setup() {
  size(600,600);
  rg = new R_Graphic(this);
  create_shapes(raw_list);
  clear_shapes(raw_list, final_list);
  union_shapes(group, union);
}

void draw() {
  background(255);
  rg.fill_is(true);
  // show_shapes(raw_list);
  // show_shapes(final_list);
  show_group_shapes(group);
  show_shapes(union);
}


void keyPressed() {
  create_shapes(raw_list);
  clear_shapes(raw_list, final_list);
  union_shapes(group, union);

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
  int num = select_overlaps_shapes(start, end);
  // select_overlaps_shapes(start, end);
  group_overlap_shape(group, end, num);
}


void group_overlap_shape(ArrayList<ArrayList> group, ArrayList<R_Shape> overlaps, int num) {
  group.clear();
  for(int i = 0 ; i < num ; i++) {
    ArrayList<R_Shape> shapes = new ArrayList();
    group.add(shapes);
  }

  for(R_Shape s : overlaps) {
    int index = s.id().a();
    group.get(index).add(s);
  }
}

int select_overlaps_shapes(ArrayList<R_Shape> start, ArrayList<R_Shape> end) {
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
              id = sa.id().a()+1;
            }     
            // println("shape id", sa.id().a());
            // println("id", id);
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
  return id;
}

void show_group_shapes(ArrayList<ArrayList> group) {
  for(ArrayList g : group) {
    show_shapes(g);
  }
}


void show_shapes(ArrayList<R_Shape> list) {
  for(R_Shape s : list) {
    if(s.id().a() < 0) rg.fill(r.GOLD);
    else if(s.id().a()== 1) rg.fill(r.PURPLE);
    else if(s.id().a()== 2) rg.fill(r.OUTREMER);
    else if(s.id().a()== 3) rg.fill(r.PISTACHE);
    else if(s.id().a()== 4) rg.fill(r.CANARD);
    else if(s.id().a()== 5) rg.fill(r.CORAIL);
    else if(s.id().a()== 6) rg.fill(r.MAUVE);
    else if(s.id().a()== 7) rg.fill(r.AUBERGINE);
    else if(s.id().a()== Integer.MAX_VALUE) rg.fill(r.BLOOD);
    else rg.fill(r.GRAY[5]);
    s.show();
  }
}

/////////////////////
// UNION SHAPE
/////////////////////




void union_shapes(ArrayList<ArrayList> group, ArrayList<R_Shape> union) {
  union.clear();
  for (ArrayList<R_Shape> shapes : group) {
    R_Shape united_shape = new R_Shape(this);
    united_shape.id_a(Integer.MAX_VALUE);
    for(int i = 0 ; i < shapes.size() ; i++) {
      R_Shape s = shapes.get(i);
      union_shape(s, united_shape);

    }
    
    union.add(united_shape);
  }
  println("union", union.size());
}

void union_shape(R_Shape origin, R_Shape target) {
  ArrayList<R_Shape> shapes = new ArrayList();
  shapes.add(origin);
  shapes.add(target);
  // cas de départ
  if(target.length() == 0) {
    target.add_points(origin.get_points());
    return;
  }
  ///////////////////
  // cas usuel
  ///////////////////
  /////////////////////
  // ajouts des points
  ////////////////////
  // points de la forme 1


  // ArrayList<vec3> pts_origin = new ArrayList();
  // vec3 [] arr_pts = origin.get_points();
  // for(int i = 0 ; i < arr_pts.length ; i++) {
  //   pts_origin.add(arr_pts[i]);
  // }
  // // points de la forme 2
  // ArrayList<vec3> pts_target = new ArrayList();
  // arr_pts = target.get_points();
  // for(int i = 0 ; i < arr_pts.length ; i++) {
  //   pts_target.add(arr_pts[i]);
  // }
  // // points de la forme d'intersections
  // ArrayList<vec2> pts_intersection = new ArrayList();
  // R_Line2D [] arr_ln_origin = origin.get_lines();
  // R_Line2D [] arr_ln_target = target.get_lines();
  // for(R_Line2D ln_o : arr_ln_origin) {
  //   for(R_Line2D ln_t : arr_ln_target) {
  //     vec2 pts = ln_o.intersection(ln_t);
  //     if(pts != null) pts_intersection.add(pts);
  //   }
  // }
  // println("000", pts_origin.size(), pts_target.size(), pts_intersection.size());


  ////////////////////////
  // nettoyage des points
  ///////////////////////
  // netoyage des points inutiles, ceux qui sont à l'intérieurs des formes



  ArrayList<R_Line2D> new_lines = new ArrayList();
  R_Line2D [] arr_ln_origin = origin.get_lines();
  R_Line2D [] arr_ln_target = target.get_lines();
  for(R_Line2D ln_o : arr_ln_origin) {
    for(R_Line2D ln_t : arr_ln_target) {
      vec2 pts = ln_o.intersection(ln_t);
      if(pts == null) {
        new_lines.add(ln_t);
        new_lines.add(ln_o);
      } else {
        // création de 4 nouveaux segments à partir du point d'intersection
        // https://thecodingtrain.com/challenges/145-ray-casting-2d
        // println("pts", pts);
        // println("ln_o.a()", ln_o.a());
        R_Line2D l1 = new R_Line2D(this, pts, ln_o.a().xy());   
        R_Line2D l2 = new R_Line2D(this, pts, ln_o.b().xy());
        R_Line2D l3 = new R_Line2D(this, pts, ln_t.a().xy());
        R_Line2D l4 = new R_Line2D(this, pts, ln_t.b().xy());
        // supression des deux segments intérieurs aux formes
        // test de collision avec les segments de l'autre polygone
        // si il y a colision il faut supprimer
        if(!meet_is(l1, target)) new_lines.add(l1);
        if(!meet_is(l2, target)) new_lines.add(l2);
        if(!meet_is(l3, origin)) new_lines.add(l3);
        if(!meet_is(l4, origin)) new_lines.add(l4);

      }
    }
  }
  // maintenant il faut assembler les segments dans l'ordre pour retrouver l'union polygon
  ArrayList<vec2> new_points = new ArrayList();
  int count = 0;
  int count_equal = 0;
  println("new lines", new_lines.size());
  for(R_Line2D l1 : new_lines) {
      if(count == 0) new_points.add(l1.a());
      for(R_Line2D l2 : new_lines) {
        if(l1 == l2) {
          println("l1", l1);
          println("l2", l2);
          // juste on ne fait rien
          // println("break");
          // continue;
          count_equal++;
        }
        // println("l1.b()", l1.b(), "l2.a()", l2.a());
        if(l1.b().equals(l2.a())) {
          // println("je suis là", l1.b(), l2.a());
          new_points.add(l2.a());
        }
        count++;
      
    }
  }

  // println("new points", new_points.size(), "égalité", count_equal);
  // for(vec2 v : new_points) {
  //   println(v);
  // }
}


boolean meet_is(R_Line2D ln, R_Shape shape) {
  R_Line2D [] arr = shape.get_lines();
  for(R_Line2D line : arr) {
    if(line.intersection_is(ln, ln.a(), ln.b())) return true;
  }
  return false;
}