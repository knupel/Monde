/**
* Urbaniste
v 0.0.2
* Copyleft (c) 2019-2019
* @author Stan le Punk
* @see http://stanlepunk.xyz/
* @see https://github.com/StanLepunK/Monde
* build with Processing 3.5.1
*/
/**
french guide
boussole : compass
*/
ArrayList<Intersection> grid_nodes_monde;
ArrayList<Segment> segment_monde;
Urbanist urbanist;
float angle_tracer;
float speed;
void init_street_map() {
	// init data if nececary
	if( grid_nodes_monde == null) {
		 grid_nodes_monde = new ArrayList<Intersection>();
	}

	if(segment_monde == null) {
		segment_monde = new ArrayList<Segment>();
	}

	// reset data
	grid_nodes_monde.clear();
	segment_monde.clear();
  
  // set data
	Vec2 start_pos = Vec2(random(width),random(height));
	int range_start = 30;
	Vec2 destination = Vec2(start_pos.x+random(-range_start,range_start),start_pos.y+random(-range_start,range_start));
  urbanist = new Urbanist();
  urbanist.set_pos(start_pos);
  urbanist.set_destination(destination);
  
  angle_tracer = angle(start_pos,destination);
  Intersection intersection = new Intersection(start_pos,destination.copy()); // copy() it's nessacy to don't point on a same Object
  grid_nodes_monde.add(intersection);
  Segment segment = new Segment(start_pos,destination.copy());
  segment_monde.add(segment);
  println("new street map",urbanist.get_pos());
}








void urbanist() {
	// update
	urbanist.set_pos(follow(urbanist.get_destination(),.8));
	// display
	stroke(255);
  noFill();
  strokeWeight(10);
  point(urbanist.get_pos());
}

void boussole(Vec2 pos,int size) {
	iVec2 north = iVec2(0,-1).mult(size);
	iVec2 south = iVec2(0,1).mult(size);
	iVec2 west = iVec2(-1,0).mult(size);
	iVec2 east = iVec2(1,0).mult(size);
  
  float angle = 0;
  int div = 0;
  for(Segment s : segment_monde) {
  	int mult = ceil(s.get_distance());
  	div += mult;
  	angle += (s.get_angle() *mult);
  }
  angle /= div;

  noFill();
  stroke(r.WHITE);
  strokeWeight(2);
	push();
	translate(pos);
	rotate(PI/4+angle);
	line(north,south);
	line(west,east);
	pop();
}




void show_center_world() {
	strokeWeight(2);
  if( grid_nodes_monde.size() > 0) {
  	ellipse(grid_nodes_monde.get(0).get_pos(),50,50);
  }
}


void map() {
	Vec2 area = Vec2(2);
	if(compare(Vec2(urbanist.get_pos()),Vec2(urbanist.get_destination()),area)) {
		float min_dist = 10;
		float max_dist = 100;
		Vec2 range_dist = Vec2(min_dist,max_dist);

		Vec2 new_destination = goto_next(urbanist,angle_tracer,range_dist,Vec2(0),Vec2(width,height));
		Vec2 from = Vec2(urbanist.get_destination()).copy();
		urbanist.set_destination(new_destination);
		angle_tracer = angle(Vec2(urbanist.get_pos()),Vec2(urbanist.get_destination()));
    
    if(!intersection_is()) {
    	Intersection intersection = new Intersection(new_destination,from);
      grid_nodes_monde.add(intersection);
      println("new intersection, total is",new_destination,grid_nodes_monde.size());

      Segment segment = new Segment(new_destination,from);
      segment_monde.add(segment);
      println("new segment, total is",new_destination,from,segment_monde.size());  
    } else {
      int inter_rank = urbanist.get_intersection();
      Intersection inter = grid_nodes_monde.get(inter_rank);
    	println("The urbanist is on an existing carrefour",inter_rank,"\nthere is",inter.get_branch_available(),"on",inter.get_branch());
    }
    intersection_is(false);
	}

  // draw road map
	stroke(r.BLOOD);
	noFill();
	strokeWeight(1);

	// show segment
	for(Segment s : segment_monde) {
		line(s.get_start(),s.get_end());
	}
	/*
	// SHOW ALL PATH
	beginShape();
	for(int i = 0 ; i < grid_monde.size(); i++) {
		vertex(grid_monde.get(i).get_pos());
	}
	endShape();
	*/
	
}








