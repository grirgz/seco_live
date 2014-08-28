(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq.lag(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\x,
	PmonoArtic(\plop,
		\freq, Pseq([100,200,300],inf),
		\isRest, Pseq([
			1,1,1,1,
			1,1,1,1,
			1,0,1,1,
			0,0,1,0,
		],inf).coin.not,
		\legato, Pseq([1,0.3],inf),
		\dur, 1/4,
	)
).play
)
Pdef(\x).quant
