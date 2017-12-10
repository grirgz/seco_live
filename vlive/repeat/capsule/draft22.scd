(
SynthDef(\allreverbdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.1);
	sig = sig + in;
	15.do {
		sig = AllpassL.ar(sig, 0.06, Rand(0.001,0.06) * \delay.kr(1), 3);
	};
	sig1 = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/4);
	sig = SelectX.ar(\distmix.kr(0.5), [sig, sig1]);
	sig = Limiter.ar(sig);
	LocalOut.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = SelectX.ar(\mix.kr(0.5).lag(0.1), [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\twik, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\slurp, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.9]*2,[ 1,-1 ]), 1).round(0.1);
	env2 = EnvGen.kr(Env([1,20,1,1/2],[0.1,0.9,1]*2), 1).round(0.1);
	env3 = EnvGen.kr(Env([1,1.20,0.1],[0.1,0.9]*2), 1).round(0.1);
	sig = SinOsc.ar(freq * env1 * ( SinOsc.ar(freq * env3) * env2 + 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\islurp, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.9]*4,[ 1,-1 ]), 1).round(0.1);
	env2 = EnvGen.kr(Env([1,20,1,1/2],[0.1,0.9,1]*4), 1).round(0.1);
	env3 = EnvGen.kr(Env([1,1.20,0.1],[0.1,0.9]*4), 1).round(0.1);
	sig = SinOsc.ar(freq * env1 * ( SinOsc.ar(freq * env3) * env2 + 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.01),gate,doneAction:2);
	sig = sig * EnvGen.kr(Env([0,1,0],[1.0,0.08], [4,-1]), 1);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

PatKitDef(\rev).edit

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Pbind(\out, BusDef(\mixer3))<>
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \islurp,
			\freq, 200,
			\legato, 4,
			\isRest, Pseq([
				0,0, 0,0, 0,0, 0,0,
				0,0, 0,0, 1,0, 0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,1,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
	])
)).play;
)

(
Pdef(\part3, Pdef(\plopzed, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\speed, -1 * 1.0,
			\pos, 1/2/~t,
			\sustain, 1.9,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	])
)).play;
)


(
SynthDef(\chh, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([12000,182,61],[4,2.8]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([1000,152,91],[4,2.8]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([7100,1000,100],[4,0.8]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,1],[4.1,0.8]), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(1700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RLPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,2.4),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\echh, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,12000,182],[4,0.1]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([10,1000,152],[4,0.1]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([10,7100,1000],[4,0.1]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,0.08]/~t), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(1700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RLPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,2.4),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\echhlow, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,420,182],[4,0.1]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([10,100,152],[4,0.1]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([10,710,1000],[4,0.1]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,0.08]/~t), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(1700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RLPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,2.4),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\nidi, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,10,40,1],[4,4.1,0.8]), 1);
	sig = SinOsc.ar([234,234.43] * ( SinOsc.ar(freq) * env1 + 1 )).mean;
	sig1 = ( sig*\distamp.kr(1)*env1 ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\mix.kr(1), [sig, sig1]);
	sig = sig * EnvGen.ar(Env.adsr(2.01,0.1,0.8,0.01),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

Pdef(\part).clear;
(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \nidi,
			\freq, 200,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		//Pmono(\echh,
			//\freq, 200,
			//\dur, 1,
			//\amp, 0.1,
		//),
		Pseq([
			Pbind(
				\instrument, \echh,
				\freq, 200,
				\legato, 1,
				\dur, Pn(4,1),
				\amp, 0.1,
			),

			Ptpar([
				0,Pbind(
					\instrument, \nidi,
					\freq, 200,
					\legato, 1,
					\dur, Pn(4,1),
					\amp, 0.1,
				),
				0, Pbind(
					\instrument, \echhlow,
					\freq, 200,
					\legato, 1,
					\dur, Pn(4,1),
					\amp, 0.1,
				),
				0,	PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
					],1).coin.not,
					\sustain, 4.1,
					\gain, 2.2,
					\dur, 1/8,
					\amp, 0.1,
				)),
				0,PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pser([
						1,0,
					],8*4).coin.not,
					\sustain, 1.1,
					\gain, Pseg(Pseq([0,0,1,1,1],inf),2,1),
					\dur, 1/8,
					\amp, 0.1,
				))
			]),
			Event.silent(1),
			Ptpar([
				0, Pbind(
					\instrument, \chh,
					\freq, 200,
					\legato, 1,
					\dur, Pn(8,1),
					\amp, 0.1,
				),
				0, Pfindur(16, Pdef(\cavern2)),
			]),
			Pfindur(16, Pdef(\cavern2_walk)),
			Pfindur(16, Pdef(\cavern2_walk2)),
			Pfindur(8, Pdef(\serpent1)),
			Pfindur(8, Pdef(\serpent2)),
		],1),
	])
)).play;
)

