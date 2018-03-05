
(
SynthDef(\pigeon, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1/2,1,1/4],[0.1,0.8,2]), 1);
	env2 = EnvGen.kr(Env([1,1/2,1,1/4],[1.1,1.8,2]), 1);
	env3 = EnvGen.kr(Env([1,1/2,1,1/4],[0.4,1.8,2]), 1);
	sig = LFSaw.ar(freq);
	sig = sig.fold2(env3);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * [env1, env2], \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,1.1,0.2,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\niark, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([8,1,1/4],[0.01,0.8]), 1);
	env2 = EnvGen.kr(Env([8,1/7,1/8],[0.01,0.8]), 1);
	sig = LFSaw.ar(freq * env2);
	sig = ( sig*\distamp.kr(100) ).tanh * \distpostamp.kr(1/2);
	sig = RHPF.ar(sig, \hpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\plop, 
	Ptpar([
		0, PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0, 1,0,
				1,0, 1,1,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		0, PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq({[
				0,0,0,1,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\lag, 0.07,
			\dur, 1/8,
			\amp, 0.1,
		)),
		4, Pbind(
			\instrument, \niark,
			\freq, 200,
			\dur, 1/4,
			\amp, 0.1,
		),
		0,Ppar([
			20.collect({ arg n;
				Pbind(
					\instrument, \pigeon,
					\note, Pseq([
						n*1,
						n*2,
						n*3,
						n*4,
					],inf),
					\legato, 0.2,
					\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 1+n),
					\dur, 1/8 + ( n/8 ),
					\out, BusDef(\fx1, \audio),
					\amp, 0.1/4,
				);
			})
		].flat),
		0,Pmono(\chorusdist,
			\inbus, BusDef(\fx1, \audio),
			\freq, 200,
			\distamp, Pseq([
				50,30,
				500,30,
			],inf),
			\modfreq, 0.100,
			\modamp, Pseg(Pseq([0,1],inf),8),
			\delay, 0.001,
			\gain, 0.3,
			\dur, Pseq([1.23,1].normalizeSum,inf),
			\amp, 0.1,
		),
	])
)).play;
)

/////////////////////


(
Ndef(\crystal, { arg freq=200, pan=0, amp=0.1;
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
}).play;
);

0.51*10
 40.pow(1.1)/100




(
Pdef(\part, Pdef(\plop, 
	Ppar([
		20.collect({ arg n;
			Pbind(
				\instrument, \pigeon,
				\note, Pseq([
					n*1,
					n*2,
					n*3,
					n*4,
				],inf),
				\legato, 0.2,
				\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 1+n),
				\dur, 1/8 + ( n/8 ),
				\amp, 0.1,
			);
		})
	].flat)
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		20.collect({ arg n;
			Pbind(
				\instrument, \pigeon,
				\note, Pseq([
					8.collect({ arg idx;
						1 * (idx+1);
					})
				].flat,inf),
				\legato, 0.2,
				\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 1+n),
				\dur, 1/8 + ( n/8 ),
				\isRest, Pseq([
					Pser([
						0,
					],n*8),
					Pser([
						1,
					],inf),
				],inf).coin.not,
				\amp, 0.1,
			);
		})
	].flat)
)).play;
)

(
Pdef(\part, Pdef(\feyscat, 
	Ppar([
		20.collect({ arg n;
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\pos, Pseq([
					8.collect({ arg idx;
						1 * (idx+1);
					})
				].flat,inf)/16,
				\sustain, 0.06,
				\gain, 0.2 * Pseq([
					1,0.8,1,0.6,
				],inf),
				//\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 1+n),
				\dur, 1/8 + ( n/8 ),
				\lag, n/8/~t,
				\isRest, Pseq([
					Pser([
						0,
					],n*4),
					Pser([
						1,
					],inf),
				],inf).coin.not,
				\amp, 0.1,
			);
		})

	].flat)
)).play;
)

(
Pdef(\part, Pdef(\feyscat, 
	Ppar([
		20.collect({ arg n;
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\pos, Pseq([
					8.collect({ arg idx;
						( n+1 ) * (idx+1);
					})
				].flat,inf)/16,
				\sustain, 0.10,
				\gain, 0.2 * Pseq([
					1,0.8,1,0.6,
				],inf),
				//\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 1+n),
				\dur, 1/8 + ( n/8 ),
				\lag, n/8/~t,
				\isRest, Pseq([
					Pser([
						0,
					],n*2),
					Pser([
						1,
					],inf),
				],inf).coin.not,
				\amp, 0.1,
			);
		})

	].flat)
)).play;
)

