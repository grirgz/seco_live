
(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=4000, rq=0.3;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	ffreq = ffreq.clip(50,18000);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);
(

	Pdef(~name,

		Pspawner({ arg sp;
			var dur = 1/2;
			var ffreq = ~midi.(\k1, 300, \freq.asSpec).valpattern;
			var amps = [
				~midi.(\k2, 1, \unipolar.asSpec).valpattern,
				~midi.(\k3, 1, \uniploar.asSpec).valpattern,
			];
			var sustain = ~midi.(\k4, 1, \sustain.asSpec).valpattern;
			4140.do { arg x;
				var amp;
				x = x+1;
				amp = amps.wrapAt(x);
				sp.par(
					Pdef(~name+++\mod) <>
					Pbind(
						\instrument, ~name,
						\degree, 24.rand,
						\freq, (107.0.rand + 10).midicps,
						\ffreq, ffreq * (0.4107.rand + 0.310).midicps,
						\varx, x,
						\octave, 3,
						\sustain, dur.rand + 1/8 * sustain,
						\dur, Pn(4,64),
						\amp, 0.1 * amp,
						\lag, (16*2).rand * 1/16,
					)
				);
				1.wait;
			};
			"end".debug;
		})
	).play
);

(
Pdef(~name+++\mod, 
	Pbind(
		\freq, Pfunc({ arg ev;
			var res = sin(ev[\varx] *50) + 1 / 2;
			res = res * ev[\freq] + 140;
			res.debug;
			res;
		}),
		\freq, Pkey(\varx) % 16 * 100 + 101,
		\amp, 
		Pfunc({
			arg ev;
			ev[\amp] * [0,0,1].wrapAt(ev[\varx]);
		}),

		//\amp, Ndef(~name+++\lfo1, { arg x; SinOsc.ar(0.1*x) })
		//\amp, Pseq([x])
		//\legato, Pkey(\varx) % 8 * 1/16 + 0.1,
	)
)
);

// END


rand(8.0)
(

	Pdef(~name,

		Pspawner({ arg sp;
			var dur = 1/2;
			var ffreq = ~midi.(\k1, 300, \freq.asSpec).valpattern;
			140.do { arg x;
				x = x+1;
				sp.par(
					Pbind(
						\instrument, ~name,
						\degree, 24.rand,
						\freq, (107.0.rand + 10).midicps,
						\ffreq, ffreq * (0.4107.rand + 0.310).midicps,
						\octave, 3,
						\sustain, dur.rand + 1/8,
						\dur, 4,
						\lag, (16*4).rand * 1/16,
					)
				);
				1.wait;
			};
			"end".debug;
		})
	).play
);


rand(8.0)
