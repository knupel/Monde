
/**
GRID
2019-2019
v 0.0.1
build a normal grid from 0 to 1
*/
abstract class Grid {
	ArrayList <vec4>grid;
	Grid() {
		grid = new ArrayList<vec4>();
	}

	ArrayList<vec4> get() {
		return grid;
	}

	void clear() {
		grid.clear();
	}

}


public class Grid2D extends Grid {
	float size;

	public Grid2D() {
		super();
	}

	float get_size() {
		return size;
	}

	void type_d(float size, float start_angle) {
		type_d(0,0,size,start_angle);
	}

		void type_d(int cols, int rows, float start_angle) {
		type_d(cols,rows,0,start_angle);
	}


	void type_d(int cols, int rows, float size, float start_angle) {
		clear();
		vec2 canvas = vec2(1);
	  vec4 pos = vec4();
	  if(size ==0) {
      this.size = 1./cols;
	  } else {
	  	this.size = size;
	  }
	  
	  // define geometric data
	  float radius = size ;
	  float side = this.size *sqrt(3) ; // find the length of triangle side
	  float median = side *(sqrt(3) *.5) ; // find the length of the mediane equilateral triangle
	  
	  float angle;
	  float max_y = 0;
	  float max_x = 0;
	  if(cols == 0 && rows == 0) {
	  	max_y = canvas.y/median;
	  	max_x = canvas.x/side*2;
	  } else {
	  	max_y = rows;
 			max_x = cols;
	  }

	  for(int y = 0 ; y < max_y ; y++) {
	    float offset_y = median * y;
	    float offset_x ;
	    if(y%2 == 0 ) {
	    	offset_x = 0 ; 
	    } else {
	    	offset_x = side *.5;
	    }
	    for(int x = 0 ; x < max_x ; x++) {
	      if(x%2 == 0) {
	        angle = start_angle;
	        // correction of the triangle position to have a good line
	        float offset_y_2 = (this.size*2) -median ; 
	        pos.y = this.size -offset_y_2 + offset_y;
	      } else {
	        pos.y = this.size +offset_y ;
	        angle = start_angle +PI;
	      }
	      pos.x = x *(side *.5) +offset_x ; 
	      
	      grid.add(vec4(pos.x,pos.y,0,angle));
	      
	    }
	  }
	}

	public void type_c(int cols, int rows, float start_angle, float offset) {
		clear();
		float inc_x = 1./cols;
		float inc_y = 1./rows;
		size = inc_x *offset;
		float offset_x = inc_x *.5;
		float offset_y = inc_y *.5;

		for(float y = 0 ; y < 1 ; y += inc_y) {
			for(float x = 0 ; x < 1 ; x += inc_x) {
				float cx = x+offset_x;
				float cy = y+offset_y;
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
  
	public void type_b(int cols, int rows, float offset) {
		clear();
		float inc_x = 1./cols;
		float inc_y = 1./rows;
		float offset_x = inc_x *.5;
		float offset_y = inc_y *.5;

		float unit_y = inc_y *offset;
		int count = 0;
		for(float y = 0 ; y < 1 ; y += inc_y) {
			for(float x = 0 ; x < 1 ; x += inc_x) {
				float px = x+offset_x;
				float py = y+offset_y;

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

	public void type_a(int cols, int rows) {
		clear();
		float inc_x = 1./cols;
		float inc_y = 1./rows;
		float offset_x = inc_x *.5;
		float offset_y = inc_y *.5;
		for(float y = 0 ; y < 1 ; y += inc_y) {
			for(float x = 0 ; x < 1 ; x += inc_x) {
				float px = x+offset_x;
				float py = y+offset_y;
				grid.add(vec4(px,py,0,0));
			}
		}
	}
	//
}