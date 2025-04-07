
~t = 87/2/60; TempoClock.default.tempo = ~t;
(
SynthDef(\largechord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([0.1,0.32,2.1],[0.7,1.8])), 1);
	freq = freq * [1/4,1/2,1,2,3,4,5,6,7];
	sig = LFSaw.ar(freq *.x [1,1+\diff.kr(0.00001)]);
	sig = sig + SinOsc.ar(freq,mul:\sinamp.kr(0.2));
	sig = RLPF.ar(sig, ( \lpfr.kr(8.1) * env1 * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size); 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1488].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,1,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1689].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,1,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\accent, Pseq([
				0,0,1,0, 0,0,1,0,
			]+1/2,inf),
			\dur, 1/8,
			\gain, 0.11 * Pkey(\accent),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[285].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,1, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1858].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1
			],inf).coin.not,
			\accent, Pseq([
				1,0.7, 1,0.7, 1,0.7, 1,0.7,
				1,0.7, 0.9,1.0, 1,0.7, 1,1,
				1,0.7, 1,0.7, 0.8,0.9, 1,0.7,
				//1,0.4,1,
				//0.4,0.4,1,
			],inf),
			\legato, Pkey(\accent),
			\dur, 1/8/2,
			\gain, 0.11 * Pkey(\accent),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2200].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\mix, 0.5,
			\room, 0.71,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1488].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,1,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1689].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,1,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\accent, Pseq([
				0,0,1,0, 0,0,1,0,
			]+1/2,inf),
			\dur, 1/8,
			\gain, 0.11 * Pkey(\accent),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[285].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,1, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1858].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1
			],inf).coin.not,
			\accent, Pseq([
				1,0.7, 1,0.7, 1,0.7, 1,0.7,
				1,0.7, 0.9,1.0, 1,0.7, 1,1,
				1,0.7, 1,0.7, 0.8,0.9, 1,0.7,
				//1,0.4,1,
				//0.4,0.4,1,
			],inf),
			\legato, Pkey(\accent),
			\dur, 1/8/2,
			\gain, 0.11 * Pkey(\accent),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2200].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\mix, 0.5,
			\room, 0.71,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Funky Donkey (part3).wav'),
			\legato, 0.1,
			\legato, Ppatlace([
					Pseg(Pseq([1,1,0.1],inf),7*3),
					Pseg(Pseq([0.1,1],inf),10*3),
					Pseg(Pseq([1,0.1,1],inf),12),
					Pseg(Pseq([0.1,1],inf),17),
				],inf),
			\att, Pseg(Pseq([0,0.1,0.02],inf),8),
			\rel, Pseg(Pseq([0,2,1],inf),8*3),
			\adsr, Pseq([
				Pfuncn({ arg ev;
					[ Env.adsr(ev[\att],0.1,0.8,ev[\rel]) ]
				}),
			],inf),
			\st, 177/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop / Pkey(\st),
			\pos, Pseq([
				//8,19,16,15,
				//(0..3)+4,
				//16,15,17,18,
				//4,5,0,0
				0,

				//8,19,16,15,
				//(0..3)+4,
				//10,12,0,0,
				//7,5,0,0
			].flat/8,inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8 * Pseq([
				Ppatlace([
					Pseg(Pseq([1,1,0],inf),8*3),
					Pseg(Pseq([0,1],inf),9*3),
					Pseg(Pseq([1,0,1],inf),11),
					Pseg(Pseq([0,1],inf),12),
				],inf)
			],1),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1488].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,1,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1689].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,1,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\accent, Pseq([
				0,0,1,0, 0,0,1,0,
			]+1/2,inf),
			\dur, 1/8,
			\gain, 0.11 * Pkey(\accent),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[285].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,1, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1858].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1
			],inf).coin.not,
			\accent, Pseq([
				1,0.7, 1,0.7, 1,0.7, 1,0.7,
				1,0.7, 0.9,1.0, 1,0.7, 1,1,
				1,0.7, 1,0.7, 0.8,0.9, 1,0.7,
				//1,0.4,1,
				//0.4,0.4,1,
			],inf),
			\legato, Pkey(\accent),
			\dur, 1/8/2,
			\gain, 0.11 * Pkey(\accent),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2200].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\mix, 0.5,
			\room, 0.71,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Funky Donkey (part3).wav'),
			\legato, 0.1,
			\legato, Ppatlace([
					Pseg(Pseq([1,1,0.1],inf),7*3),
					Pseg(Pseq([0.1,1],inf),10*3),
					Pseg(Pseq([1,0.1,1],inf),12),
					Pseg(Pseq([0.1,1],inf),17),
				],inf),
			\att, Pseg(Pseq([0,0.1,0.02],inf),8),
			\rel, Pseg(Pseq([0,2,1],inf),8*3),
			\adsr, Pseq([
				Pfuncn({ arg ev;
					[ Env.adsr(ev[\att],0.1,0.8,ev[\rel]) ]
				}),
			],inf),
			\st, 177/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop / Pkey(\st),
			\pos, Pseq([

				8,19,16,15,
				(0..3)+4,
				16,15,17,18,
				4,5,0,0,

				8,19,16,15,
				(0..3)+4,
				10,12,0,0,
				7,5,0,0,

				8,19,16,15,
				(0..3)+4,
				16,4,17,5,
				4,5,0,0,
			].flat/8,inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8 * Pseq([
				Ppatlace([
					Pseg(Pseq([1,1,0],inf),8*3),
					Pseg(Pseq([0,1],inf),9*3),
					Pseg(Pseq([1,0,1],inf),11),
					Pseg(Pseq([0,1],inf),12),
				],inf)
			],1),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1488].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,1,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1689].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,1,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\accent, Pseq([
				0,0,1,0, 0,0,1,0,
			]+1/2,inf),
			\dur, 1/8,
			\gain, 0.11 * Pkey(\accent),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[285].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,1, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1858].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1
			],inf).coin.not,
			\accent, Pseq([
				1,0.7, 1,0.7, 1,0.7, 1,0.7,
				1,0.7, 0.9,1.0, 1,0.7, 1,1,
				1,0.7, 1,0.7, 0.8,0.9, 1,0.7,
				//1,0.4,1,
				//0.4,0.4,1,
			],inf),
			\legato, Pkey(\accent),
			\dur, 1/8/2,
			\gain, 0.11 * Pkey(\accent),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2200].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\mix, 0.5,
			\room, 0.71,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Funky Donkey (part3).wav'),
			\legato, 0.1,
			\legato, Ppatlace([
					Pseg(Pseq([1,1,0.1],inf),7*3),
					Pseg(Pseq([0.1,1],inf),10*3),
					Pseg(Pseq([1,0.1,1],inf),12),
					Pseg(Pseq([0.1,1],inf),17),
				],inf),
			\att, Pseg(Pseq([0,0.1,0.02],inf),8),
			\rel, Pseg(Pseq([0,2,1],inf),8*3),
			\adsr, Pseq([
				Pfuncn({ arg ev;
					[ Env.adsr(ev[\att],0.1,0.8,ev[\rel]) ]
				}),
			],inf),
			\st, 177/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([

				8,19,16,15,
				(0..3)+4,
				16,15,17,18,
				4,5,0,0,

				8,19,16,15,
				(0..3)+4,
				10,12,0,0,
				7,5,0,0,

				8,19,16,15,
				(0..3)+4,
				16,4,17,5,
				4,5,0,0,
			].flat/8,inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8 * Pseq([
				Ppatlace([
					Pseg(Pseq([1,1,0],inf),8*3),
					Pseg(Pseq([0,1],inf),9*3),
					Pseg(Pseq([1,0,1],inf),11),
					Pseg(Pseq([0,1],inf),12),
				],inf)
			],1),
		),
		Pbind(
			\instrument, \largechord,
			\legato, 0.91,
			\note, Pseq([
				\A, \Gm, \Gm7, \A,\Gm7,
			].chordProg,inf)-3,
			\octave, 5,
			\dur, Pseq([
				1,1/2,1/2,1,1,
				
			],inf),
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,11,10,
			],inf),
			\octave, 2,
			\lpf, PmodEnv(Pseq([400,1200,4000,8000],1), 8).loop,
			\legato, 0.91,
			\dur, Pseq([1.5,1/4,1/4],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([
						-1,0,
					],4*3),
					Pseq([
						4,5
					],4),
				],3),
				Pseq([
					-1,Prand([0,4,5,-1],1),
				],4*3),
				Pseq([
					4,5
				],4),
			],inf),
			//\octave, Pseq([6,6,6,5],inf).stutter(8),
			\lpf, PmodEnv(Pseq([400,1200,4000,8000]*2,1), 4).loop,
			\octave, 6,
			\dur, 1/8/2,
			\amp, 0.1 * Pseq([
				Pwhite(0.5,1,1), Pwhite(0.1,0.9,2),
				Pwhite(0.5,1,1), Pwhite(0.1,0.9,1),
				Pwhite(0.5,1,1), Pwhite(0.1,0.9,2),
			],inf),
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\delay, 1/4/~t,
			//\delay, 0.01,
			\decay, 2,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

