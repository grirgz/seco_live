TempoClock.default.tempo = t = ~t = 80/60;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
~load_standard_quickpad.();


// END
~enable_clip_automation = false;
~enable_clip_automation = true;

Veco.main.fadeout_time = 16;

8.do { arg x; var n; n=Veco.main.get_node_by_index(x); n.mixer_mode=\premix2; n.make_mixer }
