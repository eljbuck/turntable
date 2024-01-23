// name: turntable.ck
// ======================================================================================
// author: Ethan Buck
// date: 11/07/2023
//
// desc: A music sequencer controlled by spinning records. Click on buttons to activate
// their sound and shift between the two discs to make some music!
// ======================================================================================


// Initialize Mouse Manager =============================================================
Mouse mouse;
spork ~ mouse.start(0);  // start listening for mouse events
spork ~ mouse.selfUpdate(); // start updating mouse position

// Global Sequencer Params ==============================================================
32 => int NUM_BEATS_ONE;     // number of subdivisions for record 1
16 => int NUM_BEATS_TWO;     // number of subdivisions for record 2
87 => float HOME_BPM;        // middle position on tempo fader
HOME_BPM => float CURR_BPM;         // global tempo in beats per minute
5 => int NUM_INSTS_ONE;      // number of button levels for record 1
4 => int NUM_INSTS_TWO;      // number of button levels for record 2
(60/CURR_BPM)*4::second => dur PERIOD;     // duration for 4 beats
0.6 => float MAX_GAIN;                // time remaining until next period starts
0 => float CURRENT_GAIN;
// color map for buttons
[ [@(0.341, 0.094, 0.035), @(1, 0, 0)],
  [@(0.349,0.18,0.012),  @(1, 0.5, 0)],
  [@(0.341,0.29,0.0),      @(1, 1, 0)],
  [@(0.008,0.204,0.125),   @(0, 1, 0)],
  [@(0.075,0.161,0.259),   @(0, 0, 1)],
  [@(0.137,0.078,0.231), @(0.5, 0, 1)] ] @=> vec3 color_map[][];

 
 
// Global Control Flow ==================================================================
-1 => global int ON_FLAG;
-1 => global int PAUSE_FLAG;

// Global Audio Control =================================================================
Gain music => JCRev rev => dac;
Gain scratchy => dac;
CURRENT_GAIN => music.gain;
CURRENT_GAIN => scratchy.gain;
0.075 => rev.mix;

// Instrument Setup =====================================================================
class Kick extends Instrument {
    me.dir() + "vsts/kick.wav" => string filename;
    SndBuf buf => Envelope e => outlet;
    0.5 => buf.gain;
    filename => buf.read;
    fun void play() {
        e.keyOn();
        0 => buf.pos;
        buf.length() => now;
        e.keyOff();
    }
}

class Snare extends Instrument {
    me.dir() + "vsts/snare.wav" => string filename;
    SndBuf buf => Envelope e => outlet;
    0.25 => buf.gain;
    filename => buf.read;
    fun void play() {
        e.keyOn();
        0 => buf.pos;
        buf.length() => now;
        e.keyOff();
    }
}

class OpenHat extends Instrument {
    me.dir() + "vsts/openhat.wav" => string filename;
    SndBuf buf => Envelope e => outlet;
    0.25 => buf.gain;
    filename => buf.read;
    fun void play() {
        e.keyOn();
        0 => buf.pos;
        buf.length() => now;
        e.keyOff();
    }
}

class ClosedHat extends Instrument {
    me.dir() + "vsts/closedhat.wav" => string filename;
    SndBuf buf => Envelope e => outlet;
    0.5 => buf.gain;
    filename => buf.read;
    fun void play() {
        e.keyOn();
        0 => buf.pos;
        buf.length() => now;
        e.keyOff();
    }
}

class Rim extends Instrument {
    me.dir() + "vsts/rim.wav" => string filename;
    SndBuf buf => Envelope e => outlet;
    0.7 => buf.gain;
    filename => buf.read;
    fun void play() {
        e.keyOn();
        0 => buf.pos;
        buf.length() => now;
        e.keyOff();
    }
}

class BassD extends Instrument {
    me.dir() + "vsts/bass_d.wav" => string filename;
    SndBuf buf => Envelope e => outlet;
    0.5 => buf.gain;
    filename => buf.read;
    fun void play() {
        e.keyOn();
        0 => buf.pos;
        buf.length() => now;
        e.keyOff();
    }
}

class BassB extends Instrument {
    me.dir() + "vsts/bass_b.wav" => string filename;
    SndBuf buf => Envelope e => outlet;
    0.5 => buf.gain;
    filename => buf.read;
    fun void play() {
        e.keyOn();
        0 => buf.pos;
        buf.length() => now;
        e.keyOff();
    }

}

