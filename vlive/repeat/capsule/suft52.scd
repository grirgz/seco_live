
// scientist - beam down

~t = 142/4/60; TempoClock.default.tempo = ~t;

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
SynthDef(\longf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.2,1],[0.1,0.8]), 1);
	env2 = SinOsc.ar(8/1.5*~t * ( SinOsc.kr(1*~t,Rand(0,2)) * 1 + 1 )).range(0.1,1);
	env3 = EnvGen.kr(\freqenv.kr(Env([1,1,1/2,1,1/2],[1/8/~t,0.01,2.0/3 - ( 1/8 )/~t,0.01], [0,0,2,0,0])), 1);
	freq = freq * env3;
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
SynthDef(\longold, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
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
			\amp, 0.3,
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
					1,0,0, 
				],12*2),
				Pser([
					4,0,0, 
				],12*2),
				Pser([
					3,0,0, 
				],12*2),
				Pser([
					2,0,0, 
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
				\instrument, \longf,
				\note, Pseq([
					4,3,2,1,
				],inf).stutter(6*4),
		\freqenv, Pseq([
			[ (Env([1,1,1/2,1,1/2],[1/8/~t,0.01,1.0/2/3 - ( 1/8 )/~t,0.01], [0,0,2,0,0])) ],
			[ (Env([1,1,1/2,1,1/2],[1/8/~t,0.01,2.0/3 - ( 1/8 )/~t,0.01], [0,0,2,0,0])) ],
			[ (Env([1,1,1/2,1,1/2],[1/2/~t,0.01,2.0/3 - ( 1/8 )/~t,0.01], [0,0,2,0,0])) ],
		],inf).stutter(6*4),
				\octave, 7,
				\legato, Pseq([
					0,0,0, 0,0,0,
				  	0,0,0, 0,0,0,
					0,0,1/4, 3*3,0,0,  
					0,0,0, 0,0,0,
					0,0,0, 0,0,0,
				  	4,0,0, 0,0,0,
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


/////////////
/// new drumkit
PatKitDef(\rim).edit
PatKitDef(\rim).presetCompileString.editorInsert
(
PatKitDef('rim').targets = [
	StepEvent.newFrom((gain: 0.1468340252848, instrument: 'playersec', bufnum: BufDef('vipere/badrimshot.flac'))),
	StepEvent.newFrom((gain: 0.2, instrument: 'playersec', bufnum: BufDef('vipere/jonrimshot2.flac'))),
	StepEvent.newFrom((gain: 0.49893341996871, instrument: 'playersec', bufnum: BufDef('vipere/joesnare.flac'))),
	StepEvent.newFrom((gain: 0.3, instrument: 'playersec', bufnum: BufDef('amen'))),
	StepEvent.newFrom((gain: 0.2, instrument: 'playersec', bufnum: BufDef('vipere/badrimshot2.flac'))),
	StepEvent.newFrom((pos: 0.18496598639456, instrument: 'playersec', gain: 0.2, bufnum: BufDef('vipere/badrimshot2.flac'), sustain: 0.05551738473167)),
	StepEvent.newFrom((pos: 0.35920634920635, instrument: 'playersec', gain: 0.68840364276871, bufnum: BufDef('vipere/badrimshot2.flac'), sustain: 0.030133408919123)),
	nil,
	StepEvent.newFrom((gain: 0.17136745623648, instrument: 'playersec', bufnum: BufDef('vipere/jonrimshot.flac'))),
	StepEvent.newFrom((pos: 1.0388662131519, instrument: 'playersec', gain: 0.17136745623648, bufnum: BufDef('vipere/jonrimshot.flac'), sustain: 0.21498563869992)),
	StepEvent.newFrom((pos: 1.52, instrument: 'playersec', gain: 0.34346758380552, bufnum: BufDef('vipere/jonrimshot.flac'), sustain: 0.19076889644747)),
	StepEvent.newFrom((pos: 2.12, instrument: 'playersec', gain: 0.17136745623648, bufnum: BufDef('vipere/jonrimshot.flac'), sustain: 0.25842366031531)),
];
);

///////////

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
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 1,0,1,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
				],inf).coin.not,
				//\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf).stutter(12),
				\dur, 1/12,
				//\gain, 0.1 * Pseq([
					//1,0.8,1,1,0.9,
				//],inf),
				\modgain, 0,
				\out, BusDef(\sendbus3, \audio),
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 10,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 1,0,0,  0,0,1, 0,0,1,
					1,0,0, 0,0,1,  0,0,1, 0,0,0,
					0,0,0, 1,0,0,  0,0,1, 0,1,1,
				],inf).coin.not,
				//\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf).stutter(12),
				\dur, 1/12,
				//\gain, 0.1 * Pseq([
					//1,0.8,1,1,0.9,
				//],inf),
				\modgain, 0,
				\out, BusDef(\sendbus1, \audio),
			)),
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
				\adsr, Prand([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.0061,0.1,0.8,0.2) ],
					[ Env.adsr(0.001,0.1,0.2,0.4) ],
				],inf),
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
				\sustain, 0.01 * Prand([1,1,1,1,2,3],inf),
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
			\octave, Prand([4,5,6,5],inf),
			\sustain, 0.1,
			\dur, 2,
			\amp, 0.3,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \chordo2,
			\note, Pseq([
				0,4,
			],inf),
			\octave, Prand([4,4,5,6],inf),
			\sustain, 0.1,
			\dur, 2,
			\amp, 0.3,
			\out, BusDef(\sendbus3, \audio),
		),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				//\out, BusDef(\sendbus2b, \audio),
				\addAction, \addToTail,
				\lag, 0.00005,
				'mix', 0.3214285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					Pwhite(0.1,100),
				],inf).stutter(1),
				'delay2', 0.000000543560101 * Pwhite(1.0,10000),
				'distamp', 21.361836201538,
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
				\dur, Pseq([1,1.5,1,2.25],inf),
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

