
(

	Pdef(~name,

		Pspawner({ arg sp;
			var name = ~name;
			var ffreq = ~midi.(\k1, 300, \freq.asSpec).valpattern;
			var amps = [
				~midi.(\k2, 1, \unipolar.asSpec).valpattern,
				~midi.(\k3, 1, \uniploar.asSpec).valpattern,
			];
			var sustain = ~midi.(\k4, 1, \sustain.asSpec).valpattern;
			4140.do { arg x;
				var amp;
				var beats = 32;
				var dur = 4;
				var multi = 5;
				var span = 1;
				var cover = 8;
				var lag;
				var lagx;
				x = x+1;
				lagx = Pseq((0..multi)/multi,inf).asStream;
				lag = (beats).rand / beats * dur / t;
				lag.debug("LAF");
				multi.do { arg y;
					x = x + y;
					amp = amps.wrapAt(x);
					lag = lag + ((lagx.next)/8);
					lag.debug("lagYY");
					sp.par(
						Pdef(name+++\mod) <>
						Pbind(
							\instrument, name,
							\degree, 24.rand,
							\freq, (107.0.rand + 10).midicps,
							\ffreq, ffreq * (0.4107.rand + 0.310).midicps,
							\varx, x,
							\octave, 3,
							\sustain, dur.rand + 1/8 * sustain,
							\sustain, 0.1,
							\dur, Pn(dur,span*cover),
							\amp, 0.1 * amp,
							//\lag, (x-1 / beats % 1 * dur).debug("lagXX") / t,
							\lag, (beats).rand / beats * dur / t,
							\lag, lag,
						)
					);
				};
				(dur*span).wait;
			};
			"end".debug;
		})
	).play
);

(
Pdef(~name+++\mod, 
	Pbind(
		\freq, Pkey(\lag) % 16 * 100 + 101,
		\freq, Pfunc({ arg ev;
			var res = sin(ev[\varx] *50) + 1 / 2;
			res = res * ev[\freq] + 140;
			res.debug;
			res;
		}),
		\legato, 2,
		\amp, 
		Pfunc({
			arg ev;
			ev[\amp] * [0,0,1].wrapAt(ev[\varx]);
		}),
		\amp, 0.1,

		//\amp, Ndef(~name+++\lfo1, { arg x; SinOsc.ar(0.1*x) })
		//\amp, Pseq([x])
		//\legato, Pkey(\varx) % 8 * 1/16 + 0.1,
	)
)
);
