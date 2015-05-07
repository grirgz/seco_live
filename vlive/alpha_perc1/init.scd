Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
Veco.load_lib("samples_slices.scd");

Veco.main.board_size = Point(8,64);
//~set_default_quant.(4);
~set_project_tempo.(~t ? 1);
~load_standard_quickpad.();

// END

Veco.main.fadeout_time = 16;

