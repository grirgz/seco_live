


(
		~set_exec_zone.(Rect(0,32, 32+16,64));
		Veco.main.clip.response_launcher_on_hook = { arg self, pos, opos, mod;
			var ev;
			var funs;
			[pos, opos, mod].debug("response_launcher_on_hook===");
			ev = ~launcher_lib;
			funs = [
				{Veco.main.clip_offset = Point(0,Veco.main.clip_offset.y)},
				{Veco.main.clip_offset = Point(8,Veco.main.clip_offset.y)},
				{Veco.main.clip_offset = Point(16,Veco.main.clip_offset.y)},
				{Veco.main.clip_offset = Point(24,Veco.main.clip_offset.y)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+4)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+8)},
				{ev.no_pane},
			];

			funs[pos.y].value;
			Veco.main.clip.render_state;

		};
);

(
4.do { arg x;
	var row = 32 + x;
	var fxname;
	var fxnum;
	var quant = 1/2;
	var delays = [1/2,1/4,1/8,1/32];
	x = x +1;
	fxnum = 4;
	fxname = currentEnvironment[\tfx+++fxnum];

	~set_fake_clip_row.(row, { arg clip, name, namex, index;
		//TempoClock.default.play ({
			Ndef(fxname).set(\delay, delays[x-1] );
			Ndef(fxname).set(\fb, 1.5 );
			Ndef(name+++\mixer).set(\send+++fxnum, 1);
			nil;
		//}, quant);
		Veco(namex).response_off_hook = {
			//TempoClock.default.play ({
				//~quant.wait;
				Ndef(fxname).set(\fb, 0.8 );
				Ndef(name+++\mixer).set(\send+++fxnum, 0);
				nil;
			//}, [quant, 1/2]);
		};

	})
}
);


(
4.do { arg x;
	var row = 32 + x;
	var fxname;
	var fxnum;
	var quant = 1/2;
	var delays = [1/2,1/4,1/8,1/32];
	x = x +1;
	fxnum = 4;
	fxname = currentEnvironment[\tfx+++fxnum];

	~set_fake_clip_row.(row, { arg clip, name, namex, index;
		//TempoClock.default.play ({
			Ndef(fxname).set(\delay, delays[x-1] );
			Ndef(name+++\mixer).set(\send+++fxnum, 1);
			nil;
		//}, quant);
		Veco(namex).response_off_hook = {
			//TempoClock.default.play ({
				//~quant.wait;
				Ndef(name+++\mixer).set(\send+++fxnum, 0);
				nil;
			//}, [quant, 1/2]);
		};

	},0,16);
}
);

