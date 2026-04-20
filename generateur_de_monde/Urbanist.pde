/**
* URBANIST
* v 0.0.4
*/
public class Urbanist {
	private vec3 pos;
	private vec3 dst;
	private vec3 from;
	private int intersection ;
	private vec2 range;
	private vec2 angle;
	
	public Urbanist() {
		this.pos = new vec3();
		this.from = new vec3();
		this.dst = new vec3();
		this.range = new vec2(0,height);
		this.angle = new vec2(-PI/2,PI/2);
	}
  
  	// set
	public void set_intersection(int intersection) {
		this.intersection = intersection;
	}

	public void set_range(float min, float max) {
		this.range.set(min,max);
	}

	public void set_angle(float start, float end) {
		this.angle.set(start,end);
	}

	public void set_pos(vec pos) {
		this.pos.set(pos);
	}

	public void set_destination(vec dst) {
		set_destination(dst,null);

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
			if(which < 0) {
				println("void set_destination() which",which);
				which = 0;
			}
			this.dst.set(intersection.get_destination()[which]);
		}

	}
  
	// get
	public int get_intersection() {
		return intersection;
	}


	public vec2 get_range() {
		return this.range;
	}

	public vec2 get_angle() {
		return this.angle;
	}

	public float get_max() {
		return this.range.y;
	}

		public float get_min() {
		return this.range.x;
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