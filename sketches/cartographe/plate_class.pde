/**
* class R_Plate
* v 0.0.1
* 2026-2026
*/


public class R_Plate extends Rope {
    private R_Lithos grid[];
    private ivec2 size;
    private ivec2 cell;
    private int radius;
    private int cols;
    private int rows;;
    // ivec2 step = new ivec2(1);
    public R_Plate(ivec2 size, ivec2 cell) {
        super();
        // global size of the plate
        this.size = size.copy();
         // global size for each cell of the place
        int cx = cell.x();
        int cy = cell.y();
        if(cx%2 != 0) cx+=1;
        if(cy%2 != 0) cy+=1;
        this.cell = new ivec2(cx,cy);
        // radius of the plate cell for quick compute for further operation
        this.radius = this.cell.sum()/4;

        cols = size.x()/this.cell.x() + 1; // un peu bizarre, mais ça permets de faire les bordures
        rows = size.y()/this.cell.y() + 2; // juste bizarre de rajouter 2, mais ça permets de faire les bordures
        int num = cols * rows + rows;

        grid = new R_Lithos[num];
        int pos_x = 0;
        int pos_y = 0;
        boolean first_is = true;
        //
        for(int i = 0 ; i < num ; i++) {
            if(pos_x > cols) {
                first_is = false;
                pos_x = 0;
            }
            if(pos_x == 0 && !first_is) pos_y++;
            grid[i] = new R_Lithos();
            grid[i].pos(pos_x * this.cell.x(), pos_y * this.cell.y(),0);
            grid[i].radius(radius);
            int elements = floor(random(100));
            grid[i].set_sol(elements);
            pos_x++;
        }
    }


    public R_Lithos [] get() {
        return grid;
    }


    public R_Lithos get(int x, int y) {
        println("x/y",x,y);
        int nx = x / cell.x();
        int ny = y / cell.y();
        int index = index_pixel_array(nx, ny, cols + 1);
        if(index >= 0 && index < grid.length) return grid[index];
        return null;
    }

}