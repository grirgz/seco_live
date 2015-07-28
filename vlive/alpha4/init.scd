
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");

Veco.main.board_size = Point(32,64);
~set_default_quant.(4);
~set_project_tempo.(1.6);
~load_standard_quickpad.();

// END

Veco.main.fadeout_time = 16;

