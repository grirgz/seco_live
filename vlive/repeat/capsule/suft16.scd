

~t = 135/4/60; TempoClock.default.tempo = ~t;
~t = 150/4/60; TempoClock.default.tempo = ~t;



(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		
	])
)).play;
)


///////////////// changing tempo


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \bluk,
				\note, 0,
				\note, Pseq((0..64)) +.x Pseq([0,-7,-6,-5,4,1,-3,2],1),
				\octave, 4,
				\dur, 1/16 * Pseg(Pseq([2,1,1/2],inf),16,-1),
				\amp, 0.1,
			),
			Pseq([
				Pbind(\instrument, \bluk,
					\freq, ~pmodenv.(Pseq([1,1.2,2,4]*200,inf), 8),
					\dur, 1/16 * Pseg(Pseq([2,1,1/2],inf),16,-1),
					\amp, 0.1,
				),
			],inf),
			Ptpar([
				0, Pbind(
					\instrument, \snapkickx,
					\dur, 1/16 * Pseg(Pseq([2,1,1/2],inf),16,-1),
					\isRest, Pseq([
						1,0,1,0,
					],inf).coin.not,
					\amp, 0.1,
				),
			]),
		]),

		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286 * Pseg(Pseq([1,10],inf),8),
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				Pseg(Pseq([1,1000],inf),8),
			],inf).stutter(1),
			'delay2', 0.200000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		)
		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \bluk,
				\note, 0,
				\note, Pseq((0..64)) +.x Pseq([0,-7,-6,-5,4,1,-3,2],1),
				\octave, 4,
				\dur, 1/16 * Pseg(Pseq([2,1,1/2],inf),16,-1),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \basicbass,
				\freq, 80,
				\lpf, ~pmodenv.(Pseq([71,400,1000,5000,10000],inf), 4),
				\isRest, Pseq([
					0,0,1,1, 1,1,1,0,
					1,1,1,1, 1,1,0,0,
					1,1,1,1, 1,1,1,0,
					1,1,1,1, 1,1,0,0,
				],inf).coin.not,
				\dur, 1,
				\amp, 0.1,
			),
		]),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pseq([
				Pbind(\instrument, \bluk,
					\freq, ~pmodenv.(Pseq([1,1.2,2,4]*200,inf), 8),
					\dur, 1/16 * Pseg(Pseq([2,1,1/2],inf),16,-1),
					\amp, 0.1,
				),
			],inf),
			Ptpar([
				0, Pbind(
					\instrument, \snapkickx,
					\dur, 1/16 * Pseg(Pseq([2,1,1/2],inf),16,-1),
					\isRest, Pseq([
						1,0,1,0,
					],inf).coin.not,
					\amp, 0.1,
				),
			]),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,1,1,

				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
		]),

		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286 * Pseg(Pseq([1,10],inf),8),
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			\delay, ~pmodenv.(Pseq([0.000001,0.002,0.2],inf), 8),
			\delay2, ~pmodenv.(Pseq([0.000001,0.002,0.2],inf), 7),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			\delay, ~pmodenv.(Pseq([0.002,0.000001,0.2],inf), 8.1),
			\delay2, ~pmodenv.(Pseq([0.002,0.000001,0.2],inf), 7.1),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\dur, 1/4,
		)
		
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8 * Pseg(Pseq([0,1],inf),8),
			\dur, 
			Pseries(1,2,12).asStream.nextN(10)
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		
	])
)).play;
)

Pdef(\part).clear

(
SynthDef(\bluk, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * 0.01 + 1)).mean;
	sig = RLPF.ar(sig, \lpfr.kr(2.1) * ((0..7)/7 - 0.5 * 2 + 1) * freq, \rq.kr(0.5)* ((0..7)/7 - 0.5 * 0.01 + 1)).mean;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
);


///////////////////////////////////////////////////////
// ramp function research (transition between rythm in a given duration)

(
	~rampe = { arg start, end, dur;
		var mid,numpart,partsize;
		var enum;
		mid = (start+end)/2;
		numpart = (dur/mid).trunc;
		partsize = dur/numpart;
		partsize/start;
		enum = (0..numpart)/numpart;
		(start * (1-enum)) + (end * enum);
	};
	~rampe.(4,1, 2**6).postln.sum;
)
		x=(0..32)/33; ( (4 * (1-x)) + (1 * x) ).sum;


////////////////////////////////////////////////////
// experiment on multiple faded delays
(
SynthDef(\fadedelay, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = 12.collect({ arg idx;
		DelayL.ar(sig, 0.5, rrand(0.001,0.5)) * Pulse.kr(rrand(1/16,1/3)).range(0,1).lag(0.1);
		//DelayL.ar(sig, 0.5, rrand(0.001,0.5));
	}).sum;
	sig = sig + in;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fadedelay, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(freq); 
	lfo1 = 1;
	sig = in;
	sig = 12.collect({ arg idx;
		DelayL.ar(sig, 0.5, rrand(0.001,0.5)) * Saw.ar(exprand(76.0,7300) * lfo1).range(-1,1) * Pulse.kr(rrand(1/16,1/3)).range(0,1).lag(0.1);
		//DelayL.ar(sig, 0.5, rrand(0.001,0.5));
	}).sum;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),

		Pmono(\fadedelay,
			\inbus, BusDef(\sendbus1, \audio, 2),
			//\gain, 1/20,
			\gain, 2,
			\dur, 1,
		),
		
	])
)).play;
)

////////////////////////////////////////////////////
// rythm study

(
	// dnb ?
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0,0,0,
				1,1,
				0,0,0,0,0,
				1,0,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\lag, 1/16/~t,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		
	])
)).play;
)

(
	// dnb
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
				1,0,0,1, 0,1,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0,0,0,
				1,1,
				0,0,0,0,0,
				1,0,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\lag, 1/16/~t,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		
	])
)).play;
)

(
	// ???
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0, 0,1, 0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0,0,0,
				1,1,
				0,0,0,0,0,
				1,0,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\lag, 1/16/~t,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		
	])
)).play;
)

(
	// ragga
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0,0,0,
				1,1,
				0,0,0,0,0,
				1,0,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\lag, 1/16/~t,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\isRest, true,
		),
		
	])
)).play;
)

(
	// ragga
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0,0,0,
				1,1,
				0,0,0,0,0,
				1,0,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\lag, 1/16/~t,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\isRest, true,
		),
		
	])
)).play;
)

(
	// simple drummer
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0,0,0,
				1,1,
				0,0,0,0,0,
				1,0,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\lag, 1/16/~t,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\isRest, true,
		),
		
	])
)).play;
)

(
	// funky drummer
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0,0,0,
				1,1,
				0,0,0,0,0,
				1,0,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\lag, 1/16/~t,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\isRest, true,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0,0,0,
				1,1,
				0,0,0,0,0,
				1,0,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\lag, 1/16/~t,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\isRest, true,
		),
		
	])
)).play;
)


(
	// simple drummer
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,1,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0,0,0,
				1,1,
				0,0,0,0,0,
				1,0,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\lag, 1/16/~t,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\isRest, true,
		),
		
	])
)).play;
)



///////////////////////////////////////



