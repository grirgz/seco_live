
~t = 140/4/60; TempoClock.default.tempo = ~t;// mozanbique
(
~master = {
	ProtoDef(\simpleMixer).play;
	ProtoDef(\FxManager).play;
	//ProtoDef(\rdn).play;
	//ProtoDef(\rdn2).play;
	//ProtoDef(\rdn3).play;
};
~master.();
)


(
SynthDef("kick_808", {arg out = 0, freq1 = 240, freq2 = 60, amp = 1, ringTime = 10, rel = 1, dist = 0.5, pan = 0;
	var snd, env;
	snd = Ringz.ar(
		in: Impulse.ar(0), // single impulse
		freq: XLine.ar(freq1, freq2, 0.1),
		decaytime: ringTime);
	env = EnvGen.ar(Env.perc(0.001, rel, amp), doneAction: 2);
	snd = (1.0 - dist) * snd + (dist * (snd.distort));
	snd = snd * env;
	Out.ar(out, Pan2.ar(snd, pan));
//
//By Bruno Ruviaro
//https://github.com/brunoruviaro/SynthDefs-for-Patterns/blob/master/kick808.scd
}).add;
);
(
SynthDef("kick_808_sus", {arg out = 0, gate=1, freq1 = 240, freq2 = 60, amp = 1, ringTime = 10, rel = 1, dist = 0.5, pan = 0;
	var snd, env;
	var distenv;
	distenv = EnvGen.kr(Env([0,1,0],[0.1,0.8]), 1);
	snd = Ringz.ar(
		in: Impulse.ar(0), // single impulse
		freq: XLine.ar(freq1, freq2, 0.1),
		decaytime: ringTime);
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	dist = dist + distenv;
	snd = (1.0 - dist) * snd + (dist * (snd.distort));
	snd = snd * env;
	Out.ar(out, Pan2.ar(snd, pan));
//
//By Bruno Ruviaro
//https://github.com/brunoruviaro/SynthDefs-for-Patterns/blob/master/kick808.scd
}).add;
);

