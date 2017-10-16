
// the goal is to add a cleanup inside a pbind

(
	// this works!!! (re-run the pdef)
Pdef(\plop, Pbind(
	\instrument, \default,
	\myc, Prout({ arg ev;
		var cleanup = EventStreamCleanup.new;
		cleanup.addFunction(ev, {
			"can free stuff now!".debug;
		});
		inf.do {
			1.yield;
		}
	}),
	\myc2, Prout({ arg ev;
		var cleanup = EventStreamCleanup.new;
		cleanup.addFunction(ev, {
			"can free stuff now! 2".debug;
		});
		inf.do {
			1.yield;
		}
	}),
	\degree, Pseq([0],inf),
	\dur, Pseq([1],inf),
	\amp, 0.1,
)).play;
);

(
	// this works!!! (re-run the pdef)
Pdef(\plop, Pbind(
	\instrument, \default,
	\myc, Prout({ arg ev;
		var cleanup = EventStreamCleanup.new;
		cleanup.addFunction(ev, {
			"can free stuff now!".debug;
		});
		inf.do {
			1.yield;
		}
	}),
	\myc2, Prout({ arg ev;
		var cleanup = EventStreamCleanup.new;
		cleanup.addFunction(ev, {
			"can free stuff now! 2".debug;
		});
		inf.do {
			1.yield;
		}
	}),
	\degree, Pseq([0],inf),
	\dur, Pseq([1],inf),
	\amp, 0.1,
)).play;
);

(
	// this works!!! 
Pdef(\plop, 
	Pseq([
		Pfindur(2,Pbind(
			\instrument, \default,
			\myc, Prout({ arg ev;
				var cleanup = EventStreamCleanup.new;
				cleanup.addFunction(ev, {
					"can free stuff now!".debug;
				});
				inf.do {
					1.yield;
				}
			}),
			\degree, Pseq([0],inf),
			\dur, Pseq([1],inf),
			\amp, 0.1,
		))
	],inf),
).play;
);
