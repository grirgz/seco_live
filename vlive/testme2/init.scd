TempoClock.default.tempo = t = 1;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
~load_quick_quant_chooser.();

// END

Veco.main.fadeout_time = 16;

TempoClock.default.tempo = t = ~t = 1;
Veco.main.board_size = Point(32,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
~load_standard_quickpad.();


~define_effects.(['56','57','58','59']);
Veco.main.fadeout_time = 16;

