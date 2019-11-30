// suft82

// use master for sendbus1-rdn kicksnare sendbus2-rdn2 perc
// rdn3 for voice

ProtoDef(\rdn).loadFromPresetLib("default");
ProtoDef(\rdn2).loadFromPresetLib("default");
ProtoDef(\rdn3).loadFromPresetLib("default");
ProtoDef(\rdn).inbus = BusDef(\sendbus1);
ProtoDef(\rdn2).inbus = BusDef(\sendbus2);
ProtoDef(\rdn3).inbus = BusDef(\sendbus3);

ProtoDef(\rdn).loadFromPresetLib("ile5_kick");
ProtoDef(\rdn).loadFromPresetLib("ile5_kickdist");
ProtoDef(\rdn2).loadFromPresetLib("ile5_snare");
ProtoDef(\rdn2).loadFromPresetLib("ile5_snaredist");


~t = 135/4/60; TempoClock.default.tempo = ~t;

(
Pdefn(\chords, Pstep(Pseq([
	0,-1,0,-1,
	0,-1,-2,-1,
],inf),4));
Pdef(\part2, Pdef(\evoltreb, 
	Ppar([
		Pbind(
			\instrument, Pseq([
				\evoltreb,
				\evoltreb2,
				\evoltreb3,
				\evoltreb3,
			],inf).stutter(8*4*4),
			\dur, 2,
			\amp, 0.1,
			\note, Pdefn(\chords),
			\vol, Pseg(Pseq([1/2,0,1],inf),16),
			\legato, Pseq([

				7,0,0,0, 0,0,0,0,
				7,0,0,0, 0,0,0,0,
				15,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,1, 0,2,0,0,
				7,0,0,0, 0,0,0,0,
				15,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				31,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				10,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1.8,0,1,
				7,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
		);
	])
)).play;
);

(
Pdef(\part, Pdef(\evolbass, 
	Ppar([
		Pbind(
			\instrument, \evol,
			\dur, 2,
			\amp, 0.1/2,
			\note, Pdefn(\chords),
			\vol, Pseg(Pseq([1/2,0,1],inf),16),
			\legato, Pseq([
				31,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
		);
	])
)).play;
);


(
Pdef(\part, Pdef(\devolbass, 
	Ppar([
		Pbind(
			\instrument, \devol,
			\dur, 2,
			\amp, 0.071,
			\note, Pdefn(\chords),
			\vol, Pseg(Pseq([1/2,0,1],inf),16),
			\legato, Pseq([
				31,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \devoltreb,
			\dur, 2,
			\amp, 0.1,
			\note, Pdefn(\chords)+7,
			\vol, Pseg(Pseq([1/2,0,1],inf),16),
			\legato, Pseq([
				31,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\env, \audio),
			\octave, 5,
			\dur, 1/8,
		),
		Pmono( \envshifter,
			\inbus, BusDef(\env, \audio),
			\isustain, 0.1 * Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				8,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf),
			\itrig, Pkey(\isustain),
			\iadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
				[ Env.adsr(0.1,0.1,0.8,0.04) ],
				[ Env.adsr(0.1,0.1,0.8,0.04) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/5,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/8,
			\dur, 1/16,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\speed, 0.9,
			\gain, 0.1,
			\dur, 1/8,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\speed, 0.9,
			\gain, 0.05,
			\dur, 1/8/2,
		)),

		[
			[0,3,14,11,0+24],
			[0,3,14,11,0+24]+4,
			[0,3,9,11,0+24],
			[0,3,9,11,0+24]+4,
			[0,3,9,11,0+24],
			[0,3,9,11,0+24]+4,
		].flop.collect({ arg no, idx;
			no.debug("nooo");

			Pseq([
				Pmono( \devol2,
					\lfo1, Pwhite(1.0,50),
					\lfo2, Pwhite(1.0,50),
					\bias1, Pwhite(0.0,0.50),
					\bias2, Pwhite(0.0,0.50),
					\note, Pseq([
						Pseq(no)
					],1),
					\dur, 1 + (idx *0.02),
					\amp, 0.1/7,
				),
				Pbind(\instrument, \devol2,
					\lfo1, Pwhite(1.0,50),
					\lfo2, Pwhite(1.0,50),
					\note, Pseq([
						Pseq(no)
					],1),
					\dur, 1 + (idx *0.02),
					\amp, 0.1/7,
				),
			],4);
		})
		
	].flat)
)).play;
)



(
Pdef(\part2, Pdef(\castle, 
	Ppar([
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pseq([
				Pexprand(100,8000,1),
				Pseries(1,10,100),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\oscmix, Pwhite(0,1.0),
			\fmr, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, Prand([1/4,1/8,1/2,1],1).keep(1).repeat(inf) * Pseg(Pseq([1,1/3],inf),8),
			\amp, 0.1/2,
		)}!3),
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pexprand(100,14000),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,10.1) ],
			],inf),
			\fmr, Pwhite(1/40,10),
			\fmamp, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\oscmix, Pwhite(0,1.0),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, Prand([1/4,2,1],1).keep(1).repeat * Pseg(Pseq([1,1/3],inf),8),
			\amp, 0.1/2,
		)}!3),
		Pbind(
			\instrument, \cymbalsimple2,
			\freq, 200,
			\dur, 1,
			\rel, 4.5,
			\att, 0.01,
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		),
		Pmono(\echoer,
			\inbus, BusDef(\echoer, \audio),
			\delay, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 8),
			\gain, 0.4,
			\itrig,1,
			\dur, 1,
		),
	])
)).play;
);


