
// scientist - beam down

~t = 142/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				Pser([
					0,0,0, 
					3,0,0, 
				],12*2),
				Pser([
					4,0,0, 
				],12*2),
			],inf),
			\lpf, 302,
			\legato, Pseq([

					Pseq([
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 2,0,1,  2,0,1, 3,0,0,
						
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 2,0,0,  2,0,1, 3,0,0,
					],3),

					1,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,

					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,1, 0,0,1,  2,0,1, 1,0,1,

					2,0,0, 0,0,0,  0,0,0, 1,0,0,
					0,0,0, 2,0,0,  0,0,0, 3,0,0,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/12,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.110000543560101,
			'distamp', 0.361836201538,
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
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\isRest, true,
		),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0,  1,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\dur, 1/12,
				\gain, 0.4 * Pseq([
					1,0.8,1,1,0.9,
				],inf),
				\out, BusDef(\sendbus2, \audio),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,1,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,1, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,1, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					1,0,1, 0,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\dur, 1/12,
				\gain, 0.2 * Pseq([
					1,0.8,1,1,0.9,
				],inf),
				\out, BusDef(\fx1, \audio),
			)),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\out, BusDef(\sendbus2b, \audio),
				\addAction, \addToTail,
				\lag, 0.00005,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					Pwhite(0.1,100),
				],inf).stutter(1),
				'delay2', 0.000000543560101 * Pwhite(1.0,10000),
				'distamp', 31.361836201538,
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
				\inbus, BusDef(\sendbus2b),
				\room, Pwhite(0.01,1),
				\out, BusDef(\fx1, \audio),
				\dur, 1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					1,0,1, 1,0,0,  0,0,1, 1,0,0,
					1,0,1, 1,0,1,  0,0,1, 1,0,1,
				],inf).coin.not,
				\lag, 0.04,
				\sustain, 0.1,
				\dur, 1/12,
				\gain, 0.2 * Pseq([
					1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.9,
					1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.8, 1,0.7,0.2,
				],inf) * Pseq([
					1,1,Pwhite(0.01,0.5,1),
				],inf),
				\amp, 0.1,
				\lag, 0.04,
				\out, BusDef(\fx1, \audio),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\pos, 4.020,
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				   	0,0,0, 0,0,0, 0,0,0, 0,1,1, 
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				   	0,0,0, 0,0,0, 0,0,1, 0,0,1, 
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				   	0,0,0, 0,0,0, 0,0,0, 1,0,1, 
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\speed, 1.0,
				\dur, 1/12,
				\gain, 0.2 * Pseq([
					1
				],inf) * Pseq([
					1,1,1,
				],inf)*1,
				\lag, 0.04,
				\out, BusDef(\fx1, \audio),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\pos, 1.123,
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,1,1,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,1,1, 1,0,1,
					0,0,1, 1,1,1,  0,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\speed, 0.9,
				\dur, 1/12,
				\gain, 0.2 * Pseq([
					1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.9,
					1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.8, 1,0.7,0.2,
				],inf) * Pseq([
					1,1,Pwhite(0.01,0.5,1),
				],inf)*4,
				\lag, 0.04,
				\out, BusDef(\fx1, \audio),
			)),
			Pbind(
				\instrument, \organ,
				\out, BusDef(\fx1, \audio),
				\note, Pseq([
					Pser([
						[0,4,7-12]+12,
					],12*2),
					Pser([
						[4,8,11-12]+12,
					],12*2),
				],inf),
				\sustain, 0.04,
				\strum, 0.01 * Pseg(Pseq([0.01,1],inf),7),
				\isRest, Pseq([
					0,0,0, 1,0,0, 0,0,0, 1,0,0,
					0,0,0, 1,0,0, 0,0,0, 1,0,0,
					0,0,0, 1,0,0, 0,0,0, 1,0,0,
					0,0,0, 1,0,1, 0,1,0, 1,0,1,
					0,0,0, 1,0,0, 0,0,0, 1,0,0,
					0,1,0, 1,0,0, 0,0,0, 1,0,0,
				],inf).coin.not,
				\dur, 1/12,
				\amp, 0.1 * Pseq([
					1, 0.1, Pwhite(0.1,1,1),
				],inf),
				\out, BusDef(\tmix0, \audio),
			),
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\tmix0),
				\pregain, 1,
				\postgain, 1,
				\delay, 0,
				\send0, 0.1,
				\sendbus0, BusDef(\sendbus2, \audio, 2),
				\dur, 1,
			),
			Pbind(
				\instrument, \organ,
				\out, BusDef(\fx1, \audio),
				\note, Pseq([
					Pser([
						[0,4,7],
					],12*2),
					Pser([
						[5,9,12]-1,
					],12*2),
				],inf),
				\sustain, 0.01,
				\isRest, Pseq([
					0,0,1, 0,0,1, 0,0,1, 0,0,1,
					0,0,1, 0,0,0, 0,0,1, 0,0,0,
					0,0,1, 0,0,1, 0,0,1, 0,0,1,
					0,0,1, 0,0,1, 0,0,1, 0,0,1,
				],inf).coin.not,
				\dur, 1/12,
				\amp, 0.1 * Pseq([
					Pwhite(0.1,1)
				],inf),
			),
			Pbind(
				\instrument, \perctone,
				\note, Pseq([
					Pser([
						[0,4,7],
						[0,4,7],
						[0,4,7-12]+12,
						[0,4,7],
					],12*2),
					Pser([
						[5,9,0],
						[5,9,0],
						[5,9-12,0]+12,
						[5,9,0],
					],12*2),
				],inf),
				\sustain, Pseq([
					0.01, 0.01, 0.01, 0.03, 0.01, 0.01,
					0.01, 0.01, 0.01, 0.07, 0.01, 0.01,
				],inf),
				\out, BusDef(\fx1, \audio),
				\isRest, Pseq([

						0,0,0, 1,0,0,  0,0,0, 1,0,0,
						0,0,1, 0,0,0,  0,0,0, 1,0,0,
						0,0,1, 1,0,0,  0,0,0, 1,0,0,
						0,0,0, 1,0,1,  0,0,0, 1,0,0,
						1,0,1, 0,0,0,  0,0,0, 1,0,0,
						//0.1,0.1,0.1, 0.51,0,0.51,  0,0.1,0.1, 0.51,0,0.51,
				],inf).coin.not,
				\dur, 1/12,
				\octave, 6,
				\amp, 0.1,
				\isRest, true,
			),
		Pmono(\dubecho,
			\addAction, \addToTail,
			\lag, 0.0005,
			\delay, 3/4/~t,
			\sep, 0.0001,
			\inbus, BusDef(\fx1, \audio),
			\mix, ~pmodenv.(  Pseq([0,0,0,0,1,2,2,2,2,0,0,1,1,0,0],inf), 2),
			\inmix, ~pmodenv.(Pseq([1,1,1,1,0,0,0,0,0,1,1,1,1,1,1],inf), 2),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordo,
			\note, Pseq([
				0,4,
			],inf),
			\sustain, 0.1,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \aigu,
			\freq, Pseq([
				4700+Pwhite(-2420,100.0).stutter(12)
			],inf),
			\sustain, 0.011,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 0.05,
			\pan, 0.3 * Pwhite(-1,1).stutter(9),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\amp, 0.1 * Pwhite(0.05,0.1).stutter(13),
			\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
)

