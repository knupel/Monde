/**
* Class R_Cartographe
* 2026-2026
* v 0.2.0
*/
public class R_Cartographe extends R_Graphic {
	private vec3 pos;
	private vec3 dst;
	private vec3 from;
	// distance
	private vec2 dist;
	private int [] dist_proportion;
	// angle / direction
	private vec2 angle;
	private int [] angle_proportion;
	// intersection
	private ivec2 intersection;
	private int [] intersection_proportion;
	private float speed;
	// exploration
	private int count_segment_meeting = 0;
	private int count_out_canvas = 0;
	private int count_road_gradient = 0;
	private float tilt = 10;
	private int count_no_cross = 0;

	ArrayList<R_Line2D> failures = new ArrayList();
	ArrayList<R_Node> free_nodes = new ArrayList();
	
	public R_Cartographe(PApplet pa) {
		super(pa);
		// the speed walk of the agent on the map
		this.speed = 0.5;
		// position on the map
		this.pos = new vec3();
		this.from = new vec3();
		this.dst = new vec3();
		// intersection / careffour setting
		this.intersection = new ivec2(2,7);
		// must be proportional to the number of branch here 7 - 2 = 5 +1 = 6
		this.intersection_proportion = new int[] {64,32,16,8,4,2}; 
		// distance to go for the next roap
		this.dist = new vec2(0,height);
		this.dist_proportion = new int[] {64,32,16,8,4,2,1};
		// direction to take when a new intersection is create
		this.angle = new vec2(-PI,PI);
		this.angle_proportion = new int[] {1,2,3,4,5,6,7,6,5,4,3,2,1};
	}
  
  	/**
	* distance management
	*/
	public void set_dist_range(float min, float max) {
		this.dist.set(min,max);
	}

	public void set_dist_proportion(int [] arr) {
		this.dist_proportion = arr;
	}

	public float next_distance() {
		float range = abs(this.get_dist_max())-abs(this.get_dist_min());
		float dist = r.random_ratio(range, this.dist_proportion);
		return dist -abs(this.get_dist_min());
	}

	public vec2 get_dist_range() {
		return this.dist;
	}

	public float get_dist_max() {
		return this.dist.y();
	}

	public float get_dist_min() {
		return this.dist.x();
	}






	/**
	* angle and direction management
	*/
	public void set_angle(float start, float end) {
		this.angle.set(start,end);
	}

	public void set_angle_proportion(int [] arr) {
		this.angle_proportion = arr;
	}

	public float next_direction() {
		float range = abs(this.get_angle().x())+abs(this.get_angle().y());
		float angle = r.random_ratio(range, this.angle_proportion);
		return angle;
	}

	public vec2 get_angle() {
		return this.angle;
	}


	/**
	* Intersetion management
	 */

	public float get_ways_min() {
		return this.intersection.x();
	}

	public float get_ways_max() {
		return this.intersection.y();
	}

	public int how_many_ways() {
		float range = abs(this.intersection.x())-abs(this.intersection.y());
		int result = floor(r.random_ratio(range, this.intersection_proportion));
		return result + this.intersection.x();
	}

	public void set_intersection_ways(int [] arr) {
		this.intersection_proportion = arr;
	}


    // pos
	public void set_pos(vec pos) {
		this.pos.set(pos);
	}

	public vec3 get_pos() {
		return this.pos;
	}

	// destination
	public void set_destination(vec dst) {
		set_destination(dst,null);
	}

	public vec3 get_destination() {
		return dst;
	}

	// from
	public vec3 get_from() {
		return this.from;
	}

	// speed
	public void set_speed(float speed) {
		this.speed = speed;
	}

	public float get_speed() {
		return this.speed;
	}


	// tilt road in degree
	public void set_tilt(float tilt) {
		this.tilt = tilt;
	}

	public float get_tilt() {
		return this.tilt;
	}


