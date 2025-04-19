
// try to make trap

//////////////////////////////////////////////////////////
////////////// trap var 1

~t = 140/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\kick808, {arg out = 0, freq1 = 240, freq2 = 60, amp = 0.1, ringTime = 100, rel = 10000, dist = 1.5, pan = 0, tott=0.1, durr=0.001, gate=1;
	var snd, env;
	snd = Ringz.ar(
		in: Impulse.ar(0), // single impulse
		freq: XLine.ar(freq1, freq2, \glisdur.kr(0.1)),
		decaytime: ringTime);
	//env = EnvGen.ar(Env.perc(0.001, rel, amp), doneAction: 2);
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	snd = (1.0 - dist) * snd + (dist * (snd.distort));
	snd = snd * env * \gain.kr(0.2);
	snd = Limiter.ar(snd, tott, durr) * 1.5 *(1/tott);
	snd = snd * EnvGen.kr(\adsr2.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:0);
	//snd = Clip.ar(snd, -1 * tott, tott);
	//	snd = Fold.ar(snd, -1 * tott, tott);
	//	snd = Wrap.ar(snd, -1 * tott, tott);
	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
);

(
SynthDef(\kick808, {arg out = 0, freq1 = 240, freq2 = 60, amp = 0.1, ringTime = 100, rel = 10000, dist = 1.5, pan = 0, tott=0.1, durr=0.001, gate=1;
	var snd, env;
	snd = Ringz.ar(
		in: Impulse.ar(0), // single impulse
		freq: freq2,
		decaytime: ringTime) * ( dist+1 );
		//snd = snd.distort;
		snd = snd + LFSaw.ar(freq2);
	snd = Ringz.ar(
		in: snd, // single impulse
		freq: XLine.ar(freq1/4, freq2, \glisdur.kr(0.1)*8),
		decaytime: ringTime);
	//snd = snd + Ringz.ar(
		//in: Impulse.ar(0), // single impulse
		//freq: XLine.ar(freq1, freq2, \glisdur.kr(0.1)) * ( SinOsc.ar(freq1) * XLine.kr(0.0001,1,0.12) + 1 ),
		//decaytime: ringTime);
	//env = EnvGen.ar(Env.perc(0.001, rel, amp), doneAction: 2);
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	snd = (1.0 - dist) * snd + (dist * (snd.distort));
	snd = snd * env * \gain.kr(0.2);
	snd = Limiter.ar(snd, tott, durr) * 1.5 *(1/tott);
	snd = snd * EnvGen.kr(\adsr2.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:0);
	//snd = Clip.ar(snd, -1 * tott, tott);
	//	snd = Fold.ar(snd, -1 * tott, tott);
	//	snd = Wrap.ar(snd, -1 * tott, tott);
	//snd = Pan2.ar(snd, pan, amp);
	snd = Splay.ar(snd, \spread.kr(0.8), amp, pan);
	Out.ar(out, snd );
}).add;
);

(
	// base
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[198].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,1,1,1, 1,0,0,0,
			],inf).coin.not,
			\lag, 0.03, // bounce
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \kick808,
			\note, Pseq([
				Pstep(Pseq([
					10,10,10,8,
				],1),4),
			],inf),
			\octave, 2,
			\freq2, Pkey(\freq),
			\legato, Pseq([
				6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,4,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	// arrange
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\kick1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
		),
		Pdef(\snare1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		),
		Pdef(\clap1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[198].value,
				//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		),
		Pdef(\hat1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,1,1,1, 1,0,0,0,
				],inf).coin.not,
				\lag, 0.03, // bounce
				\dur, 1/16,
				\gain, 0.11,
			),
		),
		Pdef(\bass1, 
			Pbind(
				\instrument, \kick808,
				\note, Pseq([
					Pstep(Pseq([
						10,10,10,8,
					],1),4),
				],inf),
				\octave, 2,
				\freq2, Pkey(\freq),
				\legato, Pseq([
					6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			
					6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,4,0, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
		),
		
	])
)).play;
);

// 4 beat in video = 8 beats in sc

