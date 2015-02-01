
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");

Veco.main.board_size = Point(16,64);
~set_default_quant.(1);
~set_project_tempo.(1);
~load_standard_quickpad.();

// END

~define_effects.(['56','57','58','59']);
Veco.main.fadeout_time = 16;

TempoClock.default.tempo = 1;
Pdef.defaultQuant = 1;
// END

