/**
* maisons
* 2026-2026
* v 0.1.0
*/

ArrayList<Maison> maisons = new ArrayList();

void create_maisons(ArrayList<R_Shape> cadastre) {
    int surface = 1; // set after with the cadastre
    int max_level = 3;
    int fill_ground = r.BLACK;
    int stroke = r.GRAY[4];
    float thickness = 1;
    vec2 center = get_center_commune().xy(); // je suppose que c'est le centre mais je ne me souviens plus de l'algorithme créer il y a 5 ans

    maisons.clear();
    for(int i = 0 ; i < cadastre.size() ; i++) {
        R_Shape s =  cadastre.get(i);

        surface = (int)s.area();
        vec2 pos = s.barycenter().xy();
        float from_center = r.dist(new vec2(pos.x(),pos.z()),center);
        // from_center est utilisé pour la hauter de la maison, plus on est proche du centre plus elle est haut et grand si j'ai bien compris mon vieil algo
        Maison maison = new Maison(this, pos, surface,from_center,max_level);
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
  rg.translate(width/2, height/2);
  rg.push();
  rg.rotateXYZ(rotate_town);
  rg.translate(-width/2, -height/2);
  show_maisons();
  rg.pop();
  rg.pop();
}




void show_maisons() {
    float alt = 0;
    for(Maison m : maisons) {
      m.fill_is(true);
      m.stroke_is(true);
      m.thickness(1);
        vec3 buf_pos = m.pos().copy();
        float x = buf_pos.x();
        float y = buf_pos.y();
        float z = alt;
        // float y = alt;
        // float z = buf_pos.y();
        vec3 pos3D = new vec3(x,y,z);
        rg.push();
        rg.translate(pos3D);
        rg.rotateXYZ(rotate_house);
        m.show();
        rg.pop();
    }
}





























// TEST
R_House house;
void show_maison_1() {
  if(house == null) {
    house = new R_House(this);
  }
  house(house);
}
float rot_x = 0;
float rot_y = 0;
void house(R_House house) {
  house.fill_is(true);
  house.stroke_is(true);
  float min = width/12;
  float max = width *.4;
  
  // house size
  float rx = abs(sin(frameCount *.002));
  float ry = abs(sin(frameCount *.004));
  float rz = abs(sin(frameCount *.006));
  float sx = map(rx,0,1,min,max);
  float sy = map(ry,0,1,min,max);
  float sz = map(rz,0,1,min,max);
  vec3 size = new vec3(sx,sy,sz);
  house.size(size);

  // house peak
  float peak_a = abs(sin(frameCount *.005)) *.5;
  float peak_b = abs(sin(frameCount *.005)) *.5;
  house.set_peak(peak_a,peak_b);

  // house colour roof
   house.fill_wall(r.GRAY[6]);
   house.fill_roof(r.BLOOD);
   house.fill_ground(r.BLACK);
   house.stroke(r.GRAY[2]);
   house.thickness(2);
   house.mode(BOTTOM);

  
  
  pushMatrix();
  translate(width/2,height/2);
  if(mousePressed) {
    rot_y = map(mouseY,0,height,-PI,PI);
    rot_x = map(mouseX,0,width,-PI,PI);
  }
  rotateX(rot_y);
  rotateY(rot_x);
  house.show();
  popMatrix();

}