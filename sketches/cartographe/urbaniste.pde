/**
* urbaniste
* v 0.0.2
* Copyleft (c) 2019-2026
* @author Knupel
* @see https://github.com/knupel/Monde
*/
Urbanist urbanist;


void set_urbanist() {
	float min_range = height/80;
	float max_range = width/10;
	urbanist.set_dist_range(min_range, max_range);
	// this proportion is use to choice the direction of the next step of the urbanist
	int [] angle_proportion = {0,0,1,1,100,10,5,10,200,10,5,10,100,1,0,0};
	urbanist.set_angle_proportion(angle_proportion);
	int [] dist_proportion = {32,64,128,64,32,16,8,4,2};
	urbanist.set_dist_proportion(dist_proportion);
	urbanist.set_speed(0.05);
}

vec3 buf_follow = new vec3();
void run_urbanist() {
	urbanist.set_pos(follow(urbanist.get_destination(),urbanist.get_speed(),buf_follow));
}


void show_urbanist(vec pos) {
	rg.fill_is(true);
	rg.fill(r.YELLOW);
	rg.stroke_is(false);
	rg.ellipse(pos,50);
}