(
SynthDef(\playersec_xx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	sig = HPF.ar(sig, 40);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
SynthDef(\sindrone1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = XLine.kr(1,10,10);
	sig = WhiteNoise.ar;
	sig = Klank.ar(Ref([ exprand(20.0,10100!2!48), 0.001!8 ]), sig);
	sig = sig.debug("sig");
	sig = FreqShift.ar(sig, XLine.kr(0.0001,1000*[1,2,3],10*[1,2,3])).sum + sig;
	//sig = sig * SinOsc.kr(4*~t).range(0,1);
	//sig = sig.clump(2).sum;
	sig = sig * EnvGen.kr(\env.kr(Env([0,2,1,0],[0.1,0.8,0.1].normalizeSum)), Impulse.kr(2*~t*env1), timeScale:1/2);
	sig = sig  * 2;
	sig = sig * amp;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\sindrone1b, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,20,1,1,20],[0.1,0.8,2,10]), 1);
	sig = WhiteNoise.ar;
	sig = Klank.ar(Ref([ exprand(20.0,10100!2!48), 0.001!8 ]), sig);
	sig = sig.debug("sig");
	sig = FreqShift.ar(sig, XLine.kr(0.0001,1000*[1,2,3],10*[1,2,3])).sum + sig;
	//sig = sig * SinOsc.kr(4*~t).range(0,1);
	//sig = sig.clump(2).sum;
	sig = sig * EnvGen.kr(\env.kr(Env([0,2,1,0],[0.1,0.8,0.1].normalizeSum)), Impulse.kr(2*~t*env1), timeScale:1/2);
	sig = sig  * 2;
	sig = sig * amp;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\sindrone2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,4,4],[5.1,8,8.8]), 1);
	env2 = EnvGen.kr(Env([1,1,0.04,0.01],[6.1,8,8.8]), 1);
	sig = WhiteNoise.ar;
	sig = 4.collect({
		SinOsc.ar(rrand(400,11000)* env1 * ( 1 + ( SinOsc.ar(rrand(0.1,1000)) * LFNoise1.kr(rrand(0.1,10)).range(0,5) * env2 ))); 
	});
	sig = sig.collect({ arg isig;
		isig * SinOsc.ar(rrand(10.1!2,201)).range(0,1)
	});
	sig = sig * Duty.kr(2/~t, 0, Dseq([
		1,1,
	],inf));

	sig = sig.sum;
	sig = sig  / 2;
	sig = sig.debug("sig");
	sig = sig * amp;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\sindrone3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = 2.collect({
		DynKlank.ar(Ref([ rrand(0,1.0!48).round(SinOsc.kr(1/10).range(0.0001,1/80) ).linexp(0,1,20.0,15000) * [ [1,1.0 + SinOsc.kr(1/11).range(0,0.0051)] ], 0.001!8 ]), sig);
	});
	sig = sig.collect({ arg isig;
		isig * SinOsc.kr(rrand(0.1,1)).range(0,1)
	});

	sig = sig  / 1;
	sig = sig.flop.sum;
	sig = sig.debug("sig");
	sig = sig * amp;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\pad, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,1,0.51,0.1],[0.1,0.8,1]), 1);
	env2 = EnvGen.kr(Env([0.1,1,0.51,0.1],[0.1,2.8,1]), 1);
	sig = SinOsc.ar(freq * [1,1.01,1.001,2,1/2]);
	sig1 = LFSaw.ar(freq*2);
	sig = sig + sig1;
	sig = sig.fold2(env1);
	sig1 = RLPF.ar(sig1, \lpfr.kr(2.1) * freq * env2, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\drones, 
	Ppar([
		Pbind(
			\instrument, \sindrone1,
			\freq, 200,
			\isRest, Pseq([
				0,0,0,1, 
			],inf).coin.not,
			\legato, 1,
			\dur, 4,
			\amp, 0.1,
		),
		Pseq([
			Rest(4),
			Pmono(\sindrone2,
				\freq, 200,
				\dur, Pseq([1],12),
				\amp, 0.1,
			),
			Rest(16),
			Pmono(\sindrone2,
				\freq, 200,
				\dur, Pseq([1],8),
				\amp, 0.1,
			),
		],inf),
		Pseq([
			Rest(16),
			Rest(2),
			Pmono( \sindrone1b,
				\freq, 200,
				\isRest, Pseq([
					1, 
				],inf).coin.not,
				\legato, 1,
				\dur, 1,
				\amp, 0.1,
			),
		],inf),
		Pmono(\sindrone3,
			\freq, 200,
			\dur, Pseq([1],16),
			\amp, 0.1 * Pseg(Pseq([1,0],inf),8),
		).loop,
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\fudrums, 
	Ppar([
		Pdef(\drums) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, Pseq([
				BufDef('loop/funky1_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),

				BufDef('loop/funky1_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),
				BufDef('loop/funky2_135bpm.flac'),
			],inf).stutter(4),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\pos, Pseq([
				//Pseq((1..24) ++ [4,5,6,2,3,4,5,6]),
				Pseq((0..31)),
				Pseq([
					Plazy({ arg ev;
						var ar;
						ar = (0..31);
						ar[ar.size.rand] = (0..31).choose;
						ar[ar.size.rand] = (0..31).choose;
						Pser(ar,8*4);
					}).repeat(2),
					Pseq((0..23)),
					Pseq([0,7,8,4, 7,8,7,4].rotate(0)),
				],1),
				Pseq([
					Plazy({ arg ev;
						var ar;
						ar = (0..31);
						ar[ar.size.rand] = (0..31).choose;
						ar[ar.size.rand] = (0..31).choose;
						Pser(ar,8*4);
					}).repeat(3),
					Pseq((0..23)),
					Pseq([0,7,8,4, 7,8,7,4].rotate(0)),
				],inf),
			],inf)/8/~t+0.04,
			\speed, 1,
			\gain, 1,
			\freq, 200,
			\legato, 1.00,
			\dur, Pseq([1/8],inf),
			\amp, 0.1,
		),
	])
)).play;
);


(
	~master.();
Pdef(\part, Pdef(\fudrums2,  // 16 beats
	Ppar([
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, Pseq([
				BufDef('loop/funky3_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),

				BufDef('loop/funky1_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),

				BufDef('loop/funky1_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),

				BufDef('loop/funky1_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),
				BufDef('loop/funky2_135bpm.flac'),
			],inf).stutter(4),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\pos, Pseq([
				Pseq((0..31)),

				Pseq((0..23)),
				Pseq([0,7,8,4, 7,8,7,4].rotate(0)),

				Pseq([
					0,3,8,2, 4,3,13,13, 
					8,9,8,13, 7,1,13,9,
				]+16,1),
				Pser([
					0,1,2,3, 4,5,6,6,
					8,7,8,1, 12,2,8,15,
				],8*2),

				Pseq([
					0,3,8,2, 4,3,13,8, 
					3-16,13,8,1-16, 7,1,13,9,
				]+16,1),
				Pser([
					0,8,10,4, 8,10,4,11,
					8,9,10,11, 12,13,14,15,
				],8*2),

			],inf)/8/~t+0.04,
			\speed, 1,
			\gain, 1,
			\freq, 200,
			\legato, 1.00,
			\dur, Pseq([1/8],inf),
			\amp, 0.1,
		),
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\fudrums3,  // 32 beats
	Ppar([
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, Pseq([
				BufDef('loop/funky3_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),

				BufDef('loop/funky1_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),

				BufDef('loop/funky1_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),

				BufDef('loop/funky1_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),
				BufDef('loop/funky2_135bpm.flac'),
			],inf).stutter(4),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\pos, Pseq([
				Pseq((0..31)),

				Pseq((0..23)),
				Pseq([0,7,8,4, 7,8,7,4].rotate(0)),

				Pseq([
					0,3,8,2, 4,3,13,13, 
					8,9,8,13, 7,1,13,9,
				]+16,1),
				Pser([
					0,1,2,3, 4,5,6,6,
					8,7,8,1, 12,2,8,15,
				],8*2),

				Pseq([
					0,3,8,2, 4,3,13,8, 
					3-16,13,8,1-16, 7,1,13,9,
				]+16,1),
				Pser([
					0,8,10,4, 8,10,4,11,
					8,9,10,11, 12,13,14,15,
				],8*2),

				// 16 beats

				Pseq((0..31)),

				Pseq((0..23)),
				Pseq([0,1,8,4, 7,8,7,4].rotate(0)),

				Pseq([
					0,3,8,2, 4,3,13,13, 
					3,13,13,1, 7,1,8,9,
				]+16,1),
				Pser([
					0,3,8,3, 4,1,8,1,
					8,1,5,1, 12,5,6,1,
				],8*2),

				Pseq([
					Pseq([
						0,1,2,3, 8,7,8,1, 
						12,2,8,15, 7,7,8,9,
					],1),
					Pseq([
						0,3,8,2, 4,7,8,1, 
						12,2,8,15, 7,7,8,9,
					]+16,1),
				]),

			],inf)/8/~t+0.04,
			\speed, 1,
			\gain, 1,
			\freq, 200,
			\legato, 1.00,
			\dur, Pseq([1/8],inf),
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part,Pdef(\cat, 
	Ppar([
		
		Pdef(\pad) <>
		Pbind(
			//\out, BusDef(\fx1, \audio),
		) <> Pseq([
			Pfindur(16/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(15/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(1/4, PmonoArtic( \pad,
				\legato, Pseq([
					0.81,
				],inf),
				\degree, Pseq([
					0,
				],inf),
				\dur, 1/4,
				\amp, 0.2
			)),
		],inf),
	])
)).play;
);



//////////// MAIN
(
	~master.();
	Pdef(\drbass, 
		Pseq([
			Pfindur(32,Pdef(\drones)),

			Ppar([
				Pfindur(16,Pdef(\drones)),
				Pfindur(16,Pbind(
					\instrument, \distbass,
					\freq, 70,
					\dur, 1,
					\amp, 0.1,
				)),
			]),
			Pfindur(16,Ptpar([
				0, Pfindur(16,Pdef(\drones)),
				0, Pdef(\fudrums),
				0, Pfindur(16,Pdef(\bass) <> Pbind(
					\instrument, \distbass,
					\freq, 70,
					\legato, Pseq([
						4,0,0,0, 0,0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\amp, 0.1,
				)),
			])),
			Pfindur(32,Ptpar([
				0,Pdef(\kick) <> Pdef(\fudrums3),
				8, Pfindur(64,Pdef(\bass) <> Pbind(
					\instrument, \distbass,
					\freq, Pseg(Pseq([70,70,70,65],inf), 1),
					\fmfreq, 1/2,
					\legato, Pseq([
						4,0,0,0, 0,0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\amp, 0.1 * Pseg(Pseq([0,1,2,Pseq([2],inf)],inf),8),
				)),
			])),
			// break
			Pfindur(16,Ptpar([
				0,Pdef(\kick) <> Pdef(\fudrums2),
			])),
			// part2
			Pfindur(64,Ptpar([
				0,Pdef(\kick) <> Pdef(\fudrums3),
				0, Pfindur(16,Pdef(\bass) <> Pbind(
					\instrument, \distbass,
					\freq, Pseg(Pseq([70,70,70,65],inf), 1),
					\fmfreq, 1,
					\legato, Pseq([
						4,0,0,0, 0,0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\amp, 0.1,
				)),
				8, Pdef(\cat),
			])),
			// part2 bis
			Rest(4),
			Pfindur(60,Ptpar([
				0,Pdef(\kick) <> Pdef(\fudrums3),
				0, Pfindur(60,Pdef(\bass) <> Pbind(
					\instrument, \distbass,
					\freq, Pseg(Pseq([70,70,70,65],inf), 1),
					\fmfreq, 1,
					\legato, Pseq([
						4,0,0,0, 0,0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\amp, 0.1,
				)),
				0, Pfindur(64, Pdef(\pad) <> Pbind(\instrument, \pad,
				\legato, Pseq([
					12,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					8,0,0,0, 0,0,0,0,
					4,0,0,0, 3,0,0,1,
				],inf)*0.9,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\degree, Pstep(Pseq([
					0,0,0,-1,
				],inf),1),
				\dur, 1/8,
				\amp, 0.2
			)),
			])),

		],1),
	).play;
)

////////////////// DRAFT
(
	~master.();
Pdef(\part, Pdef(\fudrumsx, 
	Ppar([
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, Pseq([
				BufDef('loop/funky3_135bpm.flac'),
			],inf).stutter(4),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\pos, Pseq([
				Pser([
					0,1,2,3, 4,5,6,6,
					8,7,8,1, 12,2,8,15,
				],8*4*8),
				Pser([
					0,8,10,4, 8,10,4,11,
					8,9,10,11, 12,13,14,15,
				],8*4*8),
				Pser([
					0,3,8,3, 4,1,8,1,
					8,1,5,1, 12,5,6,1,
				],8*4*8),
				Plazy({ arg ev;
					var ar;
					ar = (0..31);
					ar[ar.size.rand] = (0..31).choose;
					ar[ar.size.rand] = (0..31).choose;
					Pser(ar,8*4);
				}).loop,
				Pser([
					0,1,2,3, 4,5,6,7,
					8,1,10,11, 12,13,14,15,
					//Pseq((16..31)),
				],8*4*8),
				Pser([
					0,0,1,0, 4,5,6,7,
					8,9,10,11, 12,13,14,15,
					//Pseq((16..31)),
				],8*4*8),
				Pser([
					0,1,2,3, 4,5,6,7,
					8,2,1,3, 12,13,14,15,
					//Pseq((16..31)),
				],8*4*8),
				Pser([
					0,1,2,3, 4,1,2,3,
					8,2,1,3, 12,13,14,15,
					//Pseq((16..31)),
				],8*4*8),
				Pseq((0..31)),
				Pser([
					0,1,2,3, 4,1,2,3,
					8,9,10,11, 12,13,14,15,
					Pseq((16..31)),
				],8*4),
				Pser([
					0,5,6,2, 4,5,6,7,
					8,9,10,11, 12,13,14,15,
					0,1,2,3, 4,5,6,7,
					7,6,5,4,
					12,10,13,11,
				],8*4),
				Pser([
					0,1,2,3, 8,4,6,7,
					8,9,10,11, 12,13,14,15,
					Pseq((16..31)),
				],8*4),
				Pseq((0..23)),
				Pseq([0,7,8,4, 7,8,7,4].rotate(0)),
			],inf)/8/~t+0.04,
			\speed, 1,
			\gain, 1,
			\freq, 200,
			\legato, 1.00,
			\dur, Pseq([1/8],inf),
			\amp, 0.1,
		),
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\fudrumsx, 
	Ppar([
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, Pseq([
				BufDef('loop/funky3_135bpm.flac'),
			],inf).stutter(4),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\pos, Pseq([
				Pseq([
					0,3,8,2, 4,3,13,13, 
					8,9,8,13, 7,1,13,9,
				]+16,1),
				Pser([
					0,1,2,3, 4,5,6,6,
					8,7,8,1, 12,2,8,15,
				],8*2),
				Pseq([
					0,3,8,2, 4,3,13,8, 
					3-16,13,8,1-16, 7,1,13,9,
				]+16,1),
				Pser([
					0,8,10,4, 8,10,4,11,
					8,9,10,11, 12,13,14,15,
				],8*2),
				Pseq([
					0,3,8,2, 4,3,13,13, 
					3,13,13,1, 7,1,8,9,
				]+16,1),
				Pser([
					0,3,8,3, 4,1,8,1,
					8,1,5,1, 12,5,6,1,
				],8*2),
				Pser([
					Pseq([
						0,1,2,3, 8,7,8,1, 
						12,2,8,15, 7,7,8,9,
					],1),
					Pseq([
						0,3,8,2, 4,7,8,1, 
						12,2,8,15, 7,7,8,9,
					]+16,1),
				],8*4),
				Plazy({ arg ev;
					var ar;
					ar = (0..31);
					ar[ar.size.rand] = (0..31).choose;
					ar[ar.size.rand] = (0..31).choose;
					Pser(ar,8*4);
				}),
				Pser([
					0,1,2,3, 4,5,6,7,
					8,1,10,11, 12,13,14,15,
					//Pseq((16..31)),
				],8*4),
				Pser([
					0,0,1,0, 4,5,6,7,
					8,9,10,11, 12,13,14,15,
					//Pseq((16..31)),
				],8*4),
				Pser([
					0,1,2,3, 4,5,6,7,
					8,2,1,3, 12,13,14,15,
					//Pseq((16..31)),
				],8*4),
				Pser([
					0,1,2,3, 4,1,2,3,
					8,2,1,3, 12,13,14,15,
					//Pseq((16..31)),
				],8*4),
				Pseq((0..31)),
				Pser([
					0,1,2,3, 4,1,2,3,
					8,9,10,11, 12,13,14,15,
					Pseq((16..31)),
				],8*4),
				Pser([
					0,5,6,2, 4,5,6,7,
					8,9,10,11, 12,13,14,15,
					0,1,2,3, 4,5,6,7,
					7,6,5,4,
					12,10,13,11,
				],8*4),
				Pser([
					0,1,2,3, 8,4,6,7,
					8,9,10,11, 12,13,14,15,
					Pseq((16..31)),
				],8*4),
				Pseq((0..23)),
				Pseq([0,7,8,4, 7,8,7,4].rotate(0)),
			],inf)/8/~t+0.04,
			\speed, 1,
			\gain, 1,
			\freq, 200,
			\legato, 1.00,
			\dur, Pseq([1/8],inf),
			\amp, 0.1,
		),
	])
)).play;
);


