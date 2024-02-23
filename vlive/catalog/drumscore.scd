
/////////////////////////////////////////////////////////////////
///////////// Funky drummer
(
~t = 96/2/60; TempoClock.default.tempo = ~t;

 SynthDef(\snapkick, { |out = 0, pan = 0, amp = 0.3|
	 // by snappizz
	 var body, bodyFreq, bodyAmp;
	 var pop, popFreq, popAmp;
	 var click, clickAmp;
	 var snd;

	 // body starts midrange, quickly drops down to low freqs, and trails off
	 bodyFreq = EnvGen.ar(Env([261, 120, 51], [0.035, 0.08], curve: \exp));
	 bodyAmp = EnvGen.ar(Env.linen(0.005, 0.1, 0.3), doneAction: 2);
	 body = SinOsc.ar(bodyFreq) * bodyAmp;
	 // pop sweeps over the midrange
	 popFreq = XLine.kr(750, 261, 0.02);
	 popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001)) * 0.15;
	 pop = SinOsc.ar(popFreq) * popAmp;
	 // click is spectrally rich, covering the high-freq range
	 // you can use Formant, FM, noise, whatever
	 clickAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.15;
	 click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

	 snd = body + pop + click;
	 snd = snd.tanh;

	 Out.ar(out, Pan2.ar(snd, pan, amp));
 }).add;

SynthDef(\snarebpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

	popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
	popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
	pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(410) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1840,2010,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	env2 = EnvGen.kr(Env([411,150,245],[0.01,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	sig = pop + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.01,0.9)) + LPF.ar(WhiteNoise.ar(0.1), 11300);
	sig = ( pop/2 ) + ( sig );
	sig = BPF.ar(sig, [130,220], 0.1).mean + sig; // eq
	sig = HPF.ar(sig, env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.4,1,-6)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;

SynthDef(\phycymbal, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

	popFreq = EnvGen.ar(Env([8261, 11410, 1460], [0.005, 0.01], curve: \exp));
	popAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.7;
	pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(10) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1180,6810,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.3) );
	env2 = EnvGen.kr(Env([3171,7470,13845],[0.04,\rel.kr(0.1)],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = pop/2 + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.71,0.9) * XLine.kr(1.3,1,1)) + LPF.ar(WhiteNoise.ar(0.1), 11300);
	sig = ( pop/2 ) + ( sig );
	sig = HPF.ar(sig, env2);
	sig = LPF.ar(sig, 17000);
	sig = LPF.ar(sig, 11000) + ( sig/2 );
	//sig = BRF.ar(sig, MouseX.kr(20,20000).poll, MouseY.kr(0.1,1));
	sig = BRF.ar(sig, 12000);
	sig = sig * 0.6;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.1,0.1,0.8,0.4,1,-8) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)