///////////////////////////////////////

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

SynthDef(\bassgrise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq * [1,1 + \det.kr(0.1)] * ( SinOsc.ar(freq * 1 + \fmdet.kr(0.01)) * 0.1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\bassgrise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[2.1,0.8]), 1);
	sig = SinOsc.ar(freq * [1,1 + ( env1 * \det.kr(0.1) )] * ( SinOsc.ar(freq * 1 + \fmdet.kr(0.01)) * 0.1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\chordo2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.2,1],[0.1,0.8]), 1);
	env2 = SinOsc.ar(8/1.5*~t * ( SinOsc.kr(1*~t,Rand(0,2)) * 1 + 1 )).range(0.1,1);
	env2 = SinOsc.ar(1/1.5*~t * ( SinOsc.kr(1*~t,Rand(0,2)) * 1 + 1 )).range(0.9,1);
	sig1 = SinOsc.ar(freq* [1,1.0001,1/2,1/4] * [0,4,7].midiratio/4)* EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig2 = SinOsc.ar(freq/2 * [1,2,1/2] * 4.midiratio).fold(env1) * 0.4;
	sig3 = LFSaw.ar(freq * [1,1.01,1.006,1/2,1/4] * 7.midiratio) * EnvGen.kr(Env([0,0.51,0],[1.1,2.8], 4), 1);
	sig3 = RLPF.ar(sig3, \lpfr.kr(2.1) * EnvGen.kr(Env([1,1/2,2,1],[2,2.1,2.8]), 1) * freq, \rq.kr(0.5));
	sig4 = SinOsc.ar(freq * [3/4,5/4]) * EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig5 = SinOsc.ar(freq+0.1 * [0+12,4,7,7-12,4-24].midiratio/2 * ( LFSaw.ar(freq/2) * 0.4 + 1 )) * EnvGen.kr(Env([0,0.41,0],[0.1,1.5]), 1);
	sig6 = SinOsc.ar(freq*1.001 * [1,1/2,2,1/8]  * ( SinOsc.ar(freq* [0+12,4,7,7-12].midiratio/2) * 1.4 + 1 )) * EnvGen.kr(Env([0,0,0.41,0],[0.3,0.8,6.5]), 1);
	sig6 = HPF.ar(sig6, 1000 * EnvGen.kr(Env([1,2,1],[4.1,0.8]), 1)) + BPF.ar(sig6, 70);
	sig = sig1 + sig2 + sig3 + sig4 + sig5 + sig6;
	sig = RLPF.ar(sig, env2 * 1000, 0.5 / (1+ env2 )) + ( sig/1.72 );
	sig = HPF.ar(sig, env1 * \hpf.kr(1000));
	sig = AllpassL.ar(sig, 0.4,0.01 * [1,0.6,0.7,1.1],4.5) + ( sig * 2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,5.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\hipass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ( SinOsc.ar(\fmf1.kr(3) * ( SinOsc.ar(\fmf2.kr(4)) * 1 + 1 )) * 1 + 1 ));
	sig = HPF.ar(sig, \hpf.kr(7000));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\hipasswide, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.001] * ( SinOsc.ar(\fmf1.kr(3) * ( SinOsc.ar(\fmf2.kr(4)) * 1 + 1 )) * 1 + 1 ));
	sig = HPF.ar(sig, \hpf.kr(7000));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1] * \stereo.kr(1), amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\plouc, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,6/4],[0.01,0.08]), 1);
	sig = SinOsc.ar(freq * env1);
	sig = sig.fold(0.2);
	sig = DelayL.ar(sig, 0.1,\delay.kr(0.01))+sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\chordodo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[4.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * [1,1.00001]);
	sig2 = LFSaw.ar(freq * [1,1.00001]);
	sig2 = sig2 * EnvGen.kr(Env([0,1,0],[1.1,1.8]), 1);
	sig2 = HPF.ar(sig2, \hpf.kr(8000) * env1);
	sig = [sig1, sig2].sum / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;
);

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
						8,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0.51, 0.51,0,0.51,
						
					],3),

			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/12,
			\amp, 0.1,
				\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
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
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \bassgrise,
			\note, Pseq([
				Pser([
					7,0,0, 
					0,0,0, 
					0,0,0, 
					0,0,0, 
				],12*2),
			],inf),
			\lpf, 302,
			\det, Pwhite(0.1,0.001),
			\legato, Pseq([

					Pseq([
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0.51, 0.51,0,0.51,
						8,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0.51, 0.51,0,0.51,
						2,0,0, 0,0,0,  2,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0.51, 0.51,0,0.51,
						
					],3),

			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/12,
			\amp, 0.1,
			\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
		),
			Pmono(\rdnroom,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\dur, 1/8,
				'wet10', 1.0,
				'mix', 0.4,
				'gain', 1/8,
				'fb', 0.001000031,
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
				\instrument, \dubdrone4,
				\note, Pseq([
					0,
				],inf),
				\octave, 7,
				\legato, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					8,0,0, 0,0,0,  0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,3.1) ],
				],inf),
				//\lag, 0.04,
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.15714285714286,
				'gain', 5.7344889782792,
				'fb', 0.001099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560100,
				'distamp', 2.361836201538,
				'prelpf', 19900,
				'prehpf', 1700,
				'lpf', 19900,
				'hpf', 200,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 570,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1,
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
				\isRest, true,
			),


		
	])
)).play;
)

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
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * ( SinOsc.ar( freq ) * 0.1 + 1 ));
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \hipass,
			\note, Pseq([
				0,
			],inf),
			\fmf1, 13,
			\fmf2, 4,
			\hpf, 7000,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordo2,
			\note, Pseq([
				//[0,3,5],
				[0,4,7],
				[0,3,7]+2,
			],inf).stutter(8),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \hipass,
			\note, Pseq([
				0,
			],inf),
			\fmf1, Pexprand(1,333.0).stutter(inf),
			\fmf2, Pexprand(1,9.0).stutter(inf),
			\hpf, 7000,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordo2,
			\note, Pseq([
				//[0,3,5],
				[0,4,7],
				[0,3,7]+2,
			],inf).stutter(8),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \hipass,
			\note, Pseq([
				0,4,9,
			],inf),
			\fmf1, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\hpf, ~pmodenv.(Pseq([7000,2000,100,400],inf), 8),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordo2,
			\note, Pseq([
				//[0,3,5],
				[0,4,7],
				[0,3,7]+2,
			],inf).stutter(8),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpf, 10,
			\octave, 6,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
)
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \hipass,
			\note, Pseq([
				0,4,9,
			],inf),
			\fmf1, ~pmodenv.(Pseq([1,2,1/2,4]*8,inf), 3.2),
			\fmf2, 17,
			\hpf, ~pmodenv.(Pseq([7000,2000,100,400],inf), 8),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordo2,
			\note, Pseq([
				//[0,3,5],
				[0,4,7],
				[0,3,7]+2,
			],inf).stutter(8),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpf, 10,
			\octave, 6,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \hipasswide,
			\note, Pseq([
				0,
			],inf),
			\fmf1, 13,
			\fmf2, 4,
			\hpf, 7000,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordo2,
			\note, Pseq([
				//[0,3,5],
				[0,4,7],
				[0,3,7]+2,
			],inf).stutter(8),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \plouc,
			\note, Pseq([
				0,2,
			],inf).stutter(16),
			\delay, ~pmodenv.(Pseq([0.01,0.2,0.001,0.0004],inf), 8),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \bassgrise,
			\note, Pseq([
				0,2,
			],inf).stutter(2),
			\det, 0.01,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \bassgrise,
			\note, Pseq([
				0,2,
			],inf).stutter(2*4*2)+
			Pseq([
				Prand([0,0,4],2*4*2),
				Prand([0,0,3],2*4*2),
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,0,0,0,
			]-0.1,inf).coin.not,
			\det, 0.01,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \hipass,
			\note, Pseq([
				0,4,9,
			],inf),
			\fmf1, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\hpf, ~pmodenv.(Pseq([7000,2000,100,400],inf), 8),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordo2,
			\note, Pseq([
				//[0,3,5],
				[0,4,7],
				[0,3,7]+7,
				[0,3,7]+3,
				[0,3,7]+2,
			],inf).stutter(8),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpf, 10,
			\octave, 6,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \hipass,
			\note, Pseq([
				0,4,9,
			],inf),
			\fmf1, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\fmf2, ~pmodenv.(Pseq([1,2,1,4]*1.5*2,inf), 8),
			\hpf, ~pmodenv.(Pseq([7000,2000,100,400],inf), 8),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordo2,
			\note, Pseq([
				//[0,3,5],
				[0,4,7],
				[0,4,7],
				[0,4,7],
				[0,4,7],
				[0,3,7]+7,
				[0,3,7]+7,
				[0,3,7]+3,
				[0,3,7]+2,
			],inf).stutter(3),
			\legato, Pseq([
				3,0,0, 0,0,0,
				1,0,0, 1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpf, 10,
			\octave, 6,
			\dur, 1/3,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0, 1,0,1, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		 Ppar([
			Pbind(
				\instrument, \chordodo,
				\hpf, 10,
				\octave, 5,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \chordo2,
				\hpf, 10,
				\octave, 6,
				\amp, 0.1,
			),
		].collect({ arg pat; pat <>
			Pbind(
				\dur, 1/6,
				\note, Pseq([
					//[0,3,5],
					[0,4,7],
					[0,4,7],
					[0,4,7],
					[0,4,7],
					[0,3,7]+7,
					[0,3,7]+7,
					[0,3,7]+3,
					[0,3,7]+2,
				],inf).stutter(3),
				\legato, Pseq([
					8,0,0, 0,0,0, 0,0,0, 0,0,0,
					3,0,0, 0,0,0, 1,0,0, 1,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			)
	   
		}))
		
	])
)).play;
)


