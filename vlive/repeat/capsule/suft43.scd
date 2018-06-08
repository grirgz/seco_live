
(
SynthDef(\tere, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ( LFNoise1.ar({ 0.1.rand }!10 * LFNoise1.ar({ 10.0.rand }!10)) * 1 + 1 ));
	sig = sig + SinOsc.ar(freq * ( LFNoise1.ar({ 0.1.rand }!10 * LFNoise1.ar({ 10.0.rand }!10)) * 1 + 1 ));
	sig = RLPF.ar(sig, \lpfr.kr(2) * freq * ( LFNoise1.ar(0.1.rand!10) * 1 + 1 ), \rq.kr(0.5));
	sig = sig * 4;
	pan = pan + LFNoise1.ar(1!10);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono(\tere,
			\note, Pseq([
				0,3,7,-3,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \tere,
			\freq, 200,
			\dur, 1,
			\lpfr, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,2.1) ],
			],inf),
			\lpfr, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \tere,
			\freq, 800,
			\legato, 0.2 * Pseq([
				1,2,
			],inf),
			\dur, 1/4,
			\lpfr, 1/2,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \tere,
			//\freq, ~pmodsynth.({ LFNoise1.kr(4/~t).range(10000,100) }),
			\freq, Pseq([
				10000,2424,
			],inf),
			\lpfr, 1/2,
			\legato, 2,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \tere,
			\freq, 200,
			\dur, 1,
			\lpfr, 1/2,
			\lpfr, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \tere,
			\freq, 800,
			\legato, 0.2 * Pseq([
				1,2,
			],inf),
			\dur, 1/4,
			\lpfr, 1/2,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \tere,
			//\freq, ~pmodsynth.({ LFNoise1.kr(4/~t).range(10000,100) }),
			\freq, Pseq([
				10000,2424,
			],inf),
			\lpfr, 1/2,
			\legato, 2,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\sendbus1, \audio),
			\delay, Pwhite(0.05,0.8) * Pseg(Pseq([1,0.1],inf),8),
			\decay, 10,
			\freq, 200,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
)


(
SynthDef(\korade, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1/10,10],[0.1,2.8,3]), 1);
	env1 = Duty.kr(1/2/~t, 0, Dseq([
		1,2,4,1/3,
	],inf));
	sig = WhiteNoise.ar + LFSaw.ar(freq * ( SinOsc.ar(freq) * 10 + 1 ));
	sig1 = LFSaw.ar(freq * ( SinOsc.ar(freq*(1..10)/5 * env1) * LFNoise1.ar(1.0!10).range(0.1,10) + 1 ));
	sig2 = SinOsc.ar(freq * ( SinOsc.ar(freq*(1..10)/5 * env1) * LFNoise1.ar(1.0!10).range(0.1,10) + 1 ));
	sig3 = sig1 + sig2;

	sig4 = RLPF.ar(sig3, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig5 = RLPF.ar(sig3, freq *2 * ( 2**([5,7]/12) ), LFNoise1.ar(1).range(0.05,0.4));

	sig6 = SinOsc.ar(freq * XLine.kr(2,1,0.01)) * EnvGen.kr(Env([0,1,0],[0.01,0.4]), 1);
	sig = sig4 + sig5 + sig6;
	sig = sig  /8;

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.5)), gate, doneAction:2);
	sig = Splay.ar(sig, 1, amp, pan);
	Out.ar(out, sig);
}).add;
);

Pdef(\part).clear;
Pdef(\part2).clear;