(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),
		
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,1,0,1,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,1,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0004099467303085 * Pseq([1,2,1,1, 2,1,1,2],inf),
			'delay', 0.200001231 * Pseq([
				1,0.0008,
			],inf).stutter(1),
			'delay2', 0.000210000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
		Pbind(\out, BusDef(\sendbus3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,1,0,
				].clump(16).collect(_.dup(2)).flat,inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/4,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
				\isRest, true,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.00002099467303085,
			'delay', 0.400001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.0000210000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
			\isRest, true,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\bigperc, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([


					0,0,1,0, 0,0,0,1,
					0,0,0,0, 0,1,0,0,
					0,0,1,0, 0,1,0,1,
					0,1,1,0, 1,1,0,1,

					0,0,1,0, 0,0,0,1,
					1,0,0,1, 0,1,0,0,
					0,1,0,1, 0,1,0,1,
					0,0,1,1, 0,0,1,1,

					0,0,1,0, 0,1,0,1,
					0,1,1,0, 1,1,0,1,
					0,0,1,0, 0,1,0,1,
					0,0,1,1, 1,0,1,1,

					0,0,1,0, 0,1,1,1,
					0,0,1,0, 0,0,0,0,
					0,1,0,1, 0,1,0,1,
					1,0,1,1, 1,1,0,1,
				],inf).coin.not,
				\sustain, 0.071 * Pseq([
					0.7, 0.7, 1.2, 0.7, 1, 1.2,
				],inf),
				\gain, 0.2 * Pseq([
					0.7,0.7,1,
				],inf),
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 1.7344889782792* Pseq([
				Pseq([
					0
				],8*8),
				Pseq([
					1
				],inf),
			],inf),
			'fb', 0.00002099467303085,
			'delay', 0.000600001231 * Pseq([
				Pseq([
					2,
				],8*8),
				Pseq([
					1,
				],8*8),
			],inf).stutter(1),
			'delay2', 0.00010210000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', Pseq([
				3700,
				3700,
				8000,
			],inf),
			\postlpf, ~pmodsynth.({ SinOsc.kr([1/2,1/3]).range(3000,10000).mean }),
			'posthpf', 1417,
			\bpfac, ~pmodsynth.({ SinOsc.kr([1/5,1/3]).range(3,1/8).mean }),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, (Pseq([
					0,0,0,0,0,
					1,1,
					0,0,1,0,0,1,
				],inf) * Pseq([
					Pseq([
						0
					],16*8),
					Pseq([
						Pseq([
							0,0,0,0, 0,0,0,0,
						],8),
						Pseq([
							1,1, 1,1, 1,1, 1,1,
						],4),
					],inf),
				],inf)).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\lag, (1/16/~t),
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pseq([
						0
					],16*8),
					Pseq([
						Pseq([
							0,0,0,0, 0,0,0,0,
						],4),
						Pseq([
							1,1, 1,1, 1,1, 1,1,
						],8),
					],inf),

				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.3,
				\lag, 0.04,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792 ,
			'fb', 0.0004099467303085 * Pseq([1,2,1,1, 2,1,1,2],inf),
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000210000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
		Pbind(\out, BusDef(\sendbus3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\bodyenv, [ Env.linen(0.001,0.02,0.1) ],
				\isRest, Pseq([
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			'mix', 0.85714285714286,
			'gain', 0.344889782792 * Pseq([
				Pseq([
					0
				],4*32),
				Pseq([
					1
				],inf),
			],inf),
			'fb', 0.00001099467303085,
			'delay', 0.200001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.00000210000543560101,
			'distamp', 71.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			\bpmix, 0,
			\bpfac, 3,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
	])
)).play;
)

Pdef(\part).clear;

(
SynthDef(\ulu, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread =1;
	var sig;
	var fmt = CuspN.ar((1..8)/30) * \fmtamp.kr(0.2) + 1; 
	sig = SinOsc.ar(freq * [1,1/2,3/5,2] * ((0..7)/7 - 0.5 * fspread + 1) * ( SinOsc.ar(freq*\fmr.kr(1) * fmt) * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + SinOsc.ar((1..8)/20, (1..8)); 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\parthi, Pdef(\rogne_part1, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1hi, \audio)) <>
		Ppar([
			Pmono(\ulu,
				\freq, Pseq([
					800, 800, 800, 800,
					800, 800, 800, 800,
					800, 800, 800, 800,
					800, 1800, 800, 80,
				],inf),
				\fmtamp, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,0,1,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 1,0,1,1,
					0,0,1,0, 1,0,0,0,
				],inf)+0.2,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \iron,
				\note, Pseq([
					0,1,-10,20,
				],inf).stutter(3),
				\detune, 500,
				\legato, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 4,0,0,0,
						0,0,2,0, 0,1,0,1,
						1,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus1hi, \audio, 2),
			'wet10', 1.0,
			'mix', 0.85714285714286,
			'gain', 0.344889782792 * Pseq([
				1
			],inf),
			'fb', 0.00001099467303085,
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.00000210000543560101,
			//\delay, ~pmodenv.(Pseq([0.00001,0.002,0.002,1,0.0004],inf), 8),
			//\delay2, ~pmodenv.(Pseq([0.30001,0.002,0.002,1,0.0004],inf), 7.123),
			\delay, ~pmodenv.(
				Plazy({ arg ev;
					var rr = exprand(1.0,0.000001);
					var rr2 = exprand(1.0,0.000001);
					Pseq([rr, rr,rr2],1);
				}).loop, 
				Pseq([6,1,1],inf)
			),
			\delay2, ~pmodenv.(
				Plazy({ arg ev;
					var rr = exprand(1.0,0.000001);
					var rr2 = exprand(1.0,0.000001);
					Pseq([rr, rr,rr2],1);
				}).loop, 
				Pseq([6,1,1],inf)
			),
			'distamp', 11.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			\bpmix, 0,
			\bpfac, 3,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),

		
	])
)).play;
);
(
Pdef(\parthi, Pdef(\rogne_part2, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1hi, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,1,1,-1,
					0,1,1,1,
				],inf),
				\xlag, Prand([
					0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,0,
					0,1/8,1/4,1/2,
				],inf),
				\lag, Pkey(\xlag)/~t,
				\legato, 0.8-Pkey(\xlag),
				\octave, 3,
				\dur, 1,
				\amp, 0.1,
			),
			Pmono(\ulu,
				\freq, Pseq([
					800, 800, 800, 800,
					800, 800, 800, 800,
					800, 800, 800, 800,
					800, 1800, 800, 80,
				],inf),
				\fmtamp, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,0,1,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 1,0,1,1,
					0,0,1,0, 1,0,0,0,
				],inf)+0.2,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \iron,
				\note, Pseq([
					0,1,-10,20,
				],inf).stutter(3),
				\detune, 500,
				\legato, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 4,0,0,0,
						0,0,2,0, 0,1,0,1,
						1,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus1hi, \audio, 2),
			'wet10', 1.0,
			'mix', 0.85714285714286,
			'gain', 0.344889782792 * Pseq([
				1
			],inf),
			'fb', 0.00001099467303085,
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.00000210000543560101,
			//\delay, ~pmodenv.(Pseq([0.00001,0.002,0.002,1,0.0004],inf), 8),
			//\delay2, ~pmodenv.(Pseq([0.30001,0.002,0.002,1,0.0004],inf), 7.123),
			\delay, ~pmodenv.(
				Plazy({ arg ev;
					var rr = exprand(1.0,0.000001);
					var rr2 = exprand(1.0,0.000001);
					Pseq([rr, rr,rr2],1);
				}).loop, 
				Pseq([6,1,1],inf)
			),
			\delay2, ~pmodenv.(
				Plazy({ arg ev;
					var rr = exprand(1.0,0.000001);
					var rr2 = exprand(1.0,0.000001);
					Pseq([rr, rr,rr2],1);
				}).loop, 
				Pseq([6,1,1],inf)
			),
			'distamp', 11.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			\bpmix, 0,
			\bpfac, 3,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),

		
	])
)).play;
);


