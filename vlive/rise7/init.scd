TempoClock.default.tempo = t = ~t = 2.00;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
Veco.load_lib("samples.scd");
BufDef(\crepe, "field/crepe.flac");
~load_standard_quickpad.();
~kick1 = Veco('1').uname;
~tkick1 = Veco('1').uname;

~define_effects.(['56','57','58','59']);

// END

Veco.main.fadeout_time = 16;

Ndef(Veco('56').uname+++\fx).edit
Ndef(Veco('1').uname+++\mixer).edit
~fx1
~tfx1

