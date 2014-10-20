Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
~load_standard_quickpad.();

if(~t.isNil) {
	~t = TempoClock.default.tempo;
};

// END

TempoClock.default.tempo = 1;

Veco.main.fadeout_time = 16;

