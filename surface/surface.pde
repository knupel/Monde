/**
* Sol
* Copyleft (c) 2019-2019
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
	 size(800,800,P2D);
	 // sol();
	 
}

void draw() {
	background(255);
	println((int)frameRate);


	
	if(mousePressed) {
		offset = map(mouseX,0,width,.1,1);
		angle = map(mouseY,0,height,0,TAU);
	}
	// grid.type_d(width/2,width/2,20,angle);
	// grid.type_c(cols,rows,angle,offset);
	//grid.type_d(cols,rows,angle);
	// grid.type_d(.01,angle);
	// grid.type_d(10,2,angle);
	// grid.type_d(10,20,angle);
	// grid.type_c(width/2,width/2,20,angle,offset);

	// grid.type_b(width/2,width/2,20,offset);
	grid.type_a(width/2,width/2,20);


	float size = width /(float)cols;
	int count = 0;
	int count_show = 0;
	boolean show_is = true;
  

  // float ratio = map(mouseY,0,height,10,height);
  float canvas = height;
  float ratio_cell = height;
	// show_point(ratio);
	// show_text(ratio);
	show_shape(canvas,ratio_cell);

  stroke(r.BLACK);
	rect(mouseX,mouseY,20,20);

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

void show_shape(float ratio_canvas, float ratio_cell) {
  strokeWeight(1);
  stroke(r.BLOOD);
  noFill();
  //fill(r.BLACK);

  float size = grid.get_size() *ratio_cell;
 // float size = grid.get_size() *canvas *abs(sin(frameCount*.01));
  // println(size);
  // float angle = map(mouseX,0,width,0,TAU);
	for(vec4 v : grid.get()) {
		float angle = v.w;
		// costume(vec2(v.copy().mult(canvas)),vec2(10),angle,TRIANGLE_ROPE);  
		// println(v); 

		costume(vec2(v.copy().mult(ratio_canvas)),vec2(size),angle,TRIANGLE_ROPE);   
	}
}











Sol [][] sol;
void sol() {
	sol = new Sol[rows][cols];
	for(int x = 0 ; x < sol.length ; x++) {
		for(int y = 0 ; y < sol[0].length ; y++) {
			sol[x][y]= new Sol(x,y,-1);
		}
	}

}

public class Sol {
	ivec3 coord;
	Sol (int x, int y, int z) {
		this.coord = ivec3(x,y,z);
	}

	void set_altitude(int z) {
		this.coord.z = z;
	}

	ivec3 get_coord() {
		return coord;
	}

	vec2 get_pos() {
		return vec2(coord.x,coord.y);
	}

	int get_alt() {
		return coord.z;
	}
}


