(
SynthDef(\chordo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.2,1],[0.1,0.8]), 1);
	env2 = SinOsc.ar(8/1.5*~t * ( SinOsc.kr(1*~t,Rand(0,2)) * 1 + 1 )).range(0.1,1);
	sig1 = SinOsc.ar(freq* [1,1.0001,1/2,1/4] * [0,4,7].midiratio/4)* EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig2 = SinOsc.ar(freq/2 * [1,2,1/2] * 4.midiratio).fold(env1) * 0.4;
	sig3 = LFSaw.ar(freq * [1,1.01,1.006,1/2,1/4] * 7.midiratio) * EnvGen.kr(Env([0,0.51,0],[1.1,2.8], 4), 1);
	sig3 = RLPF.ar(sig3, \lpfr.kr(2.1) * EnvGen.kr(Env([1,1/2,2,1],[2,2.1,2.8]), 1) * freq, \rq.kr(0.5));
	sig4 = SinOsc.ar(freq * [3/4,5/4]) * EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig5 = SinOsc.ar(freq+0.1 * [0+12,4,7,7-12,4-24].midiratio/2 * ( LFSaw.ar(freq/2) * 0.4 + 1 )) * EnvGen.kr(Env([0,0.41,0],[0.1,1.5]), 1);
	sig6 = SinOsc.ar(freq*1.001 * [1,1/2,2,1/8]  * ( SinOsc.ar(freq* [0+12,4,7,7-12].midiratio/2) * 1.4 + 1 )) * EnvGen.kr(Env([0,0,0.41,0],[0.3,0.8,6.5]), 1);
	sig6 = HPF.ar(sig6, 1000 * EnvGen.kr(Env([1,2,1],[4.1,0.8]), 1)) + BPF.ar(sig6, 70);
	sig = sig1 + sig2 + sig3 + sig4 + sig5 + sig6;
	sig = RLPF.ar(sig, env2 * 1000, 0.5 / (1+ env2 ));
	sig = AllpassL.ar(sig, 0.4,0.01 * [1,0.6,0.7,1.1],4.5) + ( sig * 2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,5.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);
