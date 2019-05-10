
// new cell experiment with frequencie as a space


(
~make_cell = {(
	freq: rrand(1.0,19000),
)};
~world = (
	cells: ~make_cell!10,
	nextturn: { arg self;
		var freqs;
		self.cells = self.cells.sort({ arg a, b; a.freq > b.freq });
		freqs = self.cells.collect({ arg cell;
			cell.freq
		});
		freqs.debug("freqs before");

		freqs.do { arg freq, idx;
			var prev, next;
			var friend;
			if(freqs[idx+1].notNil and: { idx>0 }) {
				prev = freqs[idx-1];
				next = freqs[idx+1];
				if((prev/freq) > (freq/next)) { // prev is closer

				};

				if(freqs[idx+1].notNil) {
					if(freqs[idx+1] / 2 < freq) {
						var newfreq;
						newfreq = (freqs[idx+1] * ( 2/3 ));
						[freq, newfreq].debug("change");
						self.cells[idx].freq = newfreq;
					}
				}
			}

		};
		freqs.debug("freqs after");
		"-----------".debug;

	},
);
)
~world.nextturn

(
	~fr = 200;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, [~fr, ~fr*( 3/2 ), ~fr*(3/2)*(3/2)],
			\dur, 1,
			\amp, 0.1,
		),

		
	])
)).play;
);
(3/2)*(3/2)
9/4



(
	// discrete
~make_cell = {(
	degree: rrand(1.0,19000),
)};
~world = (
	cells: ~make_cell!10,
	nextturn: { arg self;

	},
);
)
