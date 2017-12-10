
Pdef(\part).clear
(
Pdef(\part, Pdef(\plop, 
	Ppar([
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,1,0,0, 1,1,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				1,1,0,0, 0,0,1,1, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.021,
			\speed, 1+Pseg(Pseq([0,1.1],inf),8),
			\gain, 0.4,
			\dur, 1/32,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\instrument, \playersec_looper,
			\trigfreq, ( ~t ) * Pseq([
				2,
			],inf),
			\speed, 1 * Pseq([
				1
			],inf),
			\pos, 5.70,
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 1/4/~t,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.041,
			\dur, 1/8,
			\gain, 0.1,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0, 1,1, 0,0, 1,0,
				1,0, 1,1, 1,1, 1,0,
			],inf).coin.not,
			\sustain, 0.05 * Pseq([1,1/2],inf),
			\dur, 1/16,
			\amp, 0.1,
		)),
	])
)).play;
)

{ SinOsc.ar(200) ! 2 * 0.1}.play;
PatKitDef(\ksh2).edit



(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


////////////////////////////



(
SynthDef(\basicbassglitch, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, glitch=1;
	var sig, sig1, sig2, sig3;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.2,1],[0.1,1.8]), 1);
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);

	env3 = EnvGen.kr(Env([14,1,33],[0.01,0.02],1), 1);
	env4 = Duty.kr(1/16/~t, 0, Dseq([
		1,0,1,0,
		0,0,0,1,
	],inf)).lag(0.01);
	sig1 = SinOsc.ar(freq * 1 * [1,2,5/3] * ( Pulse.ar([301,90,30]*10) * \fac1.kr(1.7) + 1 ));
	//sig1 = SinOsc.ar(freq*2)/2; 
	sig1 = sig1.tanh;
	sig1 = RLPF.ar(sig1, ( \lpffac.kr(1) * EnvGen.kr(Env([900,1200,431],[0.01,0.08],1), 1) ).clip(20,20000), 0.5);
	env2 = EnvGen.kr(Env([0,glitch,0],[0.1,0.8]), 1);

	sig = sig / 2;
	sig = BPF.ar(sig, freq * env1, 0.1).tanh + sig;

	//sig = sig;
	sig = RLPF.ar(sig, \lpf.kr(100) * \lpffac.kr, \rq.kr(0.5));
	sig = SelectX.ar(env2, [sig, sig1]);
	sig.debug("basicbas");
	sig = TScramble.ar(sig, Impulse.kr(2),0.01);
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	Out.ar(out, sig);
}).add;
SynthDef(\basicbassglitch2, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, glitch=1;
	var sig, sig1, sig2, sig3;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.2,1],[0.1,1.8]), 1);
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);

	sig = sig / 2;
	sig = BPF.ar(sig, freq * env1, 0.1).tanh + sig;

	//sig = sig;
	sig = RLPF.ar(sig, \lpf.kr(100) * \lpffac.kr, \rq.kr(0.5));

	sig1 = sig;
	sig1 = CombL.ar(sig1, 1/freq * Pulse.ar(1).range(2,1),1) + sig1;
	sig1 = FreqShift.ar(sig1, -1* Pulse.ar(1).range(2,1)) + sig1;
	sig = SelectX.ar( EnvGen.kr(Env([glitch,0.0,1],[0.3,1.2],-1), 1), [sig, sig1]);
	sig.debug("basicbas");
	sig = TScramble.ar(sig, Impulse.kr(2),0.01);
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \basicbassglitch2,
			\note, Pseq([
				0,1,
			],inf),
			\legato, Pseq([
					1,1,2,0,
					4,0,0,0,
			],inf),
			\fac1, ~pmodenv.(Pseq([1,4,8,16,100],inf), 7),
			\lpffac, ~pmodenv.(Pseq([1,4,8,16,100],inf), 8),
			\rq, ~pmodenv.(Pseq([0.5,0.1,0.9],inf), 8),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\glitch, Pseq([0,1],inf).stutter(4),
			\glitch, Pseq([
				0,0,0,0,
				1,0,0,0,
				0,0,1,0,
				1,0,0,0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		);
	])
)).play;
)

/////////////////////




