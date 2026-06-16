/**
* Utils
* v 0.1.0.
*/





// freeze sketch
boolean freeze_is ;
void freeze() {
	freeze_is = (freeze_is)? false:true;
	if (freeze_is)  {
		noLoop();
	} else {
		loop();
	}
}

// fix fullScreen bug with few devices
import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;
import java.awt.Rectangle;
void secure_screen_place() {
  GraphicsEnvironment environment = GraphicsEnvironment.getLocalGraphicsEnvironment();
  GraphicsDevice[] devices = environment.getScreenDevices();
  Rectangle rect = devices[sketchDisplay() -1].getDefaultConfiguration().getBounds();
  surface.setLocation(0,0);
  int x = (int)rect.getX();
  int y = (int)rect.getY();
  println("repositionnement", x, y);
  surface.setLocation(x,y);
}