(
Pdef(\part, Pdef(\feyscat, 
	Ppar([
		20.collect({ arg n;
			Pseq([
				Pfindur(8,Pbind(	
					//\lag, Pkey(\lag) * 2,
				)),
				Pfindur(8,Pbind(	
					\lag, Pkey(\lag) * 2,
				)),
				Pfindur(8,Pbind(	
					\lag, Pkey(\lag) / 2,
				)),
				Pfindur(8,Pbind(	
					\speed, Pseq([
						0.7,1.2,
					],inf),
				)),
			],inf)<>
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\pos, 
					Pseq([
						8.collect({ arg idx;
							( n+1 ) * (idx+1);
						}),
					].flat,inf)/16,
				\sustain, 0.1,
				\speed, Pseq([
					1,0.9,1.1,0.7,
					1,0.9,1.1,1.3,
				],inf),
				\gain, 0.2 * Pseq([
					1,0.8,1,0.6,
				],inf),
				//\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 1+n),
				\dur, 1/8 + ( n/8 ),
				\lag, n/8/~t,
				\isRest, Pseq([
					Pser([
						0,
					],n*2),
					Pser([
						1,
					],inf),
				],inf).coin.not,
				\amp, 0.1,
			);
		})

	].flat)
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		30.collect({ arg n;
			Pbind(
				\instrument, \pigeon,
				\note, Pseq([
					( n+1 ).collect({ arg idx;
						n * (idx+1);
					})
				].flat,inf),
				\legato, 0.2,
				\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 1+n),
				\isRest, Pseq([
						Pser([
							0,
						],n*8),
						Pser([
							1,
						],inf),
				],inf).coin.not,
				\dur, 1/8 + ( n/8 ),
				\amp, 0.1,
			);
		})
	].flat)
)).play;
)

(
Pdef(\part, Pdef(\piapia, 
	Pbind(\amp, 0.1/4)<>
	Ppar([
		Pbind(
			\instrument, \pigeon,
			\degree, Pseq([
				Ptuple( [
					Pseq(0-(0..8)),
					Pseq((0..8)),
				])
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \pigeon,
			\degree, Pseq([
				Ptuple( [
					Pseq(0-( (0..8)+2 )),
					Pseq((0..8)+2),
				])
			],inf),
			\octave, 4,
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \pigeon,
			\degree, Pseq([
				Ptuple( [
					Pseq(0-( (0..16) )),
					Pseq((0..16)),
				])
			],inf)+5,
			\octave, 5,
			\dur, 1/4+0.1,
			\amp, 0.1,
		),
		//Pdef(\drums),
	].flat)
)).play;
)


(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pseq([
			Pfindur(1.5, Pdef(\piapia)),
			Event.silent(0.5),
		],inf),
		Pdef(\part)
		Pbind(\out, BusDef(\mixer6))<> Pdef(\drums),
	])
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pseq([
			Pbind(\out, BusDef(\mixer4))<>Pfindur(1.5, Pdef(\piapia)),
			Event.silent(0.5),
		],inf),
		Pbind(\out, BusDef(\mixer5))<>Pdef(\feyscat),
		Pbind(\out, BusDef(\mixer6))<> Pdef(\drums),
	])
)).play;
)

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
)).play;
);

Pdef(\drums).play


(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
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
				\isRest, true,
			),
		Pbind(\out, BusDef(\mixer5))<>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
					0,0,0,0, 0,1,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,1,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2 * Pseg(Pseq([0,1],inf),8),
				\gain, Pkey(\gain) * Pseq([
					0.3,0.5,1,0.5,
				],inf),
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,0,0, 1,1,1,0,
					1,1,0,0, 0,1,1,1,
				],inf).coin.not,
				\gain, 0.4* Pseq([
					1,0.2,
				],inf),
				\gain, Pkey(\gain) * Pseg(Pseq([0,0.1,1,0.4,1.1],inf),2),
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
		20.collect({ arg n;
			Pbind(
				\instrument, \pigeon,
				\note, Pseq([
					n*1,
					n*2,
					n*3,
					n*4,
				],inf),
				\legato, 0.2,
				\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 1+n),
				\dur, 1/8 + ( n**2/16 ),
				\amp, 0.1/3,
			);
		})
	].flat)
)).play;
)



