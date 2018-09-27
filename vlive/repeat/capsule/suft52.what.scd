
// scientist - beam down

~t = 142/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\aigu, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
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
SynthDef(\organ, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = Pulse.ar(freq * [1,1.0001, 2/3],mul: [1,1,1/3]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\dubecho,{|delay = 1, fb = 0.8, sep = 0.012|
	var input = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 

	var output;
	
	input = SelectX.ar(\inmix.kr(0.5), [DC.ar(0), input]);
	output = input + Fb({

		arg feedback; // this will contain the delayed output from the Fb unit

		var left,right;
		var magic = LeakDC.ar(feedback*fb + input);
		magic = HPF.ar(magic, 400); // filter's on the feedback path
		magic = LPF.ar(magic, 5000);
		magic = magic.tanh; // and some more non-linearity in the form of distortion
		#left, right = magic; // let's have named variables for the left and right channels
		magic = [DelayC.ar(left, 1, LFNoise2.ar(12).range(0,sep)), DelayC.ar(right, 1, LFNoise2.ar(12).range(sep,0))]; // In addition to the main delay handled by the feedback quark, this adds separately modulated delays to the left and right channels, which with a small "sep" value creates a bit of spatialization

	},delay);
	output = SelectX.ar(\mix.kr(0.5), [input, output]);
	Out.ar(0, output);
}).store;
);

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
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf).stutter(12),
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
				\postgain, 0,
				\delay, 0,
				\send0, 0.1,
				\sendbus0, BusDef(\sendbus2, \audio, 2),
				\send1, 1,
				\sendbus1, BusDef(\fx1, \audio, 2),
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
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				Pser([
					4,0,0, 
				],12*2),
			],inf),
			\lpf, 302,
			\legato, Pseq([

					Pseq([
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						
					],3),

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
			'delay2', 0.000000543560101,
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
				'gain', 0.9344889782792,
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
				\room, Pwhite(0.01,0.05),
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
					0,0,0, 0,0,0,  1,1,1, 1,1,1,
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
					0,0,0, 0,0,0,  0,1,1, 1,1,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\speed, 1.2,
				\dur, 1/12,
				\gain, 0.2 * Pseq([
					1,
				],inf) * Pseq([
					1,1,
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
				\isRest, true,
			),
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\tmix0),
				\pregain, 1,
				\postgain, 0,
				\delay, 0,
				\send0, 0.1,
				\sendbus0, BusDef(\sendbus2, \audio, 2),
				\send1, 1,
				\sendbus1, BusDef(\fx1, \audio, 2),
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
				\isRest, true,
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
			\mix, 0,
			\inmix, 1,
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
			\isRest, true,
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
			\dur, 1/16,
			\pan, 0.3 * Pwhite(-1,1).stutter(9),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 1,1,0,0,
			],inf).coin.not,
			\amp, 0.1 * Pwhite(0.05,0.1).stutter(13),
			\out, BusDef(\sendbus2, \audio),
		),
			Pbind(
				\instrument, \long,
				\note, Pseq([
					4,
				],inf),
				\octave, 7,
				\legato, Pseq([
					0,0,0, 0,0,0,
				  	0,0,0, 0,0,0,
					0,0,1/4, 3*3,0,0,  
					0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\lag, 0.04,
				\dur, 1/12,
				\amp, 0.1,
			),
	])
)).play;
)


(
SynthDef(\long, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.01,0.8]), 1);
	sig = LFSaw.ar(freq * [1,2, 3,4,8]/2 * ( SinOsc.ar(freq * [1,3/4,5/4] * [ [1,1.01] ]) * 0.1 *env1 + 1 )).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * env1, \rq.kr(0.5));
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * amp ;
	Out.ar(out, sig);
}).add;
);