(
Pdef(\parthi, Pdef(\rogne_part3, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1hi, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,1,1,-1,
					0,1,1,1,
				],inf),
				\xlag, Prand([
					0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,0,
					0,1/8,1/4,1/2,
				],inf),
				\lag, Pkey(\xlag)/~t,
				\legato, max(0.2-Pkey(\xlag),0.1),
				\octave, 3,
				\dur, 1,
				\amp, 0.1,
			),
			Pmono(\ulu,
				\freq, Pseq([
					800, 800, 800, 800,
					800, 800, 800, 800,
					800, 800, 800, 800,
					800, 1800, 800, 80,
				],inf),
				\fmtamp, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,0,1,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 1,0,1,1,
					0,0,1,0, 1,0,0,0,
				],inf)+0.2,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \iron,
				\note, Pseq([
					0,1,-10,20,
				],inf).stutter(3),
				\detune, 500,
				\legato, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 4,0,0,0,
						0,0,2,0, 0,1,0,1,
						1,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus1hi, \audio, 2),
			'wet10', 1.0,
			'mix', 0.85714285714286,
			'gain', 0.344889782792 * Pseq([
				1
			],inf),
			'fb', 0.00001099467303085,
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.00000210000543560101,
			//\delay, ~pmodenv.(Pseq([0.00001,0.002,0.002,1,0.0004],inf), 8),
			//\delay2, ~pmodenv.(Pseq([0.30001,0.002,0.002,1,0.0004],inf), 7.123),
			\delay, ~pmodenv.(
				Plazy({ arg ev;
					var rr = exprand(1.0,0.000001);
					var rr2 = exprand(1.0,0.000001);
					Pseq([rr, rr,rr2],1);
				}).loop, 
				Pseq([6,1,1],inf)
			),
			\delay2, ~pmodenv.(
				Plazy({ arg ev;
					var rr = exprand(1.0,0.000001);
					var rr2 = exprand(1.0,0.000001);
					Pseq([rr, rr,rr2],1);
				}).loop, 
				Pseq([6,1,1],inf)
			),
			'distamp', 11.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			\bpmix, 0,
			\bpfac, 3,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),

		
	])
)).play;
);


(
Pdef(\parthi, Pdef(\rogne_part4, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1hi, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pstep(Pseq([
					0,1,1,-1,
					0,1,1,1,
				],inf),1) * Prand([1,1,1,1,2,4],inf),
				\xlag, Prand([
					0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,0,
					0,1/8,1/4,1/2,
				],inf),
				\lag, Pkey(\xlag)/~t,
				\legato, 0.8-Pkey(\xlag),
				\octave, 3,
				\dur, PdurStutter(Pseq([1,4,2,8],inf), 1),
				\amp, 0.1,
			),
			Pmono(\ulu,
				\freq, Pseq([
					800, 800, 800, 800,
					800, 800, 800, 800,
					800, 800, 800, 800,
					800, 1800, 800, 80,
				],inf),
				\fmtamp, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,0,1,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 1,0,1,1,
					0,0,1,0, 1,0,0,0,
				],inf)+0.2,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \iron,
				\note, Pseq([
					0,1,-10,20,
				],inf).stutter(3),
				\detune, 500,
				\legato, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 4,0,0,0,
						0,0,2,0, 0,1,0,1,
						1,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus1hi, \audio, 2),
			'wet10', 1.0,
			'mix', 0.85714285714286,
			'gain', 0.344889782792 * Pseq([
				1
			],inf),
			'fb', 0.00001099467303085,
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.00000210000543560101,
			//\delay, ~pmodenv.(Pseq([0.00001,0.002,0.002,1,0.0004],inf), 8),
			//\delay2, ~pmodenv.(Pseq([0.30001,0.002,0.002,1,0.0004],inf), 7.123),
			\delay, ~pmodenv.(
				Plazy({ arg ev;
					var rr = exprand(1.0,0.000001);
					var rr2 = exprand(1.0,0.000001);
					Pseq([rr, rr,rr2],1);
				}).loop, 
				Pseq([6,1,1],inf)
			),
			\delay2, ~pmodenv.(
				Plazy({ arg ev;
					var rr = exprand(1.0,0.000001);
					var rr2 = exprand(1.0,0.000001);
					Pseq([rr, rr,rr2],1);
				}).loop, 
				Pseq([6,1,1],inf)
			),
			'distamp', 11.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			\bpmix, 0,
			\bpfac, 3,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),

		
	])
)).play;
);


(
Pdef(\parthi, Pdef(\rogne_part5, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1hi, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pstep(Pseq([
					0,1,1,-1,
					0,1,1,1,
				],inf),1) + Prand([0,0,0,0,12,24],inf),
				\xlag, Prand([
					0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,0,
					0,1/8,1/4,1/2,
				],inf),
				\lpf, Prand([300,200,400,1000],inf),
				\lag, Pkey(\xlag)/~t,
				\legato, 0.8-Pkey(\xlag),
				\octave, 3,
				\dur, PdurStutter(Prand([1,4,2,8],inf), 1),
				\amp, 0.1,
			),
			Pmono(\ulu,
				\freq, Pseq([
					800, 800, 800, 800,
					800, 800, 800, 800,
					800, 800, 800, 800,
					800, 1800, 800, 80,
				],inf),
				\fmtamp, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,0,1,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 1,0,1,1,
					0,0,1,0, 1,0,0,0,
				],inf)+0.2,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \iron,
				\note, Pseq([
					0,1,-10,20,
				],inf).stutter(3),
				\detune, 500,
				\legato, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 4,0,0,0,
						0,0,2,0, 0,1,0,1,
						1,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus1hi, \audio, 2),
			'wet10', 1.0,
			'mix', 0.85714285714286,
			'gain', 0.344889782792 * Pseq([
				1
			],inf),
			'fb', 0.00001099467303085,
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.00000210000543560101,
			//\delay, ~pmodenv.(Pseq([0.00001,0.002,0.002,1,0.0004],inf), 8),
			//\delay2, ~pmodenv.(Pseq([0.30001,0.002,0.002,1,0.0004],inf), 7.123),
			\delay, ~pmodenv.(
				Plazy({ arg ev;
					var rr = exprand(1.0,0.000001);
					var rr2 = exprand(1.0,0.000001);
					Pseq([rr, rr,rr2],1);
				}).loop, 
				Pseq([6,1,1],inf)
			),
			\delay2, ~pmodenv.(
				Plazy({ arg ev;
					var rr = exprand(1.0,0.000001);
					var rr2 = exprand(1.0,0.000001);
					Pseq([rr, rr,rr2],1);
				}).loop, 
				Pseq([6,1,1],inf)
			),
			'distamp', 11.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			\bpmix, 0,
			\bpfac, 3,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\plop, 
	Pseq([
		Ptpar([
			8, Pfindur(16*7,Pdef(\bigperc)),
			0, Pseq([
				Pfindur(16,Pdef(\rogne_part1)),
				Pfindur(16,Pdef(\rogne_part2)),
				Pfindur(16,Pdef(\rogne_part3)),
				Pfindur(16,Pdef(\rogne_part4)),
				Pfindur(16,Pdef(\rogne_part5)),
				Event.silent(16),
				Pfindur(16,Pdef(\rogne_part2)),
				Pfindur(16,Pdef(\rogne_part3)), // end perc
				Pfindur(16,Pdef(\rogne_part1)),
			],1),

		]),
	])
)).play;
)

//////////////////////////////////