///////////


(
SynthDef(\basicpadfm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([1,2,1],[4.1,4.8])), 1);
	env2 = EnvGen.kr(\fmenv.kr(Env([0,2,1],[4.1,4.8])), 1);
	sig1 = SinOsc.ar(freq * [1,1+\det.kr(0.00001)] * ( SinOsc.ar(freq*[2,1/2,1+\det.kr]).sum * env2 + 1 ));
	sig2 = LFSaw.ar(freq * [1,1+\det.kr]);
	sig2 = sig2 * EnvGen.kr(\sawenv.kr(Env([0,1,0],[1.1,1.8])), 1);
	sig2 = LPF.ar(sig2, \lpf.kr(8000) * env1);
	sig2 = sig2 * 1;
	sig = SelectX.ar(\oscmix.kr(0.5), [sig1, sig2]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;
);

(
~master_simple = {
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
}
)

(
	~master_simple.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \basicpadfm,
			\note, Pseq([
				0,4,
			],inf),
			\octave, 3,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.8) ],
				[ Env.adsr(0.001,0.1,0.8,1.8) ],
			],inf),
			\dur, 1,
			\amp, 0.1/4,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \basicpadfm,
			\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\note, Pseq([
				[0,4,7],
				[0,4,7]+4,
			],inf),
			\oscmix, ~pmodenv.(Pseq([0,1,0.51,0.74],inf), 8),
			\lpf, 1000,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
)