(
	Pdef(\part, Pdef(\cavern2, 
		Ppar([
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],7+8),
					0,0,0,0, 1,0,0,0,
				],1).coin.not,
				\speed, -1 * 1.0,
				\pos, 1/2/~t,
				\sustain, 1.9,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq({[
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\out, BusDef(\fx1,\audio),
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pseq([
				Pfindur(16, Ppar([
					Pbind(
						\instrument, \twik,
						\freq, Pwhite(200.0,1000)* Pseg(Pseq([0,2],inf),8),
						\dur, 1/8,
						\out, BusDef(\fx1,\audio),
						\amp, 0.1,
					),

				])),
				Pfindur(32, Ppar([
					Pbind(
						\instrument, \twik,
						\freq, Pwhite(200.0,1000)* Pseg(Pseq([0,2],inf),8),
						\freq, 200 * Pseq([
							0,12,5,-4,
						],inf).midiratio,
						\dur, 1/8,
						\out, BusDef(\fx1,\audio),
						\amp, 0.1,
					),
					Pbind(
						\instrument, \fmbell,
						\freq, 200 * Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,1,1,0, 1,1,1,0,
							1,1,1,0, 1,1,1,0,
							1,1,1,0, 1,1,1,0,
							1,1,1,0, 1,1,1,0,
						],inf).midiratio,
						\isRest, Pseq([
							1,0,0,0, 1,0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \islurp,
						\freq, 200,
						\legato, 4,
						\isRest, Pseq([
							Pstep(Pseq([0],7),1),
							0,0, 0,0, 1,0, 0,0,
						],inf).coin.not,
						\dur, 1/8,
						\amp, 0.1,
					),

				])),
			],1),
			Pmono(\allreverbdel,
				\freq, 200,
				\delay, Pseg(Pseq([1,1,0],inf),8),
				\fb, 0.1,
				\inbus, BusDef(\fx1, \audio),
				\dur, 1,
				\amp, 0.1,
			);
		])
	)).play;
)


(
	Pdef(\part, Pdef(\cavern2_walk, 
		Ppar([
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
			Pbind(
				\instrument, \basicbass,
				//\out, BusDef(\fx1, \audio),
			\note, Pstep(Pseq([
				2,9,5,-4,
			],inf),1),
			\freq, Pseq([
				80,70,
			],inf),
			\octave, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			),
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
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],7+8),
					0,0,0,0, 1,0,0,0,
				],1).coin.not,
				\speed, -1 * 1.0,
				\pos, 1/2/~t,
				\sustain, 1.9,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq({[
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\out, BusDef(\fx1,\audio),
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pseq([
				Pfindur(32, Ppar([
					Pbind(
						\instrument, \twik,
						\freq, Pwhite(200.0,1000)* Pseg(Pseq([0,2],inf),8),
						\freq, 200 * Pseq([
							0,12,5,-4,
						],inf).midiratio,
						\dur, 1/8,
						\out, BusDef(\fx1,\audio),
						\amp, 0.1,
					),
					Pbind(
						\instrument, \fmbell,
						\freq, 200 * Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,1,1,0, 1,1,1,0,
							1,1,1,0, 1,1,1,0,
							1,1,1,0, 1,1,1,0,
							1,1,1,0, 1,1,1,0,
						],inf).midiratio,
						\isRest, Pseq([
							1,0,0,0, 1,0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \islurp,
						\freq, 200,
						\legato, 4,
						\isRest, Pseq([
							Pstep(Pseq([0],inf),7),
							0,0, 0,0, 1,0, 0,0,
						],inf).coin.not,
						\dur, 1/8,
						\amp, 0.1,
					),

				])),
				Pfindur(16, Ppar([
					Pbind(
						\instrument, \twik,
						\freq, Pwhite(200.0,1000)* Pseg(Pseq([0,2],inf),8),
						\dur, 1/8,
						\out, BusDef(\fx1,\audio),
						\amp, 0.1,
					),

				])),
			],1),
			Pmono(\allreverbdel,
				\freq, 200,
				\delay, Pseg(Pseq([1,1,0],inf),8),
				\fb, 0.1,
				\inbus, BusDef(\fx1, \audio),
				\dur, 1,
				\amp, 0.1,
			);
		])
	)).play;
)

