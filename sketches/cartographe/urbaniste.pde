/**
* urbaniste
* v 0.0.2
* Copyleft (c) 2019-2026
* @author Knupel
* @see https://github.com/knupel/Monde
*/
Urbanist urbanist;


void set_urbanist(float min_range, float max_range) {
	urbanist.set_range(min_range, max_range);
	urbanist.set_angle(-PI,PI);
}

vec3 buf_follow = new vec3();
void urbanist_walk(float speed_exploration) {
	urbanist.set_pos(follow(urbanist.get_destination(),speed_exploration,buf_follow));
}


void show_urbanist(vec pos) {
	rg.fill_is(true);
	rg.fill(r.YELLOW);
	rg.stroke_is(false);
	rg.ellipse(pos,50);
}