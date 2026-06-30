/**
* UTILS
*/



boolean line_on_perimter_is(R_Shape p1, R_Shape p2, R_Line2D line) {
  float marge = 1.5;
  vec2 b = line.barycenter();
  byte res1 = rg.in_polygon(p1, b, marge);
  byte res2 = rg.in_polygon(p2, b, marge);
  if((res1 == -1 && res2 == -1) || (res1 == 1 && res2 == 1) || (res1 == 1 && res2 == 0) || (res1 == 0 && res2 == 1)) {
    rg.circle(b, 20);
    println("INAPTE POUR LE SERVICE [", res1, ",", res2, "]");
    return false;
  }
  return true;
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




boolean check_whether_line_exist(R_Line2D line, ArrayList<R_Line2D> list) {
  for(R_Line2D l : list) {
    if(l.equals(line,false)) return true;
  }
  return false;
}



boolean close(vec2 start, vec2 end) {
  if(start.equals(end)) return true;
  return false;
}