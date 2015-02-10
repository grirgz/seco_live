Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
Veco.load_lib("samples_slices.scd");

Veco.main.board_size = Point(32,64);
~set_default_quant.(4);
~set_project_tempo.(70/60);
~load_standard_quickpad.();

// END

~define_effects.(['56','57','58','59']);
Veco.main.fadeout_time = 16;

