/**
* maisons
* 2026-2026
* v 0.1.0
*/

ArrayList<Maison> maisons = new ArrayList();

void create_maisons(ArrayList<R_Shape> cadastre, R_Plate plate) {
  int surface = 1; // set after with the cadastre
  int max_level = 8;
  int fill_ground = r.TENEBRE;
  int stroke = r.LUNE;
  float thickness = 1;
  vec2 center = get_center_commune().xy(); // je suppose que c'est le centre mais je ne me souviens plus de l'algorithme créer il y a 5 ans

  maisons.clear();
  for(int i = 0 ; i < cadastre.size() ; i++) {
    R_Shape s =  cadastre.get(i);

    surface = (int)s.area();
    vec3 pos = s.barycenter();
    R_Lithos l = plate.get((int)pos.x(), (int)pos.y());
    float altitude = 0;
    if(l != null) altitude = l.altitude().y();
    pos.z(altitude);
    float from_center = r.dist(new vec2(pos.x(),pos.z()),center);
    // from_center est utilisé pour la hauter de la maison, plus on est proche du centre plus elle est haut et grand si j'ai bien compris mon vieil algo
    Maison maison = new Maison(this, surface, from_center, max_level);
    maison.pos(pos);
    int fill_roof = color(random(0,30),random(80,100),random(60,90));
    int fill_wall = color(random(360),random(0,10),random(50,100));
    float peak = random(1);
    peak *= peak;

    maison.angle(s.angle_x());
    maison.set_architecture(new vec2(peak*.5));
    maison.set_aspect(fill_roof,fill_wall,fill_ground,stroke,thickness);
    maisons.add(maison);
  }
}


float dir_x,dir_y;
void show_commune() {
  rg.push();
  rg.translate(SIZE.x()/2, SIZE.y()/2);
  rg.push();
  rg.rotateXYZ(rotate_town);
  rg.translate(-SIZE.x()/2, -SIZE.y()/2);
  show_maisons();
  rg.pop();
  rg.pop();
}




void show_maisons() {
  // float alt = 0;
  for(Maison m : maisons) {
    m.fill_is(use_fill_is());
    m.stroke_is(use_stroke_is());
    m.thickness(1);
    vec3 buf_pos = m.pos().copy();
    float x = buf_pos.x();
    float y = buf_pos.y();
    float z = buf_pos.z(); // altitude
    vec3 pos = new vec3(x,y,z);
    rg.push();
    rg.translate(pos);
    rg.rotateXYZ(rotate_house);
    m.show();
    rg.pop();
  }
}






