/**
* Carte
* v 0.7.0
* Copyleft (c) 2019-2026
* @author Knupel
* @see https://github.com/knupel/Monde
* build with Processing 4
*/
/**
french guide
boussole : compass
carte : map
*/
import rope.mesh.R_Node;
import rope.mesh.R_Line2D;

ArrayList<R_Node> grid_nodes_monde;
ArrayList<R_Line2D> segment_monde;
Urbanist urbanist;
float speed;
int inter_id;
void init_street_map() {
	// init data if nececary
	if( grid_nodes_monde == null) {
		grid_nodes_monde = new ArrayList<R_Node>();
	}

	if(segment_monde == null) {
		segment_monde = new ArrayList<R_Line2D>();
	}

	// reset data
	grid_nodes_monde.clear();
	segment_monde.clear();
	inter_id = 0;
  
	// set data
	int marge = width/10;
	vec3 start_pos = new vec3(random(marge,width -marge),random(marge,height -marge),0);
	int range_start = 30;
	vec3 destination = new vec3(start_pos.x+random(-range_start,range_start),start_pos.y+random(-range_start,range_start),0);
	urbanist = new Urbanist();
	urbanist.set_pos(start_pos);
	urbanist.set_destination(destination);
  
	// angle_tracer = angle(start_pos,destination);
	R_Node inter = new R_Node(start_pos.copy(),destination.copy()); // copy() it's nessacy to don't point on a same Object
	inter.set_branch(8); // the start need a lot of branches
	inter.id_a(inter_id++);

	grid_nodes_monde.add(inter);
	R_Line2D segment = new R_Line2D(this, start_pos,destination.copy());
	segment_monde.add(segment);
	println("new street map",urbanist.get_pos());
}