(
Pdef(\parthi, Pdef(\rogne_partxx, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1hi, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pstep(Pseq([
					0,1,1,-1,
					0,1,1,1,
				],inf),1) + Prand([0,0,0,0,12,24],inf),
				\xlag, Prand([
					0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,0,
					0,1/8,1/4,1/2,
				],inf),
				\lpf, Prand([300,200,400,1000],inf),
				\lag, Pkey(\xlag)/~t,
				\legato, 0.8-Pkey(\xlag),
				\octave, 3,
				\dur, PdurStutter(Prand([1,4,2,8],inf), 1),
				\amp, 0.1,
			),
			Pmono(\ulu,
				\freq, Pseq([
					800, 800, 800, 800,
					800, 800, 800, 800,
					800, 800, 800, 800,
					800, 1800, 800, 80,
				],inf),
				\fmtamp, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,0,1,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 1,0,1,1,
					0,0,1,0, 1,0,0,0,
				],inf)+0.2,
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \default,
				\fmtamp,1,
				\note, Pseq([
					Pwalk((1..24), Pseq([
						1,2,3,Pwhite(1,10,1),
					],inf)),
				],inf),
				\dur, Prand([1,1/2,1/4],inf),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \iron,
				\note, Pseq([
					0,1,-10,20,
				],inf).stutter(3),
				\detune, 500,
				\legato, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 4,0,0,0,
						0,0,2,0, 0,1,0,1,
						1,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus1hi, \audio, 2),
			'wet10', 1.0,
			'mix', 0.85714285714286,
			'gain', 0.344889782792 * Pseq([
				1
			],inf),
			'fb', 0.00001099467303085,
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.00000210000543560101,
			//\delay, ~pmodenv.(Pseq([0.00001,0.002,0.002,1,0.0004],inf), 8),
			//\delay2, ~pmodenv.(Pseq([0.30001,0.002,0.002,1,0.0004],inf), 7.123),
			\delay, ~pmodenv.(
				Plazy({ arg ev;
					var rr = exprand(1.0,0.000001);
					var rr2 = exprand(1.0,0.000001);
					Pseq([rr, rr,rr2],1);
				}).loop, 
				Pseq([6,1,1],inf)
			),
			\delay2, ~pmodenv.(
				Plazy({ arg ev;
					var rr = exprand(1.0,0.000001);
					var rr2 = exprand(1.0,0.000001);
					Pseq([rr, rr,rr2],1);
				}).loop, 
				Pseq([6,1,1],inf)
			),
			'distamp', 11.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			\bpmix, 0,
			\bpfac, 3,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),

		
	])
)).play;
);


(
SynthDef(\ulu2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\parthi, Pdef(\xxplop, 
	Ppar([
		3.collect  {
			Pbind(
				\instrument, \ulu2,
				\freq, Pexprand(50.0,12000),
				\legato, Pwhite(0.1,1.2),
				\dur, Pwhite(0.1,2),
				\amp, 0.1,
			);
		}
	].flat)
)).play;
)

(
Pdef(\parthi, Pdef(\plophi, 
	Ppar([
		Pbind(
			\instrument, \ulu2,
			\freq, Pseq([
				5120,5212,
			],inf),
			\legato, Pwhite(0.1,1.2),
			\dur, 1/16,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \ulu2,
			\freq, Pseq([
				2120,2312,
			],inf),
			\legato, Pwhite(0.1,1.2),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \ulu2,
			\freq, Pseq([
				1020,1112,
			],inf),
			\legato, Pwhite(0.1,1.2),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \ulu2,
			\freq, Pseq([
				520,572,
			],inf),
			\legato, Pwhite(0.1,1.2),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \ulu2,
			\freq, Pseq([
				220,272,
			],inf),
			\legato, Pwhite(0.1,1.2),
			\dur, 1/1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \ulu2,
			\freq, Pseq([
				90,82,
			],inf),
			\legato, Pwhite(0.1,1.2),
			\dur, 2,
			\amp, 0.1,
		),
	].flat)
)).play;
)


(
Pdef(\parthi, Pdef(\plophi, 
	Ppar([
		6.collect({ arg idx;
			var idxx=idx+1;
			Pbind(
				\instrument, \ulu,
				\fspread, 0.001,
				\freq, Pseq([
					rrand(0.8,1.2) * 90 * ( 2**idx ),
				],inf),
				\dur, 1/16 * ( 2**idx ),
				\amp, 0.1,
			);
		
		}),
	].flat)
)).play;
)

(
Pdef(\parthi, Pdef(\plophi, 
	Ppar([
		6.collect({ arg idx;
			var idxx=idx+1;
			Pbind(
				\instrument, \ulu,
				\fspread, 0.001,
				\freq, Pseq([
					rrand(0.8,1.2) * 90 * ( 2**idx ),
				],inf),
				\dur, 2 / ( 2**idx ),
				\amp, 0.1,
			);
		
		}),
	].flat)
)).play;
)

