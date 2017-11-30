

(
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
				\sustain, 0.1,
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\fx1, \audio),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
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
				\amp, 0.1,
				\out, BusDef(\fx1, \audio),
				\isRest, true,
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
				\amp, 0.1,
				\out, BusDef(\fx1, \audio),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
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
				\amp, 0.1,
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