(
Pdef(\part, Pdef(\zedpart, 
	Pseq([
		Pfindur(8,Ppar([
			Pdef(\hat1),
			Pdef(\clap1),
		])),
		Pfindur(8,Ppar([
			Pdef(\hat1),
			Pdef(\clap1),
			Pdef(\snare1),
		])),
		Pfindur(16,Ppar([
			Pdef(\hat1),
			Pdef(\clap1),
			Pdef(\snare1),
			Pdef(\bass1),
		])),
		Pfindur(16,Ppar([
			Pdef(\hat1),
			Pdef(\clap1),
			Pdef(\snare1),
			Pdef(\kick1),
		])),
		Pfindur(16,Ppar([
			Pdef(\hat1),
			Pdef(\clap1),
			Pdef(\snare1),
			Pdef(\bass1),
		])),
		Pfindur(32,Ppar([
			Pdef(\hat1),
			Pdef(\clap1),
			Pdef(\snare1),
			Pdef(\bass1),
			Pdef(\kick1),
		])),
		
	])
)).play;
);


//////////////////////////////////////////////////////////
////////////// trap var 2


(
	// arrange
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\kick1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0, 0,0,1,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
		),
		Pdef(\snare1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		),
		Pdef(\clap1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[198].value,
				//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		),
		Pdef(\hat1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,1,1,1, 1,0,0,0,
				],inf).coin.not,
				\lag, 0.03, // bounce
				\dur, 1/16,
				\gain, 0.11,
			),
		),
		Pdef(\bass1, 
			Pbind(
				\instrument, \kick808,
				\note, Pseq([
					Pstep(Pseq([
						10,10,10,8,
					],1),4),
				],inf),
				\octave, 2,
				\freq2, Pkey(\freq),
				\legato, Pseq([
					6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			
					6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,4,0, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
		),
		
	])
)).play;
);



//////////////////////////////////////////////////////////
////////////// trap var 3

~t = 130/2/60; TempoClock.default.tempo = ~t;

