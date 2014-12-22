TempoClock.default.tempo = t = ~t = 73/60;
Veco.main.board_size = Point(32,64);
Pdef.defaultQuant = 2;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
~load_standard_quickpad.();

// END

~define_effects.(['56','57','58','59']);
Veco.main.fadeout_time = 16;

