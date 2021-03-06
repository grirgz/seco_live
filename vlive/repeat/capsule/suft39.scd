~t = 135/4/60; TempoClock.default.tempo = ~t;
(
SynthDef(\fmbellzed, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1,1.1],[0.1,0.18,0.8]), 1);
	env2 = EnvGen.kr(Env([1,2,1]/1.2,[0.1,0.8]), 1);
	env2 = SinOsc.kr(\env2lfofreq.kr(2/~t) * env2).range(2,1);
	freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * 2.6706 + 0.13) * \fmamp.kr(2)* env1 + 1; 
	sig2 = SinOsc.ar(freq * 0.9998 * sig1 );
	sig3 = LFSaw.ar(freq * 2.6629 * (sig2 * env2 + 1) + 2.04);
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.8) * env2 * freq, \rq.kr(0.1));
	sig4 = LFCub.ar(freq * 1 * 0.9991 * sig1 + 2.14);
	sig5 = SinOsc.ar(freq * 2.6656 * sig1 - 2);
	sig6 = SinOsc.ar(freq * 1 * sig1 + 1.84);
	sig7 = LFPulse.ar(freq * 6/4 * sig1 + 0);
	sig7 = RLPF.ar(sig7, \lpfr.kr(1.8) * env2 * freq, \rq.kr(0.1));
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6, sig7] * DC.ar([0,0.5,0.5, 0.5,0.5,0.5,0.3]);
	//sig.debug("sig");
	//sig = sig /34;
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0,1,2.1,1,-1) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan + [ 0, -0.5, -0.5, 0.5, 0.5, 0, 0], amp).sum;
	Out.ar(out, sig);
}).add;
)
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \fmbellzed,
			\note, Pseq([
				0,7,-4,
			],inf)-7,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\drumbus, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,1,1,0, 0,0,0,0,

					1,0,0,0, 0,1,0,1,
					0,1,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,1,0,0,

				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,1, 1,0,1,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drumbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.55714285714286,
			'gain', 0.7344889782792/2,
			'fb', 0.0002099467303085,
			'delay', 0.100600001231 * Pseq([
				1,
			],inf).stutter(1),
			\delay, ~pmodenv.(Pseq([0.1,0.00002],inf), 8),
			'delay2', 0.000000543560101,
			'distamp', 3.361836201538,
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
		Pmono(\rdnshot,
			\inbus, BusDef(\drumbus),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 0.5,
			'gain', 1/4/2,
			'fb', 0.00109281392423591,
			'delay', 0.100006,
			'delay2', 0.0000008,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 112.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 20.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),
		Pmono(\rdnshot,
			\inbus, BusDef(\drumbus),
			\dur, 1/8,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 0.5,
			'gain', 1/6/2,
			'fb', 0.00009281392423591,
			'delay', 0.001006,
			'delay2', 0.0000008,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 412.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17 * Pseq([
				1,4,
				1,1,10,
				1,1,100,
			],inf),
			'fbdistamp', 4.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 20.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),
		Pmono(\chorusdistlim,
			\inbus, BusDef(\drumbus, \audio, 2),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00011,
			\modfreq, 4*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.2,
			\dur, 1,
			\amp, 0.1,
		),

		/////// hat

		Pbind(\out, BusDef(\hatbus, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1, 1,1,
					1,1, 1,0,
					1,0, 0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0,
					0,1,0,0,
					0,0,0,1,
					1,1,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\lag, 1/16/~t,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono(\rdnshot,
			\inbus, BusDef(\hatbus),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 0.5,
			'gain', 1/6/2,
			'fb', 0.00009281392423591,
			'delay', 0.000006,
			'delay2', 0.0000008,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 20.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),

		// hi
			Pbind(\out, BusDef(\fx1, \audio))<>Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snapclap,
					\sustain ,0.051,
					\isRest, Pseq([
						1,0,0,1, 1,0,0,1,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
			]),
		Pbind( // violin
					\out, BusDef(\fx1, \audio),
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/1 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),
		
			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			//\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			//\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			//\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, Pseq([
				4,4,4,1
			],inf).stutter(16*1),
		
			\pos, Pseq([
				~pmodsynth.({ SinOsc.kr(1/21*~t).range(0.2,1.2)+0.2 },2),
			],inf),
		
			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\legato, Pseq([
				1,0,1,0, 4,0,0,0,
				1,0,0,1, 0,0,1,0,
				4,0,0,0, 0,0,2,0,
				0,0,2,0, 1,1,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		),
			Pmono(\rdnroomff,
				\freq, 200,
				\dur, 1/4,
				\amp, 0.1,
				\inbus, BusDef(\fx1),
				'wet10', 1.0,
				'mix', 1,
				'gain', 0.7/3,
				\fb, ~pmodenv.(Pseq([0.0001,0.0002,0.001,0.004],inf), 8),
				\fb, 0.00001,
				'delay3', Pseq([
					0.00001,0.700041,0.000001,0.00001,
				],inf),
				\delay3, 0.040009,
				'delay2', 0.04000072394574653723 * Pseq([1,2,4,1/2,1/100],inf),
				\distamp, 0.771,
				\distamp3, 0.77,
				'shift', -00.1,
				'shiftmix', 0.4,
				'stereo', 00.0,
				//'ehpf', ~pmodenv.(Pseq([10000,2000,40,40],inf), 8),
				//'elpf', ~pmodenv.(Pseq([7000,10000,12040,17040],inf), 8),
				\ehpf, 4000 * Pseq([
					1,1,1/2,
				],inf),
				\elpf, 20000,
				\ffmix, 1,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\out, BusDef(\stutbus, \audio),
			),
			Pmono(\fx_stutter,
				\inbus, BusDef(\stutbus),
				\time, 1/Pseq([
					16,32,20,5,
				],inf)/~t,
				\mix, Pseq([
					0,0,1,1,
					0,1,0,1,
					1,1,0,1,
				],inf),
				\dur, 1/8,
			),
		
	])
)).play;
)