class BassF extends Instrument {
    me.dir() + "vsts/bass_f.wav" => string filename;
    SndBuf buf => Envelope e => outlet;
    0.5 => buf.gain;
    filename => buf.read;
    fun void play() {
        e.keyOn();
        0 => buf.pos;
        buf.length() => now;
        e.keyOff();
    }
}

class BassE extends Instrument {
    me.dir() + "vsts/bass_e.wav" => string filename;
    SndBuf buf => Envelope e => outlet;
    0.5 => buf.gain;
    filename => buf.read;
    fun void play() {
        e.keyOn();
        0 => buf.pos;
        buf.length() => now;
        e.keyOff();
    }    
}

class PadD extends Instrument {
    me.dir() + "vsts/pad_d.wav" => string filename;
    SndBuf buf => Envelope e => outlet;
    0.5 => buf.gain;
    filename => buf.read;
    fun void play() {
        e.keyOn();
        0 => buf.pos;
        buf.length() => now;
        e.keyOff();
    }   
}

class PadB extends Instrument {
    me.dir() + "vsts/pad_b.wav" => string filename;
    SndBuf buf => Envelope e => outlet;
    0.5 => buf.gain;
    filename => buf.read;
    fun void play() {
        e.keyOn();
        0 => buf.pos;
        buf.length() => now;
        e.keyOff();
    }   
}

class PadF extends Instrument {
    me.dir() + "vsts/pad_f.wav" => string filename;
    SndBuf buf => Envelope e => outlet;
    0.5 => buf.gain;
    filename => buf.read;
    fun void play() {
        e.keyOn();
        0 => buf.pos;
        buf.length() => now;
        e.keyOff();
    }   
}

class PadE extends Instrument {
    me.dir() + "vsts/pad_e.wav" => string filename;
    SndBuf buf => Envelope e => outlet;
    0.5 => buf.gain;
    filename => buf.read;
    fun void play() {
        e.keyOn();
        0 => buf.pos;
        buf.length() => now;
        e.keyOff();
    }   
}

class Scratch extends Instrument {
    me.dir() + "scratch.wav" => string filename;
    SndBuf buf => Envelope e => outlet;
    0.5 => buf.gain;
    filename => buf.read;
    buf.loop(1);
    fun void play() {
        e.keyOn();
        0 => buf.pos;
        // ADD LOOP SOUND
        while (PAUSE_FLAG > 0) {
            10::ms => now;
        }
        e.keyOff();
    }
}

Scratch scratch => scratchy;
Kick kicks[NUM_BEATS_ONE];
Snare snares[NUM_BEATS_ONE];
Rim rims[NUM_BEATS_ONE];
OpenHat open_hats[NUM_BEATS_ONE];
ClosedHat closed_hats[NUM_BEATS_ONE];
BassB bass_bs[NUM_BEATS_TWO];
PadB pad_bs[NUM_BEATS_TWO];
PadD pad_ds[NUM_BEATS_TWO];
BassD bass_ds[NUM_BEATS_TWO];


[ kicks, snares, rims, closed_hats, open_hats ] @=> Instrument drum_map[][];
[ bass_bs, pad_bs, bass_ds, pad_ds] @=> Instrument harm_map[][];

fun void initialize_map(Instrument map[][], Gain main) {
    for (0 => int i; i < map.size(); 1 +=> i) {
        for (0 => int j; j < map[i].size(); 1 +=> j) {
            map[i][j] => main;
        }
    }
}
spork ~initialize_map(drum_map, music);
spork ~initialize_map(harm_map, music);

// Scene Setup ==========================================================================
GG.camera() --> GG.scene();
// set bg color
GG.scene().backgroundColor( @(0.745,0.686,0.557) );
// orthographic
GG.camera().orthographic();


// Record Setup ==========================================================================
GButton buttons1[NUM_INSTS_ONE][NUM_BEATS_ONE];  // 2D array for buttons on first record
GButton buttons2[NUM_INSTS_TWO][NUM_BEATS_TWO];  // 2D array for buttons on second record

RecordPlayer player1 --> GG.scene(); 
player1.init(1.7);
player1.rotZ(Math.pi / 2);
RecordPlayer player2 --> GG.scene(); 
player2.init(1.7);
player2.rotZ(Math.pi / 2);
Controller controller --> GG.scene();
controller.init(0.65 * player1.width());
player1.posX(-(controller.width() / 2 + player1.height() / 2));
player2.posX(controller.width() / 2 + player1.height() / 2);
controller.posY(-(player1.width() / 2 - controller.height() / 2));

