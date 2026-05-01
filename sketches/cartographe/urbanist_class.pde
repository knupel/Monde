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
	private vec2 dist;
	private int [] dist_proportion;
	// angle / direction
	private vec2 angle;
	private int [] angle_proportion;
	// intersection
	private ivec2 intersection;
	private int [] intersection_proportion;
	private float speed;
	
	public Urbanist() {
		// the speed walk of the agent on the map
		this.speed = 0.5;
		// position on the map
		this.pos = new vec3();
		this.from = new vec3();
		this.dst = new vec3();
		// intersection / careffour setting
		this.intersection = new ivec2(2,7);
		// must be proportiona to the number of branch here 7 - 2 = 5 +1 = 6
		this.intersection_proportion = new int[] {64,32,16,8,4,2}; 
		// distance to go for the next roap
		this.dist = new vec2(0,height);
		this.dist_proportion = new int[] {64,32,16,8,4,2,1};
		// direction to take when a new intersection is create
		this.angle = new vec2(-PI,PI);
		this.angle_proportion = new int[] {1,2,3,4,5,6,7,6,5,4,3,2,1};
	}
  
  	/**
	* distance management
	*/
	public void set_dist_range(float min, float max) {
		this.dist.set(min,max);
	}

	public void set_dist_proportion(int [] arr) {
		this.dist_proportion = arr;
	}

	public float next_distance() {
		float range = abs(this.get_dist_max())-abs(this.get_dist_min());
		float dist = r.random_ratio(range, this.dist_proportion);
		return dist -abs(this.get_dist_min());
	}

	public vec2 get_dist_range() {
		return this.dist;
	}

	public float get_dist_max() {
		return this.dist.y();
	}

	public float get_dist_min() {
		return this.dist.x();
	}






	/**
	* angle and direction management
	*/
	public void set_angle(float start, float end) {
		this.angle.set(start,end);
	}

	public void set_angle_proportion(int [] arr) {
		this.angle_proportion = arr;
	}

	public float next_direction() {
		float range = abs(this.get_angle().x())+abs(this.get_angle().y());
		float angle = r.random_ratio(range, this.angle_proportion);
		return angle;
	}

	public vec2 get_angle() {
		return this.angle;
	}


	/**
	* Intersetion management
	 */

	public float get_ways_min() {
		return this.intersection.x();
	}

	public float get_ways_max() {
		return this.intersection.y();
	}

	public int how_many_ways() {
		float range = abs(this.intersection.x())-abs(this.intersection.y());
		int result = floor(r.random_ratio(range, this.intersection_proportion));
		return result + this.intersection.x();
	}

	public void set_intersection_ways(int [] arr) {
		this.intersection_proportion = arr;
	}


  	/**
	* position, destination, speed of the urbanist
	*/
	public void set_pos(vec pos) {
		this.pos.set(pos);
	}

	public void set_destination(vec dst) {
		set_destination(dst,null);
	}

	public void set_speed(float speed) {
		this.speed = speed;
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
  


	public float get_speed() {
		return this.speed;
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
