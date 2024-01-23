// name: vinyl.ck
// ==============================================================
// author: Ethan Buck
// date: 11/07/2023
//
// desc: class to construct a vinyl object, used by turntable


// class to build a record
public class Record extends GGen {
    // radius
    float rad;
    // outer geo
    CircleGeometry outer;
    FlatMaterial outerMat;
    outerMat.color( @(0, 0, 0) );
    GMesh outerMesh;
    outerMesh.set(outer, outerMat);
    outerMesh --> this;
    // inner geo
    CircleGeometry inner;
    FlatMaterial innerMat;
    GMesh innerMesh;
    innerMat.color( @(0.643,0.761,0.765) );
    innerMesh.set(inner, innerMat);
    innerMesh --> this;
    // hole geo
    CircleGeometry hole;
    FlatMaterial holeMat;
    GMesh holeMesh;
    holeMat.color( @(1, 1, 1) );
    holeMesh.set(hole, holeMat);
    holeMesh --> this;
    // playhead geo
    FlatMaterial triMat;
    triMat.color( @(0, 0, 0) );
    GMesh triMesh;
    CircleGeometry triangle;
    triMesh.set(triangle, triMat);
    triMesh --> this;
    // num of lines for circle (more = smoother)
    500 => int num_seg;
    
    // given polar coords, returns cartesian x coord
    fun float get_x(float theta, float r) {
        return r * Math.cos(theta);
    }
    
    // given polar coords, returns cartesian y coord
    fun float get_y(float theta, float r) {
        return r * Math.sin(theta);
    }
    
    // initializes record geometry
    fun void init(float radius, int num_insts, int num_beats, Mouse @ mouse, GButton buttons[][], vec3 color_map[][], Instrument @ instrument[][]) {
        radius => rad;
        // initialize outer disc
        outer.set(radius, num_seg, 0, Math.pi * 2);
        radius / 3 => float inner_radius;
        // initialize inner disk
        inner.set(inner_radius, num_seg, 0, Math.pi * 2);
        // initialize triangle playhead indicator
        radius / 16 => float tri_radius;
        triangle.set(radius / 16, 3, 0, Math.pi * 2);
        triMesh.posX(inner_radius - tri_radius);
        // initialize hole
        hole.set(tri_radius, 100, 0, Math.pi * 2);
        // button radius
        (radius - inner_radius) / (2 * (num_insts + 1)) => float but_radius;
        // topmost position of button
        radius - but_radius => float upper_bound;
        // bottommost position of button
        inner_radius + but_radius => float lower_bound;
        // *** initialize all buttons: ***
        for (0 => int i; i < buttons.size(); 1 +=> i) {
            for (0 => int j; j < buttons[i].size(); 1 +=> j) {
                buttons[i][j] --> this;
                buttons[i][j].init(mouse, but_radius, color_map[color_map.size() - i - 1], instrument[i][j]);
                j * Math.pi / (num_beats / 2) => float theta;
                // calculate distance from center (starting from end, working inwards)
                inner_radius + (i + 1) * ((radius - inner_radius) / (num_insts + 1)) => float r;
                buttons[i][j].posX(get_x(theta, r));
                buttons[i][j].posY(get_y(theta, r));
                buttons[i][j].posZ(.000002); 
            }
        }
        // texture geos
        Circle textures[num_insts * 2];
        // initialize texture:
        for (0 => int i; i < textures.size(); 1 +=> i) {
            textures[i] --> outerMesh;
            textures[i].init(720, inner_radius + (i + 1) * ((radius - inner_radius) / ((num_insts * 2) + 1)));
            textures[i].posZ(0.0000015);
            textures[i].color( @(0.35, 0.35, 0.35) );
        }
    }
    fun float radius() {
        return rad;
    }
    0 => int active;
    fun void set_active(int i) {
        i => active;
    }
    fun int is_active() {
        return active;
    }
    0 => int spinning;
    fun void set_spin(int i) {
       i => spinning;
    }
    fun int is_spinning() {
        return spinning;
    }
}