(
SynthDef("kick_808_sus", {arg out = 0, gate=1, freq1 = 240, freq2 = 60, amp = 1, ringTime = 10, rel = 1, dist = 0.5, pan = 0;
	var snd, env;
	var distenv, ringenv;
	distenv = EnvGen.kr(Env([0,1,0],[0.2,1.8]), 1);
	ringenv = EnvGen.kr(Env([0,1,0],[0.5,0.8]), 1);
	//ringTime = ringTime + ringenv;
	snd = Ringz.ar(
		in: Impulse.ar(0), // single impulse
		freq: XLine.ar(freq1, freq2, 0.1),
		decaytime: ringTime);
	snd = snd + FreqShift.ar(snd, \freqshift.kr(-80.1) * ringenv) /2;
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	dist = dist + distenv;
	snd = (1.0 - dist) * snd + (dist * (snd.distort));
	snd = snd * env;
	snd = snd * amp;
	Out.ar(out, Pan2.ar(snd, pan));
//
//By Bruno Ruviaro
//https://github.com/brunoruviaro/SynthDefs-for-Patterns/blob/master/kick808.scd
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \kick_808,
			\octave, 3,
			\rel, 2,
			\freq2, Pkey(\freq),
			\freq1, Pkey(\freq)*2,
			\note, Pseq([
				0,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			//\isRest, Pseq([
				//1,0,0,0, 0,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.1,
		//),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		PmonoArtic(
			 \kick_808_sus,
			\octave, 3,
			\rel, 2,
			\note, Pseq([
				1,3,
			],inf),
			\ringTime, Pseg(Pseq([0,2,18],inf),8),
			\ringTime, 10,
			\freq2, Pkey(\freq),
			\freq1, Pkey(\freq)*2,
			\legato, Pseq([
				1,1,0.1,0.9, 1,1,1,0.4,
			],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			//\isRest, Pseq([
				//1,0,0,0, 0,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.1,
		//),
		
	])
)).play;
);

(
	// draft 1
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		PmonoArtic(
			 \kick_808_sus,
			\octave, 3,
			\rel, 2,
			\note, Pseq([
				1,1,1,1,
				13,13,1,1,
				1,1,1,1,
				7,7,1,1,
				0,0,0,0,
				0,0,0,0,
				0,0,1,1,
				13,13,1,1,
			],inf),
			\ringTime, Pseg(Pseq([0,2,18],inf),8),
			\ringTime, 10,
			\freq2, Pkey(\freq),
			\freq1, Pkey(\freq)*2,
			\legato, Pseq([
				1,1,1,1, 0,0,1,1,
				0,0,0.51,0.51, 0,0,0,0,
				1,0,1,1, 0,0,0,0,
				0,0,0.51,0.51, 0,1,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				//1,1,0.1,0.9, 1,1,1,0.4,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[376].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			//\lag, 0.04,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[169].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0.8,0.81,0.81, 0,0,0,0,
				0,0,0.1,0.1, 0,0,0.8,0.8,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.23,0.7,0.3
			],inf) * Pwhite(0.6,1,inf),
			\legato, 1 * Pseq([
				1,0.23,0.7,0.3
			],inf) * Pwhite(0.6,1,inf),
			//\lag, 0.04,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pseq([
				0.7,0.7,0.65,
				
			],inf)*1.111,
			\pos, Pseq([
				1,3,
			],inf),
			\legato, 1,
			\legato, Pseq([
				//1,0,0,0, 0,0,0,0,
				//2.5,0,0,1, 0.1,0.1,0,0,
				2.5,0,0,0, 0,0,0.31,0,
				0,0,0.3,0, 0,0,0,0.3,
				2.5,0,0,0, 0,0,3.31,0,
				0,0,1.7,0, 0,0,0,0.9,
				0.5,0,0.3,0, 0,0.3,0,0,
				0,0,0.7,1, 0,0,0,0.9,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, 1/8,
			\gain, 1/8,
		)
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			//\isRest, Pseq([
				//1,0,0,0, 0,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.1,
		//),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		PmonoArtic(
			 \kick_808_sus,
			\octave, 3,
			\rel, 2,
			\note, Pseq([
				1,0,1,0, 0,0,0,0,
			],inf),
			\ringTime, Pseg(Pseq([0,2,18],inf),8),
			\ringTime, 10,
			\freq2, Pkey(\freq),
			\freq1, Pkey(\freq)*2,
			\legato, Pseq([

				1,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,1,0, 0,1,0,0,

				1,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,

				1,0.9,1,0.9, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,1,1,1, 0,1,0,0.91,

				1,0.9,1,0.9, 0,1,1,0.9,
				0,1,1,1, 0,0,0,1,
				0,0,1,1, 0,1,0,0,
				1,1,1,1, 0,1,0,0.91,

				//1,1,0.1,0.9, 1,1,1,0.4,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[376].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			//\lag, 0.04,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[169].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0.2,0,0.2,
				0,0,0,0.2, 0,0,0,0,
				0,0.8,0,0, 0,0,0,0.2,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.23,0.7,0.3
			],inf) * Pwhite(0.6,1,inf),
			\legato, 1 * Pseq([
				1,0.23,0.7,0.3
			],inf) * Pwhite(0.6,1,inf),
			//\lag, 0.04,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pseq([
				Pseq([
					1.7
				],16*3),
				Pseq([
					1.7
				],12),
				Pseq([
					1.7
				],4)/4,
				
			],inf)*1.111,
			\pos, Pseq([
				1,1, 1,1, 1,1, 1,1,
				1,1, 1,1, 1,1, 1,1,
				1,1, 1,1, 1,1, 1,1,
				//1,1, 1,1, 1,1, 1,1,
				//4,4, 4,4, 1,1, 1,1,
				Pseq([
					0.9
				],8),
				Pseq([
					1,1, 1,1, 1,1, 1,1,
					//1,1, 1,1, 1,1, 1,1,
					//4,4, 4,4, 1,1, 1,1,
					Pseq([
						0.9
					],8),
				],2),
			],inf),
			\legato, 1,
			\legato, Pseq([
				//1,0,0,0, 0,0,0,0,
				//2.5,0,0,1, 0.1,0.1,0,0,
				0,0,0,0, 4,0,0,0,
				0,0,0,0.71, 2,0,1,0,
				0,0,0,0, 4,0,0,0,
				0,1,0,0, 0.2,0,2,0,
				0,0,0,0, 3,0,0,0.2,
				0,0,0.3,0, 0.51,0.1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, 1/8,
			\gain, 1/8,
		)
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			//\isRest, Pseq([
				//1,0,0,0, 0,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.1,
		//),
		
	])
)).play;
);

