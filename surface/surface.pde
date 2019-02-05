/**
* Sol
* Copyleft (c) 2019-2019
* Stan le Punk
* https://github.com/StanLepunK
* http://stanlepunk.xyz/
*/

void setup() {
	size(300,300);


}





/**
ROPE - Romanesco processing environment – 
* Copyleft (c) 2014-2019
* Stan le Punk
* https://github.com/StanLepunK
* http://stanlepunk.xyz/
*/





int cols = 10;
int rows = 10;
float offset = .25;
float angle = PI;
Grid2D grid = new Grid2D();
void setup() {
	 size(800,800,P3D);
	 // sol();
}

void draw() {
	background(255);
	
	if(mousePressed) {
		offset = map(mouseX,0,width,.1,1);
		angle = map(mouseY,0,height,0,TAU);
	}
	// grid.type_c(cols,rows,angle,offset);
	//grid.type_d(cols,rows,angle);
	grid.type_d(.03,angle);
	// grid.type_d(10,2,angle);
	// grid.type_d(10,20,angle);


	float size = width /(float)cols /2;
	int count = 0;
	int count_show = 0;
	boolean show_is = true;

	// show_point(width);
	// show_text(width);
	show_shape(width);

}

int [][] sol;
void sol() {
	sol = new Sol[rows][cols];
	for(int x = 0 ; x < sol.lenght ; x++) {
		for(int y = 0 ; y < sol[0].length ; y++) {
			sol[x][y]= new Sol(x,y,-1);
		}
	}

}




void show_text(int canvas) {
	textAlign(CENTER);
	textSize(16);
	fill(r.BLACK);
  int count =0;
	for(vec4 v : grid.get()) {
		text(count++,vec2(v).mult(canvas));  
	}
}


void show_point(int canvas) {
  strokeWeight(10);
  stroke(r.BLOOD);
  noFill();
	for(vec4 v : grid.get()) {
		point(vec2(v.copy().mult(canvas)));   
	}
}

void show_shape(int canvas) {
  strokeWeight(5);
  stroke(r.BLOOD);
  fill(r.BLACK);
  float size = grid.get_size() *canvas *abs(sin(frameCount*.01));
  // println(size);
	for(vec4 v : grid.get()) {
		float angle = v.w;
		// costume(vec2(v.copy().mult(canvas)),vec2(10),angle,TRIANGLE_ROPE);  
		// println(v); 

		costume(vec2(v.copy().mult(canvas)),vec2(size),angle,TRIANGLE_ROPE);   
	}
}






public class Sol {
	ivec3 coord;
	Sol (int x, int y, int z) {
		this.coord = ivec2(x,y,z);
	}

	void set_altitude(int z) {
		this.coord.z = z;
	}

	vec3 get_coord() {
		return coord;
	}

	vec2 get_pos() {
		return vec2(coord.x,coord.y);
	}

	int get_alt() {
		return coord.z;
	}
}


































