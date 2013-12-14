TempoClock.default.tempo = t = 65/60;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.load_file("synthpool.scd");
~load_standard_quickpad.();

// END

Veco.main.fadeout_time = 16;

Veco.force_init;