(
	// arrange
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\kick1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
					0,0,0,1, 1,0,0,0, 1,0,0,0, 0,0,0,0,
					//1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
					//0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.2,
				\out, BusDef(\chainside, \audio),
			),
		),
		Pdef(\snare1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		),
		Pdef(\clap1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[198].value,
				//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		),
		Pdef(\hat1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,1,1,1, 1,1,1,1,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,1,1,1, 1,1,1,1,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\lag, 0.01, // bounce
				\dur, 1/16,
				\gain, 0.11,
			),
		),
		Pdef(\hat2, 
			Pbind(
				\instrument, \playersec,
				\speed, -5.midiratio,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,  0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\legato, 2,
				\lag, 0.01, // bounce
				\dur, 1/16,
				\gain, 0.11,
			),
		),
		Pdef(\bass1, 
			Pbind(
				\instrument, \kick808,
				\note, Pseq([
					Pstep(Pseq([
						0,0,0,1,
						1,0,1,1,
						0,0,0,1,
						0,0,1,1,
					],1),1/2),
				],inf),
				\octave, 3,
				\freq2, Pkey(\freq),
				\freq1, Pkey(\freq)*2,
				\freq1, Pseq([
					Pstep(Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,1,2,2,
					],1),1/2)*2 * Pkey(\freq),
				],inf),
				\legato, Pseq([
					6,0,0,0, 0,0,6,0, 0,0,0,0, 6,0,0,0,
					0,0,0,0, 4,0,0,0, 2,0,2, 0,2,0,
				],inf),
				\glisdur, Pseq([
					Pstep(Pseq([
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.1,0.1,
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.2,0.1,
					],1),1/2),
				],inf),
				\dist, 0.5,
				//\ringTime, 18,
				//\durr, 0.01,
				//\lag, -0.01,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, PdurStutter(Pseq([8,8,8,6],inf), 1),
				\out, BusDef(\chainin, \audio),
				\amp, 0.1,
			),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\chainin, \audio),
			\sideinbus, BusDef(\chainside, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\cprelax, 0.1,
			\cpt, 0.005,
			\cpabove, 0.000001,
			\cpclamp, 0.01,
			\gain, 1.5,
			\mix, 1,
			\sidegain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

//////////////////////////////////////////////////////////
////////////// trap var 4

~t = 144/2/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\trapvar4, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/tyanimal.flac'),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,0,
				0,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
				//0,0,4,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\pos, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				//0,0,3.170,0, 3.17,0,0,0, 3.170,0,0,0, 3.17,0,0,0,
			],inf)+0.15,
			//\lag, 0.061,
			\gain, 1,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/tyanimal.flac'),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\speed, Pseq([
				2,-1,-2,-2,
			],inf).stutter(8).midiratio,
			\legato, 4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\pos, Pseq([
				12.17,
				15.23,
				15.23,
				12.17,
			],inf).stutter(8),
			//\lag, 0.061,
			\dur, 1/8,
			\gain, 0.7,
			\out, BusDef(\reverb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\reverb, \audio),
			\addAction, \addToTail,
			\room, 0.71,
			\mix, 0.61,
			\damp, 1,
			\lag, 0.0009,
			\dur, 1,
		),
		Pdef(\kick1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
					//1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
					//0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.2,
				\out, BusDef(\chainside, \audio),
			),
		),
		Pdef(\snare1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		),
		Pdef(\clap1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[198].value,
				//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0, 0,0,1,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
					0,0,1,0, 1,0,0,0, 1,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		),
		Pdef(\hat1, 
			Pbind(
				\instrument, \playerpansec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\lag, 0.01, // bounce
				\dur, 1/16,
				\gain, 0.11,
				\pan, Pseg(Pwhite(-1,1),2),
			),
		),
		Pbind(
			\instrument, \playerpansec,
			\bufnum, ~buflib.hat[348].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0, 0,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
			]/2,inf).coin.not,
			\pan, Pseg(Pwhite(-1,1),1/4),
			\dur, 1/16,
			\gain, 0.11,
		),
		Pdef(\bass1, 
			Pbind(
				\instrument, \kick808,
				\note, Pseq([
					Pstep(Pseq([
						2,2,2,2, 2,2,2,2,
						2,2,2,2, 2,2,2,2,

						2,2,2,2, 2,2,2,2,
						Pseq([
							0,2,5,2,10,9,7,5,
						],1)+12,

						2,2,2,2, 2,2,2,2,
						Pseq([
							0,2,5,2,10,9,7,5,
						],1)+12,

						2,2,2,2, 2,2,2,2,
						Pseq([
							0,2,10,9, 5,4,5+12,4+12,
						],1)+12,
					],1),1/4),
				],inf),
				\octave, 2,
				\freq2, Pkey(\freq),
				\freq1, Pkey(\freq)*2,
				\freq1, Pseq([
					Pstep(Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,1.2,1.2,1,
					],1),1/2)*2 * Pkey(\freq),
				],inf),
				\legato, Pseq([
					8,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					8,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					Pseq([ 0,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0, ],1)*2.1,

					8,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					Pseq([ 0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0, ],1)*4.1,

					8,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					Pseq([ 0,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0, ],1)*2.1,
				],inf),
				\glisdur, Pseq([
					Pstep(Pseq([
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.1,0.1,
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.2,0.1,
					],1),1/2),
				],inf),
				\dist, 0.9,
				\ringTime, 100,
				//\durr, 0.01,
				//\lag, -0.01,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, PdurStutter(Pseq([8,8,8,8],inf), 1),
				\out, BusDef(\chainin, \audio),
				\amp, 0.1,
			),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\chainin, \audio),
			\sideinbus, BusDef(\chainside, \audio),
			\addAction, \addToTail,
			//\lag, 0.0009,
			\cprelax, 0.1,
			\cpt, 0.005,
			\cpabove, 0.000001,
			\cpclamp, 0.01,
			\gain, 1.5,
			\mix, 1,
			\sidegain, 1,
			\dur, 1,
		),
		
	])
)).play;
);
////////////// test sidechain


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\kick1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.2,
				\out, BusDef(\chainside, \audio),
			),
		),
		Pdef(\bass1, 
			Pbind(
				\instrument, \kick808,
				\note, Pseq([
					Pstep(Pseq([
						2,2,2,2, 2,2,2,2,
						2,2,2,2, 2,2,2,2,
					],1),1/4),
				],inf),
				\octave, 2,
				\freq2, Pkey(\freq),
				\freq1, Pkey(\freq)*2,
				\freq1, Pseq([
					Pstep(Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
					],1),1/2)*2 * Pkey(\freq),
				],inf),
				\legato, Pseq([
					9,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf),
				\glisdur, Pseq([
					Pstep(Pseq([
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.1,0.1,
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.2,0.1,
					],1),1/2),
				],inf),
				\dist, 0.5,
				//\ringTime, 18,
				//\durr, 0.01,
				//\lag, -0.01,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, PdurStutter(Pseq([8,8,8,8],inf), 1),
				\out, BusDef(\chainin, \audio),
				\amp, 0.1,
			),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\chainin, \audio),
			\sideinbus, BusDef(\chainside, \audio),
			\addAction, \addToTail,
			//\lag, 0.0009,
			\cprelax, 0.04,
			\cpt, 0.05,
			\cpabove, 1.000001,
			\cpclamp, 0.01,
			\gain, 1.5,
			\mix, 1,
			\sidegain, 1,
			\dur, 1,
		),
	])
)).play;
);