(
Pdef(\funkydrummer, 
	Ppar([
		Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\sustain, 0.1/2,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snarebpf,
			\sustain, 0.1/2,
			\adsr, Pseq([
				 [ Env.adsr(0.1/3,0.1,0.8,0.2,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snarebpf,
			\sustain, 0.04,
			\adsr, Pseq([
				 [ Env.adsr(0.1/2,0.1,0.8,0.1,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1/2,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \phycymbal,
			\sustain, 0.1/3,
			\adsr, Pseq([
				 [ Env.adsr(0.001,0.1,1.8,0.07,1,-3) ],
				 [ Env.adsr(0.002,0.1,0.8,0.04,1,-3) ],
			],inf).stutter(2),
			\pan, -0.1,
			\isRest, Pseq([
				1,1,1,1, 
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,8,1,
			],inf)*0.1,
			\dur, 1/8,
			\sustain, Pseq([
				0.05, 0.02, 0.05, 0.02,
				0.05, 0.02, 1/6/~t, 0.02,
				0.05, 1/6/~t, 0.05, 0.02,
				1/6/~t, 0.02, 0.05, 0.02,
			],inf)/2,
			\amp, 0.1/2,
			\amp, Pkey(\amp) * Pseq([
				1, 0.7, 0.9, 0.5,
				Plazy({ Pseq([
					1, 0.7, 0.9, 0.5,
				].scramble,1) }),
			],inf),
		),
	])
).play;
)



/////////////////////////////////////////////////////////////////
///////////// dub

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

FileSystemProject.load("holis/synthdef.scd");
FileSystemProject.load("capsule/PatKitDef_ksh.scd");
FileSystemProject.load("capsule/PatKitDef_bat.scd");

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
				\isRest, true,
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

/////////////////////////////////////////////////////////////////
///////////// tyler yonker hiphop beat
// - swing
// - advanced hat score (amen sample)
// FIXME: why it freeze the interpreter ?


(
SynthDef(\sinbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([2,1.2,1/2],[0.011,1.7]), 1);
	sig = LFSaw.ar(freq * env1 * [1,1/2,1.005]) * [1,1,1];
	//sig = RLPF.ar(sig, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	//sig = BPF.ar(sig, freq/2, 0.1) * 3 + sig;
	sig = sig + SinOsc.ar(freq); 
	sig = LPF.ar(sig, \lpfr.kr(2.1) * env1 * freq);
	sig = ( sig*2 ).tanh * 3;
	sig = HPF.ar(sig, 30);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.4,1.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\pico, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1.2,1.001,1],[0.01,0.01,1]), 1);
	sig = SinOsc.ar(freq * [1,1/2,2]) ;
	sig = LFSaw.ar(freq * [1,2 * env2, 1/2]) + sig /4;
	sig1 = sig;
	sig1 = LPF.ar(sig1, freq * 4 * env1);
	sig1 = HPF.ar(sig1, freq * env1);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	sig = sig + sig1 /1;
	sig = BRF.ar(sig, freq, 1/2);
	sig = HPF.ar(sig, 400);

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.04,0.1,0.8,0.4)),gate,doneAction:2);
	sig = sig.sum;
	sig = DelayC.ar(sig, 0.01, [ 0.0001,0 ], 1);
	sig = sig /8;
	//sig = Pan2.ar(sig, pan, amp).sum;
	//sig = Splay.ar(sig, 1, amp, pan);
	Out.ar(out, sig);
}).add;
);

FileSystemProject.load("algokit/kits/PatKitDef_sample1.scd");