ProtoDef(\rdn).edit
ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
ProtoDef(\rdn2).edit



(
	~master_simple.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pdef(\bc_kick,
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
		),
		Pdef(\bc_bass,
			Pbind(
				\instrument, \basicpadfm,
				\note, Pseq([
					0,8,
				],inf),
				\octave, 3,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.8) ],
					[ Env.adsr(0.001,0.1,0.8,0.8) ],
					[ Env.adsr(0.001,0.1,0.8,1.8) ],
					[ Env.adsr(0.001,0.1,0.8,0.4) ],
					[ Env.adsr(0.001,0.1,0.8,2.8) ],
				],inf),
				\dur, 1,
				\amp, 0.1/4,
				\out, BusDef(\sendbus2, \audio),
			),
		),
		Pdef(\bc_chord,
			Pbind(
				\instrument, \basicpadfm,
				\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
				\note, Pseq([
					[0,3,7],
					[0,3,7]+8,
					[0,3,7],
					[0,2,6]+8,
				],inf),
				\oscmix, ~pmodenv.(Pseq([0,1,0.51,0.74],inf), 8),
				\lpf, 1000,
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
		),

	])
)).play;
)


(
)

(
	// init
TrackDef(\basschordgrid, TrackTemplateDef(\playergrid));
TrackDef(\basschordgrid).childAt(0,0).source = ProtoClass((play:{ "hello".postln }, isPlaying:false));
ProtoDef(\apc40).activate(TrackDef(\basschordgrid));
)

