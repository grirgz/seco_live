
(
~seqsize = 8;
~seqarray = List.newFrom({ List.newFrom(0!~seqsize) }!~seqsize);
~seqpos = Ref(Point(0,0));
)

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\seqarray, `~seqarray,
		\seqpos, Ref(~seqpos),
		\rules, Prout({ arg ev;
			1000.do { arg idx;
				ev.use {
					var size = ~seqarray.value.size;
					//~seqpos.class.debug("class");
					~seqpos.value = Point(~seqpos.value.x + 1 % size, ~seqpos.value.y + 2 % size );
					~seqarray.changed(\seqpos);
					1.yield;
					~seqpos.value = Point(~seqpos.value.x - 1 % size, ~seqpos.value.y + 1 % size );
					~seqarray.changed(\seqpos);
					1.yield;
					~seqpos.value = Point(~seqpos.value.x + 2 % size, ~seqpos.value.y % size );
					~seqarray.changed(\seqpos);
					1.yield;
				}
			};
		}),
		\isRest, Pfunc({ arg ev;
			ev.use {
				//~seqarray.debug("seqarray1");
				//~seqarray.value.debug("seqarray2");
				//~seqpos.value.x.debug("seqarray3");
				~seqarray.value[~seqpos.value.x][~seqpos.value.y].coin.not
			}
		}),
		\dur, 1/4,
		\amp, 0.1,
	),
).play;
);

(
WindowDef(\win, { arg def;
	var seqarray = ~seqarray;
	var seqpos = ~seqpos;
	var oldpos;
	var grid;
	var view = View();
	var hilistate; 
	var normalstate;
	var butarray;
	hilistate = [
		[ "-", Color.black, Color.red],
		[ "X", Color.black, Color.red],
	];
	normalstate = [
		[ "-", Color.black, Color.white],
		[ "X", Color.black, Color.white],
	];
	butarray	= seqarray.collect { arg line, lineidx;
		line.collect { arg cell, cellidx;
			var but;
			but = Param(line, cellidx, ControlSpec(0,1,1)).asButton;
			but.states = normalstate;
			but;
		};
	};
	grid = GridLayout.rows(*butarray);
	view.onChange(seqarray, \seqpos, {
		seqpos.debug("seqpos");
		defer {
			var but;
			var oldval;

			if(oldpos.notNil) {
				but = butarray[oldpos.value.x][oldpos.value.y];
				oldval = but.value;
				but.states = normalstate;
				but.value = oldval;
			};
			but = butarray[seqpos.value.x][seqpos.value.y];
			oldval = but.value;
			but.states = hilistate;
			but.value = oldval;
			oldpos = Ref(seqpos.value);
		}

	});
	view.layout = grid;
	view;

}).front;
)
