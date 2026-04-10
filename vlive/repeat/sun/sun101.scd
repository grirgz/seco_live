
/////////////////////////////////////////// feynman trance
// from suft25

(
~t = 155/4/60; TempoClock.default.tempo = ~t;
~swing = 1/6;
FileSystemProject.load("capsule/draftsynth.scd");
FileSystemProject.load("capsule/fxheavy.scd");
)

(
SynthDef(\longway, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.01;
	var sig;
	var spread =1;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * ( SinOsc.ar(freq*0.2) * 1 + 1 )) * ( SinOsc.ar(freq * 0.2) * 1 + 1 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,2.1),gate,doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\longway, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \longway,
				\note, Pseq([
					18,0,7,8
				],inf),
				\fspread, 1/Pkey(\freq) * 8,
				\dur, 1,
				\amp, 0.1,
			),
			//Pbind(
				//\instrument, \playersec_looper,
				//\bufnum, BufDef('voices/feynman.flac'),
				//\trigfreq, 8*~t,
				//\legato, 1,
				//\pos, ~pmodenv.(Pseq([0,2,1,4],inf), 8),
				//\dur, 1,
				//\gain, 1/2,
			////	\out, BusDef(\smpsendbus1, \audio),
			//),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
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
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),

		//Pbind(\out, BusDef(\drums1, \audio)) <>
		//Ppar([
			//Pbind(
				//\instrument, \snapkickx,
				//\dur, 1/8,
				//\isRest, Pseq([
					//1,0,1,0, 
					//1,0,1,0, 
					//1,0,1,0, 
					//1,0,1,0, 
				//],inf).coin.not,
				//\amp, 0.1,
			//),
			//PatKitDef(\ksh2b).asPattern(Pbind(
				//\kitIndex, 5,
				//\isRest, Pseq([
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 1,0,0,0,
					//0,1,0,0, 0,0,0,0,

					//0,0,0,0, 1,0,0,1,
					//0,1,0,0, 0,1,0,1,
					//0,0,0,0, 0,1,0,0,
					//0,1,0,0, 1,0,1,0,

					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 1,0,0,0,
					//0,1,0,0, 1,0,0,0,

					//0,0,0,0, 1,0,1,0,
					//0,1,1,0, 1,0,1,1,
					//0,1,0,1, 1,0,1,0,
					//0,1,0,0, 1,0,1,0,
				//],inf).coin.not,
				//\gain, 0.2,
				//\gain, Pkey(\gain) * Pseq([
					////Pseq([
						////1,1/3,1/2,1/3,
					////],2*4),
					//Pseq([
						//1,2/3,1/2,2/3,
					//],2*4),
				//],inf),
				//\speed, Pwhite(1,1.01),
				//\sustain, 0.1 * Pseq([
					//1,3/5,4/5,3/5,
					//2,3/5,4/5,3/5,
				//],inf),
				//\dur, 1/8 * (1 + (1/6 * Pseq([1,-1],inf))),
			//)),
			//Pbind(
				//\instrument, \phyhat3,
				//\isRest, Pseq([
					//1,0,0,1, 1,0,1,0, 1,0,0,0, 1,0,1,1,
					//1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					//1,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				//],inf).coin.not,
				//\sustain, 0.05,
				//\fac1,0.2,
				//\dur, 1/16 * (1 + (1/6 * Pseq([1,0,-1,0],inf))),
				//\amp, 0.01 * Pseq([1,0.7],inf),
			//),
		//]),

		//Pmono( \rdncleandist_fulllight,
			//\inbus, BusDef(\drums1, \audio, 2),
			//\addAction, \addToTail,
			//'wet10', 1.0,
			//'mix', 0.55714285714286,
			//'gain', 0.7344889782792,
			//'fb', 0.0002099467303085,
			//'delay', 0.0000600001231 * Pseq([
				//1,
			//],inf).stutter(1),
			//'delay2', 0.0000543560101,
			//'distamp', 1.361836201538,
			//'prelpf', 8900,
			//'prehpf', 17,
			//'lpf', 9900,
			//'hpf', 17,
			//'fbdistamp', 4.5388371966577,
			//'fbdistmix', 0.98176470588235,
			//'postlpf', 19900,
			//'posthpf', 17,
			//\bpmix, 0,
			//'wetamp', 0.20503372119697,
			//'indelay', 0.04,
			//'wet20', 1.0,
			//'mamp', 1,
			//\dur, 1,
		//),
		//Pmono( \rdncleandist_fulllight,
			//\inbus, BusDef(\drums1, \audio, 2),
			//\addAction, \addToTail,
			//'wet10', 1.0,
			//'mix', 0.25714285714286,
			//'gain', 0.9344889782792,
			//'fb', 0.0002099467303085,
			//'delay', 0.000200001231 * Pseq([
				//1,
			//],inf).stutter(1),
			//'delay2', 0.0000543560101,
			//'distamp', 1.361836201538,
			//'prelpf', 19900,
			//'prehpf', 917,
			//'lpf', 19900,
			//'hpf', 117,
			//'fbdistamp', 4.5388371966577,
			//'fbdistmix', 0.98176470588235,
			//'postlpf', 19900,
			//'posthpf', 170,
			//\bpmix, 0,
			//'wetamp', 0.20503372119697,
			//'indelay', 0.04,
			//'wet20', 1.0,
			//'mamp', 1,
			//\dur, 1,
		//),
		//Pmono( \rdncleandist_fulllight,
			//\inbus, BusDef(\drums1, \audio, 2),
			//\addAction, \addToTail,
			//'wet10', 1.0,
			//'mix', 0.25714285714286,
			//'gain', 0.9344889782792,
			//'fb', 0.0002099467303085,
			//'delay', 0.000200001231 * Pseq([
				//1,1.3,1/2,
			//],inf).stutter(1),
			//'delay2', 0.1000543560101,
			//'distamp', 2.361836201538,
			//'prelpf', 19900,
			//'prehpf', 13917,
			//'lpf', 19900,
			//'hpf', 117,
			//'fbdistamp', 4.5388371966577,
			//'fbdistmix', 0.98176470588235,
			//'postlpf', 19900,
			//'posthpf', 170,
			//\bpmix, 0,
			//'wetamp', 0.20503372119697,
			//'indelay', 0.04,
			//'wet20', 1.0,
			//'mamp', 1,
			//\dur, 1/4,
		//),
	])
)).play;
)