/////////////////////:

(
	// experiment
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\kick1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
					0,0,0,1, 1,0,0,0, 1,0,0,0, 0,0,0,0,
					//1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
					//0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.2,
				\out, BusDef(\chainside, \audio),
			),
		),
		Pdef(\snare1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		),
		Pdef(\clap1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[198].value,
				//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		),
		Pdef(\hat1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,1,1,1, 1,1,1,1,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,1,1,1, 1,1,1,1,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\lag, 0.01, // bounce
				\dur, 1/16,
				\gain, 0.11,
			),
		),
		Pdef(\hat2, 
			Pbind(
				\instrument, \playersec,
				\speed, -5.midiratio,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,  0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\legato, 2,
				\lag, 0.01, // bounce
				\dur, 1/16,
				\gain, 0.11,
			),
		),
		Pdef(\bass1, 
			Pbind(
				\instrument, \kick808,
				\note, Pseq([
					Pstep(Pseq([
						0,0,0,1,
						1,0,1,1,
						0,0,0,1,
						0,0,1,1,
					],1),1/2),
				],inf),
				\octave, 2,
				\freq2, Pkey(\freq),
				\freq1, Pkey(\freq)*2,
				\freq1, Pseq([
					Pstep(Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,1,2,2,
					],1),1/2)*2 * Pkey(\freq),
				],inf),
				\legato, Pseq([
					//0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 6,0,0,0,
					0,0,0,0, 4,0,0,0, 2,0,2, 0,2,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 4,0,0,0, 2,0,2, 0,2,0,
				],inf),
				\glisdur, Pseq([
					Pstep(Pseq([
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.1,0.1,
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.1,0.2,
					],1),1/2),
				],inf),
				\dist, 0.5,
				//\ringTime, 18,
				//\durr, 0.01,
				//\lag, -0.01,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, PdurStutter(Pseq([8,8,8,6],inf), 1),
				//\out, BusDef(\chainin, \audio),
				\out, BusDef(\sendbus1, \audio),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.1,0.1) ],
				],inf),
				//\lag, -0.04,
				\amp, 0.1/2,
			),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\chainin, \audio),
			\sideinbus, BusDef(\chainside, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\cprelax, 0.1,
			\cpt, 0.005,
			\cpabove, 0.000001,
			\cpclamp, 0.01,
			\gain, 1.5,
			\mix, 1,
			\sidegain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \kick808,
			\note, 0,
			\octave, 3,
			\dist, 10,
			\legato, 0.1,
			\glisdur, 0.1,
			\freq2, Pkey(\freq),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \testbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 2,
			\legato, 0.5,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);


