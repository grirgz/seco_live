// remix suft34
(
~t = 135/4/60; TempoClock.default.tempo = ~t; // real
//~t = 145/4/60; TempoClock.default.tempo = ~t;

FileSystemProject.loadOnce("sndlib/synthaccu.scd");
FileSystemProject.loadOnce("holis/synthdef.scd");
FileSystemProject.loadOnce("capsule/lib.scd");
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
~swing = (1 + (1/6 * Pseq([1,-1],inf)));
)

(
SynthDef(\chordnoise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.02,11],[0.1,0.8]), 1);
	sig = LFPulse.ar(freq * LFNoise1.ar(freq * \fmr.kr(1/2) * env1,mul:\fmamp.kr(0.01) * env1,add:1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// original
// bass: standard
~swing = (1 + (1/6 * Pseq([1,-1],inf)));
Pdef(\part, Pdef(\rdub_bass, 
	Ppar([
		///// drums
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\dur, 1/8 * ~swing,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
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
				\dur, 1/8 * ~swing,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\dur, ( 1/8 * ~swing ),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
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

		///// snare+hat
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 1,0,0,1,
				],inf).coin.not,
				\sustain, 0.051,
				\gain, 0.1,
				\dur, 1/8,
				\dur, 1/8 * ~swing,
				\out, BusDef(\rimbus, \audio),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1, 1,0,
					1,1, 0,0,
					1,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\dur, ( 1/8 * ~swing ),
				\amp, 0.015 * Pseq([1,0.7],inf),
				\out, BusDef(\rimbus, \audio),
			),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\rimbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.05714285714286,
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
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\rimbus, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.05714285714286,
			'gain', 1.0344889782792,
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

		///// chords

		PmonoArtic(\tredrone,
			\legato, 1,
			\cus3, { rrand(0.01,10) }.dup(3),
			\fma, 0.001,
			\cus2, 10,
			\cusfreq, 1,
			\lpfr, 2,
			\lagf, Pseq([1,0,0,1]/8,inf).stutter(8),
			\lagf, 0,
			\note, Pseq([
				0, 0, 1, -1, 0, 1, 0, 0,
				0, -12, -12, 0, 0, -1, -1, 0,
				0, 0, 1, -1, 0, 1, 0, 0,
				1, 1, 1, -2, 1, 1, -2, 1,
			],inf),
			\octave, 7,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\chordbus, \audio),
		),
		Pmono(\kr_amplitude,
			\inbus, BusDef(\sendbus1),
			\out, BusDef(\ampkr, \control),
			//\ampbias, 100.000000001,
			\ampscale, 0,
			\ampscale, 0.05,
			\amplag, 0.05102,
			//\clipmin, 20,
			//\clipmax, 19900,
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\chordbus, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			\mix, 1,
			'gain', 0.2344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.200000543560101,
			\delay, BusDef(\ampkr, \control).asMap,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			//\postlpf, BusDef(\ampkr, \control).asMap,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\modgain, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,

				1,1,1,1, 1,1,1,1,
				1,1,1,0, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,

				1,1,1,0, 1,1,1,1,
				1,1,1,0, 1,1,0,1,
				1,0,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\dur, 1/8,
		),

		///// bass

		Pbind(
			\out, BusDef(\chord2bus, \audio),
			\instrument, \chordnoise,
			\note, Pseq([
				0,0,-5,0,
				0,-1,0,0,
				0,-1,0,0,
				1,1,-2,1,
			],inf),
			\octave, 3,
			\legato, Pseq([
				3,0,0,0, 1,1,1,1,
				1,1,2,0, 2,0,1,1,
				3,0,0,0, 1,1,1,1,
				1,1,2,0, 1,2,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.001,
			\fmr, 1/10,
			\dur, 1/4,
			\amp, 0.1/3,
		),
		Pmono(\kr_amplitude,
			\inbus, BusDef(\sendbus1),
			\out, BusDef(\ampkr2, \control),
			//\ampbias, 100.000000001,
			//\ampbias, 0.08,
			//\indelay, 0.04,
			\ampscale, 0.0810005,
			\amplag, 0.001102,
			//\clipmin, 20,
			//\clipmax, 19900,
			\dur, 1,
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\chord2bus, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1,
			'gain', 1/4,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			\fb, BusDef(\ampkr2, \control).asMap,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\chord2bus2, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\chord2bus2, \audio),
			\lpf, 4000,
			\dur, 1,
		),
		
	])
)).play;
);

