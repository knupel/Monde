class Edge {
  int i, j;
  float d;
  Edge(int i, int j, float d) {
    this.i = i;
    this.j = j;
    this.d = d;
  }
}

class UnionFind {
  int[] parent;
  UnionFind(int n) {
    parent = new int[n];
    for (int i = 0; i < n; i++) parent[i] = i;
  }
  int find(int x) {
    if (parent[x] != x) parent[x] = find(parent[x]);
    return parent[x];
  }
  void union(int x, int y) {
    int px = find(x), py = find(y);
    if (px != py) parent[px] = py;
  }
}