(
SynthDef(\long, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
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
	//sig = RLPF.ar(sig, env2 * 1000, 0.5 / (1+ env2 ));
	sig = AllpassL.ar(sig, 0.4,0.01 * [1,0.6,0.7,1.1],4.5) + ( sig * 2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,5.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
)


///////////////////////////////////////


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				Pser([
					7,0,0, 
					0,0,0, 
					0,0,0, 
					0,0,0, 
				],12*2),
			],inf),
			\lpf, 302,
			\legato, Pseq([

					Pseq([
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						
					],3),

			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/12,
			\amp, 0.1,
				\lag, 0.04,
			//\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,0,  0,0,0, 0,0,0,
			],inf).coin.not,
				\lag, 0.04,
			\amp, 0.1,
		),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0,  1,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\dur, 1/12,
				\gain, 0.4 * Pseq([
					1,0.8,1,1,0.9,
				],inf),
				\lag, 0.04,
				//\out, BusDef(\sendbus2, \audio),
			)),
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
				//\out, BusDef(\fx1, \audio),
			)),
			Pbind(
				\instrument, \dubdrone,
				\note, Pseq([
					0,
				],inf),
				\octave, 3,
				\legato, Pseq([
					0,0,0, 0,0,0,
				  	0,0,0, 0,0,0,
					0,0,1/4, 3*3,0,0,  
					0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\lag, 0.04,
				\dur, 1/12,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \dubdrone3,
				\note, Pseq([
					4,
				],inf),
				\octave, 7,
				\legato, Pseq([
					0,0,0, 0,0,0,
				  	0,0,0, 6,0,0,
					0,0,0, 0,0,0,
					0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\lag, 0.04,
				\dur, 1/12,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \dubdrone4,
				\note, Pseq([
					4,
				],inf),
				\octave, 7,
				\legato, Pseq([
					0,0,0, 0,0,0, 0,0,4, 0,0,0,
					0,0,0, 0,0,0, 0,0,1/4, 2,0,0,
					0,0,0, 0,0,0, 0,3,0, 0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\lag, 0.04,
				\dur, 1/12,
				\amp, 0.1,
			),


			Pbind(
				\instrument, \conga,
				\harm1, Pseq([
					Pseq([[2.1,1], [1,1]]*3,12).stutter(1),
				],inf),
				\freq, 770,
				\amp, 0.03,
				\dur, 1/12,
				\lag, [0,0.03],
				\isRest, Pseq([
					Pser([
						//0,0,0, 0,0,0,  0,0,0, 0,0,0,  
						//0,0,0, 0,0,0,  0,0,0, 0,0,0,  
						0,0,0, 0,0,0,  0,0,1, 1,0,0,  
						1,0,1, 0,1,0,  0,0,1, 1,0,1,  
					],inf),
				],inf).coin.not,
				\out, BusDef(\sendbus1, \audio),
			),
			Pmono(\rdnroom,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 0.4,
				'gain', 1/8,
				'fb', 0.000000031,
				'delay', 0.00000001,
				'delay2', 0.00001001,
				'delay3', 0.0000080,
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
SynthDef(\dubdrone, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*1.123) * 1 ))) * LFSaw.ar(freq*4/3 * SinOsc.kr(1/12).range(1.1,1)) ;
	sig = RLPF.ar(sig, 3000 * LFNoise1.ar(1/13!4).range(1/4,4), \rq.kr(0.5) * LFNoise1.ar(1/13!4).range(1/4,2)).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\dubdrone2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*1).round(0.1) * 1 ))) * LFSaw.ar(freq*4/3 * SinOsc.kr(1/12).range(1.1,1)) ;
	sig = RLPF.ar(sig, 3000 * LFNoise1.ar(1/13!4).range(1/4,4), \rq.kr(0.5) * LFNoise1.ar(1/13!4).range(1/4,2)).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\dubdrone3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = Klank.ar(Ref([ exprand(20.0,10100!48!2), 0.001!8 ]), sig);
	//sig = sig * SinOsc.kr(4*~t).range(0,1);
	sig = sig * EnvGen.kr(\env.kr(Env([0,2,1,0],[0.01,0.8,0.01].normalizeSum)), Impulse.kr(4*1.5*~t), timeScale:1/8);
	//sig = sig  / 4;
	sig = sig * 15*2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,1.1,0.2,0.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig.debug("sig");
	Out.ar(out, sig);
}).add;

