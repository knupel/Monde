void old_1_create_ridge_and_talweg_network(Ground ground[], ArrayList<R_Line2D> ridges, ArrayList<R_Line2D> talwegs, int min_lines, int max_lines, int min_length, int max_length) {
  ArrayList<Integer> high_indices = new ArrayList<Integer>();
  ArrayList<Integer> low_indices = new ArrayList<Integer>();

  for(int i = 0; i < ground.length; i++) {
    float z = ground[i].pos().z();
    if(z == 1) {
      high_indices.add(i);
    } else if(z == 0) {
      low_indices.add(i);
    }
  }

  int ridge_count = floor(random(min_lines, max_lines + 1));
  int talweg_count = floor(random(min_lines, max_lines + 1));

  for(int i = 0; i < ridge_count; i++) {
    if(high_indices.size() == 0) break;
    int start_index = high_indices.get(floor(random(high_indices.size())));
    old_1_create_line(ground, ridges, start_index, 1, floor(random(min_length, max_length + 1)));
  }

  for(int i = 0; i < talweg_count; i++) {
    if(low_indices.size() == 0) break;
    int start_index = low_indices.get(floor(random(low_indices.size())));
    old_1_create_line(ground, talwegs, start_index, 0, floor(random(min_length, max_length + 1)));
  }
}

void old_1_create_line(Ground ground[], ArrayList<R_Line2D> lines, int start_index, float target_value, int length) {
  // lines.clear();
  int current_index = start_index;
  int previous_index = -1;

  for(int step = 0; step < length; step++) {
    ground[current_index].pos.z(target_value);
    int next_index = old_1_choose_next_line_index(ground, current_index, previous_index, target_value);
    if(next_index == -1) {
      break;
    }
    if(previous_index >= 0 && current_index >= 0) {
      vec3 a = ground[previous_index].pos().copy();
      vec3 b = ground[current_index].pos().copy();
      // println(a,b);
      R_Line2D line = new R_Line2D(this, a, b);
      lines.add(line);
    }
    previous_index = current_index;
    current_index = next_index;
  }
}

int old_1_choose_next_line_index(Ground ground[], int current_index, int previous_index, float target_value) {
  int[] neighbors = old_1_get_neighbor_indices(current_index);
  ArrayList<Integer> candidates = new ArrayList<Integer>();

  for(int i = 0; i < neighbors.length; i++) {
    int neighbor = neighbors[i];
    if(neighbor == -1 || neighbor == previous_index) continue;
    candidates.add(neighbor);
  }

  if(candidates.size() == 0) {
    return -1;
  }

  ArrayList<Integer> unused = new ArrayList<Integer>();
  for(int i = 0; i < candidates.size(); i++) {
    int index = candidates.get(i);
    if(ground[index].pos().z() != target_value) {
      unused.add(index);
    }
  }

  if(unused.size() > 0) {
    candidates = unused;
  }

  return candidates.get(floor(random(candidates.size())));
}

int[] old_1_get_neighbor_indices(int index) {
  int row_width = cols + 1;
  int x = index % row_width;
  int y = index / row_width;
  int[] neighbors = new int[4];

  neighbors[0] = (x > 0) ? index - 1 : -1;
  neighbors[1] = (x < row_width - 1) ? index + 1 : -1;
  neighbors[2] = (y > 0) ? index - row_width : -1;
  neighbors[3] = (y < rows - 1) ? index + row_width : -1;

  return neighbors;
}









// deuxième solution qui ne fonctionne pas

/**
* Création de lignes de crête reliant les sommets par paires
 */
void old_2_create_ridge_network(Ground[] ground, ArrayList<vec3> tops, ArrayList<R_Line2D> ridges, int min_lines, int max_lines, int min_length, int max_length) {
  if(tops.size() < 2) return;
  
  // Convertir tops en indices
  ArrayList<Integer> top_indices = new ArrayList<>();
  for(vec3 top : tops) {
    for(int i = 0; i < ground.length; i++) {
      if(ground[i].pos().equals(top)) {
        top_indices.add(i);
        break;
      }
    }
  }

  ArrayList<Integer> used_segments = new ArrayList<>();
  int current_end = -1; // Pour chaîner les crêtes
  
  int ridge_count = floor(random(min_lines, max_lines + 1));
  for(int r = 0; r < ridge_count && top_indices.size() >= 2; r++) {
    int start_index;
    int end_index;
    
    // Chaînage : réutiliser l'end de la crête précédente avec probabilité 50%
    if(current_end != -1 && random(1) > 0.5) {
      start_index = current_end;
      // Choisir un end différent
      end_index = top_indices.get(floor(random(top_indices.size())));
      while(end_index == start_index) {
        end_index = top_indices.get(floor(random(top_indices.size())));
      }
    } else {
      // Choisir deux sommets aléatoires
      int start_idx = floor(random(top_indices.size()));
      int end_idx = start_idx;
      while(end_idx == start_idx) {
        end_idx = floor(random(top_indices.size()));
      }
      start_index = top_indices.get(start_idx);
      end_index = top_indices.get(end_idx);
    }
    
    // Trouver chemin via BFS
    ArrayList<Integer> path = old_2_bfs_path(ground, start_index, end_index, used_segments);
    
    if(path != null && path.size() > 0) {
      current_end = path.get(path.size() - 1); // Sauvegarder l'end pour chaînage futur
      
      // Ajouter segments
      for(int i = 0; i < path.size() - 1; i++) {
        int p1 = path.get(i);
        int p2 = path.get(i + 1);
        
        float z1 = ground[p1].pos().z();
        ground[p1].pos.z(min(1, z1 + 0.15));
        
        float z2 = ground[p2].pos().z();
        ground[p2].pos.z(min(1, z2 + 0.15));
        
        vec3 a = ground[p1].pos().copy();
        vec3 b = ground[p2].pos().copy();
        R_Line2D line = new R_Line2D(this, a, b);
        ridges.add(line);
        
        int seg = min(p1, p2) * ground.length + max(p1, p2);
        used_segments.add(seg);
      }
    }
  }
}

