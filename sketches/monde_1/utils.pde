void background(vec4 c) {
  background(c.x,c.y,c.z,c.w) ;
}

void background(vec3 c) {
  background(c.x,c.y,c.z) ;
}

void background(vec2 c) {
  background(c.x,c.y) ;
}
// ivec
void background(ivec4 c) {
  background(c.x,c.y,c.z,c.w) ;
}

void background(ivec3 c) {
  background(c.x,c.y,c.z) ;
}

void background(ivec2 c) {
  background(c.x,c.y) ;
}





/**
background image
*/
void background(PImage src, int mode) {
  background_calc(src,null,null,null,null,mode);
}

void background(PImage src, int mode, float red, float green, float blue) {
  vec3 colour_curtain = r.abs(new vec3(red,green,blue).div(new vec3(g.colorModeX,g.colorModeY,g.colorModeZ)));
  background_calc(src,null,null,colour_curtain,null,mode);
}

void background(PImage src, float px, float py, float red, float green, float blue) {
  vec3 colour_curtain = r.abs(new vec3(red,green,blue).div(new vec3(g.colorModeX,g.colorModeY,g.colorModeZ)));
  vec2 pos = new vec2(px /width, py /height);
  background_calc(src,pos,null,colour_curtain,null,r.SCALE);
}

void background(PImage src, float px, float py, float scale_x, float red, float green, float blue) {
  vec3 colour_curtain = r.abs(new vec3(red,green,blue).div(new vec3(g.colorModeX,g.colorModeY,g.colorModeZ)));
  vec2 pos = new vec2(px /width, py /height);
  vec2 scale = new vec2(scale_x);
  background_calc(src,pos,scale,colour_curtain,null,r.SCALE);
}

void background(PImage src, float px, float py, float scale_x, float red, float green, float blue, float curtain_position) {
  vec3 colour_curtain = r.abs(new vec3(red,green,blue).div(new vec3(g.colorModeX,g.colorModeY,g.colorModeZ)));
  vec2 pos = new vec2(px /width, py /height);
  vec2 scale = new vec2(scale_x);
  vec4 curtain_pos = new vec4(curtain_position,0,curtain_position,0);
  background_calc(src,pos,scale,colour_curtain,curtain_pos,r.SCALE);
}

void background(PImage src, vec2 pos, vec2 scale, vec3 colour_background, vec4 pos_curtain, int mode) {
  background_calc(src,pos,scale,colour_background,pos_curtain,mode);
}



PShader img_shader_calc_rope;
void background_calc(PImage src, vec2 pos, vec2 scale, vec3 colour_background, vec4 pos_curtain, int mode) {
  boolean context_ok = false ;
  if(r.get_renderer(g).equals(P2D) || r.get_renderer(g).equals(P3D)) {
    context_ok = true;
  } else {
    r.print_err_tempo(180,"method background(PImage img) need context in P3D or P2D to work");
  }
  if(context_ok && src != null && src.width > 0 && src.height > 0) {
    if(img_shader_calc_rope == null) {
      img_shader_calc_rope = loadShader("shader/fx_post/image.glsl");
    }
    if(graphics_is(src).equals("PGraphics")) {
      img_shader_calc_rope.set("flip_source",false,false);
    } else {
      img_shader_calc_rope.set("flip_source",true,false);
    }
    
    img_shader_calc_rope.set("texture_source",src);
    img_shader_calc_rope.set("resolution",width,height);
    img_shader_calc_rope.set("resolution_source",src.width,src.height); 
    
    if(colour_background != null) {
      img_shader_calc_rope.set("colour",colour_background.x,colour_background.y,colour_background.z); // definr RGB color from 0 to 1
    }

    if(pos_curtain != null) {
      img_shader_calc_rope.set("curtain",pos_curtain.x,pos_curtain.y,pos_curtain.z,pos_curtain.w); // definr RGB color from 0 to 1
    }

    if(pos != null) {
      img_shader_calc_rope.set("position",pos.x,pos.y); // from 0 to 1
    }
    
    if(scale != null) {
      img_shader_calc_rope.set("scale",scale.x,scale.y);
    }
    
    int shader_mode = 0;
    if(mode == r.FIT) {
      shader_mode = 0;
    } else if(mode == SCREEN) {
      shader_mode = 1;
    } else if(mode == r.SCALE) {
      shader_mode = 2;
    }
    img_shader_calc_rope.set("mode",shader_mode);

    filter(img_shader_calc_rope);
  }
}



