(
SynthDef(\testbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[212].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);


///////////////// test new bass

(
SynthDef(\bassfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bassfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq) * Env.perc(0.001,0.04).ar(0);
	//sig = 0;
	sig = Impulse.kr(0) + sig;
	//sig = Impulse.kr(0);
	//freq= freq/4;
	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.9) ) + sig;
	
		isig = DelayL.ar(isig, 0.1, 1/freq * ( SinOsc.ar(0.1) * 0.1 + 1 )) + isig;
		//isig = CombL.ar(isig, 0.1, 1/freq, 0.01) + isig;
		//isig= isig * 1.2;
		//isig = DelayL.ar(sig, 0.1, 1/freq);
		//isig = Ringz.ar(isig, freq/2, 0.01) * 0.1;
		//isig = isig.distort;
		isig = Limiter.ar(isig, 1.1, 1/freq);
		//Amplitude.ar(isig).poll;
		isig;
	},0,0);
	//sig = RLPF.ar(sig, ( \lpfr.kr(15.1) * freq ).clip(20,20000), \rq.kr(0.1));
	sig = LPF.ar(sig, ( \lpfr.kr(24.1) * freq ).clip(20,20000).poll);
	//sig = sig * 10;
	//sig = Limiter.ar(sig);
	sig = sig * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bassfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq) * Env.perc(0.001,0.04).ar(0);
	//sig = 0;
	sig = Impulse.kr(0) + sig;
	//sig = Impulse.kr(0);
	//freq= freq/4;
	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.9) ) + sig;
	
		isig = DelayL.ar(isig, 0.1, 1/freq * ( SinOsc.ar(0.1) * 0.9 + 1 )) + isig;
		//isig = CombL.ar(isig, 0.1, 1/freq, 0.01) + isig;
		//isig= isig * 1.2;
		//isig = DelayL.ar(sig, 0.1, 1/freq);
		//isig = Ringz.ar(isig, freq/2, 0.01) * 0.1;
		//isig = isig.distort;
		isig = Limiter.ar(isig, 1.1, 1/freq);
		//Amplitude.ar(isig).poll;
		isig;
	},0,0);
	//sig = RLPF.ar(sig, ( \lpfr.kr(15.1) * freq ).clip(20,20000), \rq.kr(0.1));
	sig = LPF.ar(sig, ( \lpfr.kr(24.1) * freq ).clip(20,20000).poll);
	//sig = sig * 10;
	//sig = Limiter.ar(sig);
	sig = sig * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bassfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq) * Env.perc(0.001,0.04).ar(0);
	//sig = 0;
	sig = Impulse.kr(0) + sig;
	//sig = Impulse.kr(0);
	//freq= freq/4;
	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.9) ) + sig;
	
		isig = DelayL.ar(isig, 0.1, 1/freq/2 * ( SinOsc.ar(freq) * 0.2 + 1 )) + isig;
		//isig = CombL.ar(isig, 0.1, 1/freq, 0.01) + isig;
		//isig= isig * 1.2;
		//isig = DelayL.ar(sig, 0.1, 1/freq);
		//isig = Ringz.ar(isig, freq/2, 0.01) * 0.1;
		isig = isig.distort * 3;
		isig = Limiter.ar(isig, 1.1, 1/freq);
		//Amplitude.ar(isig).poll;
		isig;
	},0,0);
	//sig = RLPF.ar(sig, ( \lpfr.kr(15.1) * freq ).clip(20,20000), \rq.kr(0.1));
	sig = LPF.ar(sig, ( \lpfr.kr(24.1) * freq ).clip(20,20000).poll);
	//sig = sig * 10;
	//sig = Limiter.ar(sig);
	sig = sig * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bassfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq) * Env.perc(0.001,0.04).ar(0);
	//sig = 0;
	sig = Impulse.kr(0) + sig;
	//sig = Impulse.kr(0);
	//freq= freq/4;
	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.9) ) + sig;
	
		isig = DelayL.ar(isig, 0.1, 1/freq/2 * ( SinOsc.ar(freq) * 0.2 + 1 )) + isig;
		//isig = CombL.ar(isig, 0.1, 1/freq, 0.01) + isig;
		//isig= isig * 1.2;
		//isig = DelayL.ar(sig, 0.1, 1/freq);
		isig = Ringz.ar(isig, freq, 0.001) + isig;
		//isig = isig.distort * 3;
		isig = Limiter.ar(isig, 1, 1/freq);
		//Amplitude.ar(isig).poll;
		isig;
	},0,0);
	//sig = RLPF.ar(sig, ( \lpfr.kr(15.1) * freq ).clip(20,20000), \rq.kr(0.1));
	sig = SinOsc.ar(freq).distort + ( sig * 0.2 ); 
	sig = LPF.ar(sig, ( \lpfr.kr(24.1) * freq ).clip(20,20000).poll);
	//sig = sig * 10;
	//sig = Limiter.ar(sig);
	sig = sig * 4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bassfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq) * Env.perc(0.001,0.04).ar(0);
	//sig = 0;
	sig = Impulse.kr(0) + sig;
	//sig = Impulse.kr(0);
	//freq= freq/4;
	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.9) ) + sig;
	
		isig = DelayL.ar(isig, 0.1, 1/freq) + isig;
		isig = DelayL.ar(isig.reverse, 0.1, 1/( freq + [0,1] )) + isig;
		//isig = DelayL.ar(isig, 0.1, 1/freq*2 * ( SinOsc.kr(1) * 0.1 + 1 )) + isig;
		//isig = CombL.ar(isig, 0.1, 1/freq, 0.01) + isig;
		//isig= isig * 1.2;
		//isig = DelayL.ar(sig, 0.1, 1/freq);
		//isig = Ringz.ar(isig, freq/2, 0.0001) + isig;
		//isig = isig.distort + isig;
		//isig = isig / 3;
		isig = Limiter.ar(isig, 1, 1/freq);
		//Amplitude.ar(isig).poll;
		isig;
	},0,0);
		sig = Ringz.ar(sig, freq, 0.1001) + sig * 0.01;
	//sig = RLPF.ar(sig, ( \lpfr.kr(15.1) * freq ).clip(20,20000), \rq.kr(0.1));
	//sig = SinOsc.ar(freq).distort + ( sig * 0.2 ); 
	sig = LPF.ar(sig, ( \lpfr.kr(14.1) * freq ).clip(20,20000).poll);
	//sig = sig * 10;
	//sig = Limiter.ar(sig);
	//sig = sig * 4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\kick1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
					0,0,0,1, 1,0,0,0, 1,0,0,0, 0,0,0,0,
					//1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
					//0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.2,
				\out, BusDef(\chainside, \audio),
				//\isRest, true,
			),
		),
		Pbind(
			\instrument, \default,
				\note, Pseq([
					Pstep(Pseq([
						0,3,7,1,
						1,0,1,1,
						0,0,0,1,
						0,0,1,1,
					],1),1/4),
				],inf),
				\octave, 3,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
			\dur, 1/8,
			\amp, 0.2,
		),
		Pdef(\bass1, 
			Pbind(
				\instrument, \bassfb,
				\note, Pseq([
					Pstep(Pseq([
						0,3,7,1,
						1,0,1,1,
						0,0,0,1,
						0,0,1,1,
					],1),1/2),
				],inf),
				\octave, 3,
				\freq2, Pkey(\freq),
				\freq1, Pkey(\freq)*2,
				\freq1, Pseq([
					Pstep(Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,1,2,2,
					],1),1/2)*2 * Pkey(\freq),
				],inf),
				\legato, Pseq([
					//0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 6,0,0,0,
					0,0,0,0, 4,0,0,0, 2,0,2, 0,2,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 4,0,0,0, 2,0,2, 0,2,0,
				],inf),
				\glisdur, Pseq([
					Pstep(Pseq([
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.1,0.1,
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.1,0.2,
					],1),1/2),
				],inf),
				\dist, 0.5,
				//\ringTime, 18,
				//\durr, 0.01,
				//\lag, -0.01,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, PdurStutter(Pseq([8,8,8,6],inf), 1),
				\out, BusDef(\chainin, \audio),
				//\out, BusDef(\sendbus1, \audio),
				//\lag, -0.04,
				\amp, 0.1,
			),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\chainin, \audio),
			\sideinbus, BusDef(\chainside, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\cprelax, 0.1,
			\cpt, 0.05,
			\cpabove, 0.01,
			\cpclamp, 0.01,
			\gain, 1.5,
			\mix, 1,
			\sidegain, 1,
			\dur, 1,
		),
	])
)).play;
);