(
Pdef(\parthi, Pdef(\plophi, 
	Ppar([
		6.collect({ arg idx;
			var idxx=idx+1;
			Pbind(
				\instrument, \ulu,
				\fspread, 0.001,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\freq, Pseq([
					rrand(0.8,1.2) * 90 * ( 2**idx ),
				],inf),
				\dur, 2 / ( 2**idx ),
				\amp, 0.1,
			);
		
		}),
	].flat)
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1hi, \audio)) <>
		Ppar([
			6.collect({ arg idx;
				var idxx=idx+1;
				Pseq([
					Pfindur(8 + idx,
						Pbind(
							\instrument, \ulu,
							\isRest, Pseq([
								1,1,1,1, 0,0,0,0,
								1,1,0,0,
							],inf).coin.not,
							\fspread, 0.001,
							\freq, Pseq([
								rrand(0.8,1.2) * 90 * ( 2**idx ),
							],inf),
							\dur, 2 / ( 2**idx ),
							\amp, 0.1,
						),
					),
					Pfindur(8 + idx,
						Pbind(
							\instrument, \ulu,
							\fspread, 0.001,
							\isRest, Pseq([
								1,1,1,1, 0,0,0,0,
								1,1,0,0,
							],inf).coin.not,
							\freq, Pseq([
								rrand(0.8,1.2) * 90 * ( 2**idx ),
							],inf),
							\dur, 1/16 * ( 2**idx ),
							\amp, 0.1,
						),
					),
				],inf);
		
			}),
		].flat),
			Pmono( \rdncleandist_fulllight,
				\addAction, \addToTail,
				\inbus, BusDef(\sendbus1hi, \audio, 2),
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.644889782792 * Pseq([
					1
				],inf),
				'fb', 0.00001099467303085,
				'delay', 0.000001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.00000210000543560101,
				//\delay, ~pmodenv.(Pseq([0.00001,0.002,0.002,1,0.0004],inf), 8),
				//\delay2, ~pmodenv.(Pseq([0.30001,0.002,0.002,1,0.0004],inf), 7.123),
				\delay, ~pmodenv.(
					Plazy({ arg ev;
						var rr = exprand(1.0,0.000001);
						var rr2 = exprand(1.0,0.000001);
						Pseq([rr, rr,rr2],1);
					}).loop, 
					Pseq([6,1,1],inf)
				),
				\delay2, ~pmodenv.(
					Plazy({ arg ev;
						var rr = exprand(1.0,0.000001);
						var rr2 = exprand(1.0,0.000001);
						Pseq([rr, rr,rr2],1);
					}).loop, 
					Pseq([6,1,1],inf)
				),
				'distamp', 01.361836201538,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'fbdistamp', 0.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				\bpmix, 0,
				\bpfac, 3,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/4,
			),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,1, 0,0,1, 0,0,1, 0,0,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, (Pseq([
					0,0,0,0,0,
					1,1,
					0,0,1,0,0,1,
				],inf) * Pseq([
					Pseq([
						Pseq([
							1,1, 1,1, 1,1, 1,1,
						],4),
					],inf),
				],inf)).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\lag, (1/16/~t),
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pseq([
						Pseq([
							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,
						],8),
					],inf),

				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.3,
				\lag, 0.04,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792 ,
			'fb', 0.0004099467303085 * Pseq([1,2,1,1, 2,1,1,2],inf),
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000210000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
	]),
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1hi, \audio)) <>
		Ppar([
			6.collect({ arg idx;
				var idxx=idx+1;
				Pseq([
					Pfindur(8 + idx,
						Pbind(
							\instrument, \ulu,
							\isRest, Pseq([
								1,1,1,1, 0,0,0,0,
								1,1,0,0,
							],inf).coin.not,
							\fspread, 0.001,
							\freq, Pseq([
								rrand(0.8,1.2) * 90 * ( 2**idx ),
								rrand(0.8,1.2) * 90 * ( 2**idx ),
							],inf),
							\dur, 2 / ( 2**idx ),
							\amp, 0.1,
						),
					),
					Pfindur(8 + idx,
						Pbind(
							\instrument, \ulu,
							\fspread, 0.001,
							\isRest, Pseq([
								1,1,1,1, 0,0,0,0,
								1,1,0,0,
							],inf).coin.not,
							\freq, Pseq([
								rrand(0.8,1.2) * 90 * ( 2**idx ),
								rrand(0.8,1.2) * 90 * ( 2**idx ),
							],inf),
							\dur, 1/16 * ( 2**idx ),
							\amp, 0.1,
						),
					),
				],inf);
		
			}),
		].flat),
			Pmono( \rdncleandist_fulllight,
				\addAction, \addToTail,
				\inbus, BusDef(\sendbus1hi, \audio, 2),
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.644889782792 * Pseq([
					1
				],inf),
				'fb', 0.00001099467303085,
				'delay', 0.000001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.00000210000543560101,
				//\delay, ~pmodenv.(Pseq([0.00001,0.002,0.002,1,0.0004],inf), 8),
				//\delay2, ~pmodenv.(Pseq([0.30001,0.002,0.002,1,0.0004],inf), 7.123),
				\delay, ~pmodenv.(
					Plazy({ arg ev;
						var rr = exprand(1.0,0.000001);
						var rr2 = exprand(1.0,0.000001);
						Pseq([rr, rr,rr2],1);
					}).loop, 
					Pseq([6,1,1],inf)
				),
				\delay2, ~pmodenv.(
					Plazy({ arg ev;
						var rr = exprand(1.0,0.000001);
						var rr2 = exprand(1.0,0.000001);
						Pseq([rr, rr,rr2],1);
					}).loop, 
					Pseq([6,1,1],inf)
				),
				'distamp', 01.361836201538,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'fbdistamp', 0.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				\bpmix, 0,
				\bpfac, 3,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/4,
			),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,1, 0,0,1, 0,0,1, 0,0,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, (Pseq([
					0,0,0,0,0,
					1,1,
					0,0,1,0,0,1,
				],inf) * Pseq([
					Pseq([
						Pseq([
							1,1, 1,1, 1,1, 1,1,
						],4),
					],inf),
				],inf)).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\lag, (1/16/~t),
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pseq([
						Pseq([
							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,
						],8),
					],inf),

				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.3,
				\lag, 0.04,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792 ,
			'fb', 0.0004099467303085 * Pseq([1,2,1,1, 2,1,1,2],inf),
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000210000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
	]),
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1hi, \audio)) <>
		Ppar([
			6.collect({ arg idx;
				var idxx=idx+1;
				Pseq([
					Pfindur(8 + idx,
						Pbind(
							\instrument, \ulu,
							\isRest, Pseq([
								1,1,1,1, 0,0,0,0,
								1,1,0,0,
							],inf).coin.not,
							\fspread, 0.001,
							\note, Pseq([
								rrand(0,11) * 0 + ( idx*12 ),
								rrand(0,11) * 0 + ( idx*12 ),
							],inf),
							\dur, 2 / ( 2**idx ),
							\amp, 0.1,
						),
					),
					Pfindur(8 + idx,
						Pbind(
							\instrument, \ulu,
							\fspread, 0.001,
							\isRest, Pseq([
								1,1,1,1, 0,0,0,0,
								1,1,0,0,
							],inf).coin.not,
							\note, Pseq([
								rrand(0,11) * 0 + ( idx*12 ),
								rrand(0,11) * 0 + ( idx*12 ),
							],inf),
							\dur, 1/16 * ( 2**idx ),
							\amp, 0.1,
						),
					),
				],inf);
		
			}),
		].flat),
			Pmono( \rdncleandist_fulllight,
				\addAction, \addToTail,
				\inbus, BusDef(\sendbus1hi, \audio, 2),
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.644889782792 * Pseq([
					1
				],inf),
				'fb', 0.00001099467303085,
				'delay', 0.000001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.00000210000543560101,
				//\delay, ~pmodenv.(Pseq([0.00001,0.002,0.002,1,0.0004],inf), 8),
				//\delay2, ~pmodenv.(Pseq([0.30001,0.002,0.002,1,0.0004],inf), 7.123),
				\delay, ~pmodenv.(
					Plazy({ arg ev;
						var rr = exprand(1.0,0.000001);
						var rr2 = exprand(1.0,0.000001);
						Pseq([rr, rr,rr2],1);
					}).loop, 
					Pseq([6,1,1],inf)
				),
				\delay2, ~pmodenv.(
					Plazy({ arg ev;
						var rr = exprand(1.0,0.000001);
						var rr2 = exprand(1.0,0.000001);
						Pseq([rr, rr,rr2],1);
					}).loop, 
					Pseq([6,1,1],inf)
				),
				'distamp', 01.361836201538,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'fbdistamp', 0.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				\bpmix, 0,
				\bpfac, 3,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/4,
			),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,1, 0,0,1, 0,0,1, 0,0,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, (Pseq([
					0,0,0,0,0,
					1,1,
					0,0,1,0,0,1,
				],inf) * Pseq([
					Pseq([
						Pseq([
							1,1, 1,1, 1,1, 1,1,
						],4),
					],inf),
				],inf)).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\lag, (1/16/~t),
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pseq([
						Pseq([
							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,
						],8),
					],inf),

				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.3,
				\lag, 0.04,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792 ,
			'fb', 0.0004099467303085 * Pseq([1,2,1,1, 2,1,1,2],inf),
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000210000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
	]),
)).play;
)