public class Urbanist {
	private Vec3 pos;
	private Vec3 dst;
	private int intersection ;
	
	public Urbanist() {
		this.pos = Vec3();
		this.dst = Vec3();
	}

	public void set_intersection(int intersection) {
		this.intersection = intersection;
	}

	public int get_intersection() {
		return intersection;
	}



	public void set_pos(Vec pos) {
		this.pos.set(pos);
	}

	public void set_destination(Vec dst) {
		this.dst.set(dst);
	}

	public Vec3 get_pos() {
		return this.pos;
	}

	public Vec3 get_destination() {
		return dst;
	}
}






Vec2 goto_next(Urbanist urbanist, float previous_direction, Vec2 range, Vec2 canvas_min, Vec2 canvas_max) {
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
	Vec2 pos = to_cartesian_2D(angle,dist).add(Vec2(urbanist.get_destination()));
	if(!all(greaterThan(pos,canvas_min)) || !all(lessThan(pos,canvas_max))) {
		pos = goto_next(urbanist,previous_direction,range,canvas_min,canvas_max);
	}
	// check if the new target is close to carrefour, if it is the plotter must go on it
	urbanist.set_intersection(-1);

	/*
	start to 1 is good or what ?????

	*/
	for(int i = 1 ; i < grid_nodes_monde.size() ; i++) {
		Vec3 p = grid_nodes_monde.get(i).get_pos();
		if(compare(pos,Vec2(p.x,p.y),Vec2(range.x))) {
			intersection_is(true);
			pos = Vec2(p.x,p.y);
			urbanist.set_intersection(i);
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
	ArrayList<Vec3> dest_list;
	int branch = 2;
	int id;

	Intersection(Vec pos, Vec from) {
		this.id = (int)random(MAX_INT);
		this.pos = Vec3(pos.x,pos.y,pos.z);
		dest_list = new ArrayList<Vec3>();
		dest_list.add(Vec3(from.x,from.y,from.z));
		branch = (ceil(map(random_next_gaussian(1),-1,1,0,8)));
		if(branch == 0 || branch == 1) branch = 2; // we can choic 1 for the future to create a cul-de-sac
	}

	boolean add_destination(Vec3 dst) {
		if(dest_list.size() < branch) {
			dest_list.add(dst);
			println("new destination added");
			return true;
		} else {
			println("no more slot available to add new destination");
			return false;
		}
	}

	int get_branch() {
		return branch;
	}

	int get_branch_available() {
		return branch - dest_list.size();
	}

	void set_destination(Vec3 pos) {
		if(dest_list.size() < branch) {
			println("class Intersection",id,"add destination",pos,"to branch");
			dest_list.add(pos);
		} else {
			println("class Intersection",id,"has no more branches available");
		}
	}


  
	void set_branch(int branch) {
		this.branch = branch;
	}

	Vec3 [] get_destination() {
		return dest_list.toArray(new Vec3[dest_list.size()]);
	}

	Vec3 get_pos() {
		return pos;
	}
}









public class Segment {
	private Vec3 start;
	private Vec3 end;
	private int capacity;
	private boolean direction;
	private float angle;
	private float dist;
	public Segment(Vec start, Vec end) {
		this.start = Vec3(start.x,start.y,start.z);
		this.end = Vec3(end.x,end.y,end.z);
		this.angle = angle(Vec2(this.start),Vec2(this.end));
		this.dist = dist(this.start,this.end);
	}

	public Vec3 get_start() {
		return start;
	}

	public Vec3 get_end() {
		return end;
	}

	public float get_angle() {
		return angle;
	}

	public float get_distance() {
		return dist;
	}

	public void set_capacity(int capacity) {
		this.capacity = capacity;
	}

	public void set_direction(boolean direction) {
		this.direction = direction;
	}
}