///// remix
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1137].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
					1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.13,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2251].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1690].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1363].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		
		Pbind(
			\instrument, \chordnoise,
			\note, Pseq([
				0,0,-5,0,
				0,-1,0,0,
				0,-1,0,0,
				1,1,-2,1,
			],inf),
			\octave, 3,
			\legato, Pseq([
				3,0,0,0, 1,1,1,1,
				1,1,2,0, 2,0,1,1,
				3,0,0,0, 1,1,1,1,
				1,1,2,0, 1,2,0,1,
			],inf)*0.7,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.001,
			\fmr, 1/10,
			\dur, 1/4,
			\amp, 0.1/3,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\kr_amplitude,
			\inbus, BusDef(\sendbus1),
			\out, BusDef(\ampkr2, \control),
			//\ampbias, 100.000000001,
			//\ampbias, 0.08,
			//\indelay, 0.04,
			\ampscale, 0.0810005,
			\amplag, 0.001102,
			//\clipmin, 20,
			//\clipmax, 19900,
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kickbus, \audio),
			\cpt, 0.011,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\rdnroom1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\rdnroom1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1,
			'gain', 1/4,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00011001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			//\fb, BusDef(\ampkr2, \control).asMap,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\rdnroom2, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\rdnroom2, \audio),
			\lpf, 4000,
			\lpf, PmodEnv(Pseq([4000,100,10000],1), 8).loop,
			\gain, 0.25,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1137].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
					1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.13,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1928].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1928].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],14),
				0,0,0,0, 0,1,0,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, 0.4,
			\dur, 1/8/2,
			\gain, 0.02,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1690].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1363].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),4).loop / Pkey(\st),
			\pos, Pseq([
				Pseq([
					(0..7)/4,
					Pser([
						[ 0,1,2,3,0,1,2,3,4,5,4, ]/4
					].flat,16),
					Pser([
						[ 0,1,2,4,0,1,2,3,4,5,4, ]/4+2 + 0.01,
					].flat,8),
					(0..7)/4 + 6 + 0.02,
					//(0..15)/8+6,
					
				].flat,1),
			],inf) / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,1, 1,0,1,0,
				1,1,0,1, 1,0,1,1,
				//1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/13,
		),
		
		Pbind(
			\instrument, \chordnoise,
			\note, Pseq([
				0,0,-5,0,
				0,-1,0,0,
				0,-1,0,0,
				1,1,-2,1,
			],inf),
			\octave, 3,
			\legato, Pseq([
				3,0,0,0, 1,1,1,1,
				1,1,2,0, 2,0,1,1,
				3,0,0,0, 1,1,1,1,
				1,1,2,0, 1,2,0,1,
			],inf)*0.7,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.001,
			\fmr, 1/10,
			\dur, 1/4,
			\amp, 0.1/3,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\kr_amplitude,
			\inbus, BusDef(\sendbus1),
			\out, BusDef(\ampkr2, \control),
			//\ampbias, 100.000000001,
			//\ampbias, 0.08,
			//\indelay, 0.04,
			\ampscale, 0.0810005,
			\amplag, 0.001102,
			//\clipmin, 20,
			//\clipmax, 19900,
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kickbus, \audio),
			\cpt, 0.011,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\rdnroom1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\rdnroom1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1,
			'gain', 1/4,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00011001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			//\fb, BusDef(\ampkr2, \control).asMap,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\rdnroom2, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\rdnroom2, \audio),
			\lpf, 4000,
			\lpf, PmodEnv(Pseq([4000,100,10000],1), 8).loop,
			\gain, 0.25,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1137].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
					1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.13,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1928].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1928].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],14),
				0,0,0,0, 0,1,0,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, 0.4,
			\dur, 1/8/2,
			\gain, 0.02,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1690].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1363].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),4).loop / Pkey(\st),
			\pos, Pseq([
				Pseq([
					(0..7)/4,
					Pser([
						[ 0,1,2,3,0,1,2,3,4,5,4, ]/4
					].flat,16),
					Pser([
						[ 0,1,2,4,0,1,2,3,4,5,4, ]/4+2 + 0.01,
					].flat,8),
					(0..7)/4 + 6 + 0.02,
					//(0..15)/8+6,
					
				].flat,1),
			],inf) / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,1, 1,0,1,0,
				1,1,0,1, 1,0,1,1,
				//1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/13,
		),
		
		Pbind( // bass
			\instrument, \chordnoise,
			\note, Pseq([
				0,0,-5,0,
				0,-1,0,0,
				0,-1,0,0,
				1,1,-2,1,
			],inf),
			\octave, 3,
			\legato, Pseq([
				3,0,0,0, 1,1,1,1,
				1,1,2,0, 2,0,1,1,
				3,0,0,0, 1,1,1,1,
				1,1,2,0, 1,2,0,1,
			],inf)*0.7,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.001,
			\fmr, 1/10,
			\dur, 1/4,
			\amp, 0.1/3,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\kr_amplitude,
			\inbus, BusDef(\sendbus1),
			\out, BusDef(\ampkr2, \control),
			//\ampbias, 100.000000001,
			//\ampbias, 0.08,
			//\indelay, 0.04,
			\ampscale, 0.0810005,
			\amplag, 0.001102,
			//\clipmin, 20,
			//\clipmax, 19900,
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kickbus, \audio),
			\cpt, 0.011,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\rdnroom1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\rdnroom1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1,
			'gain', 1/4,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00011001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			//\fb, BusDef(\ampkr2, \control).asMap,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\rdnroom2, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\rdnroom2, \audio),
			\lpf, 4000,
			\lpf, PmodEnv(Pseq([4000,100,10000],1), 8).loop,
			\gain, 0.30,
			\dur, 1,
		),

		// treb

		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					\r,
				],3),
				Pser([
					0,1
				],3),
				Pser([
					-4,-5
				],4),
				Pser([
					-7,-8
				],4),
				Pser([
					-11,-12
				],2),
			],inf).stutter(2),
			\octave, 6,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,0,1,
				1,1,0,1, 1,0,
			],inf).coin.not,
			\lpf, PmodEnv(Pseq([600,1000,8000],1), 8).loop,
			\dur, 1/8/2,
			\amp, 0.081,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1137].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
					1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.13,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1928].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1928].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],14),
				0,0,0,0, 0,1,0,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, 0.4,
			\dur, 1/8/2,
			\gain, 0.02,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1690].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1363].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),4).loop / Pkey(\st),
			\pos, Pseq([
				Pseq([
					(0..7)/4,
					Pser([
						[ 0,1,2,3,0,1,2,3,4,5,4, ]/4
					].flat,16),
					Pser([
						[ 0,1,2,4,0,1,2,3,4,5,4, ]/4+2 + 0.01,
					].flat,8),
					(0..7)/4 + 6 + 0.02,
					//(0..15)/8+6,
					
				].flat,1),
			],inf) / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,1, 1,0,1,0,
				1,1,0,1, 1,0,1,1,
				//1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/13,
		),
		
		Pbind( // bass
			\instrument, \chordnoise,
			\note, Pseq([
				0,0,-5,0,
				0,-1,0,0,
				0,-1,0,0,
				1,1,-2,1,
			],inf),
			\octave, 3,
			\legato, Pseq([
				3,0,0,0, 1,1,1,1,
				1,1,2,0, 2,0,1,1,
				3,0,0,0, 1,1,1,1,
				1,1,2,0, 1,2,0,1,
			],inf)*0.7,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.001,
			\fmr, 1/10,
			\dur, 1/4,
			\amp, 0.1/3,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\kr_amplitude,
			\inbus, BusDef(\sendbus1),
			\out, BusDef(\ampkr2, \control),
			//\ampbias, 100.000000001,
			//\ampbias, 0.08,
			//\indelay, 0.04,
			\ampscale, 0.0810005,
			\amplag, 0.001102,
			//\clipmin, 20,
			//\clipmax, 19900,
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kickbus, \audio),
			\cpt, 0.011,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\rdnroom1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\rdnroom1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1,
			'gain', 1/4,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00011001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			//\fb, BusDef(\ampkr2, \control).asMap,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\rdnroom2, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\rdnroom2, \audio),
			\lpf, 4000,
			\lpf, PmodEnv(Pseq([4000,100,10000],1), 8).loop,
			\gain, 0.30,
			\dur, 1,
		),

		// treb

		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					-4,-1,0,
				],16),
			],inf).stutter(2),
			\octave, Pseq([
				Pser([
					5
				],16*8),
				Pser([
					5,5,
					6,6,
				],16*8),
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,0,1, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,0,1, 
			],inf).coin.not,
			\lpf, PmodEnv(Pseq([300,700,1000],1), 8).loop,
			\envamt, PmodEnv(Pseq([1,4,8],1), 8).loop,
			\rq, 0.4,
			\dur, 1/8/2,
			\amp, 0.081,
			\out, BusDef(\sh1, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\sh1, \audio),
			\addAction, \addToTail,
			\hpf, 1000,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