vec3 buf_follow = new vec3();
void urbanist() {
	float speed = .8;
	int min = 20;
	int max = 200;
	// update
	urbanist.set_pos(follow(urbanist.get_destination(),speed,buf_follow));
	urbanist.set_range(min,max);
	urbanist.set_angle(-PI,PI);
	// show
	show_urbaniste(urbanist.get_pos());
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




void show_center_world() {
	rg.fill_is(true);
	rg.stroke_is(false);
	// rg.thickness(2);
	// rg.stroke(r.YELLOW);
	rg.fill(r.BLOOD);
	rg.stroke(r.BLOOD);
	if(grid_nodes_monde.size() > 0) {
		rg.ellipse(grid_nodes_monde.get(0).pos(),50,50);
	}
}

void show_intersection() {
	rg.fill_is(true);
	rg.fill(r.WHITE);
	if(grid_nodes_monde.size() > 0) {
		for(R_Node inter : grid_nodes_monde) {
			textAlign(CENTER);
			rg.text(inter.id().a(),inter.pos());
			// point(inter.get_pos());
		}
	}
}


void map() {
	vec2 area = new vec2(10);
	vec6 canvas_birth = new vec6(0,0,-width,   width,height,width);
	boolean show_info = true;
	if(r.compare(new vec2(urbanist.get_pos()),new vec2(urbanist.get_destination()),area)) {
		vec2 new_destination = goto_next(urbanist,canvas_birth,grid_nodes_monde,segment_monde,show_info);
		// show_urbaniste(new_destination);

		int id_inter = rank_intersection(urbanist,urbanist.get_pos());
		if(id_inter >= 0) {
			R_Node inter = grid_nodes_monde.get(id_inter);
			urbanist.set_destination(new_destination,inter);
		} else {
			urbanist.set_destination(new_destination);
		}

    
    if(!intersection_is()) {
    	boolean cycle_add_is = false;
		cycle_add_is = ask_intersection();
		// check to build segment
		boolean build_anytime_is = false;
		cycle_add_is = add_segment(urbanist,build_anytime_is,show_info);
		if(cycle_add_is) {
			add_intersection();
		} else {
			vec2 back_to_center_pos = new vec2(grid_nodes_monde.get(0).pos());
			urbanist.set_destination(back_to_center_pos);

		}
    }
    intersection_is(false);
	}

	// draw road map
  	rg.stroke_is(true);
	rg.stroke(r.BLOOD);
	rg.fill_is(false);
	rg.thickness(2);

	// show segment
	for(R_Line2D s : segment_monde) {
		rg.line(s.a(),s.b());
	}
	/*
	// SHOW ALL PATH
	beginShape();
	for(int i = 0 ; i < grid_monde.size(); i++) {
		vertex(grid_monde.get(i).get_pos());
	}
	endShape();
	*/
	count_segment_meeting = 0;
	
}



/**
add intersection
*/
boolean ask_intersection() {
	int min_branch = 2;
	int max_branch = 5;
	int num = num_branch_by_intersection(min_branch,max_branch);
  return ask_intersection(urbanist,num);
}


R_Node temp_intersection;
boolean ask_intersection(Urbanist urb, int max_branch) {
	boolean add_is = false;
	temp_intersection = new R_Node(urb.get_destination().copy(),urb.get_from());
	temp_intersection.set_branch(max_branch);
	temp_intersection.id_a(inter_id++);
	add_is = true;
	return add_is;
}

void add_intersection() {
	grid_nodes_monde.add(temp_intersection);
}



boolean add_segment(Urbanist urb, boolean build_anytime, boolean show_info_is) {
	boolean add_is = false;
	boolean from_is = false;
	int id_from = rank_intersection(urb,urb.get_from());
	R_Node inter;

	if(id_from >= 0) {
		inter = grid_nodes_monde.get(id_from);
		if(inter.get_branch_available() > 0) {
			from_is = true;
		}
	}
	
	// info
	if(show_info_is) {
		noStroke();
		fill(r.WHITE);
		rg.ellipse(new vec2(urb.get_from()),20,20);
		rg.ellipse(new vec2(urb.get_destination()),20,20);
	}


	if(build_anytime || from_is) {
		R_Line2D segment = new R_Line2D(this,temp_intersection.pos(),urb.get_from());
		if(segment.dist() <= urb.get_max()) {
			segment_monde.add(segment);
			grid_nodes_monde.get(id_from).add_destination(temp_intersection.pos());
			temp_intersection.add_destination(urb.get_from());
			add_is = true;
		}
	}
	return add_is;
}



int rank_intersection(Urbanist urb, vec target) {
	int rank = -1;
	for(int i = 0 ; i < grid_nodes_monde.size() ; i++) {
		vec3 p = grid_nodes_monde.get(i).pos();
		if(r.compare(new vec2(target),new vec2(p.x,p.y),new vec2(5))) {
			rank = i;
			break;
		}
	}
	return rank;
}


int num_branch_by_intersection(int min, int max) {
	int num = (ceil(map(r.random_next_gaussian(1),-1,1,0,max)));
	if(num == 0 || num == (min-1)) num = min; // we can choic 1 for the future to create a cul-de-sac
	return num;
}
















/**
GOTO NEXT 
v 0.1.1
* is a main method to give the next destination point for urbanist
*/
vec2 goto_next(Urbanist urb, vec6 canvas, ArrayList<R_Node> inter_list, ArrayList<R_Line2D> seg_list, boolean show_info) {
	vec2 pos = compute_pos(urb,canvas,inter_list);
	count_segment_out_canvas = 0;
  
	// check if the new target is close to carrefour, if it is the plotter must go on it
	urb.set_intersection(-1);

	for(int i = 0 ; i < grid_nodes_monde.size() ; i++) {
		vec3 p = grid_nodes_monde.get(i).pos();
		if(r.compare(pos,new vec2(p.x,p.y),new vec2(urb.get_min()))) {
			intersection_is(true);
			pos = new vec2(p.x,p.y);
			urb.set_intersection(i);
			break;
		}
	}
	return pos;
}

int count_segment_meeting = 0;
boolean check_meeting_segment(R_Line2D target_segment, ArrayList<R_Line2D> seg_list, boolean show_info) {
	boolean is = false;
	int max_iter_for_meeting = 100;
	for(R_Line2D s : seg_list) {
  	if(show_info) {
  		strokeWeight(1);
  		stroke(255);
  		noFill();
  		vec2 meet_pos = target_segment.intersection(s);
  		rg.line(target_segment.a(),target_segment.b());
  		if(meet_pos != null) rg.ellipse(meet_pos,30,30);
  	}

  	if(target_segment.intersection_is(s) && count_segment_meeting < max_iter_for_meeting) {
  		count_segment_meeting ++;
  		is = true;
  		break;
  	}
  }
  return is;
}


int count_segment_out_canvas = 0;

vec2 compute_pos(Urbanist urb, vec6 canvas, ArrayList<R_Node> inter_list) {
	float angle = r.random_next_gaussian(3);
	float previous_direction = new vec2(urb.get_pos()).angle(new vec2(urb.get_destination()));
	// float previous_direction = angle(new vec2(urb.get_pos()),new vec2(urb.get_destination()));
	float ratio_center = abs(r.random_next_gaussian(2));
	float dist = map(ratio_center,0,1,urb.get_range().x,urb.get_range().y);
	// new angle
	angle = map(angle,-1,1,urb.get_angle().x,urb.get_angle().y);
	angle += previous_direction;
	// other side direction
	float goto_left = random(1);
	if(goto_left < .5) angle *= -1;
	vec3 canvas_min = new vec3(canvas.x(),canvas.y(),canvas.z());
	vec3 canvas_max = new vec3(canvas.w(),canvas.e(),canvas.f());
	vec2 pos = r.to_cartesian_2D(angle,dist).add(new vec2(urb.get_destination()));
  
  int max_try = 10; // limit for the recursive call
	if(count_segment_out_canvas < max_try && (!r.all(r.greaterThan(pos,new vec2(canvas_min))) || !r.all(r.lessThan(pos, new vec2(canvas_max))))) {
		count_segment_out_canvas++;
		// loop method until is good
		pos = compute_pos(urb,canvas,inter_list); 
	} else if(count_segment_out_canvas >= max_try) {
		// back to starting position in case there is too much recursive call
    pos = new vec2(inter_list.get(0).pos());
	}

  // check for to big length for next destination
	float length_to_go = r.dist(pos,new vec2(urb.get_pos()));
	if(length_to_go >= urb.get_max()) {
		int target = (floor(random(inter_list.size())));
		pos = new vec2(inter_list.get(target).pos());
	}
	
	return pos;
}

boolean intersection_is = false;
boolean intersection_is() {
	return intersection_is;
}

void intersection_is(boolean is) {
	intersection_is = is;
}































































