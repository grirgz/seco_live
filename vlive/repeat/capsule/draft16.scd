

(
SynthDef(\bluk, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * 0.01 + 1)).mean;
	sig = RLPF.ar(sig, \lpfr.kr(2.1) * ((0..7)/7 - 0.5 * 2 + 1) * freq, \rq.kr(0.5)* ((0..7)/7 - 0.5 * 0.01 + 1)).mean;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\source1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\source2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\filterpart, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, Pseq([
				\source1,
				\source2,
			],inf),
			\freq, 200,
			\dur, 1,
			\out, BusDef(\oscbus, \audio),
			\amp, 0.1,
		),
		Pmono(\filterpart,
			\inbus, BusDef(\oscbus, \audio),
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
).play;
);

s.waitForBoot{{ SinOsc.ar(17000) ! 2 * 0.1}.play};

FileSystemProject.load("libdef/piano.scd")
ProtoDef(\piano).startControl
ProtoDef(\piano)

Ndef(\bla, { SinOsc.ar(17000)!2*0.1  }).play
Ndef(\bla, { LFSaw.ar(17000)!2*0.1  }).play
Ndef(\bla, { Saw.ar(17000)!2*0.1  }).play
( 64+(4*12) ).midicps
(84).midicps


(
Pdef(\plop, Pbind(
	\instrument, Prand([\default,\bluk],inf),
	\note, Pseq([
		Plazy({ arg ev;
			var ar = [0,4,7];
			var ari = ar.copy;
			var idx = ar.size.rand;
			ar[idx] = ar[idx] + [1,-1].choose;
			Pseq([
				ari,
				ar,
			]).stutter(8)
		}).loop,
	],inf),
	\ctranspose, Pbrown(-4,4,1).stutter(32*Plazy({ Pseq(4.partition) }).loop),
	\octave, Pseq([
		Plazy({ arg ev;
			var ar = [5,5,5];
			var ari = ar.copy;
			var idx = ar.size.rand;
			ar[idx] = ar[idx] + [1,-1].choose;
			Pseq([
				ar,
				ari,
				ar,
				ari,
				ari,
			]).stutter(1)
		}).loop,
	],inf),
	\dur, 1/8,
	\amp, 0.1,
	\legato, Ptuple(Pwhite(0.3,1)!3),
	\amp, Pkey(\amp) * Pseq([
		Plazy({ arg ev;
			Pseq([
				[1,0,1],
				[0,1,0],
				[1,1,0],
				[0,0,1],
				[0,1,1],
				[1,0,0],
			].clump(2).scramble.flatten,2);
		}).loop,
	],inf),
	\amp, Pkey(\amp) * Ptuple(Pwhite(0.6,1.1)!3),
)).play;
);

4.partition

(
);

(
Pdef(\plopx, Pbind(
	\instrument, \bluk,
	\note, 0,
	\note, Pseq((0..64)) +.x Pseq([0,-7,-6,-5,4,1,-3,2],1),
	\octave, 4,
	\dur, 1/16 * Pseg(Pseq([2,1,1/2],inf),16,-1),
	\amp, 0.1,
)).play;
);

{ SinOsc.ar(700) ! 2 * 0.1}.play;

(
Pdef(\demo, Pbind(
	\instrument, \default,
	\isRest, Pseq([
		0,0,1,0, 1,0,1,0,
	],inf).coin.not,
	\isRest, true,
	\freq, 200,
	\dur, 1,
	\amp, 0.1,
)).play;
)

(
Pdef(\demo, Pbind(
	\instrument, \default,
	\legato, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\isRest, true,
	\freq, 200,
	\dur, 1,
	\amp, 0.1,
	//\isRest, true, // mute the pattern
)).play;
)