(
	// big bell
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\drumbus, \audio)) <>
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
					0,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drumbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.55714285714286,
			'gain', 0.7344889782792/2.73,
			'fb', 0.0002099467303085,
			'delay', 0.100600001231 * Pseq([
				1,
			],inf).stutter(1),
			\delay, ~pmodenv.(Pseq([0.1,0.00002],inf), 8),
			'delay2', 0.000000543560101,
			'distamp', 3.361836201538,
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
		Pmono(\rdnshot,
			\inbus, BusDef(\drumbus),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 0.5,
			'gain', 1/4/2.73,
			'fb', 0.00109281392423591,
			'delay', 0.100006,
			'delay2', 0.0000008,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 112.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 20.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),
		Pmono(\rdnshot,
			\inbus, BusDef(\drumbus),
			\dur, 1/8,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 0.5,
			'gain', 1/6/2.73,
			'fb', 0.00009281392423591,
			'delay', 0.001006,
			'delay2', 0.0000008,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 412.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17 * Pseq([
				1,4,
				1,1,10,
				1,1,100,
			],inf),
			'fbdistamp', 4.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 20.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),
		Pmono(\chorusdistlim,
			\inbus, BusDef(\drumbus, \audio, 2),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00011,
			\modfreq, 4*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.172,
			\dur, 1,
			\amp, 0.1,
		),

		/////// hat

		Pbind(\out, BusDef(\hatbus, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0, 0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\lag, 1/16/~t,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono(\rdnshot,
			\inbus, BusDef(\hatbus),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 0.5,
			'gain', 1/6,
			'fb', 0.00009281392423591,
			'delay', 0.000006,
			'delay2', 0.0000008,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 20.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),

		// hi
		Pbind(
			\instrument, \fmbellzed,
			\env2lfofreq, Pseg(Pseq([0,0.1,0.2,8],inf),2),
			\freq, 200,
			\dur, 1,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
			\out, BusDef(\drumbus, \audio),
			\out, BusDef(\bellbus, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\bellbus),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\drumbus, \audio, 2),
			\send0, 1,
			\sendbus1, BusDef(\fx1, \audio, 2),
			\dur, 1,
		),
			Pbind(\out, BusDef(\fx1xx, \audio))<>Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snapclap,
					\sustain ,0.051,
					\isRest, Pseq([
						1,0,0,1, 1,0,0,1,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
			]),
		Pbind( // violin
					\out, BusDef(\fx1, \audio),
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/1 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),
		
			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			//\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			//\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			//\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, Pseq([
				4,4,4,1
			],inf).stutter(16*1),
		
			\pos, Pseq([
				~pmodsynth.({ SinOsc.kr(1/21*~t).range(0.2,1.2)+0.2 },2),
			],inf),
		
			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/18,
			\amp, 0.1,
		),
			Pmono(\rdnroomff,
				\freq, 200,
				\dur, 1/4,
				\amp, 0.1,
				\inbus, BusDef(\fx1),
				'wet10', 1.0,
				'mix', 1,
				'gain', 0.1,
				\fb, ~pmodenv.(Pseq([0.0001,0.0002,0.001,0.004],inf), 8),
				\fb, 0.00001,
				'delay3', Pseq([
					0.00001,
				],inf),
				\delay3, 0.040009,
				'delay2', 0.04000072394574653723 ,
				\distamp, 0.771,
				\distamp3, 0.77,
				'shift', -00.1,
				'shiftmix', 0.4,
				'stereo', 00.0,
				//'ehpf', ~pmodenv.(Pseq([10000,2000,40,40],inf), 8),
				//'elpf', ~pmodenv.(Pseq([7000,10000,12040,17040],inf), 8),
				\ehpf, 1400 * Pseq([
					1,1,1,
				],inf),
				\elpf, 20000,
				\ffmix, 1,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\out, BusDef(\stutbus, \audio),
			),
			Pmono(\fx_stutter,
				\inbus, BusDef(\stutbus),
				\time, 1/Pseq([
					16,32,20,5,
				],inf)/~t,
				\mix, Pseq([
					0,0,0,0,
					0,0,0,0,
					0,0,0,0,
				],inf),
				\dur, 1/8,
			),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\drumbus, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,

					1,0,0,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,1,

				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,1,1,
					1,0,0,1, 0,0,1,0, 0,1,0,1, 1,0,1,1,
					0,1,1,1, 0,0,0,0, 0,0,0,0, 1,0,1,1,
					1,0,0,1, 0,0,1,0, 0,1,0,1, 1,0,1,1,
					0,1,1,0, 1,0,0,0, 0,0,0,0, 0,0,1,1,
					1,0,0,1, 0,0,1,0, 0,1,0,1, 1,0,1,1,
					0,0,0,1, 1,0,1,1, 0,0,1,0, 1,0,1,1,
					1,0,0,1, 0,0,1,0, 0,1,0,1, 1,0,1,1,
				],inf).coin.not,
				\sustain, 0.1/2,
				\gain, 0.15,
				\dur, 1/16,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drumbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.55714285714286,
			'gain', 0.7344889782792/2,
			'fb', 0.0002099467303085,
			'delay', 0.100600001231 * Pseq([
				1,
			],inf).stutter(1),
			\delay, ~pmodenv.(Pseq([0.1,0.00002],inf), 8),
			'delay2', 0.000000543560101,
			'distamp', 3.361836201538,
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
		Pmono(\rdnshot,
			\inbus, BusDef(\drumbus),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 0.5,
			'gain', 1/4/2,
			'fb', 0.00109281392423591,
			'delay', 0.100006,
			'delay2', 0.0000008,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 112.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 20.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),
		Pmono(\rdnshot,
			\inbus, BusDef(\drumbus),
			\dur, 1/8,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 0.5,
			'gain', 1/6/2,
			'fb', 0.00009281392423591,
			'delay', 0.030006,
			'delay2', 0.2000008,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17 * Pseq([
				1,4,
				1,1,10,
				1,1,100,
			],inf),
			'fbdistamp', 4.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 20.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),
		Pmono(\chorusdistlim,
			\inbus, BusDef(\drumbus, \audio, 2),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00011,
			\modfreq, 4*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.2,
			\dur, 1,
			\amp, 0.1,
		),

		/////// hat

		Pbind(\out, BusDef(\hatbus, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1, 1,1,
					1,1, 1,0,
					1,0, 0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0,
					0,1,0,0,
					0,0,0,1,
					1,1,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\lag, 1/16/~t,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono(\rdnshot,
			\inbus, BusDef(\hatbus),
			\dur, 1,
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 0.5,
			'gain', 1/6/2,
			'fb', 0.00009281392423591,
			'delay', 0.000006,
			'delay2', 0.0000008,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.1683753109874,
			'pitchlag', 0.17526592085368,
			'pitchmix', 0.87394957983193,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.65607499380699,
			'fbdistmix', 0.96638655462185,
			'postlpf', 19402.265930714,
			'posthpf', 20.0,
			'wetamp', 1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'delay3', 0.0001,
		),

		// hi
		Pbind(
			\instrument, \fmbellzed,
			\env2lfofreq, Pseg(Pseq([0,0.1,0.2,8],inf),2),
			\freq, Pseq([
				1000,1234,432,543,
			],inf),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0,0,1,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			//\out, BusDef(\drumbus, \audio),
			//\out, BusDef(\bellbus, \audio),
			\out, BusDef(\fx1, \audio),
		),
			Pbind(\out, BusDef(\fx1, \audio))<>Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snapclap,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 0,1,1,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,1, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 1,0,1,1,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
			]),
			Pmono(\rdnroomff,
				\freq, 200,
				\dur, 1/4,
				\amp, 0.1,
				\inbus, BusDef(\fx1),
				'wet10', 1.0,
				'mix', 1,
				'gain', 0.7/3,
				\fb, ~pmodenv.(Pseq([0.0001,0.0002,0.001,0.004],inf), 8),
				\fb, 0.00001,
				'delay3', Pseq([
					0.00001,0.700041,0.000001,0.00001,
				],inf),
				\delay3, 0.040009,
				'delay2', 0.00000072394574653723 * Pseq([1,2,4,1/2,1/100],inf),
				\distamp, 0.771,
				\distamp3, 0.77,
				'shift', -00.1,
				'shiftmix', 0.4,
				'stereo', 00.0,
				//'ehpf', ~pmodenv.(Pseq([10000,2000,40,40],inf), 8),
				//'elpf', ~pmodenv.(Pseq([7000,10000,12040,17040],inf), 8),
				\ehpf, 4000 * Pseq([
					1,1,1,0.8,
				],inf),
				\elpf, 20000 * Pseq([
					1,1/2,
				],inf),
				\ffmix, 1,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\out, BusDef(\stutbus, \audio),
			),
			Pmono(\fx_stutter,
				\inbus, BusDef(\stutbus),
				\time, 1/Pseq([
					16,32,20,5,
				],inf)/~t,
				\mix, Pseq([
					0,0,1,1,
					0,1,0,1,
					1,1,0,1,
				],inf),
				\dur, 1/8,
			),
		
	])
)).play;
)

/////////////////



(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,1,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\mixer0, \audio),
			),
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
					0,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\mixer0, \audio),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\mixer1, \audio),
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
				\out, BusDef(\mixer2, \audio),
			),
			Pbind(
				\instrument, \iron,
				\freq, 2000,
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\mixer4, \audio),
			),
		
	])
)).play;
)

ProtoDef(\rdn).edit
ProtoDef(\rdn2).edit
ProtoDef(\simpleMixer).edit

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\mixer0, \audio),
			),
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\mixer0, \audio),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\mixer1, \audio),
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
				\out, BusDef(\mixer2, \audio),
			),
			Pbind(
				\instrument, \iron,
				\freq, 2000,
				\isRest, Pseq([
					1,0,0,
					1,0,0,
					1,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\mixer4, \audio),
			),
		
	])
)).play;
)
