TempoClock.default.tempo = t = 65/60;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
~load_quick_quant_chooser.();

// END

Veco.main.fadeout_time = 16;

Veco.force_init;
