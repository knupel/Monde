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
    float thickness = 2;
    vec2 center = new vec2(0); // je suppose que c'est le centre mais je ne me souviens plus de l'algorithme créer il y a 5 ans

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
        maison.set_architecture(new vec2(peak*.5));
        maison.set_aspect(fill_roof,fill_wall,fill_ground,stroke,thickness);
        maisons.add(maison);
    }
    println("nombre de maisons", maisons.size());

}


float dir_x,dir_y;
void show_commune() {
    println("je suis là", frameCount);
    pushMatrix();
  if(mousePressed) { 
    dir_y = map(mouseY,0,height,PI/5,-PI/5);
  }
  rotateX(dir_y);
  translate(width/2,height/2);
  if(mousePressed) {
    dir_x = map(mouseX,0,width,-PI,PI);
  } else {
    dir_x += .005;
  }
  rotateY(dir_x);

  show_maisons();
  popMatrix();
}


void show_maisons() {
    vec3 world = new vec3(3*width,width,3*width);

    // float px = cad.x *world.x();
    // float py = (cad.y *world.y()) -(h.size.z/2);
    // float pz = cad.z *world.z();
    // vec3 pos = new vec3(px,py,pz);
    float alt = 0;
    // where cadastre.add(new vec4(pos.x,altitude,pos.y,id));
    for(Maison m : maisons) {
        vec3 pos = m.pos().copy();
        float x = pos.x() *world.x();
        alt *= pos.z();
        float y = (alt *world.y()) -(m.size.z()/2);
        float z =  pos.y() *world.z();
        vec3 pos3D = new vec3(x,y,z);

        m.show(pos3D);
    }
}