// orig
(
Pdef(\part, Pdef(\longway, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \longway,
				\note, Pseq([
					18,0,7,8
				],inf),
				\fspread, 1/Pkey(\freq) * 8,
				\dur, 1,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec_looper,
				\bufnum, BufDef('voices/feynman.flac'),
				\trigfreq, 400*~t,
				\legato, 1,
				\pos, ~pmodenv.(Pseq([0,2,1,4],inf), 8),
				\dur, 1,
				\gain, 1/2,
			//	\out, BusDef(\smpsendbus1, \audio),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
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
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),

		Pbind(\out, BusDef(\drums1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 
					1,0,1,0, 
					1,0,1,0, 
					1,0,1,0, 
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 0,0,0,0,

					0,0,0,0, 1,0,0,1,
					0,1,0,0, 0,1,0,1,
					0,0,0,0, 0,1,0,0,
					0,1,0,0, 1,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,0,

					0,0,0,0, 1,0,1,0,
					0,1,1,0, 1,0,1,1,
					0,1,0,1, 1,0,1,0,
					0,1,0,0, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.2,
				\gain, Pkey(\gain) * Pseq([
					//Pseq([
						//1,1/3,1/2,1/3,
					//],2*4),
					Pseq([
						1,2/3,1/2,2/3,
					],2*4),
				],inf),
				\speed, Pwhite(1,1.01),
				\sustain, 0.1 * Pseq([
					1,3/5,4/5,3/5,
					2,3/5,4/5,3/5,
				],inf),
				\dur, 1/8 * (1 + (1/6 * Pseq([1,-1],inf))),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0,1, 1,0,1,0, 1,0,0,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.2,
				\dur, 1/16 * (1 + (1/6 * Pseq([1,0,-1,0],inf))),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),

		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drums1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.55714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.0000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.0000543560101,
			'distamp', 1.361836201538,
			'prelpf', 8900,
			'prehpf', 17,
			'lpf', 9900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drums1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.25714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000200001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.0000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 917,
			'lpf', 19900,
			'hpf', 117,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 170,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drums1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.25714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000200001231 * Pseq([
				1,1.3,1/2,
			],inf).stutter(1),
			'delay2', 0.1000543560101,
			'distamp', 2.361836201538,
			'prelpf', 19900,
			'prehpf', 13917,
			'lpf', 19900,
			'hpf', 117,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 170,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),

	])
)).play;
)