(
SynthDef(\basicbassglitch3, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, glitch=1, lpffac=1;
	var sig, sig1, sig2, sig3;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.04,1.8]), 1);
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);

	sig = sig / 2;
	sig = BPF.ar(sig, freq * env1, 0.1, mul: EnvGen.kr(Env([0,1,0,10],[0.02,0.2,0.2]), 1)).tanh * 0.5 + sig;

	//sig = sig;
	sig = RLPF.ar(sig, ( \lpf.kr(100) *lpffac ).clip(20,20000), \rq.kr(0.5));

	sig1 = sig;
	//sig1 = CombL.ar(sig1, 1/freq * Pulse.ar(1).range(2,1),1) + sig1;
	//sig1 = FreqShift.ar(sig1, 1* LFPulse.ar(2 * ( SinOsc.ar(12) * 10 + 1 )) * lpffac) + sig1;
	sig1 = DelayC.ar(sig, 1, \delay.kr(0.1) * (Amplitude.kr(sig1)*0.1 + 1))+sig1;
	sig = SelectX.ar( EnvGen.kr(Env([0*glitch,0.7*glitch,0,0.7],[0.1,0.01,4.2],-1), 1), [sig, sig1]);
	sig.debug("basicbas");
	sig = TScramble.ar(sig, Impulse.kr(2),0.01);
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \basicbassglitch3,
			\note, Pseq([
				0,1,
			],inf),
			\legato, Pseq([
					1,1,2,0,
					4,0,0,0,
			],inf),
			\fac1, ~pmodenv.(Pseq([1,4,8,16,100],inf), 7),
			\lpffac, ~pmodenv.(Pseq([1,4,8,16,100],inf), 8),
			\rq, ~pmodenv.(Pseq([0.5,0.1,0.9],inf), 8),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\glitch, Pseq([0,1],inf).stutter(4),
			\glitch, Pseq([
				0,0,0,0,

				0,0,0,1,
				1,0,0,0,
				0,0,1,0,
				1,0,0,0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		);
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \basicbassglitch3,
			\note, Pseq([
				0,0,0,9,
				3,3,3,4,
			],inf),
			\legato, Pseq([
					3,0,0,0.1,
					4,0,0,0,
			],inf),
			\lpffac, Pseq([
				~pmodenv.(Pseq([1,100],1), 1),
				~pmodenv.(Pseq([1,10],1), 1),
				~pmodenv.(Pseq([100,10],1), 1),
			],inf),
			\lpf, Pseq([
				100,200,400,700,
			],inf),
			\rq, ~pmodenv.(Pseq([0.5,0.1,0.9],inf), 8),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\glitch, Pseq([0,1],inf).stutter(4),
			\glitch, Pseq([
				0,0,0,0,

				0,0,0,1,
				1,0,0,0,
				0,0,1,0,
				1,0,0,0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		);
	])
)).play;
)