(
r = \r;
Pdef(\fadrum, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0, 0,0,
				0,0, 0,1,
				1,0, 1,0,
				0,0, 1,0,
				1,0, 0,0,
				0,0, 0,1,
				1,1, 1,0,
				0,1, 1,1,

				1,0, 0,0,
				0,0, 1,1,
				1,0, 1,0,
				0,0, 1,0,
				1,0, 0,0,
				0,0, 0,1,
				1,0, 1,0,
				0,0, 0,1,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/4,
			\dur, Pkey(\dur) * (1 + (0.15 * Pseq([1,-1],inf))),
			\gain, 0.6,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, Pseq([1,4],inf).stutter(16) * 0.111,
			\dur, 1/8,
			\gain, 1/2,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/8,
			\gain, 1/3,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\instrument, \playersec_hlpf,
			\bufnum, BufDef(\amen),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
			\pos, 0.50,
			\speed, 1.2,
			\sustain, 0.1,
			\lpmix, 1,
			\hpmix, 1,
			\lpf, 9300,
			\hpf, 4300,
			\gain, 0.15,
			\adsr, Prand([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\sustain, 0.1,
			\gain, Pkey(\gain) * Pseq([
				0.8, 0.2,
			],inf).stutter(1),
			\lag, 1/8,
			\dur, 1/4,
			\amp, 0.1,
		)),
		Pseq([
			Pfindur(8,Pdef(\firsthat, PatKitDef(\sample1).asPattern(Pbind(
				// tech:
				// - downbeat has accent
				// - upbeat is probabilistic
				// - pos vary to vary timbre
				// - random env
				// - swing
				// - two scores in Pseq to add variety
				\kitIndex, 0,
				\instrument, \playersec_hlpf,
				\bufnum, BufDef.mono('heavy/kick1.flac'),
				\bufnum, BufDef('heavy/kick1.flac'),
				\bufnum, BufDef(\amen),
				\isRest, Pseq([
					0,1, 1,1,
				],inf).coin.not,
				\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
				\grate, 100,
				\lpmix, 1,
				\hpmix, 1,
				\lpf, 9300,
				\hpf, 4300,
				\isRest, Pseq([
					1,0.41,1,0.41,
					1,0.41,1,0.41,
					1,0.41,1,0.41,
					1,0.61,1,0.61,

					1,0.41,1,0.41,
					1,0.81,1,0.81,
					1,0.41,1,0.81,
					1,0.41,1,0.41,
					//1,1,1,1,
				],inf).coin.not,
				\speed, 1.2,
				\adsr, Prand([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
					[ Env.adsr(0.01,0.1,0.8,0.051) ],
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
					[ Env.adsr(0.1,0.1,0.8,0.01) ],
				],inf),
				\dur, 1/4,
				\dur, Pkey(\dur) * (1 + (0.15 * Pseq([1,-1],inf))),
				\sustain, 0.1,
				\gain, 0.15,
				\gain, Pkey(\gain) * Pseq([
					0.8, 0.2,
				],inf).stutter(1),
				\amp, 0.1,
			)))),
			Pfindur(4,PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\instrument, \playersec_hlpf,
				\bufnum, BufDef.mono('heavy/kick1.flac'),
				\bufnum, BufDef('heavy/kick1.flac'),
				\bufnum, BufDef(\amen),
				\isRest, Pseq([
					0,1, 1,1,
				],inf).coin.not,
				//\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
				\pos, 0.49,
				\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
				\grate, 100,
				\isRest, Pseq([
					0,1,0,1,
				],inf).coin.not,
				\lpmix, 1,
				\hpmix, 1,
				\lpf, 9300,
				\hpf, 4300,
				\isRest, Pseq([
					1,0.41,1,0.41,
					1,0.41,1,0.41,
					1,0.41,1,0.41,
					1,0.61,1,0.61,

					1,0.41,1,0.41,
					1,0.81,1,0.81,
					1,0.41,1,0.81,
					1,0.41,1,0.41,
					//1,1,1,1,
				],inf).coin.not,
				//\grate, ~pmodenv.(Pseq([0,0.2,0.3,0.6],inf)*1317, 1/4),
				\sustain, 0.11/1 * Pseq([0.5,1],inf).stutter(1) * Prand([1,1/2,0.7,1.5],inf),
				\speed, 1.2,
				\dur, 1/4,
				\dur, Pkey(\dur) * (1 + (0.15 * Pseq([1,-1],inf))),
				\adsr, Prand([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
					[ Env.adsr(0.01,0.1,0.8,0.051) ],
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
					[ Env.adsr(0.1,0.1,0.8,0.01) ],
				],inf),
				\adsr, Prand([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\sustain, 0.1,
				\gain, 0.20,
				\gain, Pkey(\gain) * Pseq([
					0.8, 0.2, 0.8, 0.2, 0.8, 0.8, 0.2, 0.2,
					0.8, 0.8, 0.2, 0.2, 0.8, 0.8, 0.7, 0.2,
				],inf).stutter(1),
				\isRest, Pseq([
					1,0,1,1, 0,1,1,0,
					0,1,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			))),
			Pfindur(4, Pbind(
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 0,0,0,0,
				],inf).coin.not,
			) <> Pdef(\firsthat)),
		],inf),
		Pbind(
			\instrument, \sinbass,
			\degree, Pseq([
				1s,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4s,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,4s,1s,
			],inf),
			\octave, 3,
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,

				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0,
					
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
				],inf),
			],inf).coin.not,
			\legato, Pseq([
				10,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1/2,1,1,1, 1/2,1,1,1,
				1,1,1,1, 1,1,1/2,1/2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,1.1) ],
				[ Env.adsr(0.001,0.1,0.8,1.1) ],
				[ Env.adsr(0.001,0.1,0.8,0.6) ],
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf).stutter(8),
			\dur, 1/4,
			\amp, 0.1
		),
		Pbind(
			\instrument, \pico,
			\degree, Pseq([
				r,r,r,r, r,r,r,r,
				r,r,r,r, 1,1,1,1,
				1s,r,r,r, r,r,r,r,
				r,r,r,r, 1,1,1,1,
			],inf) + [0,-3],
			\dur, 1/2,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \pico,
			\degree, Pseq([
				r,r,r,r, r,r,r,r,
				r,r,r,r, 1s,r,r,1s,
				r,r,r,r, r,r,r,r,
				r,r,r,r, 1s,1s,r,1s,
			].rotate(-1),inf),
			\lag, 1/4 + (1/40),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\legato, 0.1,
			\dur, 1/2,
			\amp, 0.1/2,
		),
	])
).play;
)