(
	// double kick and clap
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		PmonoArtic(
			 \kick_808_sus,
			\octave, 3,
			\rel, 2,
			\note, Pseq([
				1,0,1,0, 0,0,0,0,
			],inf),
			\ringTime, Pseg(Pseq([0,2,18],inf),8),
			\ringTime, 10,
			\freq2, Pkey(\freq),
			\freq1, Pkey(\freq)*2,
			\legato, Pseq([
				2,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				2,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				2,0,0,0.2, 0,0,0.2,0,
				0,0.2,0,0, 0,0,1,0,

				//1,1,0.1,0.9, 1,1,1,0.4,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.2,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1246].value,
			\legato, Pseq([
				2,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				2,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				2,0,0,0.2, 0,0,0.2,0,
				0,0.2,0,0, 0,0,1,0,

				//1,1,0.1,0.9, 1,1,1,0.4,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[376].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
			//\lag, 0.04,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[329].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				1,1,0,1, 1,0,0,1,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,1,1,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.21,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[169].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0.2,0,0.2,
				0,0,0,0.2, 0,0,0,0,
				0,0.8,0,0, 0,0,0,0.2,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.23,0.7,0.3
			],inf) * Pwhite(0.6,1,inf),
			\legato, 1 * Pseq([
				1,0.23,0.7,0.3
			],inf) * Pwhite(0.6,1,inf),
			//\lag, 0.04,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pseq([
				3,
				
			],inf)*1.111,
			\pos, Pseq([
				1,1, 1,1, 1,1, 1,1,
			],inf),
			\legato, 1,
			\legato, Pseq([
				//1,0,0,0, 0,0,0,0,
				//2.5,0,0,1, 0.1,0.1,0,0,
				1,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, 1/8,
			\gain, 1/8 * Pseg(Pseq([0,0,0,0,1],1),2).loop,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pseq([
				6.5,
			],inf)*1.111,
			\pos, Pseq([
				5.82,
				5.02,
				5.72,
				5.52,
			],inf),
			\legato, 1,
			\legato, Pseq([
				//1,0,0,0, 0,0,0,0,
				//2.5,0,0,1, 0.1,0.1,0,0,
				1,0,1,0, 1,0,1,0, 
				1,0,0,1, 0,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 0,0,1,1,
			],inf)*0.3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer2, \audio),
			\dur, 1/16,
			\gain, 1/8,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pseq([
				Pseq([
					1.7
				],16*3),
				Pseq([
					1.7
				],12),
				Pseq([
					1.7
				],4)/4,
				
			],inf)*1.111,
			\pos, Pseq([
				1,1, 1,1, 1,1, 1,1,
				1,1, 1,1, 1,1, 1,1,
				1,1, 1,1, 1,1, 1,1,
				//1,1, 1,1, 1,1, 1,1,
				//4,4, 4,4, 1,1, 1,1,
				Pseq([
					0.9
				],8),
				Pseq([
					1,1, 1,1, 1,1, 1,1,
					//1,1, 1,1, 1,1, 1,1,
					//4,4, 4,4, 1,1, 1,1,
					Pseq([
						0.9
					],8),
				],2),
			],inf),
			\legato, 1,
			\legato, Pseq([
				//1,0,0,0, 0,0,0,0,
				//2.5,0,0,1, 0.1,0.1,0,0,
				0,0,0,0, 4,0,0,0,
				0,0,0,0.71, 2,0,1,0,
				0,0,0,0, 4,0,0,0,
				0,1,0,0, 0.2,0,2,0,
				0,0,0,0, 3,0,0,0.2,
				0,0,0.3,0, 0.51,0.1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, 1/8,
			\gain, 1/8,
		)
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			//\isRest, Pseq([
				//1,0,0,0, 0,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.1,
		//),
		
	])
)).play;
);

