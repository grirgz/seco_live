
(
Pdef(\zed, 
	Pbind(
		\osc, Pseq([SinOsc, LFSaw],inf),
		\instrument, Prout({ arg ev;
			SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
				var sig;
				sig = ev[\osc].ar(freq);
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
				sig = Pan2.ar(sig, pan, amp);
				Out.ar(out, sig);
			}).add.yield;
		}).loop,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