///////////////////////////////////////////////////////////
//////// swing and ternary
~t = 185/2/60; TempoClock.default.tempo = ~t;

FileSystemProject.load("algokit/kits/PatKitDef_sample1.scd");

// ternary
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0, 0,0,0,
				0,0,0, 0,0,1,
				1,0,0, 1,0,0,
				0,0,0, 1,0,0,
				1,0,0, 0,0,0,
				0,0,0, 0,0,1,
				1,0,1, 1,0,0,
				0,0,1, 1,0,1,
		
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/6,
			\gain, 0.6,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, Pseq([1,4],inf).stutter(16) * 0.111,
			\dur, 1/8,
			\gain, 1/2,
			\amp, 0.1,
		)),
	])
)).play;
)

// is equivalent to swinged binary half timed
// (but swing allow more subtility)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0, 0,0,
				0,0, 0,1,
				1,0, 1,0,
				0,1, 1,1,

				1,0, 0,0,
				0,0, 0,1,
				1,1, 1,0,
				0,1, 1,1,

			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/4,
			\dur, ( Pkey(\dur) * (1 + (0.20 * Pseq([1,-1],inf))) ).trace, 
			\gain, 0.6,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, Pseq([1,4],inf).stutter(16) * 0.111,
			\dur, 1/8,
			\gain, 1/2,
			\amp, 0.1,
		)),
	])
)).play;
)

// is also equivalent in reverse swinged binary:
// logic: in reverse swing, the note is in the fourth position, but start sooner due to the swing, so equivalent of the third position, which mean the second position in half-time swinged, and third position in ternary

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 1,0,0,0,
				0,0,0,1, 1,0,0,1,

			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/8,
			// reverse swing
			\dur, ( Pkey(\dur) * (1 + (0.60 * Pseq([-1,1],inf))) ).trace,
			//\dur, ( Pkey(\dur) * (1 + (0.05 * Pseq([1,-1],inf))) ).trace, // don't work
			\gain, 0.6,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, Pseq([1,4],inf).stutter(16) * 0.111,
			\dur, 1/8,
			\gain, 1/2,
			\amp, 0.1,
		)),
	])
)).play;
)



///////////////////////////////////////////////////////////
//////// slow hip hop
// from capsule/draft19
// - ghost snare
// - hat upbeat very unaccentued and rare

~t = 135/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("capsule/PatKitDef_ksh.scd");


Pdef(\part).clear;

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pfindur(24,Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,1, 0,0,1,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.4* Pseq([
					1,0.2,
				],inf),
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.1,
			)),
		])),
	])
)).play;
)


///////////////////////////////////////////////////////////
//////// dub
// from capsule/draft19

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pfindur(24,Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\adsr, Pseq([
					[ Env.adsr(0.02,0.1,0.8,0.4) ],
				],inf),
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
		
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,1, 0,0,1,0, 0,0,0,0, 0,1,0,0,
		
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/4,
				\adsr, Pseq([
					[ Env.adsr(0.02,0.1,0.8,0.3) ],
				],inf),
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0, 0,0,1,0, 1,1,0,1,
					0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
		
					0,0,1,0, 1,0,1,0, 0,0,1,0, 0,0,1,0,
					0,0,1,1, 1,0,1,0, 0,0,1,0, 1,1,0,1,
					0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
					0,0,1,0, 1,1,1,0, 0,0,1,0, 1,1,0,1,
		
					0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
					0,0,1,1, 1,0,1,0, 0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0, 0,0,1,0, 1,0,1,1,
					0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
		
					0,0,1,0, 0,0,1,0, 0,0,1,0, 1,0,1,0,
					1,1,0,1, 1,1,0,1, 0,0,1,0, 1,0,1,1,
					0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
					0,0,1,1, 1,0,1,0, 0,0,1,0, 1,1,0,1,
				],inf).coin.not,
				\gain, 0.4* Pseq([
					1,0.6,
				],inf),
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,  0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
		
					0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\gain, 0.4* Pseq([
					1,0.6,
				],inf),
				\sustain, 0.10,
				\dur, 1/16,
				\amp, 0.1,
			)),
		])),
	])
)).play;
)


