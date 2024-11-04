(
SynthDef(\wah, { arg out=0, gate=1;
	var env, in;
	env = Linen.kr(gate, 0.05, 1, 0.4, 2);
	in = In.ar(out, 2);
	XOut.ar(out, env, RLPF.ar(in, LinExp.kr(LFNoise1.kr(2.3), -1, 1, 200, 8000), 0.1).softclip * 0.8);
}, [\ir, 0]).add;
)

(
Pdef(\demo, 
	Pbind(
		\instrument, \default,
		\degree, Pseq((1..10),inf),
		\dur, 1/4,
		\amp, 0.1,
	),
).play;
);

// add fx
(
Pdef(\fx, 
	Pmono(\wah,
		\addAction, \addToTail,
		\lag, 0.0005,
		\dur, 1,
	)
).play;
);

// remove fx
Pdef(\fx).stop;



////////////////////////

(
SynthDef(\trig, {
	|freq=220, amp=0.5, t_gate=1, pan=0|
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.adsr, t_gate.poll, doneAction:2); //The synth does not disappear even when the envelope is completed.
	sig = sig * env * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).add
)

(
Pbind(
	\instrument, \trig,
	//\gate, Pseq([1, 0, 0, 0, 0, 1], inf),
	\gate, Pseq([1, 0, 0, 0, 0, 1], inf).collect { |a| if(a == 0) { Rest(a)  } { a  }  },
	\dur, 1.25,
	\freq, Pexprand(50, 500, inf),
).play
)
s.options.blockSize / s.sampleRate