// nap
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1137].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
					1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.13,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1928].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1928].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],14),
				0,0,0,0, 0,1,0,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, 0.4,
			\dur, 1/8/2,
			\gain, 0.02,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1690].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1363].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),4).loop / Pkey(\st),
			\pos, Pseq([
				Pseq([
					(0..7)/4,
					Pser([
						[ 0,1,2,3,0,1,2,3,4,5,4, ]/4
					].flat,16),
					Pser([
						[ 0,1,2,4,0,1,2,3,4,5,4, ]/4+2 + 0.01,
					].flat,8),
					(0..7)/4 + 6 + 0.02,
					//(0..15)/8+6,
					
				].flat,1),
			],inf) / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,1,1,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,1,0,
				1,1,0,1, 1,0,1,1,
				//1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/13,
		),
		
		Pbind( // bass
			\instrument, \chordnoise,
			\note, Pseq([
				0,0,-5,0,
				0,-1,0,0,
				0,-1,0,0,
				1,1,-2,1,
			],inf),
			\octave, 3,
			\legato, Pseq([
				3,0,0,0, 1,1,1,1,
				1,1,2,0, 2,0,1,1,
				3,0,0,0, 1,1,1,1,
				1,1,2,0, 1,2,0,1,
			],inf)*0.7,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.001,
			\fmr, 1/10,
			\dur, 1/4,
			\amp, 0.1/3,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\kr_amplitude,
			\inbus, BusDef(\sendbus1),
			\out, BusDef(\ampkr2, \control),
			//\ampbias, 100.000000001,
			//\ampbias, 0.08,
			//\indelay, 0.04,
			\ampscale, 0.0810005,
			\amplag, 0.001102,
			//\clipmin, 20,
			//\clipmax, 19900,
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kickbus, \audio),
			\cpt, 0.011,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\rdnroom1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\rdnroom1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1,
			'gain', 1/4,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00011001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			//\fb, BusDef(\ampkr2, \control).asMap,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\rdnroom2, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\rdnroom2, \audio),
			\lpf, 4000,
			\lpf, PmodEnv(Pseq([4000,100,10000],1), 8).loop,
			\gain, 0.30,
			\dur, 1,
		),

		// treb

		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				Pser([
					[0,-5],
					[0,-5],
					[0,-5],
					[1,-4],
				],16),
			],inf).stutter(2),
			\octave, Pseq([
				Pser([
					6
				],16*8),
			],inf),
			\legato, Pseq([
				1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\envamt, PmodEnv(Pseq([1,4,8],1), 8).loop,
			\rq, 0.6,
			\dur, 1/2,
			\amp, 0.081,
			\out, BusDef(\sh1, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\sh1, \audio),
			\addAction, \addToTail,
			\hpf, 500,
			\lag, 0.0009,
			\mix, 0,
			\dur, 1,
		),
	])
)).play;
);

