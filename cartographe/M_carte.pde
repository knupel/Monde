/**
* Carte
v 0.2.0
* Copyleft (c) 2019-2019
* @author Stan le Punk
* @see http://stanlepunk.xyz/
* @see https://github.com/StanLepunK/Monde
* build with Processing 3.5.2
*/
/**
french guide
boussole : compass
carte : map
*/
ArrayList<Intersection> grid_nodes_monde;
ArrayList<Segment> segment_monde;
Urbanist urbanist;
float speed;
int inter_id;
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
	inter_id = 0;
  
  // set data
  int marge = width/10;
	Vec2 start_pos = Vec2(random(marge,width -marge),random(marge,height -marge));
	int range_start = 30;
	Vec2 destination = Vec2(start_pos.x+random(-range_start,range_start),start_pos.y+random(-range_start,range_start));
  urbanist = new Urbanist();
  urbanist.set_pos(start_pos);
  urbanist.set_destination(destination);
  
  // angle_tracer = angle(start_pos,destination);
  Intersection inter = new Intersection(start_pos,destination.copy()); // copy() it's nessacy to don't point on a same Object
  inter.set_branch(8); // the start need a lot of branches
  inter.set_id(inter_id++);

  grid_nodes_monde.add(inter);
  Segment segment = new Segment(start_pos,destination.copy());
  segment_monde.add(segment);
  println("new street map",urbanist.get_pos());
}












void urbanist() {
	float speed = .2;
	int min = 20;
	int max = 100;
	// update
	urbanist.set_pos(follow(urbanist.get_destination(),speed));
	urbanist.set_range(min,max);
	// display
	stroke(255);
  noFill();
  strokeWeight(10);
  point(urbanist.get_pos());
}

void boussole(Vec2 pos, int size) {
	iVec2 north = iVec2(0,-1).mult(size);
	iVec2 south = iVec2(0,1).mult(size);
	iVec2 west = iVec2(-1,0).mult(size);
	iVec2 east = iVec2(1,0).mult(size);
  
  float angle = 0;
  int div = 0;
  for(Segment s : segment_monde) {
  	int mult = ceil(s.get_length());
  	div += mult;
  	angle += (s.get_angle() *mult);
  }
  angle /= div;

  noFill();
  stroke(r.WHITE);
  strokeWeight(1);
	push();
	translate(pos);
	rotate(PI/4+angle);
	line(north,south);
	line(west,east);
	pop();
}




void show_center_world() {
	strokeWeight(2);
  if(grid_nodes_monde.size() > 0) {
  	ellipse(grid_nodes_monde.get(0).get_pos(),50,50);
  }
}

void show_intersection() {
	strokeWeight(4);
	stroke(255);
	noFill();
  if(grid_nodes_monde.size() > 0) {
  	for(Intersection inter : grid_nodes_monde) {
  		textAlign(CENTER);
  		text(inter.get_id(),inter.get_pos());
  		// point(inter.get_pos());
  	}
  }
}


