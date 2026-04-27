/**
* urbaniste
* v 0.0.1
* 2026-2026
* Copyleft (c) 2019-2026
* @author Knupel
* @see https://github.com/knupel/Monde
*/
Urbanist urbanist;

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


void show_urbaniste(vec pos) {
	rg.fill_is(true);
	rg.fill(r.YELLOW);
	rg.stroke_is(false);
	rg.ellipse(pos,50);
}