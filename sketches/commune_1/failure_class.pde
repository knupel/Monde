
/**
* Class R_Fail
* 2026-2026
* v 0.0.1
*/

public class R_Fail extends R_Graphic {
    private ArrayList<R_Line2D> lines;
    private int count_lines;

    public R_Fail(PApplet pa) {
        super(pa);
        lines = new ArrayList();
    }


    public void add_line(vec2 a, vec2 b, int c) {
        count_lines++;
		R_Line2D line = new R_Line2D(this.pa, a,b);
		line.id_a(c);
		line.palette(c);
		lines.add(line);
	}

    public void clear_count() {
        count_lines = 0;
    }

    public int get_count_lines() {
        return count_lines;
    }


    public ArrayList<R_Line2D> get_lines() {
        return lines;
    }

    public void clear_lines() {
        lines.clear();
    }

}