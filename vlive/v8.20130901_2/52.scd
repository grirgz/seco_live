~name = \52;

SynthDef(\bass, { arg freq = 440, amp = 0.2, amp2 = 0.3, atk=0.2, sus=0.5, rel=0.5;
	var sig;
	sig = RLPF.ar(
			Pulse.ar((freq), 0.5, amp).distort*4,
		240, 4, amp2);
	Out.ar (0,
		Pan2.ar(sig,0, EnvGen.kr(Env.linen(atk,sus, rel, 1, 0), doneAction: 2))
	)
}).add;

(
~disco_bass = Pbind(
	\instrument, \bass,
	\midinote, Pseq([45,57,45,57,45,57,45,57,45,57,45,57,45,57,45,57,45,57,45,57,45,57,45,57,43,55,43,55,43,55,43,55], inf),
	\dur, 0.4/2,
	\amp, Pseq([1, 0.75], inf),
	\atk, 0.02,
	\sus, 0.1,
	\rel, 0.01,
).play;
)
