/**
ROPE - Romanesco processing environment – 
* Copyleft (c) 2014-2019
* Stan le Punk
* https://github.com/StanLepunK
* http://stanlepunk.xyz/
*/




/**
* ROAD MAP / ROAD NETWORK implementation
* @see http://martindevans.me/game-development/2015/12/11/Procedural-Generation-For-Dummies-Roads/
* @see http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.85.6659&rep=rep1&type=pdf
* @see https://graphics.ethz.ch/Downloads/Publications/Papers/2001/p_Par01.pdf
*/
ArrayList<Vec2>nodes = new ArrayList<Vec2>();
Vec2 plotter;
float angle_tracer;
float speed;
Vec2 destination;


void setup() {
  background(0);
  fullScreen(2);
  // size(800,800);
  init_street_map();
}


void draw() {
  background(0);
	Vec2 target = destination.copy();
	Vec2 area = Vec2(2);
	plotter.set(follow(target,.8));
	if(compare(plotter,destination,area)) {
		// float min_dist = width *.1;
		float min_dist = 20;
		float max_dist = dist(nodes.get(0),destination);
		Vec2 range_dist = Vec2(min_dist,max_dist);
		Vec2 new_destination = goto_next(destination,angle_tracer,range_dist,Vec2(0),Vec2(width,height));
		destination.set(new_destination);
		angle_tracer = angle(plotter,destination);
    
    if(!intersection_is()) {
    	nodes.add(destination.copy()); // copy() it's necessary to don't point on a same Object
			println("new intersection, total is",nodes.size());
    }
    intersection_is(false);

		
		// if(!intersection_is()) {
		// 	nodes.add(destination.copy()); // copy() it's necessary to don't point on a same Object
		// 	println("new intersection, total is",nodes.size());
		// } else {
		// 	intersection_is(false);
		// }
		
		
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

		// draw tracer
  stroke(255);
  noFill();
  strokeWeight(10);
  point(plotter);
  // SHOW CENTER

  strokeWeight(5);
  if(nodes.size() > 0) {
  	ellipse(nodes.get(0),50,50);
  }
}


void keyPressed() {
	if(key == 'n') {
		init_street_map();

	}
}

void init_street_map() {
	if(nodes == null) {
		nodes = new ArrayList<Vec2>();
	}
	nodes.clear();
	Vec2 start_pos = Vec2(random(width),random(height));
  plotter = start_pos.copy();
  destination = Vec2(random(width),random(height));
  angle_tracer = angle(start_pos,destination);
  nodes.add(start_pos);
  nodes.add(destination.copy()); // copy() it's nessacy to don't point on a same Object
  println("new street map",plotter);

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





























