TempoClock.default.tempo = t = 120/60;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
Veco.load_lib("samples.scd");
~load_standard_quickpad.();

// END

Veco.main.fadeout_time = 16;

(
~changetempo.(5,130/60)
)

blend(30, 1000, 0.9)
