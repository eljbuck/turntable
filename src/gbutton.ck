// name: gbutton.ck
// ====================================================================
// author: Andrew Zhu Aday (modified by Ethan Buck
// date: 11/11/2023 
//
// desc: class for button objects that are placed on vinyl for turntable.ck
// ============================================================================ 
public class GButton extends GGen {
    // initialize mesh
    CircleGeometry button;
    float radius;
    FlatMaterial buttonMat;
    GMesh buttonMesh;
    buttonMesh.set(button, buttonMat);
    buttonMesh --> this;
    
    // initialize instrument
    Instrument @ instrument;
    
    // reference to a mouse
    Mouse @ mouse;
    
    // events
    Event onHoverEvent, onClickEvent;  // onExit, onRelease
    
    // states
    0 => static int NONE;  // not hovered or active
    1 => static int HOVERED;  // hovered
    2 => static int ACTIVE;   // clicked
    3 => static int PLAYING;  // makine sound!
    0 => int state; // current state
    
    // input types
    0 => static int MOUSE_HOVER;
    1 => static int MOUSE_EXIT;
    2 => static int MOUSE_CLICK;
    3 => static int NOTE_ON;
    4 => static int NOTE_OFF;
    
    vec3 colorMap[2];
    
    // constructor
    fun void init(Mouse @ m, float rad, vec3 colors[], Instrument @ inst) {
        if (mouse != null) return;
        m @=> this.mouse;
        rad => radius;
        inst @=> instrument;
        button.set(radius, 100, 0, 2 * Math.pi);
        for (0 => int i; i< 2; 1 +=> i) {
            colors[i] => colorMap[i];
        }
        spork ~ this.clickListener();
    }
    
    // check if state is active (i.e. should play sound)
    fun int active() {
        return state == ACTIVE;
    }
    
    fun vec3 worldPos() {
        return this.posWorld();
    }
    
    // set color
    fun void color(vec3 c) {
        buttonMat.color(c);
    }
    
    // returns true if mouse is hovering over pad
    fun int isHovered() {
        buttonMesh.posWorld() => vec3 worldPos;
        Math.pow((worldPos.x - mouse.worldPos.x), 2) + Math.pow((worldPos.y - mouse.worldPos.y), 2) => float dist;
        if (dist <= Math.pow(radius, 2)) {
            return true;
        }
        return false;
    }
    
    // poll for hover events
    fun void pollHover() {
        if (isHovered()) {
            onHoverEvent.broadcast();
            handleInput(MOUSE_HOVER);
        } else {
            if (state == HOVERED) handleInput(MOUSE_EXIT);
        }
    }
    
    // handle mouse clicks
    fun void clickListener() {
        now => time lastClick;
        while (true) {
            mouse.mouseDownEvents[Mouse.LEFT_CLICK] => now;
            if (isHovered()) {
                onClickEvent.broadcast();
                handleInput(MOUSE_CLICK);
            }
            100::ms => now; // cooldown
        }
    }
    
    // plays designated instrument sound when clicked
    fun void play_click() {
        while (true) {
            onClickEvent => now;
            instrument.play();
        }
    }
    spork ~play_click();
    
    // activate pad, meaning it should be played when the sequencer hits it
    fun void activate() {
        enter(ACTIVE);
    }
    
    0 => int lastState;
    // enter state, remember last state
    fun void enter(int s) {
        state => lastState;
        s => state;
    }
    
    // basic state machine for handling input
    fun void handleInput(int input) {
        if (input == NOTE_ON) {
            enter(PLAYING);
            return;
        }
        
        if (input == NOTE_OFF) {
            enter(lastState);
            return;
        }
        
        if (state == NONE) {
            if (input == MOUSE_HOVER)      enter(HOVERED);
            else if (input == MOUSE_CLICK) enter(ACTIVE);
        } else if (state == HOVERED) {
            if (input == MOUSE_EXIT)       enter(NONE);
            else if (input == MOUSE_CLICK) enter(ACTIVE);
        } else if (state == ACTIVE) {
            if (input == MOUSE_CLICK)      enter(NONE);
        } else if (state == PLAYING) {
            if (input == MOUSE_CLICK)      enter(NONE);
            if (input == NOTE_OFF)         enter(ACTIVE);
        }
    }
    
    // override ggen update
    fun void update(float dt) {
        // check if hovered
        pollHover();
        
        // update state
        if (state >= 2) {
            this.color(colorMap[1]);
        } else {
            this.color(colorMap[0]);
        }
    }
}
