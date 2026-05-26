j'aurais besoin que la fonction `void union_shape(ArrayList<R_Shape> shapes, R_Shape target)` réunisent la liste de polygones venant `ArrayList<R_Shape> shapes` et qui se supperposent en un seul polygone `R_Shape target.
La surface du nouveau polygone ne doit pas dépasser celles des polygones qui se supperposent.
Cela pourrait se traduite en une union des polygones en un seul.
L'algorithme de Weiler - Atherton pourrait être une bonne inspiration



Marche pas : 

int orientation(vec2 p, vec2 q, vec2 r) {
  float val = (q.y() - p.y()) * (r.x() - q.x()) - (q.x() - p.x()) * (r.y() - q.y());
  if (abs(val) < 0.001) return 0;
  return (val > 0) ? 1 : 2;
}

boolean onSegment(vec2 p, vec2 q, vec2 r) {
  return q.x() <= max(p.x(), r.x()) && q.x() >= min(p.x(), r.x()) &&
         q.y() <= max(p.y(), r.y()) && q.y() >= min(p.y(), r.y());
}

boolean segmentsIntersect(vec2 p1, vec2 q1, vec2 p2, vec2 q2) {
  int o1 = orientation(p1, q1, p2);
  int o2 = orientation(p1, q1, q2);
  int o3 = orientation(p2, q2, p1);
  int o4 = orientation(p2, q2, q1);
  if (o1 != o2 && o3 != o4) return true;
  if (o1 == 0 && onSegment(p1, p2, q1)) return true;
  if (o2 == 0 && onSegment(p1, q2, q1)) return true;
  if (o3 == 0 && onSegment(p2, p1, q2)) return true;
  if (o4 == 0 && onSegment(p2, q1, q2)) return true;
  return false;
}

vec2 intersectionPoint(vec2 p1, vec2 q1, vec2 p2, vec2 q2) {
  float A1 = q1.y() - p1.y();
  float B1 = p1.x() - q1.x();
  float C1 = A1 * p1.x() + B1 * p1.y();
  float A2 = q2.y() - p2.y();
  float B2 = p2.x() - q2.x();
  float C2 = A2 * p2.x() + B2 * p2.y();
  float det = A1 * B2 - A2 * B1;
  if (abs(det) < 0.0001) return null;
  float x = (B2 * C1 - B1 * C2) / det;
  float y = (A1 * C2 - A2 * C1) / det;
  return new vec2(x, y);
}

boolean samePoint(vec2 a, vec2 b) {
  return abs(a.x() - b.x()) < 0.001 && abs(a.y() - b.y()) < 0.001;
}

String pointKey(vec2 p) {
  int ix = round(p.x() * 1000);
  int iy = round(p.y() * 1000);
  return ix + "_" + iy;
}

vec2 midpoint(vec2 a, vec2 b) {
  return new vec2((a.x() + b.x()) * 0.5, (a.y() + b.y()) * 0.5);
}

vec2[] shapeToVec2(R_Shape shape) {
  vec3[] pts = shape.get_ref_points();
  vec2[] arr = new vec2[pts.length];
  for (int i = 0; i < pts.length; i++) {
    arr[i] = new vec2(pts[i].x(), pts[i].y());
  }
  return arr;
}

ArrayList<vec2> sortPointsOnEdge(vec2 a, vec2 b, ArrayList<vec2> points) {
  ArrayList<vec2> sorted = new ArrayList<vec2>();
  sorted.add(a);
  for (vec2 p : points) {
    if (!samePoint(p, a) && !samePoint(p, b) && orientation(a, b, p) == 0 && onSegment(a, p, b)) {
      sorted.add(p);
    }
  }
  sorted.add(b);
  for (int i = 0; i < sorted.size() - 1; i++) {
    for (int j = i + 1; j < sorted.size(); j++) {
      float ti = abs(sorted.get(i).x() - a.x()) + abs(sorted.get(i).y() - a.y());
      float tj = abs(sorted.get(j).x() - a.x()) + abs(sorted.get(j).y() - a.y());
      if (tj < ti) {
        vec2 tmp = sorted.get(i);
        sorted.set(i, sorted.get(j));
        sorted.set(j, tmp);
      }
    }
  }
  return sorted;
}

ArrayList<vec2[]> splitPolygonEdges(vec2[] poly, ArrayList<vec2> cutPoints) {
  ArrayList<vec2[]> segments = new ArrayList<vec2[]>();
  for (int i = 0; i < poly.length; i++) {
    vec2 a = poly[i];
    vec2 b = poly[(i + 1) % poly.length];
    ArrayList<vec2> edgePoints = sortPointsOnEdge(a, b, cutPoints);
    for (int j = 0; j < edgePoints.size() - 1; j++) {
      vec2 p = edgePoints.get(j);
      vec2 q = edgePoints.get(j + 1);
      if (!samePoint(p, q)) {
        segments.add(new vec2[] { p, q });
      }
    }
  }
  return segments;
}

