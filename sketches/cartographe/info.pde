/**
* info
* 2026-2026
* v 0.0.1
* @author Knupel
* https://github.com/knupel
* http://knupel.art
*/


boolean show_info_is = true;



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
	// rg.thickness(2);
	// rg.stroke(r.YELLOW);
	rg.fill(colour);
	rg.stroke(colour);
	if(grid_nodes_monde.size() > 0) {
		rg.ellipse(grid_nodes_monde.get(0).pos(),diam);
	}
}

void show_intersection() {
	rg.fill_is(true);
	rg.fill(r.WHITE);
	if(grid_nodes_monde.size() > 0) {
		for(R_Node inter : grid_nodes_monde) {
			textAlign(CENTER);
			// String txt = inter.get_branch() + " / " + inter.id().a();
			// rg.text(txt,inter.pos());
			rg.text(inter.get_branch(),inter.pos());
			// rg.text(inter.id().a(),inter.pos());
			// point(inter.get_pos());
		}
	}
}