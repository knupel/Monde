/**
* Carte
* v 0.7.0
* Copyleft (c) 2019-2026
* @author Knupel
* @see https://github.com/knupel/Monde
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



// Map
void init_map() {
	// init data if nececary
	if(grid_nodes_monde == null) grid_nodes_monde = new ArrayList<R_Node>();
	if(segment_monde == null) segment_monde = new ArrayList<R_Line2D>();

	// reset data
	grid_nodes_monde.clear();
	segment_monde.clear();
	set_id_intersection(0);
  
	// set data
	int marge = width/10;
	vec3 start_pos = new vec3(random(marge,width -marge),random(marge,height -marge),0);
	int range_start = 30;
	vec3 destination = new vec3(start_pos.x+random(-range_start,range_start),start_pos.y+random(-range_start,range_start),0);
	urbanist = new Urbanist();
	urbanist.set_pos(start_pos);
	urbanist.set_destination(destination);
  
	// angle_tracer = angle(start_pos,destination);
	R_Node intersection = new R_Node(start_pos.copy(),destination.copy()); // copy() it's nessacy to don't point on a same Object
	intersection.set_branch(8); // the start need a lot of branches
	intersection.id_a(add_id_intersection());

	grid_nodes_monde.add(intersection);
	R_Line2D segment = new R_Line2D(this, start_pos,destination.copy());
	segment_monde.add(segment);
	println("new street map",urbanist.get_pos());
}






void build_map() {
	vec2 area = new vec2(10);
	int min_by_intersection = 2;
	int max_by_intersection = 5;

	vec6 canvas_birth = new vec6(0,0,-width,   width,height,width);

	boolean show_info = true;
	if(r.compare(new vec2(urbanist.get_pos()), new vec2(urbanist.get_destination()), area)) {
		vec3 new_destination = goto_next(urbanist, canvas_birth, grid_nodes_monde, segment_monde, show_info);
		int id_inter = rank_intersection(urbanist.get_pos());
		if(id_inter >= 0) {
			R_Node inter = grid_nodes_monde.get(id_inter);
			urbanist.set_destination(new_destination,inter);
		} else {
			urbanist.set_destination(new_destination);
		}

    if(!intersection_is()) {
    	boolean cycle_add_is = false;
		cycle_add_is = ask_intersection(min_by_intersection, max_by_intersection);
		// check to build segment
		boolean build_anytime_is = false;
		cycle_add_is = add_segment(urbanist, build_anytime_is);
		if(cycle_add_is) {
			add_intersection(temp_intersection);
		} else {
			vec2 back_to_center_pos = new vec2(grid_nodes_monde.get(0).pos());
			urbanist.set_destination(back_to_center_pos);
		}
    }
    intersection_is(false);
	}
	count_segment_meeting = 0;
}

void close_dead_end(int range_to_link) {
	// the path must be close, it's patch with only one entry or dead end
	// select path with only one entry and make a list
	ArrayList <R_Node> list_dead_end = new ArrayList();
	ArrayList <R_Node> list_crossroad_free = new ArrayList();
	int rank = 0; // set rank to refind the node in thee next step
	for(R_Node node : grid_nodes_monde){
		int entry = node.get_branch() - node.get_branch_available();
		if(entry == 1) {
			list_dead_end.add(node.copy().id_a(rank)); // use copy to avoid the pointer problem affectation
		}
		if(entry > 1) {
			list_crossroad_free.add(node.copy().id_a(rank)); // use copy to avoid the pointer problem affectation
		}
		rank++;
	}
	println("intersection : ", grid_nodes_monde.size());
	println("dead end : ", list_dead_end.size());
	println("crossroad free : ", list_crossroad_free.size());
	// close ead end if it's in the range
	int num_possible_links = 0;
	for(R_Node dead : list_dead_end) {
		for(R_Node cross : list_crossroad_free) {
			float dist = dead.pos().dist(cross.pos());
			if(dist <= range_to_link && dist > 0) {
				num_possible_links++;
				// add segment
				R_Line2D segment = new R_Line2D(this,dead.pos(),cross.pos());
				segment_monde.add(segment);
				// update node
				grid_nodes_monde.get(dead.id().a()).add_destination(cross.pos());
				grid_nodes_monde.get(cross.id().a()).add_destination(dead.pos());
				break; // to don't more links than dead end
			}
		}
	}
	println("dead end link to network : ", num_possible_links);
}

void show_map() {
	// draw road map
  	rg.stroke_is(true);
	rg.stroke(r.BLOOD);
	rg.fill_is(false);
	rg.thickness(2);
	// show segment
	for(R_Line2D s : segment_monde) {
		rg.line(s.a(),s.b());
	}
}	






/**
intersection
*/

int intersection_id;

int get_id_intersection() {
	return intersection_id;
}

int add_id_intersection() {
	return intersection_id++;
}

void set_id_intersection(int id) {
	intersection_id = id;
}

/**
add intersection
*/
boolean ask_intersection(int min_branch, int max_branch) {
	int num = num_branch_by_intersection(min_branch,max_branch);
	return ask_intersection(urbanist,num);
}


R_Node temp_intersection;
boolean ask_intersection(Urbanist urb, int max_branch) {
	boolean add_is = false;

	temp_intersection = new R_Node(urb.get_destination().copy(),urb.get_from());
	temp_intersection.set_branch(max_branch);
	temp_intersection.id_a(add_id_intersection());
	add_is = true;
	return add_is;
}

void add_intersection(R_Node node) {
	grid_nodes_monde.add(node);
}

int num_branch_by_intersection(int min, int max) {
	int num = (ceil(map(r.random_next_gaussian(1),-1,1,0,max)));
	if(num == 0 || num == (min-1)) num = min; // we can choic 1 for the future to create a cul-de-sac
	return num;
}







// segment
boolean add_segment(Urbanist urb, boolean build_anytime) {
	boolean add_is = false;
	boolean from_is = false;
	int id_from = rank_intersection(urb.get_from());
	R_Node inter;

	if(id_from >= 0) {
		inter = grid_nodes_monde.get(id_from);
		if(inter.get_branch_available() > 0) {
			from_is = true;
		}
	}

	if(build_anytime || from_is) {
		R_Line2D segment = new R_Line2D(this,temp_intersection.pos(),urb.get_from());
		if(segment.dist() <= urb.get_dist_max()) {
			segment_monde.add(segment);
			grid_nodes_monde.get(id_from).add_destination(temp_intersection.pos());
			temp_intersection.add_destination(urb.get_from());
			add_is = true;
		}
	}
	return add_is;
}



int rank_intersection(vec target) {
	int rank = -1;
	int area = 5; // detection area
	for(int i = 0 ; i < grid_nodes_monde.size() ; i++) {
		vec3 p = grid_nodes_monde.get(i).pos();
		if(r.compare(target.xy(),p.xy(),new vec2(area))) {
			rank = i;
			break;
		}
	}
	return rank;
}



















































