///////////////////////////////////////////////////////////
//////// hip hop with dub hat
// from capsule/suft73.scd
FileSystemProject.load("capsule/PatKitDef_bat.scd");
FileSystemProject.load("holis/synthdef.scd");
(
SynthDef(\subass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([2,1,1],[0.01,0.8]), 1);
	env2 = EnvGen.kr(\freqenv.kr(Env([1,1.1,1.02,1,0.991],[1/2,1/4, 1/4,1/2]/~t)), 1);
	sig = SinOsc.ar(freq * [1,1.002, env2]).sum;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.02,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.015, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 1,0,0,  0,0,0, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,1,  0,0,0, 0,0,1,
				0,0,1, 1,0,0,  0,0,0, 0,0,0,
		
				0,0,0, 0,0,1,  0,0,0, 0,0,1,
				0,0,0, 1,0,0,  0,0,0, 1,0,1,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
		
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,1,
			],inf).coin.not,
			\speed, 1.01,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/3,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,0, 1,0,0,  0,0,1, 0,0,1,
				0,1,0, 1,0,0,  0,0,0, 1,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1 * Pseq([
				1,1,1/8, 1/2,1,1,  1,1,1/4, 1,1,1,
			],inf),
			\speed, 0.9,
			\velamp, 1/6,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
		
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\speed, 0.9,
			\velamp, 1/6,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.6,0.2],inf),
		),
		Pbind(
			\instrument, \subass,
			\freqenv, Pseq([
				[Env([1,1.1,1.02,1,0.991],[1/2,1/4, 1/4,1/2]*2/~t)],
			],inf).stutter(1),
			\note, Pseq([
				1,0,
			],inf)-2,
			\legato, Pseq([
				3,0,0, 0,0,0,  0,0,0, 0,0,1,
				0,0,0, 3,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\lpf, 40,
			\dur, 1/12,
			\amp, 0.2,
		),
	])
)).play;
);

///////////////////////////////////////////////////////////
//////// drums with echo


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
	])
)).play;
)



///////////////////////////////////////////////////////////
//////// cool randomized breakbeat drum with 6/8
// from capsule/vin11.scd

(
Pdef(\part, Pdef(\zed, 
	Ppar([
	Pbind(
		\instrument, \snapkickx,
		\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
		\dur, 1/8,
		\isRest, Pseq([
			Prand([
				Pseq([ 
					1,0,0,0, 0,0,0,1, 
					0,1,0,0, 0,0,0,1, 
					1,0,0,0, 0,0,1,0, 
					0,1,0,0, 0,0,0,1, 

					1,0,0,0, 0,0,0,1, 
					0,0,0,1, 0,0,0,1, 
					0,1,0,1, 0,0,0,0, 
					0,0,1,0, 0,0,0,1, 
				],1),
			],1),
		],inf).coin.not,
		\amp, 0.2,
	),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[0575].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.21,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\isRest, Pseq([
					Prand([
						Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
						Pseq([ 0,0,0,0, 1,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
						Pseq([ 0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0, ],1),
					],1),
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.31,
				\gain, Pkey(\gain) * Pseq([
					Prand([
						Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
						Pseq([ 1,1,0,1, 1,0,1,0, ],1),
						Pseq([ 1,0,1,1, 0,1,1,0, ],1),
						Pseq([ 1,1,0,1, 0,1,1,0, ],1),
					],inf) + 0.7 / 1.7,
				],1),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1066].value,
				\isRest, Pseq([
					Prand([
						Pseq([ 1,1,0,1, 1,0,1,0, ],1),
						Pseq([ 1,0,1,1, 0,1,1,0, ],1),
						Pseq([ 1,1,0,1, 0,1,1,0, ],1),
					],inf),
					0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,1,1, 0,0,0,1, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\sustain, 0.01,
				\gain, 0.05,
				\gain, Pkey(\gain) * Pseq([
					Prand([
						Pseq([ 1,1,1,1, 0,0,0,0, ]-0.7,1),
						Pseq([ 0,0,0,0, 1,1,1,1, ]-0.7,1),
						Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
						Pseq([ 1,1,0,1, 1,0,1,0, ]-0.7,1),
						Pseq([ 1,1,0,1, 1,0,1,0, ],1),
						Pseq([ 1,0,1,1, 0,1,1,0, ],1),
						Pseq([ 1,1,0,1, 0,1,1,0, ],1),
					],inf) + 0.7 / 1.7,
				],1),
			),
		
	])
)).play;
);


/////////////////////////////////////
///// trap capsule/vin15.scd


~t = 140/4/60; TempoClock.default.tempo = ~t; // trap tempo

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1153].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1960].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[849].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
					0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
					0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
				],inf),
			],inf).coin.not,
			
			\dur, 1/16,
			\gain, 0.31 * Pseq([
				1/8,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
			],inf),
		),

		
	])
)).play;
);



