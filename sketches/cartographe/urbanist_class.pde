/**
* Class Urbanist
* 2026-2026
* v 0.1.0
*/
public class Urbanist {
	private vec3 pos;
	private vec3 dst;
	private vec3 from;
	// distance
	private vec2 dist_range;
	private int [] dist_proportion;
	// angle / direction
	private vec2 angle;
	private int [] angle_proportion;
	// intersection
	private ivec2 intersection;
	private int [] intersection_proportion;
	private float speed;
	
	public Urbanist() {
		this.pos = new vec3();
		this.from = new vec3();
		this.dst = new vec3();
		this.intersection = new ivec2(2,7);
		this.intersection_proportion = new int[] {64,32,16,8,4,2,1};
		this.speed = 0.5;
		this.dist_range = new vec2(0,height);
		this.dist_proportion = new int[] {64,32,16,8,4,2,1};
		this.angle = new vec2(-PI,PI);
		this.angle_proportion = new int[] {1,2,3,4,5,6,7,6,5,4,3,2,1};
	}
  
  	// set
	public void set_dist_range(float min, float max) {
		this.dist_range.set(min,max);
	}

	public void set_dist_proportion(int [] arr) {
		this.dist_proportion = arr;
	}

	public void set_angle(float start, float end) {
		this.angle.set(start,end);
	}

	public void set_angle_proportion(int [] arr) {
		this.angle_proportion = arr;
	}

	public void set_pos(vec pos) {
		this.pos.set(pos);
	}

	public void set_destination(vec dst) {
		set_destination(dst,null);
	}

	public void set_speed(float speed) {
		this.speed = speed;
	}


	public float next_distance() {
		float range = abs(this.get_dist_max())-abs(this.get_dist_min());
		float dist = r.random_ratio(range, this.dist_proportion);
		return dist -abs(this.get_dist_min());
	}

	public float next_direction() {
		float range = abs(this.get_angle().x())+abs(this.get_angle().y());
		float angle = r.random_ratio(range, this.angle_proportion);
		return angle;
	}

	public void set_destination(vec dst, R_Node intersection) {
		// check if there is free slot on this intersection
		if(intersection == null || intersection.get_branch_available() > 0) {
			this.from.set(this.dst);
			this.dst.set(dst);
		} else {
			this.from.set(this.dst);
			// select destination in the pnal of destination of this intersection
			int which = floor(random(intersection.get_branch()));
			if(which < 0) which = 0;
			this.dst.set(intersection.get_destination()[which]);
		}
	}
  
  	// get
	// public int get_intersection() {
	// 	return intersection;
	// }

	public float get_speed() {
		return this.speed;
	}


	public vec2 get_dist_range() {
		return this.dist_range;
	}

	public vec2 get_angle() {
		return this.angle;
	}

	public float get_dist_max() {
		return this.dist_range.y();
	}

	public float get_dist_min() {
		return this.dist_range.x();
	}

	
	public vec3 get_pos() {
		return this.pos;
	}

	public vec3 get_from() {
		return this.from;
	}

	public vec3 get_destination() {
		return dst;
	}
}