////// friction bass


(
// This filters a simple sine wave, producing a chaotic result
x = {
var sig, out;
sig = SinOsc.ar(660);
out = Friction.ar(sig, friction: 5.41322e-5, mass: 8.05501);
Pan2.ar(out, 0, 0.1);
}.scope
)

x.free;

(
// Modulate the parameters by moving the mouse. Left speaker is original (modulated) sine wave, right speaker is filtered.
x = {
var sig, out;
sig = SinOsc.ar((LFPulse.kr(0.5) + LFPulse.kr(0.33)).range(40, 66).lag(0.1));
out = Friction.ar(sig, friction: MouseX.kr(0.00001, 0.03, 1), mass: MouseY.kr(0.2, 10, 1));
[sig, out] * 0.1;
}.scope
)

x.free;

(
// Some Ringz oscillators, each with a _separate_ Friction1, then merged to create a "rusty" klank.
// Note the way the effect changes as the sound dies away.
x = {
var imp, klank, rusty;
imp = Impulse.ar(1, 0, 0.1);
klank = Ringz.ar(imp, [800, 1071, 1153, 1723]);

rusty = Friction.ar(klank, 
friction: 0.00001,
mass: 100.69789);

Pan2.ar(rusty.sum)
}.play(s);
)

x.free;

(
// In this one we can play with the DC offset and the spring stiffness
x = {
var sig, out;
sig = SinOsc.ar(330) + MouseX.kr(0.01, 10, 1);

out = Friction.ar(sig, friction: 5.41322e-5, mass: 8.05501, 
spring: MouseY.kr(0,1));
Pan2.ar(out * 0.1);
}.scope
)

x.free;

