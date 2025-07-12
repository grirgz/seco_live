(
~t = 138/4/60; TempoClock.default.tempo = ~t; // freedom fighter
FileSystemProject.load("capsule/fxheavy.scd");
SynthDef(\melead, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([1,142,1],[0.01,0.1])), 1);
	sig = LFPulse.ar(freq * [1,1.001]).sum;
	//sig = sig + FreqShift.ar(sig, freq*2);
	sig = sig + FreqShift.ar(sig, \shiftfac.kr(0.1) * env1);
	sig = BPF.ar(sig, ( freq * \bpfac.kr(1) ).clip(20,19000), \rq.kr(0.1) * env1);
	sig = sig * 0.7;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\fxringer, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = RHPF.ar(sig, \lpf.kr(1000), \rq.kr(0.5));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\clochete, { arg out=0, gate=1, freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = Dust.ar(10 * SinOsc.kr(1/8).range(10,1/2));
	sig1 = Ringz.ar(sig1, rrand(100,10000.0!8) * LFNoise0.kr(1/2).range(1/4,1), 1.1).mean/2;
	sig2 = Dust.ar(7);
	sig2 = Ringz.ar(sig2, rrand(100,10000.0!8), 1.1).mean/2;
	sig = sig1 + sig2;
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\blitz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var fspread;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var ofreq = freq;
	sig1 = LFSaw.ar(freq * Latch.kr( WhiteNoise.ar(4),Impulse.kr( SinOsc.ar(1/4).range(1,8) )));
	//sig1 = LPF.ar(sig1, SinOsc.ar(10).range(10,1000) );
	sig1 = sig1 * LFPulse.ar(freq);
	fspread = SinOsc.ar(freq) * 0.01;
	sig2 = Duty.ar(fspread * 10, 0, Dseq([
		1000,340,5400,2390,
	],inf));
	freq = freq * [1,3/2,2,1/2];
	freq = LFSaw.ar(ofreq*2) * LFPulse.ar(sig2) * 0.07 + 1 * freq;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * ( sig1 * 1 + 1 ));
	sig = Saw.ar(freq* ( sig1 * 1 + 1 )) + sig;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + SinOsc.ar((1..sig.size),(1..sig.size));
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * 2;
	Out.ar(out, sig);
}).add;
)

(
~swing = -1*Pseg(Pseq([1/9,1/3],inf),8);
~swing = -1/6;
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					Pseq([
						0,-2,0,-2,
					],3),
					0,-2,-2,-3,
				],inf),
				\legato, Pseq([
						1,1,1,0, 1,0,1,0,
						1,0,1,1, 1,0,1,1,
						1,0,1,0, 1,1,1,0,
						1,1,1,0, 1,0,1,0,
						1,1,1,1, 1,1,1,1,
				],inf).linlin(0,1,0.2,0.5),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\lag, 0.04,
				\octave, 3,
				\lpf, 150,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\out, BusDef(\fx1, \audio),
				\amp, 0.1,
				\amp, Pkey(\amp) * Pfunc({ arg ev; ev[\legato]*2  }) * Pseq([1,0.7],inf),
			),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\isRest, Pseq([
					1,1,1,1, 0,0,1,1,
					1,0,1,1, 0,0,0,0,
					1,0,0,1, 1,1,1,0,
					1,1,1,1, 0,1,0,0,
				],inf).coin.not,
				\amp, 0.1 * Pseq([
					1,1/3,0.8,1/3,
				],inf),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,1,0,0, 1,0,0,1,
					0,1,0,0, 1,0,1,1,
					0,1,1,1, 1,0,0,1,
					0,0,0,0, 1,0,1,1,
			
				],inf).coin.not,
				\sustain, 0.1 * Pseq([
					1/2,1/3,1/4,1/3,
					1,1/3,1/2,1/3,
				],inf),
				\gain, 0.2,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\gain, 0.2 * Pseq([
					0.31,1/3,0.3,1/3,
					1,1/3,0.6,1/3,
				],inf),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					0,0, 1,0, 1,1, 0,1,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,0, 1,0, 1,0, 1,0,
				],inf).coin.not,
				\sustain, 0.10,
				\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
				\dur, 1/16,
				\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.2344889782792,
			'fb', 0.0002099467303085 * Pseq([
				1,2,
				1,20,
				1,2,
				1,200,
			],inf),
			'delay', 0.00010001231 * Pseq([
				1,1/20,100,
				1,1/20,100,
				1/20,100,
			],inf).stutter(1),
			'delay2', ~pmodenv.(Pseq([100,2,190,120,1/100,1/11,123,4] * 0.001,inf), 1/4, 1, -2),
		\delay2,0.0001 * Pseq([
			1,1/100,1000,
			1,1/100,4000,
		],inf),
			'distamp', 01.361836201538 * Pseq([
				1,20,1,2,
				2,1,4,20,
			],inf),
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
	])
)).play;
)


(
~swing = -1*Pseg(Pseq([1/9,1/3],inf),8);
~swing = -1/6;
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					Pseq([
						0,-2,0,-2,
					],3),
					0,-2,-2,-3,
				],inf),
				\legato, Pseq([
					3,0,0,1, 0,1,0,1,
					2,0,2,0, 0,1,0,0,
					1,0,0,1, 0,0,1,0,
				],inf).linlin(0,1,0,0.5),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\lag, 0.04,
				\octave, 3,
				\lpf, 150,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\out, BusDef(\fx1, \audio),
				\amp, 0.1,
				\amp, Pkey(\amp) * Pfunc({ arg ev; ev[\legato]*2  }) * Pseq([1,0.7],inf),
			),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\isRest, Pseq([
					1,1,1,1, 0,0,1,1,
					1,0,1,1, 0,0,0,0,
					1,0,0,1, 1,1,1,0,
					1,1,1,1, 0,1,0,0,
				],inf).coin.not,
				\amp, 0.1 * Pseq([
					1,1/3,0.8,1/3,
				],inf),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,1,0,0, 1,0,0,1,
					0,1,0,0, 1,0,1,1,
					0,1,1,1, 1,0,0,1,
					0,0,0,0, 1,0,1,1,
			
				],inf).coin.not,
				\sustain, 0.1 * Pseq([
					1/2,1/3,1/4,1/3,
					1,1/3,1/2,1/3,
				],inf),
				\gain, 0.2,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\gain, 0.2 * Pseq([
					0.31,1/3,0.3,1/3,
					1,1/3,0.6,1/3,
				],inf),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					0,0, 1,0, 1,1, 0,1,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,0, 1,0, 1,0, 1,0,
				],inf).coin.not,
				\sustain, 0.10,
				\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
				\dur, 1/16,
				\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				Pseq([
					0,
				],6+8),
				-2,
				-3,
			],inf),
			\octave, 5,
			\diff, 0.1,
			\fmr, Pseg(Pseq([1,2],inf),8),
			\env1, Pseq([
				[ Env([1,2,1]/2,[0.01,0.8],-1) ],
				[ Env([1,2,1]/2,[0.01,0.18],-1) ],
			],inf),
			\foldfreq, 100,
			\hpf, 3400,
			\lpfr, 3,
			\legato, Pseq([
					4,0,0,0, 0,1,0,0,
					0,1,0,0, 0,0,1,0,
					1,1,0,1, 0,1,1,0,
					0,3,0,0, 0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\amp, 0.1/2,
			//\lag, 0.04,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085 * Pseq([
				1,2,
				1,20,
				1,2,
				1,200,
			],inf),
			'delay', 0.00010001231 * Pseq([
				1,1/20,100,
				1,1/20,100,
				1/20,100,
			],inf).stutter(1),
			'delay2', ~pmodenv.(Pseq([100,2,190,120,1/100,1/11,123,4] * 0.001,inf), 1/4, 1, -2),
		\delay2,0.0001 * Pseq([
			1,1/100,1000,
			1,1/100,4000,
		],inf),
			'distamp', 01.361836201538 * Pseq([
				1,20,1,2,
				2,1,4,20,
			],inf),
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,5,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 21.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),

	])
)).play;
)

