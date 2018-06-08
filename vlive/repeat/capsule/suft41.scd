~t = 135/4/60; TempoClock.default.tempo = ~t;


(
SynthDef(\planos, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\snapbow, {
	var snd, freq;
	freq = \freq.kr(440, 0.3);
	snd = CombC.ar(LeakDC.ar({ PinkNoise.ar }.dup(2)), freq.reciprocal, freq.reciprocal, 5);
	snd = LeakDC.ar(snd);
	snd = RLPF.ar(snd, Duty.kr(1/4/~t, 0, Dseq([
		1000,100,
	],inf)), 0.3);
	snd = snd * Env.perc(4, 1, 1, 4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), Balance2.ar(snd[0], snd[1], \pan.kr(0), \amp.kr(0.1)));
}).add;
)
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapbow,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

(
SynthDef(\combkick, { arg out=0, pan=0, amp=0.1, gate=1;
	var sig, freq;
	var env;
	env = EnvGen.kr(\lpenv.kr(Env([1400,400,70.1,10],[0.001,0.008,1])), gate);
	freq = \freq.kr(440, 0.3);
	sig = CombC.ar(LeakDC.ar({ Hasher.ar(SinOsc.ar(freq)) }!2), 1/freq, 1/freq, \decay.kr(0.05));
	sig = LeakDC.ar(sig);
	sig = RLPF.ar(sig, env, \rq.kr(0.3)) * \gain.kr(1) * 0.5;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpenv: XEnvSpec(\freq!4)
))).add;
)

(
SynthDef(\snappad, {
	var snd, freq;
	freq = \freq.kr(440);
	// Four pulse waves (two one octave down) with randomly modulated pitches and pulse widths
	snd = Pulse.ar(
		freq * ({ LFNoise2.kr(3).range(-0.05, 0.05).midiratio }.dup(4)) * [1, 1/2, 1/2, 1],
		{ LFNoise2.kr(3).range(0.3, 0.7) }.dup(4)
	);
	// Spread across stereo field
	snd = Splay.ar(snd);
	// Sharp hi cut made by cascading three lowpass filters
	3.do { snd = LPF.ar(snd, \ffreq.kr(1500)); };
	snd = snd * Env.asr(\at.kr(3), \sustainlevel.kr(1), \rel.kr(3), -4).ar(Done.freeSelf, \gate.kr(1));
	Out.ar(\out.kr(0), Balance2.ar(snd[0], snd[1], \pan.kr(0), \amp.kr(0.1)));
}).add;
)

