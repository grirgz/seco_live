TempoClock.default.tempo = t = ~t = 2.00;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
Veco.load_lib("samples.scd");
BufDef(\crepe, "field/crepe.flac");
~load_standard_quickpad.();
~kick1 = Veco('1').uname;

~tfx1 = Veco('57').uname+++\fx;
~fx1 = BusDef(~tfx1);

~tfx2 = Veco('56').uname+++\fx;
~fx2 = BusDef(~tfx2);

// END

Veco.main.fadeout_time = 16;