Record record1 --> player1;
record1.init(1.75, NUM_INSTS_ONE, NUM_BEATS_ONE, mouse, buttons1, color_map, drum_map);
(player1.height() - (record1.radius() * 2)) / 2 => float margin;
record1.posX((-player1.width() / 2) + record1.radius() + margin);

Record record2 --> player2;
record2.init(1.75, NUM_INSTS_TWO, NUM_BEATS_TWO, mouse, buttons2, color_map, harm_map);
record2.posX((-player2.width() / 2) + record2.radius() + margin);

// Waveform Set Up =======================================================================
dac => Gain input;
256 => int WINDOW_SIZE;
input => Flip accum => blackhole;
WINDOW_SIZE => accum.size;
Windowing.hann(WINDOW_SIZE) @=> float window[];
GLines waveform --> controller;
waveform.mat().color( @(0.988,0.404,0.0) );
waveform.posY(1.0);
waveform.sca( @(1.12, 1, 1) ); 
1.0 => float WAV_AMPLITUDE;

float samples[0];
vec3 positions[WINDOW_SIZE];

// map audio buffer to 3D positions
fun void map2waveform( float in[], vec3 out[] )
{
    if(in.size() != out.size() )
    {
        <<< "size mismatch in map2waveform()", "">>>;
        return;
    }
    // mapping to xyz coordinate
    int i;
    1.55 => float width;
    for( auto s: in )
    {
        // space evenly in X
        -width/2 + width/WINDOW_SIZE*i => out[i].x;
        // map frequency bin magnitude in Y
        s*WAV_AMPLITUDE*window[i] => out[i].y;
        // constant 0 for Z here
        0 => out[i].z;
        // increment
        i++;
    }
}

//do audio stuff
fun void doAudio()
{
    while ( true )
    {
        // upchuck to process accum
        accum.upchuck();
        // get the last window size samples (waveform)
        accum.output( samples );
        //jump by samples
        WINDOW_SIZE::samp/2 => now;
    }
}
spork ~ doAudio();

// Sequencing Logic ======================================================================

// phaser control flow
fun void control_sequence() {
    while (true) {
        if (ON_FLAG < 0) {
            record1.set_active(0);
            record2.set_active(0);
        } else if (controller.get_slider_pos() == 0) {
            record1.set_active(1);
            record2.set_active(1);
        } else if (controller.get_slider_pos() == 1) {
            record1.set_active(0);
            record2.set_active(1);
        } else if (controller.get_slider_pos() == -1) {
            record1.set_active(1);
            record2.set_active(0);
        }
        1::ms => now;
    }
}
spork ~ control_sequence();

//
fun dur pause(Record record) {
    0::ms => dur elapsed;
    record.set_spin(0);
    record.rot() => vec3 pos;
    spork ~ scratch.play();
    while (PAUSE_FLAG > 0) {
        if (record.is_active()) {
            record.rotZ(Math.random2f(pos.z + 0.001, pos.z + 0.005));            
        }
        50::ms => now;
        if (record.is_active()) {
            record.rotZ(Math.random2f(pos.z - 0.001, pos.z - 0.005));   
        }
        50::ms => now;
        100::ms +=> elapsed;
    }
    record.rot(pos);
    record.set_spin(1);
    return elapsed;
}

// given an column of buttons on the record (int j) and a button map, this function plays
// all of the active buttons
fun void play_active_insts(int j, GButton buttons[][]) {
    for (0 => int i; i < buttons.size(); 1 +=> i) {
        if (buttons[i][j].active()) {
            spork ~ buttons[i][j].instrument.play();
        }
    }
}

// plays one period of a given record
fun void sequence_one_cycle(Record record, GButton buttons[][], int NUM_BEATS, dur STEP) {
    for (0 => int i; i < NUM_BEATS; 1 +=> i) {
        play_active_insts(i, buttons);
        now + STEP => time end;
        while (now < end) {
            if (PAUSE_FLAG > 0) {
                pause(record) +=> end;
            }
            1::ms => now;
        }
    }
}

// rotates given record one cycle 
fun void rotate_one_cycle(Record record) {
    record.set_spin(1);
    now + PERIOD => time end;
    while (now < end) {
        if (PAUSE_FLAG > 0) {
            pause(record) +=> end;
        }
        1 - (end - now) / PERIOD => float progress;
        record.rotZ(-2*Math.pi * progress);
        10::ms => now;
    }
    record.rotZ(0);
}

