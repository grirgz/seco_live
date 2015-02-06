Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
~load_standard_quickpad.();


// END

Veco.main.board_size = Point(32,64);
~set_default_quant.(4);
~set_project_tempo.(1);

~define_effects.(['56','57','58','59']);
Veco.main.fadeout_time = 16;