(
Pdef(\part2, Pdef(\castle_nude, 
	Ppar([
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pseq([
				Pexprand(100,8000,4).stutter(Pseq([4,3],inf)),
				Pseries(1,10,100).stutter(8),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\oscmix, Pwhite(0,1.0),
			\fmr, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, rrand(1/2,1/16),
			\lag, rrand(0,0.3),
			\amp, 0.1/3,
		)}!8),
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pexprand(100,14000),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,10.1) ],
			],inf),
			\fmr, Pwhite(1/40,10),
			\fmamp, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\oscmix, Pwhite(0,1.0),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, Prand([1/4,2,1],1).keep(1).repeat * Pseg(Pseq([1,1/3],inf),8),
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		)}!1),
		Pbind(
			\instrument, \cymbalsimple2,
			\freq, 200,
			\dur, 4,
			\rel, 4.5,
			\att, 0.01,
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		),
		Pmono(\echoer,
			\inbus, BusDef(\echoer, \audio),
			\delay, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 8),
			\itrig,1,
			\gain, 0.4,
			\dur, 1,
		),
	])
)).play;
);


Pdef(\part3).stop;
(
Pdef(\part, Pdef(\castle_perc, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,1,0,1,
				0,0,0,1, 1,0,0,1,

				1,0,0,0, 0,0,1,1,
				0,0,0,1, 1,0,1,0,
				1,0,0,1, 1,0,1,1,
				0,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/16,
			\gain, 0.7,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0.5, 0.5,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0.51,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,0,1,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\sustain, 0.1,
			\speed, Pseq([
				Pseq([
					1,1,
				],2),
				Pseq([
					Pseries(1,10,0.1),
				],1),
			],inf),
			\gain, 0.3,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/1,
			\dur, 1/16,
			\out, BusDef(\echoer2, \audio),
		)),
		Pmono(\echoer,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\echoer2, \audio),
			\delay, ~pmodenv.(Pseq([1,2,10,1/101,4]/11,inf), 8),
			\itrig,Pseq([0,1],inf),
			\gain, 0.4,
			\dur, 1/2,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
				],16),
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\velamp,2,
			\dur, 1/16,
		)),
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pseq([
				Pexprand(100,8000,4).stutter(Pseq([4,3],inf)),
				Pseries(1,10,100).stutter(8),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\oscmix, Pwhite(0,1.0),
			\fmr, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, rrand(1/2,1/16),
			\lag, rrand(0,0.3),
			\amp, 0.1 * 0.8,
		)}!8),
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pexprand(100,14000),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,10.1) ],
			],inf),
			\fmr, Pwhite(1/40,10),
			\fmamp, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\oscmix, Pwhite(0,1.0),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, Prand([1/4,2,1],1).keep(1).repeat * Pseg(Pseq([1,1/3],inf),8),
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		)}!1),
		Pbind(
			\instrument, \cymbalsimple2,
			\freq, 200,
			\dur, 4,
			\rel, 4.5,
			\att, 0.01,
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		),
		Pmono(\echoer,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\echoer, \audio),
			\delay, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 8),
			\itrig,1,
			\gain, 0.4,
			\dur, 1,
			\isRest, true,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\castle_dist, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.18], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 1,0,0,0,
				1,0,1,0, 0,1,0,0,
				0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.2,
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0.5, 0.5,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0.51,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,0,1,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\sustain, 0.1,
			\speed, Pseq([
				Pseq([
					1,1,
				],2),
				Pseq([
					Pseries(1,10,0.1),
				],1),
			],inf),
			\gain, 0.3,
			\dur, 1/12,
			\out, BusDef(\echoer2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/1,
			\dur, 1/16,
			\out, BusDef(\echoer2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/4,
			\dur, 1/16,
			//\out, BusDef(\limiter2, \audio),
		)),
		Pmono(\echoer,
			\inbus, BusDef(\echoer2, \audio),
			\delay, ~pmodenv.(Pseq(1/[10,101,1,504,60,20,1,70]/2,inf), 1.712),
			\itrig,Pseq([0,1],inf),
			\gain, 0.8,
			\dur, 1/2,
			\out, BusDef(\limiter2,\audio),
		),
		Pmono(\echoer,
			\inbus, BusDef(\echoer2, \audio),
			\delay, ~pmodenv.(Pseq(1/[10,101,204,60,20,1,70],inf), 1.412),
			\itrig,Pseq([0,1],inf),
			\gain, 0.8,
			\dur, 1/2,
			\out, BusDef(\limiter2,\audio),
		),
		Pmono(\echoer,
			\inbus, BusDef(\echoer2, \audio),
			\delay, ~pmodenv.(Pseq(1/[10,101,504,60,20,1,70],inf), 1),
			\itrig,Pseq([0,1],inf),
			\gain, 0.8,
			\dur, 1/2,
			\out, BusDef(\limiter2,\audio),
		),
		Pmono(\fx_limiter,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\limiter2, \audio),
			\level, 0.1/2,
			\limdur, 0.001,
			\gain, 1,
			\dur, 1,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
				],16),
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\velamp,4,
			\dur, 1/16,
			\out, BusDef(\echoer2, \audio),
		)),
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pseq([
				Pexprand(100,8000,4).stutter(Pseq([4,3],inf)),
				Pseries(1,10,100).stutter(8),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\oscmix, Pwhite(0,1.0),
			\fmr, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, rrand(1/2,1/16),
			\lag, rrand(0,0.3),
			\amp, 0.1 * 0.4,
		)}!8),
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pexprand(100,14000),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,10.1) ],
			],inf),
			\fmr, Pwhite(1/40,10),
			\fmamp, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\oscmix, Pwhite(0,1.0),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, Prand([1/4,2,1],1).keep(1).repeat * Pseg(Pseq([1,1/3],inf),8),
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		)}!1),
		Pbind(
			\instrument, \cymbalsimple2,
			\freq, 200,
			\dur, 4,
			\rel, 4.5,
			\att, 0.01,
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		),
		Pmono(\echoer,
			\inbus, BusDef(\echoer, \audio),
			\delay, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 8),
			\itrig,1,
			\gain, 0.8,
			\dur, 1,
			\out, BusDef(\limiter, \audio),
		),
		Pmono(\fx_limiter,
			\inbus, BusDef(\limiter, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\level, 0.1/2,
			\limdur, 0.001,
			\gain, 1,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\castle_calme, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\freq, 70,
			\dur, 1,
			\amp, 0.1,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,1,0,1,
				0,0,0,1, 1,0,0,1,

				1,0,0,0, 0,0,1,1,
				0,0,0,1, 1,0,1,0,
				1,0,0,1, 1,0,1,1,
				0,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/16,
			\isRest, true,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0.5, 0.5,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0.51,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,0,1,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\sustain, 0.1,
			\speed, Pseq([
				Pseq([
					1,1,
				],2),
				Pseq([
					Pseries(1,10,0.1),
				],1),
			],inf),
			\gain, 0.3,
			\dur, 1/12,
			\out, BusDef(\echoer2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/1,
			\dur, 1/16,
			\out, BusDef(\echoer, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/1,
			\dur, 1/16,
			\out, BusDef(\echoer2, \audio),
		)),
		Pmono(\echoer,
			\inbus, BusDef(\echoer2, \audio),
			\delay, ~pmodenv.(Pseq([1/101,1/54]/11,inf), 8),
			\itrig,Pseq([0,1],inf),
			\gain, 0.4,
			\mix, 0.4,
			\dur, 1/2,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
				],16),
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\velamp,4,
			\dur, 1/16,
			\isRest, true,
		)),
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pseq([
				Pseries(1,10,100).stutter(8),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\oscmix, Pwhite(0,1.0),
			\fmr, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\isRest, Pseq([
				0,
				1,
			],inf).stutter(8).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\lag, rrand(0,0.3),
			\amp, 0.1 * 0.8,
		)}!8),
		Ppar({Pbind(
			\instrument, \longrain,
			\freq, Pexprand(100,14000),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,10.1) ],
			],inf),
			\fmr, Pwhite(1/40,10),
			\fmamp, Pwhite(1/40,10),
			\rq, Pwhite(0.1,1),
			\oscmix, Pwhite(0,1.0),
			\isRest, Pseq([
				1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, Prand([1/4,2,1],1).keep(1).repeat * Pseg(Pseq([1,1/3],inf),8),
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		)}!1),
		Pbind(
			\instrument, \cymbalsimple2,
			\freq, 200,
			\dur, 4,
			\rel, 4.5,
			\att, 0.01,
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		),
		Pmono(\echoer,
			\inbus, BusDef(\echoer, \audio),
			\delay, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 8),
			\decay, 1,
			\itrig,1,
			\gain, 0.8,
			\dur, 1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pdef(\evolbass),
		//Pdef(\devolbass),
		Pdef(\castle_perc),
		//Pdef(\castle_calme),
		
	])
)).play;
);
		Pdef(\part2, Pdef(\devolbass)).play
		Pdef(\devolbass).stop




