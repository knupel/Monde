void setup() {
  size(400,400);
}

int buf_x = 0;
int buf_y = 0;
int x = 0;
int y = 0;
boolean mouse_clicked = false;

void draw() {
  if(mousePressed) {
    x = mouseX - buf_x;
    y = mouseY - buf_y;
  } else {
    x = y = 0;
  }
  println("X", x, mouseX);
  println("Y", y, mouseY);
}

void mouseReleased() {
  mouse_clicked = false;
  buf_x = mouseX;
  buf_y = mouseY;
}
  
void mousePressed() {
  if(!mouse_clicked) {
    buf_x = mouseX;
    buf_y = mouseY;
  }
  mouse_clicked = true;
}
