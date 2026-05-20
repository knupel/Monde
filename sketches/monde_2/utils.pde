/**
MISC
v 0.0.6
*/
/**
stop trhead draw by using loop and noLoop()
*/
boolean freeze_is ;
void freeze() {
	freeze_is = (freeze_is)? false:true;
	if (freeze_is)  {
		noLoop();
	} else {
		loop();
	}
}




/**
* palette
* v 0.0.2
*/
R_Colour palette_colour_rope;
void palette(int... list_colour) {
	if(palette_colour_rope == null) {
		palette_colour_rope = new R_Colour(this,list_colour);
	} else {
		palette_colour_rope.clear();
		palette_colour_rope.add(0,list_colour);
	}
}

int [] get_palette() {
	if(palette_colour_rope != null) {
		return palette_colour_rope.get();
	} else return null;
}





/**
* plot
* v 0.2.0
* set pixel color with alpha and PGraphics management 
*/
boolean use_plot_x2_is = false;
void use_plot_x2(boolean is) {
	use_plot_x2_is = is;
}

void plot(vec2 pos, int colour) {
	plot((int)pos.x(), (int)pos.y(), colour, 1.0, g);
}

void plot(vec2 pos, int colour, PGraphics pg) {
	plot((int)pos.x(), (int)pos.y(), colour, 1.0, pg);
}

void plot(vec2 pos, int colour, float alpha) {
	plot((int)pos.x(), (int)pos.y(), colour, alpha, g);
}

void plot(vec2 pos, int colour, float alpha, PGraphics pg) {
	plot((int)pos.x(), (int)pos.y(), colour, alpha, pg);
}

void plot(int x, int y, int colour) {
	plot(x, y, colour, 1.0, g);
}

void plot(int x, int y, int colour, PGraphics pg) {
	plot(x, y, colour, 1.0, pg);
}

void plot(int x, int y, int colour, float alpha) {
	plot(x, y, colour, alpha, g);
}

void plot(int x, int y, int colour, float alpha, PGraphics pg) {
	int index = r.index_pixel_array(x, y, pg.width);
	if(index >= 0 && index < pg.pixels.length && x >= 0 && x < pg.width) {
		int bg = pg.pixels[index];
		int col = colour;
		if(alpha < 1) {
			col = mixer(bg,colour,alpha);
		} 
		pg.pixels[index] = col;
		if(use_plot_x2_is) {
			Integer [] arr = new Integer[calc_plot_neighbourhood(index, x, y, pg.width, pg.height).size()];
			arr = calc_plot_neighbourhood(index, x, y, pg.width, pg.height).toArray(arr);
			for(int which_one : arr) {
				pg.pixels[which_one] = col;
			}
		}
	}
}

ArrayList<Integer> calc_plot_neighbourhood(int index_base, int x, int y, int w, int h) {
	ArrayList<Integer> arr = new ArrayList<Integer>();
	int index = 0;

	if(x < w -1) {
		index = index_base + 1;
		arr.add(index);
	}
	if(x > 0) {
		index = index_base - 1;
		arr.add(index);
	}
	if(y < h -1) {
		index = index_base + w;
		arr.add(index);
	}
	if(y > 0) {
		index = index_base - w;
		arr.add(index);
	}
	return arr;
}



/**
* mixer
* v 0.0.3
* mix color together with the normal threshold variation
*/
int mixer(int src, int dst, float threshold) {
	if(g.colorMode == RGB) {
		float x = gradient_value(red(src),red(dst),threshold);
		float y = gradient_value(green(src),green(dst),threshold);
		float z = gradient_value(blue(src),blue(dst),threshold);
		return color(x,y,z);
	} else {
		float x = gradient_value(hue(src),hue(dst),threshold);
		float y = gradient_value(saturation(src),saturation(dst),threshold);
		float z = gradient_value(brightness(src),brightness(dst),threshold);
		return color(x,y,z);
	}
}

int mixer_xyza(int src, int dst, float threshold) {
	float a = gradient_value(alpha(src),alpha(dst),threshold);
	if(g.colorMode == RGB) {
		float x = gradient_value(red(src),red(dst),threshold);
		float y = gradient_value(green(src),green(dst),threshold);
		float z = gradient_value(blue(src),blue(dst),threshold);
		return color(x,y,z,a);
	} else {
		float x = gradient_value(hue(src),hue(dst),threshold);
		float y = gradient_value(saturation(src),saturation(dst),threshold);
		float z = gradient_value(brightness(src),brightness(dst),threshold);
		return color(x,y,z,a);
	}
}

float gradient_value(float src, float dst, float threshold) {
	float gradient = src;
	float range = src - dst;
	float power = range * threshold;
	return gradient - power;
}