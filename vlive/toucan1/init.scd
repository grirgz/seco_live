Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
Veco.load_file("drumkit.scd");

Veco.main.board_size = Point(32,64);
~set_default_quant.(8);
~set_project_tempo.(160/60);
~load_standard_quickpad.();

// END

Veco.main.fadeout_time = 16;

~t
Pdef.defaultQuant
Ndef.defaultQuant