Pdef(\part).clear;
(
	// algo hat and clap
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		PmonoArtic(
			 \kick_808_sus,
			\octave, 3,
			\rel, 2,
			\note, Pseq([
				1,0,1,0, 0,0,0,0,
			],inf),
			\ringTime, Pseg(Pseq([0,2,18],inf),8),
			\ringTime, 10,
			\freq2, Pkey(\freq),
			\freq1, Pkey(\freq)*2,
			\legato, Pseq([
				2,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				2,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				2,0,0,0.2, 0,0,0.2,0,
				0,0.2,0,0, 0,0,1,0,

				//1,1,0.1,0.9, 1,1,1,0.4,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.2,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1246].value,
			\legato, Pseq([
				2,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				2,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				2,0,0,0.2, 0,0,0.2,0,
				0,0.2,0,0, 0,0,1,0,

				//1,1,0.1,0.9, 1,1,1,0.4,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[376].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
			//\lag, 0.04,
			\out, BusDef(\mixer1, \audio),
		),
		Prout({
			var pats = { 
				{
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.clap[329].value,
						\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
						\isRest, Pseq({[
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,1,0, 0,1,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 1,0,0,0,
							1,0,0,1, 0,0,1,0,
							0,0,1,0, 0,1,0,0,
							0,0,0,0, 0,0,1,1,
							1,1,0,1, 1,0,0,1,
							1,0,1,0, 1,0,1,0, 
							1,1,1,1, 1,1,1,1,
						].clump(4).choose}.dup(8).flatten.debug("pats"),inf).coin.not,
						\dur, 1/16,
						\gain, 0.11,
						\out, BusDef(\mixer1, \audio),
						\out, [
							BusDef(\mixer1, \audio),
							//BusDef(\sendbus1, \audio),
							BusDef(\sendbus2, \audio),
							//BusDef(\sendbus3, \audio),
							//BusDef(\sendbus4, \audio),
						].choose,
					)
				}.dup(4) 
			}.dup(4);


			Ppar(
				Plazy({ arg ev;
					Pfindur([1,2,3,4,6,8].choose, pats.choose.choose.debug("pp"))
				}).repeat(200) ! 4,
			).embedInStream;


		}),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[169].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0.2,0,0.2,
				0,0,0,0.2, 0,0,0,0,
				0,0.8,0,0, 0,0,0,0.2,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.23,0.7,0.3
			],inf) * Pwhite(0.6,1,inf),
			\legato, 1 * Pseq([
				1,0.23,0.7,0.3
			],inf) * Pwhite(0.6,1,inf),
			//\lag, 0.04,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pseq([
				3,
				
			],inf)*1.111,
			\pos, Pseq([
				1,1, 1,1, 1,1, 1,1,
			],inf),
			\legato, 1,
			\legato, Pseq([
				//1,0,0,0, 0,0,0,0,
				//2.5,0,0,1, 0.1,0.1,0,0,
				1,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, 1/8,
			\gain, 1/8 * Pseg(Pseq([0,0,0,0,1],1),2).loop,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pseq([
				6.5,
			],inf)*1.111,
			\pos, Pseq([
				5.82,
				5.02,
				5.72,
				5.52,
			],inf),
			\legato, 1,
			\legato, Pseq([
				//1,0,0,0, 0,0,0,0,
				//2.5,0,0,1, 0.1,0.1,0,0,
				1,0,1,0, 1,0,1,0, 
				1,0,0,1, 0,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 0,0,1,1,
			],inf)*0.3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer2, \audio),
			\dur, 1/16,
			\gain, 1/8,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pseq([
				Pseq([
					1.7
				],16*3),
				Pseq([
					1.7
				],12),
				Pseq([
					1.7
				],4)/4,
				
			],inf)*1.111,
			\pos, Pseq([
				1,1, 1,1, 1,1, 1,1,
				1,1, 1,1, 1,1, 1,1,
				1,1, 1,1, 1,1, 1,1,
				//1,1, 1,1, 1,1, 1,1,
				//4,4, 4,4, 1,1, 1,1,
				Pseq([
					0.9
				],8),
				Pseq([
					1,1, 1,1, 1,1, 1,1,
					//1,1, 1,1, 1,1, 1,1,
					//4,4, 4,4, 1,1, 1,1,
					Pseq([
						0.9
					],8),
				],2),
			],inf),
			\legato, 1,
			\legato, Pseq([
				//1,0,0,0, 0,0,0,0,
				//2.5,0,0,1, 0.1,0.1,0,0,
				0,0,0,0, 4,0,0,0,
				0,0,0,0.71, 2,0,1,0,
				0,0,0,0, 4,0,0,0,
				0,1,0,0, 0.2,0,2,0,
				0,0,0,0, 3,0,0,0.2,
				0,0,0.3,0, 0.51,0.1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, 1/8,
			\gain, 1/8,
		)
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			//\isRest, Pseq([
				//1,0,0,0, 0,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.1,
		//),
		
	])
)).play;
);

