TempoClock.default.tempo = t = 65/60;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 8;
Veco.load_lib("main.scd");
Veco.load_file("synthpool.scd");
~load_standard_quickpad.();

Veco.main[\in_stop_exclusion_range] = { arg x; x.inclusivelyBetween(16,24) };

BufDef(\donkey, "bruit1/06_donkeys-eating-hay.flac");

// END

Veco.main.fadeout_time = 16;

Veco.force_init