boolean segmentVisible(vec2 a, vec2 b, ArrayList<vec2[]> others) {
  vec2 mid = midpoint(a, b);
  for (vec2[] other : others) {
    if (Ru.in_polygon(other, mid)) {
      return false;
    }
  }
  return true;
}

ArrayList<vec2> orderBoundarySegments(ArrayList<vec2[]> segments) {
  HashMap<String, ArrayList<String>> adjacency = new HashMap<String, ArrayList<String>>();
  HashMap<String, vec2> pointMap = new HashMap<String, vec2>();
  HashSet<String> added = new HashSet<String>();
  for (vec2[] seg : segments) {
    String aKey = pointKey(seg[0]);
    String bKey = pointKey(seg[1]);
    pointMap.put(aKey, seg[0]);
    pointMap.put(bKey, seg[1]);
    adjacency.putIfAbsent(aKey, new ArrayList<String>());
    adjacency.putIfAbsent(bKey, new ArrayList<String>());
    if (!adjacency.get(aKey).contains(bKey)) adjacency.get(aKey).add(bKey);
    if (!adjacency.get(bKey).contains(aKey)) adjacency.get(bKey).add(aKey);
    String key = aKey.compareTo(bKey) < 0 ? aKey + "|" + bKey : bKey + "|" + aKey;
    if (!added.contains(key)) {
      added.add(key);
    }
  }
  if (adjacency.isEmpty()) return new ArrayList<vec2>();
  String startKey = null;
  for (String key : adjacency.keySet()) {
    if (startKey == null) { startKey = key; continue; }
    vec2 cand = pointMap.get(key);
    vec2 best = pointMap.get(startKey);
    if (cand.x() < best.x() || (cand.x() == best.x() && cand.y() < best.y())) {
      startKey = key;
    }
  }
  ArrayList<vec2> result = new ArrayList<vec2>();
  String currentKey = startKey;
  String previousKey = null;
  while (currentKey != null) {
    result.add(pointMap.get(currentKey));
    ArrayList<String> neighbors = adjacency.get(currentKey);
    String nextKey = null;
    if (neighbors != null) {
      for (String neighbor : neighbors) {
        if (!neighbor.equals(previousKey)) {
          nextKey = neighbor;
          break;
        }
      }
    }
    if (nextKey == null || nextKey.equals(startKey)) break;
    previousKey = currentKey;
    currentKey = nextKey;
  }
  return result;
}

void union_shapes(ArrayList<ArrayList> group, ArrayList<R_Shape> union) {
  union.clear();
  for (ArrayList<R_Shape> shapes : group) {
    R_Shape united_shape = new R_Shape(this);
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

  // target.clear();
  if (shapes == null || shapes.size() == 0) return;
  if (shapes.size() == 1) {
    vec3[] pts = shapes.get(0).get_ref_points();
    for (vec3 p : pts) {
      target.add_point(p.x(), p.y());
    }
    return;
  }
  ArrayList<vec2[]> polygons = new ArrayList<vec2[]>();
  for (R_Shape s : shapes) {
    polygons.add(shapeToVec2(s));
  }
  ArrayList<vec2> intersections = new ArrayList<vec2>();
  for (int i = 0; i < polygons.size(); i++) {
    for (int j = i + 1; j < polygons.size(); j++) {
      vec2[] a = polygons.get(i);
      vec2[] b = polygons.get(j);
      for (int ia = 0; ia < a.length; ia++) {
        for (int ib = 0; ib < b.length; ib++) {
          vec2 p1 = a[ia];
          vec2 q1 = a[(ia + 1) % a.length];
          vec2 p2 = b[ib];
          vec2 q2 = b[(ib + 1) % b.length];
          if (segmentsIntersect(p1, q1, p2, q2)) {
            vec2 ip = intersectionPoint(p1, q1, p2, q2);
            if (ip != null) {
              boolean found = false;
              for (vec2 existing : intersections) {
                if (samePoint(existing, ip)) { found = true; break; }
              }
              if (!found) intersections.add(ip);
            }
          }
        }
      }
    }
  }
  ArrayList<vec2[]> boundary = new ArrayList<vec2[]>();
  for (int i = 0; i < polygons.size(); i++) {
    vec2[] poly = polygons.get(i);
    ArrayList<vec2[]> split = splitPolygonEdges(poly, intersections);
    ArrayList<vec2[]> others = new ArrayList<vec2[]>();
    for (int j = 0; j < polygons.size(); j++) {
      if (j != i) others.add(polygons.get(j));
    }
    for (vec2[] seg : split) {
      if (segmentVisible(seg[0], seg[1], others)) {
        boundary.add(seg);
      }
    }
  }
  ArrayList<vec2> loop = orderBoundarySegments(boundary);
  for (vec2 p : loop) {
    target.add_point(p.x(), p.y());
  }
}