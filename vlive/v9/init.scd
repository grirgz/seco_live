Veco.load_lib("main.scd");
Pdef.defaultQuant = 4;
TempoClock.default.tempo = 1.4;
Veco.main.board_size = Point(16,64);
Veco.main.fadeout_time = 16;
~load_standard_quickpad.();

// END
Pdef.defaultQuant = 1;
TempoClock.default.tempo = 1;