void map() {
	Vec2 area = Vec2(10);
	Vec6 canvas_birth = Vec6(0,0,-width,   width,height,width);
	boolean show_info = true;
	if(compare(Vec2(urbanist.get_pos()),Vec2(urbanist.get_destination()),area)) {
		Vec2 new_destination = goto_next(urbanist,canvas_birth,grid_nodes_monde,segment_monde,show_info);
		int id_inter = rank_intersection(urbanist,urbanist.get_pos());
	  if(id_inter >= 0) {
	  	Intersection inter = grid_nodes_monde.get(id_inter);
			urbanist.set_destination(new_destination,inter);
		} else {
			urbanist.set_destination(new_destination);
		}
    
    
    if(!intersection_is()) {
    	boolean cycle_add_is = false;
      cycle_add_is = ask_intersection();
      // check to build segment
      boolean build_anytime_is = false;
      cycle_add_is = add_segment(urbanist,build_anytime_is,show_info);
      if(cycle_add_is) {
      	add_intersection();
      }
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
	count_segment_meeting = 0;
	
}



/**
add intersection
*/
boolean ask_intersection() {
	int min_branch = 2;
	int max_branch = 5;
	int num = num_branch_by_intersection(min_branch,max_branch);
  return ask_intersection(urbanist,num);
}


Intersection temp_intersection;
boolean ask_intersection(Urbanist urb, int max_branch) {
	boolean add_is = false;
	temp_intersection = new Intersection(urb.get_destination(),urb.get_from());
	temp_intersection.set_branch(max_branch);
	temp_intersection.set_id(inter_id++);
	add_is = true;
	return add_is;
}

void add_intersection() {
	grid_nodes_monde.add(temp_intersection);
}



boolean add_segment(Urbanist urb, boolean build_anytime, boolean show_info_is) {
	boolean add_is = false;
	boolean from_is = false;
  int id_from = rank_intersection(urb,urb.get_from());
  Intersection inter;

  if(id_from >= 0) {
  	inter = grid_nodes_monde.get(id_from);
	  if(inter.get_branch_available() > 0) {
	  	from_is = true;
	  }
  }
  
  // info
  if(show_info_is) {
  	noStroke();
  	fill(r.WHITE);
  	ellipse(Vec2(urb.get_from()),20,20);
  	ellipse(Vec2(urb.get_destination()),20,20);
  }


  if(build_anytime || from_is) {
  	Segment segment = new Segment(temp_intersection.get_pos(),urb.get_from());
  	if(segment.get_length() <= urb.get_max()) {
  		segment_monde.add(segment);
  		grid_nodes_monde.get(id_from).add_destination(temp_intersection.get_pos());
  		temp_intersection.add_destination(urb.get_from());
  		add_is = true;
  	}
  }
  return add_is;
}



int rank_intersection(Urbanist urb, Vec target) {
	int rank = -1;
	for(int i = 0 ; i < grid_nodes_monde.size() ; i++) {
		Vec3 p = grid_nodes_monde.get(i).get_pos();
		if(compare(Vec2(target),Vec2(p.x,p.y),Vec2(5))) {
			rank = i;
			break;
		}
	}
	return rank;
}


int num_branch_by_intersection(int min, int max) {
	int num = (ceil(map(random_next_gaussian(1),-1,1,0,max)));
	if(num == 0 || num == (min-1)) num = min; // we can choic 1 for the future to create a cul-de-sac
	return num;
}









/*
void img_urbanist_setting() {
	iVec2 pos = iVec2(urbanist.get_pos());
	float density = brightness(img.get(pos.x,pos.y));
	// float min = map(density,0,g.colorModeZ,5,15);
	// float max = map(density,0,g.colorModeZ,25,400);
	float min = 100;
	float max = 300;
	// println(density);
	urbanist.set_range(min,max);
}


void img_map_setting() {
	iVec2 pos = iVec2(urbanist.get_pos());
	float density = brightness(img.get(pos.x,pos.y));
	int num = (int)map(density,0,g.colorModeZ,12,2);
	add_intersection(urbanist,num);
}
*/




















/**
GOTO NEXT 
v 0.1.0
* is a main method to give the next destination point for urbanist
*/
Vec2 goto_next(Urbanist urb, Vec6 canvas, ArrayList<Intersection> inter_list, ArrayList<Segment> seg_list, boolean show_info) {
	Vec2 angle_range = Vec2(0,PI/6);
	Vec2 pos = compute_pos(urb,canvas,inter_list,angle_range);
	count_segment_out_canvas = 0;

	// check if the urbanist don't meet an other segment
	Segment urb_seg = new Segment(urb.get_pos(),pos);
	boolean meet_is = check_meeting_segment(urb_seg,seg_list,show_info);
  
  if(meet_is) {
  	//println(count_segment_meeting);
  	// pos = goto_next(urb,canvas,seg_list,show_info);
  }
	// check if the new target is close to carrefour, if it is the plotter must go on it
	urb.set_intersection(-1);

	for(int i = 0 ; i < grid_nodes_monde.size() ; i++) {
		Vec3 p = grid_nodes_monde.get(i).get_pos();
		if(compare(pos,Vec2(p.x,p.y),Vec2(urb.get_min()))) {
			intersection_is(true);
			pos = Vec2(p.x,p.y);
			urb.set_intersection(i);
			break;
		}
	}
	return pos;
}

int count_segment_meeting = 0;
boolean check_meeting_segment(Segment target_segment, ArrayList<Segment> seg_list, boolean show_info) {
	boolean is = false;
	int max_iter_for_meeting = 100;
	for(Segment s : seg_list) {
  	if(show_info) {
  		strokeWeight(1);
  		stroke(255);
  		noFill();
  		Vec2 meet_pos = target_segment.meet_at(s);
  		line(target_segment.get_start(),target_segment.get_end());
  		if(meet_pos != null) ellipse(meet_pos,30,30);
  	}

  	if(target_segment.meet_is(s) && count_segment_meeting < max_iter_for_meeting) {
  		count_segment_meeting ++;
  		is = true;
  		break;
  	}
  }
  return is;
}


int count_segment_out_canvas = 0;

Vec2 compute_pos(Urbanist urb, Vec6 canvas, ArrayList<Intersection> inter_list, Vec2 range_angle) {
	float angle = random_next_gaussian(3);
	float previous_direction = angle(Vec2(urb.get_pos()),Vec2(urb.get_destination()));
	float ratio_center = abs(random_next_gaussian(2));
	float dist = map(ratio_center,0,1,urb.get_range().x,urb.get_range().y);
	// new angle
	angle = map(angle,-1,1,range_angle.x,range_angle.y);
	angle += previous_direction;
	// other side direction
	float goto_left = random(1);
	if(goto_left < .5) angle *= -1;
	Vec3 canvas_min = Vec3(canvas.a,canvas.b,canvas.c);
	Vec3 canvas_max = Vec3(canvas.d,canvas.e,canvas.f);
	Vec2 pos = to_cartesian_2D(angle,dist).add(Vec2(urb.get_destination()));
  
  int max_try = 10; // limit for the recursive call
	if(count_segment_out_canvas < max_try && (!all(greaterThan(pos,Vec2(canvas_min))) || !all(lessThan(pos,Vec2(canvas_max))))) {
		count_segment_out_canvas++;
		// loop method until is good
		pos = compute_pos(urb,canvas,inter_list,range_angle); 
	} else if( count_segment_out_canvas >= max_try) {
		// back to starting position in case there is too much recursive call
    pos = Vec2(inter_list.get(0).get_pos());
	}

  // check for to big length for next destination
	float length_to_go = dist(pos,Vec2(urb.get_pos()));
	if(length_to_go >= urb.get_max()) {
		int target = (floor(random(inter_list.size())));
		pos = Vec2(inter_list.get(target).get_pos());
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








































/**
URBANIST
v 0.0.4
*/
public class Urbanist {
	private Vec3 pos;
	private Vec3 dst;
	private Vec3 from;
	private int intersection ;
	private Vec2 range;
	
	public Urbanist() {
		this.pos = Vec3();
		this.from = Vec3();
		this.dst = Vec3();
		this.range = Vec2(0,height);
	}
  
  // set
	public void set_intersection(int intersection) {
		this.intersection = intersection;
	}

	public void set_range(float min, float max) {
		this.range.set(min,max);
	}

	public void set_pos(Vec pos) {
		this.pos.set(pos);
	}

	public void set_destination(Vec dst) {
		set_destination(dst,null);

	}

	public void set_destination(Vec dst, Intersection intersection) {
		// check if there is free slot on this intersection
		if(intersection == null || intersection.get_branch_available() > 0) {
			this.from.set(this.dst);
			this.dst.set(dst);
		} else {
			this.from.set(this.dst);
			// select destination in the pnal of destination of this intersection
			int which = floor(random(intersection.get_branch()));
			this.dst.set(intersection.get_destination()[which]);
		}

	}
  
  // get
  public int get_intersection() {
		return intersection;
	}


	public Vec2 get_range() {
		return this.range;
	}

	public float get_max() {
		return this.range.y;
	}

		public float get_min() {
		return this.range.x;
	}

	public Vec3 get_pos() {
		return this.pos;
	}

	public Vec3 get_from() {
		return this.from;
	}

	public Vec3 get_destination() {
		return dst;
	}
}










/**
INTERSECTION
v 0.0.3
*/
public class Intersection {
	private Vec3 pos;
	private ArrayList<Vec3> dest_list;
	private int branch = 4;
	private int id;

	public Intersection(Vec pos, Vec from) {
		this.id = (int)random(MAX_INT);
		this.pos = Vec3(pos);
		dest_list = new ArrayList<Vec3>();
		dest_list.add(Vec3(from));
	}


	public boolean add_destination(Vec dst) {
		if(dest_list.size() < branch && !all(equal(get_pos(),Vec3(dst)))) {
			boolean equal_is = false;
			Vec3 [] list = get_destination();
			for(int i = 0 ; i < list.length ; i++) {
				if(all(equal(list[i],Vec3(dst)))) {
					equal_is = true;
				}
			}
			if(!equal_is) {
				dest_list.add(Vec3(dst));
			}
			return !equal_is;
		} else {
			return false;
		}
	}
  
  // set
  public void set_destination(Vec3 pos) {
		if(dest_list.size() < branch) {
			dest_list.add(pos);
		} 
	}

	public void set_id(int id) {
		this.id = id;
	}

	public void set_branch(int branch) {
		if(branch > 1 && branch > dest_list.size()) {
			this.branch = branch;
		} 
	}

  
  // get
	public int get_id() {
		return id;
	}

	public int get_branch() {
		return branch;
	}

	public int get_branch_available() {
		return branch - dest_list.size();
	}

	public Vec3 [] get_destination() {
		return dest_list.toArray(new Vec3[dest_list.size()]);
	}

	public Vec3 get_pos() {
		return pos;
	}
}








/**
SEGMENT
v 0.0.2
*/
public class Segment {
	private Vec3 start;
	private Vec3 end;
	private int capacity;
	private boolean direction;
	private float angle;
	private float length;
	public Segment(Vec start, Vec end) {
		this.start = Vec3(start.x,start.y,start.z);
		this.end = Vec3(end.x,end.y,end.z);
		this.angle = angle(Vec2(this.start),Vec2(this.end));
		this.length = dist(this.start,this.end);
		// println("class Segment: new Segment build");
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

	public float get_length() {
		return length;
	}

	public void set_capacity(int capacity) {
		this.capacity = capacity;
	}

	public void set_direction(boolean direction) {
		this.direction = direction;
	}



	private Vec2 line_intersection(Segment one, Segment two) {
    float x1 = one.get_start().x;
    float y1 = one.get_start().y;
    float x2 = one.get_end().x;
    float y2 = one.get_end().y;
    
    float x3 = two.get_start().x;
    float y3 = two.get_start().y;
    float x4 = two.get_end().x;
    float y4 = two.get_end().y;
    
    float bx = x2 - x1;
    float by = y2 - y1;
    float dx = x4 - x3;
    float dy = y4 - y3;
   
    float b_dot_d_perp = bx * dy - by * dx;
   
    if(b_dot_d_perp == 0) {
    	return null;
    }
   
    float cx = x3 - x1;
    float cy = y3 - y1;
   
    float t = (cx * dy - cy * dx) / b_dot_d_perp;
    if(t < 0 || t > 1) return null;
   
    float u = (cx * by - cy * bx) / b_dot_d_perp;
    if(u < 0 || u > 1) return null;
   
    return Vec2(x1+t*bx, y1+t*by);
  }
  
  public Vec2 meet_at(Segment target) {
    return line_intersection(this,target);
  }

  public boolean meet_is(Segment target) {
  	if(meet_at(target) == null) {
  		return false;
  	} else {
  		return true;
  	}
  }
}