String graphics_is(Object obj) {
  if(obj instanceof PGraphics) {
    return "PGraphics";
  } else if(obj instanceof PGraphics2D) {
    return "PGraphics";
  } else if(obj instanceof PGraphics3D) {
    return "PGraphics";
  } else if(obj instanceof PImage) {
    return "PImage";
  } else return null;
}















/*
* INPUT PART
* v 1.0.1
* 2017-2021
*/
import rope.tool.file.*;

R_Input rope_input;


void select_input() {
	select_input("default");
}

void select_input(String type) {
	if(rope_input == null) {
		rope_input = new R_Input(this);
	}
	rope_input.select_input(type);
}


String input_path() {
	return input_path("default");
}

String input_path(String type) {
	if(rope_input == null)
		rope_input = new R_Input(this);
	return rope_input.input_path(type);
}








import rope.image.R_Pattern;

R_Pattern rope_pattern;


void init_pattern() {
  if(rope_pattern == null) {
    rope_pattern = new R_Pattern(this); 
  }
}



PGraphics pattern_noise(int w, int h) {
  init_pattern();
  rope_pattern.build_matrix_noise_mono();
  return rope_pattern.map_mono(w, h);
}

PGraphics pattern_noise_xyz(int w, int h) {
  init_pattern();
  rope_pattern.build_matrix_noise_xyz();
  return rope_pattern.map_xyz(w, h);
}


/**
* Patttern noise
* inspired by Daniel Shiffman
* https://www.youtube.com/watch?v=8ZEMLCnn8v0
*/
@Deprecated
PGraphics pattern_noise(int w, int h, float... inc) {
  PGraphics pg;
  noiseSeed((int)random(MAX_INT));
  if(w > 0 && h > 0 && inc.length > 0 && inc.length < 5) {
    float [] cm = r.getColorMode(this.g, false);
    colorMode(RGB,255,255,255,255);
    pg = createGraphics(w,h);
    float offset_x [] = new float[inc.length];
    float offset_y [] = new float[inc.length];
    float component [] = new float[inc.length];
    float max [] = new float[inc.length];
    if(inc.length == 1) {
      max[0] = g.colorModeZ;
    } else if (inc.length == 2) {
      max[0] = g.colorModeZ;
      max[1] = g.colorModeA;
    } else if (inc.length == 3) {
      max[0] = g.colorModeX;
      max[1] = g.colorModeY;
      max[2] = g.colorModeZ;
    } else if (inc.length == 4) {
      max[0] = g.colorModeX;
      max[1] = g.colorModeY;
      max[2] = g.colorModeZ;
      max[3] = g.colorModeA;
    }
    colorMode((int)cm[0],cm[1],cm[2],cm[3],cm[4]);

    pg.beginDraw();
    for(int i = 0 ; i < inc.length ; i++) {
      offset_y[i] = 0;
    }
    
    for(int x = 0 ; x < w ; x++) {
      for(int i = 0 ; i < inc.length ; i++) {
        offset_x[i] = 0;
      }
      for(int y = 0 ; y < h ; y++) {
        for(int i = 0 ; i < inc.length ; i++) {
          component[i] = map(noise(offset_x[i],offset_y[i]),0,1,0,max[i]);
        }
        int c = 0;
        if(inc.length == 1) c = color(component[0]);
        else if (inc.length == 2) c = color(component[0],component[1]);
        else if (inc.length == 3) c = color(component[0],component[1],component[2]);
        else if (inc.length == 4) c = color(component[0],component[1],component[2],component[3]);

        pg.set(x,y,c);
        for(int i = 0 ; i < inc.length ; i++) {
          offset_x[i] += inc[i];
        }
      }
      for(int i = 0 ; i < inc.length ; i++) {
        offset_y[i] += inc[i];
      }
    }
    pg.endDraw();
    return pg;
  } else {
    r.print_err("method pattern_noise(): may be problem with size:",w,h,"\nor with component color num >>>",inc.length,"<<< must be between 1 and 4");
    return null;
  }
}










