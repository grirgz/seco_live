// freq2 get -nan when using both array in note and adsr
// does not -nan when freq2 is not the last argument but still set to default value
// solve it with:
//	\freq2, Pfunc({ arg ev;
//		ev.use {  ~freq.value(ev).postln + 1 };
//	}),

(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, freq2=200;
	var sig;
	sig = SinOsc.ar(freq) + SinOsc.ar(freq2.poll);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\zed, { arg out=0, freq2=200, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq) + SinOsc.ar(freq2.poll);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \zed,
			\note, [0,7],
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			//\freq2, Pkey(\freq),
			\freq2, Ptuple(Pkey(\freq)!2),
			\dur, 4,
			\amp, 0.3,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \zed,
			\note, [0,1],
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1),
Env.adsr(1.01,0.1,0.8,0.1)
		   	],
			],inf),
			\terrain, b.bufnum,
			\freq2, Ptuple(Pkey(\freq)!2),
			//\freq2, Pkey(\freq),
			\dur, 4,
			\amp, 0.3,
		),
		
	])
)).play;
);
