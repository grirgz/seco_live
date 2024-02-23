
// continue trap
~t = 75/2/60; TempoClock.default.tempo = ~t;
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
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1524].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0, 1,1,1,0, 0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\lag, -0.04,
			\out, BusDef(\mixer1, \audio),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\bassenv, \audio),
			\legato, Pseq([
				4,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,2,0, 0,0,0,0, 0,0,0,0,
			],inf),
			\mix, 1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[257].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				//1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0, 1,0,0,1, 0,0,1,0, 1,0,0,1, 0,0,1,0, 1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 0,0,0,0, 0,0,1,1, 1,1,1,1, 1,0,1,0, 1,0,0,0, 

				1,0,0,1, 0,1,0,1, 0,0,0,0, 0,0,1,1, 0,0,0,0, 1,1,1,0, 1,0,0,0, 1,0,0,1,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 0,0,0,0, 0,0,1,1, 1,1,1,1, 1,0,1,0, 1,0,0,0, 
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[689].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\lag, -0.04,
			\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\snareenv, \audio),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0, 4,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,3.1) ],
			],inf),
			\mix, 1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[1].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,0,1, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \fousplay,
			\note, Pseq([
				0,-1,-2,-2
			],inf) + [0,3,7],
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		
	])
)).play;
);


ProtoDef(\piano).startControl()

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscsmp,
			//\bufnum, TrackDef(\smp).elAt(0,1).source.buffer,
			\bufnum, BufDef.stereo('vipere/tyanimal.flac'),
			\pos, 1/2,
			//\pos, ~pmodenv.(Pseq([0,8,15,4]/1+1,1), 8).loop,
			//\pos, Pseg(Pwhite(0,20.0),8),
			\pos, 12.22,
			\note, Pseq([
				0,4,7,4,
			],inf),
			\levelScale, ~pmodenv.(Pseq([0.01,0.1,0.02],1), 8).loop,
			\posenv, Pseq([
				[ Env([0,0.51,0.1,0.1].integrate,[0.02,1,5.8]) ],
				[ Env([0,0.51,0.1,1.1].integrate,[0.02,1,5.8]) ]
			],inf),
			\octave, 5,
			//\oscrange, ~pmodenv.(Pseq([100,20000],1), 8).loop,
			\oscrange, 160,
			\legato, 1,
			\dur, 4,
			\amp, 0.4,
		),
		
	])
)).play;
);


(
SynthDef(\fousplay, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar( LFNoise1.ar(1/8!8) ) * 0.81 + 1 ));
	sig = sig + SinOsc.ar(freq * 2 * ( SinOsc.ar( LFNoise1.ar(1/8!8) ) * 0.41 + 1 ), mul:0.4);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1524].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0, 1,1,1,0, 0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\lag, -0.04,
			\out, BusDef(\mixer1, \audio),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\bassenv, \audio),
			\legato, Pseq([
				4,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,2,0, 0,0,0,0, 0,0,0,0,
			],inf),
			\mix, 1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[257].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				//1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0, 1,0,0,1, 0,0,1,0, 1,0,0,1, 0,0,1,0, 1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 0,0,0,0, 0,0,1,1, 1,1,1,1, 1,0,1,0, 1,0,0,0, 

				1,0,0,1, 0,1,0,1, 0,0,0,0, 0,0,1,1, 0,0,0,0, 1,1,1,0, 1,0,0,0, 1,0,0,1,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 0,0,0,0, 0,0,1,1, 1,1,1,1, 1,0,1,0, 1,0,0,0, 
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[689].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\lag, -0.04,
			\out, BusDef(\sendbus5, \audio),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\snareenv, \audio),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0, 4,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 4,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\mix, 1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[1].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,0,1, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \fousplay,
			\note, Pseq([
				0,-1,-2,-2
			],inf) + [0,3,7],
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		
	])
)).play;
);

/////////////////////////////

