~t = 180/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\mixosc, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread = 0.01;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.ar(freq*[1,2,1/2,1.001]);
	sig2 = LFSaw.ar(freq+1);
	sig3 = SinOsc.ar(freq * ( SinOsc.ar(freq * \fmr.kr(2)) * 1 + 1 )+1);
	sig = SelectX.ar( SinOsc.kr(freq * 2 * ((0..7)/7 - 0.5 * fspread + 1)).range(0,2), [ sig1, sig2, sig3 ] );
	sig = RLPF.ar(sig, \lpfr.kr(2.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + LFNoise1.kr(1/8!8, mul: XLine.kr(0.5,1,1));
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig / 1.2;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \mixosc,
			\fmr, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\fspread, ~pmodenv.(Pseq([0.00001,0.002,0.1],inf), 8),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\rq, ~pmodenv.(Pseq([1,2,1,4]/8,inf), 5),
			\legato, 1,
			\note, Pseq([
				0,1,8,7,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(\out, BusDef(\kickbus, \audio)) <>
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
		]),
	Pbind(
		\instrument, \iron,
		\note, Pstep(Pseq([
			0,0,0,-1,
		],inf),1/2) + [0,3,7],
		\octave, 9,
		\hpf, 30,
		\env1, Pseq([
			[ Env([1,1.5,1],[0.1,0.8]) ]
		],inf),
		\diff, 1.1,
		\fmr, 1/4 * Pseq([1,0.1],inf).stutter(2),
		\lpfr,2,
		\adsr, Pseq([
			[ Env.adsr(0.051,0.01,0.8,0.2) ],
			[ Env.adsr(0.051,0.01,0.8,0.1) ],
		],inf).stutter(2),
		\legato, Pseq([
			1,0,1,0, 
		],inf)/10,
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/16,
		\panwidth, 0.2,
		\gain, 5,
		\amp,0.05,
	),
	Pbind(
		\instrument, \snapkickx,
		\dur, 1/8,
		\isRest, Pseq([
			1,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\amp, 0.1,
		\out, BusDef(\kickbus, \audio),
	),
	Pmono( \rdncleandist_fulllight,
		\inbus, BusDef(\kickbus, \audio, 2),
		\addAction, \addToTail,
		'mix', 0.15714285714286,
		'gain', 0.7344889782792,
		'fb', 0.0002099467303085,
		'delay', 0.000600001231 * Pseq([
			1,
		],inf).stutter(1),
		'delay2', 0.000000543560101,
		'distamp', 1.361836201538,
		'prelpf', 19900,
		'prehpf', 17,
		'lpf', 19900,
		'hpf', 17,
		'fbdistamp', 4.5388371966577,
		'fbdistmix', 0.98176470588235,
		'postlpf', 19900,
		'posthpf', 17,
		\bpmix, 0,
		'wetamp', 0.20503372119697,
		'indelay', 0.04,
		\dur, 1,
	),
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \mixosc,
			\fmr, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\fspread, ~pmodenv.(Pseq([0.00001,0.002,0.1],inf), 8),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\rq, ~pmodenv.(Pseq([1,2,1,4]/8,inf), 5),
			\legato, 1,
			\note, Pseq([
				0,1,8,7,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(\out, BusDef(\kickbus, \audio)) <>
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
		]),
	Pbind(
		\instrument, \iron,
		\note, Pstep(Pseq([
			0,0,0,-1,
		],inf),1/2) + [0,3,7],
		\octave, 9,
		\hpf, 30,
		\env1, Pseq([
			[ Env([1,1.5,1],[0.1,0.8]) ]
		],inf),
		\diff, 1.1,
		\fmr, 1/4 * Pseq([1,0.1],inf).stutter(2),
		\lpfr,2,
		\adsr, Pseq([
			[ Env.adsr(0.051,0.01,0.8,0.2) ],
			[ Env.adsr(0.051,0.01,0.8,0.1) ],
		],inf).stutter(2),
		\legato, Pseq([
			1,0,1,0, 
		],inf)/10,
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/16,
		\panwidth, 0.2,
		\gain, 5,
		\amp,0.05,
	),
	Pbind(
		\instrument, \iron,
		\note, Pstep(Pseq([
			0,0,0,-1,
		],inf),1/2) + [0,3,7],
		\octave, 9,
		\hpf, 30,
		\env1, Pseq([
			[ Env([1,1.5,1],[0.1,0.8]) ]
		],inf),
		\diff, 1.1,
		\fmr, 1/4 * Pseq([1,0.1],inf).stutter(2),
		\lpfr,2,
		\adsr, Pseq([
			[ Env.adsr(0.051,0.01,0.8,0.2) ],
			[ Env.adsr(0.051,0.01,0.8,0.1) ],
		],inf).stutter(2),
		\legato, Pseq([
			3,0,0,0, 1,1,0,1, 
			1,3,0,0, 2,0,1,1, 
			3,0,0,1, 1,2,0,0, 
			1,3,0,0, 2,0,1,1, 
		],inf)/10,
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/16,
		\panwidth, 0.2,
		\gain, 5,
		\amp,0.05 * Pseg(Pseq([0,1],inf),8),
	),
	Pbind(
		\instrument, \snapkickx,
		\dur, 1/8,
		\isRest, Pseq([
			1,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\amp, 0.1,
		\out, BusDef(\kickbus, \audio),
	),
	Pmono( \rdncleandist_fulllight,
		\inbus, BusDef(\kickbus, \audio, 2),
		\addAction, \addToTail,
		'mix', 0.15714285714286,
		'gain', 0.7344889782792,
		'fb', 0.0002099467303085,
		'delay', 0.000600001231 * Pseq([
			1,
		],inf).stutter(1),
		'delay2', 0.000000543560101,
		'distamp', 1.361836201538,
		'prelpf', 19900,
		'prehpf', 17,
		'lpf', 19900,
		'hpf', 17,
		'fbdistamp', 4.5388371966577,
		'fbdistmix', 0.98176470588235,
		'postlpf', 19900,
		'posthpf', 17,
		\bpmix, 0,
		'wetamp', 0.20503372119697,
		'indelay', 0.04,
		\dur, 1,
	),
	Pmono( \rdncleandist_fulllight,
		\inbus, BusDef(\kickbus, \audio, 2),
		\addAction, \addToTail,
		'mix', 0.15714285714286,
		'gain', 0.7344889782792,
		'fb', 0.0002099467303085,
		'delay', 0.000600001231 * Pseq([
			1,
		],inf).stutter(1),
		'delay2', 0.000000543560101,
		'distamp', 1.361836201538,
		'prelpf', 19900,
		'prehpf', 17,
		'lpf', 19900,
		'hpf', 170,
		'fbdistamp', 4.5388371966577,
		'fbdistmix', 0.98176470588235,
		'postlpf', 19900,
		'posthpf', 817,
		\bpmix, 0,
		'wetamp', 0.20503372119697,
		'indelay', 0.04,
		\dur, 1,
	),
	])
)).play;
)
