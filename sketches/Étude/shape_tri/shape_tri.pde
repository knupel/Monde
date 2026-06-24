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


int echec_manuel = 0;



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
  if(key == 'a') a_switch();
  if(key == 'z') z_switch();
  if(key == 'e') e_switch();

  if(key == 'n') {
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

    // show_shapes(union);

  }

  if(key == 'i') {
    println("succes", echec_manuel, " / ", succes, " / ", total);
  }

  if(key == 'e') {
    echec_manuel++;
  }
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

  // println("0", new_lines.size());
  //show_line(new_lto_addines, 1);
  clean_lines(origin, target, new_lines);
  // show_lines(new_lines, 1);
  // println("1", new_lines.size());

  
  // augmenter le range de détection après chaque ronde d'échec complet
  // puis remttre à la valeur de part après un succès.
  int start_index = 0;
  build_new_lines(new_lines, start_index);

  clean_new_lines(origin, target, new_lines);

  // int ox = mouseX;
  // int oy = mouseY;
    int ox = 0;
  int oy = 0;
  show_lines(new_lines, 1, ox, oy);
  show_shape(origin); show_shape(target);
  show_barycenter(new_lines, 5);


  fusion(new_lines, target);

}

/////////////////////////
// SORT
/////////////////////////

void fusion(ArrayList<R_Line2D> lines, R_Shape target) {
  target.clear();
  for(int i = 0 ; i < lines.size(); i++) {
    vec2 p = lines.get(i).a().copy();
    target.add_points(p);
  }
}

void clean_new_lines(R_Shape p1, R_Shape p2, ArrayList<R_Line2D> list) {
  // retirer les lignes qui ne sont pas sur les lignes
  // ça se voir car les barycentres sont soit à l'intérieur des formes soit à l'extérieurs
  int marge = 1;
  for(int i = list.size() -1 ; i > 0 ; i-- ) {
    R_Line2D line = list.get(i);
    vec2 b = line.barycenter();
    byte res1 = rg.in_polygon(p1, b, marge);
    byte res2 = rg.in_polygon(p2, b, marge);
    if((res1 == -1 && res2 == -1) || (res1 == 1 && res2 == 1)) {
    // if(!rg.in_polygon(p1, b) && !rg.in_polygon(p2, b)) {
      rg.circle(b, 20);
      println("mais qu'est-ce tu fous là, dégages de P1", res1, res2);
      list.remove(i);
    }
  }
}


int total = 0;
int succes = 0;

int count_recursion_union_sort = 0;
void build_new_lines(ArrayList<R_Line2D> src, int start_index) {
  // init
  ArrayList<R_Line2D> src_copy = new ArrayList();
  for(R_Line2D line : src) {
    src_copy.add(line.copy());
  }
  
  // start
  float range_detection = 0.1;
  ArrayList<R_Line2D> sort = new ArrayList();
  R_Line2D line = src_copy.get(start_index).copy(); // need to copy to avoid the pointer effect
  src_copy.remove(start_index);
  sort.add(line.copy());
  int max_recursion = src_copy.size() *100;
  count_recursion_union_sort = 0;
  recursive_clean(src_copy, sort, max_recursion, range_detection);
  

  // check
  // boolean fail = false
  if(src_copy.size() == 0) { 
    println(frameCount, "BINGO [", src.size(), sort.size(), start_index, "]");
    total++;
    succes++;
  } else {
    total++;
    start_index++;
    if(start_index < src.size()) {
      if(!chain_close_is(sort)) {
        println(frameCount, " OUVERTE ECHEC [", src.size(), src_copy.size(), sort.size(), start_index, "]");
        build_new_lines(src, start_index);
      } else {
        // succes++;
        println(frameCount, " FERMÉE ECHEC [", src.size(), src_copy.size(), sort.size(), start_index, "]");
        build_new_lines(src, start_index);
      }
    } else {
      println(frameCount, " ÉCHEC TOTAL [", src.size(), src_copy.size(), sort.size(), start_index, "]");
    }
  }


  // the end
  src.clear();
  for(R_Line2D l : sort) {
    src.add(l.copy());
  }
}

boolean chain_close_is(ArrayList<R_Line2D> list) {
  for(int current = 0 ; current < list.size() ; current++) {
    int next = current + 1;
    if(current == list.size() - 1) next = 0;
    R_Line2D line_current = list.get(current);
    R_Line2D line_next = list.get(next);
    vec2 b = line_current.b();
    vec2 a = line_next.a();
    if(!b.equals(a)) return false;
  }
  return true;
}


import rope.utils.R_Pair;
void recursive_clean(ArrayList<R_Line2D> src, ArrayList<R_Line2D> dst, int max, float range) {
  if(src.size() > 0 && count_recursion_union_sort < max) {
    count_recursion_union_sort++;
    for(int i = 0 ; i < src.size() ; i++) {
      R_Line2D tmp_src = src.get(i);
      R_Line2D tmp_dst =  dst.get(dst.size() -1);
     
      R_Pair pair_src = tmp_src.get_pair();
      R_Pair pair_dst = tmp_dst.get_pair();
      vec3 last = (vec3)pair_dst.b();
      vec3 a = (vec3)pair_src.a();
      vec3 b = (vec3)pair_src.b();
      
      if(last.compare(a, range)) {
        R_Line2D new_line = new R_Line2D(this, last, b);
        src.remove(i);
        dst.add(new_line);
        break;
      }
      
      if(last.compare(b, range)) {
        R_Line2D new_line = new R_Line2D(this, last, a);
        src.remove(i);
        dst.add(new_line);
        break;
      }
    }
    recursive_clean(src , dst, max, range +=0.1);
  }
}

boolean check_whether_line_exist(R_Line2D line, ArrayList<R_Line2D> list) {
  for(R_Line2D l : list) {
    if(l.equals(line,false)) return true;
  }
  return false;
}



/////////////////////////
// END SORT
/////////////////////////
boolean close(vec2 start, vec2 end) {
  if(start.equals(end)) return true;
  return false;
}










///////////////////////////////////////////
// START ADD LINES and SPLITED LINES
///////////////////////////////////////////
void clean_lines(R_Shape origin, R_Shape target, ArrayList<R_Line2D> lines) {
  ArrayList<R_Line2D> buf = new ArrayList();
  for(R_Line2D l : lines) {
    vec2 barycenter = l.barycenter();
    boolean is = false;
    if(origin.in_polygon(barycenter, 1)) is = true;
    if(target.in_polygon(barycenter, 1)) is = true;
    if(!is) buf.add(l);
  }
  lines.clear();
  float min_dist = 2.5;
  for(R_Line2D l : buf) {
    // lines.add(l);
    if(l.dist() > min_dist) {
      lines.add(l);
    } else {
      // println("REMOVE", l.dist(), l.a());
      // show_info_line(l);
      // deuxième check
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
