/**
* angle
* v 0.0.2
* @return float
*/
float angle_radians(float y, float range) {
  return map(y, 0,range, 0, TAU) ;
}

float angle_degrees(float y, float range) {
  return map(y, 0,range, 0, 360) ;
}

float angle(vec2 a, vec2 b) {
  return atan2(b.y -a.y, b.x -a.x);
}

float angle(vec2 v) {
  return atan2(v.y, v.x);
}















/**
* Method motion
* v 0.2.0
*/
/**
* follow
* v 0.3.1
* WARNING
* the argument buf is use to buffering ans store the position in most of case this value is set at like vec2() or vec3()
* but you can use to reset the starting position.
*/

vec2 follow(vec2 target, float speed, vec2 buf) {
  return follow(target.x(), target.y(), speed, speed, buf);
}

vec2 follow(vec2 target, vec2 speed, vec2 buf) {
  return follow(target.x(), target.y(), speed.x(), speed.y(), buf);
}

vec2 follow(float tx, float ty, float speed, vec2 buf) {
  return follow(tx, ty, speed, speed, buf);
}

vec2 follow(float tx, float ty, float sx, float sy, vec2 buf) {
  sx = check_speed_follow(sx);
  sy = check_speed_follow(sy);
  // calcul X pos
  float dx = tx - buf.x();
  if(abs(dx) != 0) {
    buf.add_x(dx * sx);
  }
  // calcul Y pos
  float dy = ty - buf.y();
  if(abs(dy) != 0) {
    buf.add_y(dy * sy);
  }
  return buf;
}

// vec3 follow
vec3 follow(vec3 target, float speed, vec3 buf) {
  return follow(target.x(), target.y(), target.z(), speed, speed, speed, buf);
}

vec3 follow(vec3 target, vec3 speed, vec3 buf) {
  return follow(target.x(), target.y(), target.z(), speed.x(), speed.y(), speed.z(), buf);
}


vec3 follow(float tx, float ty, float tz, float speed, vec3 buf) {
  return follow(tx, ty, tz, speed, speed, speed, buf);
}

vec3 follow(float tx, float ty, float tz, float sx, float sy, float sz, vec3 buf) {
  sx = check_speed_follow(sx);
  sy = check_speed_follow(sy);
  sz = check_speed_follow(sz);
  // calcul X pos
  float dx = tx - buf.x();
  if(abs(dx) != 0) {
    buf.add_x(dx * sx);
  }
  // calcul Y pos
  float dy = ty - buf.y();
  if(abs(dy) != 0) {
    buf.add_y(dy * sy);
  }
  // calcul Z pos
  float dz = tz - buf.z();
  if(abs(dz) != 0) {
    buf.add_z(dz * sy);
  }
  return buf;
}

float check_speed_follow(float speed) {
  if(speed < 0 || speed > 1) {
    r.print_err_tempo(120,"vec3 follow(): speed parameter must be a normal value between [0.0, 1.0]\n instead value 1 is attribute to speed");
    speed = 1.0;
  }
  return speed;
}





/**
CHECK
v 0.2.4
*/
/**
Check Type
v 0.0.4
*/
String get_type(Object obj) {
	if(obj instanceof Integer) {
		return "Integer";
	} else if(obj instanceof Float) {
		return "Float";
	} else if(obj instanceof String) {
		return "String";
	} else if(obj instanceof Double) {
		return "Double";
	} else if(obj instanceof Long) {
		return "Long";
	} else if(obj instanceof Short) {
		return "Short";
	} else if(obj instanceof Boolean) {
		return "Boolean";
	} else if(obj instanceof Byte) {
		return "Byte";
	} else if(obj instanceof Character) {
		return "Character";
	} else if(obj instanceof PVector) {
		return "PVector";
	} else if(obj instanceof vec) {
		return "vec";
	} else if(obj instanceof ivec) {
		return "ivec";
	} else if(obj instanceof bvec) {
		return "bvec";
	} else if(obj == null) {
		return "null";
	} else return "Unknow" ;
}








import rope.colour.R_Colour;

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
* pixel array
*/
int index_pixel_array(int x, int y, int w) {
	return (x + y * w);
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
	int index = index_pixel_array(x, y, pg.width);
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
	int index, tx, ty = 0;

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