// controls rotation/sequencing of records according to control_sequence()
fun void rotate(Record record, GButton buttons[][], int NUM_BEATS) {
    while (true) {
        PERIOD / NUM_BEATS => dur STEP;
        if (record.is_active()) {
            spork ~ sequence_one_cycle(record, buttons, NUM_BEATS, STEP);
            spork ~ rotate_one_cycle(record);
        } else {
            record.set_spin(0);
        }
        now + PERIOD => time end;
        while (now < end) {
            if (PAUSE_FLAG > 0) {
                music.gain(0);
                pause(record) +=> end;
                music.gain(CURRENT_GAIN);
            }
            1::ms => now;
        }
    }
}
spork ~rotate(record1, buttons1, NUM_BEATS_ONE);
spork ~rotate(record2, buttons2, NUM_BEATS_TWO);

fun void print_status() {
        <<< "ON_FLAG:", ON_FLAG >>>; 
        <<< "record1 activity:", record1.is_active() >>>;
        <<< "record2 activity:", record2.is_active() >>>;
        <<< "record1 spinning:", record1.is_spinning() >>>;
        <<< "record2 spinning:", record2.is_spinning() >>>;
        <<< "controller position:", controller.get_slider_pos() >>>;
}
// spork ~print_status();

fun void detect_space() {
    while (true) {
        if (KB.isKeyDown(KB.KEY_SPACE)) {
            -1 *=> ON_FLAG;
        }
        250::ms => now;
    }
}
spork ~ detect_space();

fun void detect_p() {
    while (true) {
        if (KB.isKeyDown(KB.KEY_P)) {
            -1 *=> PAUSE_FLAG;
            <<< PAUSE_FLAG >>>;
        }
        250::ms => now;
    }
}
spork ~ detect_p();

fun void detect_right() {
    while (true) {
        if (KB.isKeyDown(KB.KEY_RIGHT)) {
            controller.shift_slider_right();
        }
        250::ms => now;
    }
}
spork ~ detect_right();

fun void detect_left() {
    while (true) {
        
        if (KB.isKeyDown(KB.KEY_LEFT)) {
            controller.shift_slider_left();
        }
        250::ms => now;
    }
}
spork ~ detect_left();

fun void update_tempo() {
    while (true) {
        (60/CURR_BPM)*4::second => PERIOD;     // duration for 4 beats
        PERIOD => now;
    }
}
spork ~ update_tempo();

// want tempo to increase 10 bpm from current tempo
fun void detect_t_up() {
    while (true) {
        
        while (KB.isKeyDown(KB.KEY_T)) {
            if (KB.isKeyDown(KB.KEY_UP)) {
                controller.tempo_up() * 10 + HOME_BPM => CURR_BPM;
            }
            100::ms => now;
        }
        250::ms => now;
    }
}
spork ~ detect_t_up();

fun void detect_t_down() {
    while (true) {
        
        while (KB.isKeyDown(KB.KEY_T)) {
            if (KB.isKeyDown(KB.KEY_DOWN)) {
                controller.tempo_down() * 10 + HOME_BPM => CURR_BPM;
            }
            100::ms => now;
        }
        250::ms => now;
    }
}
spork ~ detect_t_down();


// max volume is 0.6
fun void detect_v_up() {
    while (true) {
        
        while (KB.isKeyDown(KB.KEY_V)) {
            if (KB.isKeyDown(KB.KEY_UP)) {
                MAX_GAIN * controller.vol_up() => CURRENT_GAIN;
                music.gain(CURRENT_GAIN);
                scratchy.gain(CURRENT_GAIN);
            }
            100::ms => now;
        }
        250::ms => now;
    }
}
spork ~ detect_v_up();

fun void detect_v_down() {
    while (true) {
        
        while (KB.isKeyDown(KB.KEY_V)) {
            if (KB.isKeyDown(KB.KEY_DOWN)) {
                MAX_GAIN * controller.vol_down() => CURRENT_GAIN;
                music.gain(CURRENT_GAIN);
                scratchy.gain(CURRENT_GAIN);
            }
            100::ms => now;
        }
        250::ms => now;
    }
}
spork ~ detect_v_down();


// Game Loop =============================================================================
while (true) { 
    if (ON_FLAG > 0) {
        waveform --> controller;
        map2waveform(samples, positions);
        waveform.geo().positions(positions);
    } else {
        waveform --< controller;
    }
    GG.nextFrame() => now; }