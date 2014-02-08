TempoClock.default.tempo = t = 160/60*0.5;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
~load_standard_quickpad.();
~swing = (1 + (0.19 * Pseq([-1,1],inf)));
~swing1 = Pn(Plazy({(1 + (~swingamp * Pseq(~swingspin,1)));}));
~swingamp = 0.37;
~swingspin = [1,0,-1, 0];

// END

Veco.main.fadeout_time = 16;

MidiBoard.map(\k1, )