(
SynthDef(\basicbassglitch4, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, glitch=1, lpffac=1;
	var sig, sig1, sig2, sig3;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.04,1.8]), 1);
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);

	sig = sig / 2;
	sig = BPF.ar(sig, freq * env1, 0.1, mul: EnvGen.kr(Env([0,1,0,10],[0.02,0.2,0.2]), 1)).tanh * 0.5 + sig;

	//sig = sig;
	sig = RLPF.ar(sig, ( \lpf.kr(100) *lpffac ).clip(20,20000), \rq.kr(0.5));

	sig1 = sig;
	//sig1 = CombL.ar(sig1, 1/freq * Pulse.ar(1).range(2,1),1) + sig1;
	sig1 = FreqShift.ar(sig1, \shift.kr(0) * ( SinOsc.ar(freq*10 * Duty.kr(1/16/~t * lpffac, 0, Dseq([
		1,0,3,0,
	],inf))) * 0.8 + 1 )) + sig1;
	//sig1 = DelayC.ar(sig, 1, \delay.kr(0.1) )+sig1;
	sig = SelectX.ar( EnvGen.kr(Env([0*glitch,0.7*glitch,0,0.7],[0.1,0.01,4.2],-1), 1), [sig, sig1]);
	sig.debug("basicbas");
	sig = TScramble.ar(sig, Impulse.kr(2),0.01);
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	Out.ar(out, sig);
}).add;
)

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pseq([
			Pbind(
				\instrument, \basicbassglitch4,
				\note, Pseq([
					0,0,0,-1,
				],inf).stutter(4),
				\legato, Pseq([
						4,0,0,0,
						4,0,0,0,
						4,0,0,0,
						2,0,1,0.1,
				],2)*0.8,
				\shift, Pseq([
					~pmodenv.(Pseq([0.0001,100.1],1), 1),
					~pmodenv.(Pseq([101,100.1],1), 1),
					~pmodenv.(Pseq([-401,10.1],1), 1),
				],inf),
				\lpffac, Pseq([
					~pmodenv.(Pseq([1,4],1), 2),
				],inf),
				\lpf, Pseq([
					400
				],inf),
				\rq, ~pmodenv.(Pseq([0.5,0.1,0.9],inf), 8),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\glitch, Pseq([0,1],inf).stutter(4),
				\glitch, Pseq([
					1
				],inf),
				\octave, 3,
				\dur, 1/8,
				\out, BusDef(\mixer3, \audio),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \basicbassglitch4,
				\note, Pseq([
					0,0,0,-1,
				],inf).stutter(4),
				\legato, Pseq([
						4,0,0,0,
						4,0,0,0,
						4,0,0,0,
						1,2,0,0.1,
				],2)*0.8,
				\shift, Pseq([
					~pmodenv.(Pseq([0.0001,100.1],1), 1),
					~pmodenv.(Pseq([101,100.1],1), 1),
					~pmodenv.(Pseq([-401,10.1],1), 1),
				],inf),
				\lpffac, Pseq([
					~pmodenv.(Pseq([2,1],1), 1),
					~pmodenv.(Pseq([2,1,7,1/2,5],1), 1/4),
				],inf),
				\lpf, Pseq([
					100,100,100,700,
					400,200,400,400,
					100,100,100,700,
					700,400,400,700,
				],inf),
				\rq, ~pmodenv.(Pseq([0.5,0.1,0.9],inf), 8),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\glitch, Pseq([0,1],inf).stutter(4),
				\glitch, Pseq([
					1
				],inf),
				\octave, 3,
				\dur, 1/8,
				\out, BusDef(\mixer3, \audio),
				\amp, 0.1,
			),
		],inf),
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			
					1,1,1,1, 0,0,0,0, 1,1,1,1, 1,0,1,0,
					0,0,0,0, 0,0,1,0, 1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\sustain, 0.021,
				\speed, 1+Pseg(Pseq([0,1.1],inf),8),
				\lag, 0.00,
				\gain, 0.4,
				\dur, 1/32,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\instrument, \playersec_looper,
				\trigfreq, ( ~t ) * Pseq([
					2,
				],inf),
				\speed, 1 * Pseq([
					1
				],inf),
				\pos, 5.70,
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 1/4/~t,
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,1,0,
					0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.041,
				\dur, 1/8,
				\gain, 0.1,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0, 1,1, 0,0, 1,0,
					1,0, 1,1, 1,1, 1,0,
				],inf).coin.not,
				\sustain, 0.05 * Pseq([1,1/2],inf),
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
	])
)).play;
)