/////////////////////////////////////
///// jazz
// 4 * 3 steps
~t = 185/4/60; TempoClock.default.tempo = ~t;
(
	// jazz drums
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1277].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1916].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1128].value,
			\isRest, Pseq([
				1,0,0, 1,0,1, 1,0,0, 1,0,1
			],inf).coin.not,
			\accent, Pseq([
				1,0,0, 5,0,0, 1,0,0, 5,0,0
			],inf),
			\dur, 1/12,
			\gain, 0.31 * ( Pkey(\accent)/5+1 / 2 ),
		),
		
	])
)).play;
);

(
	// jazz drums + hiphop
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0, 0,0,1, 0,0,0, 1,0,0,
				0,0,1, 1,0,0, 1,0,0, 1,0,1,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1916].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1128].value,
			\isRest, Pseq([
				1,0,0, 1,0,1, 1,0,0, 1,0,1
			],inf).coin.not,
			\accent, Pseq([
				1,0,0, 5,0,0, 1,0,0, 5,0,0
			],inf),
			\dur, 1/12,
			\gain, 0.31 * ( Pkey(\accent)/5+1 / 2 ),
		),
		
	])
)).play;
);


//////////////////////////////////
//// swing sing sing

(
	// sing sing
~t = 120/2/60; TempoClock.default.tempo = ~t;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1036].value,
			\isRest, Pseq([
				1,0,0, 1,0,0, 1,0,0, 1,0,0,
				1,0,0, 1,0,0, 1,0,0, 1,0,1,
			],inf).coin.not,
			\legato, 2,
			\dur, 1/12,
			\gain, 0.1 * Pseq([
				1,0,0, 0.1,0,0, 0.3,0,1, 0.1,0,0.1,
				1,0,0, 0.1,0,0, 0.3,0,1, 0.4,0,0.1,
			],inf),
		),
		Pbind( // sing
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1624].value,
			\isRest, Pseq([
				1,0,0, 1,0,0,  1,0,1, 1,0,1,
				1,0,0, 1,0,1,  1,0,1, 1,0,1,
			],inf).coin.not,
			\legato, 2,
			\dur, 1/12,
			\gain, 0.1 * Pseq([
				1,0,0, 1,0,0, 0.2,0,1, 0.2,0,0.2,
				1,0,0, 0.2,0,1, 0.2,0,1, 0.2,0,0.2,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[28].value,
			\isRest, Pseq([
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
			],inf).coin.not,
			\legato, 2,
			\dur, 1/12,
			\gain, 0.11,
		),
		
	])
)).play;
);


////////////////////////////////
/////////// yt synthdef dnb

~t = 170/2/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0.5,0.5, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.05) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1090].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);


//////////////////////////
///////// breakbeat sample chopping

~t = 280/4/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					Pser([
						(0..2)+36,
						(0..2)+42,
						(0..2)+36,
						(0..2)+41,
						(0..2)+36,
					].flat,32-4),
					36,37,38,39,
				],4) - Pseq((0..32),inf).stutter(32*4)
				//Pseq([
					//Pser([
						//(0..5)+36,
					//].flat,16-4),
					//36,37,38,39,
				//],4),
			].flat,inf)/8 / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/8,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseq([
				//Pseg(Pseq([ 0, 1/16, ]+(0),1),1/16).repeat(8),
				Pseq([
					0,10,4,10, 8,10,10,16,
					20,18,0,19, 8,7,4,7,
					//0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3
					0,4,4,4, 8,10,4,0,
					4,4,0,16, 8,7,7,4,
					0,4,4,0, 8,10,4,4,
					17,16,0,16, 8,7,7,4,
					0,10,10,10, 8,10,10,16,
					17,16,0,16, 8,7,4,7,

					//16,16,16,16,
					//0,0,8,0, 0,8,0,8,
					//0,2,2,0, 8,2,0,8,
				],inf)/16,

				//Pseg(Pseq([ 0, 1/2, ]+0,1),1/2),
				//Pseg(Pseq([ 0, 1/2, ]+0,1),1/2),
				//Pseg(Pseq([ 0, 1/2, ]+1,1),1/2),
				//Pseg(Pseq([ 0, 1/2, ]+( 1/2 ),1),1/2),
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
	])
)).play;
);


