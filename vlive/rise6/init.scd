TempoClock.default.tempo = t = 110/60;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
Veco.load_lib("samples.scd");
~load_standard_quickpad.();

// END

Veco.main.fadeout_time = 16;

(
~changetempo.(5,100/60)
)

blend(30, 1000, 0.9)
TempoClock.default.tempo = t = 90/60;