(
Pdef(\part, Pdef(\drums, 
	Ppar([
			Pseq([
				Pfindur(24,Ppar([
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 1,
						\isRest, Pseq([
							1,0,0,1, 0,0,1,0,
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
						\sustain, 0.05,
						\adsr, Pseq([
							[ Env.adsr(0.01,0.1,0.8,0.2) ],
						],inf),
						\speed, 0.95,
						\gain, 0.2,
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
				Ptpar([
					4, PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 1,
						\isRest, Pseq([
							1,0,0,0, 0,0,0,1,
							1,0,0,0, 0,0,0,1,
							1,0,1,0, 0,0,0,1,
							1,0,0,1, 0,0,0,1,
						],1).coin.not,
						\sustain, 0.1,
						\dur, 1/8,
						\amp, 0.1,
					)),
					6, PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 8,
						\isRest, Pseq([
							1,0,1,0, 1,1,1,0,
							1,1,1,1, 1,1,1,1,
						],1).coin.not,
						\gain, 0.4* Pseq([
							1,0.2,
						],inf),
						\sustain, 0.05,
						\dur, 1/8,
						\amp, 0.1,
					)),
				]),
			],inf),
	])
)).play;
)



///////////////////////////////////



(
Pdef(\part, Pdef(\plop, 
	Ptpar([
		0, PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0, 0,0, 1,0, 0,1,
				1,0, 0,0, 1,0, 0,1,
				1,0, 0,0, 1,0, 0,1,
				1,0, 0,0, 1,1, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,0, 0,0, 1,1, 1,1,
			],inf).coin.not,
			\sustain, Pseq([
				Pser([
					0.01,0.1
				],4*8-2),0.1,0.1,
				Pser([
					0.1,
				],4*8),
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		)),
		0, PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq({[
				0,0,0,1,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\lag, 0.07,
			\dur, 1/8,
			\amp, 0.1,
		)),
		4, PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,1,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\lag, 0.00,
			\dur, 1/16,
			\amp, 0.1,
		)),
		0, Pbind(
			\instrument, \niark,
			\freq, 400,
			\sustain, 0.01,
			\isRest, Pseq([
				0,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
		),
		0, Pseq([
			Pfindur(3.5,Ppar([
				20.collect({ arg n;
					Pbind(
						\instrument, \pigeon,
						\note, Pseq([
							n*1,
							n*2,
							n*3,
							n*4,
						],inf),
						\legato, 0.2,
						\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 1+n),
						\dur, 1/8 + ( n/8 ),
						\out, BusDef(\fx1, \audio),
						\amp, 0.1/4,
					);
				})
			].flat)),
			Event.silent(4.5),
		],inf),
		0,Pmono(\chorusdist,
			\inbus, BusDef(\fx1, \audio),
			\freq, 200,
			\distamp, Pseq([
				50,30,
				500,30,
			],inf),
			\modfreq, 0.100,
			\modamp, Pseg(Pseq([0,1],inf),8),
			\delay, 0.001,
			\gain, 0.3,
			\dur, Pseq([1.23,1].normalizeSum,inf),
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ptpar([
		0, PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 0,1, 1,0, 0,1,
				1,1, 0,0, 1,0, 1,1,
				1,0, 0,0, 1,1, 1,1,

				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,0, 0,0, 1,1, 1,1,
				1,0, 0,0, 1,0, 0,1,
				1,0, 0,0, 1,0, 0,1,
				1,0, 0,0, 1,0, 0,1,
				1,0, 0,0, 1,1, 1,1,
			],inf).coin.not,
			\sustain, Pseq([
				Pser([
					0.1,
					0.1,
					0.1,
					0.1,
					0.1,
					0.1,
					0.01,0.1
				],inf)
			],inf),
			\dur, 1/8,
			\amp, 0.1,
						\out, BusDef(\fx1, \audio),
		)),
		0, PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				0,0,0,1, 0,0,0,1,
				0,0,0,1, 0,0,1,1,
				0,0,0,1, 0,1,0,1,
				0,0,0,1, 0,1,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\lag, 0.07,
			\dur, 1/8,
			\amp, 0.1,
						\out, BusDef(\fx1, \audio),
		)),
		0, PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,1,0,1,
			],inf).coin.not,
			\sustain, 0.01 * Pseq([
				1,9,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.7) ],
			],inf),
			\lag, 0.00,
			\dur, 1/16,
						\out, BusDef(\fx1, \audio),
			\amp, 0.1,
		)),
		0, Pbind(
			\instrument, \niark,
			\freq, 400,
			\sustain, 0.01,
			\isRest, Pseq([
				0,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
		),
		0, Pseq([
			Pfindur(3.5,Ppar([
				10.collect({ arg n;
					Pbind(
						\instrument, \pigeon,
						\note, Pseq([
							n*1,
							n*2,
						],inf),
						\legato, 0.2,
						\lpfr, ~pmodenv.(Pseq([1,2,1,4],inf), 1+n),
						\dur, 1/8 + ( n/8 ),
						\out, BusDef(\fx1, \audio),
						\amp, 0.1/4,
						\isRest, true,
					);
				})
			].flat)),
			Event.silent(4.5),
		],inf),
		0,Pmono(\chorusdist,
			\inbus, BusDef(\fx1, \audio),
			\mix, 1/2,
			\freq, 200,
			\distamp, Pseq([
				50,30,
				60,30,
			],inf),
			\modfreq, 0.100,
			\modamp, Pseg(Pseq([0,1],inf),8),
			\delay, 0.001,
			\gain, 0.3,
			\dur, Pseq([1.23,1].normalizeSum,inf),
			\amp, 0.1,
		),
	])
)).play;
)
