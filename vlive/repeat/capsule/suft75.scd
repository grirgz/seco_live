(
SynthDef(\foo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.ar(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\fooseq, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = Duty.ar(1/4/~t, 0, Dseq([
		1,2,1/2,2,
	],inf)).lag(0.1) * SinOsc.kr(1).range(1/2,1);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pmono(\fooseq,
			\out, BusDef(\seq, \audio),
			\dur, 1,
		),
		Pbind(
			\instrument, \foo,
			\note, Pseq([
				0,2,5,1,
			],inf).stutter(4),
			\lpfr, BusDef(\seq, \audio).asMap,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);
