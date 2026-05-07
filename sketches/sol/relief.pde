void show_talwegs() {
     // talwegs
  for(R_Line2D line : talwegs) {
    line.show();
  }
  int rank = 0;
  for(vec3 pos : bottoms) { 
    rg.ellipse(pos,20);
    rg.textAlign(CENTER);
    rg.text(rank++, pos.x(), pos.y());
  }
}

void show_ridges() {
  for(R_Line2D line : ridges) {
    line.show();
  }
  int rank = 0;
  for(vec3 pos : tops) { 
    rg.ellipse(pos,20);
    rg.textAlign(CENTER);
    rg.text(rank++, pos.x(), pos.y());
  }
}




/**
* Create Talwegs and Ridges
 */


void create_ridges(ArrayList<vec3> points, ArrayList<R_Line2D> lines, int num) {
  create_key_points(points, lines, num, 1);
}

void create_talwegs(ArrayList<vec3> points, ArrayList<R_Line2D> lines, int num) {
  create_key_points(points, lines, num, 0);
}



void create_key_points(ArrayList<vec3> points, ArrayList<R_Line2D> lines, int num, float altitude) {
  points.clear();
  lines.clear();
  int max_to_next_point = (int)(r.min(height, width) * 0.4);
  vec3 seed = new vec3(random(width), random(height), altitude);
  // need to make .copy() along the algorithm to avoid the pointer effect
  points.add(seed.copy());
  for(int i = 0 ; i < num ; i++) {
    vec3 next_point = next_point(seed.copy(), max_to_next_point);
    R_Line2D next_line = new R_Line2D(this, seed.copy(), next_point.copy());
    points.add(next_point);
    // check for crossing line, if that's don't cross we can add the ridge
    if(lines.size() > 0) {
      boolean crossing_is = false;
      for(R_Line2D previous_line : lines) {
        // need add the seed coordonanate as exception to avoid the intersection on this point, if we don't do that we cannot link the segment
        if(previous_line.intersection_is(next_line, seed.xy())) {
          crossing_is = true;
          seed.x(random(width));
          seed.y(random(height));
          break;
        }
      }
      if(!crossing_is) {
        lines.add(next_line.copy());
      } 
    } else {
      lines.add(next_line.copy());
    }
    // check if the next top is out of the range
    if(next_point.xy().in_rect(0,0,width,height)) {
      seed.set(next_point.copy());
    } else {
      seed.set(random(width), random(height), altitude);
      points.add(seed.copy());
    }
  }
}



vec3 next_point(vec3 origin, int max) {
  float dist = random(max);
  float angle = random(TAU);
  float x = sin(angle);
  float y = cos(angle);
  x = x * dist + origin.x();
  y = y * dist + origin.y();
  return new vec3(x,y,origin.z());
}

/**
* Clean talwegs and ridges
*/
void clean_talwegs_ridges(ArrayList<R_Line2D> talwegs,  ArrayList<R_Line2D> ridges) {
  for(int i = talwegs.size() -1 ; i >= 0; i--) {
    for(int k = ridges.size() -1 ; k >= 0; k--) {
      // avoid the Array out bounds
      if(i >= talwegs.size() || k >= ridges.size()) {
        continue;
      }
      R_Line2D talweg = talwegs.get(i);
      R_Line2D ridge = ridges.get(k);
      if(ridge.intersection_is(talweg)) {
        float pile_ou_face = random(1);
        if(pile_ou_face > 0.5) {
          talwegs.remove(i);
        } else {
          ridges.remove(k);
        }
      }
    }
  }
}





/**
* set grid point to follow the ridges and talwegs
 */


void up_point_on_the_ridge(Ground grid[], ArrayList<R_Line2D> lines) {
  level_lines_grid(grid, lines, 1);
}
void down_point_on_the_talweg(Ground grid[], ArrayList<R_Line2D> lines){
  level_lines_grid(grid, lines, 0);
}

void level_lines_grid(Ground grid[], ArrayList<R_Line2D> lines, float level) {
  for(Ground elem : grid) {
    for(R_Line2D line : lines) {
      if(line.meet_is(elem.pos(), elem.radius())) {
        elem.pos.z(level);
        break;
      }
    }

  }
}













/**
* smooth altitude
 */
void smooth_altitudes(Ground grid[], int passes, float convergence) {
  int row_width = cols + 1;
  float[] values = new float[grid.length];
  boolean[] locked = new boolean[ground.length];

  for(int i = 0; i < ground.length; i++) {
    values[i] = ground[i].pos().z();
    locked[i] = values[i] == 1 || values[i] == 0;
  }

  for(int pass = 0; pass < passes; pass++) {
    float[] next = new float[ground.length];

    for(int i = 0; i < ground.length; i++) {
      if(locked[i]) {
        next[i] = values[i];
        continue;
      }

      int x = i % row_width;
      int y = i / row_width;
      float sum = 0;
      int count = 0;

      if(x > 0) {
        sum += values[i - 1];
        count++;
      }
      if(x < row_width - 1) {
        sum += values[i + 1];
        count++;
      }
      if(y > 0) {
        sum += values[i - row_width];
        count++;
      }
      if(y < rows - 1) {
        sum += values[i + row_width];
        count++;
      }

      float neighbor_avg = sum / max(count, 1);
      next[i] = lerp(values[i], neighbor_avg, convergence);
    }

    values = next;
  }

  for(int i = 0; i < grid.length; i++) {
    grid[i].pos.z(values[i]);
  }
}