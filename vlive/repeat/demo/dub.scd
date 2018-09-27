

(
	SynthDef(\perctone, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		var pop, popFreq, popAmp;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var env1, env2, env3, env4, env5, env6, env7, env8;
		env1 = EnvGen.kr(Env([2,1,1/4],[0.13,0.04],-1), 1);
		sig = LFPulse.ar(freq) + LFSaw.ar(freq+[0,10.101*env1]).mean /2;
		sig = sig + SinOsc.ar(freq * [1,2,1/2], mul:env1.lag(1)).mean / 2; 
		sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * env1, \rq.kr(0.5));
		sig = ( sig * env1 ).distort;

		popFreq = XLine.kr(350, 61, 0.02);
		popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001)) * 0.15;
		pop = SinOsc.ar(popFreq) * popAmp;
		sig = sig + pop;

		sig1 = SinOsc.ar(freq*2);
		sig1 = LPF.ar(sig1, freq * EnvGen.kr(Env([1,1/2,1/4],[0.01,0.8]), 1));
		sig = sig + sig1;

		sig1 = WhiteNoise.ar;
		sig1 = LPF.ar(sig1, EnvGen.kr(Env([10000,710,100],[0.01,0.8], -4), 1));
		sig1 = HPF.ar(sig1, Rand(700,800.0));
		sig1 = Ringz.ar(sig1, freq, 0.1)/6;
		sig = sig + sig1;

		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.1)), gate, doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
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
)



~t = 71/2/60; TempoClock.default.tempo = ~t;
Pdef(\part).clear