///////////////
// try various bass

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1137].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
					1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.13,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1928].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1928].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],14),
				0,0,0,0, 0,1,0,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, 0.4,
			\dur, 1/8/2,
			\gain, 0.02,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1690].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1363].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),4).loop / Pkey(\st),
			\pos, Pseq([
				Pseq([
					(0..7)/4,
					Pser([
						[ 0,1,2,3,0,1,2,3,4,5,4, ]/4
					].flat,16),
					Pser([
						[ 0,1,2,4,0,1,2,3,4,5,4, ]/4+2 + 0.01,
					].flat,8),
					(0..7)/4 + 6 + 0.02,
					//(0..15)/8+6,
					
				].flat,1),
			],inf) / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				//1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/13,
		),
		
		Pbind( // bass
			\instrument, \chordnoise,
			\note, Pseq([
				Pser([
					0,7,
				],8),
				//0,0,-5,0,
				//0,-1,0,0,
				//0,-1,0,0,
				//1,1,-2,1,
			],inf) + Pseq([
				0,-5,1,-2
			],inf).stutter(4),
			\octave, 3,
			\legato, Pseq([
				1
			],inf)*0.7,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.001,
			\fmr, 1/10,
			\dur, 1/8,
			\amp, 0.1/3,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\kr_amplitude,
			\inbus, BusDef(\sendbus1),
			\out, BusDef(\ampkr2, \control),
			//\ampbias, 100.000000001,
			//\ampbias, 0.08,
			//\indelay, 0.04,
			\ampscale, 0.0810005,
			\amplag, 0.001102,
			//\clipmin, 20,
			//\clipmax, 19900,
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kickbus, \audio),
			\cpt, 0.011,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\rdnroom1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\rdnroom1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1,
			'gain', 1/4,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00011001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			//\fb, BusDef(\ampkr2, \control).asMap,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\rdnroom2, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\rdnroom2, \audio),
			\lpf, 4000,
			\lpf, PmodEnv(Pseq([4000,100,10000],1), 8).loop,
			\gain, 0.30,
			\dur, 1,
		),

	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1137].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
					1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.13,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1928].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1928].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],14),
				0,0,0,0, 0,1,0,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, 0.4,
			\dur, 1/8/2,
			\gain, 0.02,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1690].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1363].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),4).loop / Pkey(\st),
			\pos, Pseq([
				Pseq([
					(0..7)/4,
					Pser([
						[ 0,1,2,3,0,1,2,3,4,5,4, ]/4
					].flat,16),
					Pser([
						[ 0,1,2,4,0,1,2,3,4,5,4, ]/4+2 + 0.01,
					].flat,8),
					(0..7)/4 + 6 + 0.02,
					//(0..15)/8+6,
					
				].flat,1),
			],inf) / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				//1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/13,
		),
		
		Pbind( // bass
			\instrument, \chordnoise,
			\note, Pseq([
				Pser([
					0,
				],8),
				//0,0,-5,0,
				//0,-1,0,0,
				//0,-1,0,0,
				//1,1,-2,1,
			],inf) + Pseq([
				0,-5,1,-2
			],inf).stutter(8*4),
			\octave, 3,
			\legato, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf)*0.7,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.2,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.011,
			\fmr, 1/2,
			\dur, 1/8/2,
			\amp, 0.1/3,
			\out, BusDef(\basstrack, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,
				],8),
				//0,0,-5,0,
				//0,-1,0,0,
				//0,-1,0,0,
				//1,1,-2,1,
			],inf) + Pseq([
				0,-5,1,-2
			],inf).stutter(8*4),
			\lag, -0.02,
			\legato, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf)*0.7,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.2,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8/2,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\kr_amplitude,
			\inbus, BusDef(\sendbus1),
			\out, BusDef(\ampkr2, \control),
			//\ampbias, 100.000000001,
			//\ampbias, 0.08,
			//\indelay, 0.04,
			\ampscale, 0.0810005,
			\amplag, 0.001102,
			//\clipmin, 20,
			//\clipmax, 19900,
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kickbus, \audio),
			\cpt, 0.011,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.03,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\rdnroom2, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\rdnroom1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1,
			'gain', 1/4,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00011001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			//\fb, BusDef(\ampkr2, \control).asMap,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\rdnroom2, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\rdnroom2, \audio),
			\lpf, 4000,
			\lpf, PmodEnv(Pseq([4000,100,10000],1), 8).loop,
			\gain, 0.30,
			\gain, 0.5,
			\dur, 1,
		),

	])
)).play;
);