(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pseq([
			Pbind(
				\instrument, \basicbassglitch4,
				\note, Pseq([
					0,0,0,-1,
				],inf).stutter(4),
				\legato, Pseq([
						4,0,0,0,
						4,0,0,0,
						4,0,0,0,
						2,0,1,0.1,
				],2)*0.8,
				\shift, Pseq([
					~pmodenv.(Pseq([0.0001,100.1],1), 1),
					~pmodenv.(Pseq([101,100.1],1), 1),
					~pmodenv.(Pseq([-401,10.1],1), 1),
				],inf),
				\lpffac, Pseq([
					~pmodenv.(Pseq([1,4],1), 2),
				],inf),
				\lpf, Pseq([
					400
				],inf),
				\rq, ~pmodenv.(Pseq([0.5,0.1,0.9],inf), 8),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\glitch, Pseq([0,1],inf).stutter(4),
				\glitch, Pseq([
					1
				],inf),
				\octave, 3,
				\dur, 1/8,
				\out, BusDef(\mixer3, \audio),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \basicbassglitch4,
				\note, Pseq([
					0,0,0,-1,
				],inf).stutter(4),
				\legato, Pseq([
						4,0,0,0,
						4,0,0,0,
						4,0,0,0,
						1,2,0,0.1,
				],2)*0.8,
				\shift, Pseq([
					~pmodenv.(Pseq([0.0001,100.1],1), 1),
					~pmodenv.(Pseq([101,100.1],1), 1),
					~pmodenv.(Pseq([-401,10.1],1), 1),
				],inf),
				\lpffac, Pseq([
					~pmodenv.(Pseq([2,1],1), 1),
					~pmodenv.(Pseq([2,1,7,1/2,5],1), 1/4),
				],inf),
				\lpf, Pseq([
					100,100,100,700,
					400,200,400,400,
					100,100,100,700,
					700,400,400,700,
				],inf),
				\rq, ~pmodenv.(Pseq([0.5,0.1,0.9],inf), 8),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\glitch, Pseq([0,1],inf).stutter(4),
				\glitch, Pseq([
					1
				],inf),
				\octave, 3,
				\dur, 1/8,
				\out, BusDef(\mixer3, \audio),
				\amp, 0.1,
			),
		],inf),
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,1,0,1,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			
				],inf).coin.not,
				\sustain, 0.021,
				\speed, 1+Pseg(Pseq([0,1.1],inf),8),
				\lag, 0.00,
				\gain, 0.4,
				\dur, 1/32,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\instrument, \playersec_looper,
				\trigfreq, ( ~t ) * Pseq([
					2,
				],inf),
				\speed, 1 * Pseq([
					1
				],inf),
				\pos, 5.70,
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 1/4/~t,
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			)),
			Pbind(\pos, Pkey(\pos)+0.01)<>
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
					0,0,0,1, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
					0,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.071,
				\dur, 1/16,
				\gain, 0.1,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0,
					1,1,1,1, 0,0,0,0,
					1,0,1,0, 0,1,1,1,
				],inf).coin.not,
				\sustain, 0.05 * Pseq([1,1/2],inf),
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
	])
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pseq([
			Pbind(
				\instrument, \basicbassglitch4,
				\note, Pseq([
					0,0,0,-1,
				],inf).stutter(4),
				\legato, Pseq([
						4,0,0,0,
						0,0,0,0,
				],2)*0.8,
				\shift, Pseq([
					~pmodenv.(Pseq([0.0001,100.1],1), 1),
					~pmodenv.(Pseq([101,100.1],1), 1),
					~pmodenv.(Pseq([-401,10.1],1), 1),
				],inf),
				\lpffac, Pseq([
					~pmodenv.(Pseq([1,4],1), 2),
				],inf),
				\lpf, Pseq([
					400
				],inf),
				\rq, ~pmodenv.(Pseq([0.5,0.1,0.9],inf), 8),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\glitch, Pseq([0,1],inf).stutter(4),
				\glitch, Pseq([
					1
				],inf),
				\octave, 3,
				\dur, 1/8,
				\out, BusDef(\mixer3, \audio),
				\amp, 0.1,
			),
		],inf),
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			
				],inf).coin.not,
				\sustain, 0.021,
				\speed, 1+Pseg(Pseq([0,1.1],inf),8),
				\lag, 0.00,
				\gain, 0.4,
				\dur, 1/32,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pbind(\pos, Pkey(\pos)+0.01)<>
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.071,
				\dur, 1/16,
				\gain, 0.1,
				\amp, 0.1,
			)),
		]),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					1,0,0,
					1,0,0,
					1,0,0,
					1,0,0,
				],inf).coin.not,
				\sustain, 0.05 * Pseq([1,1/2],inf),
				\gain, 0.4*Pseq([
					1,
				],inf),
				\dur, 1/24,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,
					0,0,0,
					0,0,1,
					0,0,0,
				],inf).coin.not,
				\sustain, 0.02 * Pseq([1,1/2],inf),
				\gain, 0.2,
				\dur, 1/24,
				\amp, 0.1,
			)),
	])
)).play;
)
