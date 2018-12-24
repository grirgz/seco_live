
~t = 135/4/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\ze_snapkickx,
	Pbind(
		\instrument, \snapkickx,
		\dur, 1/8,
		\isRest, Pseq([
			1,0,0,0, 0,0,0,0,
			1,0,1,0, 0,0,0,0,
		],inf).coin.not,
		\amp, 0.1,
	),
)).play;
);
(
Pdef(\part, Pdef(\ze_snare_ksh2b, 
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
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_phyhat3, 
	Ppar([
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
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_fmbell, 
	Ppar([
		Pbind(
			\instrument, \fmbell,
			// []
			\note, Pseq([
				4,3,
			],inf),
			\octave, 4,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.4) ],
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_fmbass, 
	Ppar([
		Pbind(
			\instrument, \fmbass,
			\note, Pseq([
				-3,2, -3,2,
				-3,4, -3,4,
			],inf).stutter(2),
			\legato, Pseq([
				1,0,
				1,0,
				1,1,
				1,0,
				1,0,
				1,1, 0,1,
				1,0,
				1,0,
				1,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_chordar, 
	Ppar([
		Pbind(
			// chords
			\instrument, \chordar,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.9) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				[2,5,9],
				[1,4,9],
			],inf).stutter(8),
			\isRest, Pseq([
				0,1,0,0,
				0,0,1,0,
				1,0,1,0,
				0,0,1,1,
			],inf).coin.not,
			\legato, Pseq([0.9,0.9,0.9,0.4],inf).stutter(2),
			\legato, 1.7,
			\legato, Pseq([
		
		
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
		
				0,0,0,0, 1,0,0.5,0,
				0,0,0,0, 0.5,0,0,0.5,
				0,0,0.5,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
		
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\mixhpf, 0,
			\mixlpf, 1,
			\amp, 0.1/8,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_pluck, 
	Ppar([
		Pbind(
			\instrument, \pluck,
			\note, Pseq([
				[2,5,9],
				[1,4,8],
			],inf).stutter(8),
			\dstrum, Pseg(Pseq([0,0.0010],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0,
				0,1,1,1,
				1,0,1,0,
				0,1,1,0,
				0,0,1,0,
				1,0,1,1,
			],inf).coin.not,
			\decay, 0.04,
			\coef, Pseg(Pseq((1..10)/10,inf),1),
			\coef, 0.405,
			\coef, Pseq([
				0.7,0.7,0.4,0.7,
			],inf),
			\dur, 1/8,
			\amp, 0.1/2,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_brownbass, 
	Ppar([
		Pbind(
			\instrument, \brownbass,
			\note, Pseq([
				-3,2, -3,2,
				-3,4, -3,4,
			],inf).stutter(2),
			\octave, 3,
			\legato, Pseq([
					2,0, 0,0, 0,0, 2,0,
					2,0, 0,0, 0,0, 2,0,
					2,0, 0,0, 1,0, 2,0,
					0,0, 2,0, 0,0, 2,0,
					2,0, 0,0, 0,0, 2,0,
					2,0, 0,0, 1,0, 0,0,
					2,0, 0,0, 0,0, 2,0,
					2,0, 0,0, 1,0, 0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_vlip, 
	Ppar([
		Pbind(
			\instrument, \vlip,
			\note, Pseq([
				2,5,9,
				1,4,9,
				2,5,2,
				1,4,1,
				2,5,5,
				1,4,4,
			],inf),
			\fmamp, 0.4,
			\legato, Pseq([
				0,0,0, 3,0,0,
				0,0,1/4, 3,0,0,
				0,0,0, 3,0,0,
				0,0,1/4, 1/4,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/6,
			\amp, 0.1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_kalimba, 
	Ppar([
		Pbind(
			\instrument, \kalimba,
			\note, Pseq([
				0,-1
			],inf),
			\isRest, Pseq([
				1,0,0,1, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.2,
			//\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_fmsaw_scratch, 
	Ppar([
		Pbind(
			// scratching!
			\instrument, \fmsaw,
			\note, Pseq([
				[1,5,8],
				[1,6,10],
				[3,8,12, 0],
				[1,6,10, -2],
			],inf).stutter(8).collect({ arg x; x.choose }) + Pseq([0,1],inf),
			\isRest, Pseq([
				1,1,0.9,1,
				1,1,1,0.9,
				0,0.5,1,0,
				0.5,1,0.5,1,
			],inf).coin.not,
			\octave, Pseq([4,4,4,Prand([5,3],1)],inf).stutter(2) + Prand([0,1,0],inf).stutter(8),
			\legato, Pseq([0.9,0.9,0.9,0.4],inf).stutter(2) * 0.5,
			\dur, PdurStutter(Pseq([2,4,2,Prand([1,4],1)],inf),Pseq([1/4],inf)),
			\amp, 0.1/3,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_rise, 
	Ppar([
		Pbind(
			\instrument, \rise,
			\degree, Pseq([0],inf),
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 2,
			\amp, 0.1
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_amenbreak, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 4*~t/(137/60),
			\pos, Pseq((0..3)/4*2,inf)/(137/60),
			\legato, 1,
			\gain, 1/10,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_stringsx, 
	Ppar([
		Pbind(
			\instrument, Pseq([
				Pseq([
					\stringsx,
				],6),
				Pseq([
					\stringsx2,
				],2),
			],inf),
			\note, Pseq([
				[0,3,7]+2,
				[0,3,7]+1,
			],inf),
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.1,0.1,0.8,3.1) ],
				],6),
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
					[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\legato, Pseq([
				Pseq([
					0.8,
				],6),
				0.1,0.8,
			],inf),
			\lag, Pseq([
				Pseq([
					0
				],6),
				5/12,
				0,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_sibass, 
	Ppar([
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				2,1,2,1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_basicbass, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				2,1,2,1
			],inf).stutter(6*2),
			\octave, 3,
			\legato, Pseq([
				4,0,0, 0,0,0,  2,0,0, 0,0,0,
				4,0,0, 0,0,0,  0,0,1/2, 1,0,0,
				4,0,0, 0,0,1/2,  1,0,0, 0,0,0,
				4,0,0, 0,0,0,  0,0,0, 1/2,0,1/2,
				4,0,0, 0,0,0,  2,0,0, 0,0,0,
				4,0,0, 0,0,0,  0,0,1/2, 1,0,0,
				0,0,0, 0,0,1/2,  6,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, Pseq([
				200,200,133,
				200,200,243,
			],inf),
			\dur, 1/12,
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\ze_snare_electro, 
	Ppar([
		Pbind(
			\instrument, \snare_electro,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_hihat_electro, 
	Ppar([
		Pbind(
			\instrument, \hihat_electro,
			\freq, 200,
			\isRest, Pseq([
				1,0,0, 1,0,1, 1,0,1, 1,0,1,
				1,1,0, 1,0,0, 1,0,0, 1,0,0,
				1,0,1, 1,0,0, 1,1,0, 1,0,1,
				1,1,0, 1,0,0, 1,0,0, 1,0,1,
		
				1,0,0, 1,0,1, 1,0,1, 1,0,1,
				1,1,0, 1,0,0, 1,0,0, 1,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				1,1,0, 1,0,0, 0,0,1, 1,1,1,
			],inf).coin.not,
			\dur, 1/12,
			\amp, 0.1 * Pseq([
				1,0.6,0.7,
			],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_snaretuned2, 
	Ppar([
		Pbind(
			\instrument, "snaretuned2",
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/12,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_organ_tonewheel1, 
	Ppar([
		Pbind(
			\instrument, Pseq([
				Pseq([
					\organ_tonewheel1,
				],6),
				Pseq([
					\organ_tonewheel0,
				],2),
			],inf),
			\note, Pseq([
				[0,3,7]+2,
				[0,3,7]+1,
			],inf),
			\sus, 1,
			\rel, 0.71,
			\strum, Pseg(Pseq([0,0.4],inf),8),
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.1,0.1,0.8,3.1) ],
				],6),
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
					[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\legato, Pseq([
				Pseq([
					0.8,
				],6),
				0.1,0.8,
			],inf),
			\lag, Pseq([
				Pseq([
					0
				],6),
				5/12,
				0,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_hech, 
	Ppar([
		Pbind(
			\instrument, \hech,
			\legato, 1/4,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_fzion3, 
	Ppar([
		Pbind(
			\instrument, \fzion3,
			\freq, 1210,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_fzion4, 
	Ppar([
		Pbind(
			\instrument, \fzion4,
			\note, Pseq([
				7,
			],inf).stutter(1)+[0,2],
			\freq, 1210,
			\octave, 7,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 1,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.45) ],
			],inf),
			\dur, 1/12,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_fzion, 
	Ppar([
		Pbind(
			\instrument, \fzion,
			\note, Pseq([
				2,1
			],inf).stutter(12),
			\legato, Pseq([
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
		
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_fzion2, 
	Ppar([
		Pbind(
			\instrument, \fzion2,
			\note, Pseq([
				2,1,
			],inf).stutter(12),
			\octave, 4,
			\legato, Pseq([
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
		
				15,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 9,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_hat_bat_pre, 
	Ppar([
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				0,0,0, 0,0,1, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\dur, 1/12,
		)),
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_clap_bat, 
	Ppar([
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
		
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/12,
		)),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_clave_bat, 
	Ppar([
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 20,
			\speed, Pseq([
				Pseg( Pseq([ 1,1.02 ],1), 1/2),
				Pseg( Pseq([ 2,1 ],1), 1),
				Pseg( Pseq([ 1/2,2 ],1), 1/2),

				Pseg( Pseq([ 0.71,0.71 ]*2,1), 1),
				Pseg( Pseq([ 1/2,1.2 ]*2,1), 1/2),
				Pseg( Pseq([ 1.11,1.21 ],1), 1/2),
			],inf),
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 1,0,1,
				0,1,0, 1,0,1,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 1,0,0,
				1,1,0, 1,0,1,  1,0,0, 1,0,1,
				0,0,0, 0,0,0,  1,0,0, 1,0,1,
				0,1,0, 1,0,1,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  1,0,1, 1,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
			],inf).coin.not,
			\velamp, 0.7,
			\sustain, 0.2,
			\dur, 1/12 * (1 + (0.16 * Pseq([-1,0,1],inf))),
		)),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_feynman_scratch, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/loop2_185bpm.flac'),
			\bufnum, BufDef(\ukraine, "bruit1/07_ukraine.flac"),
			\bufnum, BufDef('fix4/snare1.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\speed, 1.031 * Pseq([
				1,0.9,1.12
			],inf),
			\speed, ~pmodenv.(Pseq([
				1,1,1, 1,1,1,  1,1,1, 1,1,1,
				1,1,1, 1,1,1,  1,1,1, 1,1,1,
				1,2,1,1/2,1,1.2, 1,2,1,1/2,1,1.2,
				1,2,1,1/2,1,1.2, 1,2,1,1/2,1,1.2,
			],inf), 1/12),
			\pos, Pseq([
				4,2,5
			],inf),
			\dur, Pn(1/12,inf),
			\legato, Pseq([
				 2,0,0, 4,0,0,  0,0,1, 1,0,0,
				1,0,1/2, 0,0,1,  0,0,1, 1,0,0,
				0,0,0, 0,0,0,  0,0,1/2, 1,0,1,
				0,0,1/2, 0,0,1,  0,0,1, 1,0,0,
				//1,0,1, 3,0,0,  0,0,1, 2,0,0,
				//1,0,0, 0,0,0,  0,0,1, 0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1/4 * Pseq([
				1,2
			],inf).stutter(12*2),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_dronebleu, 
	Ppar([
		Pbind(
			\instrument, \dronebleu,
			\note, Pseq([
				2,1
			],inf).stutter(2),
			\octave, 3,
			\seqdur, 1/12/~t,
			\legato, Pseq([
				14,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 9,0,0,  0,0,0, 0,0,0,
				14,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 9,0,0,  0,0,0, 0,0,0,
				14,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 9,0,0,  0,0,0, 0,0,0,
		
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.2,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_dronebleuhi, 
	Ppar([
		Pbind(
			\instrument, \dronebleuhi,
			\note, Pseq([
				0,0,0, 0,0,0, 0,0,0,  0,0,0, 
			],inf)+Pseq([2,1],inf).stutter(12),
			\seqdur, 1/12/~t,
			\detune, Pseq([
				0,0,0, 0,0,0, 0,0,0,  0,0,0, 
				0,0,0, 0,0,0, 0,0,0,  -100,0,0, 
		
			],inf),
			\detune, Pseq([
				Pseg(Pseq([0,00],1),3),
				Pseg(Pseq([0,-100],1),2),
				Pseg(Pseq([0,100],1),1),
			],inf),
			\octave, 7,
			\legato, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,2, 0,0,1,  0,0,1, 1/2,0,0,  
				0,0,1, 1,0,0,  1,0,0, 1,0,0,
				0,0,0, 2,0,1/2,  0,0,1, 0,0,0,  
				0,0,0, 0,0,1,  0,0,0, 1,0,0,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],12*3),
				Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.0) ],
				],12*1),
			],inf),
			\dur, 1/12,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_iron, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				2,1,
			],inf),1),
			\hpfmix, 1,
			\hpf, 500,
			\lpfr, 2.3,
			\octave, 5,
			\dur, 1/1 * Pseq([4,1,3,4, 4,1,5,2].normalizeSum*4,inf),
			\amp, 0.1/5,
			\lag, 0.04,
		),
	])
)).play;
);

(
	// ramp
Pdef(\part, Pdef(\ze_nidi, 
	Ppar([
		Pbind(
			\instrument, \nidi,
			\note, Pseq([
				0,2,7,9,
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 16,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\distamp, 20,
			\mix, 0.5,
			\amp, 0.1/4,
		),
	])
)).play;
);


(
	// trumpet, add reverb for nicer
Pdef(\part, Pdef(\ze_cracklemono, 
	Ppar([
		Pmono(\cracklemono,
			\chaos, 0.93500,
			\note, Pseq([
				5,4,
				9,1,
			],inf).stutter(1),
			\octave, 5,
			\format, Pseq([
				1,2,3,4,5
			],inf)/4,
			\formdec, 0.03,
			\xtrig, 1,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);
(
	// trumpet, add reverb for nicer
Pdef(\part, Pdef(\ze_crackledec, 
	Ppar([
		Pmono(\crackledec,
			\chaos, 0.93500,
			\note, Pseq([
				5,4,
				9,1,
			],inf).stutter(1),
			\octave, 5,
			\format, Pseq([
				1,2,3,4,5
			],inf)/4,
			\formdec, 0.03,
			\xtrig, 1,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


(
	// a la base avec un rdn qui a beaucoup de fb
Pdef(\part, Pdef(\ze_bassgrise, 
	Ppar([
		Pbind(
			\instrument, \bassgrise,
			\note, Pseq([
				Pser([
					5,0,0, 
					0,0,0, 
					0,0,0, 
					0,0,0, 
				],12*2),
			],inf),
			\lpf, 802,
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
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_dubdrone4x, 
	Ppar([
		Pbind(
			\instrument, \dubdrone4x,
			\note, Pseq([
				4,
			],inf),
			\pitch_stretch, 4,
			\time_stretch, Pseg(Pseq([0,2],inf),8),
			\pos, 0.3,
			\trate, 100,
			\octave, 7,
			\legato, Pseq([
				0,0,0, 0,0,0,
			  	0,0,0, 6,0,0,
				0,0,0, 0,0,0,
				0,0,0, 0,0,0,
		
				0,0,0, 0,0,1,
			  	2,0,0, 2,0,0,
				0,0,0, 0,0,0,
				0,0,0, 0,0,0,
		
				0,0,0, 0,0,0,
				Prand([
					Pseq([
						1,0,1, 2,0,0,
					],1),
					Pseq([
						0,0,1, 1,1,0,
					],1),
				],1),
				0,0,0, 0,0,0,
				0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lag, 0.04,
			\dur, 1/12,
			\amp, 0.2,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_dubdrone4, 
	Ppar([
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
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_rim5, 
	Ppar([
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0,0,0, 1,0,0,0,0,0,
				0,0,0,0,0,0, 1,0,0,0,0,0,
				0,0,0,0,0,0, 1,0,0,0,0,1,
				0,0,1,0,0,0, 1,0,0,1,0,1,
				0,0,0,0,0,0, 1,0,0,0,0,0,
				0,0,0,0,0,0, 1,0,0,0,0,0,
				0,0,0,0,0,0, 1,0,0,0,0,1,
				0,0,1,0,0,1, 1,0,0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/12,
		)),
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_rim1, 
	Ppar([
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\instrument, \playersec_hlpf,
			\hpfmix, 1,
			\hpf, Pseq([
				1000,
				1000,
				100,
			],inf),
			\isRest, Pseq([
				0,0,0,1,0,0, 0,0,1,0,0,0,
				0,0,1,1,0,0, 1,0,0,1,0,1,
				0,0,0,1,0,0, 0,0,1,0,0,0,
				0,0,1,0,0,1, 0,0,1,1,0,1,
				0,0,0,1,0,0, 0,0,1,0,0,0,
				0,0,1,1,0,0, 1,0,0,1,0,1,
				0,0,0,1,0,0, 0,0,1,0,0,0,
				0,0,0,0,0,0, 0,0,0,1,0,1,
			],inf).coin.not,
			\sustain, 0.07,
			\speed, Pseq([
				1,0.99,
			],inf),
			\gain, 0.1 * Pseq([
				1,1,2, 1,1,2,  1,1,1, 2,1,2,
		
			],inf)/2,
			\dur, 1/12,
		)),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_rim6, 
	Ppar([
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 6,
			\isRest, Pseq([
				0,0,1, 1,0,1,  0,0,0, 0,0,0,
				0,0,0, 1,0,0,  0,0,1, 1,0,1,
				0,0,1, 1,0,0,  0,0,1, 0,0,0,
				0,0,1, 0,0,1,  0,0,1, 0,0,1,
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
		)),
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_hat_ksh2b, 
	Ppar([
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\lag, 0.04,
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 0.2 * Pseq([
				1,0.7,
			],inf) * Pseq([
				1,Pwhite(0.01,0.5,1),
			],inf),
			\amp, 0.1,
			//\out, BusDef(\fx1, \audio),
		)),
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_rim8, 
	Ppar([
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\lag, 0.08,
			\gain, 0.2,
			\dur, 1/8,
		)),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_chovar, 
	Ppar([
		Pbind(
			\instrument, \chovar,
			//\det, Ptuple (
				//Pwhite(0.01,0.00001,inf)!3
			//),
			\adsr, Pseq([
				Pfuncn({ arg ev;
					[ Env.adsr(0.1,0.1,0.8,rrand(0.1,1.2)) ]
				}),
				//Pfuncn({ arg ev;
					//[ Env.adsr(0.4,0.1,0.8,rrand(0.01,0.2)) ]
				//}),
			],inf),
			//\lpfr, Ptuple (
				//Pwhite(0.41,2.50001,inf)!3
			//),
			\note, Pseq([
				Pseq([
					Prand([
						[2,5,9],
						[5,5+12,5-12],
						[2,5-12,9-12],
						[2+12,5,9-12],
					],inf) + Pseq([0,-1],3).stutter(8),
					Prand([
						[2,5,9],
						[2,5,9],
						[2,5,9],
						[2+12,5,9],
						[2,8,9],
					],inf) + Pseq([0,-1],1).stutter(8),
				],inf),
			],inf),
			\dur, 1/8,
			\amp, 0.1/3 * Ptuple(
				Pwhite(0.1,1,inf)!3,
			),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_ridecast_speed, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\lpf, 2000 * Pseq([1,2,4],inf),
			\lpfmix, 0.1,
			\bufnum, BufDef('vipere/ridecast.flac'),
			\dur, 1/8,
			\sustain, 1/8,
			\speed, Pseq([
				1,1,1,1, 9/6,1,1,1,
			],inf),
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,1,1,
				1,1,1,0, 1,1,1,1,
				0,1,0,0, 1,0,1,1,
				1,1,1,1, 0,1,1,1,
				1,1,0,0, 1,1,1,1,
				0,1,0,1, 1,1,0,0,
				1,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\pos, 0.03,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 1,
			//\out, BusDef(\sendbus3, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_phyhat4, 
	Ppar([
		Pbind(
			\instrument, \phyhat4,
			\isRest, Pseq([
				Pseq([
					1,0,0,
				],4*7),
				Pseq([
					0,0,0,
				],4*1),
			],inf).coin.not,
			\sustain, 0.1,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.02 * Pseq([1,0.7],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_organ, 
	Ppar([
		Pbind(
			\instrument, \organ,
			//\out, BusDef(\fx1, \audio),
			\note, Pseq([
				Pser([
					[0,0,0],
					[0,0,-12],
					[0,0,-12],
					[12,12,0],
					[0,0,-12],
					[0,0,0],
				],12*2)+
				Pseq([
					[2,5,9]+0,
					[2,5,9]+0,
					[2,5,9]-1,
					[2,5,9]-1,
					[2,5,9]+0,
					[2,5,9]+0,
					[2,5,9]-1,
					[2,5,9]-1,
				],inf).stutter(6*1),
			],inf),
			\sustain, Pseq([
				0.01,0.01,0.001, 0.04,0.01,0.001,
				0.01,0.01,0.021, 0.01,0.01,0.001,
				0.01,0.01,0.001, 0.04,0.01,0.01,
			],inf),
			\isRest, Pseq([
				0,0,0, 1,0,0, 0,0,1, 1,0,0,
				0,0,0, 1,0,1, 0,0,0, 1,0,0,
				1,0,0, 1,0,1, 0,0,1, 1,0,1,
				0,0,1, 1,0,0, 0,0,0, 1,0,1,
				0,0,0, 1,0,0, 0,0,1, 1,0,0,
				0,0,0, 1,0,1, 0,0,0, 1,0,0,
				1,0,0, 1,0,1, 0,0,1, 1,0,1,
				0,0,1, 1,0,0, 0,0,1, 0,0,1,
			],inf).coin.not,
			\dur, 1/12,
			\amp, 0.1 * Pseq([
				1
			],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_wavechord, 
	Ppar([
		Pbind(
			\instrument, \wavechord,
			\note, Pseq([
				Prand([
					2,5,9,
				],inf).stutter(Prand([1,1,3,5],inf))+Pseq([0,-1],inf).stutter(12),
			],inf),
			\legato, 0.4,
			\legato, Pseq([
				1,0,1, 1,0,0,
				1,0,0, 1,0,0,
				4,0,0, 1,0,1,
			],inf)/2,
			\lpfr, Pseg(Pseq([
				1.2,2,0.8,3.5,
			],inf)+0.01,3),
			\rq, 0.5,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.01,0.1,0.8,0.21) ],
			],inf),
			\octave, Prand([5,6],inf),
			\dur, 1/12,
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\ze_rim1_speed, 
	Ppar([
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\instrument, \playersec_hlpf,
			\hpfmix, 1,
			\hpf, Pseq([
				100,
				1000,
				1000,
			],inf),
			\isRest, Pseq([
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				1,1,0, 0,0,1,  1,0,0, 1,0,1,
				1,0,0, 0,0,0,  1,0,0, 1,0,1,
			],inf).coin.not,
			\sustain, 0.07,
			\speed, Pseq([
				1,
			],inf),
			\gain, 0.1 * Pseq([
				1,1,2, 1,1,2,  1,1,1, 2,1,2,
		
			],inf)/2,
			\dur, 1/12,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\instrument, \playersec_hlpf,
			\hpfmix, 1,
			\hpf, Pseq([
				1000,
				100,
				1000,
			],inf),
			\isRest, Pseq([
				0,0,1, 0,0,0,  0,0,0, 0,0,1,
				0,0,0, 0,0,1,  0,0,1, 1,0,0,
			],inf).coin.not,
			\sustain, 0.07,
			\speed, Pseq([
				1.1,1,1.23151,
			],inf),
			\gain, 0.1 * Pseq([
				1,1,2, 1,1,2,  1,1,1, 2,1,2,
		
			],inf)/2,
			\dur, 1/12,
		)),
	])
)).play;
);

(
	// scary
Pdef(\part, Pdef(\ze_grancru, 
	Ppar([
		Pbind(
			\instrument, \grancru,
			\mbufnum, BufDef.mono('vipere/rocksteady.flac'),
			\pos, ~pmodenv.(Pseq([1,2,1,4]+3,inf), 8),
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,1.8,0.1,1,2) ],
			],inf),
			\legato, 1,
			\gfreq, 740,
			\gdur, 0.02,
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\dur, 2,
			\gain, 4,
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_smp_crush, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/crush.flac'),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\pos, 41.72,
			\dur, 1/8,
			\sustain,2/3,
			\gain, 1/12,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\ze_smp_crush2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/crush.flac'),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\pos, 49.72,
			\dur, 1/8,
			\sustain,1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\gain, 1/12,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_fater, 
	Ppar([
		Pmono(\fater,
			\inbus, BusDef(\sendbus1),
			\mix, 0.71,
			\pulse, Pseq([
				1,0,0,1,0,0,1,0,
				1,0,0,1,0,0,1,0,
				1,0,0,1,0,0,1,0,
				1,1,0,1,0,1,1,0,
				1,0,0,1,0,0,1,0,
				1,0,0,1,0,0,1,0,
				1,0,1,1,0,1,0,0,
				1,0,0,1,1,0,1,1,
			],inf),
			\pulselag, Pseg(Pseq([0,0,1],inf),4),
			\shiftfac, Pseg(Pseq([0,100],inf),8),
			\dur, 1/8,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\ze_simpleacid, 
	Ppar([
		Pbind(
			\instrument, \simpleacid,
			\note, Pseq([
				-3,1,2,4,
				9,1,5,4,
			],inf).stutter(8),
			\octave, 6,
			\isRest, Pseq([
				1,1,1,1, 1,0,1,1,
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,1,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,1,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\legato, Pseg(Pseq([1,0.1],inf),8),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4,1/2]/2,inf), Prand([1/7,1/9,1/3,1/4,1/8,1],inf)),
			\dur, 1/8,
			\amp, 0.1/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_stepchord1, 
	Ppar([
		Pbind(
			\instrument, \stepchord1,
			\legato, 0.91,
			\note, Pseq([
				[2,5,9,11],
				[2,5,9,11]-1,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_stepchord2, 
	Ppar([
		Pbind(
			\instrument, \stepchord2,
			\legato, 0.91,
			\note, Pseq([
				[2,5,9,11],
				[2,5,9,11]-1,
			],inf),
			\lfofreq1, Pseg(Pwhite(0.001,20),Pwhite(1.0,17)),
			\lfofreq2, Pseg(Pwhite(0.001,20),Pwhite(1.0,17)),
			//\lfofreq1, ~pmodenv.(Pseq([1/2,2,1/23,1,40],inf), 8),
			//\lfofreq2, ~pmodenv.(Pseq([1,1/100,20,1/4,4,1/122],inf), 5),
			\strum, Pwhite(0.001,0.1),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\ze_ridecast, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/ridecast.flac'),
			\dur, 1/8,
			\pos, 0.04,
			//\speed, ~pmodenv.(Pseq([1,1,1.1,2,1,4]/2,inf), 1/2),
			//\speed, Pseg(Pseq([0,1],inf),8),
			\speed, 1.2,
			\legato, 4.2,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],1),
				Pseq([
					1,0, 1,0, 1,0, 1,0,
					1,0, 0,0, 0,0, 0,0,
				],1),
			],inf).coin.not,
			\gain, 1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\ze_chordlock2, 
	Ppar([
		Pbind(
			\instrument, \chordlock2,
			\note, Pseq([
				[5,9,5+12],
				[5,9,5+12]-1,
			],inf),
			\legato, 1/2,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordlock2,
			\note, Pseq([
				9,
				11,
			],inf)+Pstep(Pseq([2,1],inf),1),
			\octave, Pseq([
				5,5,4,5,5,3,5,6,6,
			],inf),
			\legato, 1/2,
			\dur, Pseq([1,1/2],inf),
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_chordlock3, 
	Ppar([
		Pbind(
			\instrument, \chordlock3,
			\note, Pseq([
				[3,7,15]+2,
				[3,7-12,15]+1,
			],inf),
			\legato, 1/2,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordlock3,
			\note, Pseq([
				10, // 7th
				14, // 9th
				17, // 11th
			],inf)+Pstep(Pseq([2,1],inf),1),
			\octave, Pseq([
				5,5,4,5,5,3,5,6,6,
			],inf),
			\legato, 1/2,
			\dur, Pseq([1,1/2,1/4],inf),
			\amp, 0.1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_basslok, 
	Ppar([
		Pbind(
			\instrument, \basslok,
			\note, Pseq([
				9-12,9-12,
				2,9-12,
			],inf).stutter(1),
			\octave, 3,
			\lpfr, 4,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_tassbass, 
	Ppar([
			Pbind(
				\instrument, \tassbass,
				\octave, 3,
				\note, Pseq([
					2,1,
				],inf).stutter(6),
				\fmf, Pseq([
					Pser([3],7), 6,
					Pser([3],7), 12,
					Pser([3],7), 1/3,
					Pser([1],7), 12,
				],inf).stutter(12),
				\legato, Pseq([
					Pseq([
						6,0,0, 0,0,0,  0,0,0, 0,0,0,
					],1),
					6,0,0, 0,0,0,  0,0,0, 0,0,1,
					Pseq([
						6,0,0, 0,0,0,  0,0,0, 0,0,0,
					],1),
					6,0,0, 0,0,0,  1,0,1, 0,0,0,
					Pseq([
						6,0,0, 0,0,0,  0,0,0, 0,0,0,
					],1),
					6,0,0, 0,0,0,  0,0,0, 1,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/6,
				\amp, 0.2,
			),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_perctone, 
	Ppar([
					Pbind(
						\instrument, \perctone,
						\note, Pseq([
							Prand([3,3,3,0,0,0,0,3,3,7,7,0,3,7,[3,11],[3,14]],inf)+ Pseg(Pseq([2,1],inf),1),
						],inf),
						\legato, Pseq([

								0,0,1,0, 0,3,0,0,
								0,0,1,0, 0,3,0,0,
								0,0,1,0, 0,3,0,0,
								0,0,1,0, 0,3,0,0,

								0,0,1,0, 0,3,0,0,
								0,0,1,0, 0,3,0,0,
								4,0,0,0, 0,3,0,0,
								0,0,1,0, 0,3,0,0,

								0,0,2,0, 1,1,0,0,
								0,0,1,0, 0,3,0,0,
								2,0,1,0, 0,3,0,0,
								0,0,1,0, 4,0,0,0,

								0,0,1,0, 0,3,0,0,
								0,0,1,0, 0,3,0,0,
								0,0,1,0, 0,1,2,0,
								0,0,1,0, 0,3,0,0,

						],inf),
						\octave, 6,
						\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
						\dur, 1/8,
						\amp, 0.07,
					),
	])
)).play;
);


(
Pdef(\part, Pdef(\ze_chordo, 
	Ppar([
		Pbind(
			\instrument, \chordo,
			\note, Pseq([
				5,4,
			],inf),
			\sustain, 0.1,
			\dur, 1,
			\amp, 0.3,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\ze_aigu, 
	Ppar([
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
			\amp, 0.2 * Pwhite(0.05,0.1).stutter(13),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_conga, 
	Ppar([
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
					0,0,0, 0,0,0,  0,0,0, 0,0,0,  
					0,0,0, 0,0,0,  0,0,0, 0,0,0,  
					0,0,0, 0,0,0,  0,0,1, 0,0,1,  
					1,0,1, 0,0,1,  0,0,1, 1,0,1,  

					0,0,0, 0,0,0,  0,0,0, 0,0,0,  
					0,0,0, 0,0,0,  0,0,0, 0,0,0,  
					0,0,0, 0,0,0,  0,0,1, 1,0,0,  
					1,0,1, 0,1,0,  0,0,1, 1,0,1,  
				],inf),
			],inf).coin.not,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\ze_longf, 
	Ppar([
			Pbind(
				\instrument, \longf,
				\note, Pseq([
					5,1,2,1,
				],inf).stutter(6*2),
		\freqenv, Pseq([
			[ (Env([1,1,1/2,1,1/2],[1/8/~t,0.01,1.0/2/3 - ( 1/8 )/~t,0.01], [0,0,2,0,0])) ],
			[ (Env([1,1,1/2,1,1/2],[1/8/~t,0.01,2.0/3 - ( 1/8 )/~t,0.01], [0,0,2,0,0])) ],
			[ (Env([1,1,1/2,1,1/2],[1/2/~t,0.01,2.0/3 - ( 1/8 )/~t,0.01], [0,0,2,0,0])) ],
		],inf).stutter(6*4),
				\octave, 7,
				\legato, Pseq([
					0,0,0, 0,0,0,
				  	0,0,0, 0,0,0,
					0,0,0, 3*3,0,0,  
					0,0,0, 0,0,0,
					0,0,0, 0,0,0,
				  	4,0,0, 0,0,0,
					0,0,0, 3*3,0,0,  
					0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\lag, 0.04,
				\dur, 1/12,
				\amp, 0.1,
			),
	])
)).play;
);


(
Pdef(\part, Pdef(\ze_dubdrone, 
	Ppar([
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
	])
)).play;
);
(
Pdef(\part, Pdef(\ze_dubdrone3, 
	Ppar([
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
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_chordo2, 
	Ppar([
		Pbind(
			\instrument, \chordo2,
			\note, Pseq([
				//[0,3,5],
				[2,5,9],
				[2,5,9]-1,
			],inf).stutter(8),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\ze_hipass, 
	Ppar([
		Pbind(
			\instrument, \hipass,
			\note, Pseq([
				0,
			],inf),
			\octave, 4,
			\fmf1, Pexprand(1,333.0).stutter(inf),
			\fmf2, Pexprand(1,9.0).stutter(inf),
			\hpf, 7000,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\ze_plouc, 
	Ppar([
		Pbind(
			\instrument, \plouc,
			\note, Pseq([
				Pser([
					2,1,
				],6),
				Pser([
					Rest(2),1,
				],2),
			],inf).stutter(8),
			\delay, ~pmodenv.(Pseq([0.01,0.2,0.001,0.0004],inf), 8),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_hipasswide, 
	Ppar([
		Pbind(
			\instrument, \hipasswide,
			\note, Pseq([
				5,4,
				5,4,
				5,4,
				5,1,
			],inf),
			\octave, 6,
			\fmf1, 13,
			\fmf2, 4,
			\hpf, 14000,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\ze_chordodo, 
	Ppar([
		Pbind(
			\instrument, \chordodo,
			\hpf, 10,
			\octave, 5,
			\amp, 0.1,
			\dur, 1/12,
			\note, Pseq([
				//[0,3,5],
				Pseq([
					[2,5,9],
				],4),
				Pser([
					[2,5,9]-1,
					[2,5,8]-1,
				],4),
			],inf).stutter(3),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.8) ],
			],inf),
			\legato, Pseq([
				8,0,0, 0,0,0, 0,0,0, 0,0,0,
				3,0,0, 0,0,0, 1,0,0, 1,0,0,
				8,0,0, 0,0,0, 0,0,0, 0,0,0,
				3,0,0, 0,0,0, 1,0,0, 1,0,0,
				8,0,0, 0,0,0, 0,0,0, 0,0,0,
				3,0,0, 0,0,0, 1,0,0, 1,0,0,
				8,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,1, 1,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		)
	])
)).play;
);


(
Pdef(\part, Pdef(\ze_basicpadfm, 
	Ppar([
		Pbind(
			\instrument, \basicpadfm,
			\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\note, Pseq([
				[2,5,9],
				[2,5,9]-1,
			],inf),
			\oscmix, ~pmodenv.(Pseq([0,1,0.51,0.74],inf), 8),
			\lpf, 1000,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);



(
Pdef(\part, Pdef(\ze_cymbalsimple, 
	Ppar([
		Pbind(
			\instrument, \cymbalsimple,
			\freq, 200,
			\dur, 1,
			\isRest, Pseq([
				1,0,0,0,
				1,0,0,1,
			],inf).coin.not,
			\amp, 0.2,
		),
	])
)).play;
);



(
Pdef(\part, Pdef(\ze_oneone, 
	Ppar([
		Pbind(
			\instrument, \oneone,
			\note, Pseq([
				2,8-12,
				5,4-12,
				9,1-12,
				9,1-12,
			],inf),
			\octave, 6,
			\legato, Pseq([
				2,0,1,1,
				2,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1,
			\amp, 0.1,
			\timeScale, 1/~t/1.2,
			\lfo, 16*~t,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\ze_oneone2, 
	Ppar([
		Pbind(
			\instrument, \oneone2,
			\note, Pseq([
				2,8-12,
				5,4-12,
				9,1-12,
				9,1-12,
			],inf),
			\octave, 6,
			\legato, Pseq([
				1/2,0,2,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
			\timeScale, 1/~t/1.2,
		),
	])
)).play;
);