(
	Pdef(\part, Pdef(\zed, 
		Ppar([
		Pdef(\evolbass),
		Pdef(\evoltreb),
			Plazy({ arg ev;
				Pfindur([4,2,8,1,6,3].choose,
					PatKitDef(\rim).asPattern(Pbind(
						\kitIndex, [0,1,2,4,5,8].choose,
						\isRest, Pseq([
							1,
						],inf).coin.not,
						\sustain, 0.1,
						\gain, 0.2,
						\dur, (1..8).choose/8,
						\speed, Pseq([
							rrand(0.4,1.4)
						],inf),
					)),
				);
			}).loop!8,
		].flat,20),
	)).play;
);






(
	~master.();
Pdef(\part3, Pdef(\ile5perc, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0, 0,0,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,1, 
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1, 0,0,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,1, 

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0, 0,0,1,1, 0,0,1,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,1, 1,0,0,1, 
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/16,
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,1,0, 1,1,0,0,
				0,0,0,0, 1,0,1,0, 0,0,1,1, 0,1,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0, 0,0,1,0, 1,1,0,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.06,
			\dur, 1/16,
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
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
			\lag, 0.04,
			//\out, BusDef(\sendbus2, \audio),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\velamp, 1/6,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,1, 0,1,1,0, 0,0,0,1, 1,0,1,0,
				0,0,0,0, 1,0,0,1, 0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/16,
			\out, BusDef(\sendbus2, \audio),
		)),
		
	])
)).play;
);

