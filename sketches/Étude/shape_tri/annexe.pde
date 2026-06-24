// UTILS SHOW
void show_lines(ArrayList<R_Line2D> lines, int thickness, int trans_x, int trans_y) {
  rg.push();
  rg.translate(trans_x,trans_y);
  show_lines(lines, thickness);
  rg.pop();
}

void show_lines(ArrayList<R_Line2D> lines, int thickness) {
  for(int i = 0 ; i < lines.size(); i++) {
    R_Line2D l = lines.get(i);
    // println(l);
    l.fill_is(true);
    l.fill(r.BLACK);
    l.text(i, l.barycenter());
    l.fill_is(false);
    l.thickness(thickness);
    l.stroke_is(true);
    l.show(0);
  }
  rg.stroke_is(false);
}


void show_shape(R_Shape s) {
  s.thickness(0);
  s.stroke_is(false);
  s.fill_is(true);
  s.fill(r.PINK,50);
  s.show();
}



void show_info_line(R_Line2D l) {
  rg.fill_is(false);
  rg.stroke_is(true);
  rg.thickness(1);
  rg.stroke(r.BLOOD);
  rg.fill(r.YELLOW);
  String str = "          dist " + (int)l.dist() + "  coord " + (int)l.a().x() + " / " + (int)l.a().y();
  rg.text(str, l.a());
  rg.circle(l.a(),30);
}


void show_barycenter(ArrayList<R_Line2D> lines, int diam) {
  rg.fill_is(false);
  rg.stroke_is(true);
  rg.fill(r.WHITE);
  rg.stroke(r.PINK);
  rg.thickness(1);
  for(int i = 0 ; i < lines.size() ; i++) {
    vec2 b = lines.get(i).barycenter();
    rg.circle(b, diam);
  }
}