(
// Similar, but this time as a filter for a control-rate signal. 
// Converts boring sinusoidal freq undulation into something much more interesting...
x = {
var sig, out;
sig = LFTri.ar(33 * MouseX.kr(1.0, 100, 1));

out = Friction.ar(sig, friction: 5.41322e-5, mass: 8.05501, 
spring: MouseY.kr(0,1));
out = SinOsc.ar(out.range(150,500));
Pan2.ar(out * 0.1);
}.scope
)

x.free;


(
SynthDef(\frictionbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = LFSaw.ar(freq + [0,\deltafreq.kr(0.04),\deltafreq.kr * 0.223]).mean;
	sig1 = sig1 + SinOsc.ar(freq);
	sig = sig1;
	sig = Friction.ar(sig, friction: \friction.kr(0.001), mass: \mass.kr(8), spring: \spring.kr(0), damp:\damp.kr(0));
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = SelectX.ar(\mix.kr(1), [sig1, sig]);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	friction: ControlSpec(0.00001,1,\exp),
	mass: ControlSpec(0.1,21,\lin),
	spring: ControlSpec(0.00001,1,\exp),
	damp: ControlSpec(0.00001,1,\exp),
))).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\frictionbass, 
			Pbind(
				\instrument, \frictionbass,
				\note, Pseq([
					0,2,-1,-4,
					2,3,4,5,6,7,
				],inf),
				\octave, 3,
				\dur, 1/2,
			),
		),
		
	])
)).play;
);

Pdef(\frictionbass).edit
\lophy.asSpec
Param(Pdef(\frictionbass), \string).spec

Spec.add(\lophy, ControlSpec(0.00001,0.1,\exp))


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\frictionbass, 
			Pbind(
				\instrument, \frictionbass,
				\note, Pseq([
					-4,-5
				],inf).stutter(4),
				\octave, 3,
				\legato, Pseq([
					6,0,0,0, 0,0,6,0, 0,0,0,0, 6,0,0,0,
					0,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
			),
		),
		
	])
)).play;
);