(
	Pdef(\part, Pdef(\cavern2_walk2, 
		Ppar([
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
			Pbind(
				\instrument, \basicbass,
				//\out, BusDef(\fx1, \audio),
			\note, Pstep(Pseq([
				2,9,5,-4,
			],inf),1),
			\freq, Pseq([
				80,70,
			],inf),
			\octave, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			),
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
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],7+8),
					0,0,0,0, 1,0,0,0,
				],1).coin.not,
				\speed, -1 * 1.0,
				\pos, 1/2/~t,
				\sustain, 1.9,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq({[
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\out, BusDef(\fx1,\audio),
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pseq([
				Pfindur(32, Ppar([
					Pmono(\crystal,
						\freq, 200,
						\dur, 1,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \twik,
						\freq, 200 * Pseq([
							0,12,5,-4,
						],inf).midiratio,
						\isRest, Pseq([
							1,1,1,1,
							0,0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\out, BusDef(\fx1,\audio),
						\amp, 0.1,
					),
					Pbind(
						\instrument, \fmbell,
						\freq, 200 * Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,1,1,0, 1,1,1,0,
							1,1,1,0, 1,1,1,0,
							1,1,1,0, 1,1,1,0,
							1,1,1,0, 1,1,1,0,
						],inf).midiratio,
						\adsr, Pseq([
							[ Env.adsr(0.1,0.1,0.8,0.1) ],
						],inf),
						\isRest, Pseq([
							1,0,0,0, 1,0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \islurp,
						\freq, 200,
						\legato, 4,
						\isRest, Pseq([
							Pstep(Pseq([0],inf),7),
							0,0, 0,0, 1,0, 0,0,
						],inf).coin.not,
						\dur, 1/8,
						\amp, 0.1,
					),

				])),
				Pfindur(16, Ppar([
					Pbind(
						\instrument, \twik,
						\freq, Pwhite(200.0,1000)* Pseg(Pseq([0,2],inf),8),
						\dur, 1/8,
						\out, BusDef(\fx1,\audio),
						\amp, 0.1,
					),

				])),
			],1),
			Pmono(\allreverbdel,
				\freq, 200,
				\delay, Pseg(Pseq([0,0,1,0],inf),8),
				\fb, 0.1,
				\inbus, BusDef(\fx1, \audio),
				\dur, 1,
				\amp, 0.1,
			);
		])
	)).play;
)

(
Pdef(\part, Pdef(\cavern, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1,\audio),
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \twik,
			\freq, Pwhite(200.0,1000)* Pseg(Pseq([0,2],inf),8),
			\dur, 1/8,
			\out, BusDef(\fx1,\audio),
			\amp, 0.1,
		),
		Pmono(\allreverbdel,
			\freq, 200,
			\delay, Pseg(Pseq([1,1,0],inf),8),
			\fb, 0.1,
			\inbus, BusDef(\fx1, \audio),
			\dur, 1,
			\amp, 0.1,
		);
	])
)).play;
)


