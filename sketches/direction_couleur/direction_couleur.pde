import java.util.Arrays;
int [] proportion;
int sum;
float normal_ratio;
float final_ratio;
int num_rect_by_bands = 10;
int num_bands = 5;


void setup() {
  size(600,600);
  colorMode(HSB,360,100,100);
  proportion = new int[] {1000,5,5,5,5,5,5,5,5,5,5,5};
  sum = Arrays.stream(proportion).sum();
  normal_ratio = 1.0 / sum;
  final_ratio = (float)g.colorModeX / (float)sum;
  println("normal ratio", normal_ratio);
  println("final ratio", final_ratio);

}


void draw() {
}

void keyPressed() {
  int hauteur = height / num_bands;
  for(int i = 0 ; i < num_bands ; i++) {

    colour_band(i *hauteur, hauteur, num_rect_by_bands);
  }
}


void colour_band(int pos_y, int hauteur, int max) {
  int largeur = width/max;
  for(int i = 0 ; i < max ; i++) {
    float value = random(sum);
    int which_part = 0;
    int count = 0;
    float in = 0;
    float out = 0;
    for(int j = 0 ; j < proportion.length ; j++) {
      in = count; 
      count += proportion[j];
      out = count;
      if(value < count) {
        which_part = j;
        break;
      } else {
        which_part = j;
      }
    }
    println("which part", which_part, in, out, sum);

    int c = color(value*final_ratio,100,100);
    strokeWeight(3);
    stroke(0);
    fill(c);
    rect(i*largeur, pos_y, largeur, hauteur);
  }
}