(
SynthDef(\snapsigh, {
	var snd, freq;
	freq = \freq.kr(440, 0.3) * LFNoise2.kr(6).range(-0.1, 0.1).midiratio;
	snd = Pulse.ar(freq, LFNoise2.kr(6).range(0.3, 0.7));
	snd = RLPF.ar(snd, LFNoise2.kr(3).exprange(500, 1000), 0.2);
	snd = LPF.ar(snd, \lpf.kr(1000));
	snd = snd * Env.asr(0.1, 1, 3).ar(Done.freeSelf, \gate.kr(1));
	Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
}).add;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapsigh,
			\note, Pseq([
				[0,7,9],
				[-2,3,9-12],
			],inf),
			\octave, 7,
			\lpf, 500,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		// drums1
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			//Pdef(\combkick,
				//Pbind(
					//\instrument, \combkick,
				//),
			//) <>
			Pbind(
				\instrument, \combkick,
				\freq, 13200,
				\env, [ Env([1400,1400,50.1,10],[0.001,0.08,1]) ],
				//\freq, ~pmodenv.(Pseq([100,2000,10000],inf), 8),
				\sustain, 0.1/2,
				\isRest, Pseq([
					1,1,1,0, 0,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
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
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
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
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.0000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 10.361836201538,
			'prelpf', 19900,
			'prehpf', 100,
			'lpf', 19900,
			'hpf', 1700,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 170,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		// drums 2
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pdef(\combkick,
				Pbind(
					\instrument, \combkick,
				),
			) <>
			Pbind(
				\instrument, \combkick,
				\freq, 320 * Pseq([1,1.3,2],inf),
				\freq, Pwhite(10,17000.0),
				\env, [ Env([9400,9400,70.1,180],[0.01,0.008,1]) ],
				//\freq, ~pmodenv.(Pseq([100,2000,10000],inf), 8),
				\sustain, 0.1,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,0,1, 1,0,1,0,
					1,0,1,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.4,
				\dur, 1/16,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.200600001231 * Pseq([
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
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.0000600001231 * Pseq([
				1,2,10,
			],inf).stutter(1),
			'delay2', 0.000010543560101,
			'distamp', 10.361836201538,
			'prelpf', 19900,
			'prehpf', 100,
			'lpf', 19900,
			'hpf', 1700,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 170,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1/4,
		),

		// pad
			Pbind(
				\instrument, \snappad,
				\note, Pseq([
					0,10,
				],inf),
				\dur, 1,
				\amp, 0.1/2,
				\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \snappad,
				\note, Pseq([
					0,1,2,4,
				],inf),
				\octave, 7,
				\dur, 1,
				\amp, 0.1/2,
				\out, BusDef(\sendbus3, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,10,100,
				],inf).stutter(4),
				'delay2', 0.000000543560101,
				'distamp', 9.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 470,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1,
			),
			Pmono(\chorusdist,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\distamp, 20,
				\distpostamp, 1/1,
				\fb, 0.904,
				\distmix, 1,
				\delay, 0.00111,
				\modfreq, 4*~t * Pseq([1,2,10],inf),
				\modamp, 0.7001,
				\hpf, 500,
				\gain, 0.4,
				\dur, 1,
				\amp, 0.1,
			),
			Pmono(\fx_freqshift,
				\inbus, BusDef(\sendbus3),
				\shift, 1400,
				\mix, 1,
				\dur, 1,
			),

			// bass

			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,1,
				],inf),
				\legato, Pseq([
					//4,0,0,0, 1,0,1,1,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\dur, 1/2,
				\amp, 0.1,
				\out, BusDef(\sendbus4, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus4, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 101.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 170,
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

WindowDef(\PdefEditor).front(Pdef(\combkick))


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		// drums1
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			//Pdef(\combkick,
				//Pbind(
					//\instrument, \combkick,
				//),
			//) <>
			Pbind(
				\instrument, \combkick,
				\freq, 13200,
				\env, [ Env([1400,1400,50.1,10],[0.001,0.08,1]) ],
				//\freq, ~pmodenv.(Pseq([100,2000,10000],inf), 8),
				\sustain, 0.1/2,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,1, 0,0,0,0, 1,1,0,1, 
					1,1,0,1, 0,1,0,1, 0,0,0,0, 1,1,0,1, 
				],inf).coin.not,
				\dur, 1/16 * (1 + (0.06 * Pseq([1,-1],inf))),
				\amp, 0.07,
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
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
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
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.0000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 10.361836201538,
			'prelpf', 19900,
			'prehpf', 100,
			'lpf', 19900,
			'hpf', 1700,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 170,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		// drums 2
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pdef(\combkick,
				Pbind(
					\instrument, \combkick,
				),
			) <>
			Pbind(
				\instrument, \combkick,
				\freq, 320 * Pseq([1,1.3,2],inf),
				\freq, Pwhite(10,17000.0),
				\env, [ Env([9400,9400,70.1,180],[0.01,0.008,1]) ],
				//\freq, ~pmodenv.(Pseq([100,2000,10000],inf), 8),
				\sustain, 0.1,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,0,1, 1,0,1,0,
					1,0,1,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.4,
				\dur, 1/16,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.200600001231 * Pseq([
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
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.0000600001231 * Pseq([
				1,2,10,
			],inf).stutter(1),
			'delay2', 0.000010543560101,
			'distamp', 10.361836201538,
			'prelpf', 19900,
			'prehpf', 100,
			'lpf', 19900,
			'hpf', 1700,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 170,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1/4,
		),

		// pad
			Pbind(
				\instrument, \snappad,
				\note, Pseq([
					0,10,
				],inf),
				\dur, 1,
				\amp, 0.1/2,
				\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \snappad,
				\note, Pseq([
					0,1,2,4,
				],inf),
				\octave, 7,
				\dur, 1,
				\amp, 0.1/2,
				\out, BusDef(\sendbus3, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,10,100,
				],inf).stutter(4),
				'delay2', 0.000000543560101,
				'distamp', 9.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 470,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1,
			),
			Pmono(\chorusdist,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\distamp, 20,
				\distpostamp, 1/1,
				\fb, 0.904,
				\distmix, 1,
				\delay, 0.00111,
				\modfreq, 4*~t * Pseq([1,2,10],inf),
				\modamp, 0.7001,
				\hpf, 500,
				\gain, 0.4,
				\dur, 1,
				\amp, 0.1,
			),
			Pmono(\fx_freqshift,
				\inbus, BusDef(\sendbus3),
				\shift, 1400,
				\mix, 1,
				\dur, 1,
			),

			// bass

			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,1,
				],inf),
				\legato, Pseq([
					//4,0,0,0, 1,0,1,1,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\dur, 1/2,
				\amp, 0.1,
				\out, BusDef(\sendbus4, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus4, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 101.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 170,
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
		// drums1
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			//Pdef(\combkick,
				//Pbind(
					//\instrument, \combkick,
				//),
			//) <>
			Pbind(
				\instrument, \combkick,
				\freq, 13200,
				\env, [ Env([1400,1400,50.1,10],[0.001,0.08,1]) ],
				//\freq, ~pmodenv.(Pseq([100,2000,10000],inf), 8),
				\sustain, 0.1/2,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,1, 0,0,0,0, 1,1,0,1, 
					1,1,0,1, 0,1,0,1, 0,0,0,0, 1,1,0,1, 
				],inf).coin.not,
				\dur, 1/16 * (1 + (0.06 * Pseq([1,-1],inf))),
				\amp, 0.1,
				\isRest, true,
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
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
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
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.0000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 10.361836201538,
			'prelpf', 19900,
			'prehpf', 100,
			'lpf', 19900,
			'hpf', 1700,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 170,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		// drums 2
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pdef(\combkick,
				Pbind(
					\instrument, \combkick,
				),
			) <>
			Pbind(
				\instrument, \combkick,
				\freq, 320 * Pseq([1,1.3,2],inf),
				\freq, Pwhite(10,17000.0),
				\env, [ Env([9400,9400,70.1,180],[0.01,0.008,1]) ],
				//\freq, ~pmodenv.(Pseq([100,2000,10000],inf), 8),
				\sustain, 0.1,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					1,1,0,1, 0,0,1,1,
					1,0,1,0, 0,0,1,1,
					1,1,1,0, 0,1,1,0,
				],inf).coin.not,
				\sustain, 0.1/2,
				\gain, 0.12,
				\dur, 1/16,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0,1, 1,0,1,0,
					1,0,0,0, 1,0,1,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.4,
				\dur, 1/16,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.200600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.700000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 170,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.7000600001231 * Pseq([
				1/1010,
				1,
			],inf).stutter(4),
			'delay2', 0.000010543560101,
			'distamp', 10.361836201538,
			'prelpf', 19900,
			'prehpf', 100,
			'lpf', 19900,
			'hpf', 1700,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 170,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1/4,
		),

		// pad
			Pbind(
				\instrument, \snappad,
				\note, Pseq([
					0,10,
				],inf),
				\legato, 0.1,
				\rel, 0.1,
				\dur, 1,
				\amp, 0.1/2,
				\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \snappad,
				\note, Pseq([
					0,1,0,1,
				],inf),
				\rel, 0.1,
				\octave, 7,
				\legato, 0.1,
				\dur, 1,
				\amp, 0.1/2,
				\out, BusDef(\sendbus3, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(4),
				'delay2', 0.000000543560101,
				'distamp', 9.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 470,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1,
			),
			Pmono(\chorusdistlim,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\distamp, 20,
				\distpostamp, 1/1,
				\fb, 0.904,
				\distmix, 1,
				\delay, 0.00111,
				\modfreq, 4*~t * Pseq([1/10],inf),
				\modamp, 0.7001,
				\hpf, 500,
				\gain, 0.4,
				\dur, 1,
				\amp, 0.1,
			),
			Pmono(\fx_freqshift,
				\inbus, BusDef(\sendbus3),
				\shift, 1400,
				\mix, 1,
				\dur, 1,
			),

			// bass

			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,1,
				],inf),
				\legato, Pseq([
					//4,0,0,0, 1,0,1,1,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\dur, 1/2,
				\amp, 0.1,
				\out, BusDef(\sendbus4, \audio),
			),
			Pmono(\chorusdistlim,
				\inbus, BusDef(\sendbus4, \audio, 2),
				\distamp, 20,
				\distpostamp, 1/1,
				\fb, 0.904,
				\distmix, 1,
				\delay, 0.00111,
				\modfreq, 4*~t * Pseq([1/10],inf),
				\modamp, 0.7001,
				\hpf, 500,
				\gain, 0.4,
				\dur, 1,
				\amp, 0.1,
			),
		Pbind(
			\instrument, \snapsigh,
			\note, Pseq([
				\rest,
				\rest,
				[0,7,9],
				[-2,3,9-12],
			],inf),
			\octave, 7,
			\lpf, 500,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)