(
Pdef(\part2, Pdef(\zed2, 
	Ppar([
		Pbind(
			\instrument, \korade,
			\note, Pseq([
				1,0,2,
			],inf),
			\octave, 7,
			\rq, 0.1,
			\lpfr, ~pmodenv.(Prand([1/2,2,1,4],inf), 8),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \korade,
			\note, Pseq([
				1,0,2,
			],inf),
			\octave, 6,
			\rq, 0.1,
			\lpfr, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
)


Pdef(\part).clear;

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pseq([
			Pfindur(8,
				Ppar([
					Pbind(
						\instrument, \korade,
						\freq, Pseq([
							5000,1500,
							7000,1500,
						],inf) + Pwhite(-1000.0,1000),
						\octave, 8,
						\adsr, Pseq([
							[ Env.adsr(0.1,0.1,0.8,3.1) ],
						],inf),
						\rq, 0.1,
						\lpfr, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
						\dur, Pseq([
							1,0.1,1,0.3,
							1,0.2, 1,0.4,
						].clump( 2 ).collect(_.normalizeSum).flat * 4,inf),
						\amp, 0.1,
						\out, BusDef(\bsendbus1, \audio),
					),
					Pbind(
						\instrument, \korade,
						\freq, Pseq([
							1000,1500,
							7000,1500,
							10000,1500,
							7000,1500,
						],inf) + Pwhite(-1000.0,1000),
						\octave, 8,
						\adsr, Pseq([
							[ Env.adsr(0.1,0.1,0.8,3.1) ],
						],inf),
						\rq, 0.1,
						\lpfr, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
						\dur, Pseq([
							1,0.2, 1,0.4,
							1,0.1,1,0.3,
						].clump( 2 ).collect(_.normalizeSum).flat,inf),
						\amp, 0.1,
						\out, BusDef(\bsendbus1, \audio),
					),
				]),
			),
			Pfindur(8,
				Ppar([
					Pbind(
						\instrument, \korade,
						\freq, Pseq([
							70,700,
						],inf) + Pwhite(-1.0,20),
						\octave, 8,
						\adsr, Pseq([
							[ Env.adsr(0.1,0.1,0.8,3.1) ],
						],inf),
						\rq, 0.1,
						\lpfr, ~pmodenv.(Prand([1/2,2,1,4],inf), 8),
						\lpfr, 4,
						\dur, Pseq([
							1,0.1,1,0.3,
							1,0.2, 1,0.4,
						].clump( 2 ).collect(_.normalizeSum).flat * 2,inf),
						\amp, 0.1,
						\lag, 0.08,
					),
					Pbind(
						\instrument, \korade,
						\freq, Pseq([
							80,1750,
						],inf) + Pwhite(-1.0,10),
						\octave, 8,
						\adsr, Pseq([
							[ Env.adsr(0.1,0.1,0.8,3.1) ],
						],inf),
						\rq, 0.1,
						\lpfr, ~pmodenv.(Prand([1/2,2,1,4],inf), 8),
						\dur, Pseq([
							1,0.2, 1,0.4,
							1,0.1,1,0.3,
						].clump( 2 ).collect(_.normalizeSum*4).flat,inf),
						\amp, 0.1,
						\lag, 0.08,
					),
				]),
			),
			Pfindur(8,
				Ppar([
					Pbind(
						\instrument, \korade,
						\freq, Pseq([
							5000,1500,
							7000,1500,
						],inf) + Pwhite(-1000.0,1000),
						\octave, 8,
						\adsr, Pseq([
							[ Env.adsr(0.1,0.1,0.8,3.1) ],
						],inf),
						\rq, 0.1,
						\lpfr, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
						\dur, Pseq([
							1,0.1,1,0.3,
							1,0.2, 1,0.4,
						].clump( 2 ).collect(_.normalizeSum).flat * 4,inf),
						\amp, 0.1,
						\lag, 0.08,
					),
					Pbind(
						\instrument, \korade,
						\freq, Pseq([
							1000,1500,
							7000,1500,
							10000,1500,
							7000,1500,
						],inf) + Pwhite(-1000.0,1000),
						\octave, 8,
						\adsr, Pseq([
							[ Env.adsr(0.1,0.1,0.8,3.1) ],
						],inf),
						\rq, 0.1,
						\lpfr, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
						\dur, Pseq([
							1,0.2, 1,0.4,
							1,0.1,1,0.3,
						].clump( 2 ).collect(_.normalizeSum).flat,inf),
						\amp, 0.1,
						\lag, 0.08,
					),
				]),
			),
			Pfindur(8,
				Ppar([
					Pbind(
						\instrument, \korade,
						\freq, Pseq([
							5000,1500,
							7000,1500,
						],inf) + Pwhite(-1000.0,1000),
						\octave, 8,
						\adsr, Pseq([
							[ Env.adsr(0.1,0.1,0.8,3.1) ],
						],inf),
						\rq, 0.1,
						\lpfr, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
						\dur, Pseq([
							1,0.1,1,0.3,
							1,0.2, 1,0.4,
						].clump( 2 ).collect(_.normalizeSum).flat,inf),
						\amp, 0.1,
						\lag, 0.08,
					),
					Pbind(
						\instrument, \korade,
						\freq, Pseq([
							1000,1500,
							7000,1500,
							10000,1500,
							7000,1500,
						],inf) + Pwhite(-1000.0,1000),
						\octave, 8,
						\adsr, Pseq([
							[ Env.adsr(0.1,0.1,0.8,3.1) ],
						],inf),
						\rq, 0.1,
						\lpfr, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
						\dur, Pseq([
							1,0.2, 1,0.4,
							1,0.1,1,0.3,
						].clump( 2 ).collect(_.normalizeSum).flat,inf),
						\amp, 0.1,
						\lag, 0.08,
					),
				]),
			),
		],inf),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\bsendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0102099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
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
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\bsendbus2, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.01,
			'gain', 2,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.2000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),

		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,0,
				0,0,0,0, 0,0,1,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/9,
			\out, BusDef(\bsendbus1, \audio),
		)),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0102099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
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
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.01,
			'gain', 2,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.2000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		
	])
)).play;
)

