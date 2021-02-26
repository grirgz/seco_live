
// very slow and dist with fast bursts

~t = 135/4/60; TempoClock.default.tempo = ~t;


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[939].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2412].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[226].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 1,0,1,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
		]),
		
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-Q7NB-180T", BusDef(\sendbus1));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.59243697478992,
	'gain', 0.73529411764706,
	'fb', 0.0026843796139422,
	'delay', 0.0007776000906038,
	'delay2', 0.00029552092352029,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.35860954820118,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.50815299962112,
	'fbdistmix', 0.97899159663866,
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

);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[939].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2412].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[226].value,
				\isRest, Pseq([
					1,0,0,1, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
				\isRest, true,
			),
		]),
		
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, Pwhite(0.3,0.8),
			\targetSpeed, 2,
			\sampleTempo, 92.10/4/60,
			\speed, Pkey(\targetSpeed) * ~t / Pkey(\sampleTempo),
			\pos, Pseg(Pseq([
				0, 1, 2, 3,
			],inf),2) / Pkey(\sampleTempo),
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1,
			\lag, 0.04 + Pwhite(0,1/4),
		),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[939].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.3,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2412].value,
				\isRest, Pseq([
					0,0,0, 0,0,0,  1,0,0, 0,0,0,
					0,0,0, 0,0,0,  1,0,0, 0,1,0,
				],inf).coin.not,
				\dur, 1/12,
				\gain, 0.61,
				\out, BusDef(\sendbus1, \audio),
			),
		
	]),
	])
)).play;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


(
Pdef(\zed, 
	Pbind(
		\instrument, \playersec,
	)
).play;
);

"  jkj  ".stripWhiteSpace
SynthDesc(\playersec).asParamGroup(()).first.property


(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, Pwhite(0.3,0.8),
			\targetSpeed, 1,
			\sampleTempo, 92.10/4/60,
			\speed, Pkey(\targetSpeed) * ~t / Pkey(\sampleTempo),
			\pos, Pseg(Pseq([
				0, 1, 2, 3,
			],inf),1) / Pkey(\sampleTempo),
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				1,1,1,1, 1,1,1,1,
				0,0,1,1, 1,1,0,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1,
			\lag, 0.08,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[939].value,
				\isRest, Pseq([
					1,0,0,0, 0,1,0,0,
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2412].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[226].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 1,0,1,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
				\isRest, true,
			),
		]),
		
	])
)).play;
);