Pdef(\frictionbass).asParamGroup.getPbindCompileString.editorInsert
(

	(
	Pdef(\part, Pdef(\zedpart, 
		Ppar([
			Pbind(
				\instrument, \frictionbass,
				\note, Pseq([
					-4,-5
				],inf).stutter(4),
				\octave, 3,
				\legato, Pseq([
					6,0,0,0, 0,0,6,0, 0,0,0,0, 6,0,0,0,
					0,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				'amp', 0.0036730945821855,
				'deltafreq', 0.049770235643321,
				'friction', 0.0001023531021899,
				'mass', 1.05,
				'spring', 0.00029150530628252,
				'damp', 0.49770235643321,
				'adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0),
				'mix', 1.0,
			)
		])
	)).play;
	);

);


///////////////////////////


Param(BusDef(\speedbus, \control), \value).edit


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/chap8.flac'),
			\pos, Pstep(Pseq([
				3.5,2,2,1,
			],inf),1),
			\speed, Pseq([
					-7,-1, -7,-1, -7,-1, -7,-1,
			],inf).midiratio.stutter(4) * 1.039,
			\speed, BusDef(\speedbus, \control).asMap,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0, 0,0,0,0, 12,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1,
		),
		Pdef(\frictionbass, 
			Pbind(
				\instrument, \frictionbass,
				\note, Pseq([
					//-4,-5, -4,-5, -4,-5, -4,-5,
					//-4,-5, -4,-5, -4,-5, -4,-5,
					Pseq([
						0,-5,
					],4),
					Pseq([
						0,-5,
					],4),
					Pseq([
						-6,-4,
					],inf),
				],inf).stutter(4),
				\octave, 3,
				//\spring, ~pmodenv.(Pseq([0,1,0.1,0.7].linexp(0,1,0.0001,0.1),inf), 1/3).loop,
				'deltafreq', 0.049770235643321,
				'friction', 0.0001023531021899,
				'mass', 1.05,
				'spring', 0.00029150530628252,
				'damp', 0.49770235643321,
				\legato, Pseq([
					6,0,0,0, 0,0,6,0, 0,0,0,0, 12,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 4,0,0,0,

					//6,0,0,0, 0,0,6,0, 0,0,0,0, 6,0,0,0,
					//0,0,0,0, 0,0,0,0, 2,0,0,1, 4,0,0,0,
					//6,0,0,0, 0,0,6,0, 0,0,0,0, 6,0,0,0,
					//0,0,0,0, 0,0,0,0, 1,1,1,1, 2,0,2,0,
				],inf),
				\out, BusDef(\chainin, \audio),
				//\out, BusDef(\sendbus5, \audio),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1/4,
				\dur, 1/8,
				\isRest, true,
			),
		),
		Pdef(\kick1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
					0,0,0,1, 1,0,0,0, 1,0,0,0, 0,0,0,0,
					//1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
					//0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.2,
				\out, BusDef(\chainside, \audio),
			),
		),
		Pdef(\snare1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		),
		Pdef(\clap1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[198].value,
				//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		),
		Pdef(\hat1, 
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,1,1,1, 1,1,1,1,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,1,1,1, 1,1,1,1,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\lag, 0.01, // bounce
				\dur, 1/16,
				\gain, 0.11,
			),
		),
		Pdef(\hat2, 
			Pbind(
				\instrument, \playersec,
				\speed, -5.midiratio,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,  0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,  0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\legato, 2,
				\lag, 0.01, // bounce
				\dur, 1/16,
				\gain, 0.11,
			),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\chainin, \audio),
			\sideinbus, BusDef(\chainside, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\cprelax, 0.1,
			\cpt, 0.005,
			\cpabove, 0.000001,
			\cpclamp, 0.01,
			\gain, 1.5,
			\mix, 1,
			\sidegain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

		Pdef(\bass1, 
			Pbind(
				\instrument, \kick808,
				\note, Pseq([
					Pstep(Pseq([
						0,0,0,1,
						1,0,1,1,
						0,0,0,1,
						0,0,1,1,
					],1),1/2),
				],inf),
				\octave, 3,
				\freq2, Pkey(\freq),
				\freq1, Pkey(\freq)*2,
				\freq1, Pseq([
					Pstep(Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,1,2,2,
					],1),1/2)*2 * Pkey(\freq),
				],inf),
				\legato, Pseq([
					6,0,0,0, 0,0,6,0, 0,0,0,0, 6,0,0,0,
					0,0,0,0, 4,0,0,0, 2,0,2, 0,2,0,
				],inf),
				\glisdur, Pseq([
					Pstep(Pseq([
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.1,0.1,
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.2,0.1,
					],1),1/2),
				],inf),
				\dist, 0.5,
				//\ringTime, 18,
				//\durr, 0.01,
				//\lag, -0.01,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, PdurStutter(Pseq([8,8,8,6],inf), 1),
				\out, BusDef(\chainin, \audio),
				\amp, 0.1,
			),
		),


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/chap8.flac'),
			\pos, Pstep(Pseq([3.5],inf),2),
			\speed, Pseq([
				-7,-1, -7,-1, -7,-1, -7,-1,
			],inf).midiratio.stutter(4) * 1.039,
			//\speed, BusDef(\speedbus, \control).asMap,
			\legato, Pseq([
				4,0,0,0, 4,0,0,0, 4,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1,
			\out, BusDef(\pitchdetect, \audio),

		),
		Pbind(
			\instrument, \default,
			// 261.625
			\note, Pseq([
				-7,-1, -7,-1, -7,-1, -7,-1,
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pmono(\pitchDetect,
			\inbus, BusDef(\pitchdetect, \audio),
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),

	])
)).play;
);

(
Pdef(\melo, 
	Pbind(
				\instrument, \frictionbass,
				\octave, 3,
				//\spring, ~pmodenv.(Pseq([0,1,0.1,0.7].linexp(0,1,0.0001,0.1),inf), 1/3).loop,
				'deltafreq', 0.049770235643321,
				'friction', 0.0001023531021899,
				'mass', 1.05,
				'spring', 0.00029150530628252,
				'damp', 0.49770235643321,
				//\out, BusDef(\chainin, \audio),
				//\out, BusDef(\sendbus5, \audio),
				//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1/4,
				\dur, 1/8,
	)
);
);

ProtoDef(\piano).startControl(Pdef(\melo))
Pdef(\melo).stop

    (
        SynthDef("pitchDetect", { |out|
            var in, amp, freq, hasFreq, sound;
			in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
            amp = Amplitude.kr(in, 0.05, 0.05);
            # freq, hasFreq = Pitch.kr(in, ampThreshold: 0.02, median: 7).flop;
            //freq = Lag.kr(freq.cpsmidi.round(1).midicps, 0.05);
			freq.poll(label:"freq");
			hasFreq.poll(label:"hasfreq");
			sound = in;
            Out.ar(out, sound);
        }).add
    )
