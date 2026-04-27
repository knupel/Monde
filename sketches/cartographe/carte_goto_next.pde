/**
* CARTE GOTO NEXT 
v 0.2.0
* It's a main method to give the next destination point for urbanist
*/
vec3 goto_next(Urbanist urb, vec6 canvas, ArrayList<R_Node> inter_list, ArrayList<R_Line2D> seg_list, boolean show_info) {
	// find the next good destination
	vec2 compute_plan_pos = compute_pos_2D(urb, canvas, inter_list, seg_list);
	count_segment_out_canvas = 0;
	count_segment_no_cross = 0;
	// checking the plan 2D
	// if the new target is close to carrefour, if it is the plotter must go on it
	urb.set_intersection(-1);
	for(int i = 0 ; i < grid_nodes_monde.size() ; i++) {
		vec3 p = grid_nodes_monde.get(i).pos();
		if(r.compare(compute_plan_pos,new vec2(p.x(),p.y()),new vec2(urb.get_min()))) {
			intersection_is(true);
			compute_plan_pos = new vec2(p.x(),p.y());
			urb.set_intersection(i);
			break;
		}
	}

	// checking the altitude 
    // make that in future version


	vec3 pos = new vec3(compute_plan_pos.xy());
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


// angle
int count_segment_no_cross = 0;
vec2 compute_pos_2D(Urbanist urb, vec6 canvas, ArrayList<R_Node> inter_list, ArrayList<R_Line2D> seg_list) {
	float angle = next_angle_direction(urb);
	float ratio_center = abs(r.random_next_gaussian(2));
	float dist = map(ratio_center,0,1,urb.get_range().x,urb.get_range().y);

	vec2 buf_pos = r.to_cartesian_2D(angle,dist).add(new vec2(urb.get_destination()));
	// the function below create recursivity
	buf_pos = compute_pos_2D_out_canvas(urb, canvas, inter_list, seg_list, buf_pos);
	// the function below create recursivity
	buf_pos = compute_pos_2D_no_cross(urb, canvas, inter_list, seg_list, buf_pos);

  	// check for to big length for next destination
	float length_to_go = r.dist(buf_pos, new vec2(urb.get_pos()));
	if(length_to_go >= urb.get_max()) {
		int target = floor(random(inter_list.size()));
		buf_pos = new vec2(inter_list.get(target).pos());
	}
	return buf_pos;
}

float next_angle_direction(Urbanist urb) {
	float angle = r.random_next_gaussian(3);
	float previous_direction = new vec2(urb.get_pos()).angle(new vec2(urb.get_destination()));
	// new angle
	angle = map(angle,-1,1,urb.get_angle().x(),urb.get_angle().y());
	angle += previous_direction;
	// other side direction
	float goto_left = random(1);
	if(goto_left < .5) angle *= -1;
	return angle;
}

// out canvas
int count_segment_out_canvas = 0;
vec2 compute_pos_2D_out_canvas(Urbanist urb, vec6 canvas, ArrayList<R_Node> inter_list, ArrayList<R_Line2D> seg_list, vec2 pos) {
	vec3 canvas_min = new vec3(canvas.x(),canvas.y(),canvas.z());
	vec3 canvas_max = new vec3(canvas.w(),canvas.e(),canvas.f());
	int max_try_canvas = 10; // limit for the recursive call
	if(count_segment_out_canvas < max_try_canvas && (!r.all(r.greaterThan(pos, new vec2(canvas_min))) || !r.all(r.lessThan(pos, new vec2(canvas_max))))) {
		count_segment_out_canvas++;
		// loop method until is good
		pos = compute_pos_2D(urb,canvas,inter_list, seg_list); 
	} else if(count_segment_out_canvas >= max_try_canvas) {
		// back to starting position in case there is too much recursive call
    	pos = new vec2(inter_list.get(0).pos());
	}
	return pos;
}

vec2 compute_pos_2D_no_cross(Urbanist urb, vec6 canvas, ArrayList<R_Node> inter_list, ArrayList<R_Line2D> seg_list, vec2 pos) {
	R_Line2D target_segment = new R_Line2D(this, new vec3(urb.get_pos().x, urb.get_pos().y, 0), new vec3(pos.x(), pos.y(), 0));
	int max_try_cross = 10;
	if(count_segment_no_cross < max_try_cross && check_meeting_segment(target_segment, seg_list, false)) {
		count_segment_no_cross++;
		// loop method until is good
		pos = compute_pos_2D(urb,canvas,inter_list, seg_list);
	} else if(count_segment_no_cross >= max_try_cross) {
		int target = floor(random(inter_list.size()));
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