(
	// init 2
TrackDef(\basschordgrid).childAt(6,0).source = Ndef(\rdn);
TrackDef(\basschordgrid).childAt(7,0).source = Ndef(\rdn2);

TrackDef(\basschordgrid).childAt(0,0).source = Pdef(\bc_kick);
TrackDef(\basschordgrid).childAt(1,0).source = Pdef(\bc_bass);
TrackDef(\basschordgrid).childAt(2,0).source = Pdef(\bc_chord);

ProtoDef(\apc40).render_grid;

	ProtoDef(\apc40).mapParam([\sl, 0, 6], Param(Ndef(\rdn), \gain, ControlSpec(0,2,\lin)));
	ProtoDef(\apc40).mapParam([\sl, 0, 7], Param(Ndef(\rdn2), \gain, ControlSpec(0,2,\lin)));

	ProtoDef(\apc40).mapParam([\sl, 0, 0], ProtoDef(\simpleMixer).tracks[0].asParam(\send1));
	ProtoDef(\apc40).mapParam([\sl, 0, 1], ProtoDef(\simpleMixer).tracks[1].asParam(\send1));
	ProtoDef(\apc40).mapParam([\sl, 0, 2], ProtoDef(\simpleMixer).tracks[2].asParam(\send0));

~master = {
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
	ProtoDef(\simpleMixer).play;
};
)

~master.()

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pdef(\bc_kick,
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1/2,
				\out, BusDef(\mixer0, \audio),
			),
		),
		Pdef(\bc_bass,
			Pbind(
				\instrument, \basicpadfm,
				\note, Pseq([
					0,8,
				],inf),
				\octave, 3,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.8) ],
					[ Env.adsr(0.001,0.1,0.8,0.8) ],
					[ Env.adsr(0.001,0.1,0.8,1.8) ],
					[ Env.adsr(0.001,0.1,0.8,0.4) ],
					[ Env.adsr(0.001,0.1,0.8,2.8) ],
				],inf),
				\dur, 1,
				\amp, 0.1/4,
				\out, BusDef(\mixer1, \audio),
			),
		),
		Pdef(\bc_chord,
			Pbind(
				\instrument, \basicpadfm,
				\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
				\note, Pseq([
					[0,3,7],
					[0,3,7]+8,
					[0,3,7],
					[0,2,6]+8,
				],inf),
				\oscmix, ~pmodenv.(Pseq([0,1,0.51,0.74],inf), 8),
				\lpf, 1000,
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\mixer2, \audio),
			),
		),

	])
));
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pdef(\bc_kick,
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1/2,
				\out, BusDef(\mixer0, \audio),
			),
		),
		Pdef(\bc_bass,
			Pbind(
				\instrument, \basicpadfm,
				\note, Pseq([
					0,8,
				],inf),
				\octave, 3,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.8) ],
					[ Env.adsr(0.001,0.1,0.8,0.8) ],
					[ Env.adsr(0.001,0.1,0.8,1.8) ],
					[ Env.adsr(0.001,0.1,0.8,0.4) ],
					[ Env.adsr(0.001,0.1,0.8,2.8) ],
				],inf),
				\dur, 1,
				\amp, 0.1/4,
				\out, BusDef(\mixer1, \audio),
			),
		),
		Pdef(\bc_chord,
			Pbind(
				\instrument, \basicpadfm,
				\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
				\note, Pseq([
					[0,3,7],
					[0,3,7]+1,
				],inf),
				\oscmix, ~pmodenv.(Pseq([0,1,0.51,0.74],inf), 8),
				\lpf, 1000,
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\mixer2, \audio),
			),
		),

	])
));
)

Pdef(\bc_kick).play
Pdef(\bc_kick).clear
Pdef(\bc_bass).play
Pdef(\bc_bass).clear
