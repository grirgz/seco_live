
// try to play with time signature with drums that last one time so it can have arbitrary number of macrotime

~t = 185/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1428].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2092].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1406].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\legato, 0.1,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		// 5 times
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[387].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0, 1,0,0,
			],inf).coin.not,
			\dur, 1 * (1/2),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[702].value,
			\isRest, Pseq([
				1,0, 1,0,1,
			],inf).coin.not,
			\dur, 1 * (1/2),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[31].value,
			\isRest, Pseq([
				1,0, 0,1,0,
			],inf).coin.not,
			\dur, 1 * (1/2),
			\gain, 0.2,
		),

		// one time = 1/2 beats
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1428].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2092].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1406].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\legato, 0.1,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		// 5 times
		Pbind(\lag, 0.04) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[387].value,
				//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\isRest, Pseq([
					0,0, 1,0,0,
				],inf).coin.not,
				\dur, 1 * (1/2),
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[702].value,
				\isRest, Pseq([
					1,0, 1,0,1,
				],inf).coin.not,
				\dur, 1 * (1/2),
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[31].value,
				\isRest, Pseq([
					1,0, 0,1,0,
				],inf).coin.not,
				\dur, 1 * (1/2),
				\gain, 0.2,
			),
		]),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				2,0,4,4,4,
				-2,-2,-4,-4,-4,
			],inf),
			\octave, 3,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),

		// one time = 1/2 beats
		Pbind(\lag, 0.04) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1428].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.1/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[2092].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.21,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1406].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\legato, 0.1,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.11,
			),
		]),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		// 5 times
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[31].value,
			\isRest, Pseq([
				1,0, 0,0,1,
				1,0, 0,1,0,
			],inf).coin.not,
			\dur, 1 * (1/2),
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[387].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0, 1,0,0,
			],inf).coin.not,
			\dur, 1 * (1/2),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[702].value,
			\isRest, Pseq([
				1,0, 1,0,1,
				0,1, 0,1,0,
			],inf).coin.not,
			\dur, 1 * (1/2),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				2,0,4,4,4,
				-2,-2,-4,-4,-4,
			],inf),
			\octave, 3,
			\dur, 1/2,
			\amp, 0.1,
		),

		// one time = 1/2 beats
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1428].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2092].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1406].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\legato, 0.1,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		
	].collect { arg pat, idx;
		Pbind( \out, BusDef(\mixer+++( idx ), \audio), ) <> pat
		
	};)
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		// 5 times
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[31].value,
			\isRest, Pseq([
				1,0, 0,0,1,
				1,0, 0,1,0,
			],inf).coin.not,
			\dur, 1 * (1/2),
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[387].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,1, 0,1,0,
				1,0, 1,0,1,
			],inf).coin.not,
			\dur, 1 * (1/2),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[702].value,
			\isRest, Pseq([
				1,0, 1,0,1,
				0,1, 0,1,0,
			],inf).coin.not,
			\dur, 1 * (1/2),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				2,0,4,4,4,
				-2,-2,-4,-4,-4,
			],inf),
			\octave, 3,
			\dur, 1/2,
			\amp, 0.1,
		),

		// one time = 1/2 beats
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1428].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2092].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1406].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\legato, 0.1,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		
	].collect { arg pat, idx;
		Pbind( \out, BusDef(\mixer+++( idx ), \audio), ) <> pat
		
	};)
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		// 5 times
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[387].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0, 1,0,0,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[702].value,
			\isRest, Pseq([
				1,0, 1,0,1,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[31].value,
			\isRest, Pseq([
				1,0, 0,1,0,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\gain, 0.2,
		),

		// one time = 1/4 beats
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1428].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2092].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1406].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\legato, 0.1,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		// 7 times
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[31].value,
			\isRest, Pseq([
				1,0, 0,0,0,0,1,
				1,0, 1,0,0,0,0,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[387].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0, 0,1,0,0,0,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[702].value,
			\isRest, Pseq([
				1,0, 1,0,1,0,1,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\dur, 1/8,
			\gain, 0.11,
		),

		// one time = 1/4 beats
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1428].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\swing, (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/16 * Pkey(\swing),
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2092].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\swing, (1 + (0.36 * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1406].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\legato, 0.1,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\swing, (1 + (0.36 * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		// 7 times
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[31].value,
			\isRest, Pseq([
				1,0, 0,0,0,0,1,
				1,0, 1,0,0,0,0,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[387].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0, 0,1,0,0,0,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[702].value,
			\isRest, Pseq([
				1,0, 1,0,1,0,1,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\dur, 1/8,
			\gain, 0.11,
		),

		// one time = 1/4 beats
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1428].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\swing, (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/16 * Pkey(\swing),
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2092].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\swing, (1 + (0.36 * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1406].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\legato, 0.1,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\swing, (1 + (0.36 * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\gain, 0.11,
		),
		
	].collect { arg pat, idx;
		Pbind( \out, BusDef(\mixer+++( idx ), \audio), ) <> pat
		
	};)
)).play;
);

ProtoDef(\FxManager).presetCompileString.editorInsert
ProtoDef(\simpleMixer).presetCompileString.editorInsert
(
ProtoDef('simpleMixer').trackCount = 10;

ProtoDef('simpleMixer').tracks[0].set('inbus', BusDef('mixer0'));
ProtoDef('simpleMixer').tracks[0].set('wet1', 1.0);
ProtoDef('simpleMixer').tracks[0].set('mute', 0);
ProtoDef('simpleMixer').tracks[0].set('solo', 0);
ProtoDef('simpleMixer').tracks[0].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[0].set('prefader', 0);
ProtoDef('simpleMixer').tracks[0].set('wet2100', 1.0);
ProtoDef('simpleMixer').tracks[0].set('sendbus0', BusDef('sendbus0'));
ProtoDef('simpleMixer').tracks[0].set('send0', 0);
ProtoDef('simpleMixer').tracks[0].set('wet2101', 1.0);
ProtoDef('simpleMixer').tracks[0].set('sendbus1', BusDef('sendbus1'));
ProtoDef('simpleMixer').tracks[0].set('send1', 1.0);
ProtoDef('simpleMixer').tracks[0].set('wet2102', 1.0);
ProtoDef('simpleMixer').tracks[0].set('sendbus2', BusDef('sendbus2'));
ProtoDef('simpleMixer').tracks[0].set('send2', 0.0);
ProtoDef('simpleMixer').tracks[0].set('wet2103', 1.0);
ProtoDef('simpleMixer').tracks[0].set('sendbus3', BusDef('sendbus3'));
ProtoDef('simpleMixer').tracks[0].set('send3', 0);
ProtoDef('simpleMixer').tracks[0].set('wet2104', 1.0);
ProtoDef('simpleMixer').tracks[0].set('sendbus4', BusDef('sendbus4'));
ProtoDef('simpleMixer').tracks[0].set('send4', 0);
ProtoDef('simpleMixer').tracks[0].set('wet2105', 1.0);
ProtoDef('simpleMixer').tracks[0].set('sendbus5', BusDef('sendbus5'));
ProtoDef('simpleMixer').tracks[0].set('send5', 0);
ProtoDef('simpleMixer').tracks[0].set('wet2106', 1.0);
ProtoDef('simpleMixer').tracks[0].set('sendbus6', BusDef('sendbus6'));
ProtoDef('simpleMixer').tracks[0].set('send6', 0);
ProtoDef('simpleMixer').tracks[0].set('wet2107', 1.0);
ProtoDef('simpleMixer').tracks[0].set('sendbus7', BusDef('sendbus7'));
ProtoDef('simpleMixer').tracks[0].set('send7', 0);
ProtoDef('simpleMixer').tracks[0].set('wet3001', 1.0);
ProtoDef('simpleMixer').tracks[0].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[0].set('wet4000', 1.0);
ProtoDef('simpleMixer').tracks[0].set('postfader', 0);
ProtoDef('simpleMixer').tracks[0].set('wet5000', 1.0);
ProtoDef('simpleMixer').tracks[0].set('recbus', BusDef('trackMixerDef_record_mixer0'));
ProtoDef('simpleMixer').tracks[0].outBus = 0;

ProtoDef('simpleMixer').tracks[1].set('inbus', BusDef('mixer1'));
ProtoDef('simpleMixer').tracks[1].set('wet1', 1.0);
ProtoDef('simpleMixer').tracks[1].set('mute', 0);
ProtoDef('simpleMixer').tracks[1].set('solo', 0);
ProtoDef('simpleMixer').tracks[1].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[1].set('prefader', 0);
ProtoDef('simpleMixer').tracks[1].set('wet2100', 1.0);
ProtoDef('simpleMixer').tracks[1].set('sendbus0', BusDef('sendbus0'));
ProtoDef('simpleMixer').tracks[1].set('send0', 0);
ProtoDef('simpleMixer').tracks[1].set('wet2101', 1.0);
ProtoDef('simpleMixer').tracks[1].set('sendbus1', BusDef('sendbus1'));
ProtoDef('simpleMixer').tracks[1].set('send1', 0.0);
ProtoDef('simpleMixer').tracks[1].set('wet2102', 1.0);
ProtoDef('simpleMixer').tracks[1].set('sendbus2', BusDef('sendbus2'));
ProtoDef('simpleMixer').tracks[1].set('send2', 0.58855017059026);
ProtoDef('simpleMixer').tracks[1].set('wet2103', 1.0);
ProtoDef('simpleMixer').tracks[1].set('sendbus3', BusDef('sendbus3'));
ProtoDef('simpleMixer').tracks[1].set('send3', 0);
ProtoDef('simpleMixer').tracks[1].set('wet2104', 1.0);
ProtoDef('simpleMixer').tracks[1].set('sendbus4', BusDef('sendbus4'));
ProtoDef('simpleMixer').tracks[1].set('send4', 0);
ProtoDef('simpleMixer').tracks[1].set('wet2105', 1.0);
ProtoDef('simpleMixer').tracks[1].set('sendbus5', BusDef('sendbus5'));
ProtoDef('simpleMixer').tracks[1].set('send5', 0);
ProtoDef('simpleMixer').tracks[1].set('wet2106', 1.0);
ProtoDef('simpleMixer').tracks[1].set('sendbus6', BusDef('sendbus6'));
ProtoDef('simpleMixer').tracks[1].set('send6', 0);
ProtoDef('simpleMixer').tracks[1].set('wet2107', 1.0);
ProtoDef('simpleMixer').tracks[1].set('sendbus7', BusDef('sendbus7'));
ProtoDef('simpleMixer').tracks[1].set('send7', 0);
ProtoDef('simpleMixer').tracks[1].set('wet3001', 1.0);
ProtoDef('simpleMixer').tracks[1].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[1].set('wet4000', 1.0);
ProtoDef('simpleMixer').tracks[1].set('postfader', 0);
ProtoDef('simpleMixer').tracks[1].set('wet5000', 1.0);
ProtoDef('simpleMixer').tracks[1].set('recbus', BusDef('trackMixerDef_record_mixer1'));
ProtoDef('simpleMixer').tracks[1].outBus = 0;

ProtoDef('simpleMixer').tracks[2].set('inbus', BusDef('mixer2'));
ProtoDef('simpleMixer').tracks[2].set('wet1', 1.0);
ProtoDef('simpleMixer').tracks[2].set('mute', 0);
ProtoDef('simpleMixer').tracks[2].set('solo', 0);
ProtoDef('simpleMixer').tracks[2].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[2].set('prefader', 0);
ProtoDef('simpleMixer').tracks[2].set('wet2100', 1.0);
ProtoDef('simpleMixer').tracks[2].set('sendbus0', BusDef('sendbus0'));
ProtoDef('simpleMixer').tracks[2].set('send0', 0);
ProtoDef('simpleMixer').tracks[2].set('wet2101', 1.0);
ProtoDef('simpleMixer').tracks[2].set('sendbus1', BusDef('sendbus1'));
ProtoDef('simpleMixer').tracks[2].set('send1', 0);
ProtoDef('simpleMixer').tracks[2].set('wet2102', 1.0);
ProtoDef('simpleMixer').tracks[2].set('sendbus2', BusDef('sendbus2'));
ProtoDef('simpleMixer').tracks[2].set('send2', 0);
ProtoDef('simpleMixer').tracks[2].set('wet2103', 1.0);
ProtoDef('simpleMixer').tracks[2].set('sendbus3', BusDef('sendbus3'));
ProtoDef('simpleMixer').tracks[2].set('send3', 0);
ProtoDef('simpleMixer').tracks[2].set('wet2104', 1.0);
ProtoDef('simpleMixer').tracks[2].set('sendbus4', BusDef('sendbus4'));
ProtoDef('simpleMixer').tracks[2].set('send4', 0);
ProtoDef('simpleMixer').tracks[2].set('wet2105', 1.0);
ProtoDef('simpleMixer').tracks[2].set('sendbus5', BusDef('sendbus5'));
ProtoDef('simpleMixer').tracks[2].set('send5', 0);
ProtoDef('simpleMixer').tracks[2].set('wet2106', 1.0);
ProtoDef('simpleMixer').tracks[2].set('sendbus6', BusDef('sendbus6'));
ProtoDef('simpleMixer').tracks[2].set('send6', 0);
ProtoDef('simpleMixer').tracks[2].set('wet2107', 1.0);
ProtoDef('simpleMixer').tracks[2].set('sendbus7', BusDef('sendbus7'));
ProtoDef('simpleMixer').tracks[2].set('send7', 0);
ProtoDef('simpleMixer').tracks[2].set('wet3001', 1.0);
ProtoDef('simpleMixer').tracks[2].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[2].set('wet4000', 1.0);
ProtoDef('simpleMixer').tracks[2].set('postfader', 0);
ProtoDef('simpleMixer').tracks[2].set('wet5000', 1.0);
ProtoDef('simpleMixer').tracks[2].set('recbus', BusDef('trackMixerDef_record_mixer2'));
ProtoDef('simpleMixer').tracks[2].outBus = 0;

ProtoDef('simpleMixer').tracks[3].set('inbus', BusDef('mixer3'));
ProtoDef('simpleMixer').tracks[3].set('wet1', 1.0);
ProtoDef('simpleMixer').tracks[3].set('mute', 0);
ProtoDef('simpleMixer').tracks[3].set('solo', 0);
ProtoDef('simpleMixer').tracks[3].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[3].set('prefader', 0);
ProtoDef('simpleMixer').tracks[3].set('wet2100', 1.0);
ProtoDef('simpleMixer').tracks[3].set('sendbus0', BusDef('sendbus0'));
ProtoDef('simpleMixer').tracks[3].set('send0', 0);
ProtoDef('simpleMixer').tracks[3].set('wet2101', 1.0);
ProtoDef('simpleMixer').tracks[3].set('sendbus1', BusDef('sendbus1'));
ProtoDef('simpleMixer').tracks[3].set('send1', 0.3123002250866);
ProtoDef('simpleMixer').tracks[3].set('wet2102', 1.0);
ProtoDef('simpleMixer').tracks[3].set('sendbus2', BusDef('sendbus2'));
ProtoDef('simpleMixer').tracks[3].set('send2', 0.0);
ProtoDef('simpleMixer').tracks[3].set('wet2103', 1.0);
ProtoDef('simpleMixer').tracks[3].set('sendbus3', BusDef('sendbus3'));
ProtoDef('simpleMixer').tracks[3].set('send3', 0);
ProtoDef('simpleMixer').tracks[3].set('wet2104', 1.0);
ProtoDef('simpleMixer').tracks[3].set('sendbus4', BusDef('sendbus4'));
ProtoDef('simpleMixer').tracks[3].set('send4', 0);
ProtoDef('simpleMixer').tracks[3].set('wet2105', 1.0);
ProtoDef('simpleMixer').tracks[3].set('sendbus5', BusDef('sendbus5'));
ProtoDef('simpleMixer').tracks[3].set('send5', 0);
ProtoDef('simpleMixer').tracks[3].set('wet2106', 1.0);
ProtoDef('simpleMixer').tracks[3].set('sendbus6', BusDef('sendbus6'));
ProtoDef('simpleMixer').tracks[3].set('send6', 0);
ProtoDef('simpleMixer').tracks[3].set('wet2107', 1.0);
ProtoDef('simpleMixer').tracks[3].set('sendbus7', BusDef('sendbus7'));
ProtoDef('simpleMixer').tracks[3].set('send7', 0);
ProtoDef('simpleMixer').tracks[3].set('wet3001', 1.0);
ProtoDef('simpleMixer').tracks[3].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[3].set('wet4000', 1.0);
ProtoDef('simpleMixer').tracks[3].set('postfader', 0);
ProtoDef('simpleMixer').tracks[3].set('wet5000', 1.0);
ProtoDef('simpleMixer').tracks[3].set('recbus', BusDef('trackMixerDef_record_mixer3'));
ProtoDef('simpleMixer').tracks[3].outBus = 0;

ProtoDef('simpleMixer').tracks[4].set('inbus', BusDef('mixer4'));
ProtoDef('simpleMixer').tracks[4].set('wet1', 1.0);
ProtoDef('simpleMixer').tracks[4].set('mute', 0);
ProtoDef('simpleMixer').tracks[4].set('solo', 0);
ProtoDef('simpleMixer').tracks[4].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[4].set('prefader', 0);
ProtoDef('simpleMixer').tracks[4].set('wet2100', 1.0);
ProtoDef('simpleMixer').tracks[4].set('sendbus0', BusDef('sendbus0'));
ProtoDef('simpleMixer').tracks[4].set('send0', 0);
ProtoDef('simpleMixer').tracks[4].set('wet2101', 1.0);
ProtoDef('simpleMixer').tracks[4].set('sendbus1', BusDef('sendbus1'));
ProtoDef('simpleMixer').tracks[4].set('send1', 0);
ProtoDef('simpleMixer').tracks[4].set('wet2102', 1.0);
ProtoDef('simpleMixer').tracks[4].set('sendbus2', BusDef('sendbus2'));
ProtoDef('simpleMixer').tracks[4].set('send2', 0);
ProtoDef('simpleMixer').tracks[4].set('wet2103', 1.0);
ProtoDef('simpleMixer').tracks[4].set('sendbus3', BusDef('sendbus3'));
ProtoDef('simpleMixer').tracks[4].set('send3', 0.0);
ProtoDef('simpleMixer').tracks[4].set('wet2104', 1.0);
ProtoDef('simpleMixer').tracks[4].set('sendbus4', BusDef('sendbus4'));
ProtoDef('simpleMixer').tracks[4].set('send4', 0);
ProtoDef('simpleMixer').tracks[4].set('wet2105', 1.0);
ProtoDef('simpleMixer').tracks[4].set('sendbus5', BusDef('sendbus5'));
ProtoDef('simpleMixer').tracks[4].set('send5', 0);
ProtoDef('simpleMixer').tracks[4].set('wet2106', 1.0);
ProtoDef('simpleMixer').tracks[4].set('sendbus6', BusDef('sendbus6'));
ProtoDef('simpleMixer').tracks[4].set('send6', 0);
ProtoDef('simpleMixer').tracks[4].set('wet2107', 1.0);
ProtoDef('simpleMixer').tracks[4].set('sendbus7', BusDef('sendbus7'));
ProtoDef('simpleMixer').tracks[4].set('send7', 0);
ProtoDef('simpleMixer').tracks[4].set('wet3001', 1.0);
ProtoDef('simpleMixer').tracks[4].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[4].set('wet4000', 1.0);
ProtoDef('simpleMixer').tracks[4].set('postfader', 0);
ProtoDef('simpleMixer').tracks[4].set('wet5000', 1.0);
ProtoDef('simpleMixer').tracks[4].set('recbus', BusDef('trackMixerDef_record_mixer4'));
ProtoDef('simpleMixer').tracks[4].outBus = 0;

ProtoDef('simpleMixer').tracks[5].set('inbus', BusDef('mixer5'));
ProtoDef('simpleMixer').tracks[5].set('wet1', 1.0);
ProtoDef('simpleMixer').tracks[5].set('mute', 0);
ProtoDef('simpleMixer').tracks[5].set('solo', 0);
ProtoDef('simpleMixer').tracks[5].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[5].set('prefader', 0);
ProtoDef('simpleMixer').tracks[5].set('wet2100', 1.0);
ProtoDef('simpleMixer').tracks[5].set('sendbus0', BusDef('sendbus0'));
ProtoDef('simpleMixer').tracks[5].set('send0', 0);
ProtoDef('simpleMixer').tracks[5].set('wet2101', 1.0);
ProtoDef('simpleMixer').tracks[5].set('sendbus1', BusDef('sendbus1'));
ProtoDef('simpleMixer').tracks[5].set('send1', 0.0);
ProtoDef('simpleMixer').tracks[5].set('wet2102', 1.0);
ProtoDef('simpleMixer').tracks[5].set('sendbus2', BusDef('sendbus2'));
ProtoDef('simpleMixer').tracks[5].set('send2', 0.39464165917917);
ProtoDef('simpleMixer').tracks[5].set('wet2103', 1.0);
ProtoDef('simpleMixer').tracks[5].set('sendbus3', BusDef('sendbus3'));
ProtoDef('simpleMixer').tracks[5].set('send3', 0);
ProtoDef('simpleMixer').tracks[5].set('wet2104', 1.0);
ProtoDef('simpleMixer').tracks[5].set('sendbus4', BusDef('sendbus4'));
ProtoDef('simpleMixer').tracks[5].set('send4', 0);
ProtoDef('simpleMixer').tracks[5].set('wet2105', 1.0);
ProtoDef('simpleMixer').tracks[5].set('sendbus5', BusDef('sendbus5'));
ProtoDef('simpleMixer').tracks[5].set('send5', 0);
ProtoDef('simpleMixer').tracks[5].set('wet2106', 1.0);
ProtoDef('simpleMixer').tracks[5].set('sendbus6', BusDef('sendbus6'));
ProtoDef('simpleMixer').tracks[5].set('send6', 0);
ProtoDef('simpleMixer').tracks[5].set('wet2107', 1.0);
ProtoDef('simpleMixer').tracks[5].set('sendbus7', BusDef('sendbus7'));
ProtoDef('simpleMixer').tracks[5].set('send7', 0);
ProtoDef('simpleMixer').tracks[5].set('wet3001', 1.0);
ProtoDef('simpleMixer').tracks[5].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[5].set('wet4000', 1.0);
ProtoDef('simpleMixer').tracks[5].set('postfader', 0);
ProtoDef('simpleMixer').tracks[5].set('wet5000', 1.0);
ProtoDef('simpleMixer').tracks[5].set('recbus', BusDef('trackMixerDef_record_mixer5'));
ProtoDef('simpleMixer').tracks[5].outBus = 0;

ProtoDef('simpleMixer').tracks[6].set('inbus', BusDef('mixer6'));
ProtoDef('simpleMixer').tracks[6].set('wet1', 1.0);
ProtoDef('simpleMixer').tracks[6].set('mute', 0);
ProtoDef('simpleMixer').tracks[6].set('solo', 0);
ProtoDef('simpleMixer').tracks[6].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[6].set('prefader', 0);
ProtoDef('simpleMixer').tracks[6].set('wet2100', 1.0);
ProtoDef('simpleMixer').tracks[6].set('sendbus0', BusDef('sendbus0'));
ProtoDef('simpleMixer').tracks[6].set('send0', 0);
ProtoDef('simpleMixer').tracks[6].set('wet2101', 1.0);
ProtoDef('simpleMixer').tracks[6].set('sendbus1', BusDef('sendbus1'));
ProtoDef('simpleMixer').tracks[6].set('send1', 0);
ProtoDef('simpleMixer').tracks[6].set('wet2102', 1.0);
ProtoDef('simpleMixer').tracks[6].set('sendbus2', BusDef('sendbus2'));
ProtoDef('simpleMixer').tracks[6].set('send2', 0);
ProtoDef('simpleMixer').tracks[6].set('wet2103', 1.0);
ProtoDef('simpleMixer').tracks[6].set('sendbus3', BusDef('sendbus3'));
ProtoDef('simpleMixer').tracks[6].set('send3', 0);
ProtoDef('simpleMixer').tracks[6].set('wet2104', 1.0);
ProtoDef('simpleMixer').tracks[6].set('sendbus4', BusDef('sendbus4'));
ProtoDef('simpleMixer').tracks[6].set('send4', 0);
ProtoDef('simpleMixer').tracks[6].set('wet2105', 1.0);
ProtoDef('simpleMixer').tracks[6].set('sendbus5', BusDef('sendbus5'));
ProtoDef('simpleMixer').tracks[6].set('send5', 0);
ProtoDef('simpleMixer').tracks[6].set('wet2106', 1.0);
ProtoDef('simpleMixer').tracks[6].set('sendbus6', BusDef('sendbus6'));
ProtoDef('simpleMixer').tracks[6].set('send6', 0);
ProtoDef('simpleMixer').tracks[6].set('wet2107', 1.0);
ProtoDef('simpleMixer').tracks[6].set('sendbus7', BusDef('sendbus7'));
ProtoDef('simpleMixer').tracks[6].set('send7', 0);
ProtoDef('simpleMixer').tracks[6].set('wet3001', 1.0);
ProtoDef('simpleMixer').tracks[6].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[6].set('wet4000', 1.0);
ProtoDef('simpleMixer').tracks[6].set('postfader', 0);
ProtoDef('simpleMixer').tracks[6].set('wet5000', 1.0);
ProtoDef('simpleMixer').tracks[6].set('recbus', BusDef('trackMixerDef_record_mixer6'));
ProtoDef('simpleMixer').tracks[6].outBus = 0;

ProtoDef('simpleMixer').tracks[7].set('inbus', BusDef('mixer7'));
ProtoDef('simpleMixer').tracks[7].set('wet1', 1.0);
ProtoDef('simpleMixer').tracks[7].set('mute', 0);
ProtoDef('simpleMixer').tracks[7].set('solo', 0);
ProtoDef('simpleMixer').tracks[7].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[7].set('prefader', 0);
ProtoDef('simpleMixer').tracks[7].set('wet2100', 1.0);
ProtoDef('simpleMixer').tracks[7].set('sendbus0', BusDef('sendbus0'));
ProtoDef('simpleMixer').tracks[7].set('send0', 0);
ProtoDef('simpleMixer').tracks[7].set('wet2101', 1.0);
ProtoDef('simpleMixer').tracks[7].set('sendbus1', BusDef('sendbus1'));
ProtoDef('simpleMixer').tracks[7].set('send1', 0);
ProtoDef('simpleMixer').tracks[7].set('wet2102', 1.0);
ProtoDef('simpleMixer').tracks[7].set('sendbus2', BusDef('sendbus2'));
ProtoDef('simpleMixer').tracks[7].set('send2', 0);
ProtoDef('simpleMixer').tracks[7].set('wet2103', 1.0);
ProtoDef('simpleMixer').tracks[7].set('sendbus3', BusDef('sendbus3'));
ProtoDef('simpleMixer').tracks[7].set('send3', 0);
ProtoDef('simpleMixer').tracks[7].set('wet2104', 1.0);
ProtoDef('simpleMixer').tracks[7].set('sendbus4', BusDef('sendbus4'));
ProtoDef('simpleMixer').tracks[7].set('send4', 0);
ProtoDef('simpleMixer').tracks[7].set('wet2105', 1.0);
ProtoDef('simpleMixer').tracks[7].set('sendbus5', BusDef('sendbus5'));
ProtoDef('simpleMixer').tracks[7].set('send5', 0);
ProtoDef('simpleMixer').tracks[7].set('wet2106', 1.0);
ProtoDef('simpleMixer').tracks[7].set('sendbus6', BusDef('sendbus6'));
ProtoDef('simpleMixer').tracks[7].set('send6', 0);
ProtoDef('simpleMixer').tracks[7].set('wet2107', 1.0);
ProtoDef('simpleMixer').tracks[7].set('sendbus7', BusDef('sendbus7'));
ProtoDef('simpleMixer').tracks[7].set('send7', 0);
ProtoDef('simpleMixer').tracks[7].set('wet3001', 1.0);
ProtoDef('simpleMixer').tracks[7].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[7].set('wet4000', 1.0);
ProtoDef('simpleMixer').tracks[7].set('postfader', 0);
ProtoDef('simpleMixer').tracks[7].set('wet5000', 1.0);
ProtoDef('simpleMixer').tracks[7].set('recbus', BusDef('trackMixerDef_record_mixer7'));
ProtoDef('simpleMixer').tracks[7].outBus = 0;

ProtoDef('simpleMixer').tracks[8].set('inbus', BusDef('mixer8'));
ProtoDef('simpleMixer').tracks[8].set('wet1', 1.0);
ProtoDef('simpleMixer').tracks[8].set('mute', 0);
ProtoDef('simpleMixer').tracks[8].set('solo', 0);
ProtoDef('simpleMixer').tracks[8].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[8].set('prefader', 0);
ProtoDef('simpleMixer').tracks[8].set('wet2100', 1.0);
ProtoDef('simpleMixer').tracks[8].set('sendbus0', BusDef('sendbus0'));
ProtoDef('simpleMixer').tracks[8].set('send0', 0);
ProtoDef('simpleMixer').tracks[8].set('wet2101', 1.0);
ProtoDef('simpleMixer').tracks[8].set('sendbus1', BusDef('sendbus1'));
ProtoDef('simpleMixer').tracks[8].set('send1', 0);
ProtoDef('simpleMixer').tracks[8].set('wet2102', 1.0);
ProtoDef('simpleMixer').tracks[8].set('sendbus2', BusDef('sendbus2'));
ProtoDef('simpleMixer').tracks[8].set('send2', 0);
ProtoDef('simpleMixer').tracks[8].set('wet2103', 1.0);
ProtoDef('simpleMixer').tracks[8].set('sendbus3', BusDef('sendbus3'));
ProtoDef('simpleMixer').tracks[8].set('send3', 0);
ProtoDef('simpleMixer').tracks[8].set('wet2104', 1.0);
ProtoDef('simpleMixer').tracks[8].set('sendbus4', BusDef('sendbus4'));
ProtoDef('simpleMixer').tracks[8].set('send4', 0);
ProtoDef('simpleMixer').tracks[8].set('wet2105', 1.0);
ProtoDef('simpleMixer').tracks[8].set('sendbus5', BusDef('sendbus5'));
ProtoDef('simpleMixer').tracks[8].set('send5', 0);
ProtoDef('simpleMixer').tracks[8].set('wet2106', 1.0);
ProtoDef('simpleMixer').tracks[8].set('sendbus6', BusDef('sendbus6'));
ProtoDef('simpleMixer').tracks[8].set('send6', 0);
ProtoDef('simpleMixer').tracks[8].set('wet2107', 1.0);
ProtoDef('simpleMixer').tracks[8].set('sendbus7', BusDef('sendbus7'));
ProtoDef('simpleMixer').tracks[8].set('send7', 0);
ProtoDef('simpleMixer').tracks[8].set('wet3001', 1.0);
ProtoDef('simpleMixer').tracks[8].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[8].set('wet4000', 1.0);
ProtoDef('simpleMixer').tracks[8].set('postfader', 0);
ProtoDef('simpleMixer').tracks[8].set('wet5000', 1.0);
ProtoDef('simpleMixer').tracks[8].set('recbus', BusDef('trackMixerDef_record_mixer8'));
ProtoDef('simpleMixer').tracks[8].outBus = 0;

ProtoDef('simpleMixer').tracks[9].set('inbus', BusDef('mixer9'));
ProtoDef('simpleMixer').tracks[9].set('wet1', 1.0);
ProtoDef('simpleMixer').tracks[9].set('mute', 0);
ProtoDef('simpleMixer').tracks[9].set('solo', 0);
ProtoDef('simpleMixer').tracks[9].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[9].set('prefader', 0);
ProtoDef('simpleMixer').tracks[9].set('wet2100', 1.0);
ProtoDef('simpleMixer').tracks[9].set('sendbus0', BusDef('sendbus0'));
ProtoDef('simpleMixer').tracks[9].set('send0', 0);
ProtoDef('simpleMixer').tracks[9].set('wet2101', 1.0);
ProtoDef('simpleMixer').tracks[9].set('sendbus1', BusDef('sendbus1'));
ProtoDef('simpleMixer').tracks[9].set('send1', 0);
ProtoDef('simpleMixer').tracks[9].set('wet2102', 1.0);
ProtoDef('simpleMixer').tracks[9].set('sendbus2', BusDef('sendbus2'));
ProtoDef('simpleMixer').tracks[9].set('send2', 0);
ProtoDef('simpleMixer').tracks[9].set('wet2103', 1.0);
ProtoDef('simpleMixer').tracks[9].set('sendbus3', BusDef('sendbus3'));
ProtoDef('simpleMixer').tracks[9].set('send3', 0);
ProtoDef('simpleMixer').tracks[9].set('wet2104', 1.0);
ProtoDef('simpleMixer').tracks[9].set('sendbus4', BusDef('sendbus4'));
ProtoDef('simpleMixer').tracks[9].set('send4', 0);
ProtoDef('simpleMixer').tracks[9].set('wet2105', 1.0);
ProtoDef('simpleMixer').tracks[9].set('sendbus5', BusDef('sendbus5'));
ProtoDef('simpleMixer').tracks[9].set('send5', 0);
ProtoDef('simpleMixer').tracks[9].set('wet2106', 1.0);
ProtoDef('simpleMixer').tracks[9].set('sendbus6', BusDef('sendbus6'));
ProtoDef('simpleMixer').tracks[9].set('send6', 0);
ProtoDef('simpleMixer').tracks[9].set('wet2107', 1.0);
ProtoDef('simpleMixer').tracks[9].set('sendbus7', BusDef('sendbus7'));
ProtoDef('simpleMixer').tracks[9].set('send7', 0);
ProtoDef('simpleMixer').tracks[9].set('wet3001', 1.0);
ProtoDef('simpleMixer').tracks[9].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[9].set('wet4000', 1.0);
ProtoDef('simpleMixer').tracks[9].set('postfader', 0);
ProtoDef('simpleMixer').tracks[9].set('wet5000', 1.0);
ProtoDef('simpleMixer').tracks[9].set('recbus', BusDef('trackMixerDef_record_mixer9'));
ProtoDef('simpleMixer').tracks[9].outBus = 0;
);

(
ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = 0;
ProtoDef('rdn').make('deldefault', 'rdn', "5-U7U4-IR26", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.84033613445378,
	'gain', 0.28571428571429,
	'fb', 0.0010717581338619,
	'delay', 0.00033190087959147,
	'delay2', 0.0001123104501833,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 55.962764453196,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.55924758241628,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

ProtoDef('rdn2').inbus = BusDef('sendbus2');
ProtoDef('rdn2').outBus = 0;
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-O130-IVOH", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.3424188360028,
	'gain', 0.72689075630252,
	'fb', 0.0001,
	'delay', 0.3255405118685,
	'delay2', 0.00014725404276241,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.0804718223181,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

ProtoDef('rdn3').inbus = BusDef('sendbus3');
ProtoDef('rdn3').outBus = 0;
ProtoDef('rdn3').make('deldefault', 'rdn3', "4-U6HH-HEJ4", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.84033613445378,
	'gain', 0.95798319327731,
	'fb', 0.0001,
	'delay', 0.071968567300115,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.52298278681437,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.55924758241628,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

ProtoDef('rdn4').inbus = BusDef('zero');
ProtoDef('rdn4').outBus = 0;
ProtoDef('rdn4').make('default', 'rdn4', nil, BusDef('zero'));
Ndef('rdn4').put(100, \pset -> Pbind(
	
).keep(1));




Ndef('fx1').source = nil;
PlayerWrapper(Ndef('fx1')).outBus = 0;


Ndef('fx2').source = nil;
PlayerWrapper(Ndef('fx2')).outBus = 0;


Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;


Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;


);



//////////////////////////////////////////////////////////////
//////////////////////////////////////

//// structure
// intro 28
// part1 25
// part2
// part3
// part2
// outro 28

// 1 measure = 7 * 1/2 = 3.5 beats
// 2 measure = 7 beats
// 8 measure = 7*4=28beats
// 16 measure = 7*8= 56 beats
// 160 beats = 3:27 minutes


SampleTimeline(\bka).edit


(
	// orig
Pdef(\part, Pdef(\drum1, 
	Ppar([

		// 7 times
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[31].value,
			\isRest, Pseq([
				1,0, 0,0,0,0,1,
				1,0, 1,0,0,0,0,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[387].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0, 0,1,0,0,0,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[702].value,
			\isRest, Pseq([
				1,0, 1,0,1,0,1,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\dur, 1/8,
			\gain, 0.11,
		),

		// one time = 1/4 beats
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1428].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\swing, (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/16 * Pkey(\swing),
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2092].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\swing, (1 + (0.36 * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1406].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\legato, 0.1,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\swing, (1 + (0.36 * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\gain, 0.11,
		),
		
	].collect { arg pat, idx;
		Pbind( \out, BusDef(\mixer+++( idx ), \audio), ) <> pat
		
	};)
)).play;
);


(
	// calm
Pdef(\part, Pdef(\drumcalm1, 
	Ppar([

		// 7 times
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[31].value,
			\isRest, Pseq([
				1,0, 0,0,0,0,1,
				0,0, 0,0,0,0,0,
				0,0, 0,0,0,0,0,
				0,0, 0,0,0,0,0,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[387].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0, 0,1,0,0,0,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[702].value,
			\isRest, Pseq([
				1,0, 1,0,1,0,1,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\dur, 1/8,
			\gain, 0.11,
		),

		// one time = 1/4 beats
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1428].value,
			\isRest, Pseq([
				1,0,0,0,
				1,0,0,0,
				1,0,0,0,
				1,0,0,0,
				1,0,0,0,
				0,0,0,0,
				0,0,0,0,
			],inf).coin.not,
			\swing, (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2092].value,
			\isRest, Pseq([
				0,1,
				0,1,
				0,1,
				0,1,
				0,1,
				0,0,
				0,0,
			],inf).coin.not,
			\swing, (1 + (0.36 * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1406].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\legato, 0.1,
			\isRest, Pseq([
				1,1,1,1,
				Pseq([
					0,0,0,0,
				],3),
				1,1,1,1,
				Pseq([
					0,0,0,0,
				],2),
			],inf).coin.not,
			\swing, (1 + (0.36 * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\gain, 0.11,
		),
		
	].collect { arg pat, idx;
		Pbind( \out, BusDef(\mixer+++( idx ), \audio), ) <> pat
		
	};)
)).play;
);

(
	// orig
Pdef(\part, Pdef(\drum2, 
	Ppar([

		// 7 times
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[31].value,
			\isRest, Pseq([
				1,0, 0,0,0,0,1,
				1,0, 1,0,0,0,0,
				1,0, 0,0,1,0,1,
				1,0, 0,0,0,1,0,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[387].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0, 0,1,0,0,0,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[702].value,
			\isRest, Pseq([
				1,0, 1,0,1,0,1,
			],inf).coin.not,
			\dur, 1 * (1/4),
			\dur, 1/8,
			\gain, 0.11,
		),

		// one time = 1/4 beats
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1428].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\swing, (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/16 * Pkey(\swing),
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2092].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\swing, (1 + (0.36 * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1406].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\legato, 0.1,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\swing, (1 + (0.36 * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\gain, 0.11,
		),
		
	].collect { arg pat, idx;
		Pbind( \out, BusDef(\mixer+++( idx ), \audio), ) <> pat
		
	};)
)).play;
);

///////: debug


TrackDef(\bla, TrackTemplateDef(\playergrid));
TrackDef(\bla).edit
TrackDef(\bla).children[0].children
ProtoDef(\simpleMixer).edit
s.queryAllNodes; 

/////////////// drones

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	
	TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), gdur, pan, 1);
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
SynthDef(\oscsampler3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01,
						lpmix=0.5, ffreq=500, rq=0.1, spread=0.8, fshift=0;
	// env longer
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	osc = SinOsc.ar(freq*[1.001,0.999,1]);
	//osc = osc.sum;
	pos = EnvGen.kr(\posenv.kr(Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])),gate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	range = (range + (\framerange.kr(0)/BufFrames.ir(bufnum)));
	phase = osc * range + pos + finepos.lag(\fineposlag.kr(0));

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	ou = bufsig;
	ffreqtab = \ffreqtab.kr(1!8);
	ou = FreqShift.ar(ou, fshift);
	ou2 = RLPF.ar(ou, (ffreq * ffreqtab).clip(10,18000), rq);
	ou = SelectX.ar(lpmix, [ou, ou2]);
	ou2 = HPF.ar(ou, (\hpfreq.kr(180) * ffreqtab).clip(10,18000));
	ou = SelectX.ar(\hpmix.kr(0), [ou, ou2]);

	ou2 = (ou * \distpreamp.kr(18)).tanh / \distamp.kr(1);
	ou = SelectX.ar(\distmix.kr(0), [ou, ou2]);
	ou = Splay.ar(ou, spread, amp, pan);

	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	
	Out.ar(out, ou);
}, metadata:(specs:(
	finepos: ControlSpec(-0.001,0.001,\lin, 0, 1),
	range: ControlSpec(-0.01,0.01,\lin, 0, 1),
	adsr: \env -> [nil, nil, nil, nil, Env.adsr(0.01,0.1,0.8,0.1)],
	posenv: \env -> [nil, nil, nil, nil, Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])],
	fshift: ControlSpec(-2000,2000,\lin,0,0),
	spread: \unipolar.asSpec,
	lpmix: \unipolar.asSpec,
	pos: \unipolar.asSpec,
))).add;
)

(
Pdef(\sample, 
	Pbind(
		\instrument, \oscsampler3,
		\freq, 700,
		\pos, 0.312,
		\fshift, -148,
		\lpmix, 0.01,
		\hpmix, 0.0,
		\hpfreq, 10,
		\rq, 0.1,
		\posenv, Pseq([
			[ Env([0.004,0.0019,0.4071].integrate.postln,[0.12,8.4]) ],
		],inf),
		\levelScale, 8,
		\timeScale, 1,
		\range, 0.0001,
		\ffreq, 300,
		\freq, 1000,
		\bufnum, BufDef('loop/clean7_135bpm.flac'),
		\ffreqtab, Pseq([[Array.geom(8,4.1,0.8).postln]],inf),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.3,0.5,0.21) ],
		],inf),
		\legato, 4.0,
		\dur, 1/4,
		\isRest, Pseq([
			1,0,0,0,
			0,0,0,0,
		],inf).coin.not,
		\amp, 1 * Pkey(\amp),
	)
).play
)


(
SynthDef(\gregrain, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\gregrain_pan, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	//pan = Pulse.ar([freq,freq+10]).mean;
	pan = Drand([
		//Dwhite(-1.0,1,16).lag(0.1),
		Dbrown(-1.0,1,0.05,16),
		Dbrown(-1.0,1,0.5,16),
		Dbrown(-1.0,1,0.005,16),
	],inf);
	//pan = Dseq([1,0.4,-1,0.1,-0.9],inf);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\gregrain_pan_mad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	//pan = Dseq([1,0.4,-1,0.1,-0.9],inf);
	pan = Dbrown(-1.0,1.0,0.1,inf);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,1,10],1), 2).loop,
			\gdur, 0.1,
			\note, Pseq([
				0,4,2,
			],inf),
			\dur, 1,
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0,5,10]/80,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, 4,
			\legato, 1,
			\dur, 1/2,
			\gain, 1.3,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan_mad,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(10.02,10,inf).stutter(2), 8).loop,
			\gdur, 0.1/8,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, 6,
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, 1/2,
			\gain, 4,
		),
	])
)).play;
);

