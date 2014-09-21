Veco.exec_file("../init.scd");
Veco.main.board_size = Point(32,64);
Pdef.defaultQuant = 1;

// END


TempoClock.default.tempo = t = ~t = 1;
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
~load_standard_quickpad.();
~load_standard_launchers.();

Veco.main.fadeout_time = 16;

