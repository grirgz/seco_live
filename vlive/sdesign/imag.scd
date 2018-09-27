~t = 60/60; TempoClock.default.tempo = ~t;

///// tristesse

(
SynthDef(\tristesse, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq.lag(\freqlag.kr(1)) * ( SinOsc.kr(4 * \xf.kr(1)) * 0.1 + 1 ) );
	sig = RLPF.ar(sig, \lpfr.kr(1.7987) * freq, \rq.kr(0.1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * LFNoise1.kr(1/2).range(0.0,1.0);
	sig = sig / 4;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \tristesse,
		\note, Pseq([
			7,5,3,2, 1,0,Rest(0),Rest(0),
		],inf)+[0,3,7],
		\xf, Pseg(Pseq([0,1],inf),4),
		\dur, 1/2,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\zed, 
	Ppar([
		Ppar( [0-12,3,7-12,7].collect { arg note;
			Pmono(\tristesse,
				\note, note+Pseq([7,2,0],1),
				\octave, 6,
				\freqlag, 2*~t,
				\xf, Pseg(Pseq([0,1],inf),4),
				\lag, Pwhite(0.0001,0.2,inf),
				\dur, Pseq([0.1,0.4,4],inf),
				\amp, 0.1,
			);
		} ).loop,
		Ppar( [0-12,3,7-12,7].collect { arg note;
			Pmono(\tristesse,
				\note, note+Pseq([7,2,0],1),
				\octave, 6,
				\freqlag, 2*~t,
				\xf, Pseg(Pseq([0,1],inf),4),
				\dur, Pseq([0.1,0.1+Pwhite(0,1,1),1],inf),
				\amp, 0.1,
			);
		} ).loop,
		Ppar( [0-12,3,7-12,7].collect { arg note;
			Pmono(\tristesse,
				\note, note+Pseq([9,5,1],1),
				\octave, 6,
				\freqlag, 2*~t,
				\xf, Pseg(Pseq([0,1],inf),4),
				\dur, Pseq([0.1,0.1+Pwhite(0,1/4,1),1/2],inf),
				\amp, 0.1,
			);
		} ).loop,
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
	]),
).play;
);

Proto

(
Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,1,
			],inf).stutter(2),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/4,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus3, \audio),
		),
	]),
).play;
);
