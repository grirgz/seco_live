(
SynthDef(\star, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1;
	var fspread;
	env1 = EnvGen.kr(Env([1,2,1],[1.7,0.8]), 1);
	fspread = 0.0007 + Rand(0,0.007);
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1));
	sig = sig * ( sig/(sig+1.1)*50 * env1 ).clip(0.5);
	sig1 = sig * (sig.abs > Rand(0.1,0.7));
	sig = SelectX.ar( EnvGen.kr(Env([0,1,0],[0.1+Rand(0,2.0),0.1+Rand(0,2.0)]), 1), [sig, sig1]);
	sig = sig * 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = sig /10;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\star2, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1;
	var fspread;
	env1 = EnvGen.kr(Env([1,2,1],[1.7,0.8]), 1);
	fspread = 0.0007 + Rand(0,0.007);
	sig = LFSaw.ar(freq * \modfreq.kr(1) * ((0..7)/7 - 0.5 * fspread + 1));
	sig = sig + SinOsc.ar(freq * \modfreq.kr * ((0..7)/7 - 0.5 * fspread + 1));

	sig1 = CombL.ar(sig, 0.1, 1/( freq * env1 ),4.5)/2+sig  / 4;
	sig = SelectX.ar( EnvGen.kr(Env([0,1,0],[0.1+Rand(0,2.0),0.1+Rand(0,2.0)]), 1), [sig, sig1]);

	sig1 = CombL.ar(sig, 0.1, 1/freq * env1,4.5)/2+sig  / 4;
	sig = SelectX.ar( EnvGen.kr(Env([0,1,0],[0.1+Rand(0,2.0),0.1+Rand(0,2.0)]), 1), [sig, sig1]);

	sig = sig * ( sig/(sig+1.1)*50 * env1 ).clip(0.5);
	sig1 = sig * (sig.abs > Rand(0.1,0.7));
	sig = SelectX.ar( EnvGen.kr(Env([0,1,0],[0.1+Rand(0,2.0),0.1+Rand(0,2.0)]), 1), [sig, sig1]);
	sig = sig * 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = sig /10;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)


/////////////////////////////// PARTS