(
// cool beat!!!
~swing = -1*Pseg(Pseq([1/9,1/3],inf),8);
~swing = -1/6;
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,-2,-2, -2,-2,-3,-3,
				],inf),
				\legato, Pseq([
					Pseq([
						4,0,0,0, 0,0,0,0,
						0,0,2,0, 0,0,2,0,
					],3),
					4,0,0,0, 0,2,0,0,
					0,0,0,2, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),
			Pseq([
				Event.silent(8),
				Pbind(
					\instrument, \pluck,
					//\lag, 0.04,
					\note, Pseq([
						0,0,-2,-3,
					],inf).stutter(4),
					\isRest, Pseq([
						0,0,1, 0,0,1,
						1,0,0, 0,0,1,
						0,0,1, 0,0,0,
						0,0,0, 1,0,0,
						0,0,1, 0,0,0,
						0,0,1, 0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\lag, -0.04,
					\out, BusDef(\sendbus3, \audio),
					\amp, 0.1/10,
				),
			],1),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,1,0,
					1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,1,1,
				],inf).coin.not,
				\amp, 0.1 * Pseq([
					1,1/3,0.6,1/3,
				],inf),
				\hasGate, false,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,1,
					0,1,0,1, 1,0,0,1,
			
				],inf).coin.not,
				\sustain, 0.1 * Pseq([
					1/2,1/3,1/4,1/3,
					1,1/3,1/2,1/3,
				],inf),
				\gain, 0.2,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\gain, 0.2 * Pseq([
					0.31,1/3,0.3,1/3,
					1,1/3,0.6,1/3,
				],inf),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,1,
					0,1,0,1, 1,0,0,1,
				],inf).coin.not,
				\sustain, 0.1 * Pseq([
					1/2,1/3,1/4,1/3,
					1/3,1/3,1/2,1/3,
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\gain, 0.2,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\dur, 1/8,
				\lag, 1/16/~t,
				\gain, 0.2 * Pseq([
					0.31,1/3,0.3,1/3,
					1,1/3,0.6,1/3,
				],inf),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					0,0, 1,0, 1,1, 0,1,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,0, 1,0, 1,0, 1,0,
				],inf).coin.not,
				\sustain, 0.10,
				\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
				\dur, 1/16,
				\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				Pseq([
					0,
				],6+8),
				-2,
				-3,
			],inf),
			\octave, 5,
			\diff, 0.1,
			\fmr, Pseg(Pseq([1,2],inf),8),
			\env1, Pseq([
				[ Env([1,2,1]/2,[0.01,0.8],-1) ],
				[ Env([1,2,1]/2,[0.01,0.18],-1) ],
			],inf),
			\foldfreq, 100,
			\hpf, 3400,
			\lpfr, 3,
			\legato, Pseq([
					4,0,0,0, 0,1,0,0,
					0,1,0,0, 0,0,1,0,
					1,1,0,1, 0,1,1,0,
					0,3,0,0, 0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\amp, 0.1/2,
			//\lag, 0.04,
			\out, BusDef(\sendbus2, \audio),
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0002099467303085 * Pseq([
				1,2,
				1,20,
				1,2,
				1,200,
			],inf),
			'delay', 0.00010001231 * Pseq([
				1,1/20,100,
				1,1/20,100,
				1/20,100,
			],inf).stutter(1),
			'delay2', ~pmodenv.(Pseq([100,2,190,120,1/100,1/11,123,4] * 0.001,inf), 1/4, 1, -2),
		\delay2,0.0001 * Pseq([
			1,1/100,1000,
			1,1/100,4000,
		],inf),
			'distamp', 01.361836201538 * Pseq([
				1,20,1,2,
				2,1,4,20,
			],inf),
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0000002099467303085 * Pseq([
				1,2,
				1,20,
				1,2,
				1,2,
			],inf),
			'delay', 0.000010001231 * Pseq([
				1,1/20,100,
				1,1/20,100,
				1/20,100,
			],inf).stutter(1),
		\delay2,0.0001 * Pseq([
			1,1/100,1000,
			1,1/100,4000,
		],inf),
			'distamp', 01.361836201538 * Pseq([
				1,2,1,2,
				2,1,4,2,
				1,1,4,1,
				1,4,1,4,
			],inf),
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000 - Pseg(Pseq([0,10000],inf),7),
			'posthpf', 17217 - Pseg(Pseq([0,10000],inf),8),
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\out, BusDef(\sendbus4, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus4),
			\mix, 0.2 * Pseq([
				1,0, 0,1, 1,0, 2,2,
				1,1, 0,0, 1,0, 2,0,
			],inf),
			\fb, 0.01,
			\decay, 0.8,
			\decayfac, 0.01,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\out, BusDef(\sendbus5, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus5, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.85714285714286,
			'gain', 0.2344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.00000600001231 * Pseq([
				1,2, 1,40, 1,2, 10,2,
				1,2, 1,2, 1,2, 100,2,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/2,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.5344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.0000600001231 * Pseq([
				1,1/500,
				1,500,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),

	])
)).play;
)

Pdef(\part).clear;
(
// add pitch
~swing = -1*Pseg(Pseq([1/9,1/3],inf),8);
~swing = -1/6;
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,-2,-2, -2,-2,-3,-3,
				],inf),
				\legato, Pseq([
					Pseq([
						4,0,0,0, 0,0,0,0,
						0,0,2,0, 0,0,2,0,
					],3),
					4,0,0,0, 0,2,0,0,
					0,0,0,2, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),
			Pseq([
				//Event.silent(8),
				Plazy({ arg ev;
						var post = Pbind(
							\instrument, \pluck,
							//\lag, 0.04,
							\note, Pseq([
								0,0,-2,-3,
							],inf).stutter(4),
							\isRest, Pseq([
								0,0,1, 0,0,1,
								1,0,0, 0,0,1,
								0,0,1, 0,0,0,
								0,0,0, 1,0,0,
								0,0,1, 0,0,0,
								0,0,1, 0,0,0,
							],inf).coin.not,
							\dur, 1/8,
							\lag, -0.04,
							\out, BusDef(\sendbus3, \audio),
							\amp, 0.1/10,
						);
				
					Ptpar([
						8, Pbind(
							\instrument, \pluck,
						) <> post,
						12, Pbind(
							\instrument, \basicbass,
							\note, Pkey(\note) + Pseq([0,-2,3],inf),
							\lpf, 2000,
							\amp, 0.1/30,
							\notRest, Pseq([
								0,0,0,0,
								0,0,0,0,
								Pseq([
									1,0,0,0,
								],inf),
							],inf).coin,
							\isRest, Pfunc({ arg ev;
								ev[\isRest].not or: ev[\notRest]
							}).not,
							\octave, 7,
						) <> post,
					]);
				}).loop,

			],1),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,1,0,
					1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,1,1,
				],inf).coin.not,
				\amp, 0.1 * Pseq([
					1,1/3,0.6,1/3,
				],inf),
				\hasGate, false,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,1,
					0,1,0,1, 1,0,0,1,
			
				],inf).coin.not,
				\sustain, 0.1 * Pseq([
					1/2,1/3,1/4,1/3,
					1,1/3,1/2,1/3,
				],inf),
				\gain, 0.2,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\gain, 0.2 * Pseq([
					0.31,1/3,0.3,1/3,
					1,1/3,0.6,1/3,
				],inf),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,1,
					0,1,0,1, 1,0,0,1,
				],inf).coin.not,
				\sustain, 0.1 * Pseq([
					1/2,1/3,1/4,1/3,
					1/3,1/3,1/2,1/3,
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\gain, 0.2,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\dur, 1/8,
				\lag, 1/16/~t,
				\gain, 0.2 * Pseq([
					0.31,1/3,0.3,1/3,
					1,1/3,0.6,1/3,
				],inf),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					0,0, 1,0, 1,1, 0,1,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,0, 1,0, 1,0, 1,0,
				],inf).coin.not,
				\sustain, 0.10,
				\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
				\dur, 1/16,
				\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				Pseq([
					0,
				],6+8),
				-2,
				-3,
			],inf),
			\octave, 5,
			\diff, 0.1,
			\fmr, Pseg(Pseq([1,2],inf),8),
			\env1, Pseq([
				[ Env([1,2,1]/2,[0.01,0.8],-1) ],
				[ Env([1,2,1]/2,[0.01,0.18],-1) ],
			],inf),
			\foldfreq, 100,
			\hpf, 3400,
			\lpfr, 3,
			\legato, Pseq([
					4,0,0,0, 0,1,0,0,
					0,1,0,0, 0,0,1,0,
					1,1,0,1, 0,1,1,0,
					0,3,0,0, 0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\amp, 0.1/2,
			//\lag, 0.04,
			\out, BusDef(\sendbus2, \audio),
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0002099467303085 * Pseq([
				1,2,
				1,20,
				1,2,
				1,200,
			],inf),
			'delay', 0.00010001231 * Pseq([
				1,1/20,100,
				1,1/20,100,
				1/20,100,
			],inf).stutter(1),
			'delay2', ~pmodenv.(Pseq([100,2,190,120,1/100,1/11,123,4] * 0.001,inf), 1/4, 1, -2),
		\delay2,0.0001 * Pseq([
			1,1/100,1000,
			1,1/100,4000,
		],inf),
			'distamp', 01.361836201538 * Pseq([
				1,20,1,2,
				2,1,4,20,
			],inf),
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0000002099467303085 * Pseq([
				1,2,
				1,20,
				1,2,
				1,2,
			],inf),
			'delay', 0.000010001231 * Pseq([
				1,1/20,100,
				1,1/20,100,
				1/20,100,
			],inf).stutter(1),
		\delay2,0.0001 * Pseq([
			1,1/100,1000,
			1,1/100,4000,
		],inf),
			'distamp', 01.361836201538 * Pseq([
				1,2,1,2,
				2,1,4,2,
				1,1,4,1,
				1,4,1,4,
			],inf),
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000 - Pseg(Pseq([0,10000],inf),7),
			'posthpf', 17217 - Pseg(Pseq([0,10000],inf),8),
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\out, BusDef(\sendbus4, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus4),
			\mix, 0.2 * Pseq([
				1,0, 0,1, 1,0, 2,2,
				1,1, 0,0, 1,0, 2,0,
			],inf),
			\fb, 0.01,
			\decay, 0.8,
			\decayfac, 0.01,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\out, BusDef(\sendbus5, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus5, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.85714285714286,
			'gain', 0.2344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.00000600001231 * Pseq([
				1,2, 1,40, 1,2, 10,2,
				1,2, 1,2, 1,2, 100,2,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/2,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.5344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.0000600001231 * Pseq([
				1,1/500,
				1,500,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),

	])
)).play;
)

(
~swing = -1*Pseg(Pseq([1/9,1/3],inf),8);
~swing = -1/6;
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,-2,-2, -2,-2,-3,-3,
				],inf),
				\legato, Pseq([
					Pseq([
						4,0,0,0, 0,0,0,0,
						0,0,2,0, 0,0,2,0,
					],3),
					4,0,0,0, 0,2,0,0,
					0,0,0,2, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
				\isRest, true,
			),
				Pbind(
					\instrument, \rise,
					\degree, Pseq([0,-12],inf),
					\start, 8, \end, 2,
					\spstart, 10.01, \spend, 0.01,
					\legato, 2,
					\time, 4/~t,
					\isRest, Pseq([
						1,1,
					],inf).coin.not,
					\out, BusDef(\sendbus3, \audio),
					\dur, 4,
					\amp, 0.1,
				),
			Pseq([
				//Pmono(\brownbass,
					//\note, Pseq([
						//Pseq((0..7)).neg
					//],inf) + [0,12],
					//\octave, 3,
					//\amp, 0.1,
					//\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					//\out, BusDef(\sendbus3, \audio),
				//),
				Pbind(
					\instrument, \brownbass,
					\freq, ~pmodenv.(Pseq([
						50,50,40,
					],inf), Pseq([8,1,0],inf)),
					\octave, 3,
					\rq, Pseg(Pseq([0.84,0.1],inf),8),
					\lpfr, Pseg(Pseq([8,1,8],inf),4),
						\rq, Pseg(Pseq([0.4,0.05,1],inf),8),
						\lpfr, Pseg(Pseq([16,4,32,8],inf),4),
					\isRest, Pseq([
						1,1,1,0, 0,0,1,0,
					],inf).coin.not,
					\legato, Pseq([
						Pseq([
							2,0,0,0, 2,0,0,0,
							1,0,1,0, 0,0,2,0,
						],3),
							4,0,0,0, 1,0,1,0,
							0,1,1,0, 0,0,2,0,
						Pseq([
							4,0,0,0, 0,0,0,0,
							0,0,2,0, 0,0,2,0,
						],3),
						4,0,0,0, 0,2,0,0,
						0,0,0,2, 0,0,2,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\out, BusDef(\sendbus3, \audio),
					\amp, 0.3,
					\amp, Pkey(\amp) * Pseq([
						0.3,0.5,1,0.5,
					],inf),
				),
				Pbind(
					\instrument, \brownbass,
					\note, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,-2,-2, -2,-2,-3,-3,
					],inf) + [0,-5-12],
					\octave, 5,
					\rq, Pseg(Pseq([0.84,0.1],inf),8),
					\lpfr, Pseg(Pseq([8,1,8],inf),4),
						\rq, Pseg(Pseq([0.4,0.05,1],inf),8),
						\lpfr, Pseg(Pseq([16,4,32,8],inf),4),
					\isRest, Pseq([
						1,1,1,0, 0,0,1,0,
					],inf).coin.not,
					\legato, Pseq([
						Pseq([
							4,0,0,0, 0,0,0,0,
							0,0,2,0, 0,0,2,0,
						],3),
						4,0,0,0, 0,2,0,0,
						0,0,0,2, 0,0,2,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\out, BusDef(\sendbus3, \audio),
					\amp, 0.3,
					\amp, Pkey(\amp) * Pseq([
						0.3,0.5,1,0.5,
					],inf),
				),
				Event.silent(8),
				Pbind(
					\instrument, \pluck,
					//\lag, 0.04,
					\note, Pseq([
						0,0,-2,-3,
					],inf).stutter(4),
					\isRest, Pseq([
						0,0,1, 0,0,1,
						1,0,0, 0,0,1,
						0,0,1, 0,0,0,
						0,0,0, 1,0,0,
						0,0,1, 0,0,0,
						0,0,1, 0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\lag, -0.04,
					\out, BusDef(\sendbus3, \audio),
					\amp, 0.1/10,
				),
			],1),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1 * Pseq([
					1,1/3,0.6,1/3,
				],inf),
				\hasGate, false,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
			
				],inf).coin.not,
				\sustain, 0.1 * Pseq([
					1/2,1/3,1/4,1/3,
					1,1/3,1/2,1/3,
				],inf),
				\gain, 0.2,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\gain, 0.2 * Pseq([
					0.31,1/3,0.3,1/3,
					1,1/3,0.6,1/3,
				],inf),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,1,
					0,1,0,1, 1,0,0,1,
				],inf).coin.not,
				\sustain, 0.1 * Pseq([
					1/2,1/3,1/4,1/3,
					1/3,1/3,1/2,1/3,
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\gain, 0.2,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\dur, 1/8,
				\lag, 1/16/~t,
				\gain, 0.2 * Pseq([
					0.31,1/3,0.3,1/3,
					1,1/3,0.6,1/3,
				],inf),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					0,0, 1,0, 1,1, 0,1,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,0, 1,0, 1,0, 1,0,
				],inf).coin.not,
				\sustain, 0.10,
				\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
				\dur, 1/16,
				\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				Pseq([
					0,
				],6+8),
				-2,
				-3,
			],inf),
			\octave, 5,
			\diff, 0.1,
			\fmr, Pseg(Pseq([1,2],inf),8),
			\env1, Pseq([
				[ Env([1,2,1]/2,[0.01,0.8],-1) ],
				[ Env([1,2,1]/2,[0.01,0.18],-1) ],
			],inf),
			\foldfreq, 100,
			\hpf, 3400,
			\lpfr, 3,
			\legato, Pseq([
					4,0,0,0, 0,1,0,0,
					0,1,0,0, 0,0,1,0,
					1,1,0,1, 0,1,1,0,
					0,3,0,0, 0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\amp, 0.1/2,
			//\lag, 0.04,
			\out, BusDef(\sendbus2, \audio),
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0002099467303085 * Pseq([
				1,2,
				1,20,
				1,2,
				1,200,
			],inf),
			'delay', 0.00010001231 * Pseq([
				1,1/20,100,
				1,1/20,100,
				1/20,100,
			],inf).stutter(1),
			'delay2', ~pmodenv.(Pseq([100,2,190,120,1/100,1/11,123,4] * 0.001,inf), 1/4, 1, -2),
		\delay2,0.0001 * Pseq([
			1,1/100,1000,
			1,1/100,4000,
		],inf),
			'distamp', 01.361836201538 * Pseq([
				1,20,1,2,
				2,1,4,20,
			],inf),
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0000002099467303085 * Pseq([
				1,2,
				1,20,
				1,2,
				1,2,
			],inf),
			'delay', 0.000010001231 * Pseq([
				1,1/20,100,
				1,1/20,100,
				1/20,100,
			],inf).stutter(1),
		\delay2,0.0001 * Pseq([
			1,1/100,1000,
			1,1/100,4000,
		],inf),
			'distamp', 01.361836201538 * Pseq([
				1,2,1,2,
				2,1,4,2,
				1,1,4,1,
				1,4,1,4,
			],inf),
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000 - Pseg(Pseq([0,10000],inf),7),
			'posthpf', 17217 - Pseg(Pseq([0,10000],inf),8),
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\out, BusDef(\sendbus4, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus4),
			\mix, 0.2 * Pseq([
				1,0, 0,1, 1,0, 2,2,
				1,1, 0,0, 1,0, 2,0,
			],inf),
			\fb, 0.01,
			\decay, 0.8,
			\decayfac, 0.01,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\out, BusDef(\sendbus5, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus5, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.85714285714286,
			'gain', 0.2344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.00000600001231 * Pseq([
				1,2, 1,40, 1,2, 10,2,
				1,2, 1,2, 1,2, 100,2,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/2,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.5344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.0000600001231 * Pseq([
				1,1/500,
				1,500,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),

	])
)).play;
)


(
	r = Rest(0);
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,1,0, 0,0,0,0,
						1,0,1,0, 0,0,1,0,
						1,0,1,1, 0,1,0,0,
						1,0,1,0, 0,0,1,0,
						
						1,0,0,0, 0,0,0,0,
						1,0,1,0, 0,1,0,0,
						1,0,1,0, 0,0,1,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,0,0,0, 1,0,0,1,
						0,0,0,0, 1,0,0,1,
						0,0,0,0, 1,0,0,1,

						0,1,0,0, 1,0,0,1,
						0,0,0,0, 1,0,1,0,
						0,1,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
			
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1/3,1/3,1/2,1/3,
					],inf),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
			
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
			
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,
			
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
			
						0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\gain, 0.2,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\instrument, \playersec_hlpf,
				\bufnum, BufDef.mono('heavy/kick1.flac'),
				\bufnum, BufDef('heavy/kick1.flac'),
				\bufnum, BufDef(\amen),
				\isRest, Pseq([
					0,1, 1,1,
				],inf).coin.not,
				\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
				//\pos, 0.49,
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
				\gain, 0.15,
				\adsr, Prand([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
					[ Env.adsr(0.01,0.1,0.8,0.051) ],
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
					[ Env.adsr(0.1,0.1,0.8,0.01) ],
				],inf),
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\sustain, 0.1,
				\gain, Pkey(\gain) * Pseq([
					0.8, 0.2,
				],inf).stutter(1),
				\amp, 0.1,
			)),
		]),
		Pbind(
			\instrument, \brownbass,
			\note, Pseq([
				0,0,0,0,
				-1,-2,1,1,
			],inf)-8,
			\legato, Pseq([
				1,0,1,0, 2,0,1,0,
				2,0,0,0, 1,0,0,1,
				2,0,0,1/2, 2,0,0,0,
				2,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
			\note, Pseq([
				[9,4,3],
				[0,13],
				[1,-12],
				3,2,1,
			],inf)+4,
			\octave, 5,
			\dur, 1/3,
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.005,0.1,1.0,0.5) ],
				],1),
			],inf),
			\legato, Pseq([
					1,0,0, 1,1,0,
					1,0,0, 1,1,1,
			],inf) * 0.1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \pico,
			\degree, Pseq([
				0,2,4, [ 0,2,4 ],
				0,2,4, [ 0,2,4 ],
				3,5,7, [ 3,5-7,0 ],
				4,6,8, [ 4,6,1 ],
			],inf),
			\octave, Prand([4,5,6],inf),
			\isRest, Pseq([
				Plazy({ arg ev;
					Pseq([ 1,0,0,1, 1,0,1,0, ].scramble);
				}),
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			//\mtranspose, Pstep(Pseq([0,0,3,4],inf),1),
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\amp, 0.1/2,
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.25714285714286,
			'gain', 0.7344889782792,
			'fb', 0.000099467303085,
			'delay', 0.0000600001231 * Pseq([
			//	1,10,1000,100
			1
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 2.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			\limdelay, 0.0001,
			\endlimdelay, 0.02,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 1.344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.00000900001231 * Pseq([
			//	1,10,1000,100
			1,2,4
			],inf).stutter(1),
			'delay2', 0.200000543560101 * Pseq([
				4,3,2,1,
			],inf).stutter(8),
			'distamp', 7.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 1.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			\limdelay, 0.0001,
			\endlimdelay, 0.02,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.0000600001231 * Pseq([
			//	1,10,1000,100
			1
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 7.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 1.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
	])
)).play;
)
Pdef(\part).clear;

(
	r = Rest(0);
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\lag, 0.00, \out, BusDef(\sendbus5, \audio)) <>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,1, 0,0,1,0,
					1,0,0,0, 0,1,0,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,1, 0,0,1,0,
					1,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1 * Pseq([
					1/2,1/3,1/4,1/3,
					1,1/3,1/2,1/3,
				],inf),
				\gain, 0.2,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\gain, 0.2 * Pseq([
					0.31,1/3,0.3,1/3,
					1,1/3,0.6,1/3,
				],inf),
			)),
		]),
		Pbind(\out, BusDef(\bus1, \audio)) <>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,0,0, 0,1,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,0,1,
					1,0,1,0, 1,1,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			)),
			Pbind(
				\instrument, \plastic,
				\freq, 2000,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\legato, Pseq([
					14,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					14,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1/2,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,1, 1,1,0,0,
					0,0,1,0, 0,1,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\bus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,100
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 71.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 7700,
			'fbdistamp', 74.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 10000,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,1,0, 0,0,0,0,
						1,0,1,0, 0,0,1,0,
						1,0,1,1, 0,1,0,0,
						1,0,1,0, 0,0,1,0,
						
						1,0,0,0, 0,0,0,0,
						1,0,1,0, 0,1,0,0,
						1,0,1,0, 0,0,1,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,0,0,0, 1,0,0,1,
						0,0,0,0, 1,0,0,1,
						0,0,0,0, 1,0,0,1,

						0,1,0,0, 1,0,0,1,
						0,0,0,0, 1,0,1,0,
						0,1,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
			
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1/3,1/3,1/2,1/3,
					],inf),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
			
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
			
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,
			
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
			
						0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\gain, 0.2,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\instrument, \playersec_hlpf,
				\bufnum, BufDef.mono('heavy/kick1.flac'),
				\bufnum, BufDef('heavy/kick1.flac'),
				\bufnum, BufDef(\amen),
				\isRest, Pseq([
					0,1, 1,1,
				],inf).coin.not,
				\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
				//\pos, 0.49,
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
				\gain, 0.15,
				\adsr, Prand([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
					[ Env.adsr(0.01,0.1,0.8,0.051) ],
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
					[ Env.adsr(0.1,0.1,0.8,0.01) ],
				],inf),
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\sustain, 0.1,
				\gain, Pkey(\gain) * Pseq([
					0.8, 0.2,
				],inf).stutter(1),
				\amp, 0.1,
			)),
		]),
		Pbind(
			\instrument, \brownbass,
			\note, Pseq([
				0,0,0,0,
				-1,-2,1,1,
			],inf)-8,
			\legato, Pseq([
				1,0,1,0, 2,0,1,0,
				2,0,0,0, 1,0,0,1,
				2,0,0,1/2, 2,0,0,0,
				2,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
			\note, Pseq([
				[9,4,3],
				[0,13],
				[1,-12],
				3,2,1,
			],inf)+4,
			\octave, 5,
			\dur, 1/3,
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.005,0.1,1.0,0.5) ],
				],1),
			],inf),
			\legato, Pseq([
					1,0,0, 1,1,0,
					1,0,0, 1,1,1,
			],inf) * 0.1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus3, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \pico,
			\degree, Pseq([
				0,2,4, [ 0,2,4 ],
				0,2,4, [ 0,2,4 ],
				3,5,7, [ 3,5-7,0 ],
				4,6,8, [ 4,6,1 ],
			],inf),
			\octave, Prand([4,5,6],inf),
			\isRest, Pseq([
				Plazy({ arg ev;
					Pseq([ 1,0,0,1, 1,0,1,0, ].scramble);
				}),
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			//\mtranspose, Pstep(Pseq([0,0,3,4],inf),1),
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\amp, 0.1/2,
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.25714285714286,
			'gain', 0.7344889782792,
			'fb', 0.000099467303085,
			'delay', 0.0000600001231 * Pseq([
			//	1,10,1000,100
			1
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 2.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			\limdelay, 0.0001,
			\endlimdelay, 0.02,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 1.344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.00000900001231 * Pseq([
			//	1,10,1000,100
			1,2,4
			],inf).stutter(1),
			'delay2', 0.200000543560101 * Pseq([
				4,3,2,1,
			],inf).stutter(8),
			'distamp', 7.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 1.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			\limdelay, 0.0001,
			\endlimdelay, 0.02,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.0000600001231 * Pseq([
			//	1,10,1000,100
			1
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 7.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 1.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
		Pmono(\ringz,
			\inbus, BusDef(\sendbus5, \audio, 2),
			\mix, 1,
			\ringfac, 1,
			\decayfac, 1.8,
			\ringtab, Pseq([
				[ exprand(100,10000.0!8) ]
			],inf),
			\ringtab, Pseq([
				[ [ 1200,2000,3000,2700, 2800,9000,10000,7000, ] ],
				[ [ 1200,2000,3000,2300, 2500,9700,11000,6700, ] ]
			],inf) + Pfunc({ arg ev;
				[ 100.0.dup(8).rand ]
			}),
			\decaytab, Pseq([
				Pfunc({ arg ev;
					[ exprand(0.1,1.0!8) ]
				}),
			],inf),
			\wetgain, 0.5,
			\gain, 1/2,
			\dur, 1/2,
			\out, BusDef(\sendbus6, \audio),
		),
		Pmono(\fx_freqshift,
			\inbus, BusDef(\sendbus6),
			\shift, ~pmodenv.(Pseq([1000,20,-100,400],inf), 2),
			\dur, 1,
		),
	])
)).play;
)

(
	r = Rest(0);
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,1,0, 0,0,0,0,
						1,0,1,0, 0,0,1,0,
						1,0,1,1, 0,1,0,0,
						1,0,1,0, 0,0,1,0,
						
						1,0,0,0, 0,0,0,0,
						1,0,1,0, 0,1,0,0,
						1,0,1,0, 0,0,1,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,0,0,0, 1,0,0,1,
						0,0,0,0, 1,0,0,1,
						0,0,0,0, 1,0,0,1,

						0,1,0,0, 1,0,0,1,
						0,0,0,0, 1,0,1,0,
						0,1,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
			
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1/3,1/3,1/2,1/3,
					],inf),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
			
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
			
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,
			
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
			
						0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\gain, 0.2,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\instrument, \playersec_hlpf,
				\bufnum, BufDef.mono('heavy/kick1.flac'),
				\bufnum, BufDef('heavy/kick1.flac'),
				\bufnum, BufDef(\amen),
				\isRest, Pseq([
					0,1, 1,1,
				],inf).coin.not,
				\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
				//\pos, 0.49,
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
				\gain, 0.15,
				\adsr, Prand([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
					[ Env.adsr(0.01,0.1,0.8,0.051) ],
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
					[ Env.adsr(0.1,0.1,0.8,0.01) ],
				],inf),
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\sustain, 0.1,
				\gain, Pkey(\gain) * Pseq([
					0.8, 0.2,
				],inf).stutter(1),
				\amp, 0.1,
			)),
		]),
		Pbind(
			\instrument, \brownbass,
			\note, Pseq([
				0,0,0,0,
				-1,-2,1,1,
			],inf)-8,
			\legato, Pseq([
				1,0,1,0, 2,0,1,0,
				2,0,0,0, 1,0,0,1,
				2,0,0,1/2, 2,0,0,0,
				2,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.25714285714286,
			'gain', 0.7344889782792,
			'fb', 0.000099467303085,
			'delay', 0.0000600001231 * Pseq([
			//	1,10,1000,100
			1
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 2.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			\limdelay, 0.0001,
			\endlimdelay, 0.02,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 1.344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.00000900001231 * Pseq([
			//	1,10,1000,100
			1,2,4
			],inf).stutter(1),
			'delay2', 0.200000543560101 * Pseq([
				4,3,2,1,
			],inf).stutter(8),
			'distamp', 7.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 1.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			\limdelay, 0.0001,
			\endlimdelay, 0.02,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.0000600001231 * Pseq([
			//	1,10,1000,100
			1
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 7.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 1.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),

		//////////////////////


		Pmono(\blitz,
			\note, Pstep(Pseq([
				0,0,0,0,
				-1,-2,1,1,
			],inf),1/4)-8,
			\octave, Pseq([
				Pser([
					8,7,4,
				],2*8),
				Pseq([
					8,8,7,8,
					7,6,7,4,
				],2),
				Pseq([
					8,8,8,8,
					4,4,4,4,
				],2),
			],inf).stutter(1),
			\dur, PdurStutter(Pseq([1,4,2,8],inf), Pseq([
				1,2,1,1/2,1/2
				
			],inf)),
			\amp, 0.071,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\fxringer,
			\inbus, BusDef(\fx1, \audio),
			\rq, 0.1,
			\lpf, Pseq([
				200,400,
				200,800,
			],inf)*2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fx2, \audio),
		),
		Pmono(\fx_freqshift,
			\inbus, BusDef(\fx2),
			\shift, Pseq([
				//1000,100,
				1,1,500,1,1,500,1,10,
			],inf),
			\out, BusDef(\fx3, \audio),
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\fx3, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,1,
				1,1/10
			],inf).stutter(1),
			'delay2', 0.210000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 54.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 170,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
	])
)).play;
)