Pdef(\zedpart).clear;
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan_mad,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/140,1) + Pwhite(1.02,10,inf).stutter(8), 8).loop,
			\pos, 
			Ptuple  (
				 [
					~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(1.02,10,inf).stutter(8), 9).loop,
					~pmodenv.(Pseq([0,5,10]/140,1) + Pwhite(1.02,10,inf).stutter(8), 8).loop,
				]
			),
			\gdur, 0.1/8,
			\note, Pstep(Pseq([
				0,4,2,
			],inf)-
			Pseq([
				[0,12,5],
				[0,12,6],
				[0,12,7],
			],inf)
			,1),
			\octave, Pseq([
				[5,6],
				[6,5],
				[7,4],
				[4,7],
			],inf).stutter(5),
			\legato,  Ptuple(
				Pwhite(0.3,1)!2
			),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1),
			\amp, 0.2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan_mad,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/140,1) + Pwhite(1.02,10,inf).stutter(8), 8).loop,
			\pos, 
			Ptuple  (
				 [
					~pmodenv.(Pseq([0,5,10]/40,1) + Pwhite(1.02,10,inf).stutter(8), 9).loop,
					~pmodenv.(Pseq([0,5,10]/140,1) + Pwhite(1.02,10,inf).stutter(8), 8).loop,
				]
			),
			\gdur, 0.1/18 * Ptuple(
				Pseq([1,4,1/3,Prand([1,Pseq([1/2,10],1)])],inf).stutter(Prand([1,2,5,10],inf))!2
			),
			\note, Pstep(Pseq([
				0,4,2,
			],inf)-
			Pseq([
				[0,12,5],
				[2,12,6],
				[4,12,7],
				[7,10,0],
			],inf).stutter(3)
			,1),
			\octave, Pseq([
				[5,6],
				[6,5],
				[7,4],
				[4,7],
			],inf).stutter(5),
			\legato,  Ptuple(
				Pwhite(0.3,1)!2
			),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1),
			\amp, 0.2,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0,5,10]/180,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				3,0,5,
			],inf),1),
			\octave, 3,
			\legato, 0.9,
			\dur, 1/8,
			\amp, 0.1 * Pseq([1,0.2,0.4,0.2],inf),
		),
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(10.02,10,inf).stutter(2), 8).loop,
			\gdur, 0.1/8,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, 6,
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, 1/2,
			\gain, 4,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \gregrain,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, Ptuple  (
				[
				~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(10.02,10,inf).stutter(2), 8).loop,
				~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(10.02,10,inf).stutter(2), 8).loop,
				]
			),
			\gdur, Ptuple  (
				[
				~pmodenv.(Pseq([10,1,0,2,10]/180,1) , 3).loop,
				~pmodenv.(Pseq([0,5,10]/180,1) , 8).loop,
				]
			),
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, Ptuple(Prand([4,5,6],inf).stutter(Prand([1,2,3,4],inf))!2),
			\pan, [-1,1],
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, 1/2,
			\gain, 4,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \gregrain,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\mbufnum, BufDef.mono('vipere/amenbreak.wav'),
			\pos, Ptuple  (
				[
				~pmodenv.(Pseq([0,5,10]/400,1) + Pwhite(0.02,10,inf).stutter(8), 8).loop,
				~pmodenv.(Pseq([0,5,10]/44,1) + Pwhite(0.02,3,inf).stutter(8), 8).loop,
				]
			),
			\gdur, Ptuple  (
				[
				~pmodenv.(Pseq([10,1,0,2,10]/180,1) , 3).loop,
				~pmodenv.(Pseq([0,5,10]/180,1) , 8).loop,
				]
			),
			\gdur, 0.1,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, Ptuple(Prand([4,5,6],inf).stutter(Prand([1,2,3,4],inf))!2),
			\pan, [-1,1],
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.5) ],
			],inf),
			\dur, 1/2,
		),
	])
)).play;
);
