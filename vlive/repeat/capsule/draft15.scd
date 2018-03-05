
(
SynthDef(\simplebass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);
	sig = sig / 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);

	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)

FileSystemProject.load("libdef/piano.scd")

ProtoDef(\piano).startControl
piano	

Pdef(\pia).clear;

{ SinOsc.ar(200) ! 2 * 0.1}.play;

(
Pdef(\pia, 
	Ppar([
		Pbind( // root
			\instrument, \simplebass,
			\degree, Pstep(Pseq([
				0,1
			],inf),1),
			\isRest, Pseq([
				Plazy({ arg ev;
					Pseq({[
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,1,
						1,0,1,0, 1,1,0,0,
						1,1,0,1, 1,1,1,1,
						
						0,0,0,0,  
						1,0,0,0, 
						1,0,1,0,  
						0,0,1,0,  
						1,1,1,1, 
						1,1,0,0,  
						0,0,1,1,  
					].clump(4).choose}.dup(4).flat,2)
				}),
			],inf).coin.not,
			\lpf, 500,
			\dur, 1/16,
			\amp, 0.1,
		),
		Pbind( // treb
			\instrument, \simplebass,
			\degree, Prand([
				3,4
			],inf),
			\lpf, 5000,
			\isRest, Pseq([
				Plazy({ arg ev;
					Pseq({[
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,1,
						1,0,1,0, 1,1,0,0,
						1,1,0,1, 1,1,1,1,

						0,0,0,0,  
						1,0,0,0, 
						1,0,1,0,  
						0,0,1,0,  
						1,1,1,1, 
						1,1,0,0,  
						0,0,1,1,  
					].clump(4).choose}.dup(8).flat,2)
				}).loop,
			],inf).coin.not,
			\dur, 1/16,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\amp, 0.1/2,
		),
		
	])
).play;
);


(
Pdef(\pia, 
	Ppar([
		Pbind( // root
			\instrument, \simplebass,
			\degree, Pstep(Pseq([
				5
			],inf),1),
			\isRest, Pseq([
				Plazy({ arg ev;
					Pseq({[
						1,0,0,1, 0,0,1,0,

						1,1,1,1, 1,1,1,1,
						1,1,0,0, 1,1,0,0, 
						0,0,1,1, 0,0,1,1, 
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0, 
						0,0,1,0, 0,0,1,0, 
						0,0,0,0, 1,0,0,0, 
					].clump(8).choose}.dup(4).flat,1)
				}),
			],inf).coin.not,
			\lpf, 1000,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\amp, 0.1,
		),
		Pbind( // root
			\instrument, \simplebass,
			\degree, Pstep(Pseq([
				3
			],inf),1),
			\isRest, Pseq([
				Plazy({ arg ev;
					Pseq({[
						1,0,0,1, 0,0,1,0,

						1,1,1,1, 1,1,1,1,
						1,1,0,0, 1,1,0,0, 
						0,0,1,1, 0,0,1,1, 
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0, 
						0,0,1,0, 0,0,1,0, 
						0,0,0,0, 1,0,0,0, 
					].clump(8).choose}.dup(4).flat,1)
				}),
			],inf).coin.not,
			\lpf, 2000,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\amp, 0.1,
		),
		Pbind( // root
			\instrument, \simplebass,
			\degree, Pstep(Pseq([
				0,1
			],inf),1),
			\isRest, Pseq([
				Plazy({ arg ev;
					Pseq({[
						1,0,0,1, 0,0,1,0,

						1,1,1,1, 1,1,1,1,
						1,1,0,0, 1,1,0,0, 
						0,0,1,1, 0,0,1,1, 
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0, 
						0,0,1,0, 0,0,1,0, 
						0,0,0,0, 1,0,0,0, 
					].clump(8).choose}.dup(4).flat,1)
				}),
			],inf).coin.not,
			\lpf, 4000,
			\dur, 1/16,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.7) ],
			],inf),
			\amp, 0.1,
		),

		Pbind( // root
			\instrument, \simplebass,
			\degree, Pstep(Pseq([
				0,1
			],inf),1),
			\isRest, Pseq([
				Plazy({ arg ev;
					Pseq({[
						1,0,0,1, 0,0,1,0,

						1,1,1,1, 1,1,1,1,
						1,1,0,0, 1,1,0,0, 
						0,0,1,1, 0,0,1,1, 
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0, 
						0,0,1,0, 0,0,1,0, 
						0,0,0,0, 1,0,0,0, 
					].clump(8).choose}.dup(4).flat,1)
				}),
			],inf).coin.not,
			\lpf, 4000,
			\dur, 1/16,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.7) ],
			],inf),
			\amp, 0.1,
		),
		Pbind( // treb
			\instrument, \simplebass,
			\degree, Prand([
				3,4
			],inf),
			\lpf, 5000,
			\isRest, Pseq([
				Plazy({ arg ev;
					Pseq({[
						1,0,0,1, 0,0,1,0,
						1,1,1,1, 1,1,1,1,
						1,1,0,0, 1,1,0,0, 
						0,0,1,1, 0,0,1,1, 
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0, 
						0,0,1,0, 0,0,1,0, 
						0,0,0,0, 1,0,0,0, 
					].clump(8).choose}.dup(8).flat,2)
				}).loop,
			],inf).coin.not,
			\dur, 1/16,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\amp, 0.1/2,
		),
		
	])
).play;
);