(
	~master.();
Pdef(\part, Pdef(\t2_intro, 
	Ptpar([
		0, Pdef(\bass) <> Pbind(
			\instrument, \distbass,
			\freq, 70 * Pseq([
				2,5/4,4/3,1,
				2,5/4,4/3,1,
				2,5/4,4/3,1,
				2,5/4,4/3, Pwhite(1,3.0,1),
				Pser([
					\r
				],16),
			]+0.5,inf),
			\rq, Pseg(Pseq([1,0.01],inf),16),
			\adsr, Pseq([
				Plazy({ arg ev;
					Pseq(
						8.collect { arg idx;
							[ Env.adsr(0.1,0.1,0.8,idx/8+0.01) ]
						};
					,1);
				}).stutter(8).loop,
			],inf),
			\lag, Pseq([0,Pwhite(0.0,0.2,3)],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		4, Pdef(\pad) <> Pmono( \distbass,
			\freq, 70 * Pseq([
				8
			],inf),
			\rq, Pseq([1,0.01],inf),
			\adsr, Pseq([
				Plazy({ arg ev;
					Pseq(
						8.collect { arg idx;
							[ Env.adsr(0.1,0.1,0.8,idx/8+0.01) ]
						};
					,1);
				}).stutter(8).loop,
			],inf),
			\lag, Pseq([0,Pwhite(0.0,0.2,3)],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		8, Pdef(\piano) <> Pbind(
			\instrument,\star,
			\freq, 70 * [1,2,4,47/56] * 4 * Pstep(Pseq([1,7/9],inf),1/2) * 2,
			\spread, 100.001 * Pseq([1,1/200000],inf),
			\dur, PdurStutter(Pseq([Pser([4],5)],inf), 1/2),
			\adsr, Pseq([
				Pser([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],4),
			],inf),
			\legato, 0.5,
			\amp, 0.1,
		),
		12, PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		12, PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\pos, Pseq([
				Pseg(Pseq([0.04,0.04,1],inf),Pseq([1,3,0],inf)),
			],inf),
			\sustain, 0.1,
			\dur, 1/16,
			\amp, 0.1,
		)),
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\t2_verse1, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\pos, Pseq([
				Pseg(Pseq([0.04,0.04,1],inf),Pseq([1,3,0],inf)),
			],inf),
			\sustain, 0.1,
			\dur, 1/16,
			\amp, 0.1,
		)),
		Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
				
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.05,
		),
		Pdef(\bass) <> Pbind(
			\instrument, \distbass,
			\freq, 70 * Pseq([
				Pser([
					1
				],12),
				Pser([
					2
				],4),
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\pad) <> Pbind(
			\instrument,\star,
			\freq, 70 * [1,2,4,47/56] * 4 * Pstep(Pseq([1,7/9],inf),1/2) * 2,
			\spread, 100.001 * Pseq([1,1/200000],inf),
			\dur, PdurStutter(Pseq([Pser([1],5),4],inf), 1/2),
			\adsr, Pseq([
				Pser([
					[ Env.adsr(0.01,0.1,0.8,1.1) ],
				],5),
				Pser([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],4),
			],inf),
			\legato, 0.5,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\t2_break, 
	Ppar([
		
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,1, 0,1,1,0,
				1,1,1,0, 1,0,1,1,
				0,0,1,0, 0,1,1,0,
				0,1,0,0, 1,0,1,0,
				1,0,1,1, 0,1,1,0,
				1,1,1,0, 1,0,1,1,
			],inf).coin.not,
			\pos, Pseq([
				Pseg(Pseq([0.04,0.04,1],inf),Pseq([1,3,0],inf)),
			],inf),
			\sustain, 0.1,
			\dur, 1/16,
			\amp, 0.1,
		)),
		Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,1,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,1, 1,0,1,0,
				1,1,1,0, 1,0,1,1,
				1,1,1,0, 1,1,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
				
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.05,
		),
		Pdef(\bass) <> Pbind(
			\instrument, \distbass,
			\freq, 70 * Pseq([
				2,5/4,4/3,1,
				2,5/4,4/3,1,
				2,5/4,4/3,1,
				2,5/4,4/3, Pwhite(1,3.0,1),
				Pser([
					\r
				],16),
			]+0.5,inf),
			\lag, Pseq([0,Pwhite(0.0,0.2,3)],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\t2_chorus, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,1,
					
					0,0,0,0, 0,0,0,0,
					1,1,0,0, 1,0,1,1,
					
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 1,1,1,0,
					
					0,0,0,0, 0,1,0,0,
					1,0,0,1, 1,0,0,1,
				],inf),
			],inf).coin.not,
			\pos, Pseq([
				Pseg(Pseq([0.04,0.04,0.1],inf),Pseq([2,2,0]/4,inf)),
			],inf),
			\sustain, Pseq([1,Pser([1/2],7)],inf) * 0.1,
			\dur, 1/16,
			\amp, 0.1,
		)),
		Ptpar([
			0, Pdef(\hat) <> Pbind(
				\instrument, \phyhat,
				\isRest, Pseq([
					1,0,0,0, 1,0,1,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,0, 1,0,1,0,
					1,0,1,1, 1,0,0,0,
					1,0,0,0, 1,0,1,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 1,0,1,0,
					1,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.5,Pser([
						0.04,
					],15),
					0.05,Pser([
						0.4,0.04,
					],15),
				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.05,
			),
			2, Pdef(\bass) <> Pbind(
				\instrument, \distbass,
				\freq, 70 * Pseq([
					Pser([
						1
					],12),
					Pser([
						2
					],4),
				],inf),
				\isRest, Pseq([
					1,1,1,1, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			2, Pdef(\piano) <> Pbind(
				\instrument,\star,
				\freq, 70 * [1,2,4,47/56] * 4 * Pstep(Pseq([1,7/9],inf),1/2) * 2,
				\spread, 100.001 * Pseq([1,1/200000],inf),
				\dur, PdurStutter(Pseq([Pser([1],5),4],inf), 1/2),
				\adsr, Pseq([
					Pser([
						[ Env.adsr(0.01,0.1,0.8,1.1) ],
					],5),
					Pser([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],4),
				],inf),
				\isRest, Pseq([
					0,1,
				],inf).coin.not,
				\legato, 0.5,
				\amp, 0.1,
			),
		],inf),
		Pdef(\pad) <> Pbind(
			\instrument, Pseq([\oscsampler3],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\range, 0.001 * Pseq([
				Pser([
					0.1,1,1,1,
					1/2,1,1,1,
				],16),
				Pser([
					0.1
				],16),
			],inf) * Pseq([1/12,1],inf).stutter(32),
			\posenv, Pseq([
				Pser([
					[ Env([0.004,0.0249,0.1071].integrate.postln,[0.02,2.4]) ],
				],2),
				Pser([
					[ Env([0.004,0.0019,0.3071].integrate.postln,[1.22,8.4]) ],
					[ Env([0.004,0.0049,0.1071].integrate.postln,[0.02,2.4]) ],
				],2),
			],inf).stutter(16),
			\levelScale, 1,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
					0,1,1,0, 1,0,0,0,
					0,0,1,0, 0,1,0,1,
				],4),
			],inf).coin.not,
			\speed, 1/4,
			\legato, Pseq([
				Pser([
					8.2, 1.2, 2.2, 8.2,   8.2, 8.2, 8.2, 8.2,
					8.2, 8.2, 3.2, 8.2,   8.2, 3.2, 2.2, 2.2,
				],8*2)*1,
			],inf) * Pseq([1,1/8,1,1],inf).stutter(4),
			\gain, 0.6,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\t2_bridgeprep, 
	Ptpar([
		0, Pdef(\bass) <> Pbind(
			\instrument, \distbass,
			\freq, 70 * Pseq([
				2,5/4,4/3,1,
				2,5/4,4/3,1,
				2,5/4,4/3,1,
				2,5/4,4/3, Pwhite(1,3.0,1),
				Pser([
					\r
				],16),
			]+0.5,inf),
			\rq, Pseg(Pseq([1,0.01],inf),16),
			\adsr, Pseq([
				Plazy({ arg ev;
					Pseq(
						8.collect { arg idx;
							[ Env.adsr(0.1,0.1,0.8,idx/8+0.01) ]
						};
					,1);
				}).stutter(8).loop,
			],inf),
			\lag, Pseq([0,Pwhite(0.0,0.2,3)],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		4, Pdef(\pad) <> Pmono( \distbass,
			\freq, 70 * Pseq([
				8
			],inf),
			\rq, Pseq([1,0.01],inf),
			\adsr, Pseq([
				Plazy({ arg ev;
					Pseq(
						8.collect { arg idx;
							[ Env.adsr(0.1,0.1,0.8,idx/8+0.01) ]
						};
					,1);
				}).stutter(8).loop,
			],inf),
			\lag, Pseq([0,Pwhite(0.0,0.2,3)],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		8, Pdef(\piano) <> Pbind(
			\instrument,\star,
			\freq, 70 * [1,2,4,47/56] * 4 * Pstep(Pseq([1,7/9],inf),1/2) * 2,
			\spread, 100.001 * Pseq([1,1/200000],inf),
			\dur, PdurStutter(Pseq([Pser([4],5)],inf), 1/2),
			\adsr, Pseq([
				Pser([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],4),
			],inf),
			\legato, 0.5,
			\amp, 0.1,
		),
		12, PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		12, PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\pos, Pseq([
				Pseg(Pseq([0.04,0.04,1],inf),Pseq([1,3,0],inf)),
			],inf),
			\sustain, 0.1,
			\dur, 1/16,
			\amp, 0.1,
		)),
	])
)).play;
);

(
Pdef(\part, Pdef(\t2_bridge, 
	Ptpar([
		0,PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		0,PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,1,

				0,0,0,0, 0,0,0,0,
				1,1,0,0, 1,0,1,1,

				0,0,0,0, 0,0,0,0,
				1,0,0,1, 1,1,1,0,

				0,0,0,0, 0,1,0,0,
				1,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\pos, Pseq([
				Pseg(Pseq([0.04,0.04,0.1],inf),Pseq([2,2,0]/4,inf)),
			],inf),
			\sustain, Pseq([1,Pser([1/2],7)],inf) * 0.1,
			\dur, 1/16,
			\amp, 0.1,
		)),
		0,Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				1,0,1,1, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 1,0,1,0,
				1,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.05,
		),
		0, Pdef(\bass) <> Pbind(
			\instrument, \distbass,
			\freq, 70 * Pseq([
				2,5/4,4/3,1,
				2,5/4,4/3,1,
				2,5/4,4/3,1,
				2,5/4,4/3, Pwhite(1,3.0,1),
				Pser([
					\r
				],16),
			]+0.5,inf),
			\rq, Pseg(Pseq([1,0.01],inf),16),
			\adsr, Pseq([
				Plazy({ arg ev;
					Pseq(
						8.collect { arg idx;
							[ Env.adsr(0.1,0.1,0.8,idx/8+0.01) ]
						};
					,1);
				}).stutter(8).loop,
			],inf),
			\lag, Pseq([0,Pwhite(0.0,0.2,3)],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		4, Pdef(\pad) <> Pmono( \distbass,
			\freq, 70 * Pseq([
				8
			],inf),
			\rq, Pseq([1,0.01],inf),
			\adsr, Pseq([
				Plazy({ arg ev;
					Pseq(
						8.collect { arg idx;
							[ Env.adsr(0.1,0.1,0.8,idx/8+0.01) ]
						};
					,1);
				}).stutter(8).loop,
			],inf),
			\lag, Pseq([0,Pwhite(0.0,0.2,3)],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		8, Pdef(\piano) <> Pbind(
			\instrument,\star,
			\freq, 70 * [1,2,4,47/56] * 4 * Pstep(Pseq([1,7/9],inf),1/2) * 2,
			\spread, 100.001 * Pseq([1,1/200000],inf),
			\dur, PdurStutter(Pseq([Pser([4],5)],inf), 1/2),
			\adsr, Pseq([
				Pser([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],4),
			],inf),
			\legato, 0.5,
			\amp, 0.1,
		),
		4, Pdef(\pad) <> Pbind(
			\instrument, Pseq([\oscsampler3],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\range, 0.001 * Pseq([
				Pser([
					0.1,1,1,1,
					1/2,1,1,1,
				],16),
				Pser([
					0.1
				],16),
			],inf) * Pseq([1/12,1],inf).stutter(32),
			\posenv, Pseq([
				Pser([
					[ Env([0.004,0.0249,0.1071].integrate.postln,[0.02,2.4]) ],
				],2),
				Pser([
					[ Env([0.004,0.0019,0.3071].integrate.postln,[1.22,8.4]) ],
					[ Env([0.004,0.0049,0.1071].integrate.postln,[0.02,2.4]) ],
				],2),
			],inf).stutter(16),
			\levelScale, 1,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
					0,1,1,0, 1,0,0,0,
					0,0,1,0, 0,1,0,1,
				],4),
			],inf).coin.not,
			\speed, 1/4,
			\legato, Pseq([
				Pser([
					8.2, 1.2, 2.2, 8.2,   8.2, 8.2, 8.2, 8.2,
					8.2, 8.2, 3.2, 8.2,   8.2, 3.2, 2.2, 2.2,
				],8*2)*1,
			],inf) * Pseq([1,1/8,1,1],inf).stutter(4),
			\gain, 0.6,
			\dur, 1/8,
			\amp, 0.1,
		),
		12, PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		12, PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\pos, Pseq([
				Pseg(Pseq([0.04,0.04,1],inf),Pseq([1,3,0],inf)),
			],inf),
			\sustain, 0.1,
			\dur, 1/16,
			\amp, 0.1,
		)),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\t2_verse2, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,1,

				0,0,0,0, 0,0,0,0,
				1,1,0,0, 1,0,1,1,

				0,0,0,0, 0,0,0,0,
				1,0,0,1, 1,1,1,0,

				0,0,0,0, 0,1,0,0,
				1,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\pos, Pseq([
				Pseg(Pseq([0.04,0.04,0.1],inf),Pseq([2,2,0]/4,inf)),
			],inf),
			\sustain, Pseq([1,Pser([1/2],7)],inf) * 0.1,
			\dur, 1/16,
			\amp, 0.1,
		)),
		Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				1,0,1,1, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 1,0,1,0,
				1,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.05,
		),
		Pdef(\bass) <> Pbind(
			\instrument, \distbass,
			\freq, 70 * Pseq([
				Pser([
					1
				],12),
				Pser([
					2
				],4),
			],inf),
			\isRest, Pseq([
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\piano) <> Pbind(
			\instrument,\star,
			\freq, 70 * [1,2,4,47/56] * 4 * Pstep(Pseq([1,7/9],inf),1/2) * 2,
			\spread, 100.001 * Pseq([1,1/200000],inf),
			\dur, PdurStutter(Pseq([Pser([1],5),4],inf), 1/2),
			\adsr, Pseq([
				Pser([
					[ Env.adsr(0.01,0.1,0.8,1.1) ],
				],5),
				Pser([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],4),
			],inf),
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\legato, 0.5,
			\amp, 0.1,
		),
		Pdef(\pad) <> Pbind(
			\instrument, Pseq([\oscsampler3],inf).stutter(8*4),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\range, 0.00001 * Pseq([
				1
			],inf),
			\posenv, Pseq([
				Pser([
					[ Env([0.004,0.0249,0.1071].integrate.postln,[0.02,2.4]) ],
				],2),
			],inf).stutter(16),
			\levelScale, 1,
			\isRest, Pseq([
				Pseq([
					1,0,0,1, 0,0,0,0,
				],4),
			],inf).coin.not,
			\speed, 1/4,
			\legato, 1,
			\gain, 0.6,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
~master.();
Pdef(\part,Pdef(\t2_outro, 
	Ppar([
		Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				1,0,1,1, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 1,0,1,0,
				1,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.05 * Pseg(Pseq([1,0,0,0,0,0],inf),8),
		),
		Pdef(\piano) <> Pbind(
			\instrument,\star,
			\freq, 70 * [1,2,4,47/56] * 4 * Pstep(Pseq([1,7/9],inf),1/2) * 2,
			\spread, 100.001 * Pseq([1,1/200000],inf),
			\dur, PdurStutter(Pseq([Pser([1],5),4],inf), 1/2),
			\adsr, Pseq([
				Pser([
					[ Env.adsr(0.01,0.1,0.8,1.1) ],
				],5),
				Pser([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],4),
			],inf),
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\legato, 0.5,
			\amp, 0.1,
		),
	])
)).play;
)

//////////////////////// MAIN

(
	~master.();
Pdef(\main,Pdef(\track2, 
	Pseq([
//		Pfindur(16,Pdef(\t2_intro)),
//		Pfindur(16,Pdef(\t2_verse1)), // focus:rix&perc
//		Pfindur(16,Pdef(\t2_break)), // focus:bass&perc
		Pfindur(16,Pdef(\t2_chorus)),
		Pfindur(16,Pdef(\t2_bridgeprep)),
		Pfindur(16,Pdef(\t2_bridge)),
		Pfindur(16,Pdef(\t2_verse2)),
		Pfindur(16,Pdef(\t2_outro)),
	])
)).play;
);








///////////////////////////////////////// IDEAS
(
	~master.();
Pdef(\track2_idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,1, 0,1,1,0,
				1,1,1,0, 1,0,1,1,
				0,0,1,0, 0,1,1,0,
				0,1,0,0, 1,0,1,0,
				1,0,1,1, 0,1,1,0,
				1,1,1,0, 1,0,1,1,
			],inf).coin.not,
			\pos, Pseq([
				Pseg(Pseq([0.04,0.04,1],inf),Pseq([1,3,0],inf)),
			],inf),
			\sustain, 0.1,
			\dur, 1/16,
			\amp, 0.1,
		)),
		Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,1,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,1, 1,0,1,0,
				1,1,1,0, 1,0,1,1,
				1,1,1,0, 1,1,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
				
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.05,
		),
		Pdef(\bass) <> Pbind(
			\instrument, \distbass,
			\freq, 70 * Pseq([
				2,5/4,4/3,1,
				2,5/4,4/3,1,
				2,5/4,4/3,1,
				2,5/4,4/3, Pwhite(1,3.0,1),
				Pser([
					\r
				],16),
			]+0.5,inf),
			\lag, Pseq([0,Pwhite(0.0,0.2,3)],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
).play;
)