(
	// no real difference with \degree or different number of step, but rest change greatly
	// the 110000 pattern is very hip hop
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1hi, \audio)) <>
		Ppar([
			6.collect({ arg idx;
				var idxx=idx+1;
				Pbind(
					\scale, Scale.minor,
				)<>
				Pseq([
					Pfindur(8 + idx,
						Pbind(
							\instrument, \ulu,
							\isRest, Pseq([
								1,1, 0,0,0,0,
							],inf).coin.not,
							\fspread, 0.001,
							\degree, Pseq([
								rrand(0,6) * 0 + ( idx*7 ),
								rrand(0,6) * 0 + ( idx*7 ),
								rrand(0,6) * 0 + ( idx*7 ),
							],inf),
							\dur, 2 / ( 2**idx ),
							\amp, 0.1,
						),
					),
					Pfindur(8 + idx,
						Pbind(
							\instrument, \ulu,
							\fspread, 0.001,
							\isRest, Pseq([
								1,1, 0,0,0,0,
							],inf).coin.not,
							\degree, Pseq([
								rrand(0,6) * 0 + ( idx*7 ),
								rrand(0,6) * 0 + ( idx*7 ),
								rrand(0,6) * 0 + ( idx*7 ),
							],inf),
							\dur, 1/16 * ( 2**idx ),
							\amp, 0.1,
						),
					),
				],inf);
		
			}),
		].flat),
			Pmono( \rdncleandist_fulllight,
				\addAction, \addToTail,
				\inbus, BusDef(\sendbus1hi, \audio, 2),
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.644889782792 * Pseq([
					1
				],inf),
				'fb', 0.00001099467303085,
				'delay', 0.000001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.00000210000543560101,
				//\delay, ~pmodenv.(Pseq([0.00001,0.002,0.002,1,0.0004],inf), 8),
				//\delay2, ~pmodenv.(Pseq([0.30001,0.002,0.002,1,0.0004],inf), 7.123),
				\delay, ~pmodenv.(
					Plazy({ arg ev;
						var rr = exprand(1.0,0.000001);
						var rr2 = exprand(1.0,0.000001);
						Pseq([rr, rr,rr2],1);
					}).loop, 
					Pseq([6,1,1],inf)
				),
				\delay2, ~pmodenv.(
					Plazy({ arg ev;
						var rr = exprand(1.0,0.000001);
						var rr2 = exprand(1.0,0.000001);
						Pseq([rr, rr,rr2],1);
					}).loop, 
					Pseq([6,1,1],inf)
				),
				'distamp', 01.361836201538,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'fbdistamp', 0.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				\bpmix, 0,
				\bpfac, 3,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/4,
			),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,1, 0,0,1, 0,0,1, 0,0,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, (Pseq([
					0,0,0,0,0,
					1,1,
					0,0,1,0,0,1,
				],inf) * Pseq([
					Pseq([
						Pseq([
							1,1, 1,1, 1,1, 1,1,
						],4),
					],inf),
				],inf)).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\lag, (1/16/~t),
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pseq([
						Pseq([
							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,
						],8),
					],inf),

				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.3,
				\lag, 0.04,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792 ,
			'fb', 0.0004099467303085 * Pseq([1,2,1,1, 2,1,1,2],inf),
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000210000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
	]),
)).play;
)

(
// 10010010
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1hi, \audio)) <>
		Ppar([
			6.collect({ arg idx;
				var idxx=idx+1;
				Pbind(
					\scale, Scale.minor,
				)<>
				Pseq([
					Pfindur(8 + idx,
						Pbind(
							\instrument, \ulu,
							\isRest, Pseq([
								1,0, 0,1,0,0,1,0,
							],inf).coin.not,
							\fspread, 0.001,
							\degree, Pseq([
								rrand(0,6) * 0 + ( idx*7 ),
								rrand(0,6) * 0 + ( idx*7 ),
								rrand(0,6) * 0 + ( idx*7 ),
							],inf),
							\dur, 2 / ( 2**idx ),
							\amp, 0.1,
						),
					),
					Pfindur(8 + idx,
						Pbind(
							\instrument, \ulu,
							\fspread, 0.001,
							\isRest, Pseq([
								0,1, 1,0,1,1,0,1,
							],inf).coin.not,
							\degree, Pseq([
								rrand(0,6) * 0 + ( idx*7 ),
								rrand(0,6) * 0 + ( idx*7 ),
								rrand(0,6) * 0 + ( idx*7 ),
							],inf),
							\dur, 1/16 * ( 2**idx ),
							\amp, 0.1,
						),
					),
				],inf);
		
			}),
		].flat),
			Pmono( \rdncleandist_fulllight,
				\addAction, \addToTail,
				\inbus, BusDef(\sendbus1hi, \audio, 2),
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.644889782792 * Pseq([
					1
				],inf),
				'fb', 0.00001099467303085,
				'delay', 0.000001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.00000210000543560101,
				//\delay, ~pmodenv.(Pseq([0.00001,0.002,0.002,1,0.0004],inf), 8),
				//\delay2, ~pmodenv.(Pseq([0.30001,0.002,0.002,1,0.0004],inf), 7.123),
				\delay, ~pmodenv.(
					Plazy({ arg ev;
						var rr = exprand(1.0,0.000001);
						var rr2 = exprand(1.0,0.000001);
						Pseq([rr, rr,rr2],1);
					}).loop, 
					Pseq([6,1,1],inf)
				),
				\delay2, ~pmodenv.(
					Plazy({ arg ev;
						var rr = exprand(1.0,0.000001);
						var rr2 = exprand(1.0,0.000001);
						Pseq([rr, rr,rr2],1);
					}).loop, 
					Pseq([6,1,1],inf)
				),
				'distamp', 01.361836201538,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'fbdistamp', 0.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				\bpmix, 0,
				\bpfac, 3,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/4,
			),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,1, 0,0,1, 0,0,1, 0,0,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, (Pseq([
					0,0,0,0,0,
					1,1,
					0,0,1,0,0,1,
				],inf) * Pseq([
					Pseq([
						Pseq([
							1,1, 1,1, 1,1, 1,1,
						],4),
					],inf),
				],inf)).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\lag, (1/16/~t),
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pseq([
						Pseq([
							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,
						],8),
					],inf),

				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.3,
				\lag, 0.04,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792 ,
			'fb', 0.0004099467303085 * Pseq([1,2,1,1, 2,1,1,2],inf),
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000210000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
	]),
)).play;
)

(
// 10010010
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1hi, \audio)) <>
		Ppar([
			6.collect({ arg idx;
				var idxx=idx+1;
				Pbind(
					\scale, Scale.minor,
				)<>
				Pseq([
					Pfindur(1 * idxx,
						Pbind(
							\instrument, \ulu,
							\isRest, Pseq([
								1,0, 0,1,0,0,1,0,
							],inf).coin.not,
							\fspread, 0.001,
							\degree, Pseq([
								rrand(0,6) * 0 + ( idx*7 ),
								rrand(0,6) * 0 + ( idx*7 ),
								rrand(0,6) * 0 + ( idx*7 ),
							],inf),
							\dur, 2 / ( 2**idx ),
							\amp, 0.1,
						),
					),
					Pfindur(1 * idxx,
						Pbind(
							\instrument, \ulu,
							\fspread, 0.001,
							\isRest, Pseq([
								0,1, 1,0,1,1,0,1,
							],inf).coin.not,
							\degree, Pseq([
								rrand(0,6) * 0 + ( idx*7 ),
								rrand(0,6) * 0 + ( idx*7 ),
								rrand(0,6) * 0 + ( idx*7 ),
							],inf),
							\dur, 1/16 * ( 2**idx ),
							\amp, 0.1,
						),
					),
				],inf);
		
			}),
		].flat),
			Pmono( \rdncleandist_fulllight,
				\addAction, \addToTail,
				\inbus, BusDef(\sendbus1hi, \audio, 2),
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.644889782792 * Pseq([
					1
				],inf),
				'fb', 0.00001099467303085,
				'delay', 0.000001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.00000210000543560101,
				//\delay, ~pmodenv.(Pseq([0.00001,0.002,0.002,1,0.0004],inf), 8),
				//\delay2, ~pmodenv.(Pseq([0.30001,0.002,0.002,1,0.0004],inf), 7.123),
				\delay, ~pmodenv.(
					Plazy({ arg ev;
						var rr = exprand(1.0,0.000001);
						var rr2 = exprand(1.0,0.000001);
						Pseq([rr, rr,rr2],1);
					}).loop, 
					Pseq([6,1,1],inf)
				),
				\delay2, ~pmodenv.(
					Plazy({ arg ev;
						var rr = exprand(1.0,0.000001);
						var rr2 = exprand(1.0,0.000001);
						Pseq([rr, rr,rr2],1);
					}).loop, 
					Pseq([6,1,1],inf)
				),
				'distamp', 01.361836201538,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'fbdistamp', 0.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				\bpmix, 0,
				\bpfac, 3,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/4,
			),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,1, 0,0,1, 0,0,1, 0,0,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, (Pseq([
					0,0,0,0,0,
					1,1,
					0,0,1,0,0,1,
				],inf) * Pseq([
					Pseq([
						Pseq([
							1,1, 1,1, 1,1, 1,1,
						],4),
					],inf),
				],inf)).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\lag, (1/16/~t),
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pseq([
						Pseq([
							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,
						],8),
					],inf),

				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.3,
				\lag, 0.04,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792 ,
			'fb', 0.0004099467303085 * Pseq([1,2,1,1, 2,1,1,2],inf),
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000210000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
	]),
)).play;
)