(
Pdef(\part3, Pdef(\ized, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 221.85797297904,
			\isRest, Pseq([
				1,0,0, 0,0,0,  0,1,0, 0,0,0,  
				1,0,0, 0,0,0,  0,0,0, 0,0,0,  
				1,0,0, 0,0,0,  0,1,0, 0,0,0,  
				1,0,0, 0,0,0,  0,0,0, 0,0,0,  
				1,0,0, 0,0,0,  0,1,0, 0,0,0,  
				1,0,0, 0,0,0,  0,0,0, 0,0,0,  
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)



(
	// voice
Pdef(\part, Pdef(\vorster, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/vorster.flac'),
			\speed, ~pmodenv.(Pseq([1,2,1,4]/2,inf), 8),
			\pos, Pwhite(0,10.0),
			\legato, 1,
			\out, BusDef(\sendbus3, \audio),
			\dur, 1,
			\gain, 0.1,
		)
	])
)).play;
);




(
Pdef(\part2, Pdef(\drodro, 
	Pseq([
		Pfindur(4,
			Ppar([
				Psched([0,3.5], Ppar([
					{ arg x;
						Pbind(
							\instrument, \drodro,
							\note, Pseq([
								Pseq((1..3+x),1),
								Pseq((1..3+x).reverse,x+1),
							],inf),
							\dur, 1/7,
							\lag, x/3,
							\octave, x+4,
							\legato, 1,
							\adsr, Pseq([
								[ Env.adsr(0.1,0.1,0.8,4.1) ],
							],inf),
							\amp, 0.1,
							\out, BusDef(\fxbus1, \audio),
						)
					}!4,
					Pmono(\comby,
						\inbus, BusDef(\fxbus1, \audio),
						\dur, 1,
						\gain, 0.5,
					),
				].flat)),
				Psched([3.5,4],
					Pbind(
						\instrument, \default,
						\freq, [
							3250,
							1151,
							2202,
							2720,
						],
						\dur, 1/2,
						\amp, 0.1,
					),
				)
			].flat),
		),
		Ppar([
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq({[
					1,0,0,1, 0,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
			)),
			Pmono(\drodro,
				\note, Pseq([
					0
				],inf),
				\octave, 6,
				\dur, 1,
				\amp, 0.1,
			),
			Pmono(\drodro,
				\note, Pseq([
					5,9,
				],inf),
				\octave, 6,
				\dur, Prand([1/8,1/3],inf),
				\amp, 0.1,
			),
		])
	],1),
)).play;
);
