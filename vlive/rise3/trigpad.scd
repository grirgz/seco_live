
(
~make_reverb_trigpad = { arg index;
	var modfreq = [4,8,16,32][index];
	~quant = 1/4;
	TempoClock.default.play ({
		Ndef(~masterfx+++\fx).set(\wet70, 0.5);
		nil;
	}, ~quant);
	Veco(~namex).response_off_hook = {
		TempoClock.default.play ({
			//~quant.wait;
			Ndef(~masterfx+++\fx).set(\wet70, 0);
			//Ndef(~masterfx+++\fx).set(\choose, 0);
			nil;
		}, [~quant, 1/4]);
	};

};

~make_wobble_trigpad = { arg index;
	var modfreq = [4,8,16,32][index];
	~quant = 1/4;
	TempoClock.default.play ({
		Ndef(~masterfx+++\fx).set(\wet60, 0.5);
		Ndef(~masterfx+++\fx).set(\ffreq, 1000);
		Ndef(~masterfx+++\fx).set(\modrange, 0.9);

		Ndef(~masterfx+++\fx).set(\modfreq, modfreq);
		nil;
	}, ~quant);
	Veco(~namex).response_off_hook = {
		TempoClock.default.play ({
			//~quant.wait;
			Ndef(~masterfx+++\fx).set(\wet60, 0);
			//Ndef(~masterfx+++\fx).set(\choose, 0);
			nil;
		}, [~quant, 1/4]);
	};

};
);

~set_exec_zone.(Rect(0,32, 32,64));

(
~offset = 36;
~set_fake_clip_row.(~offset+1, { arg clip, name, namex, index, x;
	~toggle_trig.(namex, {
		~patfx_mute.(name+++\patfx)
	}, {
		~patfx_unmute.(name+++\patfx)
	});
}, 0, 32);
~set_fake_clip_row.(~offset+2, { arg clip, name, namex, index, x;
	~insert_beat.(name+++\patfx, namex)
}, 0, 32);
~set_fake_clip_row.(~offset+3, { arg clip, name, namex, index, x;
	~patfx_gate.(name+++\patfx, Pbind(\isRest, true) ,namex)
}, 0, 32);
);


(
		Veco.main.clip.response_launcher_on_hook = { arg self, pos, opos, mod;
			var ev;
			var funs;
			var modfuns;
			[pos, opos, mod].debug("response_launcher_on_hook===");
			ev = ~launcher_lib;
			funs = [
				{Veco.main.clip_offset = Point(0,0)},
				{Veco.main.clip_offset = Point(8,0)},
				{Veco.main.clip_offset = Point(16,0)},
				{Veco.main.clip_offset = Point(16+8,0)},

				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+4)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+8)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+8+4)},
			];

			modfuns = [
				{Veco.main.clip_offset = Point(0,0)},
				{Veco.main.clip_offset = Point(8,0)},
				{Veco.main.clip_offset = Point(16,0)},
				//{ev.no_pane; Veco.main.clip_offset = Point(Veco.main.clip_offset.x,32+4)},
				{
					ev.mid_pane; 
					Veco.main.clip_offset = Point(Veco.main.clip_offset.x,		32+4);
					Veco.main.pane_offset = Point(Veco.main.clip_offset.x+8,	32+4);
				},

				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+4)},
				{ev.mid_pane},
				{ev.no_pane},
			];

			if(mod) {
				modfuns[pos.y].value;
			} {
				funs[pos.y].value;
			};
			Veco.main.clip.render_state;

		};
);


// END
