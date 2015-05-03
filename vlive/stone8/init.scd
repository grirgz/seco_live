TempoClock.default.tempo = t = ~t = 1;
Veco.main.board_size = Point(32,64);
Pdef.defaultQuant = 2;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
~load_standard_quickpad.();


// END

~eu.(28,5).asInteger

~define_effects.(['56','57','58','59']);
Veco.main.fadeout_time = 16;

~macro

Ndef(\plop).asString.asCompileString
