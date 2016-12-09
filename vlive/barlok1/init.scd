Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");

Veco.main.board_size = Point(32,64);
~set_default_quant.(4);
~set_project_tempo.(80/60);
~load_standard_quickpad.();

ParamProto.init(true);

FileSystemProject.load("barlok1/lib.scd");
//FileSystemProject.load("lib/piano.scd");

// END

Veco.main.fadeout_time = 16;

