

(
		~set_exec_zone.(Rect(0,32, 32+16,64));
		Veco.main.clip.response_launcher_on_hook = { arg self, pos, opos, mod;
			var ev;
			var funs;
			[pos, opos, mod].debug("response_launcher_on_hook===");
			ev = ~launcher_lib;
			funs = [
				{Veco.main.clip_offset = Point(0,0)},
				{Veco.main.clip_offset = Point(8,0)},
				{ev.no_pane; Veco.main.clip_offset = Point(Veco.main.clip_offset.x,32+4)},
				{
					ev.mid_pane; 
					Veco.main.clip_offset = Point(Veco.main.clip_offset.x,		32+4);
					Veco.main.pane_offset = Point(Veco.main.clip_offset.x+8,	32+4);
				},

				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+4)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+8)},
				{ev.no_pane},
			];

			funs[pos.y].value;
			Veco.main.clip.render_state;

		};
);

// END

(
~set_fake_clip_row.(33, { arg clip, name, namex, index, x;
	//Ndef(~fxcomb+++\fx).set(\delaytime, 1/(2**x)/t)
	index.debug("kkjkkkk");
	[name, namex, index].debug("set_fake_clip_row");
	~clip_fx_gate.('34fx', clip, 33);
});

2.do { arg fx;
	var row = 34;
	var rowfx = 34 + fx;
	var buskey = ~fxbufstut+++\fx;
	fx = fx +1;

	~set_fake_clip_row.(rowfx, { arg clip, name, namex, index;
			Ndef(name+++\mixer).put(row, \filter -> { arg in; Out.ar(BusDef(buskey), in); in; });
			Ndef(name+++\mixer).set(\xfade, 1);
			Ndef(buskey).set(\choose, fx);
			clip.response_off_hook = {
				Ndef(name+++\mixer).set(\xfade, 0.5);
				Ndef(buskey).set(\choose, 0);
				Ndef(name+++\mixer).removeAt(row);
			};
	})
}
);

// END

~set_fake_clip_row.(33, { arg clip, name, namex, index, x;
	Ndef(~fxcomb+++\fx).set(\delaytime, 1/(2**x)/t)
});

8.do { arg x;
	var row = 33;
	var node = Veco.main.clip.abspos_to_buf(Point(x, row));
	node[\execute] = { arg self;
		Ndef(~fxcomb+++\fx).set(\delaytime, 1/(2**x)/t)
	};
	node.is_present = true;
};

	8.do { arg x;
		var row = 34;
		var rowfx = 34 + fx-1;
		var clip = Veco.main.clip.abspos_to_buf(Point(x, rowfx));
		var name = clip.node_uname;
		var buskey = ~fxbufstut+++\fx;
		var index = row;
		clip[\execute] = { arg self;
			Ndef(name+++\mixer).put(index, \filter -> { arg in; Out.ar(BusDef(buskey), in); in; });
			Ndef(name+++\mixer).set(\xfade, 1);
			Ndef(buskey).set(\choose, fx);
			clip.response_off_hook = {
				Ndef(name+++\mixer).set(\xfade, 0.5);
				Ndef(buskey).set(\choose, 0);
				Ndef(name+++\mixer).removeAt(index);
			};
		};
		clip.is_present = true;
	};
}

(
)

Veco.main.clip.abspos_to_buf(Point(0, 0))