	public void set_destination(vec dst, R_Node node) {
		// check if there is free slot on this intersection
		if(node == null || node.get_branch_available() > 0) {
			this.from.set(this.dst);
			this.dst.set(dst);
		} else {
			this.from.set(this.dst);
			// select destination in the panel of destination of this node intersection
			int which = floor(random(node.get_branch()));
			if(which < 0) which = 0;
			this.dst.set(node.get_destination()[which]);
		}
	}

	private void free_nodes(ArrayList<R_Node> nodes) {
		free_nodes.clear();
		for(R_Node node : nodes) {
			if(node.get_branch_available() > 0) {
				free_nodes.add(node);
			}
 		}
	}

	// public ArrayList<R_Node> get_free_nodes() {
	// 	return free_nodes;
	// }


	// reset
	public void reset() {
		failures.clear();
	}
  









	////////////////////////
	// the cartographe walk
	////////////////////////

	// global variable of the few functions below


	public vec3 goto_next(R_Plate plate, vec6 canvas, ArrayList<R_Node> nodes, ArrayList<R_Line2D> segments) {
		vec2 next_pos = compute_pos_2D(plate, canvas, nodes, segments);
		count_out_canvas = 0;
		count_no_cross = 0;
		count_road_gradient = 0;

		// checking the plan 2D
		// if the new target is close to carrefour, if it is the plotter must go on it
		for(int i = 0 ; i < nodes.size() ; i++) {
			vec3 p = nodes.get(i).pos();
			if(compare(next_pos,new vec2(p.x(),p.y()),new vec2(get_dist_min()))) {
				intersection_is(true);
				next_pos = new vec2(p.x(),p.y());
				break;
			}
		}
		return new vec3(next_pos.xy());
	}


	// add next step for the urbanist direction, plus distance

	private vec2 compute_pos_2D(R_Plate plate, vec6 canvas, ArrayList<R_Node> nodes, ArrayList<R_Line2D> segments) {
		// set direction
		float angle = next_angle_direction();
		// set distance
		float dist = next_distance();

		vec2 buf_pos = to_cartesian_2D(angle,dist).add(new vec2(get_destination()));

		// the functions below create recursivity
		buf_pos = compute_pos_2D_out_canvas(plate, canvas, nodes, segments, buf_pos);
		buf_pos = compute_pos_2D_no_cross(plate, canvas, nodes, segments, buf_pos);
		buf_pos = compute_pos_2D_road_gradient(plate, canvas, nodes, segments, buf_pos);

		// check for to big length for next destination
		float length_to_go = dist(buf_pos, new vec2(get_pos()));
		if(length_to_go >= get_dist_max()) {
			int target = floor(random(nodes.size()));
			buf_pos = new vec2(nodes.get(target).pos());
		}
		return buf_pos;
	}

	// test road gradient of the new road

	private vec2 compute_pos_2D_road_gradient(R_Plate plate, vec6 canvas, ArrayList<R_Node> nodes, ArrayList<R_Line2D> segments, vec2 buf_pos) {
		int max_try_gradient = 10;
		float amp = plate.amplitude();
		// current position
		R_Lithos current_lithos = plate.get((int)get_pos().x(), (int)get_pos().y());
		float current_alt = current_lithos.pos().z() *amp;
		vec2 current = new vec2(0, current_alt);
		// next position
		R_Lithos next_lithos = plate.get((int)buf_pos.x(), (int)buf_pos.y());
		float next_alt = next_lithos.pos().z() *amp;
		float d = buf_pos.dist(get_pos());
		vec2 next = new vec2(d, next_alt);
		// tilt of the road
		float angle = current.angle(next);
		float angle_deg = abs(angle) * 57.295776; // 180°/PI = 57.295776

		if(angle_deg > tilt && count_road_gradient < max_try_gradient) {
			add_failure(get_pos().xy(), buf_pos, r.YELLOW);
			count_road_gradient++;
			// loop method until is good
			buf_pos = compute_pos_2D(plate, canvas, nodes, segments); 
		} else if(count_road_gradient >= max_try_gradient) {
			// back to starting position in case there is too much recursive call or tp node with free slot
			//
			//
			// Maintenant c'est ici qu'on doit regarder free_nodes
			//
			//
			buf_pos = new vec2(nodes.get(0).pos());
		}
		// return buf_pos;
		return buf_pos;
	}