(
	// algo hat and clap
	// with bath.flac
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		PmonoArtic(
			 \kick_808_sus,
			\octave, 3,
			\rel, 2,
			\note, Pseq([
				1,0,1,0, 0,0,0,0,
			],inf),
			\ringTime, Pseg(Pseq([0,2,18],inf),8),
			\ringTime, 10,
			\freq2, Pkey(\freq),
			\freq1, Pkey(\freq)*2,
			\legato, Pseq([
				2,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				2,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				2,0,0,0.2, 0,0,0.2,0,
				0,0.2,0,0, 0,0,1,0,

				//1,1,0.1,0.9, 1,1,1,0.4,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.2,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1246].value,
			\legato, Pseq([
				2,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				2,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				2,0,0,0.2, 0,0,0.2,0,
				0,0.2,0,0, 0,0,1,0,

				//1,1,0.1,0.9, 1,1,1,0.4,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[376].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
			//\lag, 0.04,
			\out, BusDef(\mixer1, \audio),
		),
		Prout({
			var pats = { 
				{
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.clap[329].value,
						\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
						\isRest, Pseq({[
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,1,0, 0,1,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 1,0,0,0,
							1,0,0,1, 0,0,1,0,
							0,0,1,0, 0,1,0,0,
							0,0,0,0, 0,0,1,1,
							1,1,0,1, 1,0,0,1,
							1,0,1,0, 1,0,1,0, 
							1,1,1,1, 1,1,1,1,
						].clump(4).choose}.dup(8).flatten.debug("pats"),inf).coin.not,
						\dur, 1/16,
						\gain, 0.11,
						\out, BusDef(\mixer1, \audio),
						\out, [
							BusDef(\mixer1, \audio),
							//BusDef(\sendbus1, \audio),
							BusDef(\sendbus2, \audio),
							//BusDef(\sendbus3, \audio),
							//BusDef(\sendbus4, \audio),
						].choose,
					)
				}.dup(4) 
			}.dup(4);


			Ppar(
				Plazy({ arg ev;
					Pfindur([1,2,3,4,6,8].choose, pats.choose.choose.debug("pp"))
				}).repeat(200) ! 4,
			).embedInStream;


		}),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[169].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0.2,0,0.2,
				0,0,0,0.2, 0,0,0,0,
				0,0.8,0,0, 0,0,0,0.2,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.23,0.7,0.3
			],inf) * Pwhite(0.6,1,inf),
			\legato, 1 * Pseq([
				1,0.23,0.7,0.3
			],inf) * Pwhite(0.6,1,inf),
			//\lag, 0.04,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pseq([
				3,
				
			],inf)*1.111,
			\pos, Pseq([
				1,1, 1,1, 1,1, 1,1,
			],inf),
			\legato, 1,
			\legato, Pseq([
				//1,0,0,0, 0,0,0,0,
				//2.5,0,0,1, 0.1,0.1,0,0,
				1,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, 1/8,
			\gain, 1/8 * Pseg(Pseq([0,0,0,0,1],1),2).loop,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pseq([
				6.5,
			],inf)*1.111,
			\pos, Pseq([
				5.82,
				5.02,
				5.72,
				5.52,
			],inf),
			\legato, 1,
			\legato, Pseq([
				//1,0,0,0, 0,0,0,0,
				//2.5,0,0,1, 0.1,0.1,0,0,
				1,0,1,0, 1,0,1,0, 
				1,0,0,1, 0,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 0,0,1,1,
			],inf)*0.3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer2, \audio),
			\dur, 1/16,
			\gain, 1/8,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			\speed, Pseq([
				Pseq([
					1.7
				],16*3),
				Pseq([
					1.7
				],12),
				Pseq([
					1.7
				],4)/4,
				
			],inf)*1.111,
			\pos, Pseq([
				1,1, 1,1, 1,1, 1,1,
				1,1, 1,1, 1,1, 1,1,
				1,1, 1,1, 1,1, 1,1,
				//1,1, 1,1, 1,1, 1,1,
				//4,4, 4,4, 1,1, 1,1,
				Pseq([
					0.9
				],8),
				Pseq([
					1,1, 1,1, 1,1, 1,1,
					//1,1, 1,1, 1,1, 1,1,
					//4,4, 4,4, 1,1, 1,1,
					Pseq([
						0.9
					],8),
				],2),
			],inf),
			\legato, 1,
			\legato, Pseq([
				//1,0,0,0, 0,0,0,0,
				//2.5,0,0,1, 0.1,0.1,0,0,
				0,0,0,0, 4,0,0,0,
				0,0,0,0.71, 2,0,1,0,
				0,0,0,0, 4,0,0,0,
				0,1,0,0, 0.2,0,2,0,
				0,0,0,0, 3,0,0,0.2,
				0,0,0.3,0, 0.51,0.1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\mixer4, \audio),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/bath.flac'),
			\dur, 1,
			\pos, Pwhite(0,60.0,inf),
			\gain, 1,
			\out, BusDef(\mixer5, \audio),
		),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			//\isRest, Pseq([
				//1,0,0,0, 0,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.1,
		//),
		
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
	// mouton
ProtoDef('rdn').make('deldefault', 'rdn', "5-OIIO-4LS6", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1,
	'gain', 0.3,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.2297970969047,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.96204032710648,
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
).keep(1));

);



(
ClipTimeline(\mixerRecorder).tracks = ProtoDef(\simpleMixer).tracks.collect({ arg track, idx;
	(
		index: idx,
		recordArmed: true,
		recordBus: track.inbus,
		muted: false,
	)
});
)
(
ClipTimeline(\mixerRecorder).tracks = 
ProtoDef(\simpleMixer).tracks.collect({ arg track, idx;
	(
		index: idx,
		recordArmed: true,
		recordBus: track.recbus,
		muted: false,
	)
}) ++ 
ProtoDef(\fxMixer).tracks.collect({ arg track, idx;
	(
		index: idx,
		recordArmed: true,
		recordBus: track.recbus,
		muted: false,
	)
});
)
ClipTimeline(\mixerRecorder).edit
ClipTimeline(\mixerRecorder).refresh
(
	~delete_blank = { arg timeline;

		var todelete = List.new;
		timeline.eventList.copy.do { arg event, idx;
			event.timeline !? { arg tl; tl.buffer !?  { arg buf;
				buf.loadToFloatArray(action: { arg col;
					if(col.every( _ == 0 )) {
						Log(\Param).debug("event to remove %", event);
						//todelete.add(event);
						timeline.eventList.remove(event);
						Log(\Param).debug("removed event %", event);
					}
				}).debug("bla");
			} }
		};
	};

	~delete_blank.(ClipTimeline(\mixerRecorder));
)
ProtoDef(\simpleMixer).tracks;