//////////////////////////////////
(
// 10010010 manualy
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1hi, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \iron,
				\note, Pseq([
					0,2,3,4,
				],inf),
				\isRest, Pseq([
					1,0, 0,1,0,0,1,0,
					1,0, 0,1,0,0,1,0,
					1,0, 0,1,0,0,1,0,
					1,1, 1,1,0,0,1,0,
				],inf).coin.not,
				\legato, Pwhite(0.1,1.2),
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \iron,
				\note, Pseq([
					0,2,3,4,
				],inf),
				\octave, 6,
				\diff, 0.0001,
				\isRest, Pseq([
					Pseq([
						1,0, 0,1,0,0,1,0,
					],4),
					Pseq([
						0,1, 1,0,1,1,0,1,
					],4),
				],inf).coin.not,
				\legato, Pwhite(0.1,1.2),

				\dur, 1/4,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,-1,
				],inf),
				\octave, 3,
				\diff, 0.0001,
				\isRest, Pseq([
					Pseq([
						1,0, 0,1,0,0,1,0,
					],1),
					Pseq([
						0,1, 1,0,1,1,0,1,
					],1),
				],inf).coin.not,
				\legato, Pwhite(0.1,1.2),

				\dur, 1/2,
				\amp, 0.1,
			),
		].flat),
			Pmono( \rdncleandist_fulllight,
				\addAction, \addToTail,
				\inbus, BusDef(\sendbus1hi, \audio, 2),
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.644889782792 * Pseq([
					1
				],inf),
				'fb', 0.00001099467303085,
				'delay', 0.000001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.00000210000543560101,
				//\delay, ~pmodenv.(Pseq([0.00001,0.002,0.002,1,0.0004],inf), 8),
				//\delay2, ~pmodenv.(Pseq([0.30001,0.002,0.002,1,0.0004],inf), 7.123),
				\delay, ~pmodenv.(
					Plazy({ arg ev;
						var rr = exprand(1.0,0.000001);
						var rr2 = exprand(1.0,0.000001);
						Pseq([rr, rr,rr2],1);
					}).loop, 
					Pseq([6,1,1],inf)
				),
				\delay2, ~pmodenv.(
					Plazy({ arg ev;
						var rr = exprand(1.0,0.000001);
						var rr2 = exprand(1.0,0.000001);
						Pseq([rr, rr,rr2],1);
					}).loop, 
					Pseq([6,1,1],inf)
				),
				'distamp', 01.361836201538,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'fbdistamp', 0.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				\bpmix, 0,
				\bpfac, 3,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/4,
			),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,1, 0,0,1, 0,0,1, 0,0,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, (Pseq([
					0,0,0,0,0,
					1,1,
					0,0,1,0,0,1,
				],inf) * Pseq([
					Pseq([
						Pseq([
							1,1, 1,1, 1,1, 1,1,
						],4),
					],inf),
				],inf)).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\lag, (1/16/~t),
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pseq([
						Pseq([
							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,
						],8),
					],inf),

				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.3,
				\lag, 0.04,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792 ,
			'fb', 0.0004099467303085 * Pseq([1,2,1,1, 2,1,1,2],inf),
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000210000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
	]),
)).play;
)


(
// 10010010 manualy
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1hi, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \iron,
				\note, Pseq([
					2,2,1,2,
					2,2,1,2,
					2,2,1,2,
					2,2,1,2,
					-2,-2,1,-2,
					-2,-2,1,-2,
					-2,-2,1,-2,
					-2,-2,1,-2,
				],inf),
				\isRest, Pseq([
					1,0, 0,1,0,0,1,0,
					1,0, 0,1,0,0,1,0,
					1,0, 0,1,0,0,1,0,
					1,1, 1,1,0,0,1,0,
				],inf).coin.not,
				\legato, Pwhite(0.1,1.2),
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \iron,
				\note, Pseq([
					2,2,1,2,
					2,2,1,2,
					2,2,1,2,
					2,2,1,2,
					-2,-2,1,-2,
					-2,-2,1,-2,
					-2,-2,1,-2,
					-2,-2,1,-2,
				],inf),
				\octave, 6,
				\diff, 0.0001,
				\isRest, Pseq([
					Pseq([
						1,0, 0,1,0,0,1,0,
					],4),
					Pseq([
						0,1, 1,0,1,1,0,1,
					],4),
				],inf).coin.not,
				\legato, Pwhite(0.1,1.2),

				\dur, 1/4,
				\amp, 0.1,
			),
		].flat),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus1hi),
			\mix, 0.2,
			\out, BusDef(\sendbus2hi, \audio),
			\dur, 1,
		),
			Pmono( \rdncleandist_fulllight,
				\addAction, \addToTail,
				\inbus, BusDef(\sendbus2hi, \audio, 2),
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.644889782792 * Pseq([
					1
				],inf),
				'fb', 0.00001099467303085,
				'delay', 0.000001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.00000210000543560101,
				//\delay, ~pmodenv.(Pseq([0.00001,0.002,0.002,1,0.0004],inf), 8),
				//\delay2, ~pmodenv.(Pseq([0.30001,0.002,0.002,1,0.0004],inf), 7.123),
				\delay, ~pmodenv.(
					Plazy({ arg ev;
						var rr = exprand(1.0,0.000001);
						var rr2 = exprand(1.0,0.000001);
						Pseq([rr, rr,rr2],1);
					}).loop, 
					Pseq([6,1,1],inf)
				),
				\delay2, ~pmodenv.(
					Plazy({ arg ev;
						var rr = exprand(1.0,0.000001);
						var rr2 = exprand(1.0,0.000001);
						Pseq([rr, rr,rr2],1);
					}).loop, 
					Pseq([6,1,1],inf)
				),
				'distamp', 01.361836201538,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 1717,
				'fbdistamp', 70.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				\bpmix, 0,
				\bpfac, 3,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/4,
			),
			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \basicbass,
					\note, Pseq([
						0,0,0,-1,
					],inf),
					\octave, 3,
					\lpf, Pseg(Pwhite(200,700),1),
					\isRest, Pseq([
						Pseq([
							1,0, 0,1,0,0,1,0,
						],1),
						Pseq([
							0,1, 1,0,1,1,0,1,
						],1),
					],inf).coin.not,
					\legato, Pwhite(0.1,1.2),
				
					\dur, 1/2,
					\amp, 0.1,
				),
				Pbind(
					\instrument, \ulu,
					\note, Pseq([
						0,0,0,-1,
					],inf),
					\octave, 4,
					\isRest, Pseq([
						Pseq([
							1,0, 0,1,0,0,1,0,
						],1),
						Pseq([
							0,1, 1,0,1,1,0,1,
						],1),
					],inf).coin.not,
					\dur, 1/2,
					\amp, 0.1,
				),
			]),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792 ,
			'fb', 0.0004099467303085,
			'delay', 0.010001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.00000210000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 11.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,1, 0,0,1, 0,0,1, 0,0,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, (Pseq([
					0,0,0,0, 0,1,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0, 1,
				],inf) * Pseq([
					Pseq([

						Pseq([
							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,

							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,

							1,0,1,0, 1,0,1,0,
							1,1, 1,1, 1,1, 1,1,

							0,0, 0,0, 1,1, 1,1,
							1,1,1,1, 0,0,0,0,

							1,1, 1,1, 1,1, 1,1,
							1,0,1,0, 1,0,1,0,

							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,
						],4),
					],inf),
				],inf)).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\lag, (1/16/~t),
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pseq([
						Pseq([

							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,

							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,

							1,0,1,0, 1,0,1,0,
							1,1, 1,1, 1,1, 1,1,

							0,0, 0,0, 1,1, 1,1,
							1,1,1,1, 0,0,0,0,

							1,1, 1,1, 1,1, 1,1,
							1,0,1,0, 1,0,1,0,

							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,
						],8),
					],inf),

				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.3,
				\lag, 0.04,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792 ,
			'fb', 0.0004099467303085 * Pseq([1,2,1,1, 2,1,1,2],inf),
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000210000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
	]),
)).play;
)



