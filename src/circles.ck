// circle.ck
// ====================================================
// author: Ge Wang and Andrew Zhu Aday
// 
// desc: class to get 2d outline textures on record
public class Circle extends GGen
{
    // for drawing our circle 
    GLines circle --> this;
    // randomize rate
    Math.random2f(2,3) => float rate;
    // default color
    color( @(.5, 1, .5) );
    // initialize a circle
    fun void init( int resolution, float radius )
    {
        // incremental angle from 0 to 2pi in N steps
        2*pi / resolution => float theta;    
        // positions of our circle
        vec3 pos[resolution];
        // previous, init to 1 zero
        @(radius,0) => vec3 prev;
        // loop over vertices
        for( int i; i < pos.size(); i++ )
        {
            // rotate our vector to plot a circle
            // https://en.wikipedia.org/wiki/Rotation_matrix
            Math.cos(theta)*prev.x - Math.sin(theta)*prev.y => pos[i].x;
            Math.sin(theta)*prev.x + Math.cos(theta)*prev.y => pos[i].y;
            // just XY here, 0 for Z
            0 => pos[i].z;
            // remember v as the new previous
            pos[i] => prev;
        }
        
        // set positions
        circle.geo().positions( pos );
    }
    
    fun void color( vec3 c )
    {
        circle.mat().color( c );
    }
}