ClipTimeline(\mixerRecorder).eventList[2].timeline.buffer

ClipTimeline(\mixerRecorder).eventList[0].timeline !? { _.buffer }

c
ProtoDef(\simpleMixer).tracks[0].proxy.edit

ClipTimeline(\bli).edit

doWithQuant

s.bind { Synth(\default) }
Synth(\default)

~co = Condition.new

~co.hang
~co.test


(
Task({
	"pll".postln;
	~co.wait;
	"end=================".debug;
}).play
)
~co.test = true
~co.test = false
~co.test = { 1+1 == ~bla }
~co.signal
~bla = 2

(
	~delete_blank = { arg timeline;

		var todelete = List.new;
		var count = 0;
		var condition = Condition({ count == 0 });
		fork {
			timeline.eventList.copy.do { arg event, idx;
				event.timeline !? { arg tl; tl.buffer !?  { arg buf;
					buf.loadToFloatArray(action: { arg col;
						if(col.every( _ == 0 )) {
							Log(\Param).debug("event to remove %", event);
							//todelete.add(event);
							//timeline.eventList.remove(event);
							Log(\Param).debug("removed event %", event);
						};
						count = count - 1;
						//condition.test = count == 0;
						condition.signal;
					}).debug("bla");
					count = count + 1;
				} }
			};
			condition.wait;
			timeline.changed(\refresh);
			"finnn".debug;
		}
	};

	~delete_blank.(ClipTimeline(\mixerRecorder));
)

ClipTimeline(\mixerRecorder).changed(\redraw)



BhobChao

{ RLPFD.ar(Mix(LFSaw.ar([120, 180], 0, 0.33)), LinExp.kr(LFCub.kr(0.1, 0.5*pi), -1, 1, 280, 1500), 0.6, 0.5, mul:3).dup }.play


{ Henon2DC.ar(440, 1880, LFNoise2.kr(1, 0.1, 1.3), 0.3).dup }.play
{ Henon2DC.ar(70, 170, LFNoise2.kr(1, 0.1, 1.3), 0.2).dup * 0.2 }.play
{ Gbman2DL.ar(200, 800).dup * 0.2 }.play

// each also has a corresponding trigger
{ Ringz.ar(StandardTrig.ar(10, 20), 2205, 0.02).fold2(0.5).dup }.play

// can be k-rate
{ SinOsc.ar(Latoocarfian2DN.kr(4, 16, mul:220, add:440)).cubed.fold2(0.6).dup }.play

// trig & oscillator
(
{
var trig, sig;
trig=LatoocarfianTrig.kr(4, 12, [1.1, 1.5]);
sig=Latoocarfian2DC.ar(420, 8200, Lag.kr(TRand.kr(0.4, 0.8, trig), 0.1), Lag.kr(TRand.kr(2.0, 3.0, trig), 0.1), d:[1.0, 1.05], mul:Latch.kr(trig, trig));
(sig.cubed * 2).tanh
}.play
)

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////
// ginger bread man equations

(
	WindowDef(\farfalle, {
		var canvas = UserView.new;
		var fx = { arg x; 
			x.debug("x");
			if(x < 1) {
				0.412;
			} {
				(1 - fy.(x-1) + fx.(x-1).abs).debug("int")
			}
		};
		var fy = { arg x;
			if(x < 1) {
				1;
			} {
				fx.(x-1)
			}
		};
		fx.(12).debug("fx");
		fy.(14).debug("fy");
		canvas.drawFunc = {
			Pen.strokeColor = Color.red;
			Pen.fillColor = Color.blue;
			Pen.scale(20,20);
			10.do { arg x;
				10.do { arg y;
					Pen.color = Color.red(fx.(x)%1);
					Pen.fillRect( Rect(x, y, 1,1) );
				}
			};

			//Pen.stroke;
			//Pen.fill;
			//Pen.draw(3);
		};
		canvas.background_(Color.grey);
	}).front;
)