ArrayList<Integer> old_2_bfs_path(Ground[] ground, int start, int end, ArrayList<Integer> used_segments) {
  ArrayList<Integer> path = new ArrayList<>();
  ArrayList<Integer> queue = new ArrayList<>();
  ArrayList<Integer> visited = new ArrayList<>();
  int[] parent = new int[ground.length];
  
  for(int i = 0; i < ground.length; i++) {
    parent[i] = -1;
  }
  
  queue.add(start);
  visited.add(start);
  int count = 0;
  while(queue.size() > 0) {
    int current = queue.remove(0);
    println("count while", count++);
    if(count > 500) break;
    if(current == end) {
      int node = end;
      while(node != -1) {
        path.add(0, node);
        node = parent[node];
      }
      return path;
    }
    
    int[] neighbors = old_2_get_neighbor_indices(current);
    for(int n : neighbors) {
      if(n == -1) continue;
      
      int seg = min(current, n) * ground.length + max(current, n);
      boolean segment_used = false;
      for(int s : used_segments) {
        if(s == seg) {
          segment_used = true;
          break;
        }
      }
      
      if(!segment_used && !visited.contains(n)) {
        visited.add(n);
        parent[n] = current;
        queue.add(n);
      }
    }
  }
  
  return path;
}

int[] old_2_get_neighbor_indices(int index) {
  int row_width = cols + 1;
  int x = index % row_width;
  int y = index / row_width;
  int[] neighbors = new int[8];

  neighbors[0] = (x > 0) ? index - 1 : -1; // left
  neighbors[1] = (x < row_width - 1) ? index + 1 : -1; // right
  neighbors[2] = (y > 0) ? index - row_width : -1; // up
  neighbors[3] = (y < rows - 1) ? index + row_width : -1; // down
  neighbors[4] = (x > 0 && y > 0) ? index - row_width - 1 : -1; // up-left
  neighbors[5] = (x < row_width - 1 && y > 0) ? index - row_width + 1 : -1; // up-right
  neighbors[6] = (x > 0 && y < rows - 1) ? index + row_width - 1 : -1; // down-left
  neighbors[7] = (x < row_width - 1 && y < rows - 1) ? index + row_width + 1 : -1; // down-right

  return neighbors;
}



/**
* 3eme essai
 */

 void old_3_create_ridge(ArrayList<vec3> tops, ArrayList<R_Line2D> ridges) {
  if (tops.size() < 2) return; // Need at least 2 points

  // Create all possible edges
  ArrayList<Edge> edges = new ArrayList<>();
  for (int i = 0; i < tops.size(); i++) {
    for (int j = i + 1; j < tops.size(); j++) {
      vec3 a = tops.get(i);
      vec3 b = tops.get(j);
      float d = dist(a.x(), a.y(), b.x(), b.y());
      edges.add(new Edge(i, j, d));
    }
  }

  // Sort edges by distance
  edges.sort((e1, e2) -> Float.compare(e1.d, e2.d));

  // Union-Find
  UnionFind uf = new UnionFind(tops.size());

  // Process edges
  for (Edge e : edges) {
    if (uf.find(e.i) != uf.find(e.j)) {
      // Check if adding this edge would cross existing ridges
      R_Line2D candidate = new R_Line2D(this, tops.get(e.i), tops.get(e.j));
      boolean crosses = false;
      for (R_Line2D existing : ridges) {
        if (candidate.intersection_is(existing)) {
          crosses = true;
          break;
        }
      }
      if (!crosses) {
        ridges.add(candidate);
        uf.union(e.i, e.j);
      }
    }
  }
}

// class Edge {
//   int i, j;
//   float d;
//   Edge(int i, int j, float d) {
//     this.i = i;
//     this.j = j;
//     this.d = d;
//   }
// }

// class UnionFind {
//   int[] parent;
//   UnionFind(int n) {
//     parent = new int[n];
//     for (int i = 0; i < n; i++) parent[i] = i;
//   }
//   int find(int x) {
//     if (parent[x] != x) parent[x] = find(parent[x]);
//     return parent[x];
//   }
//   void union(int x, int y) {
//     int px = find(x), py = find(y);
//     if (px != py) parent[px] = py;
//   }
// }