SynthDef(\dubdrone4, { arg out=0, gate=1, amp=0.5, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0,
						release=0.2;
						 
	var ou;
	var ou1, ou2;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;

	bufnum = BufDef.mono(\rocksteady, "vipere/rocksteady.flac");
	pitch_stretch = Duty.kr(1/8/~t, 0, Dseq([
		[0,4,7,12],
		[0,4,7,10],
		[0,7,10,-12],
		[0,3,7,10],
	].midiratio,inf));
	time_stretch = 0;
	trate = 100;
	pos = SinOsc.kr(1/16*~t,pi).range(0,1) * 0.0004 * [1,1.1] + 0.3;
	//pos = EnvGen.ar(Env([0,0.4,0.2],[0.4,0.2]),LFPulse.kr(1/1*~t),doneAction:0);
	//pos = pos + EnvGen.ar(Env([0,0.2,0.4],[0.4,0.1]),LFPulse.kr(1*~t).poll,doneAction:0).poll;
	clk = Impulse.kr(trate);
	randclk = Impulse.kr(randrate * trate);
	dur = 0.1;
	pan = (WhiteNoise.kr(0.6) + pan).clip(-1,1);
	sr = SampleRate.ir;
	phasor = Phasor.ar(0, time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);

	pos = phasor * BufDur.kr(bufnum) + finepos ;
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	ou = Pan2.ar(ou, SinOsc.kr(1/48,[0,pi]).unipolar).flop;
	ou = [
		[300,350] * SinOsc.kr(1/8*~t).range(1,1.2),
		[1300,1350],
		[7300,7350],
	].collect { arg x, idx;
		ou1 = RHPF.ar(ou, x[0],0.3);
		ou2 = RLPF.ar(ou1, x[1],0.3);
		ou2 = ou2 * SinOsc.kr(1/(1+x)).unipolar;
		ou2;
	};
	ou = ou /8;
	ou = Splay.ar(ou, 1, amp);
	ou = ou * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, ou);
}).add;
SynthDef(\conga, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3, sig4, sig5;
	sig1 = LFTri.ar(111);
	sig1 = FreqShift.ar(sig1, 175);
	sig1 = sig1 + FreqShift.ar(sig1, [224 * \harm2.kr(1),224 * \harm1.kr(1)]);
	sig1 = sig1 * EnvGen.ar(Env.perc(0.0001,0.22), gate);

	sig2 = SinOsc.ar(330) + SinOsc.ar(180);
	sig2 = sig2 * EnvGen.ar(Env.perc(0.0001,0.151), gate);

	sig3 = PinkNoise.ar(1);
	sig3 = BRF.ar(sig3, [100,800,300,400]*2).sum;
	sig3 = LPF.ar(sig3, [5000,6000,100,10000]*1);
	sig3 = sig3 * EnvGen.ar(Env.perc(0.0001,0.201, 1, \sqr), gate);

	sig4 = WhiteNoise.ar(1);
	sig4 = BRF.ar(sig4, [100,900,300,400]*4).sum;
	sig4 = LPF.ar(sig4, [500,4000,100,1000]*2*XLine.kr(1,0.100,0.01));
	sig4 = sig4 * EnvGen.ar(Env.perc(0.0001,0.251, 1, \cub), gate);

	sig5 = PinkNoise.ar(1) * sig2;
	//sig5 = BRF.ar(sig5, [100,800,300,400]*2).sum;
	sig5 = LPF.ar(sig5, [500,600,100,1000]*0.21);
	sig5 = sig5 * EnvGen.ar(Env.perc(0.0001,0.111, 1, \sqr), gate) * 4;

	sig = sig1 + sig3 + sig4 + sig5;
	//sig = (HPF.ar(sig,100)*14).distort + LPF.ar(sig, 100);
	sig = sig * 2;




	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.0001,0.1,0.8,2.4)),gate,doneAction:doneAction);
	//sig = DetectSilence.ar(sig, doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