(
	WindowDef(\farfalle, { arg def;
		var canvas = UserView.new;
		var size = 10000;
		var tx = 0!size;
		var ty = 0!size;
		var x0 = rrand(-1.0,1.0);
		var y0 = rrand(-1.0,1.0);
		var scale = 50;
		var translate = scale*4;
		var ginger;
		ginger = {
			[x0,y0].debug("x, y");
			tx = 0!size;
			ty = 0!size;
			x0 = rrand(-1.0,1.0);
			y0 = rrand(-1.0,1.0);
			size.do { arg i;
				if(i <= 0) {
					tx[i] = 1 - y0 + abs(x0);
					ty[i] = x0;
				} {
					tx[i] = 1 - ty[i-1] + abs(tx[i-1]);
					ty[i] = tx[i-1];
				}
			};
		};
		ginger.();
		Tdef(\ginger, {
			loop {
				ginger.();
				defer{  def.windowDo(_.refresh);};
				1.wait;
			}
		}).play;
		canvas.drawFunc = {
			Pen.strokeColor = Color.red;
			Pen.fillColor = Color.blue;
			//Pen.scale(scale,scale);
			Pen.translate(translate,translate);
			size.do { arg i;
				Pen.fillRect( Rect(tx[i]*scale, ty[i]*scale, 1,1) );
			};

			//Pen.stroke;
			//Pen.fill;
			//Pen.draw(3);
		};
		canvas.background_(Color.grey);
	}).front;
)
Tdef(\ginger).clear

(
	// ab coefs
	WindowDef(\farfalle, { arg def;
		var canvas = UserView.new;
		var size = 10000;
		var tx = 0!size;
		var ty = 0!size;
		var x0 = rrand(-1.0,1.0);
		var y0 = rrand(-1.0,1.0);
		var xa = rrand(-1.0,1.0);
		var xb = rrand(-1.0,1.0);
		var scale = 40;
		var translate = 100;
		var ginger;
		var psize = 3;
		ginger = { arg idx=0;
			tx = 0!size;
			ty = 0!size;
			x0 = rrand(-1.0,1.0);
			y0 = rrand(-1.0,1.0);
			xa = idx/500 + 0.3;
			xb = 1;
			xa = 0.079;
			[x0,y0, xa].debug("x, y");
			size.do { arg i;
				if(i <= 0) {
					tx[i] = 1 - ( xa *  y0 )+ (xb * abs(x0));
					ty[i] = x0;
				} {
					tx[i] = 1 - ( xa * ty[i-1] ) + ( xb * abs(tx[i-1]));
					ty[i] = tx[i-1];
				}
			};
		};
		ginger.();
		Tdef(\ginger, {
			1000.do { arg x;
				//ginger.();
				defer{  ginger.(x); def.windowDo(_.refresh);};
				0.1.wait;
			}
		}).play;
		canvas.drawFunc = {
			Pen.strokeColor = Color.red;
			Pen.fillColor = Color.blue;
			//Pen.scale(scale,scale);
			Pen.translate(translate,translate);
			size.do { arg i;
				Pen.fillRect( Rect(tx[i]*scale, ty[i]*scale, psize,psize) );
			};

			//Pen.stroke;
			//Pen.fill;
			//Pen.draw(3);
		};
		canvas.background_(Color.grey);
	}).front;
)

(
	// ab coefs 2D
	WindowDef(\farfalle, { arg def;
		var canvas = UserView.new;
		var size = 200; // numiteration
		var numsamples = 100;
		var tx = 0!size;
		var ty = 0!size;
		var x0 = rrand(-1.0,1.0);
		var y0 = rrand(-1.0,1.0);
		var xa = rrand(-1.0,1.0);
		var xb = rrand(-1.0,1.0);
		var scale = 4*3;
		var translate = 350;
		var ginger;
		var psize = 1;
		ginger = { arg idx=0;
			tx = 20 * rand2(1.0!numsamples!size);
			ty = 20 * rand2(1.0!numsamples!size);
			//tx = 0!size;
			//ty = 0!size;
			x0 = rrand(-1.0,1.0);
			y0 = rrand(-1.0,1.0);
			xa = idx/500 + 0.3;
			xa = 1;
			xb = 0.079;
			[x0,y0, xa].debug("x, y");
			size.do { arg i;
				if(i <= 0) {
					//tx[i] = 1 - ( xa *  y0 )+ (xb * abs(x0));
					//ty[i] = x0;
				} {
					tx[i] = 1 - ( xa * ty[i-1] ) + ( xb * abs(tx[i-1]));
					ty[i] = tx[i-1];
				}
			};
		};
		ginger.();
		Tdef(\ginger, {
			1000.do { arg x;
				//ginger.();
				defer{  ginger.(x); def.windowDo(_.refresh);};
				0.4.wait;
			}
		}).play;
		canvas.drawFunc = {
			Pen.strokeColor = Color.red;
			Pen.fillColor = Color.blue;
			//Pen.scale(scale,scale);
			Pen.translate(translate,translate);
			size.do { arg i;
				//tx[i].debug("txi");
				numsamples.do { arg smpidx;
					Pen.fillColor = Color.blue(smpidx / numsamples);
					Pen.fillRect( Rect(tx[i][smpidx]*scale, ty[i][smpidx]*scale, psize,psize) );
				}
			};

			//Pen.stroke;
			//Pen.fill;
			//Pen.draw(3);
		};
		canvas.background_(Color.grey);
	}).front;
)