// cleaned noise
(
Pdef(\part, Pdef(\longway, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \longway,
				\note, Pseq([
					18,0,7,8
				],inf),
				\fspread, 1/Pkey(\freq) * 8,
				\dur, 1,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec_grain,
				\mbufnum, BufDef.mono('voices/feynman.flac'),
				\gfreq, 400*~t,
				\gdur, 0.005,
				\legato, 1,
				\pos, ~pmodenv.(Pseq([0,2,1,4],inf), 8),
				\dur, 1,
				\gain, 1/2,
				\amp, 0.4,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
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
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),

		Pbind(\out, BusDef(\drums1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 
					1,0,1,0, 
					1,0,1,0, 
					1,0,1,0, 
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 0,0,0,0,

					0,0,0,0, 1,0,0,1,
					0,1,0,0, 0,1,0,1,
					0,0,0,0, 0,1,0,0,
					0,1,0,0, 1,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,0,

					0,0,0,0, 1,0,1,0,
					0,1,1,0, 1,0,1,1,
					0,1,0,1, 1,0,1,0,
					0,1,0,0, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.2,
				\gain, Pkey(\gain) * Pseq([
					//Pseq([
						//1,1/3,1/2,1/3,
					//],2*4),
					Pseq([
						1,2/3,1/2,2/3,
					],2*4),
				],inf),
				\speed, Pwhite(1,1.01),
				\sustain, 0.1 * Pseq([
					1,3/5,4/5,3/5,
					2,3/5,4/5,3/5,
				],inf),
				\dur, 1/8 * (1 + (1/6 * Pseq([1,-1],inf))),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0,1, 1,0,1,0, 1,0,0,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.2,
				\dur, 1/16 * (1 + (1/6 * Pseq([1,0,-1,0],inf))),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),

		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drums1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.55714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.0000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.0000543560101,
			'distamp', 1.361836201538,
			'prelpf', 8900,
			'prehpf', 17,
			'lpf', 9900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drums1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.25714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000200001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.0000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 917,
			'lpf', 19900,
			'hpf', 117,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 170,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drums1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.25714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000200001231 * Pseq([
				1,1.3,1/2,
			],inf).stutter(1),
			'delay2', 0.1000543560101,
			'distamp', 2.361836201538,
			'prelpf', 19900,
			'prehpf', 13917,
			'lpf', 19900,
			'hpf', 117,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 170,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),

	])
)).play;
)

// change drums

(
Pdef(\part, Pdef(\longway, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \longway,
				\note, Pseq([
					18,0,7,8
				],inf),
				\fspread, 1/Pkey(\freq) * 8,
				\dur, 1,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec_grain,
				\mbufnum, BufDef.mono('voices/feynman.flac'),
				\gfreq, 400*~t,
				\gdur, 0.005,
				\legato, 1,
				\pos, ~pmodenv.(Pseq([0,2,1,4],inf), 8),
				\dur, 1,
				\gain, 1/2,
				\amp, 0.4,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
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
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),

		Pbind(\out, BusDef(\drums1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[3].value,
				//\bufnum, ~buflib.kick[1155].value,
				\bufnum, ~buflib.kick[1395].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,1,0, 
					1,0,1,0, 
					1,0,1,0, 
					1,0,1,0, 
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.2,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[1742].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 0,0,0,0,

					0,0,0,0, 1,0,0,1,
					0,1,0,0, 0,1,0,1,
					0,0,0,0, 0,1,0,0,
					0,1,0,0, 1,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,0,

					0,0,0,0, 1,0,1,0,
					0,1,1,0, 1,0,1,1,
					0,1,0,1, 1,0,1,0,
					0,1,0,0, 1,0,1,0,
				],inf).coin.not,
				\speed, Pwhite(1,1.01),
				\sustain, 0.1 * Pseq([
					1,3/5,4/5,3/5,
					2,3/5,4/5,3/5,
				],inf),
				\dur, 1/8 * (1 + (1/6 * Pseq([1,-1],inf))),
				\gain, 0.2,
				\gain, Pkey(\gain) * Pseq([
					//Pseq([
						//1,1/3,1/2,1/3,
					//],2*4),
					Pseq([
						1,2/3,1/2,2/3,
					],2*4),
				],inf),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[352].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,0,1, 1,0,1,0, 1,0,0,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\fac1,0.2,
				\dur, 1/16 * (1 + (1/6 * Pseq([1,0,-1,0],inf))),
				\gain, 0.1 * Pseq([1,0.7],inf),
			),
		]),

		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drums1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.10714285714286,
			'gain', 0.8344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.4000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.2000543560101,
			'distamp', 1.361836201538,
			'prelpf', 8900,
			'prehpf', 17,
			'lpf', 9900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),

	])
)).play;
)