/////////////
// sdesign son aggressifs, puis filtrage pour faire une nappe


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \noisybassfe,
			\note, Pstep(Pseq([
				0,12,0,7,
			],inf),1/4),
			\note, Pseq([
				[
				0,12,0,7,
				]
			],inf)+ Pseq([
				0,5,4,2,
			],inf).stutter(4*4),
			\strum, 0.01,

			\octave, 5,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.3,0.1,0.8,0.1) ],
			],inf),
			\lpf, 2600 * Pseq([1,2,3],inf),
			\hpf, 100,
			\dur, Pseq([
				1/8/2,
			],inf) * Pseq([0.2,0.3,0.3,0.2]*4,inf),
			\amp, 0.1/2,
			\out, BusDef(\fxpad, \audio),
		),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\fxpad, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
SynthDef(\noisybassfe, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lpenv, lpfreq;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,0.8]), \trigx.tr(1));
	env2 = EnvGen.kr(Env([0,0,1,0],[0.01,0.2,1.4]), \trigx.tr(1));
	env3 = EnvGen.kr(Env([1,1,0,0],[0.01,0.4,1.8]), \trigx.tr(1));
	sig = Pulse.ar(freq * [1,1.0001]);
	//sig = sig * ( SinOsc.ar(freq) + 1  );
	sig1 = ( SinOsc.ar(freq) + 1  );
	sig1 = SelectX.ar(env2, [DC.ar(1), sig1]);
	sig = sig * sig1;
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));

	sig1 = SinOsc.ar(2*~t).exprange(0.1,1);
	sig1 = SelectX.ar(env2, [DC.ar(1), sig1]);
	//sig = [sig, sig1].sum;
	//sig = sig/4 + LPF.ar(sig.fold2( sig1 ), 10000);

	sig = HPF.ar(sig, \hpf.kr(10));

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \oscsampler3,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 1.608,
			\note, Pseq([
				[0,4,7],
			],inf),
			\note, Pseq([
				Pser([
					[0,-5],
					[0,-5],
					[0,-5],
					[1,-4],
				],16),
			],inf).stutter(8),
			\strum, 0.1,
			\octave, 6,
			\range, 0.00001,
			\posenv, Pseq([
				[ Env([0.00,0.00011001,0.01].integrate.postln,[0.41,8.1]) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.7,0.1,0.8,0.7) ],
			],inf),
			\finepos, 1/400,
			\legato, Pseq([
				1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4 * Pseq([1/3,2/3],inf),
			\fshift, 0,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 1,
			\hpfreq, 700,
			\ffreq, Pseq([
				8240,
			],inf).stutter(2),
			\amp, 0.1,

		) 
	])
)).play;
);

// try with delay

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \oscsampler3,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 1.608,
			\note, Pseq([
				[0,4,7],
			],inf),
			\note, Pseq([
				Pser([
					[0,-5],
					[0,-5],
					[0,-5],
					[1,-4],
				],16),
			],inf).stutter(8),
			\strum, 0.1,
			\octave, 6,
			\range, 0.00001,
			\posenv, Pseq([
				[ Env([0.00,0.00011001,0.01].integrate.postln,[0.41,8.1]) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.7,0.1,0.8,0.7) ],
			],inf),
			\finepos, 1/400,
			\legato, Pseq([
				1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\fshift, 0,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 1,
			\hpfreq, 700,
			\ffreq, Pseq([
				8240,
			],inf).stutter(2),
			\amp, 0.1,
			\out, BusDef(\delay, \audio),

		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\delay, \audio),
			\delay, 1/8/~t,
			\diffadd, 0.1,
			\decay, 4/~t,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);
