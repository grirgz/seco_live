TempoClock.default.tempo = t = 161.5/60/2;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
Veco.load_file("synth.scd");
Veco.load_lib("samples.scd");
~load_standard_quickpad.();

MIDIBoard.map(\s9, s.volume, \volume);

// END

Veco.main.fadeout_time = 16;

