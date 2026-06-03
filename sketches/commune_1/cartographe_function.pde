/**
* urbaniste
* v 0.0.2
* Copyleft (c) 2019-2026
* @author Knupel
* @see https://github.com/knupel/Monde
*/
R_Cartographe stroller;

R_Cartographe get_stroller() {
	return stroller;
}

// Cartographe / Stroller
void init_stroller() {
	stroller = new R_Cartographe(this);
	int marge = width/10;
	// position
	vec3 start_pos = new vec3(random(marge,width -marge),random(marge,height -marge),0);
	int range_start = 30;
	vec3 destination = new vec3(start_pos.x()+random(-range_start,range_start),start_pos.y()+random(-range_start,range_start),0);
	stroller.set_pos(start_pos);
	stroller.set_destination(destination);
	int radius_stroller = 5;
	int marge_stroller = 2;
	stroller.create_stroller(radius_stroller,marge_stroller);
}


void set_stroller() {
	// direction
	// this proportion is use to choice the direction of the next step of the urbanist
	// int [] angle_proportion = {0,0,0,0,50,0,0,0,200,0,0,0,50,0,0,0}; // this setting cause a U-turn situation
	int [] angle_proportion = {100,0,0,0,50,0,0,0,0,0,0,0,50,0,0,100};

	stroller.set_angle_proportion(angle_proportion);
	// distance
	float min_range = height/100;
	float max_range = width/10;
	stroller.set_dist_range(min_range, max_range);
	int [] dist_proportion = {32,64,128,64,32,16,8,4,2};
	stroller.set_dist_proportion(dist_proportion);
	// intersection
	int [] intersection_proportion = {32,64,64,32,4,2}; 
	stroller.set_intersection_ways(intersection_proportion);
	stroller.set_speed(0.2);
	stroller.set_tilt(8.5); // 8.5 est la valeur maximum française pour les pentes en France
	stroller.reset();
}


void reset_stroller() {
	init_stroller();
	set_stroller();
	set_map(stroller);
	
}

vec3 buf_follow = new vec3();
void run_stroller() {
	stroller.set_pos(follow(stroller.get_destination(),stroller.get_speed(),buf_follow));
}


void show_stroller() {
	rg.fill_is(use_fill_is());
	rg.fill(r.GOLD);
	rg.stroke_is(use_stroke_is());
	rg.stroke(r.TENEBRE);
	rg.thickness(1);
	stroller.show();
}


void show_failure() {
	// println("total failure ", stroller.get_failure().size());
	for(R_Line2D line : stroller.get_failure()) {
		line.thickness(1);
		if(line.id().a() == r.YELLOW) {
			line.show(0);
		}
		
	}

}