

~t = 138/4/60; TempoClock.default.tempo = ~t; // freedom fighter


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 51], [0.035, 1.48], curve: \exp) ],
			\bodyenv, [ Env.linen(0.001,0.3,0.1) ],
			\clickrel, 0.01,
			\distpreamp, 2,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\bass, Pbind(
	\instrument, \basicbass,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
)).play;
);

ProtoDef(\piano).keyboard
ProtoDef(\piano).startControl(Pdef(\bass))
WindowDef(\PdefEditor).front(Pdef(\bass))
Pdef(\bass).getHalo(\MIDIFunc)


(
~m = MIDIdef.cc(\track1, { arg ... args;
	args.postln;
	
}).learn;
)
(
~m = MIDIFunc.cc({ arg ... args;
	args.postln;
	
}).fix.learn;
)
~m.clear
MIDIFunc.allEnabled

Param(Pdef(\bass), \bla).absKey

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\degree, Pstep(Pseq([
					Pseq([
						\r,\r,\r,\r,
						\r,\r,\r, 1,
					],1),
					Pseq([
						-2,5,5,5,
						5,\r,\r, -2,
						1,\r,\r, 1,
						0, \r,-1, \r,
						
						-2,\r,\r, \r,
						\r,-2,-2, -1,
						1, 1,1, 1,
						0, \r, -1, \r,
					],inf),
			
				],inf),1/8),
				\octave, 2,
				\bodyfreqenv, Pfunc({ arg ev;
					var fr = ev.use { ~freq.value };
					[ Env([500,fr,fr],[0.01,0.1]) ];
				}),
				\bodyenv, [ Env.linen(0.01,0.08,0.01) ],
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,1,0, 0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/16,
				\amp, 0.2,
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

		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq({[
					0,0,1,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq({[
					0,1,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,1,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\gain, 0.2,
				\amp, 0.1,
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
			Pbind(
				\instrument, \basicbass,
				\degree, Pseq([
					Pseq([
					-2,\r,-2,-2,
					5,\r,\r, -2,
					1,\r,\r, 1,
					0, \r,-1, \r,
			
					-2,\r,\r, \r,
					\r,-2,-2, -1,
					1, 1,1, 1,
					0, \r, -1, \r,
					],1),
					Pseq([
					-2,5,5,5,
					5,\r,\r, -2,
					1,\r,\r, 1,
					0, \r,-1, \r,
			
					-2,\r,\r, \r,
					\r,-2,-2, -1,
					1, 1,1, 1,
					0, \r, -1, \r,
					],1),
			
				],inf),
				\legato, Pseq([
					1,1,1,1,
					2,1,1,1,
					1,1,1,1,
					1,1,1,1,
			
					2,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
				],inf) * 0.8,
				//\lpf, Pkey(\freq)*1.2,
				\octave, 3,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\bus0, \audio),
			),
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\bus0),
				\delay, 0.04,
				\postgain, 0,
				\send3, 0.04,
				\dur, 1,
			),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.500600001231 * Pseq([
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
			\addAction, \addToTail,
			'mamp', 1,
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.500600001231 * Pseq([
				1,1000,1,1/100,
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
			\addAction, \addToTail,
			'mamp', 1,
			\dur, 1/4,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 47.361836201538,
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
			\addAction, \addToTail,
			'mamp', 1,
			\dur, 1/4,
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
				\instrument, \snapkickx,
				\degree, Pstep(Pseq([
					-2,5,5,5,
					5,\r,\r, -2,
					1,\r,\r, 1,
					0, \r,-1, \r,
			
					-2,\r,\r, \r,
					\r,-2,-2, -1,
					1, 1,1, 1,
					0, \r, -1, \r,
			
				],inf),1/8),
				\octave, 2,
				\bodyfreqenv, Pfunc({ arg ev;
					var fr = ev.use { ~freq.value };
					[ Env([500,fr,fr],[0.01,0.1]) ];
				}),
				\bodyenv, [ Env.linen(0.01,0.08,0.01) ],
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,1,0, 0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/16,
				\amp, 0.2,
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

		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			PatKitDef(\sample1).asPattern(Pbind(
				\instrument,\playersec_hlpf,
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,1,1,0,

					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,0,1,0, 0,0,1,1,
					1,0,0,0, 1,1,0,1,

					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,0,1,0, 0,0,0,1,
					0,1,1,1, 0,1,1,0,
				],inf).coin.not,
				\speed, 1.8 * Pseq([
					1,1.02,
				],inf),
				\hpfmix, 1,
				\hpf, 7400,
				\sustain, 0.01 * Pseq([
					1,
				],inf),
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,1,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,1,
					0,1,0,0, 0,0,1,0,
					0,0,0,1, 0,0,1,0,
					0,1,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 0,0,1,0,
					0,0,0,1, 0,0,1,1,
					0,1,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\gain, 0.2,
				\amp, 0.1,
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
			Pbind(
				\instrument, \basicbass,
				\degree, Pseq([
					-2,5,5,5,
					5,\r,\r, -2,
					1,\r,\r, 1,
					0, \r,-1, \r,
			
					-2,\r,\r, \r,
					\r,-2,-2, -1,
					1, 1,1, 1,
					0, \r, -1, \r,
			
				],inf),
				\legato, Pseq([
					1,1,1,1,
					2,1,1,1,
					1,1,1,1,
					1,1,1,1,
			
					2,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
				],inf) * 0.8,
				//\lpf, Pkey(\freq)*1.2,
				\octave, 3,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\bus0, \audio),
			),
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\bus0),
				\delay, 0.04,
				\postgain, 0,
				\send3, 0.04,
				\dur, 1,
			),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.500600001231 * Pseq([
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
			\addAction, \addToTail,
			'mamp', 1,
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.9344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000004001231 * Pseq([
				1,1000,1,1/100,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.445388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			\addAction, \addToTail,
			'mamp', 1,
			\dur, 1/4,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0008099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.440000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 47.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 44.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			\addAction, \addToTail,
			'mamp', 1,
			\dur, 1/4,
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
				\instrument, \snapkickx,
				\degree, Pstep(Pseq([
					-2,5,5,5,
					5,\r,\r, -2,
					1,\r,\r, 1,
					0, \r,-1, \r,
			
					-2,\r,\r, \r,
					\r,-2,-2, -1,
					1, 1,1, 1,
					0, \r, -1, \r,
			
				],inf),1/8),
				\octave, 2,
				\bodyfreqenv, Pfunc({ arg ev;
					var fr = ev.use { ~freq.value };
					[ Env([500,fr,fr],[0.01,0.1]) ];
				}),
				\bodyenv, [ Env.linen(0.01,0.08,0.01) ],
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,1,0, 0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/16,
				\amp, 0.2,
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

		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,1,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,1,0,
					0,0,0,0, 0,1,1,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0, 0,0,1,0, 0,1,0,1,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,0,
					0,0,1,0, 0,1,0,1, 0,0,0,0, 0,0,0,0,

				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.04,
				\dur, 1/16,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\instrument,\playersec_hlpf,
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,1,1,0,

					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,0,1,0, 0,0,1,1,
					1,0,0,0, 1,1,0,1,

					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,0,1,0, 0,0,0,1,
					0,1,1,1, 0,1,1,0,
				],inf).coin.not,
				\speed, 1.8 * Pseq([
					1,1.02,
				],inf),
				\hpfmix, 1,
				\hpf, 7400,
				\sustain, 0.01 * Pseq([
					1,
				],inf),
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,1,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,1,
					0,1,0,0, 0,0,1,0,
					0,0,0,1, 0,0,1,0,
					0,1,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 0,0,1,0,
					0,0,0,1, 0,0,1,1,
					0,1,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\gain, 0.2,
				\amp, 0.1,
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
			Pbind(
				\instrument, \basicbass,
				\degree, Pseq([
					-2,5,5,5,
					5,\r,\r, -2,
					1,\r,\r, 1,
					0, \r,-1, \r,
			
					-2,\r,\r, \r,
					\r,-2,-2, -1,
					1, 1,1, 1,
					0, \r, -1, \r,
			
				],inf),
				\legato, Pseq([
					1,1,1,1,
					2,1,1,1,
					1,1,1,1,
					1,1,1,1,
			
					2,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
				],inf) * 0.8,
				//\lpf, Pkey(\freq)*1.2,
				\octave, 3,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\bus0, \audio),
			),
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\bus0),
				\delay, 0.04,
				\postgain, 0,
				\send3, 0.04,
				\dur, 1,
			),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.200600001231 * Pseq([
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
			\addAction, \addToTail,
			'mamp', 1,
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.9344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000004001231 * Pseq([
				1,2,1/2,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.445388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			\addAction, \addToTail,
			'mamp', 1,
			\dur, 1/4,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.5344889782792,
			'fb', 0.0000099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000030543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 47.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 44.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			\addAction, \addToTail,
			'mamp', 1,
			\dur, 1/4,
		),

	])
)).play;
)



(
// more snare
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\degree, Pstep(Pseq([
					-2,5,5,5,
					5,\r,\r, -2,
					1,\r,\r, 1,
					0, \r,-1, \r,
			
					-2,\r,\r, \r,
					\r,-2,-2, -1,
					1, 1,1, 1,
					0, \r, -1, \r,
			
				],inf),1/8),
				\octave, 2,
				\bodyfreqenv, Pfunc({ arg ev;
					var fr = ev.use { ~freq.value };
					[ Env([500,fr,fr],[0.01,0.1]) ];
				}),
				\bodyenv, [ Env.linen(0.01,0.08,0.01) ],
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,1,0, 0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/16,
				\amp, 0.2,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					1,0,0,1, 1,0,1,0,
					0,0,0,0, 1,0,1,0,
					0,1,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,0,
					0,0,0,0, 1,0,1,0,
					0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
		]),

		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,1,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,1,0,
					0,0,0,0, 0,1,1,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0, 0,0,1,0, 0,1,0,1,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,0,
					0,0,1,0, 0,1,0,1, 0,0,0,0, 0,0,0,0,

				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.04,
				\dur, 1/16,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\instrument,\playersec_hlpf,
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,1,1,0,

					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,0,1,0, 0,0,1,1,
					1,0,0,0, 1,1,0,1,

					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,0,1,0, 0,0,0,1,
					0,1,1,1, 0,1,1,0,
				],inf).coin.not,
				\speed, 1.8 * Pseq([
					1,1.02,
				],inf),
				\hpfmix, 1,
				\hpf, 7400,
				\sustain, 0.01 * Pseq([
					1,
				],inf),
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,1,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,1,
					0,1,0,0, 0,0,1,0,
					0,0,0,1, 0,0,1,0,
					0,1,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 0,0,1,0,
					0,0,0,1, 0,0,1,1,
					0,1,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\gain, 0.2,
				\amp, 0.1,
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
			Pbind(
				\instrument, \basicbass,
				\degree, Pseq([
					-2,5,5,5,
					5,\r,\r, -2,
					1,\r,\r, 1,
					0, \r,-1, \r,
			
					-2,\r,\r, \r,
					\r,-2,-2, -1,
					1, 1,1, 1,
					0, \r, -1, \r,
			
				],inf),
				\legato, Pseq([
					1,1,1,1,
					2,1,1,1,
					1,1,1,1,
					1,1,1,1,
			
					2,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
				],inf) * 0.8,
				//\lpf, Pkey(\freq)*1.2,
				\octave, 3,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\bus0, \audio),
			),
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\bus0),
				\delay, 0.04,
				\postgain, 0,
				\send3, 0.04,
				\dur, 1,
			),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.200600001231 * Pseq([
				1,
				1/2,
				1,
				1,
				0.0001,
				0.01,
				1,
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
			\addAction, \addToTail,
			'mamp', 1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.9344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000004001231 * Pseq([
				1,2,1/2,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.445388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			\addAction, \addToTail,
			'mamp', 1,
			\dur, 1/4,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.5344889782792,
			'fb', 0.0000099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000030543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 47.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 44.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			\addAction, \addToTail,
			'mamp', 1,
			\dur, 1/4,
		),

	])
)).play;
)