//////////// try remove noise

(
SynthDef(\playersec_looper, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var trigger = Impulse.ar(\trigfreq.kr(0));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
			Pbind(
				\instrument, \playersec_looper,
				\bufnum, BufDef('voices/feynman.flac'),
				\trigfreq, 400*~t,
				\legato, 1,
				\pos, ~pmodenv.(Pseq([0,2,1,4],inf), 8),
				\dur, 1,
				\gain, 1/2,
			),
	])
)).play;
);
(
SynthDef(\playersec_looper2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	sig = BufRd.ar(2, bufnum, phase: K2A.ar(pos*BufSampleRate.kr(bufnum)), loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
Pdef(\part).reset;
)


(
// now too slow, we need grain
Pdef(\part, Pdef(\zedpart, 
	Ppar([
			Pbind(
				\instrument, \playersec_looper2,
				\bufnum, BufDef('voices/feynman.flac'),
				\trigfreq, 400*~t,
				\legato, 1,
				\pos, ~pmodenv.(Pseq([0,2,1,4],inf), 8),
				\dur, 1,
				\gain, 1/2,
			),
	])
)).play;
);

(
// now in sndlib/synthplayrec.scd
SynthDef(\playersec_grain, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, pos=0, gdur=0.005, mbufnum=0;
	var sig;
	var clk = Impulse.ar(\gfreq.kr(400));
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)
(
SynthDef(\playersec_grain2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, pos=0, gdur=0.005, mbufnum=0;
	var sig;
	var clk = Impulse.ar(\gfreq.kr(400));
	//pos = pos + SinOsc.ar(1,mul:400/SampleRate.ir); 
	//pos = pos + LFSaw.ar(1,mul:400/SampleRate.ir); 
	pos = pos + LFNoise1.kr(4340,mul:14/SampleRate.ir);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)
(
// nice
Pdef(\part, Pdef(\zedpart, 
	Ppar([
			Pbind(
				\instrument, \playersec_grain,
				\mbufnum, BufDef.mono('voices/feynman.flac'),
				\gfreq, 400*~t,
				\gdur, 0.005,
				\legato, 1,
				\pos, ~pmodenv.(Pseq([0,2,1,4],inf), 8),
				\dur, 1,
				\gain, 1/2,
				\amp, 0.4,
			),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec_grain,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, PmodEnv(Pseq([0,1],1), 2).loop,
			\pitch_stretch, 1,
			\legato, 1,
			\dur, 1,
			\amp, 0.4,
		),
	])
)).play;
);

////////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
			Pbind(
				\instrument, \longway,
				\note, Pseq([
					18,0,7,8
				],inf),
				//\fspread, 1/Pkey(\freq) * 2,
				\fspread, 0.001,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/2,
				\amp, 0.1,
			),
	])
)).play;
);