(
	// trio
Pdef(\pia, 
	Ppar([
		Pbind( // root
			\instrument, \simplebass,
			\degree, Pstep(Pseq([
				5
			],inf),1),
			\isRest, Pseq([
				Plazy({ arg ev;
					Pseq({[
						0,0,0, 0,0,0,
						1,0,0, 0,0,0,
						1,0,0, 1,0,0,
						1,0,1, 1,0,1,
						1,0,1, 1,0,0,
						1,0,0, 1,0,1,
						0,0,0, 1,0,1,
						1,0,1, 0,0,0,
						1,1,1, 1,0,1,
						1,0,1, 1,1,1,
					].clump(8).choose}.dup(4).flat,1)
				}),
			],inf).coin.not,
			\lpf, 1000,
			\dur, 1/12,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\amp, 0.1,
		),
		Pbind( // root
			\instrument, \simplebass,
			\degree, Pstep(Pseq([
				3
			],inf),1),
			\isRest, Pseq([
				Plazy({ arg ev;
					Pseq({[
						0,0,0, 0,0,0,
						1,0,0, 0,0,0,
						1,0,0, 1,0,0,
						1,0,1, 1,0,1,
						1,0,1, 1,0,0,
						1,0,0, 1,0,1,
						0,0,0, 1,0,1,
						1,0,1, 0,0,0,
						1,1,1, 1,0,1,
						1,0,1, 1,1,1,
					].clump(8).choose}.dup(4).flat,1)
				}),
			],inf).coin.not,
			\lpf, 2000,
			\dur, 1/12,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\amp, 0.1,
		),
		Pbind( // root
			\instrument, \simplebass,
			\degree, Pstep(Pseq([
				0,1
			],inf),1),
			\isRest, Pseq([
				Plazy({ arg ev;
					Pseq({[
						0,0,0, 0,0,0,
						1,0,0, 0,0,0,
						1,0,0, 1,0,0,
						1,0,1, 1,0,1,
						1,0,1, 1,0,0,
						1,0,0, 1,0,1,
						0,0,0, 1,0,1,
						1,0,1, 0,0,0,
						1,1,1, 1,0,1,
						1,0,1, 1,1,1,
					].clump(8).choose}.dup(4).flat,1)
				}),
			],inf).coin.not,
			\lpf, 4000,
			\dur, 1/12,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.7) ],
			],inf),
			\amp, 0.1,
		),

		Pbind( // root
			\instrument, \simplebass,
			\degree, Pstep(Pseq([
				0,1
			],inf),1),
			\isRest, Pseq([
				Plazy({ arg ev;
					Pseq({[
						0,0,0, 0,0,0,
						1,0,0, 0,0,0,
						1,0,0, 1,0,0,
						1,0,1, 1,0,1,
						1,0,1, 1,0,0,
						1,0,0, 1,0,1,
						0,0,0, 1,0,1,
						1,0,1, 0,0,0,
						1,1,1, 1,0,1,
						1,0,1, 1,1,1,
					].clump(8).choose}.dup(4).flat,1)
				}),
			],inf).coin.not,
			\lpf, 4000,
			\dur, 1/12,
			\lpf, ~pmodenv.(Prand([5000,200,14001,2004],inf), 4),
			\rq, ~pmodenv.(Pseq([1,0.2,0.514001,0.082004],inf), 9),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.7) ],
			],inf),
			\amp, 0.1,
		),
		Pbind( // treb
			\instrument, \simplebass,
			\degree, Prand([
				3,4
			],inf),
			\lpf, 5000,
			\isRest, Pseq([
				Plazy({ arg ev;
					Pseq({[
						0,0,0, 0,0,0,
						1,0,0, 0,0,0,
						1,0,0, 1,0,0,
						1,0,1, 1,0,1,
						1,0,1, 1,0,0,
						1,0,0, 1,0,1,
						0,0,0, 1,0,1,
						1,0,1, 0,0,0,
						1,1,1, 1,0,1,
						1,0,1, 1,1,1,
					].clump(8).choose}.dup(8).flat,2)
				}).loop,
			],inf).coin.not,
			\dur, 1/12,
			\lpf, ~pmodenv.(Pseq([5000,200,14001,2004],inf), 8),
			\rq, ~pmodenv.(Pseq([1,0.2,0.514001,0.082004],inf), 7),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\amp, 0.1,
		),
		
	])
).play;
);




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
)
(
	Pdef(\part_melo, 
		Pbind(\degree, Pstep(Pseq([
					1,7,
		],inf),1),
	)<>
		Ppar([
			Pbind(
				\instrument, \perctone,
				\degree, Pseq([
					1,0,-2,2,
					1,0,3,2,
					1,0,1,2,
				],inf),
				\sustain, 0.1,
				\isRest, Pseq([
					Pseq({[
						1,1,0,0, 1,1,0,0, 
						1,1,0,1, 0,1,0,1, 
						1,0,0,1, 0,0,1,0, 
						0,0,1,1, 0,0,1,1, 
						1,0,1,1, 0,0,1,1, 
						1,0,1,0, 1,0,1,0, 
						1,1,1,0, 1,0,1,0, 
						1,0,1,0, 1,0,1,1, 
					].clump(8).choose}.dup(8).flat,inf)
				],inf).coin.not,
				\dur, 1/8,
				\octave, 3,
				\amp, 0.1,
			),

			Pbind(
				\instrument, \perctone,
				\degree, Pseq([
					1,0,-2,2,
					1,0,3,2,
					1,0,1,2,
				],inf),
				\octave, 4,
				\sustain, 0.1,
				\isRest, Pseq([
					Pseq({[
						1,1,0,0, 1,1,0,0, 
						1,1,0,1, 0,1,0,1, 
						1,0,0,1, 0,0,1,0, 
						0,0,1,1, 0,0,1,1, 
						1,0,1,1, 0,0,1,1, 
						1,0,1,0, 1,0,1,0, 
						1,1,1,0, 1,0,1,0, 
						1,0,1,0, 1,0,1,1, 
					].clump(8).choose}.dup(8).flat,inf)
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \perctone,
				\degree, Pseq([
					1,0,-2,2,
					1,0,3,2,
					1,0,1,2,
				],inf).stutter(2),
				\octave, Prand([5,6],inf),
				\sustain, 0.1,
				\isRest, Pseq([
					Pseq({[
						1,1,0,0, 1,1,0,0, 
						1,1,0,1, 0,1,0,1, 
						1,0,0,1, 0,0,1,0, 
						0,0,1,1, 0,0,1,1, 
						1,0,1,1, 0,0,1,1, 
						1,0,1,0, 1,0,1,0, 
						1,1,1,0, 1,0,1,0, 
						1,0,1,0, 1,0,1,1, 
					].clump(8).choose}.dup(8).flat,inf)
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\lpfr, Pseq([2,2.4,1.1],inf),
				\dur, 1/16,
				\amp, 0.051,
			)
		])
	).play;
);

(
	Pdefn(\melo1,
		Pstep(Pseq([
			\r,\r, \r,\r, \r,\r, \r,\r,
			1,1,1,1, 1,1,1,1,
			\r,\r, \r,\r, \r,\r, \r,\r,
			1,1,1,1, 1,1,1,1,
			\r,\r, \r,\r, \r,\r, \r,\r,
			1,1,1,1, 1,1,1,1,
			\r,\r, \r,\r, \r,\r, \r,\r,
			Pseq([
				1,0,2,4, 3,2,4,1,
			],inf),
		],inf),1/8)
	);
	Pdef(\part_melo, 
		Pbind(
			\scale, Scale.choose,
		) <>
		Ppar([
			Pbind(
				\instrument, \perctone,
				\degree, Pdefn(\melo1),
				\sustain, 0.1,
				\isRest, Pseq([
					Pseq({[
						1,1,0,0, 1,1,0,0, 
						1,1,0,1, 0,1,0,1, 
						1,0,0,1, 0,0,1,0, 
						0,0,1,1, 0,0,1,1, 
						1,0,1,1, 0,0,1,1, 
						1,0,1,0, 1,0,1,0, 
						1,1,1,0, 1,0,1,0, 
						1,0,1,0, 1,0,1,1, 
					].clump(8).choose}.dup(8).flat,inf)
				],inf).coin.not,
				\dur, 1/8,
				\octave, 3,
				\amp, 0.1,
			),

			Pbind(
				\instrument, \perctone,
				\degree, Pseq([
					1,0,-2,2,
					1,0,3,2,
					1,0,1,2,
				],inf),
				\degree, Pdefn(\melo1),
				\octave, 4,
				\sustain, Pwhite(0.01,0.4).stutter(Prand([3,1,4,5,8],inf)),
				\isRest, Pseq([
					Pseq({[
						1,1,0,0, 1,1,0,0, 
						1,1,0,1, 0,1,0,1, 
						1,0,0,1, 0,0,1,0, 
						0,0,1,1, 0,0,1,1, 
						1,0,1,1, 0,0,1,1, 
						1,0,1,0, 1,0,1,0, 
						1,1,1,0, 1,0,1,0, 
						1,0,1,0, 1,0,1,1, 
					].clump(8).choose}.dup(8).flat,inf)
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \perctone,
				\degree, Pseq([
					1,0,-2,2,
					1,0,3,2,
					1,0,1,2,
				],inf).stutter(2),
				\degree, Pdefn(\melo1),
				\octave, Prand([5,6],inf),
				\sustain, 0.1,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],8),
					Pseq({[
						1,1,0,0, 1,1,0,0, 
						1,1,0,1, 0,1,0,1, 
						1,0,0,1, 0,0,1,0, 
						0,0,1,1, 0,0,1,1, 
						1,0,1,1, 0,0,1,1, 
						1,0,1,0, 1,0,1,0, 
						1,1,1,0, 1,0,1,0, 
						1,0,1,0, 1,0,1,1, 
					].clump(8).choose}.dup(8).flat,1)
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\lpfr, Pseq([2,2.4,1.1],inf),
				\dur, 1/16,
				\amp, 0.051,
			)
		])
	).play;
);



(
Pdef(\part_melo, 
	Ppar([
		Pbind(
			\instrument, \perctone,
			\note, Pseq([
				1,
			],inf),
			\isRest, Pseq([
				1,0,0, 0,0,0, 
			],inf).coin.not,
			\legato, Pseq([
				1,1,1, 1,1,1,  0,0,0, 0,0,0,
				0,0,0, 1,1,1,  0,0,1, 1,0,1,
				1,1,1, 1,0,1,  1,1,1, 0,0,1,
				1,0,0, 1,1,1,  0,0,0, 1,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/12,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \perctone,
			\out, BusDef(\mixer5, \audio),
			\note, Pseq([
				Pseq([
					4,7,1,
				],12*4),
				Pseq([
					3,5,1,-3,12
				],12*4),
			],inf),
			\isRest, Pseq([
				1,0,0, 0,0,0, 
			],inf).coin.not,
			\legato, Pseq([
					0,0,5, 0,0,0,
					1,0,5, 1,0,0,
					0,0,5, 0,0,0,
					0,0,0, 0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		);
		
	])
).play;
);

(
Pdef(\part_melo, 
	Ppar([
		Pbind(
			\instrument, \perctone,
			\note, Pseq([
				1,
			],inf),
			\isRest, Pseq([
				1,0,0, 0,0,0, 
			],inf).coin.not,
			\legato, Pseq([
				1,1,1, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpfr, ~pmodenv.(Pseq([4,2,1,1/4],inf), 2),
			\rel, Pseg(Pseq([0,1],inf),8),
			\at, Pseg(Pseq([0.01,0.001,0,1],inf),7),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(ev[\at],0.1,0.8,ev[\rel]) ];
				}).loop,
			],inf),
			\octave, 6,
			\dur, 1/12,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \perctone,
			\out, BusDef(\mixer5, \audio),
			\note, Pseq([
				Pseq([
					4,7,1,
				],12*4),
				Pseq([
					3,5,1,-3,12
				],12*4),
			],inf),
			\isRest, Pseq([
				1,0,0, 0,0,0, 
			],inf).coin.not,
			\legato, Pseq([
					0,0,1, 1,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		);
		
	])
).play;
);

Main.version

(
	Tdef(\cputest, {

		116.do { arg idx;
			{ SinOsc.ar(200) ! 40 * 0.001}.play;
			if(idx%5==0) { 
				"%: %u, %s".format(idx, s.numUGens, s.numSynths).postln; 
			};
			0.05.wait;

		}
	}).play;
)


s.ugenCount