(
Pdef(\part3, Pdef(\awos, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\sustain, 4/~t,
			\dur, 4,
			\out, BusDef(\awosfx1,\audio),
			\amp, 0.1,
		),
		Pmono(\filterdist,
			\inbus, BusDef(\awosfx1, \audio),
			\lpf, ~pmodenv.(Pseq([100,2000,10000,4],inf), 8),
			\rq, 0.1,
			\distamp, ~pmodenv.(Pseq([1,2,10,40],inf), 8),
			\delay, ~pmodenv.(Pseq(1/[1,20,9,13,10],inf), 8,1,-1),
			\combmix, ~pmodenv.(Pseq([0,0,1,1,1],inf), 8,1,-1),
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

(
SynthDef(\filterdist, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig1 = AllpassL.ar(sig, 1/~t,\delay.kr(1/8/~t),10)+sig*2;
	sig = SelectX.ar(\combmix.kr(0.5), [sig, sig1]);
	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


/////////////////////////////////////

(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\crystal, { arg gate=1, out=0, freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var size = 8;
	var master = EnvGen.kr(Env([1/10, 1/2, 1/100, 1, 2],[0.1,0.8,1,1]*4).circle, 1);
	var randfreq = {
		exprand(1/10000,1/10) * ( SinOsc.kr(exprand(1/1000,2), 1.0.rand) * exprand(1/100,2) + 1 ) * master;
	};
	var randfreqtab = {
		{randfreq.()}.dup(size);
	};
	var stut;
	sig = Dust.ar(100 * SinOsc.kr(1/13 * [1,1.123]).range(1/10,1).sum);
	sig = Ringz.ar(sig, exprand(50.0!size,15000) * LFNoise0.ar(randfreqtab.()).range(1/2,1), SinOsc.kr(randfreqtab.(),1.0.rand).range(4,40));
	sig = sig.collect({ arg si;
		si = si * SinOsc.kr(randfreq.(), 1.0.rand).exprange(0.01,1);
		si = [
			{ si.fold2(0.8) },
			{ si.tanh },
			{ si * 0.4 },
		].choose.value;
		si;
	});
	pan = SinOsc.kr(sig, randfreqtab.(), 1.0.rand) * SinOsc.kr(randfreqtab.(), 1.0.rand).range(0,1) + pan;
	sig = sig * 6 * 2 * ( size.pow(1.5)/100 ) * 2;
	sig = Pan2.ar(sig, pan, amp);
	sig = sig.mean;
	sig1 = sig;
	sig = BPF.ar([ sig ], exprand(50.0!size,15000) * SinOsc.kr(randfreqtab.(), 1.0.rand).range(1/2,1), SinOsc.kr(randfreqtab.(), 1.0.rand).range(0.1,1));
	stut = 4;
	//sig = ~stutter.(sig, Impulse.ar(stut.reciprocal), 0.4);

	sig = DelayC.ar(sig, 0.2, LFPulse.ar((0.2 * 2).reciprocal,0,0.5) * 0.2);
	sig = sig.mean + ( sig1/10 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
)


////////////////////////////////////////////:


(
SynthDef(\fmbass2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fac1=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq * [1,1/2,2];
	freq = freq * ((0..1)/1 - 0.5 * 0.0107 + 1);
	env1 = EnvGen.kr(Env([0,1,0.051,0],[0.401,8.01,0.8], [4,-8]), 1);
	env2 = EnvGen.kr(Env([0,1,0.051,0],[8.405,0.5,1.5], [0,-8], releaseNode:2, loopNode:0), gate);
	env3 = EnvGen.kr(Env([0,1,1,0],[0.01,13.01,0.2], [0,0,-4], releaseNode:2, loopNode:0), gate);
	env4 = EnvGen.kr(Env([0,1,0],[0.002,4.8], [0,-4]), 1);
	env5 = EnvGen.kr(Env([0,1,1,0],[0.001,0.1,20.8], [4,0,-4], releaseNode:2, loopNode:0), gate);
	env6 = EnvGen.kr(Env([0,1,0],[0.001,3.0], [0,-4]), 1);
	//freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * 11 + 0) * env1; 
	sig2 = SinOsc.ar(freq * 6 * ( sig1 * 2.5 * fac1 + 1 )) * env2;
	sig3 = SinOsc.ar(freq * 2 * ( sig2 * 2.5 + 1 ) * 1 + 10.1) * env3;
	sig4 = SinOsc.ar(freq * 1.01 * ( sig3 * 2.5 + 1 ) + 0) * env4;
	sig5 = SinOsc.ar(freq * 1 * ( sig2 * 2.5 * fac1 + 1 ) * (sig4 * 2.5 + 1)) * env5;
	sig6 = SinOsc.ar(freq * 2) * env6;
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar([0.0, 0.0, 0.0,  0.0, 0.5, 0.5]);
	//sig = ( sig*\distamp.kr(100) ).tanh * \distpostamp.kr(1/2);
	env7 = EnvGen.kr(Env([100,freq,4001],[8.1,0.8]), 1);
	sig = BRF.ar(sig, env7);
	sig = sig * ( SinOsc.kr(freq) * env2 * fac1 + 1 );
	sig.debug("sig");
	sig = sig /2;
	sig = sig.flop.sum;
	sig = HPF.ar(sig, 200);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0,1,0.01, 1,-1) ),gate,doneAction:2);
	sig = sig * AmpComp.kr(freq);
	sig.debug("sigx");
	sig = Pan2.ar(sig, pan + [ 0, 0, 0, 0, 0, 0], amp).sum;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\kickret, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(Env([261, 120, 61,55], [0.035, 0.08,2], curve: \exp));
	bodyAmp = EnvGen.ar(Env.linen(0.005, 4.1, 0.3), doneAction: 2);
	body = SinOsc.ar(bodyFreq) * bodyAmp;
	// pop sweeps over the midrange
	popFreq = XLine.kr(750, 261, 0.02);
	popAmp = EnvGen.ar(Env.linen(0.001, 2.02, 0.001)) * 0.15;
	pop = SinOsc.ar(popFreq) * popAmp;
	// click is spectrally rich, covering the high-freq range
	// you can use Formant, FM, noise, whatever
	clickAmp = EnvGen.ar(Env.perc(0.001, 3.01)) * 0.15;
	click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;
	//click = LPF.ar(Impulse.ar(0),3000);

	snd = body;
	snd = body + pop + click;
	//snd = pop + click;
	//snd = click*2;
	snd = snd * EnvGen.kr(Env([1,1,14,1],[0.1,0.8,1]), 1);
	snd = snd.tanh;

	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
)

(
	~master.();
Pdef(\part, Pdef(\serpent1, 
	Ppar([
		Pbind(
			\instrument, \fmbass2,
			\note, Pseq([
				7,6,-1,3,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,1,0,1,
				8,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
					3,0,0,0, 1,0,0,1,
					8,0,0,0, 0,0,0,0,
					4,0,0,0, 8,0,0,0,
					0,0,0,0, 1,0,0,1,
					8,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,1,
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fac1, Pseg(Pseq([0,10],inf),32),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fmbass2,
			\note, Pseq([
				0,0,0,1,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,1,0,1,
				8,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
					6,0,0,0, 0,0,1,1,
				8,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,1,
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\fac1, Pseg(Pseq([0,10],inf),32),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kickret,
			\freq, 200,

			\legato, 1,
			\dur, 2,
			\amp, 0.1,
		),
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
					//0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					//0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1,
					0,1,1,0, 1,1,1,0, 0,0,0,0, 0,0,1,0,
					0,0,1,0, 1,1,0,1, 0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,1,0, 0,0,0,0, 0,0,1,0,
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
				\dur, 1/16,
				\amp, 0.1,
			)),
	])
)).play;
)

(
Pdef(\part, Pdef(\serpent2, 
	Ppar([
		Pbind(
			\instrument, \fmbass2,
			\note, Pseq([
				-2,-2,-2,-5,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,1,0,1,
				8,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
					3,0,0,0, 1,0,0,1,
					8,0,0,0, 0,0,0,0,
					4,0,0,0, 8,0,0,0,
					0,0,0,0, 1,0,0,1,
					8,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,1,
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fac1, Pseg(Pseq([0,10],inf),32),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fmbass2,
			\note, Pseq([
				-2,-2,-2,-5,
			],inf)+3,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,1,
				8,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
					6,0,0,0, 0,0,1,1,
				8,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,1,
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\fac1, Pseg(Pseq([0,10],inf),32),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kickret,
			\freq, 200,

			\legato, 1,
			\dur, 2,
			\amp, 0.1,
		),
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
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1,
					0,1,1,0, 1,1,1,0, 0,0,0,0, 0,0,1,0,
					0,0,1,0, 1,1,0,1, 0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,1,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,1, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.4* Pseq([
					1,0.2,
				],inf),
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.1,
			)),
	])
)).play;
)