////////////////:
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				Pser([
					7,0,0, 
					0,0,0, 
					0,0,0, 
					0,0,0, 
				],12*2),
			],inf),
			\lpf, 302,
			\legato, Pseq([

					Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						
					],3),

			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/12,
			\amp, 0.1,
				\lag, 0.04,
			//\out, BusDef(\sendbus1, \audio),
		),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0,  1,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\dur, 1/12,
				\gain, 0.4 * Pseq([
					1,0.8,1,1,0.9,
				],inf),
				//\lag, 0.04,
				//\out, BusDef(\sendbus2, \audio),
					\out, BusDef(\sendbus1, \audio),
			)),
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
				//\out, BusDef(\fx1, \audio),
			)),
				Pbind(
					\instrument, \simplebass,
					\degree, Pseq([0,2b,4,-4],inf),
					\legato, Pseq([
						Pseq([ 1,1,1,1, ],3),
						Pseq([ 1,1,1,1, ]/4,1),

					],inf),
					\lpf, ~pmodenv.(Pseq([400,200,1000,4000],inf), 4),
					\legato, Pseq([
						10,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\rq, 0.1,
					\octave, 3,
					\dur, 1/12,
					\amp, 0.1,
					\out, BusDef(\sendbus1, \audio),
				),
			Pbind(
				\instrument, \conga,
				\harm1, Pseq([
					Pseq([[2.1,1], [1,1]]*1,12).stutter(1),
				],inf),
				\freq, 70,
				\amp, 0.03,
				\dur, 1/12,
				\lag, [0,0.03],
				\isRest, Pseq([
					Pser([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,1,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 1,0,0,  0,0,1, 0,1,1,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 1,1,1,

						0,0,0, 0,0,0,  0,0,0, 0,1,0,
						1,0,1, 0,1,0,  0,0,0, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 1,0,1,
					],inf),
				],inf).coin.not,
				\out, BusDef(\sendbus1, \audio),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,1, 0,0,1,
					0,0,1, 1,0,0,  0,0,1, 1,0,1,
				],inf).coin.not,
				\sustain, 0.1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				\gain, 0.2,
				\dur, 1/12,
				\lag, 0.04,
				\isRest, true,
			)),
			Pmono(\rdnroom,
				\addAction, \addToTail,
				\lag, 0.0005,
				\freq, 200,
				\dur, 1/4,
				\amp, 0.1,
				\inbus, BusDef(\sendbus1, \audio),
				'wet10', 1.0,
				'mix', 0.01,
				'gain', 2/1,
				'fb', 0.0000111,
				'delay3', Pseq([
					0.1000001,
				],inf),
				'delay2', 0.000072394574653723,
				'delay', 0.2000072394574653723,
				'distamp', Pseq([
					Pseq([ 0.43886430789846, ],4*4),
				],inf),
				'distamp3', 0.6985772146511,
				'shift', -70.0001,
				'shiftmix', 0.0,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'stereo', 100.0,
				'fbdistamp', 0.9234346672443,
				'fbdistmix', 0.91176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				'brfrqfac', 0.37940593233798,
				'brffac', 0.60195390291997,
			),
			Pbind(
				\instrument, \iron,
				\note, Pseq([
					Pser([
						0,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, -12,0,0, 0,0,0, 0,0,0,
					],12+6),
					Pn(\rest,6),
				],inf),
				\octave, Prand([
					4,4,5,5,
					5,6,5,5,5,5,4,
				],inf),
				\lpfr, Pseg(Pseq([2,1/2],inf),1),
				\lpfr, 8,
				\hpf, 3000,
				\diff, 0.001,
				\env1, Pseq([
					[ Env(2.01-[2,1/2,1],[0.1,0.1]) ],
					[ Env(2.01-[2,1/2,1],[0.1,0.1]) ],
					[ Env(2.01-[2,1/2,1],[0.1,0.08]) ],
					[ Env(2.01-[2,1/2,1],[0.1,0.08]) ],
					[ Env(2.01-[2,1/2,1],[0.2,0.08]) ],
					[ Env(2.01-[2,1/2,1],[0.2,0.08]) ],
					[ Env(2.01-[2,1/2,1],[0.1,0.08]) ],
					[ Env(2.01-[2,1/2,1],[0.1,0.08]) ],
					[ Env(2.01-[2,1/2,1],[0.2,0.08]) ],
					[ Env(2.01-[2,1/2,1],[0.02,0.08]) ],
					[ Env(2.01-[2,1/2,1],[0.2,0.08]) ],
					[ Env(2.01-[1,2,1],[0.2,0.08]) ],
				],inf).stutter(12),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				\fmr, 2,
				\rq, 0.1,
				\dur, 1/12,
				\amp, 0.1 * Pseq([
					1,0.4,0.4,
					0.4,0.4,0.4,
					1,0.4,0.4,
					0.4,0.9,0.4,
					1,0.4,0.4,

				],inf),
				\out, BusDef(\bus2, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\bus2, \audio, 2),
				\addAction, \addToTail,
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
				\dur, 1,
			),
		
	])
)).play;
)