(
	// ab coefs 2D fixed init
	WindowDef(\farfalle, { arg def;
		var canvas = UserView.new;
		var size = 70; // numiteration
		var numsamples = 220;
		var tx = 0!size;
		var ty = 0!size;
		var x0 = rrand(-1.0,1.0);
		var y0 = rrand(-1.0,1.0);
		var xa = rrand(-1.0,1.0);
		var xb = rrand(-1.0,1.0);
		var scale = 4*3;
		var translate = 350;
		var ginger;
		var psize = 1;
			var itx = 20 * rand2(1.0!numsamples!size);
			var ity = 20 * rand2(1.0!numsamples!size);
		ginger = { arg idx=0;
			tx = 20 * rand2(1.0!numsamples!size);
			ty = 20 * rand2(1.0!numsamples!size);
			//tx = itx.copy;
			//ty = ity.copy;
			x0 = rrand(-1.0,1.0);
			y0 = rrand(-1.0,1.0);
			xa = idx/500 + 0.3;
			xa = 1.011;
			xb = 0.779;
			[x0,y0, xa].debug("x, y");
			size.do { arg i;
				if(i <= 0) {
					//tx[i] = 1 - ( xa *  y0 )+ (xb * abs(x0));
					//ty[i] = x0;
				} {
					tx[i] = 1 - ( xa * ty[i-1] ) + ( xb * abs(tx[i-1]));
					ty[i] = tx[i-1];
				}
			};
		};
		ginger.();
		Tdef(\ginger, {
			1000.do { arg x;
				//ginger.();
				defer{  ginger.(x); def.windowDo(_.refresh);};
				0.1.wait;
			}
		}).play;
		canvas.drawFunc = {
			Pen.strokeColor = Color.red;
			Pen.fillColor = Color.blue;
			//Pen.scale(scale,scale);
			Pen.translate(translate,translate);
			size.do { arg i;
				//tx[i].debug("txi");
				numsamples.do { arg smpidx;
					Pen.fillColor = Color.blue(smpidx / numsamples);
					Pen.fillRect( Rect(tx[i][smpidx]*scale, ty[i][smpidx]*scale, psize,psize) );
				}
			};

			//Pen.stroke;
			//Pen.fill;
			//Pen.draw(3);
		};
		canvas.background_(Color.grey);
	}).front;
)

(
// gingerbread man map plot
~win = Window.new;
~layout = VLayout(
);
~win.layout = ~layout;
//window.alwaysOnTop = true;
~win.front;
)

(
	WindowDef(\farfalle, { arg def;
	}).front;
)


(
~plotginger = {

	var window = Window.new;
	var layout;
	var canvas = UserView.new;
	var size = 100000;
	var tx = 0!size;
	var ty = 0!size;
	var x0 = rrand(-1.0,1.0)*2;
	var y0 = rrand(-1.0,1.0)*2;
	var scale = 50;
	var translate = scale*4;
	var ginger;

	ginger = {
		[x0,y0].debug("x, y");
		tx = 0!size;
		ty = 0!size;
		x0 = rrand(-1.0,1.0);
		y0 = rrand(-1.0,1.0);
		size.do { arg i;
			if(i <= 0) {
				tx[i] = 1 - y0 + abs(x0);
				ty[i] = x0;
			} {
				tx[i] = 1 - ty[i-1] + abs(tx[i-1]);
				ty[i] = tx[i-1];
			}
		};
	};
	ginger.();

	Tdef(\ginger, {
		loop {
			ginger.();
			defer{  window.refresh;};
			1.wait;
		}
	}).play;

	layout = VLayout(
		canvas.drawFunc = {
			Pen.fillColor = Color.blue;
			Pen.translate(translate,translate);
			size.do { arg i;
				Pen.fillRect( Rect(tx[i]*scale, ty[i]*scale, 1,1) );
			};
		};
		canvas.background_(Color.grey);

	);
	window.layout = layout;
	//window.alwaysOnTop = true;
	window.front;
};
~plotginger.();
)



			(
			Ppar(
				Plazy({ arg ev;
					Pfindur([1,2,3,4,6,8].choose, Pbind().debug("pp"))
				}).repeat(200) ! 4,
			).play;
			)

			(
				Prout({ arg ev;
					Ppar(
						Plazy({ arg ev;
							Pfindur([1,2,3,4,6,8].choose, Pbind().debug("pp"))
						}).repeat(200) ! 4,
					).embedInStream;

				}).play
			)

			(
				Prout({ arg ev;
						Plazy({ arg ev;
							Pfindur([1,2,3,4,6,8].choose, Pbind().debug("pp"))
						}).repeat(200).embedInStream;

				}).play
			)

			(
				Plazy({ arg ev;
						Plazy({ arg ev;
							Pfindur([1,2,3,4,6,8].choose, Pbind().debug("pp"))
						}).repeat(200);

				}).play
			)
