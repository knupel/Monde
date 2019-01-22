/**
* Urbaniste
v 0.0.2
* Copyleft (c) 2019-2019
* @author Stan le Punk
* @see http://stanlepunk.xyz/
* @see https://github.com/StanLepunK/Monde
*/
ArrayList<Vec2>nodes = new ArrayList<Vec2>();
Vec2 urbanist;
float angle_tracer;
float speed;
Vec2 destination;




void show_urbanist() {
	stroke(255);
  noFill();
  strokeWeight(10);
  point(urbanist);
}

void show_center_world() {
	strokeWeight(5);
  if(nodes.size() > 0) {
  	ellipse(nodes.get(0),50,50);
  }
}




void init_street_map() {
	if(nodes == null) {
		nodes = new ArrayList<Vec2>();
	}
	nodes.clear();
	Vec2 start_pos = Vec2(random(width),random(height));
  urbanist = start_pos.copy();
  destination = Vec2(random(width),random(height));
  angle_tracer = angle(start_pos,destination);
  nodes.add(start_pos);
  nodes.add(destination.copy()); // copy() it's nessacy to don't point on a same Object
  println("new street map",urbanist);
}



void map() {
	Vec2 target = destination.copy();
	Vec2 area = Vec2(2);
	urbanist.set(follow(target,.8));
	if(compare(urbanist,destination,area)) {
		// float min_dist = width *.1;
		float min_dist = 20;
		float max_dist = dist(nodes.get(0),destination);
		Vec2 range_dist = Vec2(min_dist,max_dist);
		Vec2 new_destination = goto_next(destination,angle_tracer,range_dist,Vec2(0),Vec2(width,height));
		destination.set(new_destination);
		angle_tracer = angle(urbanist,destination);
    
    if(!intersection_is()) {
    	nodes.add(destination.copy()); // copy() it's necessary to don't point on a same Object
			println("new intersection, total is",nodes.size());
    }
    intersection_is(false);
	}

  // draw road map
	stroke(r.BLOOD);
	noFill();
	strokeWeight(1);
	beginShape();
	for(int i = 0 ; i < nodes.size(); i++) {
		vertex(nodes.get(i));
	}
	endShape();
}








Vec2 goto_next(Vec2 previous_pos, float previous_direction, Vec2 range, Vec2 canvas_min, Vec2 canvas_max) {
	float angle = random_next_gaussian(3);
	// new angle
	angle = map(angle,-1,1,0,PI);
	angle += previous_direction;

	// other side direction
	float goto_left = random(1);
	if(goto_left < .5) angle *= -1;
  
  // new distance
	float ratio_center = abs(random_next_gaussian(2));
	float dist = map(ratio_center,0,1,range.x,range.y);
	
	// check if the new destination is in the window
	Vec2 pos = to_cartesian_2D(angle,dist).add(previous_pos);
	if(!all(greaterThan(pos,canvas_min)) || !all(lessThan(pos,canvas_max))) {
		pos = goto_next(previous_pos,previous_direction,range,canvas_min,canvas_max);
	}
	// check if the new target is close to carrefour, if it is the plotter must go on it
	for(int i = 1 ; i < nodes.size() ; i++) {
		Vec2 p = nodes.get(i);
		if(compare(pos,p,Vec2(range.x))) {
		// if(compare(pos,p,Vec2(range.x).div(2))) {
			// println("new destination to other intersection, the plotter go to intersection");
			intersection_is(true);
			pos = p.copy();
			break;
		}
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






class Intersection {
	Vec3 pos;
	ArrayList<Vec3> dst;

	Intersection(Vec3 pos) {
		this.pos = pos.copy();
	}
}

class Segment {
	Vec3 start;
	Vec3 end;
	int capacity;
	boolean direction;
	Segment(Vec3 start, Vec3 end) {
		this.start = start.copy();
		this.end = end.copy();
	}

	void set_capacity(int capacity) {
		this.capacity = capacity;
	}

	void set_direction(boolean direction) {
		this.direction = direction;
	}
}