(
SynthDef(\tricera, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig1 = Duty.kr(1/4/~t, 0, Dseq([
		//1,1,0,1, 1,0,1,0,
		//0,0,1,0, 0,1,0,1,
		1,0,0,1, 0,0,1,0,
	].rotate(2),inf))*2;
	env1 = EnvGen.kr(Env([2,2,1],[0.1,1.7],-1), sig1);
	
	sig = LFSaw.ar(freq * ( env1/4+1 ) * ( SinOsc.ar(freq * env1) * 1 + 1 ));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * env1, \rq.kr(0.5));
	sig = sig * ( env1/2 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono( \tricera,
			\freq, 70,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,1, 0,0,1, 0,0,1, 0,0,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, (Pseq([
					0,0,0,0, 0,1,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0, 1,
				],inf) * Pseq([
					Pseq([

						Pseq([
							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,

							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,

							1,0,1,0, 1,0,1,0,
							1,1, 1,1, 1,1, 1,1,

							0,0, 0,0, 1,1, 1,1,
							1,1,1,1, 0,0,0,0,

							1,1, 1,1, 1,1, 1,1,
							1,0,1,0, 1,0,1,0,

							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,
						],4),
					],inf),
				],inf)).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\lag, (1/16/~t),
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pseq([
						Pseq([

							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,

							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,

							1,0,1,0, 1,0,1,0,
							1,1, 1,1, 1,1, 1,1,

							0,0, 0,0, 1,1, 1,1,
							1,1,1,1, 0,0,0,0,

							1,1, 1,1, 1,1, 1,1,
							1,0,1,0, 1,0,1,0,

							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,
						],8),
					],inf),

				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.3,
				\lag, 0.04,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792 ,
			'fb', 0.0004099467303085 * Pseq([1,2,1,1, 2,1,1,2],inf),
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000210000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
	])
)).play;
)


(
SynthDef(\tricera, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig1 = Duty.kr(1/4/~t, 0, Dseq([
		//1,1,0,1, 1,0,1,0,
		//0,0,1,0, 0,1,0,1,
		1,0,0,1, 0,0,1,0,
	].rotate(2),inf))*2;
	env1 = EnvGen.kr(Env([2,2,1],[0.1,1.7],-1), sig1);
	env2 = EnvGen.kr(Env([0.1,0.1,2],[0.1,1.7],-1), sig1);
	freq = freq * [1,1/2,1/4,2];
	
	sig = LFSaw.ar(freq * ( env1/8+1 ) * ((0..7)/7 - 0.5 * \fspread.kr(0.01) * env2 + 1) * ( SinOsc.ar(freq * (env1/10 + 1)) * env2 * 2 + 1 ));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * env1, \rq.kr(0.5));
	sig = sig * ( env1/2 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + SinOsc.kr((1..8)/8); 
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\tricera2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,1,0, 1,0,1,0,
	].rotate(0),inf));
	env1 = EnvGen.kr(Env([2,2,1],[0.1,0.7],-1), sig1);
	env2 = EnvGen.kr(Env([0.1,0.1,2],[0.1,0.7],-1), sig1);
	freq = freq * [1,1/2,1/4,2];
	
	sig = LFSaw.ar(freq * ( env2/80+1 ) * ((0..7)/7 - 0.5 * \fspread.kr(0.01) * env1 + 1) * ( SinOsc.ar(freq * (env1/10 + 1)) * env2 * 2 + 1 ));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * env1, \rq.kr(0.5));
	sig = sig * ( env1/2 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + SinOsc.kr((1..8)/8); 
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\tricera3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig1 = Duty.kr(1/2/~t, 0, Dseq([
		//1,1,0,1, 1,0,1,0,
		//0,0,1,0, 0,1,0,1,
		1,0,0,1, 0,0,1,0,
	].rotate(0),inf))*2;
	env1 = EnvGen.kr(Env([2,2,1],[0.1,1.7],-1), sig1);
	env2 = EnvGen.kr(Env([0.1,0.1,2],[0.1,1.7],-1), sig1);
	freq = freq * [1,1/2,1/4,2];
	
	sig = LFSaw.ar(freq * ( env2/8+1 ) * ((0..7)/7 - 0.5 * \fspread.kr(0.01) * env1 + 1) * ( SinOsc.ar(freq * (env1/10 + 1)) * env2 * 2 + 1 ));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * env2, \rq.kr(0.5));
	sig = sig * ( env1/2 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + SinOsc.kr((1..8)/8); 
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono( \tricera,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono( \tricera2,
			\note, Pseq([
				1,2,3,4,
			],inf),
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pmono( \tricera3,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\octave, 7,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,1, 0,0,1, 0,0,1, 0,0,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, (Pseq([
					0,0,0,0, 0,1,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0, 1,
				],inf) * Pseq([
					Pseq([

						Pseq([
							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,

							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,

							1,0,1,0, 1,0,1,0,
							1,1, 1,1, 1,1, 1,1,

							0,0, 0,0, 1,1, 1,1,
							1,1,1,1, 0,0,0,0,

							1,1, 1,1, 1,1, 1,1,
							1,0,1,0, 1,0,1,0,

							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,
						],4),
					],inf),
				],inf)).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\lag, (1/16/~t),
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					Pseq([
						Pseq([

							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,

							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,

							1,0,1,0, 1,0,1,0,
							1,1, 1,1, 1,1, 1,1,

							0,0, 0,0, 1,1, 1,1,
							1,1,1,1, 0,0,0,0,

							1,1, 1,1, 1,1, 1,1,
							1,0,1,0, 1,0,1,0,

							1,1, 1,1, 1,1, 1,1,
							0,0,0,0, 0,0,0,0,
						],8),
					],inf),

				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.3,
				\lag, 0.04,
				\dur, 1/8,
				\amp, 0.02 * Pseq([1,0.7],inf),
			),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792 ,
			'fb', 0.0004099467303085 * Pseq([1,2,1,1, 2,1,1,2],inf),
			'delay', 0.000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000210000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
	])
)).play;
)
