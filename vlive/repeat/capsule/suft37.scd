
(
SynthDef(\hinoise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq * Duty.kr(
		Dseq([
			Dwhite(0.01,3,1), Dwhite(0.1,0.01,1),
			Dwhite(0.01,2,1), Dwhite(0.1,0.01,1),
			Dwhite(0.01,0.2,1), Dwhite(0.1,0.01,1),
			Dwhite(0.01,0.2,1), Dwhite(0.1,0.01,1),
		],inf)/~t, 0, 
		Dseq([
		1,Dwhite(1/2,1/8,1),
	],inf));
	sig = LFSaw.ar(freq * (1..8)/2 * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 )) + PinkNoise.ar;
	sig = SinOsc.ar(freq * ( sig * 1 + 1 )) ;
	sig = HPF.ar(sig, freq * \hpfr.kr(1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\lownoise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFNoise1.ar(freq) + PinkNoise.ar;
	sig = LPF.ar(sig, freq * \lpfr.kr(1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\sisin, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.01;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,1.2,1,1],[0.7,0.1,0.1,0.8]), 1);
	sig = SinOsc.ar(freq * [ [1,2,1/2] ] * env1 * ((0..7)/7 - 0.5 * fspread + 1)).flop * [\octlow.kr(0),\octmid.kr(1),\octhi.kr(0)];
	sig = sig.mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(2,
			Pmono( \lownoise,
				\freq, 400,
				\lpfr, 1/2,
				\legato, 1,
				\dur, 1,
				\amp, 0.1,
			),
		),
		Pfindur(16, Pdef(\nant_part1)),
		Pfindur(16+8, Pdef(\nant_part2)),
		Pfindur(16, Pdef(\nant_part3)),
		Pfindur(2,
			Pmono( \lownoise,
				\freq, 400,
				\lpfr, 1/2,
				\legato, 1,
				\dur, 1,
				\amp, 0.1,
			),
		),
		Pfindur(16, Pdef(\nant_part1sec2)),
	],inf)
)).play;
)