	// out canvas

	private vec2 compute_pos_2D_out_canvas(R_Plate plate, vec6 canvas, ArrayList<R_Node> nodes, ArrayList<R_Line2D> segments, vec2 buf_pos) {
		// limit for the recursive call
		int max_try_canvas = 10;
		// limit for the recursive call
		vec3 canvas_min = new vec3(canvas.x(),canvas.y(),canvas.z());
		vec3 canvas_max = new vec3(canvas.w(),canvas.e(),canvas.f());

		if(count_out_canvas < max_try_canvas && (!r.all(greaterThan(buf_pos, new vec2(canvas_min))) || !r.all(lessThan(buf_pos, new vec2(canvas_max))))) {
			add_failure(get_pos().xy(), buf_pos, r.BLUE);
			count_out_canvas++;
			// loop method until is good
			buf_pos = compute_pos_2D(plate, canvas,nodes, segments); 
		} else if(count_out_canvas >= max_try_canvas) {
			// back to starting position in case there is too much recursive call or tp node with free slot
			//
			//
			// Maintenant c'est ici qu'on doit regarder free_nodes
			//
			//
			buf_pos = new vec2(nodes.get(0).pos());
		}
		return buf_pos;
	}


	private vec2 compute_pos_2D_no_cross(R_Plate plate, vec6 canvas, ArrayList<R_Node> nodes, ArrayList<R_Line2D> segments, vec2 buf_pos) {
		// limit for the recursive call
		int max_try_cross = 10;
		// limit for the recursive call
		R_Line2D target_segment = new R_Line2D(pa, new vec3(get_pos().x, get_pos().y, 0), new vec3(buf_pos.x(), buf_pos.y(), 0));
		if(count_no_cross < max_try_cross && check_meeting_segment(target_segment, segments, false)) {
			add_failure(get_pos().xy(), buf_pos, r.GREEN);
			count_no_cross++;
			// loop method until is good
			buf_pos = compute_pos_2D(plate, canvas,nodes, segments);
		} else if(count_no_cross >= max_try_cross) {

			// HERE IT'S WEIRD ??????
			int target = floor(random(nodes.size()));
			buf_pos = new vec2(nodes.get(target).pos());
						// back to starting position in case there is too much recursive call or tp node with free slot
			//
			//
			// Maintenant c'est ici qu'on doit regarder free_nodes
			//
			//
			buf_pos = new vec2(nodes.get(0).pos());
		}
		return buf_pos;
	}


	private void add_failure(vec2 a, vec2 b, int c) {
		R_Line2D line = new R_Line2D(this.pa, a,b);
		line.id_a(c);
		line.palette(c);
		failures.add(line);
	}


	public ArrayList<R_Line2D> get_failure() {
		return failures;
	}












	// utils

	private float next_angle_direction() {
		float previous_direction = new vec2(get_pos()).angle(new vec2(get_destination()));
		float angle = next_direction();
		// println("angle", angle);
			if(keyPressed) {
		}
		angle += previous_direction;
		return angle;
	}


	private boolean check_meeting_segment(R_Line2D target_segment, ArrayList<R_Line2D> seg_list, boolean show_info) {
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
			count_segment_meeting++;
			is = true;
			break;
		}
	}
	return is;
	}



	boolean intersection_is = false;
	public boolean intersection_is() {
		return intersection_is;
	}

	private void intersection_is(boolean is) {
		intersection_is = is;
	}


	public void reset_stroll() {
		count_segment_meeting = 0;
	} 
}
