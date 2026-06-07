/**
* info
* 2026-2026
* v 0.2.0
* @author Knupel
* https://github.com/knupel
* http://knupel.art
*/

int info_num_houses = 0;
int info_num_roads = 0;
int info_grid_size = 0;
int info_num_fail = 0;
int info_num_carrafour = 0;
int info_num_lot = 0;
int info_fps = 0;
vec2 pos_text = new vec2();

void update_info() {
	info_num_houses = maisons.size();
	info_num_roads = get_roads().size();
	info_num_fail = stroller.get_failure().size();
	info_grid_size = get_grid_Sol().length;
	info_num_lot = get_cadastre().size();
	info_fps = (int)frameRate;
}

void show_info() {
	int marge_left = width / 15;
	int marge_top = height / 15;
	int step = 20;
	pos_text(marge_left, marge_top + step);
	rg.textAlign(LEFT);
	rg.text("Taille: " + SIZE.x() + " x " + SIZE.y(), pos_text(step));
	rg.text("Grille: " + info_grid_size, pos_text(step));
	rg.text("Routes: " + info_num_roads, pos_text(step));
	rg.text("Cadastre nombre de lots: " + info_num_lot, pos_text(step));
	rg.text("Maisons: " + info_num_houses, pos_text(step));
}

void pos_text(int x, int y) {
	pos_text.set(x,y);
}

vec2 pos_text(int step) {
	pos_text.add_y(step);
	return pos_text;
}





void boussole(vec2 pos, int size) {
	ivec2 north = new ivec2(0,-1).mult(size);
	ivec2 south = new ivec2(0,1).mult(size);
	ivec2 west = new ivec2(-1,0).mult(size);
	ivec2 east = new ivec2(1,0).mult(size);
	
	float angle = 0;
	int div = 0;
	for(R_Line2D s : segment_monde) {
		int mult = ceil(s.dist());
		div += mult;
		angle += (s.angle() *mult);
	}
	angle /= div;

	noFill();
	stroke(r.WHITE);
	strokeWeight(1);
	push();
	rg.translate(pos);
	rotate(PI/4+angle);
	rg.line(new vec2(north),new vec2(south));
	rg.line(new vec2(west),new vec2(east));
	pop();
}




void show_center_town(int diam, int colour) {
	rg.fill_is(true);
	rg.stroke_is(false);
	rg.fill(colour);
	rg.stroke(colour);
	if(grid_nodes_monde.size() > 0) {
		rg.ellipse(get_center_commune(),diam);
	}
}

void show_intersection() {
	rg.fill_is(true);
	rg.fill(r.WHITE);
	if(grid_nodes_monde.size() > 0) {
		for(R_Node inter : grid_nodes_monde) {
			textAlign(CENTER);
			rg.text(inter.get_branch(),inter.pos());
		}
	}
}