(
Pdef(\part, Pdef(\nant_part1, 
	Ppar([
		Pmono( \lownoise,
			\freq, 400,
			\lpfr, ~pmodenv.(Pseq([1/2,1/2,2,4,1/2],inf), Pseq([8,4,3.5,0.05,1])),
			\legato, 1,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sisin,
			\octhi, ~pmodenv.(Pseq([1,2,1,4]/4,inf), 8),
			\octlow, ~pmodenv.(Pseq([1,2,1,4]/4,inf), 3),
			\octmid, ~pmodenv.(Pseq([1,2,1,4]/4,inf), 5),
			\freq, 800,
			\dur, 2,
			\sustain, 1/2,
			\amp, 0.1,
			\out, BusDef(\sinbus, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sinbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 1,
			'gain', 0.1344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.701600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
			'delay2', ~pmodenv.(Pseq([0.1,0.82,0.00001],inf), 8),
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
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\sinbus),
			\room, 2,
			\mix, 1,
			\damp, 2,
			\gain, 1/2,
			\dur, 1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\nant_part2, 
	Ppar([
		Pmono( \lownoise,
			\freq, 400,
			\lpfr, 1/2,
			\legato, 1,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sisin,
			\octhi, ~pmodenv.(Pseq([1,2,1,4]/4,inf), 8),
			\octlow, ~pmodenv.(Pseq([1,2,1,4]/4,inf), 3),
			\octmid, ~pmodenv.(Pseq([1,2,1,4]/4,inf), 5),
			\freq, 800,
			\dur, 2,
			\sustain, 1/2,
			\amp, 0.1,
			\out, BusDef(\sinbus, \audio),
		),
		Pbind(
			\instrument, \sisin,
			\freq, Pseq([500],inf),
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 0.4 * Pseg(Pseq([4,1/4],inf),16),
			\amp, 0.1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sinbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 1,
			'gain', 0.1344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.701600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
			'delay2', ~pmodenv.(Pseq([0.1,0.82,0.00001],inf), 8),
			'distamp', 7.361836201538,
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
			\out, BusDef(\stutbus, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sinbus, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1,
			'gain', 1/22,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			 \delay3, ~pmodenv.(Pseq([0.00001,0.2,1],inf), 8),
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 1.89,
			'shift', -0.01,
			'shiftmix', 1.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\stutbus, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\sinbus),
			\room, 2,
			\mix, 1,
			\damp, 2,
			\gain, 1/2,
			\dur, 1,
			\out, BusDef(\stutbus, \audio),
		),

		/////

		Pmono(\perceuse,
			\freq, 870,
			\dur, 2/3,
			\octlow, 1,
			\octhi, 1,
			\amp, ~pmodenv.(Pseq([0.001,0.2],inf), 16),
			\out, BusDef(\perceusebus, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\perceusebus),
			\lpf, ~pmodenv.(Pseq([100,2000,17000],inf), 8),
			\dur, 1,
			\out, BusDef(\stutbus, \audio),
		),
		Pbind(
			\instrument, \envgrain,
			\mbufnum, BufDef.mono('voices/nanterre.flac'),
				\pos, Pseq([
					Ptime(),
				],inf),
				\posenv, Pseq([
					[ Env([0,4.27,0],[8.02,0.8]) ],
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([2,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 42,
				\gfreq, Pkey(\freq),
				\gdur, 0.09,
				\posrandamp, 0.005,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.1) ],
				],inf),
				\legato, Pseq([
					8,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/8,
				\gain, 1/8,
				\amp, 0.1,
				\out, BusDef(\smpbus, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\smpbus, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1/2,
			'gain', ~pmodenv.(Pseq([0.000001,0.08],inf), 16),
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.2000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3',  ~pmodenv.(Pseq(0.89 *[1/2,1,2],inf), 8),
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\stutbus, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\smpbus, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1/2,
			'gain', ~pmodenv.(Pseq([0.000001,0.08],inf), 16),
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3',  ~pmodenv.(Pseq(0.89 *[1/2,1,2],inf), 8),
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\stutbus, \audio),
		),

		////

		Pmono(\fx_stutter,
			\inbus, BusDef(\stutbus),
			\mix, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				1,1,1,1,
				1,1,1,1,
			],inf),
			\time, 0.1,
			\rate, ~pmodenv.(Pseq([1,1,8],inf), Pseq([4*4+4,4],inf)),
			\dur, 1,
		),
	])
)).play;
)

(
SynthDef(\perceuse, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(\freqenv.kr(Env.asr(0.4,1,1.3)), gate);
	freq = freq * [1,2,4,8] * LFNoise1.ar(1/3!4, mul:0.2, add:1 );
	freq = freq * ( env1+1);
	sig1 = Formant.ar(freq) * ( 1/[1,2,4,8] );
	sig2 = BPF.ar(WhiteNoise.ar, freq, 0.2)*10;
	sig = sig1 + sig2;
	sig = sig / 3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}, metadata:(specs:(
	freqenv: XEnvSpec.asr
))).add;
);


(
	Pdef(\part, Pdef(\nant_part3, 
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/nanterre.flac'),
				\pos, 12,
				\sustain, 0.1,
				\dur, 1,
				\gain, 1/3,
			),
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('voices/nanterre.flac'),
				\pos, Pseq([
					10,
					7,
				],inf).stutter(8),
				\posenv, Pseq([
					[ Env([0,0.27,0],[8.02,0.8]) ],
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([2,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 42,
				\gfreq, Pkey(\freq),
				\gdur, 0.09,
				\posrandamp, 0.005,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.1) ],
				],inf),
				\legato, Pseq([
					8,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/8,
				\gain, 1/8,
				\amp, 0.1,
			),
			Ptpar([
				4, Pbind(
					\instrument, \envgrain,
					\mbufnum, BufDef.mono('voices/nanterre.flac'),
					\pos, Pseq([
						7
					],inf),
					\posenv, Pseq([
						[ Env([0,1.27,0],[8.02,0.8]) ],
					],inf),
					\pitchenv, Pseq([
						[ Env([1,1,1],[0.1,2.8]) ]
					],inf),
					\gfreqenv, Pseq([
						[ Env([1,1,1],[0.1,2.8]) ]
					],inf),
					\gdurenv, Pseq([
						[ Env([2,1,1],[0.1,2.8]) ]
					],inf),
					\freq, 42,
					\gfreq, Pkey(\freq),
					\gdur, 0.09,
					\posrandamp, 0.005,
					\posrandfreq, 20,
					\adsr, Pseq([
						[ Env.adsr(0.71,0.1,0.8,1.1) ],
					],inf),
					\legato, Pseq([
						0,0,0,0, 3,0,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\pitch_stretch, 1,
					\dur, 1/8,
					\gain, 1/8,
					\amp, 0.1,
					\out, BusDef(\massbus, \audio),
				),
				8, Pbind(
					\instrument, \envgrain,
					\mbufnum, BufDef.mono('voices/nanterre.flac'),
					\pos, Pseq([
						4
					],inf),
					\posenv, Pseq([
						[ Env([0,1.27,0],[8.02,0.8]) ],
					],inf),
					\pitchenv, Pseq([
						[ Env(1/[2,3,1],[0.1,2.8]) ]
					],inf),
					\gfreqenv, Pseq([
						[ Env([1,4,1],[0.1,2.8]) ]
					],inf),
					\gdurenv, Pseq([
						[ Env([2,1,1],[0.1,2.8]) ]
					],inf),
					\freq, 442,
					\gfreq, Pkey(\freq),
					\gdur, 0.09,
					\posrandamp, 0.005,
					\posrandfreq, 20,
					\adsr, Pseq([
						[ Env.adsr(0.71,0.1,0.8,1.1) ],
					],inf),
					\legato, Pseq([
						0,0,0,0, 3,0,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\pitch_stretch, 1,
					\dur, 1/8,
					\gain, 1/8,
					\amp, 0.1,
					\out, BusDef(\massbus, \audio),
				),
			]),
			Pmono(\fx_freeverb2,
				\inbus, BusDef(\massbus),
				\dur, 1,
				\out, BusDef(\massbus2, \audio),
			),
			Pmono(\rdnroom,
				\inbus, BusDef(\massbus2, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 1,
				'gain', 1/22,
				'fb', 0.000000031,
				'delay', 0.00001001,
				'delay2', 0.00001001,
				'delay3', 0.0000080,
				'distamp', 10.604,
				'distamp2', 0.23,
				'distamp3', 32.89,
				'shift', -5.0,
				'shiftmix', 0.1,
				'stereo', 1.0,
				'indelay', 0.04,
			),
			Pmono(\rdnroom,
				\inbus, BusDef(\massbus2, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 1,
				'gain', 1/22,
				'fb', 0.000000031,
				'delay', 0.00001001,
				'delay2', 0.01001001,
				'delay3', 0.0100080,
				'distamp', 10.604,
				'distamp2', 0.23,
				'distamp3', 32.89,
				'shift', -5.0,
				'shiftmix', 0.1,
				'stereo', 1.0,
				'indelay', 0.04,
			),

		])
	)).play;
)



(
Pdef(\part, Pdef(\nant_part1sec2, 
	Ppar([
		Pmono( \lownoise,
			\freq, 400,
			\lpfr, ~pmodenv.(Pseq([1/2,1/2,2,4,1/2],inf), Pseq([8,4,3.5,0.05,1])),
			\legato, 1,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono( \hinoise,
			\freq, 12400,
			\fmr, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\lhfr, 1,
			\legato, 1,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sisin,
			\octhi, ~pmodenv.(Pseq([1,2,1,4]/4,inf), 8),
			\octlow, ~pmodenv.(Pseq([1,2,1,4]/4,inf), 3),
			\octmid, ~pmodenv.(Pseq([1,2,1,4]/4,inf), 5),
			\freq, 800,
			\dur, 2,
			\sustain, 1/2,
			\amp, 0.1,
			\out, BusDef(\sinbus, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sinbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 1,
			'gain', 0.1344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.701600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
			'delay2', ~pmodenv.(Pseq([0.1,0.82,0.00001],inf), 8),
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
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\sinbus),
			\room, 2,
			\mix, 1,
			\damp, 2,
			\gain, 1/2,
			\dur, 1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pmono( \hinoise,
			\freq, Pseq([
				Pwhite(100.0,12000)
			],inf),
			\fmr, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\lhfr, 1,
			\legato, 1,
			\dur, Pwhite(1.0,8),
			\amp, 0.1,
		),
	])
)).play;
)
