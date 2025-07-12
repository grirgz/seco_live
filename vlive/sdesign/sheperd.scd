
(
Ndef(\sheperd, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var rate=1/4;
	env1 = LFSaw.kr(rate).unipolar + 1;
	env2 = LFSaw.kr(rate).unipolar.lag(0.1);
	env3 = 1-LFSaw.kr(rate).unipolar.lag(0.1);
	env1.poll;
	sig1 = SinOsc.ar(freq * env1) * env2;
	sig2 = SinOsc.ar(freq*2 * env1) * env3;
	sig = SelectX.ar(\mix.kr(0), [sig1, sig2]);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( // grave
			\instrument, \default,
			\note, Pseq([
				Pseq((0..11))
			],inf),
			\dur, 1/12,
			\amp, 0.1 * Pseg(Pseq([0,1],1),1).loop,
		),
		Pbind( // aigu
			\instrument, \default,
			\note, Pseq([
				Pseq((0..11))
			],inf)+12,
			\dur, 1/12,
			\amp, 0.1 * Pseg(Pseq([1,0],1),1).loop,
		),
		
	])
)).play;
);

(
// works!!!!
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( // grave
			\instrument, \default,
			\note, Pseq([
				Pseq((0..11))
			],inf),
			\dur, 1/12,
			\amp, 0.1 * Pseg(Pseq([0,1],1),1,-2).loop,
		),
		Pbind( // aigu
			\instrument, \default,
			\note, Pseq([
				Pseq((0..11))
			],inf)+12,
			\dur, 1/12,
			\amp, 0.1 * Pseg(Pseq([1,0],1),1,-2).loop,
		),
		
	])
)).play;
);

~t = 185/2/60; TempoClock.default.tempo = ~t;
~t = 55/4/60; TempoClock.default.tempo = ~t;
(
// test seq
Pdef(\part, Pdef(\zedpart, 
	Pseq([
		Pbind( // grave
			\instrument, \default,
			\note, Pseq([
				Pseq((0..11))
			],1),
			\dur, 1/12,
			\amp, 0.1 * Pseg(Pseq([0,1],1),1).loop,
		),
		Pbind( // aigu
			\instrument, \default,
			\note, Pseq([
				Pseq((0..11))
			],1)+12,
			\dur, 1/12,
			\amp, 0.1 * Pseg(Pseq([1,0],1),1).loop,
		),
		
	])
)).play;
);