~t = 75/1/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1236].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,

				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[257].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
				],1),
				Pseq([
					1,0,0,0, 1,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 1,1,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
				],1),
				1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,1, 
				1,0,0,0, 1,0,0,0, 1,0,1,1, 1,1,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,0,0, 
				1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,1, 
				1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,1,0, 1,0,0,0, 1,0,0,0, 1,1,1,1, 1,1,1,1, 
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1131].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,0,0, 0,0,1,0,

				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,0,0, 1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\speed, Pseq([
				Pseq([ 0, ],8*7+64),
				Pseq((0..7),1),
				
			],inf).midiratio,
			\dur, 1/8,
			\gain, 0.10,
		),
		Pdef(\bass1, 
			Pbind(
				\instrument, \kick808,
				\note, Pseq([
					Pstep(Pseq([
						Pseq([
							Pseq([
								0
							],8*3),
							Pseq([
								0,4,3,2,3,-3,-1,-2,
							],1)+7,
						],inf)+4,

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
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,1,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,2,0,
					0,0,1,3, 0,0,0,0, 0,0,0,0, 4,0,0,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,1,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 2,0,2,0,
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
				\lag, -0.04,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, PdurStutter(Pseq([8,8,8,8],inf), 1),
				\out, BusDef(\chainin, \audio),
				\out, BusDef(\sendbus1, \audio),
				\amp, 0.1,
			),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[689].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			//\lag, -0.04,
				\lag, -0.04,
				\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[1].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
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

(
Pdef(\part, Pdef(\zedpart, 
	Pbind(
		\out, BusDef(\sendbus1, \audio),
	)<>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1236].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,

				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[257].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
				],1),
				Pseq([
					1,0,0,0, 1,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 1,1,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
				],1),
				1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,1, 
				1,0,0,0, 1,0,0,0, 1,0,1,1, 1,1,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,0,0, 
				1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,1, 
				1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,1,0, 1,0,0,0, 1,0,0,0, 1,1,1,1, 1,1,1,1, 
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1131].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,0,0, 0,0,1,0,

				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,0,0, 1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\speed, Pseq([
				Pseq([ 0, ],8*7+64),
				Pseq((0..7),1),
				
			],inf).midiratio,
			\dur, 1/8,
			\gain, 0.10,
		),
		Pdef(\bass1, 
			Pbind(
				\instrument, \kick808,
				\note, Pseq([
					Pstep(Pseq([
						Pseq([
							Pseq([
								0
							],8*3),
							Pseq([
								0,4,3,2,3,-3,-1,-2,
							],1)+7,
						],inf)+4,

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
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,1,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,2,0,
					0,0,1,3, 0,0,0,0, 0,0,0,0, 4,0,0,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,1,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 2,0,2,0,
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
				\lag, -0.04,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, PdurStutter(Pseq([8,8,8,8],inf), 1),
				\out, BusDef(\chainin, \audio),
				\out, BusDef(\sendbus1, \audio),
				\amp, 0.1,
				//\isRest, true,
			),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[689].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			//\lag, -0.04,
				\lag, -0.04,
				\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[1].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
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

ProtoDef(\rdn).presetCompileString.editorInsert

(
Pdef(\part, Pdef(\zedpart, 
	Pbind(
		\out, BusDef(\sendbus1, \audio),
	)<>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1236].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,

				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[257].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
				],1),
				Pseq([
					1,0,0,0, 1,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 1,1,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
				],1),
				1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,1, 
				1,0,0,0, 1,0,0,0, 1,0,1,1, 1,1,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,0,0, 
				1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,1, 
				1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,1,0, 1,0,0,0, 1,0,0,0, 1,1,1,1, 1,1,1,1, 
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1131].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,0,0, 0,0,1,0,

				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,0,0, 1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\speed, Pseq([
				Pseq([ 0, ],8*7+64),
				Pseq((0..7),1),
				
			],inf).midiratio,
			\dur, 1/8,
			\gain, 0.10,
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
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[689].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			//\lag, -0.04,
				\lag, -0.04,
				\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[1].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
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


//////////////////////

~t = 75/1/60; TempoClock.default.tempo = ~t;

(
SynthDef(\nosebleed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar( ( SinOsc.ar( (1..8) ) * 1 + 1 ) ) * 1 + 1 ));
	sig = CombL.ar(sig, 4/~t, LFNoise1.kr(1/2).range(0.1,1.0),10/~t) + sig;
	sig = CombL.ar(sig, 4/~t, LFNoise1.kr(1/4).range(0.1,1.0),10/~t) + sig;
	sig = Limiter.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\zed, 
	Pmono(\nosebleed,
		\freq, 200,
		\dur, 1,
		\amp, 0.1,
	),
).play;
);

(
SynthDef(\nosebleed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = XLine.kr(1,1/8/~t,\ramptime.kr(8/~t));
	sig = SinOsc.ar(freq * ( SinOsc.ar( ( SinOsc.ar( (1..8) ) * 1 + 1 ) ) * 1 + 1 ));
	sig = CombL.ar(sig, 4/~t, env1,10/~t) + sig;
	sig = CombL.ar(sig, 4/~t, env1,10/~t) + sig;
	sig = Limiter.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\zed, 
	Pmono(\nosebleed,
		\note, Pseq([
			0,5,9,-4
		],inf),
		\dur, 1,
		\amp, 0.1,
	),
).play;
);


(
Pdef(\part, Pdef(\basedrums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1236].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,

				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[257].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
				],1),
				Pseq([
					1,0,0,0, 1,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 1,1,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
				],1),
				1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,1, 
				1,0,0,0, 1,0,0,0, 1,0,1,1, 1,1,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,0,0, 
				1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,1, 
				1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,1,0, 1,0,0,0, 1,0,0,0, 1,1,1,1, 1,1,1,1, 
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1131].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,0,0, 0,0,1,0,

				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,0,0, 1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\speed, Pseq([
				Pseq([ 0, ],8*7+64),
				Pseq((0..7),1),
				
			],inf).midiratio,
			\dur, 1/8,
			\gain, 0.10,
		),
		Pdef(\bass1, 
			Pbind(
				\instrument, \kick808,
				\note, Pseq([
					Pstep(Pseq([
						Pseq([
							Pseq([
								0
							],8*3),
							Pseq([
								0,4,3,2,3,-3,-1,-2,
							],1)+7,
						],inf)+4,

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
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,1,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,2,0,
					0,0,1,3, 0,0,0,0, 0,0,0,0, 4,0,0,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,1,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 2,0,2,0,
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
				\lag, -0.04,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, PdurStutter(Pseq([8,8,8,8],inf), 1),
				\out, BusDef(\chainin, \audio),
				\out, BusDef(\sendbus1, \audio),
				\amp, 0.1,
			),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[689].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			//\lag, -0.04,
				\lag, -0.04,
				\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[1].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
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

(
Pdef(\part, Pdef(\zedpart, 
	Ptpar([
		0, Pmono(\nosebleed,
			\note, Pseq([
				0,5,9,-4
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		8, Ppar([
			Pdef(\basedrums1)
		])
	],1),
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ptpar([
		0, Pbind(
			\instrument, \nosebleed,
			\ramptime, 1/8,
			\rampstart, 1/4,
			\fmfreqfac, 131,
			\fma2, Pseq([
				10,1,1,100,
			],inf),
			\note, Pstep(Pseq([
				0,5,9,-4
			],inf),1),
			\legato, Pseq([
				6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,2,0,
				6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,5,0, 0,0,0,1,
			].rotate(16),inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		4, Ppar([
			Pdef(\basedrums1)
		])
	],1),
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ptpar([
		0, Pbind(
			\instrument, \nosebleed,
			\note, Pstep(Pseq([
				0,12,-12
			],inf), Prand([8,4,16,32],inf)),
			\octave, 7,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,0,0, 0,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,1,0, 1,0,0,1, 0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\legato, 0.1,
			\dur, 1/8,
			\amp, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		0, Pbind(
			\instrument, \nosebleed,
			\ramptime, 1/8,
			\rampend, Pstep(Pseq([
				1/8,1,1/4 
			],inf),Pseq([1,2,7,1],inf)),
			\rampstart, 1/4,
			\fmfreqfac, 131,
			\fma2, Pseq([
				10,1,1,100,
			],inf) * Pstep(Pseq([
				1,0.3,1.5,
			],inf),8),
			\note, Pstep(Pseq([
				0,5,9,-4,
			],inf),4),
			\legato, Pseq([
				3,0,0,6, 0,0,0,0, 0,0,6,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0, 0,0,0,0, 0,0,2,0,
				6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,2,0,
				6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,5,0, 0,0,0,1,
			].rotate(8+16),inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		4, Ppar([
			Pdef(\basedrums1)
		])
	],1),
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ptpar([
		0, Pbind(
			\instrument, \nosebleed,
			\ramptime, 1/8,
			\rampend, Pstep(Pseq([
				1/8,1,1/4 
			],inf),Pseq([1,2,7,1],inf)),
			\rampstart, 1/4,
			\fmfreqfac, 131,
			\fma2, Pseq([
				10,1,1,100,
			],inf) * Pstep(Pseq([
				1,0.3,1.5,
			],inf),8),
			\note, Pstep(Pseq([
				0,5,9,-4,
			],inf),4),
			\legato, Pseq([
				3,0,0,6, 0,0,0,0, 0,0,6,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0, 0,0,0,0, 0,0,2,0,
				6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,2,0,
				6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,5,0, 0,0,0,1,
			].rotate(8+16),inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		0, Pbind(
			\instrument, \nosebleed,
			\ramptime, 1/8,
			\rampend, Pstep(Pseq([
				1/8,1/2,1,1/4,1
			],inf),Pseq([1,2,7,1],inf)),
			\rampstart, 1/4,
			\fmfreqfac, 131,
			\fma2, Pseq([
				4,10,1,1,100,
			],inf) * Pstep(Pseq([
				1,0.3,1.5,2.1,0.7
			],inf),8),
			\note, Pstep(Pseq([
				0,5,9,-4,
			],inf),4)+7+12,
			\legato, Pseq([
				0,0,0,6, 0,0,0,0, 0,0,6,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0, 0,0,0,0, 0,0,2,0,
				0,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				0,0,2,0, 0,0,0,0, 0,0,5,0, 0,0,0,1,
			].rotate(16),inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		4, Ppar([
			Pdef(\basedrums1)
		])
	],1),
)).play;
);
(
SynthDef(\nosebleed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = XLine.kr(\rampstart.kr(1),\rampend.kr(1/8/~t),\ramptime.kr(8/~t));
	sig = SinOsc.ar(freq * ( SinOsc.ar( ( SinOsc.ar( (1..8) * \fmfreqfac2.kr(1) ) * \fma2.kr(1) + 1 ) * \fmfreqfac.kr(1) ) * \fma.kr(1) + 1 ));
	sig = CombL.ar(sig, 4/~t, env1,\combdecay.kr(10/~t)) + sig;
	sig = CombL.ar(sig, 4/~t, env1,\combdecay2.kr(10/~t)) + sig;
	sig = Limiter.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\nosepad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = XLine.kr(\rampstart.kr(1),\rampend.kr(1/8/~t),\ramptime.kr(8/~t));
	env2 = XLine.kr(0.1,10,1);
	sig = SinOsc.ar(freq * [ [1,2,1/2] ] * ( SinOsc.ar( ( SinOsc.ar( (1..8) * \fmfreqfac2.kr(1) ) * \fma2.kr(1) + 1 ) * \fmfreqfac.kr(1) ) * \fma.kr(1) + 1 ));
	sig = sig.flop.mean;
	sig.debug("sig");
	sig = CombL.ar(sig, \maxdelay.kr(0.1), env1, \combdecay.kr(10/~t)*env2) + sig;
	sig = AllpassL.ar(sig, \maxdelay.kr, env1, \combdecay2.kr(10/~t)*env2) + sig;
	sig = Limiter.ar(sig,1,0.01);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
)

~t = 75/1/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \nosepad,
			\fma, ~pmodenv.(Pseq([1.4,0.001,10,100],8), 8).loop,
			\fma2, ~pmodenv.(Pseq([10.4,0.001,100],8), 9).loop,
			\note, Pstep(Pseq([
				[0,4,7],
				[0,3,7,10-12]+4,
			],inf),1),
			\octave, 4,
			\fmfreqfac, Pfunc({ arg ev;
				( ev.use { ~freq.value } * 8 );
			}),
			\fmfreqfac2, 1,
			\rampstart, Pfunc({ arg ev;
				( ev.use { 1/~freq.value } * 1 );
			}),
			\rampend, Pfunc({ arg ev;
				ev.use { 1/~freq.value } * 1;
			}),
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \nosepad,
			\fma, ~pmodenv.(Pseq([1.4,0.001,10,100],8), 8).loop,
			\fma2, ~pmodenv.(Pseq([10.4,0.001,100],8), 9).loop,
			\note, Pstep(Pseq([
				[0,4,7],
				[0,3,7,10-12]+4,
			],inf),1),
			\octave, 4,
			\spread, Pbrown(0.1,1,0.1,inf),
			\pan, Pbrown(-1,1,0.1,inf),
			\fmfreqfac, Pfunc({ arg ev;
				( ev.use { ~freq.value }  );
			}) * Pseq([1,2,5,1/3],inf).stutter(8),
			\fmfreqfac2, Pseq([1,2,5,1/3],inf).stutter(9),
			\rampstart, Pfunc({ arg ev;
				( ev.use { 1/~freq.value } * 1 );
			}),
			\rampend, Pfunc({ arg ev;
				ev.use { 1/~freq.value } * 1;
			}),
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
		),
	])
)).play;
);




(
SynthDef(\nosebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = 1/freq * XLine.kr(\delaystartfac.kr(1), \delayendfac.kr(1), \delaytime.kr(8));
	env2 = XLine.kr(\decaystart.kr(0.1),\decayend.kr(10),\decaytime.kr(4));
	env3 = XLine.kr(\fmastart.kr(101),\fmaend.kr(1),\fmatime.kr(0.01));
	sig = SinOsc.ar(freq * [ [1,2,1/2] ] * ( SinOsc.ar( ( SinOsc.ar( (1..8) * \fmfreqfac2.kr(1) ) * \fma2.kr(1) + 1 ) * freq * \fmfreqfac.kr(1) ) * \fma.kr(1) * env3 + 1 ));
	sig = sig.flop.mean;
	sig.debug("sig");
	sig = CombL.ar(sig, \maxdelay.kr(0.1), env1 * \combdelayfac.kr(1), \combdecayfac.kr(10)*env2) + sig;
	sig = AllpassL.ar(sig, \maxdelay.kr, env1 * \combdelayfac2.kr(1), \combdecayfac2.kr(10)*env2) + sig;
	//sig = sig + ( SinOsc.ar(freq) * EnvGen.ar(Env([0,1,0],[0.01,0.08]), 1) );
	//sig =  sig + ( SinOsc.ar(freq * EnvGen.kr(Env([20,12,12],[0.01,0.8]), 1)) * EnvGen.ar(Env([0,1,0],[0.01,0.01]), 1) * 1 );
	sig = sig + ( Decay.ar(Impulse.ar(0), \attdur.kr(0.051)) * LPF.ar(WhiteNoise.ar,freq*\attlpffac.kr(4)) * \attamp.kr(1) );
	//Decay.ar(Impulse.ar(0), 0.3) * WhiteNoise.ar
	sig = sig * \pregain.kr(1);
	sig = Limiter.ar(sig,1,0.01);
	sig = sig * \gain.kr(1) * 1/4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
)

(
	// cool sound
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \nosebass,
			\note, Pseq([
				0,0,-1,-5,
			],inf).stutter(2),
			\octave, 3,
			\fma, Pseg(Pseq([0,1,10],inf),8),
			\fma2, Pseg(Pseq([0,1,10],inf),10),
			\combdelayfac, Pseg(Pseq([0,1,10],inf),12),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\legato, 0.1,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \nosebass,
			\note, Pseq([
				0,0,-1,-5,
			],inf),
			\octave, 3,
			\fma, Pseg(Pseq([0,1,10],inf),8),
			\fma2, Pseg(Pseq([0,1,10],inf),10),
			\delaydecayfac, Pseg(Pseq([0,1,10],inf),12),
			\delaytime, 0.1,
			\delayendfac, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\legato, 0.7,
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
			\instrument, \nosebass,
			\note, Pseq([
				0,0,-1,-5,
			],inf),
			\octave, 3,
			\fma, Pseg(Pseq([0,1,10],inf),8),
			\fma2, Pseg(Pseq([0,1,10],inf),10),
			\delaydecayfac, Pseg(Pseq([0,1,10],inf),12),
			\delaytime, 0.1,
			\delayendfac, 1,
			\delaystartfac, 1.2,
			\attamp, 13,
			\attlpffac, 2,
			\attdur, 0.04,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\legato, 0.7,
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
			\instrument, \nosebass,
			\note, Pseq([
				0,0,-1,-5,
			],inf),
			\octave, 3,
			\fma, Pseg(Pseq([0,1,0.510],inf),8),
			\fma2, Pseg(Pseq([0,1,0.310],inf),10),
			\delaydecayfac, Pseg(Pseq([0,1,10],inf),12),
			\delaytime, 0.1,
			\delayendfac, 1,
			\delaystartfac, 1.2,
			\attamp, 13,
			\attlpffac, 2,
			\attdur, 0.04,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\legato, 0.1,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \nosebass,
			\note, Pstep(Pseq([
				0,0,-1,-5,
			],inf)),
			\octave, 3,
			\fma, Pseg(Pseq([0,1,0.510],inf),8),
			\fma2, Pseg(Pseq([0,1,0.310],inf),10),
			\delaydecayfac, Pseg(Pseq([0,1,10],inf),12),
			\delaytime, 0.1,
			\delayendfac, 1,
			\delaystartfac, 1.2,
			\attamp, 13,
			\attlpffac, 2,
			\attdur, 0.04,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\legato, 0.1,
			\legato, Pseq([
				4,0,0,0, 0,0,4,0, 0,0,0,0, 4,0,0,0,
				0,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,1,0,
				2,0,0,0, 0,0,6,0, 0,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,2,0, 0,0,0,0, 0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
				0,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[257].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
				],1),
				Pseq([
					1,0,0,0, 1,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 1,1,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
				],1),
				1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,1, 
				1,0,0,0, 1,0,0,0, 1,0,1,1, 1,1,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,0,0, 
				1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,1, 
				1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,1,0, 1,0,0,0, 1,0,0,0, 1,1,1,1, 1,1,1,1, 
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1131].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,0,0, 0,0,1,0,

				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,0,0, 1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\speed, Pseq([
				Pseq([ 0, ],8*7+64),
				Pseq((0..7),1),
				
			],inf).midiratio,
			//\lag, 0.05,
			\dur, 1/8,
			\gain, 0.10,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[689].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			//\lag, -0.04,
				//\lag, -0.04,
				//\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[1].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		//Pmono(\fx_sidechain,
			//\inbus, BusDef(\chainin, \audio),
			//\sideinbus, BusDef(\chainside, \audio),
			//\addAction, \addToTail,
			////\lag, 0.0009,
			//\cprelax, 0.1,
			//\cpt, 0.005,
			//\cpabove, 0.000001,
			//\cpclamp, 0.01,
			//\gain, 1.5,
			//\mix, 1,
			//\sidegain, 1,
			//\dur, 1,
		//),
		
	])
)).play;
);

//////////

~t = 75/1/60; TempoClock.default.tempo = ~t;
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = WhiteNoise.ar;
	sig = CombC.ar(sig, 0.1, 1/17000,10);
	sig = sig * 0.1;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1036].value,
			\isRest, Pseq([
				1,0,0, 1,0,0, 1,0,0, 1,0,0,
				1,0,0, 1,0,0, 1,0,0, 1,0,1,
			],inf).coin.not,
			\dur, 1/12*2,
			\gain, 0.1 * Pseq([
				1,0,0, 0.1,0,0, 0.3,0,1, 0.1,0,0.1,
				1,0,0, 0.1,0,0, 0.3,0,1, 0.4,0,0.1,
			],inf),
		),
		Pbind( // sing
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1624].value,
			\isRest, Pseq([
				1,0,0, 1,0,0,  1,0,1, 1,0,1,
				1,0,0, 1,0,1,  1,0,1, 1,0,1,
			],inf).coin.not,
			\dur, 1/12*2,
			\gain, 0.1 * Pseq([
				1,0,0, 1,0,0, 0.2,0,1, 0.2,0,0.2,
				1,0,0, 0.2,0,1, 0.2,0,1, 0.2,0,0.2,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[28].value,
			\isRest, Pseq([
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
			],inf).coin.not,
			\dur, 1/12*2,
			\gain, 0.11,
		),
		
	])
)).play;
);
