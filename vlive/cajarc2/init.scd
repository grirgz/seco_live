TempoClock.default.tempo = t = ~t = 1;
//TempoClock.default.tempo = t = ~t = 126/60/2;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
~load_standard_quickpad.();

// END

Veco.main.fadeout_time = 16;
Veco.gui
