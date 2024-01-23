//-----------------------------------------------------------------------------
// name: run.ck
// desc: top-level program to run for turntable.ck
//
//-----------------------------------------------------------------------------

[
    "mouse.ck",
    "KB.ck",
    "instrument.ck",
    "gbutton.ck",
    "circles.ck",
    "vinyl.ck",
    "player.ck",
    "controller",
    "turntable.ck"
] @=> string files[];

for (auto file : files)
    Machine.add( me.dir() + file );