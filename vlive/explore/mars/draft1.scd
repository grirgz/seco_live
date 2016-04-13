
(
Ndef(\drap, { arg freq=100, pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(2/~t, 0, Dseq([
		1,0,0,0,
	],inf)).midiratio * freq;
	sig = WhiteNoise.ar(1);
	sig = sig + LFSaw.ar(freq);
	sig = BPF.ar(sig, SinOsc.kr(1).range(1190,1221));
	sig = Pan2.ar(sig, pan, amp);
}).play(BusDef(\fx1).index,2);
);
Ndef(\fx1).play

(
Ndef(\fx1).put(100, \pset -> Pbind(
	\delay, Pseq([0.00001,0.001,0.001,0.002],inf),
	\delay2, Pseq([0.00001,0.01,0.001,0.2],inf).stutter(4),
	\dur, 1/4,
));
)

(
Ndef(\fx1).put(100, \pset -> Pbind(
	\delay, Pseq([Pn(0.00001,15),0.1],inf),
	\delay2, Pseq([0.00001,0.01,0.001,0.2],inf).stutter(Pseq([2,4,10]*2,inf)),
	\dur, 1/4,
));
)
(
Ndef(\fx1).put(100, \pset -> Pbind(
	\delay, Pseq([Pn(0.00001,15),0.1],inf),
	\delay2, Pseq([0.00001,0.01,0.701,0.007],inf).stutter(Pseq([4,6,2,4]*2,inf)),
	\dur, 1/4,
));
)

(
Ndef(\fx1).put(100, \pset -> Pbind(
	\delay, Pseq([0.001,0.57, 0.001, 0.65,  0.001, 0.60, 0.01,0.9]/2,inf).stutter(2),
	\delay2, Pseq([0.00001,0.000701],inf).stutter(Pseq([1,1,7,7],inf)),
	\dur, 1/4,
));
)

Ndef(\fx1).stop
Ndef(\fx1).play
Pdef(\part1_wet).stop
Ndef(\drap).stop
(
	Ndef(\fx1).play;
	Ndef(\drap).play;
	Pdef(\part1_wet).play;
)

Ndef(\fx1).asPattern.play
