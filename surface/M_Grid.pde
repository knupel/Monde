
/**
GRID
2019-2019
v 0.1.0
build a normal grid from 0 to 1
*/
abstract class Grid {
	protected ArrayList <vec4>grid;
	private ivec3 canvas;
	private float size;

	
	Grid() {
		grid = new ArrayList<vec4>();
	}

	public ArrayList<vec4> get() {
		return grid;
	}

	public int length() {
		if(grid != null) {
			return grid.size();
		} else return -1;
	}

	public float  get_cell_size() {
		return size;
	}

	public void set_cell_size(float size) {
		this.size = size;
	}

	public void clear() {
		grid.clear();
	}

	ivec3 get_canvas() {
		return canvas;
	}

	public void canvas(int w, int h, int d, int size) {
		// here we calculate the real side and median not the normalize one
		float side = size *sqrt(3);
		float median = side *(sqrt(3) *.5);

		int cols = floor(w/size);
		int rows = floor(h/median);
		int depth = 0;

		if(d > 0) {
			depth = floor(d/size);
		}
		if(canvas == null) {
			canvas = ivec3(cols,rows,depth);
		} else {
			canvas.set(cols,rows,depth);
		}
	}
	//
}







/**
* Grid2D
*
*/
public class Grid2D extends Grid {
	

	public Grid2D() {
		super();
	}

	public float get_size() {
		return get_cell_size()*2;
	}


  public void type_d(int w, int h, int size, float start_angle) {
  	type_d(w,h,0,size,start_angle);

  }

	public void type_d(int w, int h, int d, int size, float start_angle) {
		clear();
/*
		vec2 canvas_normal = vec2(1);
		if(w > h) {
			canvas_normal.y = h /(float)w;
		} else {
			canvas_normal.x = w /(float)h;
		}
		*/
		set_cell_size((float)size/w);

	  float side = get_cell_size() *sqrt(3); // find the length of triangle side
	  float median = side *(sqrt(3) *.5); // find the length of the mediane equilateral triangle
		canvas(w,h,d,size);
 
	  float angle;
    vec4 pos = vec4();
	  for(int y = 0 ; y < get_canvas().y ; y++) {
	    float offset_y = median * y;
	    float offset_x ;
	    if(y%2 == 0 ) {
	    	offset_x = 0 ; 
	    } else {
	    	offset_x = side *.5;
	    }
	    for(int x = 0 ; x < get_canvas().x ; x++) {
	      if(x%2 == 0) {
	        angle = start_angle;
	        // correction of the triangle position to have a good line
	        float offset_y_2 = (get_cell_size()*2) -median ; 
	        pos.y = get_cell_size() -offset_y_2 + offset_y;
	      } else {
	        pos.y = get_cell_size() +offset_y ;
	        angle = start_angle +PI;
	      }
	      pos.x = x *(side *.5) +offset_x ; 
	      
	      grid.add(vec4(pos.x,pos.y,0,angle));
	      
	    }
	  }
	}

public void type_c(int w, int h, int size, float start_angle, float offset) {
  	type_c(w,h,0,size,start_angle,offset);

  }
  
	public void type_c(int w, int h, int d, int size, float start_angle, float offset) {
		clear();

		set_cell_size((float)size/w);

	  float side = get_cell_size() *sqrt(3); // find the length of triangle side
	  float median = side *(sqrt(3) *.5); // find the length of the mediane equilateral triangle
		canvas(w,h,d,size);
    
    float inc_x = 1. / get_canvas().x;
		float inc_y = 1. / get_canvas().y;
    float offset_normal_x = inc_x *.5;
		float offset_normal_y = inc_y *.5;

    for(float y = 0 ; y < get_canvas().y ; y++) {
			for(float x = 0 ; x < get_canvas().x ; x++) {
				float cx = x / get_canvas().x + offset_normal_x;
				float cy = y / get_canvas().y + offset_normal_y;
				float angle = start_angle;
				for(int i = 0 ; i < 6 ; i++) {
					angle += PI/3;
					float px = cos(angle) *(inc_x *offset);
					float py = sin(angle) *(inc_y *offset);
					float pw = 0;
					if(i%2 == 0) {
						pw = PI;
					}
					grid.add(vec4(cx+px,cy+py,0,pw));
				}	
			}
		}
	}
  
	public void type_b(int w, int h, int size, float offset) {
  	type_b(w,h,0,size,offset);
  }
  
	public void type_b(int w, int h, int d, int size, float offset) {
		clear();

		set_cell_size((float)size/w);

	  float side = get_cell_size() *sqrt(3); // find the length of triangle side
	  float median = side *(sqrt(3) *.5); // find the length of the mediane equilateral triangle
		canvas(w,h,d,size);
    
    float inc_x = 1. / get_canvas().x;
		float inc_y = 1. / get_canvas().y;
    float offset_normal_x = inc_x *.5;
		float offset_normal_y = inc_y *.5;

		float unit_y = inc_y *offset;
		int count = 0;

    for(float y = 0 ; y < get_canvas().y ; y++) {
			for(float x = 0 ; x < get_canvas().x ; x++) {
				float px = x / get_canvas().x + offset_normal_x;
				float py = y / get_canvas().y + offset_normal_y;
				// barycenter position
				if(count%2 == 0) {
					py += unit_y;
				} else {
					py -= unit_y;
				}
	      
	      // direction
				grid.add(vec4(px,py,0,0));
				count++;
			}
		}
	}

	public void type_a(int w, int h, int size) {
  	type_a(w,h,0,size);
  }
  
	public void type_a(int w, int h, int d, int size) {
		clear();

		set_cell_size((float)size/w);

	  float side = get_cell_size() *sqrt(3); // find the length of triangle side
	  float median = side *(sqrt(3) *.5); // find the length of the mediane equilateral triangle
		canvas(w,h,d,size);
    
    float inc_x = 1. / get_canvas().x;
		float inc_y = 1. / get_canvas().y;
    float offset_normal_x = inc_x *.5;
		float offset_normal_y = inc_y *.5;

		float unit_y = inc_y *offset;
		int count = 0;

    for(float y = 0 ; y < get_canvas().y ; y++) {
			for(float x = 0 ; x < get_canvas().x ; x++) {
				float px = x / get_canvas().x + offset_normal_x;
				float py = y / get_canvas().y + offset_normal_y;
				grid.add(vec4(px,py,0,0));
				count++;
			}
		}
	}
	//
}