(
Pdef(\part2, Pdef(\zed2, 
	Ppar([
		
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,0,
				0,0,0,1, 0,0,0,0,0,
				0,0,0,0, 0,0,0,0,0,
				0,0,0,1, 0,0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\speed, Pseq([
				Pseq([
					1,1,1,1,
				],3),
				Pseq([
					1,1,1,1,
				],1)/2,
			],inf),
			\dur, 1/9/2,
			\out, BusDef(\csendbus1, \audio),
		)),
		Pmono(\rdnroom,
			\inbus, BusDef(\csendbus2, \audio, 2),
			\dur, 1/2,
			'wet10', 1.0,
			'mix', 0.71,
			'gain', 1/4,
			'fb', 0.0000100031,
			'delay', 0.00100001 * Pseq([
				1,1/10,2,
			],inf),
			'delay2', 0.00011001,
			'delay3', 0.000080,
			'distamp', 0.604,
			'distamp2', 4.23,
			'distamp3', 1.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\csendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.5714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0001099467303085,
			'delay', 0.000600001231 * Pseq([
				1,2,4,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 7.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 1700,
			'fbdistamp', 44.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 170,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\csendbus1, \audio, 2),
			\out, BusDef(\csendbus2, \audio),
			\mix, 0.5,
			\room, 1/2,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part2, Pdef(\zed2, 
	Ppar([
		
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				1,0,1,0, 0,1,1,1,1,

			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\speed, 1/2 * Pseg(Pseq([1,4],inf),2),
			\dur, 1/9/2,
			\out, BusDef(\csendbus1, \audio),
		)),
		Pmono(\rdnroom,
			\inbus, BusDef(\csendbus2, \audio, 2),
			\dur, 1/2,
			'wet10', 1.0,
			'mix', 0.71,
			'gain', 1/4,
			'fb', 0.0000100031,
			'delay', 0.00100001 * Pseq([
				1,1/10,2,
			],inf),
			'delay2', 0.00011001,
			'delay3', 0.000080,
			'distamp', 0.604,
			'distamp2', 4.23,
			'distamp3', 1.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\csendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.5714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0001099467303085,
			'delay', 0.000600001231 * Pseq([
				1,2,4,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 7.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 1700,
			'fbdistamp', 44.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 170,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\csendbus1, \audio, 2),
			\out, BusDef(\csendbus2, \audio),
			\mix, 0.5,
			\room, 1/2,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)


///////////////////////////////////:::


