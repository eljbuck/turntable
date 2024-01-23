// name: controller.ck
// ===================================================================
// author: Ethan Buck
// date: 11/11/2023
//
// desc: middle part of the turntable (with fader controls)
// ===================================================================

public class Controller extends GMesh {
    float w;
    float h;
    float sliderWidth;
    float sliderGripWidth;
    float faderHeight;
    float faderGripHeight;
    4 => int TEMPO_INCS;         // in positive direction (e.g. 
    float tempo_increment;
    8 => int VOL_INCS;
    float vol_increment;
    0 => int tempo_fader_pos;    // ranges from -TEMPO_INCS -> TEMPO_INCS
    0 => int vol_fader_pos;      // ranges from 0 - MAX_VOL_INC
    0 => int slider_pos;
    
    PlaneGeometry controller; FlatMaterial contMat; GMesh contMesh --> this;
    contMat.color( @(0.294,0.435,0.431) );
    contMesh.set(controller, contMat);
    
    PlaneGeometry slider; FlatMaterial sliderMat; GMesh sliderMesh --> this;
    sliderMat.color( @(0.133,0.243,0.243) );
    sliderMesh.set(slider, sliderMat);
    
    PlaneGeometry sliderGrip; FlatMaterial sliderGripMat; GMesh sliderGripMesh --> sliderMesh;
    sliderGripMat.color( @(0.988,0.404,0.0) );
    sliderGripMesh.set(sliderGrip, sliderGripMat);
    sliderGripMesh.posZ(.1);
    
    PlaneGeometry fader1; FlatMaterial fader1Mat; GMesh fader1Mesh --> this;
    fader1Mat.color( @(0.133,0.243,0.243) );
    fader1Mesh.set(fader1, fader1Mat);
    
    PlaneGeometry fader2; FlatMaterial fader2Mat; GMesh fader2Mesh --> this;
    fader2Mat.color( @(0.133,0.243,0.243) );
    fader2Mesh.set(fader2, fader2Mat);
    
    PlaneGeometry faderGrip; FlatMaterial faderGripMat; GMesh faderGrip1 --> fader1Mesh; GMesh faderGrip2 --> fader2Mesh;
    faderGripMat.color( @(0.988,0.404,0.0) );
    faderGrip1.set(faderGrip, faderGripMat);
    faderGrip2.set(faderGrip, faderGripMat);
    faderGrip1.posZ(0.1); faderGrip2.posZ(0.1);
    
    PlaneGeometry display; FlatMaterial displayMat; GMesh displayMesh --> this;
    displayMat.color( @(0.133,0.243,0.243) );
    displayMesh.set(display, displayMat);
    
    fun void init(float width) {
        width => w;
        1.15 * width => h;
        controller.set(w, h, 100, 100);
        0.8 * width => sliderWidth;
        0.025 * width => float sliderHeight;
        slider.set(sliderWidth, sliderHeight, 100, 100);
        sliderHeight * 2 => sliderGripWidth;
        sliderHeight * 4 => float sliderGripHeight;
        sliderGrip.set(sliderGripWidth, sliderGripHeight, 100, 100);
        0.4 * h => faderHeight;
        sliderHeight => float faderWidth;
        fader1.set(faderWidth, faderHeight, 100, 100);
        fader2.set(faderWidth, faderHeight, 100, 100);
        sliderGripHeight => float faderGripWidth;
        sliderGripWidth => faderGripHeight;
        faderGrip.set(faderGripWidth, faderGripHeight, 100, 100);
        sliderMesh.posY(.1 * h);
        fader1Mesh.posX(-(w / 4.5));
        fader1Mesh.posY(-.2 * h);
        fader2Mesh.posX(w / 4.5);
        fader2Mesh.posY(-.2 * h);
        faderGrip2.translateY(- (faderHeight / 2) + (faderGripHeight / 2));
        display.set(0.6 * w, 0.22 * h, 100, 100);
        displayMesh.posY(1.);
        (faderHeight - faderGripHeight) / VOL_INCS => vol_increment;
        (faderHeight - faderGripHeight) / TEMPO_INCS / 2 => tempo_increment;
    }
    
    fun int get_vol_fader_pos() {
        return vol_fader_pos;
    }
    
    // moves volume fader and returns percentage of total volume fader is at
    fun float vol_up() {
        if (vol_fader_pos < VOL_INCS) {
            faderGrip2.translateY(vol_increment);
            1 +=> vol_fader_pos;
        }
        return vol_fader_pos$float / VOL_INCS;
    }
    
    fun float vol_down() {
        if (vol_fader_pos > 0) {
            faderGrip2.translateY(-vol_increment);
            1 -=> vol_fader_pos;
        }
        return vol_fader_pos$float / VOL_INCS;
    }
    
    fun int tempo_up() {
        if (tempo_fader_pos < TEMPO_INCS) {
            faderGrip1.translateY(tempo_increment);
            1 +=> tempo_fader_pos;
        }
        return tempo_fader_pos; // returns distance from starting pos 
    }
    
    fun int tempo_down() {
        if (tempo_fader_pos > -TEMPO_INCS) {
            faderGrip1.translateY(- tempo_increment);
            1 -=> tempo_fader_pos;
        }
        return tempo_fader_pos;  // returns distance from starting pos 
    }
    
    fun int get_slider_pos() {
        return slider_pos;
    }
    
    fun void shift_slider_right() {
        if (slider_pos < 1) {
            sliderGripMesh.translateX(sliderWidth / 2 - sliderGripWidth / 2);
            1 +=> slider_pos;
        }
    }
    
    fun void shift_slider_left() {
        if (slider_pos > -1) {
            sliderGripMesh.translateX(-(sliderWidth / 2 - sliderGripWidth / 2));
            -1 +=> slider_pos;
        }
    }
    
    fun float width() {
        return w; 
    }
    fun float height() {
        return h;
    }
}