(
Pdef(\part, Pdef(\plop, 
	Ppar([

		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				Pser([
					0,0,0, -5,0,0, 0,0,0, 0,0,4,
					0,0,-5, 0,0,0, 0,0,0, 0,0,4,
				],12*2),
				Pser([
					2,2,-3, 2,2,2, 2,2,5, 2,2,2,
				],12*2),
			],inf),
			\lpf, 302,
			\legato, Pseq([
					3,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,1, 2,0,1,  2,0,1, 3,0,0,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/12,
			\amp, 0.1,
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
				\out, BusDef(\fx1, \audio),
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
					0,0,0, 0,0,0,  0,0,1, 0,0,1,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
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
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0, 1,0,1, 0,0,0, 1,0,0,
					0,0,0, 1,0,1, 0,0,0, 1,0,1,
					1,1,0, 1,0,1, 0,0,0, 1,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/12,
				\gain, 0.2 * Pseq([
					1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.9,
					1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.8, 1,0.7,0.2,
				],inf),
				\out, BusDef(\fx1, \audio),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				// not convincing so muted
				\kitIndex, 9,
				\isRest, Pseq([
					1,0,0, 0,0,0, 1,0, 0,0, 1,0, 
					0,0,1, 1,0,1, 1,0, 0,0, 0,0, 
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/24,
				\gain, 0.2 * Pseq([
					1,1,1,
					1,0.2,0.2,
				],inf),
				\out, BusDef(\fx1, \audio),
				\isRest, true,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				// not convincing so muted
				\kitIndex, 9,
				\isRest, Pseq([
					1,0,1,0,
					1,1,0,1,
					1,0,1,0,
					1,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/16,
				\gain, 0.2 * Pseq([
					1,1,1, 0.2,
				],inf),
				\out, BusDef(\fx1, \audio),
				\isRest, true,
			)),
			Pbind(
				\instrument, \organ,
				\out, BusDef(\fx1, \audio),
				\note, Pseq([
					Pser([
						[0,4,7-12]+12,
					],12*2),
					Pser([
						[5,9,12-12]+12,
					],12*2),
				],inf),
				\sustain, 0.04,
				\isRest, Pseq([
					0,0,0, 1,0,0, 0,0,0, 1,0,0,
				],inf).coin.not,
				\dur, 1/12,
				\amp, 0.1 * Pseq([
					1
				],inf),
			),
			Pbind(
				\instrument, \organ,
				\out, BusDef(\fx1, \audio),
				\note, Pseq([
					Pser([
						[0,4,7],
					],12*2),
					Pser([
						[5,9,12],
					],12*2),
				],inf),
				\sustain, 0.01,
				\isRest, Pseq([
					0,0,1, 0,0,1, 0,0,1, 0,0,1,
				],inf).coin.not,
				\dur, 1/12,
				\amp, 0.1 * Pseq([
					1
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
			),
		Pmono(\dubecho,
			\delay, 3/4/~t,
			\sep, 0.0001,
			\inbus, BusDef(\fx1, \audio),
			\mix, ~pmodenv.(  Pseq([0,0,0,0,1,2,2,2,2,0,0,1,1,0,0],inf), 2),
			\inmix, ~pmodenv.(Pseq([1,1,1,1,0,0,0,0,0,1,1,1,1,1,1],inf), 2),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

3/4/~t

~t = 133/4/60; TempoClock.default.tempo = ~t; // meaning of life


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 0,0,0, 0,0,0, 0,0,1,
				0,0,1, 0,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,1, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,1,
				0,0,1, 0,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 0,0,1, 1,0,0, 1,0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 6,
			\isRest, Pseq([
				0,0,1,0,0,0, 0,0,0, 1,1,0,
				0,0,0,0,0,1, 0,0,0, 0,0,0,
				0,0,0,0,0,1, 0,0,1,0,1,1,
				0,0,0,0,0,1, 0,0,0, 0,0,0,

				0,0,1,0,0,0, 0,0,0, 0,0,0,
				0,0,1,0,0,0, 0,0,0, 1,1,0,
				0,0,0,0,0,0, 0,0,0, 0,0,0,
				0,0,0,0,0,0, 0,1,1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
					1,0,1, 1,0,1, 1,0,1, 1,0,1,
					1,1,0, 1,0,1, 1,0,1, 1,0,1,
					1,0,1, 1,0,1, 1,0,1, 1,0,1,
					1,1,0, 1,0,1, 1,0,1, 1,0,1,
					1,0,1, 1,0,1, 1,0,1, 1,0,1,
					1,1,0, 1,0,1, 1,0,1, 1,0,1,
					1,0,1, 1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,1,1, 1,0,0, 1,1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \phyhat4,
			\isRest, Pseq([
				Pseq([
					1,0,0,
				],4*7),
				Pseq([
					0,0,0,
				],4*1),
			],inf).coin.not,
			\sustain, 0.1,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.02 * Pseq([1,0.7],inf),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0,0,0, 1,0,0,0,0,0,
				0,0,0,0,0,0, 1,0,0,0,0,0,
				0,0,0,0,0,0, 1,0,0,0,0,1,
				0,0,1,0,0,0, 1,0,0,1,0,1,
				0,0,0,0,0,0, 1,0,0,0,0,0,
				0,0,0,0,0,0, 1,0,0,0,0,0,
				0,0,0,0,0,0, 1,0,0,0,0,1,
				0,0,1,0,0,1, 1,0,0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/12,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\instrument, \playersec_hlpf,
			\hpfmix, 1,
			\hpf, Pseq([
				1000,
				1000,
				100,
			],inf),
			\isRest, Pseq([
				0,0,0,1,0,0, 0,0,1,0,0,0,
				0,0,1,1,0,0, 1,0,0,1,0,1,
				0,0,0,1,0,0, 0,0,1,0,0,0,
				0,0,1,0,0,1, 0,0,1,1,0,1,
				0,0,0,1,0,0, 0,0,1,0,0,0,
				0,0,1,1,0,0, 1,0,0,1,0,1,
				0,0,0,1,0,0, 0,0,1,0,0,0,
				0,0,0,0,0,0, 0,0,0,1,0,1,
			],inf).coin.not,
			\sustain, 0.07,
			\speed, Pseq([
				1,0.99,
			],inf),
			\gain, 0.1 * Pseq([
				1,1,2, 1,1,2,  1,1,1, 2,1,2,
				
			],inf)/2,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \organ,
			//\out, BusDef(\fx1, \audio),
			\note, Pseq([
				Pser([
					[0,4,7-12],
					[0,4,7-12],
					[0,4,7-12],
					[0+12,4,7],
					[0,4,7-12],
					[0,4,7-12],
				],12*2),
				Pser([
					[0,0,0],
					[0,0,-12],
					[0,0,-12],
					[12,12,0],
					[0,0,-12],
					[0,0,0],
				],12*2)+[0,3,7]+9-12,
				Pser([
					[0,3,7-12],
					[0,3,7-12],
					[0,3,7-12],
					[0+12,3,7],
					[0,3,7-12],
					[0,3,7-12],
				],12*2)+2,
				Pser([
					[0,4,7-12],
					[0,4,7-12],
					[0,4,7-12],
					[0+12,4,7],
					[0,4,7-12],
					[0,4,7-12],
				],12*2)+7,
			],inf),
			\sustain, Pseq([
				0.01,0.01,0.001, 0.04,0.01,0.001,
				0.01,0.01,0.021, 0.01,0.01,0.001,
				0.01,0.01,0.001, 0.04,0.01,0.01,
			],inf),
			\isRest, Pseq([
				0,0,0, 1,0,0, 0,0,1, 1,0,0,
				0,0,0, 1,0,1, 0,0,0, 1,0,0,
				1,0,0, 1,0,1, 0,0,1, 1,0,1,
				0,0,1, 1,0,0, 0,0,0, 1,0,1,
				0,0,0, 1,0,0, 0,0,1, 1,0,0,
				0,0,0, 1,0,1, 0,0,0, 1,0,0,
				1,0,0, 1,0,1, 0,0,1, 1,0,1,
				0,0,1, 1,0,0, 0,0,1, 0,0,1,
			],inf).coin.not,
			\dur, 1/12,
			\amp, 0.1 * Pseq([
				1
			],inf),
		),
		
	])
)).play;
)