// multiband fx!!!
(
	Pdef(\part, Pdef(\plop, 
		Ppar([

			// drums

			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,1,0, 0,0,0,0,
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
						1,0,1,0, 0,1,0,0,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,1,0,1, 1,1,0,1,
						0,1,0,0, 1,0,1,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1/3,1/3,1/2,1/3,
					],inf),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\gain, 0.2,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				Pbind(
					\instrument, \playersec_hlpf,
					\bufnum, BufDef(\amen),
					\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
					//\pos, 0.49,
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
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\sustain, 0.1,
					\gain, 0.15,
					\gain, Pkey(\gain) * Pseq([
						0.8, 0.2,
					],inf).stutter(1),
					\amp, 0.1,
				),
			]),
			// low
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.25714285714286,
				'gain', 1.4344889782792,
				'fb', 0.000099467303085,
				'delay', 0.0000600001231 * Pseq([
					//	1,10,1000,100
					1
				],inf).stutter(1),
				'delay2', 0.120000543560101,
				'distamp', 1.361836201538,
				'prelpf', 2900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 0.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				\limdelay, 0.0001,
				\endlimdelay, 0.02,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			// mid
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.25714285714286,
				'gain', 0.7344889782792,
				'fb', 0.000099467303085,
				'delay', 0.2000600001231 * Pseq([
					//	1,10,1000,100
					1/4
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19900,
				'prehpf', 1017,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 2.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				\limdelay, 0.0001,
				\endlimdelay, 0.02,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			// hi
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.25714285714286,
				'gain', 0.7344889782792,
				'fb', 0.000099467303085,
				'delay', 0.0000600001231 * Pseq([
					//	1,10,1000,100
					1
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19900,
				'prehpf', 11017,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 12.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				\limdelay, 0.0001,
				\endlimdelay, 0.02,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),


			// bass

		Pbind(
			\instrument, \brownbass,
			\note, Pseq([
				0,0,0,0,
				-1,-2,1,1,
			],inf)-8,
			\legato, Pseq([
				1,0,1,0, 2,0,1,0,
				2,0,0,0, 1,0,0,1,
				2,0,0,1/2, 2,0,0,0,
				2,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\bsendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\bsendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 1.344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.00000900001231 * Pseq([
			//	1,10,1000,100
			1,2,4
			],inf).stutter(1),
			'delay2', 0.200000543560101 * Pseq([
				4,3,2,1,
			],inf).stutter(8),
			'distamp', 7.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 1.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			\limdelay, 0.0001,
			\endlimdelay, 0.02,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),

		// hi

		Pbind(
			\instrument, \melead,
			\note, Pseq([
				0,0,0,0, 0,0,0,-5,
				-6,0,0,-6, -6,0,0,-6,
			],inf)-8+12,
			\legato, Pseq([
				2,0,0,1, 0,0,1,1,
				4,0,0,0, 1,1,0,0,
				4,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\out, BusDef(\csendbus1, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \melead,
			\note, Pseq([
				0,0,0,0, 0,0,0,-5,
				-6,0,0,-6, -6,0,0,-6,
			],inf)-8+12+12,
			\legato, Pseq([
				2,0,0,1, 0,0,1,1,
				4,0,0,0, 1,1,0,0,
				4,0,0,0, 0,0,0,1,
			],inf)/8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\lag, 1/8/~t,
			\out, BusDef(\csendbus1, \audio),
			\amp, 0.1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\csendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
			'distamp', 11.361836201538,
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
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\csendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.002099467303085,
			'delay', 0.700600001231 * Pseq([
				1,1/3,1/10,1/20,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 11.361836201538,
			'prelpf', 19900,
			'prehpf', 2017,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 7017,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),

		])
	)).play;
)

(
	Pdef(\part, Pdef(\plop, 
		Ppar([

			// drums

			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,1,0, 0,0,0,0,
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
						1,0,1,0, 0,1,0,0,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,1,0,1, 1,1,0,1,
						0,1,0,0, 1,0,1,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1/3,1/3,1/2,1/3,
					],inf),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\gain, 0.2,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				Pbind(
					\instrument, \playersec_hlpf,
					\bufnum, BufDef(\amen),
					\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
					//\pos, 0.49,
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
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\sustain, 0.1,
					\gain, 0.15,
					\gain, Pkey(\gain) * Pseq([
						0.8, 0.2,
					],inf).stutter(1),
					\amp, 0.1,
				),
			]),
			// low
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.25714285714286,
				'gain', 1.4344889782792,
				'fb', 0.000099467303085,
				'delay', 0.0010600001231 * Pseq([
					//	1,10,1000,100
					1
				],inf).stutter(1),
				'delay2', 0.120000543560101,
				'distamp', 1.361836201538,
				'prelpf', 2900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 0.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				\limdelay, 0.0001,
				\endlimdelay, 0.02,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			// mid
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.25714285714286,
				'gain', 0.7344889782792,
				'fb', 0.000099467303085,
				'delay', 0.2000600001231 * Pseq([
					//	1,10,1000,100
					1/4
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19900,
				'prehpf', 1017,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 2.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				\limdelay, 0.0001,
				\endlimdelay, 0.02,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			// hi
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.25714285714286,
				'gain', 0.7344889782792,
				'fb', 0.000099467303085,
				'delay', 0.0000600001231 * Pseq([
					//	1,10,1000,100
					1
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19900,
				'prehpf', 11017,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 12.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				\limdelay, 0.0001,
				\endlimdelay, 0.02,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),


			// bass

		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,0,
				-1,-2,1,1,
			],inf),1/4)-8,
			\legato, Pseq([
				4,0,0,0, 1,0,0,1,
				6,0,0,0, 0,0,1,0,
				4,0,0,0, 0,0,0,1,
				4,0,0,0, 1,0,1,0,
			],inf)*0.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/4,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\amp, 0.1,
			\out, BusDef(\bsendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\bsendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 1.344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.00000900001231 * Pseq([
			//	1,10,1000,100
			1,2,4
			],inf).stutter(1),
			'delay2', 0.000000543560101 * Pseq([
				4,3,2,1,
			],inf).stutter(8),
			'distamp', 7.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 1.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			\limdelay, 0.0001,
			\endlimdelay, 0.02,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),

		// hi

		Pbind(
			\instrument, \melead,
			\note, Pseq([
				0,0,0,0, 0,0,0,-5,
				-6,0,0,-6, -6,0,0,-6,
			],inf)-8+12,
			\legato, Pseq([
				2,0,0,1, 0,0,1,1,
				4,0,0,0, 1,1,0,0,
				4,0,0,0, 0,0,0,1,
				2,0,0,1, 0,0,1,1,
				1,0,0,0, 1,1,0,0,
				2,0,0,0, 0,0,0,1,
				1,0,1,1, 0,0,1,1,
				1,1,0,0, 1,1,0,0,
				2,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\shiftfac, ~pmodenv.(Pseq([1,2,1,4]/4,inf), 1/3),
			\bpfac, ~pmodenv.(Pseq([1,2,1,4],inf), 1),
			\dur, 1/4,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\out, BusDef(\csendbus1, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \melead,
			\note, Pseq([
				0,0,0,0, 0,0,0,-5,
				-6,0,0,-6, -6,0,0,-6,
			],inf)-8+12+12,
			\legato, Pseq([
				2,0,0,1, 0,0,1,1,
				4,0,0,0, 1,1,0,0,
				4,0,0,0, 0,0,0,1,
			],inf)/8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\bpfac, ~pmodenv.(Pseq([1,2,1,4]/4,inf), 1.1),
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\lag, 1/8/~t,
			\out, BusDef(\csendbus1, \audio),
			\amp, 0.1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\csendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,2,
				1/2,2,
				1,2,
				1,4,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
			'distamp', 11.361836201538,
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
			\dur, 1/4,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\csendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.002099467303085,
			'delay', 0.700600001231 * Pseq([
				1,1/3,1/10,1/20,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 11.361836201538,
			'prelpf', 19900,
			'prehpf', 2017,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 7017,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),

		])
	)).play;
)

(
	Pdef(\part, Pdef(\plop, 
		Ppar([

			///////// drums

			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,1,0, 0,0,0,0,
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
						1,0,1,0, 0,1,0,0,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,1,0,1, 1,1,0,1,
						0,1,0,0, 1,0,1,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1/3,1/3,1/2,1/3,
					],inf),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\gain, 0.2,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				Pbind(
					\instrument, \playersec_hlpf,
					\bufnum, BufDef(\amen),
					\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
					//\pos, 0.49,
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
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\sustain, 0.1,
					\gain, 0.15,
					\gain, Pkey(\gain) * Pseq([
						0.8, 0.2,
					],inf).stutter(1),
					\amp, 0.1,
				),
			]),
			// lowfx
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.25714285714286,
				'gain', 1.4344889782792,
				'fb', 0.000099467303085,
				'delay', 0.0010600001231 * Pseq([
					//	1,10,1000,100
					1
				],inf).stutter(1),
				'delay2', 0.120000543560101,
				'distamp', 1.361836201538,
				'prelpf', 2900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 0.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				\limdelay, 0.0001,
				\endlimdelay, 0.02,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			// midfx
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.25714285714286,
				'gain', 0.7344889782792,
				'fb', 0.000099467303085,
				'delay', 0.2000600001231 * Pseq([
					//	1,10,1000,100
					1/4
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19900,
				'prehpf', 1017,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 2.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				\limdelay, 0.0001,
				\endlimdelay, 0.02,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			// hifx
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.25714285714286,
				'gain', 0.7344889782792,
				'fb', 0.000099467303085,
				'delay', 0.0000600001231 * Pseq([
					//	1,10,1000,100
					1
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19900,
				'prehpf', 11017,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 12.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				\limdelay, 0.0001,
				\endlimdelay, 0.02,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),


			/////////// bass

		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,0,
				-1,-2,1,1,
			],inf),1/4)-8,
			\legato, Pseq([
				4,0,0,0, 1,0,0,1,
				6,0,0,0, 0,0,1,0,
				4,0,0,0, 0,0,0,1,
				4,0,0,0, 1,0,1,0,
			],inf)*0.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/4,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\amp, 0.1,
			\out, BusDef(\bsendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\bsendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 1.344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.00000900001231 * Pseq([
			//	1,10,1000,100
			1,2,4
			],inf).stutter(1),
			'delay2', 0.000000543560101 * Pseq([
				4,3,2,1,
			],inf).stutter(8),
			'distamp', 7.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 1.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			\limdelay, 0.0001,
			\endlimdelay, 0.02,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),

		///////////// hi


		Pbind(\out, BusDef(\csendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec_looper,
				\bufnum, BufDef('voices/feynman.flac'),
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,1.1) ],
				],inf),
				\gain, 1/2,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec_looper,
				\bufnum, BufDef('voices/feynman.flac'),
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,1, 0,1,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\pos, 0.4,
				\gain, 1/2,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec_looper,
				\bufnum, BufDef('voices/feynman.flac'),
				\dur, 1/16,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					0,0,1,1, 0,1,0,0, 0,0,0,1, 0,0,1,0,
					1,0,0,1, 1,0,1,0, 0,1,0,0, 0,1,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\pos, 0.3,
				\gain, 1/2,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\dur, 1/8,
				\legato, 2,
				\pos, 2,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\gain, 1/2,
				\amp, 0.1,
			),
		]),

		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\csendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.2344889782792,
			'fb', 0.00002099467303085,
			'delay', 0.0000600001231 * Pseq([
				1,2,
				1/2,2,
				1,2,
				1,4,
			],inf).stutter(1),
			'delay2', 0.00000543560101,
			'distamp', 71.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			\fff, Pseq([1,1/3,1.3,1/8],inf),
			'lpf', 15900 * Pkey(\fff),
			'hpf', 7817 * Pkey(\fff),
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
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


//////

(
SynthDef(\granix, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum=0, pitch_stretch=1, pos=0, gdur=0.1;
	var sig;
	var clk = Impulse.ar(\gfreq.kr(100));
	pos = pos + LFNoise0.ar(\glfofreq.kr(2),mul:\glforange.kr(0.1)); 
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), gdur, pan, 1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\granixlfo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum=0, pitch_stretch=1, pos=0, gdur=0.1;
	var sig;
	var clk = Impulse.ar(\gfreq.kr(100) * LFNoise1.ar(19).range(1,10));
	pos = pos + LFNoise0.ar(\glfofreq.kr(2),mul:\glforange.kr(0.1)); 
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), gdur, pan, 1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \granixlfo,
			\bufnum, BufDef.mono('voices/feynman.flac'),
			\bufnum, BufDef.mono('heavy/kick1.flac'),
			\bufnum, BufDef.mono('fix4/snare1.flac'),
			\pos, 0.06,
			//\gfreq, ~pmodenv.(Pseq([1,50,60,10],inf), 1/2),
			\gfreq, ~pmodsynth.({ SinOsc.kr(13).range(30,1)  }),
			\gdur, 0.4181,
			\legato, Pseq([
				1,0,2,0, 0,0,1,0,
				4,0,0,0, 0,1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\pitch_stretch, ~pmodenv.(Pseq([1,2,1,4],inf), 2),
			\pitch_stretch, Pseq([
				1,1,1,1,
				1,1,2,2,
			],inf),
			\glforange, 0.009,
			\freq, 200,
			\gain, 2,
\lag, 0.04,
//					\out, BusDef(\sendbus1bass, \audio),
			\dur, 1/8,
		),

			///////// drums
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
					\out, BusDef(\sendbus1bass, \audio),
				),

				Pbind(\out, BusDef(\sendbus2, \audio)) <>
				Ppar([
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 8,
						\isRest, Pseq([
							1,1,1,1, 1,1,1,1,
							1,0,1,1, 0,1,0,1,
						],inf).coin.not,
						\sustain, 0.1,
						\dur, 1/8,
						\amp, 0.1 * Pseq([1,0.7],inf),
						\dur, 1/8 * (1 + (-1/12 * Pseq([-1,1],inf))),
					)),
					
				]),

			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,1,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0, 1,1, 1,0, 1,0,
						1,0, 1,0, 1,1, 1,0,
					],inf).coin.not,
					\sustain, 0.05,
					\fac1,0.1,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1/3,1/3,1/2,1/3,
					],inf),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\gain, 0.2,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
					\isRest, true,
				)),
				Pbind(
					\instrument, \playersec_hlpf,
					\bufnum, BufDef(\amen),
					\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
					//\pos, 0.49,
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
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\sustain, 0.1,
					\gain, 0.15,
					\gain, Pkey(\gain) * Pseq([
						0.8, 0.2,
					],inf).stutter(1),
					\amp, 0.1,
					\isRest, true,
				),
			]),
			// lowfx
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1bass, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 1.4344889782792,
				'fb', 0.000099467303085,
				'delay', 0.0000600001231 * Pseq([
					//	1,10,1000,100
					1
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 0.361836201538,
				'prelpf', 2900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 0.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 1900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				\limdelay, 0.0001,
				\endlimdelay, 0.02,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			// midfx
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.25714285714286,
				'gain', 1.4344889782792,
				'fb', 0.000099467303085,
				'delay', 0.000100001231 * Pseq([
					//	1,10,1000,100
					1
				],inf).stutter(1),
				'delay2', 0.0000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 2900,
				'prehpf', 1317,
				'lpf', 9900,
				'hpf', 17,
				'fbdistamp', 0.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 8017,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				\limdelay, 0.0001,
				\endlimdelay, 0.02,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			// hifx
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.25714285714286,
				'gain', 0.7344889782792,
				'fb', 0.000099467303085,
				'delay', 0.0000600001231 * Pseq([
					//	1,10,1000,100
					1
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19900,
				'prehpf', 1110,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 12.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', Pseg(Pseq([100,18000],inf),Pseq([2,0],inf)),
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				\limdelay, 0.0001,
				\endlimdelay, 0.02,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
	])
)).play;
)



