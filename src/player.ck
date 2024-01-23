// name: player.ck
// ====================================================================================
// author: Ethan Buck
// date: 11/11/2023
//
// desc: class that creates a record player geometry (with arm and needle) for turntable.ck
// ====================================================================================

// creates arm component of record player
class Arm extends GMesh {
    // angled arm geo
    PlaneGeometry arm;
    FlatMaterial armMat;
    armMat.color( @(1, 1, 1) );
    GMesh armMesh;
    armMesh.set(arm, armMat);
    armMesh --> this;
    // playhead arm geo
    PlaneGeometry playhead;
    FlatMaterial playheadMat;
    playheadMat.color( @(1, 1, 1) );
    GMesh playheadMesh;
    playheadMesh.set(playhead, armMat);
    playheadMesh --> this;
    // arm end geo
    PlaneGeometry end;
    FlatMaterial endMat;
    endMat.color( @(0.216,0.243,0.282) );
    GMesh endMesh;
    endMesh.set(end, endMat);
    endMesh --> armMesh;
    endMesh.posZ(.01);
    // needle geo
    PlaneGeometry needle;
    FlatMaterial needleMat;
    needleMat.color( @(0.216,0.243,0.282) );
    GMesh needleMesh;
    needleMesh.set(needle, needleMat);
    needleMesh --> playheadMesh;
    needleMesh.posZ(.01);
    // needle grip geo
    PlaneGeometry grip;
    FlatMaterial gripMat;
    gripMat.color( @(1, 1, 1) );
    GMesh gripMesh;
    gripMesh.set(grip, gripMat);
    gripMesh --> needleMesh;
    //gripMesh.posZ(.01);
    fun void init(float width, float height, float theta) {
        width / 1.25 => float playheadWidth;
        arm.set(width, height, 100, 100);
        armMesh.posX(width);
        armMesh.rotZ(-theta);
        (width/2) * Math.sin(theta) => float h;
        armMesh.translateY(h);
        armMesh.translateX(-(h / Math.tan(theta/2)));
        (height/2) * Math.sin(Math.pi - theta) => float k;
        armMesh.translateX(-k);
        // law of cosines lol
        Math.sqrt(2 * Math.pow((height / 2), 2) + (2 * Math.pow((height / 2), 2)) * Math.cos(Math.pi * 2 - theta)) => float s;
        s * Math.cos(theta / 2) => float b;
        armMesh.translateY(-b);
        playhead.set(playheadWidth, height, 100, 100);
        <<< width >>>;
        <<< playheadWidth >>>;
        <<< 1/3 * width >>>;
        playheadMesh.translateX((width - playheadWidth) / 2);
        // initialize end block
        width / 8 => float endWidth;
        end.set(endWidth, height * 5, 100, 100);
        endMesh.posX(- (width/2 - endWidth /2));
        // initialize needle
        width / 6 => float needleWidth;
        needle.set(needleWidth, height * 3, 100, 100);
        needleMesh.posX(-(playheadWidth/2 - needleWidth / 2));
        // initialize needle grip
        needleWidth / 1.5 => float gripWidth;
        grip.set(gripWidth, height / 1.5, 100, 100);
        gripMesh.rotZ(Math.pi / 4);
        gripMesh.posY(-1.5*height);
    }
}

// creates body of record player
class Player extends GMesh {
    PlaneGeometry plane;
    FlatMaterial planeMat;
    planeMat.color( @(0.341,0.514,0.51) );
    GMesh planeMesh;
    planeMesh.set(plane, planeMat);
    planeMesh --> this;
    CircleGeometry housing;
    FlatMaterial housingMat;
    housingMat.color( @(0, 0, 0) );
    GMesh housingMesh;
    housingMesh.set(housing, housingMat);
    housingMesh --> this;
    CircleGeometry mount;
    FlatMaterial mountMat;
    mountMat.color( @(0.216,0.243,0.282) );
    GMesh mountMesh;
    mountMesh.set(mount, mountMat);
    mountMesh --> housingMesh;
    mountMesh.posZ(0.00009);
    float width;
    float height;
    fun void scale(float factor) {
        1.75 * factor => width;
        width * 0.8 => height;
        plane.set(width, height, 100, 100);
        width / 15 => float radius;
        housing.set(radius, 100, 0, Math.pi*2);
        radius * 1.5 => float margin;
        housingMesh.posX(width / 2 - margin);
        housingMesh.posY(height / 2 - margin);
        mount.set(0.5 * radius, 100, 0, Math.pi*2);
    }
    fun float getWidth() {
        return width;
    }
    fun float getHeight() {
        return height;
    }    
}

// positions both together
public class RecordPlayer extends GMesh {
    Player player;
    Arm arm;
    fun void init(float factor) {
        player --> this;
        player.scale(factor * 1.5);
        arm --> player;
        arm.init(1.1 * factor, .035 * factor, (1.6 * Math.pi) / 3);
        arm.posX(0.75);
        arm.posZ(0.000008);
    }
    fun float width() {
        return player.getWidth();
    }
    fun float height() {
        return player.getHeight();
    }
}