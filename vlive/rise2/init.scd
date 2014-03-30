TempoClock.default.tempo = t = 1.4;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
Veco.exec_file("trigpad.scd");

~load_standard_quickpad.();


// END
Pdef('6pre').fadeTime=0

Veco.main.fadeout_time = 16;

1.4 *64
1/1.4
64/1.4