(
SynthDef(\longfm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, spread=0.8, fspread=0.01;
	var sig;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * ( SinOsc.ar(freq*\fmf.kr(0.2)) * \fma.kr(1) + 1 )) * ( SinOsc.ar(freq * \fmf2.kr(0.2)) * \fma2.kr(1) + 1 );
	sig = sig + SinOsc.ar(freq * SinOsc.ar(freq*1/2,mul:0.2) ); 
	sig = sig * 0.5;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
			Pbind(
				\instrument, \longfm,
				\note, Pseq([
					//18,0,7,8
					0,4,7
				],inf),
				\fspread, 1/Pkey(\freq) * 8,
				//\fspread, 0.0001,
				\fmf, 1.2,
				\fmf2, 0.2,
				\fmf2, PmodEnv(Pseq([0.1,1],1), 8).loop,
				\fmf, PmodEnv(1-Pseq([0.1,1],1), 8).loop,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.1) ],
				],inf),
				\legato, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \default,
				\note, Pseq([
					0,7,
				],inf),
				\dur, 1,
				\amp, 0.1,
			),
	])
)).play;
);


///////////////


(
Pdef(\part, Pdef(\longway, 
	Ppar([
		Pbind(
			\instrument, \longway,
			\note, Pseq([
				18,0,7,8
			],inf),
			\fspread, 1/Pkey(\freq) * 8,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec_grain,
				\mbufnum, BufDef.mono('voices/feynman.flac'),
				\gfreq, 400*~t,
				\gdur, 0.005,
				\legato, 1,
				\pos, ~pmodenv.(Pseq([0,2,1,4],inf), 8),
				\dur, 1,
				\gain, 1/2,
				\amp, 0.4,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
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
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1558].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],15),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[543].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],15),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[53].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
				0,0,1,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.051,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),



	])
)).play;
)

