TempoClock.default.tempo = t = ~t = 128/60;
Veco.main.board_size = Point(32,64);
Pdef.defaultQuant = 8;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
~load_standard_quickpad.();
BufDef.mono(\rocksteady, "vipere/rocksteady.flac");

// END

Veco.main.fadeout_time = 16;

