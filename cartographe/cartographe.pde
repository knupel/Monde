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


PImage img ;
void setup() {
  background(0);
  fullScreen(P2D,2);
  // size(1300,800);
  init_street_map();
  img = loadImage("petit_vinci_la_dame_à_l_hermine.jpg");
  //surface.setSize(img.width,img.height);
}


void draw() {

  
  background(0);
  map();
  urbanist();
  if(show_info_is) {
  	show_center_world();
  	boussole(Vec2(grid_nodes_monde.get(0).get_pos()),80);
    show_intersection();
  }
}



boolean show_info_is = true;
void keyPressed() {
	if(key == 'n') {
		init_street_map();
	}

  if(key == ' '){
    freeze();
  }

	if(key == 'i') {
		if(show_info_is) {
			show_info_is = false;
		} else {
			show_info_is = true;
		}
	}

}































