TempoClock.default.tempo = t = 1;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
~load_quick_quant_chooser.();
~load_quick_editors.();
Veco.load_file("1.scd");


// END

Veco.main.fadeout_time = 16;