(
Pdef(\part, Pdef(\longway, 
	Ppar([
		Pbind(
			\instrument, \longway,
			\note, Pseq([
				18,0,7,8
			],inf),
			\fspread, 1/Pkey(\freq) * 8,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pbind(\out, BusDef(\voice, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec_grain,
				\mbufnum, BufDef.mono('voices/feynman.flac'),
				\gfreq, 400*~t,
				\gdur, 0.005,
				\legato, 1,
				\pos, ~pmodenv.(Pseq([0,2,1,4],inf), 8),
				\dur, 1,
				\gain, 1/3,
				\amp, 0.4,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\voice, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
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
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\out, BusDef(\voiceb, \audio),
		),
		Pbind(
			\inbus, BusDef(\voiceb, \audio),
			\instrument, \fx_env,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\amp, 0.1,
		),


		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1558].value,
			\bufnum, ~buflib.kick[1069].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],15),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.13,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[543].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],15),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.09,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[53].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
				0,0,1,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.08,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\sidegain, 1,
			\cpt, 0.051,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\basstrack2),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\basstrack2, \audio),
			\addAction, \addToTail,
			\hpf, 400,
			\gain, 0.6,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\basstrack3, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\basstrack3, \audio),
			//\addAction, \addToTail,
			\lag, 0.00091,
			\dur, 1/8/2,
			\legato, 0.9,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,0,1, 1,1,1,1,
				1,0,1,1, 0,1,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.6,0.1) ],
			],inf),
			\amp, 0.2 * Pseq([
				0.2,0.4,1,1,
			],inf),
			//\out, BusDef(\basstrack3, \audio),
		),
		Pmono(\fx_simplecompander,
			\inbus, BusDef(\basstrack4, \audio),
			\addAction, \addToTail,
			\lag, 0.00093,
			\cpt, 0.01000000149012,
			\cpbelow, 1.00100004673,
			\cpabove, 0.0099999997764826,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\wetgain, 6,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				6,0,7,8
			],inf).stutter(8*2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 0,1,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\lpf, 200,
			\legato, 1,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.7,0.3,0.1) ],
			],inf),
			\envamt, 1,
			\octave, Pseq([3,4],inf).stutter(2),
			\rq, 0.4,
			\dur, 1/8/2,
			\amp, 0.12,
			\out, BusDef(\truebasstrack, \audio),
		),
		Pmono(\fx_lowshelf,
			\inbus, BusDef(\truebasstrack, \audio),
			\addAction, \addToTail,
			\db, 7,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\truebasstrack2, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\truebasstrack2, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\sidegain, 0,
			\cpt, 0.051,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			//\out, BusDef(\basstrack2),
		),



	])
)).play;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				6,0,7,8
			],inf).stutter(8),
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \longway2,
			\note, Pseq([
				6,0,7,8
			],inf),
			\octave, 5,
			//\legato, 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\fspread, 1/Pkey(\freq) * 8,
			\legato, 1,
			\dur, 1,
			\amp, 0.1,
			//\out, BusDef(\basstrack, \audio),
			\out, BusDef(\longway1, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\longway1, \audio),
			\addAction, \addToTail,
			\lpf, 200,
			\hpf, 50,
			\lag, 0.0009,
			\gain, 1,
			\dur, 1,
			\mix, 0,
			\out, BusDef(\longway2, \audio),
		),
		Pmono(\fx_simplecompander,
			\inbus, BusDef(\longway2, \audio),
			\pregain, 1.0,
			\cpt, 0.10000000149012,
			\cpbelow, 0.50100004673,
			\cpabove, 0.0099999997764826,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\wetgain, 1.0,
			\mix, 1.0,
			\gain, 1.1,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,

			\lag, 0.00091,
			\dur, 1,
			\out, BusDef(\longway3, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\longway3, \audio),
			\addAction, \addToTail,
			\room,3,
			\lag, 0.00092,
			\mix, 0,
			\dur, 1,
			\out, BusDef(\longway4, \audio),
		),
		Pmono(\fx_clip2,
			\inbus, BusDef(\longway4, \audio),
			\distamp, 14.0,
			\level, 1.0,
			\distpostamp, 0.25,
			\mix, 0.51,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\gain, 1.0/2,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\longway5, \audio),
		),
		//Pmono(\fx_vintageDist,
			//\inbus, BusDef(\longway4, \audio),
			//\addAction, \addToTail,
			//\lag, 0.00094,
			//\mix, 0.25,
			//\dur, 1,
			//\out, BusDef(\longway5, \audio),
		//),
		Pmono(\fx_lpf,
			\inbus, BusDef(\longway5, \audio),
			\addAction, \addToTail,
			\lpf, 400,
			\lag, 0.0009,
			\rq, 0.9,
			\dur, 1,
			\mix, 0,
			\gain, 1.32,
			\out, BusDef(\longway6, \audio),
		),
		Pmono(\fx_lowshelf,
			\inbus, BusDef(\longway6, \audio),
			\addAction, \addToTail,
			\db, 8,
			\lag, 0.0009,
			\freq, 200,
			\rs, 8,
			\dur, 1,
			\mix, 0,
			\out, BusDef(\basstrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1558].value,
			\bufnum, ~buflib.kick[1069].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],15),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.13,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\addAction, \addToTail,
			\lag, 0.00097,
			\sidegain, 1,
			\cpt, 0.011,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.2,
			\gain, 1,
			\dur, 1,
			//\out, BusDef(\basstrack2),
		),
		
		Pbind(
			\instrument, \playersec_grain,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\gfreq, 400*~t,
			\gdur, 0.005,
			\legato, 1,
			\pos, ~pmodenv.(Pseq([0,2,1,4],inf), 8),
			\pitch_stretch, PmodEnv(Pseq([1,2,1/2,4],1), 2).loop,
			\dur, 1,
			\gain, 1/3,
			\amp, 0.4,
			\out, BusDef(\voice, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\voice, \audio),
			\addAction, \addToTail,
			\hpf, 400,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[53].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
				0,0,1,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.08,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1558].value,
			\bufnum, ~buflib.kick[1069].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],15),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.13,
		),
		
	])
)).play;
);
(
SynthDef(\longway2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.01;
	var sig;
	var spread =1;
	sig = SinOsc.ar(freq / 4 * ((0..7)/7 - 0.5 * fspread + 1) * ( SinOsc.ar(freq/4) * 1 + 1 )) * ( SinOsc.ar(freq/4 ) * 1 + 1 );
	sig = SinOsc.ar(freq/4) + sig;
	//sig = sig + (sig.clip(0.8).tanh * 0.5 + 1);
	//sig = sig * SinOsc.ar(8*~t).clip(0,1);
	//sig = sig.tanh;
	sig = RLPF.ar(sig, \lpf.kr(700), \rq.kr(0.5));
	sig = HPF.ar(sig, 70);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.1)),gate,doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
//Pdef(\part).reset;
);
