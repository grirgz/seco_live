TempoClock.default.tempo = t = 1;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
~load_quick_quant_chooser.();
~load_quick_editors.();
//Veco(\1).execute;
Veco.load_file("synthpool.scd");


// END

Veco.main.fadeout_time = 16;

Pdef.defaultQuant = 1;
