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
    int id = (int)random(Integer.MAX_VALUE);
    shape.id_a(id);
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
    int index = s.id().b();
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
            if(sa.id().b() == Integer.MIN_VALUE && sb.id().b() == Integer.MIN_VALUE) sa.id_b(id);
            if(sb.id().b() != Integer.MIN_VALUE) {
              sa.id_b(sb.id().b());
              id = sa.id().b()+1;
            }     
            end.add(sa);
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
    else if(s.id().b()== 1) rg.fill(r.PURPLE);
    else if(s.id().b()== 2) rg.fill(r.OUTREMER);
    else if(s.id().b()== 3) rg.fill(r.PISTACHE);
    else if(s.id().b()== 4) rg.fill(r.CANARD);
    else if(s.id().b()== 5) rg.fill(r.CORAIL);
    else if(s.id().b()== 6) rg.fill(r.MAUVE);
    else if(s.id().b()== 7) rg.fill(r.AUBERGINE);
    else if(s.id().b()== Integer.MAX_VALUE) rg.fill(r.BLOOD);
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
}

void union_shape(R_Shape origin, R_Shape target) {
  ArrayList<R_Shape> shapes = new ArrayList();
  shapes.add(origin);
  shapes.add(target);
  // cas de départ
  if(target.length() == 0) {
    target.add_points(origin.get_points());
    target.id(origin.id());
    return;
  }
  ////////////////////////
  // netoyage des points inutiles, ceux qui sont à l'intérieurs des formes
  ArrayList<R_Line2D> new_lines = new ArrayList();
  R_Line2D [] arr_ln_origin = origin.get_lines();
  R_Line2D [] arr_ln_target = target.get_lines();

  add_keys(arr_ln_origin, arr_ln_target);

  add_cut_lines(arr_ln_origin, new_lines);
  add_cut_lines(arr_ln_target, new_lines);


  show_line(new_lines, 1);
  clean_lines(origin, target, new_lines);
  show_line(new_lines, 4);

  sort_lines(new_lines);

  // ArrayList<vec2> res = new ArrayList();

  // println("new points", res.size());
  // for(vec2 v : res) {
  //   println(v);
  // }
}

/////////////////////////
// SORT
/////////////////////////

R_Line2D [] sort_lines(ArrayList<R_Line2D> lines_src) {
  ArrayList<R_Line2D> sort = new ArrayList();
  R_Line2D line = lines_src.get(0);
  sort.add(line.copy());
  
  // int index = 1;
  // int index_sort = 0;

  // println("0 je suis là");
  //r.print_array(lines_src);
  int len = sort.size();
  int max_iter = lines_src.size() *10;
  int iter = 0;
  while(sort.size() < lines_src.size() && iter < max_iter) {
    if(sort.size() != len) {
      len = sort.size();
      line = sort.get(len -1);
    }
    iter++;
    // println("iter", iter);
    for(int i = 1 ; i < lines_src.size() ; i++) {
      vec2 a = line.a().copy();
      vec2 b = line.b().copy();
      R_Line2D test = lines_src.get(i);
      if(!line.equals(test,false)) {
        float marge = 0.2;
        if(a.compare(test.a(), marge)) {
          sort.add(test.copy());
          break;
        }
        if(a.compare(test.b(), marge)) {
          sort.add(test.copy());
          break;
        }
        if(b.compare(test.a(), marge)) {
          sort.add(test.copy());
          break;
        }
        if(b.compare(test.b(), marge)) {
          sort.add(test.copy());
          break;
        }
      }
      
    }
  }



  if(sort.size() == lines_src.size()) {
    println("BINGO");
  } else {
    println("ÉCHEC");
    println("src len", lines_src.size());
    r.print_array(lines_src);
    println("sort len", sort.size());
    r.print_array(sort);
  }
  // println("1 je suis là");


  // while(sort.size() == lines_src.size() || iter < max_iter) {
  //   iter += index;
  //   index = 1;
  //   // il faudrait optimiser pour retirer les éléments trouvés de la liste.
  //   for( ; index < lines_src.size() ; index++) {
  //     R_Line2D l1 = sort.get(index_sort);
  //     R_Line2D l2 = lines_src.get(index).copy();
  //     if(l1.a().equals(l2.a())) {
  //       println("Bingo AA", l1.a(), l2.a(), index);
  //       index_sort++;
  //       sort.add(l2);
  //       break;
  //     }

  //     if(l1.a().equals(l2.b())) {
  //       println("Bingo AB", l1.a(), l2.b());
  //       index_sort++;
  //       sort.add(l2);
  //       break;
  //     }
      
  //     index++;
  //   }
  // }
  // println("frameCount", frameCount, "src", lines_src.size(), "sort", sort.size());
  R_Line2D [] buf = new R_Line2D[sort.size()];
  return sort.toArray(buf);
}

/////////////////////////
// END SORT
/////////////////////////










///////////////////////////////////////////
// START ADD LINES and SPLITED LINES
///////////////////////////////////////////
void clean_lines(R_Shape origin, R_Shape target, ArrayList<R_Line2D> lines) {
  ArrayList<R_Line2D> buf = new ArrayList();
  for(R_Line2D l : lines) {
    vec2 barycenter = l.barycenter();
    boolean is = false;
    if(origin.in_polygon(barycenter, 2)) is = true;
    if(target.in_polygon(barycenter, 2)) is = true;
    if(!is) buf.add(l);
  }
  lines.clear();
  for(R_Line2D l : buf) {
    lines.add(l);
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
      l2.id_b(get_color(index));
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






























// UTILS SHOW
void show_line(ArrayList<R_Line2D> lines, int thickness) {
    for(R_Line2D l : lines) {
    l.thickness(thickness);
    l.stroke_is(true);
    l.show(0);
  }
  rg.stroke_is(false);
}







// OLD


// boolean meet_is(R_Line2D ln, R_Shape shape) {
//   R_Line2D [] arr = shape.get_lines();
//   for(R_Line2D line : arr) {
//     if(line.intersection_is(ln, ln.a(), ln.b())) return true;
//   }
//   return false;
// }



void sort_lines_old(ArrayList<R_Line2D> lines_src, ArrayList<vec2> res, int id) {
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
  sort_lines_old(lines_src, res, id);
}