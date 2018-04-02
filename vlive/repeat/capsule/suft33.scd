

~t = 145/4/60; TempoClock.default.tempo = ~t;


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,1,
			],inf),1),
			\octave, 3,
			\legato, Pseq([
				3,0,0,0, 2,0,2,0,
				0,0,1,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			//\lag, 0.04,
			\amp, 0.1,
			\out, BusDef(\bassbus, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\bassbus, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 1/10,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shift2', -1.13,
			'shift3', -2.478,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'stereo', 1.0,
			'fbdistamp', 0.923,
			'fbdistmix', 0.911,
			'postlpf', 19000,
			'posthpf', 17,
			'wetamp', 0.18,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37,
			'brffac', 0.60,
		),
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
	])
)).play;
)


(
Pdef(\cbass, 
	Pbind(
		\instrument, \basicbass,
		\note, Pstep(Pseq([
			0,0,0,1,
		],inf),1),
		\octave, 3,
		\legato, Pseq([
			3,0,0,0, 2,0,2,0,
			0,0,1,0, 2,0,2,0,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		//\lag, 0.04,
		\amp, 0.1,
	),
).play;
);


(
Pdef(\ckick, 
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
).play;
);

(
Pdef(\csnare, 
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
).play;
);

(
Pdef(\chat, 
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
).play;
);


(
Pdef(\cdrumfx, 
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\drumbus, \audio, 2),
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
	) 
);

(
	Pdef(\cbassfx, 
	
		Pmono(\rdnroom,
			\inbus, BusDef(\bassbus, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 1/10,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shift2', -1.13,
			'shift3', -2.478,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'stereo', 1.0,
			'fbdistamp', 0.923,
			'fbdistmix', 0.911,
			'postlpf', 19000,
			'posthpf', 17,
			'wetamp', 0.18,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37,
			'brffac', 0.60,
		),
	)
)

(
Pdef(\part, Pdef(\main, 
	Ppar([
		Pbind( \out, BusDef(\drumbus, \audio), ) <>
		Ppar([
			Pbind(
				\isRest, Pseq([
					1,0,
				],inf).coin.not,
			) <>
			Pdef(\ckick),
			Pdef(\csnare),
			Pdef(\chat),
		]),
		Pdef(\cdrumfx),

		Pbind( \out, BusDef(\bassbus, \audio)) <> Pdef(\cbass),
		Pdef(\cbassfx),
		
	])
)).play;
)


////////////////////////////////////////////



(
SynthDef(\bigkick, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(\bodyfreqenv.kr(Env([261, 60, 51], [0.035, 0.08], curve: \exp)));
	bodyAmp = EnvGen.ar(\bodyenv.kr(Env.linen(0.005, 0.1, 0.3)), doneAction: 2);
	body = SinOsc.ar(bodyFreq) * bodyAmp;
	// pop sweeps over the midrange
	popFreq = XLine.kr(\popfstart.kr(750), \popfend.kr(261), \popfdur.kr(0.02));
	popAmp = EnvGen.ar(\popenv.kr(Env.linen(0.001, 0.02, 0.001))) * \popamp.kr(0.15);
	pop = SinOsc.ar(popFreq) * popAmp;
	// click is spectrally rich, covering the high-freq range
	// you can use Formant, FM, noise, whatever
	clickAmp = EnvGen.ar(Env.perc(\clickat.kr(0.001), \clickrel.kr(0.01))) * \clickamp.kr(0.15);
	click = LPF.ar(Formant.ar(\formfund.kr(910), \formfreq.kr(4760), \formbw.kr(2110)), \lpf.kr(3140)) * clickAmp;

	snd = body + pop + click;
	snd = snd * \distpreamp.kr(1) * EnvGen.ar( \distenv.kr(Env([1,2,1],[0.1,0.8])));
	snd = snd.tanh;
	snd = snd * \distpostamp.kr(1);

	snd = snd * ( 1-EnvGen.ar( Env([0,1], [0.1]),In.kr(\chokebus.kr(BusDef(\zero, \control)), 1) * Duty.kr(0.01, 0, Dseq([ 0,Dseq([1],inf), ],inf)), doneAction:2) ); 
	Out.kr(\chokebus.kr, Impulse.kr(0));

	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \bigkick,
			\bodyfreqenv, 
			Pseq([
				[ Env([220,42,40],[0.01,0.8]) ],
				[ Env([220,42,35],[0.01,0.8]) ],
				[ Env([220,48,46],[0.01,0.8]) ],
				[ Env([220,40,50],[0.01,0.8]) ],
			],inf).stutter(32 * 4),
			\bodyenv, 
			Pseq([
				[ Env.linen(0.001,0.1,0.08) ],
				[ Env.linen(0.001,0.1,1.22) ],
				[ Env.linen(0.001,0.1,0.22) ],
				[ Env.linen(0.001,0.1,0.42) ],
			],inf).stutter(32*8),
			\denv, Pseg(Pseq([0,4],inf),8),
			\distenv, Pfunc({ arg ev;
				[ Env([1,1.2,1],[ev[\denv],0.8]) ];
			}),
			//\sustain, 0.1,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,1, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16 * (1 + (0.06 * Pseq([1,-1],inf))),
			\distpreamp, 10,
			\amp, 0.1,
			\out, BusDef(\mixdrum, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\sustain, 0.051,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\mixdrum, \audio),
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
			\out, BusDef(\mixdrum, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\mixdrum),
			\send1, 0.9,
			\delay, 0.04,
			\lag, 0.0009,
			\postgain, 0,
			\postgain, ~pmodline.(0,1,8),
			\dur, 1,
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1,
			'gain', 1/10,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0001080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.19,
			'shift', -5.0,
			'shift2', -1.13,
			'shift3', -2.478,
			'shiftmix', 0.1,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'stereo', 1.0,
			'fbdistamp', 0.923,
			'fbdistmix', 0.911,
			'postlpf', 19000,
			'posthpf', 17,
			'wetamp', 0.18,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37,
			'brffac', 0.60,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			\lag, 0.0001,
			'wet10', 1.0,
			'mix', 1,
			'gain', 0.444889782792,
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
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),

		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,0,1,5,
			],inf),1),
			\octave, 6,
			\fmr, 1/1* Pseg(Pseq([0,1/8],inf),16),
			\diff, 0.0001 * Pseg(Pseq([0,100],inf),8),
			\legato, Pseg(Pseq([0.1,1.2],inf),32),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.1/8,
			\out, BusDef(\mixhi, \audio),
		),
		Pbind(
			\instrument, \basicbass,
			\freq, 50,
			\octave, 3,
			\isRest, Pseq([
				0,0,1,
				0,1,1,
			],inf).coin.not,
			\dur, 1/12,
			\amp, 0.1,
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\mixhi),
			\send2, 0.9,
			\delay, 0.04,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1,
			'gain', 1/15,
			'fb', 0.000000031,
			'delay', 0.10000001,
			'delay2', 0.01001001,
			'delay3', 0.0010080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shift2', -1.13,
			'shift3', -2.478,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'stereo', 1.0,
			'fbdistamp', 0.923,
			'fbdistmix', 0.911,
			'postlpf', 19000,
			'posthpf', 17,
			'wetamp', 0.18,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37,
			'brffac', 0.60,
		),
	])
)).play;
)


TempoClock
