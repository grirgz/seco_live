TempoClock.default.tempo = t = 160/60*0.5;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
~load_standard_quickpad.();
~swing = (1 + (0.19 * Pseq([-1,1],inf)));
~swing1 = Pn(Plazy({(1 + (~swingamp * Pseq(~swingspin,1)));}));
~swingamp = 0.37;
~swingspin = [1,0,-1, 0];

~tfx1 = '32';
~fx1 = BusDef(~tfx1);

(
~make_fx_gate1 = {

	var index = ~index;
	index = index + 100;
	Ndef(~name+++\mixer).put(index, \filter -> { arg in; Out.ar(BusDef(\mangle), in); in; });
	Ndef(~name+++\mixer).set(\xfade, 1);

	~index.debug("delire!!!");
	Veco.do { arg name, namex;
		Veco(~namex).response_off_hook = {
			//var index = Veco.main.uname_to_index(name);
			Ndef(name+++\mixer).set(\xfade, 0.5);
			index.debug("remove!!");
			//Ndef(\mangle).removeAt(index)
			Ndef(name+++\mixer).removeAt(index);
		};
	};
	Veco(~namex).response_mode = \exec;
}
);

(
8.do { arg x;
	8.do { arg y;
		Veco.main.clip.abspos_to_buf(Point(x,y)+Point(0,32)).response_mode = \exec;
	}
}
);

(
Veco.main.clip.response_launcher_on_hook = { arg self, pos, opos, mod;
	var ev;
	var funs;
	[pos, opos, mod].debug("response_launcher_on_hook===");
	ev = (
		no_pane: { arg self;
			debug("no_pane!");
			Veco.main.pane_rect = Rect(100,100,100,100);
		},
		mid_pane: { arg self;
			debug("mid_pane!");
			Veco.main.pane_rect = Rect(0,4,8,8);
		},
	);
	funs = [
		{Veco.main.clip_offset = Point(0,0)},
		{Veco.main.clip_offset = Point(8,0)},
		{ev.no_pane; Veco.main.clip_offset = Point(Veco.main.clip_offset.x,32)},
		{ev.mid_pane; Veco.main.clip_offset = Point(Veco.main.clip_offset.x,0)},

		{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32)},
		{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+4)},
		nil,
		{ev.no_pane},
	];

	funs[pos.y].value;
	Veco.main.clip.render_state;

};
);

// END

Veco.main.fadeout_time = 16;

MidiBoard.map(\k1, )
Veco.force_init
