import java.util.*;


import rope.core.Rope;
import rope.core.R_Graphic;
import rope.utils.R_Utils.Ru;

import rope.mesh.R_Shape;
import rope.vector.vec2;
import rope.vector.vec3;
import rope.mesh.R_Line2D;

ArrayList<R_Shape> start_list = new ArrayList();
ArrayList<R_Shape> end_list = new ArrayList();
ArrayList<ArrayList> group = new ArrayList();
ArrayList<R_Shape> union = new ArrayList();
Rope r = new Rope();
R_Graphic rg;

void setup() {
  size(600,600);
  rg = new R_Graphic(this);
  create_shapes(start_list);
  clear_shapes(start_list, end_list);
  union_shapes(group, union);
  rg.fill_is(true);
  rg.stroke_is(false);
  // show_shapes(end_list);
}

void draw() {
  // background(255);

}


void keyPressed() {
  background(255);
  // display
  rg.fill_is(true);
  rg.stroke_is(false);
  rg.thickness(1);
  // show_shapes(start_list);
  // show_shapes(end_list);
  // show_group_shapes(group);
  // show_shapes(union);

  // create
  create_shapes(start_list);
  clear_shapes(start_list, end_list);
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
  int num = 2;
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
  start.clear();
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


  ////////////////////////
  // nettoyage des points
  ///////////////////////
  // netoyage des points inutiles, ceux qui sont à l'intérieurs des formes
  ArrayList<R_Line2D> new_lines = new ArrayList();
  R_Line2D [] arr_ln_origin = origin.get_lines();
  R_Line2D [] arr_ln_target = target.get_lines();
  // add_full_lines(arr_ln_origin, arr_ln_target , new_lines);
  // add_full_lines(arr_ln_target, arr_ln_origin , new_lines);

  add_keys(arr_ln_origin, arr_ln_target);

  add_cut_lines(arr_ln_origin, new_lines);
  add_cut_lines(arr_ln_target, new_lines);


  ArrayList<vec2> res = new ArrayList();

  for(R_Line2D l : new_lines) {
    l.thickness(4);
    l.stroke_is(true);
    // l.stroke(r.BLACK);
    l.show(0);
  }
  rg.stroke_is(false);
  // while(new_lines.size() > 0) {
  //   sort_lines(new_lines, res, 0);
  // }


  println("new points", res.size());
  for(vec2 v : res) {
    println(v);
  }
}

///////////////////////////////////////////
// START ADD LINES and SPLITED LINES
///////////////////////////////////////////
void add_full_lines(R_Line2D [] src_a, R_Line2D [] src_b , ArrayList<R_Line2D> new_lines) {
  for(R_Line2D  ln_a : src_a) {
    boolean is = false;
    for(R_Line2D ln_b : src_b) {
      if(ln_a.intersection_is(ln_b)) {
        is = true;
      }
    }
    if(!is) {
      ln_a.palette(r.BLOOD);
      new_lines.add(ln_a);
    }
  }
}

void add_keys(R_Line2D [] src_a, R_Line2D [] src_b) {
  // search key point
  for(R_Line2D  ln_a : src_a) {
    for(R_Line2D ln_b : src_b) {
      if(ln_a.intersection_is(ln_b)) {
        vec2 key_point = ln_a.intersection(ln_b);
        ln_a.add_keys(key_point);
        ln_b.add_keys(key_point);
      }
    }
  }
}

void add_cut_lines(R_Line2D [] src_lines, ArrayList<R_Line2D> new_lines) {
  R_Line2D [] l_cut;
  for(R_Line2D  l1 : src_lines) {
    l_cut = l1.cut();
    int index = 0;
    for(R_Line2D l2 : l_cut) {
      println("index", index);
      l2.id_a(get_color(index));
      l2.palette(get_color(index));
      index++;
      new_lines.add(l2);
    }
  }
}

int get_color(int index) {
  switch(index) {
    case 0 : return r.GRAY[5];
    case 1 : return r.BLOOD;
    case 2 : return r.GOLD;
    case 3 : return r.BLUE;
    case 4 : return r.ORANGE;
    case 5 : return r.GREEN;
    case 6 : return r.VERT_DE_GRIS;
    default : return r.GRAY[5];
  }
  
}


///////////////////////////////////////////
// END ADD LINES and SPLITED LINES
///////////////////////////////////////////

void sort_lines(ArrayList<R_Line2D> lines_src, ArrayList<vec2> res, int id) {
  R_Line2D l1 = new R_Line2D(this);
  println("0000 lines_src.size()", lines_src.size());
  for(int i = 0 ; i < lines_src.size() ; i++) {
    R_Line2D l = lines_src.get(i);
   
    if(l.id().a() == id) {
      l1 = l.copy();
      lines_src.remove(i);
      break;
    }
  }
  println("1111 lines_src.size()", lines_src.size(), l1.id().a(), lines_src.get(0).id().a());
  // println("l.id().a()", l1.id().a(), "id", id);
  // println("size lines_src", lines_src.size());
  int index = 0;
  // int id = 0;
  for( ; index < lines_src.size() ; index++) {
    R_Line2D l2 = lines_src.get(index);
    if(l1.id().a() == l2.id().a()) {
      // LE SOUCIS EST LA, c'est ici que ça fait tourner en rond
      // id = l2.id().a();
      println("--- l1.id().a() == l2.id().a()");
      continue;
    }
    // peut-être pas besoin de la ligne ci-dessus normalement elle a été supprimée

    if(l1.b() == l2.a()) {
      id = l2.id().a();
      println("*** l1.b() == l2.a()");
      res.add(l2.a().copy());
      break;
    }
    if(l1.b() == l2.b()) {
      println("/// l1.b() == l2.b()");
      id = l2.id().a();
      res.add(l2.b().copy());
      // besoin d'inverser le segment AB
      vec2 buf = l2.a().copy();
      l2.a(l2.b());
      l2.b(buf.x(), buf.y());
      break;
    }
  }
  sort_lines(lines_src, res, id);
}


boolean meet_is(R_Line2D ln, R_Shape shape) {
  R_Line2D [] arr = shape.get_lines();
  for(R_Line2D line : arr) {
    if(line.intersection_is(ln, ln.a(), ln.b())) return true;
  }
  return false;
}