/**
* cadatre 
* 2026-2026
* V 0.2.0
*/


void show_cadastre(ArrayList<R_Shape> cadastre) {
  rg.thickness(1);
  rg.stroke_is(true);
  rg.fill_is(true);
  rg.fill(r.GOLD);
  for(R_Shape shape : cadastre) {
    shape.show();
  }
}


void clear_cadastre(ArrayList<R_Shape> cadastre) {
    cadastre.clear();
}



void create_cadastre(int offset, ArrayList<R_Line2D> lines, ArrayList<R_Shape> cadastre) {
  clear_cadastre(cadastre);
  float step = offset * 0.1;
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
  // Fail and don't work after 5 full day of coding... no more time to work on it.
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












