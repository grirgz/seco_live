TempoClock.default.tempo = t = 1;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
//Veco(\1).execute;
Veco.load_file("synthpool.scd");
~load_standard_quickpad.();


// END

Veco.main.fadeout_time = 16;

Pdef.defaultQuant = 1;