(
Ndef(\zigzag, { arg freq=800, pan=0, amp=0.1, fspread=0.0001;
	var sig;
	freq = Pulse.ar(6*~t).range(freq,freq * 3/8);
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * ( SinOsc.ar( freq * 2 ) * 0.1 + 1 ));
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);


/////////////////////



(
Pdef(\part, Pdef(\zed, 
	Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0,  1,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\dur, 1/12,
				\gain, 0.4 * Pseq([
					1,0.8,1,1,0.9,
				],inf),
				\lag, 0.04,
				//\out, BusDef(\sendbus2, \audio),
			)),
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
				//\out, BusDef(\fx1, \audio),
			)),

			///////

			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 1,0,0.4,  1,0.5,0.51, 1,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\dur, 1/12,
				\gain, 0.4 * Pseq([
					1,0.8,1,1,0.9,
				],inf),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
			)),
			Pmono(\rdnroom,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 1,
				'gain', 1/12,
				'fb', 0.000000031,
				'delay', 0.00000001,
				'delay2', 0.10001001,
				'delay3', 0.0000080,
				'distamp', 0.604,
				'distamp2', 0.23,
				'distamp3', 0.89,
				'shift', -5.0,
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			),
			
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,1, 0,0,0,  0,0,0, 1,0,0,
					0,0,1, 0,0,0,  0,0,0, 0,0,0,
					0,0,1, 1,0,0,  0,0,0, 0,0,0,
					0,0,1, 0,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.21) ],
				],inf),
				\speed,1,
				\gain, 0.3,
				\dur, 1/12,
				\gain, 0.4 * Pseq([
					1,0.8,1,1,0.9,
				],inf),
				//\lag, 0.04,
				\out, BusDef(\sendbus3, \audio),
			)),
			Pmono(\rdnroom,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				\lag, 0.0005,
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 1,
				'gain', 1/3,
				'fb', 0.000000031,
				'delay', 0.00000001,
				'delay2', 0.00001001,
				'delay3', 0.4000080,
				'delay3', ~pmodenv.(Pseq([Pn(0.001,7),0.4],inf), 1),
				'distamp', 0.304,
				'distamp2', 0.23,
				'distamp3', 0.39,
				'shift', -5.0,
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			),

			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,4,
				],inf).stutter(12*2),
				\legato, Pseq([
					8,0,0, 0,0,0,  0,0,0, 0,0,0,
					8,0,0, 0,0,0,  0,0,0, 1/2,0,0,
					8,0,0, 0,0,0,  0,0,0, 0,0,0,
					8,0,0, 0,0,0,  0,0,0, 0,0,1/2,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\sendbus5, \audio),
			),
			Pmono(\rdnroom,
				\inbus, BusDef(\sendbus5, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 0.01,
				'gain', 2,
				'fb', 0.000100031,
				'delay', 0.00000001,
				'delay2', 0.00001001,
				'delay3', 0.0000080,
				'distamp', 1.604,
				'distamp2', 0.23,
				'distamp3', 0.89,
				'shift', -5.0,
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			),


			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/12,
				\isRest, Pseq([
					1,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
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
				'shiftmix', 0.0,
				'stereo', 1.0,
				'indelay', 0.04,
			),

		Pbind(
			\instrument, \chordo,
			\note, Pseq([
				0,4,
			],inf),
			\sustain, 0.1,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		
	])
)).play;
)
