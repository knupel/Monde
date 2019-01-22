/**
ROPE - Romanesco processing environment – 
* Copyleft (c) 2014-2019
* Stan le Punk
* https://github.com/StanLepunK
* http://stanlepunk.xyz/
*/




/**
* ROAD MAP / ROAD NETWORK implementation
* @see http://martindevans.me/game-development/2015/12/11/Procedural-Generation-For-Dummies-Roads/
* @see http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.85.6659&rep=rep1&type=pdf
* @see https://graphics.ethz.ch/Downloads/Publications/Papers/2001/p_Par01.pdf
*/
ArrayList<Vec2>nodes = new ArrayList<Vec2>();
Vec2 urbanist;
float angle_tracer;
float speed;
Vec2 destination;


void setup() {
  background(0);
  fullScreen(2);
  // size(800,800);
  init_street_map();
}


void draw() {
  background(0);
  map();
  show_urbanist();
  show_center_world();
}

void show_urbanist() {
	stroke(255);
  noFill();
  strokeWeight(10);
  point(urbanist);
}

void show_center_world() {
	strokeWeight(5);
  if(nodes.size() > 0) {
  	ellipse(nodes.get(0),50,50);
  }
}


void keyPressed() {
	if(key == 'n') {
		init_street_map();
	}
}































