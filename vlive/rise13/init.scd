//TempoClock.default.tempo = t = ~t = 128/60;
TempoClock.default.tempo = t = ~t = 128/60;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
~load_standard_quickpad.();

~define_effects.([\56, \57]);

// END

Veco.main.fadeout_time = 16;