Pdef(\part).clear;

(
SynthDef(\simplepad, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var fmcar;
	fmcar = LFNoise0.kr(1/9!8).range(0.5,1.5);
	fmcar = SelectX.kr(\fmcarmix.kr(1), [1, fmcar]);
	env1 = EnvGen.kr(Env([0.1,1,4]/8,[1.1,0.8]), 1) * \fmamp.kr(1);
	sig = Formant.ar(freq* ( LFNoise1.kr(1/9!8) * env1 + fmcar ), 700 , 1000);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\formbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var fmcar;
	var spread = [1,1];
	fmcar = LFNoise0.kr(1/9!8).range(0.5,1.5);
	fmcar = SelectX.kr(\fmcarmix.kr(1), [1, fmcar]);
	env1 = EnvGen.kr(Env([0.1,1,4]/8,[1.1,0.8]), 1) * \fmamp.kr(1);
	sig = Formant.ar(freq * spread, freq  * spread, freq*2.1 * spread);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\fx_gverb, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = GVerb.ar(sig, roomsize:1, revtime:3);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,1.01),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \simplepad,
			\note, Pseq([
				0,2,3,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1/~t) ],
			],inf),
			\legato, 1/2,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\sendbus1),
		),
		Pbind(
			\instrument, \simplepad,
			\note, Pseq([
				0,2,3,
			],inf),
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1/~t) ],
			],inf),
			\legato, 1/2,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1),
			\isRest, true,
		),
		Pbind(
			\instrument, \formbass,
			\note, Pseq([
				0,2,3,
			],inf),
			\octave, 3,
			\fmamp, 0,
			\fmcarmix, 0,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1/~t) ],
			],inf),
			\legato, 1/2,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1/2,
			\out, BusDef(\sendbus1),
		),

		Pmono(\fx_gverb,
			\inbus, BusDef(\sendbus1),
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.400600001231 * Pseq([
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
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\out, BusDef(\sendbus3, \audio),
			\amp, 0.1/2,
		),
		Pbind(\out, BusDef(\sendbus3, \audio)) <>
		Ppar([
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
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 1.4,
			\speed, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		)),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
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
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pspawner({ arg sp;
			sp.par(
				Pbind(
					\instrument, \simplepad,
					\note, Pseq([
						0,2,3,
					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,1.1/~t) ],
					],inf),
					\legato, 1/2,
					\dur, 4,
					\amp, 0.1,
					\out, BusDef(\sendbus1),
				)
			);
			sp.wait(2);
			sp.par(Pbind(
				\instrument, \simplepad,
				\note, Pseq([
					0,2,3,
				],inf),
				\octave, 6,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,1.1/~t) ],
				],inf),
				\legato, 1/2,
				\isRest, Pseq([
					1,0,
				],inf).coin.not,
				\dur, 1/4,
				\amp, 0.1,
				\out, BusDef(\sendbus1),
				\isRest, true,
			));
			sp.wait(2);
			sp.par(Pbind(
				\instrument, \formbass,
				\note, Pseq([
					0,2,3,
				],inf),
				\octave, 3,
				\fmamp, 0,
				\fmcarmix, 0,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,1.1/~t) ],
				],inf),
				\legato, 1/2,
				\isRest, Pseq([
					1,0,
				],inf).coin.not,
				\dur, 1/4,
				\amp, 0.1/2,
				\out, BusDef(\sendbus1),
			));

			sp.wait(2);
			sp.par(Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus3, \audio),
				\amp, 0.1/2,
			));
			sp.wait(2);
			sp.par(
			Pbind(\out, BusDef(\sendbus3, \audio)) <>
			Ppar([
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
			]));
			sp.wait(2);
			sp.par(PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 1.4,
				\speed, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus3, \audio),
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			)));

		}),

		Pmono(\fx_gverb,
			\inbus, BusDef(\sendbus1),
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.400600001231 * Pseq([
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
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
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
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pseq([
			Pfindur(16, Ptpar([
				0,Pbind(
					\instrument, \formbass,
					\freq, 80,
					\dur, 8,
					\amp, 0.1,
				),
				5/3,Pbind(
					\instrument, \formbass,
					\freq, 67,
					\dur, Pseq([9, 7],inf),
					\amp, 0.1,
				),
				10/3,Pbind(
					\instrument, \simplepad,
					\freq, 367,
					\adsr, Pseq([
						[ Env.adsr(10.1,0.1,0.8,10.1) ],
					],inf),
					\dur, Pn(8,1),
					\amp, 0.1,
				),
			])),
			Pfindur(32, 
				Pbind( \out, BusDef(\sendbus2, \audio), ) <>
				Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\out, BusDef(\sendbus3, \audio),
					\amp, 0.1/2,
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
			])),
		],1),

		Pmono(\fx_gverb,
			\inbus, BusDef(\sendbus1),
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.400600001231 * Pseq([
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
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
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


///////////:::

(
// cool beat with more hi for drums
~swing = -1*Pseg(Pseq([1/9,1/3],inf),8);
~swing = -1/6;
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,-2,-2, -2,-2,-3,-3,
				],inf),
				\legato, Pseq([
					Pseq([
						4,0,0,0, 0,0,0,0,
						0,0,2,0, 0,0,2,0,
					],3),
					4,0,0,0, 0,2,0,0,
					0,0,0,2, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),
			Pseq([
				//Event.silent(8),
				Plazy({ arg ev;
						var post = Pbind(
							\instrument, \pluck,
							//\lag, 0.04,
							\note, Pseq([
								0,0,-2,-3,
							],inf).stutter(4),
							\isRest, Pseq([
								0,0,1, 0,0,1,
								1,0,0, 0,0,1,
								0,0,1, 0,0,0,
								0,0,0, 1,0,0,
								0,0,1, 0,0,0,
								0,0,1, 0,0,0,
							],inf).coin.not,
							\dur, 1/8,
							\lag, -0.04,
							\out, BusDef(\sendbus3, \audio),
							\amp, 0.1/10,
						);
				
					Ptpar([
						8, Pbind(
							\instrument, \pluck,
						) <> post,
						12, Pbind(
							\instrument, \basicbass,
							\note, Pkey(\note) + Pseq([0,-2,3],inf),
							\lpf, 2000,
							\amp, 0.1/30,
							\notRest, Pseq([
								0,0,0,0,
								0,0,0,0,
								Pseq([
									1,0,0,0,
								],inf),
							],inf).coin,
							\isRest, Pfunc({ arg ev;
								ev[\isRest].not or: ev[\notRest]
							}).not,
							\octave, 7,
						) <> post,
					]);
				}).loop,

			],1),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,1,0,
					1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,1,1,
				],inf).coin.not,
				\amp, 0.1 * Pseq([
					1,1/3,0.6,1/3,
				],inf),
				\hasGate, false,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,1,
					0,1,0,1, 1,0,0,1,
			
				],inf).coin.not,
				\sustain, 0.1 * Pseq([
					1/2,1/3,1/4,1/3,
					1,1/3,1/2,1/3,
				],inf),
				\gain, 0.2,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\gain, 0.2 * Pseq([
					0.31,1/3,0.3,1/3,
					1,1/3,0.6,1/3,
				],inf),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,1,
					0,1,0,1, 1,0,0,1,
				],inf).coin.not,
				\sustain, 0.1 * Pseq([
					1/2,1/3,1/4,1/3,
					1/3,1/3,1/2,1/3,
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\gain, 0.2,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\dur, 1/8,
				\lag, 1/16/~t,
				\gain, 0.2 * Pseq([
					0.31,1/3,0.3,1/3,
					1,1/3,0.6,1/3,
				],inf),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					0,0, 1,0, 1,1, 0,1,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					1,0, 1,0, 1,0, 1,0,
				],inf).coin.not,
				\sustain, 0.10,
				\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
				\dur, 1/16,
				\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				Pseq([
					0,
				],6+8),
				-2,
				-3,
			],inf),
			\octave, 5,
			\diff, 0.1,
			\fmr, Pseg(Pseq([1,2],inf),8),
			\env1, Pseq([
				[ Env([1,2,1]/2,[0.01,0.8],-1) ],
				[ Env([1,2,1]/2,[0.01,0.18],-1) ],
			],inf),
			\foldfreq, 100,
			\hpf, 3400,
			\lpfr, 3,
			\legato, Pseq([
					4,0,0,0, 0,1,0,0,
					0,1,0,0, 0,0,1,0,
					1,1,0,1, 0,1,1,0,
					0,3,0,0, 0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\amp, 0.1/2,
			//\lag, 0.04,
			\out, BusDef(\sendbus2, \audio),
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0002099467303085 * Pseq([
				1,2,
				1,20,
				1,2,
				1,200,
			],inf),
			'delay', 0.00010001231 * Pseq([
				1,1/20,100,
				1,1/20,100,
				1/20,100,
			],inf).stutter(1),
			'delay2', ~pmodenv.(Pseq([100,2,190,120,1/100,1/11,123,4] * 0.001,inf), 1/4, 1, -2),
		\delay2,0.0001 * Pseq([
			1,1/100,1000,
			1,1/100,4000,
		],inf),
			'distamp', 01.361836201538 * Pseq([
				1,20,1,2,
				2,1,4,20,
			],inf),
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792,
			'fb', 0.0000002099467303085 * Pseq([
				1,2,
				1,20,
				1,2,
				1,2,
			],inf),
			'delay', 0.000010001231 * Pseq([
				1,1/20,100,
				1,1/20,100,
				1/20,100,
			],inf).stutter(1),
		\delay2,0.0001 * Pseq([
			1,1/100,1000,
			1,1/100,4000,
		],inf),
			'distamp', 01.361836201538 * Pseq([
				1,2,1,2,
				2,1,4,2,
				1,1,4,1,
				1,4,1,4,
			],inf),
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000 - Pseg(Pseq([0,10000],inf),7),
			'posthpf', 17217 - Pseg(Pseq([0,10000],inf),8),
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\out, BusDef(\sendbus4, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus4),
			\mix, 0.2 * Pseq([
				1,0, 0,1, 1,0, 2,2,
				1,1, 0,0, 1,0, 2,0,
			],inf),
			\fb, 0.01,
			\decay, 0.8,
			\decayfac, 0.01,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			\out, BusDef(\sendbus5, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus5, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.85714285714286,
			'gain', 0.2344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.00000600001231 * Pseq([
				1,2, 1,40, 1,2, 10,2,
				1,2, 1,2, 1,2, 100,2,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/2,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.5344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.0000600001231 * Pseq([
				1,1/500,
				1,500,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.85714285714286,
			'gain', 1.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.2000600001231 * Pseq([
				1,1/10,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 0.361836201538,
			'prelpf', 19000,
			'prehpf', 300,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000,
			'posthpf', 17,
			\bpmix, 0.51,
			\bpffac1, 108,
			\bprqfac1, 0.1,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.85714285714286,
			'gain', 1.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.0000600001231 * Pseq([
				1,1/10,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 0.361836201538,
			'prelpf', 19000,
			'prehpf', 5300,
			'lpf', 19000,
			'hpf', 170,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000,
			'posthpf', 170,
			\bpmix, 0.51,
			\bpffac1, 108,
			\bprqfac1, 0.1,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),

	])
)).play;
)



///////////////////////// ///////////////////////// ///////////////////////// /////////////////////////
///////////////////////// ///////////////////////// ///////////////////////// /////////////////////////
///////////////////////// ///////////////////////// ///////////////////////// /////////////////////////
// test fx delays
// too hard, ask or adjust manually



(
	r = Rest(0);
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \brownbass,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.091) ],
				],inf),
				\freq, 700,
				\sustain, 0.1/7,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
			Pbind(
				\instrument, \brownbass,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.091) ],
				],inf),
				\freq, 700,
				\sustain, 0.1/7,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
				\lag, 0.04,
			),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 1,
			'gain', 0.7344889782792,
			'fb', 0.001099467303085,
			'delay', 0.0000600001231 * Pseq([
			//	1,10,1000,100
			1
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
			\limdelay, 0.0001,
			\endlimdelay, 0.0154,
			'indelay', 0.0004,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
		),
	])
)).play;
)

