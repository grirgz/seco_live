

~t = 135/4/60; TempoClock.default.tempo = ~t;


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