//////////////////////
/////////// trap


~t = 140/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\kick808, {arg out = 0, freq1 = 240, freq2 = 60, amp = 0.1, ringTime = 100, rel = 10000, dist = 1.5, pan = 0, tott=0.1, durr=0.001, gate=1;
	var snd, env;
	snd = Ringz.ar(
		in: Impulse.ar(0), // single impulse
		freq: XLine.ar(freq1, freq2, \glisdur.kr(0.1)),
		decaytime: ringTime);
	//env = EnvGen.ar(Env.perc(0.001, rel, amp), doneAction: 2);
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	snd = (1.0 - dist) * snd + (dist * (snd.distort));
	snd = snd * env * \gain.kr(0.2);
	snd = Limiter.ar(snd, tott, durr) * 1.5 *(1/tott);
	snd = snd * EnvGen.kr(\adsr2.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:0);
	//snd = Clip.ar(snd, -1 * tott, tott);
	//	snd = Fold.ar(snd, -1 * tott, tott);
	//	snd = Wrap.ar(snd, -1 * tott, tott);
	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
)


(
	// base
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[198].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,1,1,1, 1,0,0,0,
			],inf).coin.not,
			\lag, 0.03, // bounce
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \kick808,
			\note, Pseq([
				Pstep(Pseq([
					10,10,10,8,
				],1),4),
			],inf),
			\octave, 2,
			\freq2, Pkey(\freq),
			\legato, Pseq([
				6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,4,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

/////////////////////////////
////////// fear not a man


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1568].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1124].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\velo, Pseq([
				0,1,3,3, 1,3,0,1,
				1,1,3,3, 1,1,1,1,
			],inf),
			\legato, 1/2 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 4,1,1,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\bufnum, Pfunc({ arg ev;
				~buflib.hat[1360 + ev[\velo]].value
			}),
			\isRest, Pseq([
				0,0,1,1, 0,1,0,0,
				0,0,1,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);


/////////// flam

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1637].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\lag, Pseq([
				[0,-0.035],0,0,0, 0,0,0,0,
			],inf),
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				[1,1/4],1,1/2,1, 1/2,1,1/2,1,
			],inf),
		),
		
	])
)).play;
);


///////
///////////////////////// punk drums
~t = 200/2/60; TempoClock.default.tempo = ~t;
~t = 250/2/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[480].value,
			\bufnum, ~buflib.kick[1059].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				Pwhite(0.9,1,1),
				Phprand(0.5,1,1),
				Phprand(0.4,1,1),
				Pexprand(0.2,0.7,1),
			],inf).stutter(2),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1631].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1131].value,
			\bufnum, ~buflib.hat[119].value,
			\bufnum, [
				~buflib.hat[253].value,
				~buflib.hat[119].value,
			],
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\velo, Pseg(Pseq([0,0,1],1),4).loop,
			\legato, Pkey(\velo).linlin(0,1,0.1,2),
			\gain, 0.11 * Pkey(\velo).linlin(0,1,0.3,1/2),
		),
	])
)).play;
);

(
	~swing = 0.32;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[480].value,
			\bufnum, ~buflib.kick[1059].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0.91,0, 0,0,0.51,0,
				1,0,0.51,0, 0,0,0.21,0,
			],inf).coin.not,
			\gain, 0.1 * Pseq([
				Phprand(0.9,1,1),
				Phprand(0.2,0.5,1),
				Phprand(0.4,1,1),
				Pexprand(0.1,0.5,1),
				Phprand(0.4,1,1),
				Phprand(0.2,0.5,1),
				Phprand(0.4,1,1),
				Pexprand(0.1,0.5,1),
			],inf).stutter(2),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,0,-1,0],inf))),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1631].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1131].value,
			\bufnum, ~buflib.hat[119].value,
			\bufnum, [
				~buflib.hat[253].value,
				~buflib.hat[119].value,
			],
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,0,-1,0],inf))),
			\velo, Pseg(Pseq([0,0,1],1),4).loop,
			\legato, Pkey(\velo).linlin(0,1,0.1,2),
			\gain, 0.11 * Pkey(\velo).linlin(0,1,0.3,1/2),
		),
	])
)).play;
);