(
	~master.();
Pdef(\track2_idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\pos, Pseq([
				Pseg(Pseq([0.04,0.04,1],inf),Pseq([1,3,0],inf)),
			],inf),
			\sustain, 0.1,
			\dur, 1/16,
			\amp, 0.1,
		)),
		Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
				
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.05,
		),
		Pdef(\bass) <> Pbind(
			\instrument, \distbass,
			\freq, 70 * Pseq([
				Pser([
					1
				],12),
				Pser([
					2
				],4),
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\pad) <> Pbind(
			\instrument,\star,
			\freq, 70 * [1,2,4,47/56] * 4 * Pstep(Pseq([1,7/9],inf),1/2) * 2,
			\spread, 100.001 * Pseq([1,1/200000],inf),
			\dur, PdurStutter(Pseq([Pser([1],5),4],inf), 1/2),
			\adsr, Pseq([
				Pser([
					[ Env.adsr(0.01,0.1,0.8,1.1) ],
				],5),
				Pser([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],4),
			],inf),
			\legato, 0.5,
			\amp, 0.1,
		),
		
	])
).play;
)

(
	~master.();
Pdef(\track2_idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,1,

				0,0,0,0, 0,0,0,0,
				1,1,0,0, 1,0,1,1,

				0,0,0,0, 0,0,0,0,
				1,0,0,1, 1,1,1,0,

				0,0,0,0, 0,1,0,0,
				1,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\pos, Pseq([
				Pseg(Pseq([0.04,0.04,0.1],inf),Pseq([2,2,0]/4,inf)),
			],inf),
			\sustain, Pseq([1,Pser([1/2],7)],inf) * 0.1,
			\dur, 1/16,
			\amp, 0.1,
		)),
		Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				1,0,1,1, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 1,0,1,0,
				1,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.05,
		),
		Pdef(\bass) <> Pbind(
			\instrument, \distbass,
			\freq, 70 * Pseq([
				Pser([
					1
				],12),
				Pser([
					2
				],4),
			],inf),
			\isRest, Pseq([
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\piano) <> Pbind(
			\instrument,\star,
			\freq, 70 * [1,2,4,47/56] * 4 * Pstep(Pseq([1,7/9],inf),1/2) * 2,
			\spread, 100.001 * Pseq([1,1/200000],inf),
			\dur, PdurStutter(Pseq([Pser([1],5),4],inf), 1/2),
			\adsr, Pseq([
				Pser([
					[ Env.adsr(0.01,0.1,0.8,1.1) ],
				],5),
				Pser([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],4),
			],inf),
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\legato, 0.5,
			\amp, 0.1,
		),
		Pdef(\pad) <> Pbind(
			\instrument, Pseq([\oscsampler3],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\range, 0.001 * Pseq([
				Pser([
					0.1,1,1,1,
					1/2,1,1,1,
				],16),
				Pser([
					0.1
				],16),
			],inf),
			\posenv, Pseq([
				[ Env([0.004,0.0019,0.3071].integrate.postln,[1.22,8.4]) ],
				[ Env([0.004,0.0049,0.1071].integrate.postln,[0.02,2.4]) ],
			],inf).stutter(16),
			\levelScale, 1,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\speed, 1/4,
			\legato, Pseq([
				Pser([
					8.2,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
).play;
)

	(
	~master.();
Pdef(\part, Pdef(\xxx, 
	Pseq([
		Pfindur(4,
			Pdef(\t2_verse1),
		),
		Pfindur(12,
			Pdef(\t2_verse1_explore),
		),
	])
)).play;
	)

(
	// explore
	~master.();
Pdef(\part, Pdef(\t2_verse1_explore, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 1/2,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				Pseq([
					0,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\pos, Pseq([
				0.04,
			],inf),
			\sustain, 0.1,
			\gain, 1/2,
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,1,

				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,1,

					0,0,0,0, 0,1,0,1,
					0,1,0,0, 0,0,0,1,
					0,0,1,0, 0,1,0,0,
					1,0,1,0, 0,0,1,1,
				],inf),
			],inf).coin.not,
			\pos, Pseq([
				Pseg(Pseq([0.04,0.04,1],inf),Pseq([1,3,0]*2,inf)),
			],inf),
			\sustain, 0.1,
			\gain, 1/2,
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				Pseq([
					0,1,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					
					0,1,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf),
			],inf).coin.not,
			\pos, Pseq([
				Pseg(Pseq([1.04,1.04,0.4],inf),Pseq([1,3,0]*2,inf)),
			],inf),
			\sustain, 0.1,
			\gain, 1/2,
			\dur, 1/16,
			\amp, 0.1,
		)),
		Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0, 1,0,1,1, 1,0,1,1,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,0,0, 1,0,1,1, 1,0,1,0,

				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0, 1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
				
			],inf),
			\dur, 1/16,
			\gain, 1/2,
			\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.05,
		),
		Pdef(\bass) <> Pbind(
			\instrument, \distbass,
			\freq, 70 * Pseq([
				Pser([
					2
				],12),
				Pser([
					1
				],4),
			],inf),
			\fmrange, 10.40,
			\fmfreq, ~pmodenv.(Pseq(1/[1,1.2,1,1.4],inf), 8),
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
				7,0,0,0, 0,0,0,1,
				7,0,0,0, 0,0,0,0,
				3,0,0,0, 0,1.8,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.2,
		),
		Pdef(\pad) <> Pbind(
			\instrument,\star2,
			\freq, 70 * [1,2,4,47/56] * 4 * Pstep(Pseq([1,7/9],inf),1/2) * 2,
			\freq, ~pmodenv.(70 * [1,2,4,47/56] * 4 * Pstep(Pseq([1,7/9],inf),1/2) * 2, 8),
			\spread, 100.001 * Pseq([1/200000],inf),
			\dur, PdurStutter(Pseq([Pser([1],5),4],inf), 1/2),
			\dur, 1/8,
			\legato, Pseq([
				1,0,2,0,
				1,0,1,1,
				1,0,2,0,
				1,1,2,0,

				1,0,2,0,
				1,0,2,0,
				0,0,0,0,
				0.1,0.1,0,0, 1,1,1,1,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				Pser([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],4),
			],inf),
			\amp, 0.2,
		),
	])
)).play;
);
