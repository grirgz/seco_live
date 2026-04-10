
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
SynthDef(\lporgan, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq;
	sig = LFPulse.ar(Vibrato.kr(freq, 4*~t) * [1,4]) * [0.1,1];
	sig = sig.mean;
	//sig = Resonz.ar(sig, 1890) + sig;
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\odrums1, 
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

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\odrums1),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,11,10,
			],inf),
			\octave, 2,
			\lpf, PmodEnv(Pseq([400,1200,4000,8000],1), 8,\exp).loop,
			\legato, 0.91,
			\dur, Pseq([1.5,1/4,1/4],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \lporgan,
			\octave, 4,
			\lpf, PmodEnv(Pseq([700,2000,4000],1), 8,\exp).loop,
			\dur, 1/8,
			\legato, Pseg(Pseq([0.3,0.7,0.2,0.5,1],inf),8),
			\amp, 0.1,
			\note, Pseq([
				Pser([
					10,5,3,
				],16*2),
				Pser([
					11,5,3,
				],16*2),
			],inf),
		),
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\odrums1),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,11,10,
			],inf),
			\octave, 2,
			\lpf, PmodEnv(Pseq([400,1200,4000,8000],1), 8,\exp).loop,
			\legato, 0.91,
			\dur, Pseq([1.5,1/4,1/4],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \lporgan,
			\octave, 4,
			\lpf, PmodEnv(Pseq([700,2000,4000],1), 8,\exp).loop,
			\dur, 1/8,
			\legato, Pseg(Pseq([0.3,0.7,0.2,0.5,1],inf),8),
			\legato, 0.3 * Pseq([
				1,1,1,1, 1,3,1,1,
				1,1,3,1, 1,1,1,1,
			],inf) * Ptuple(Pwhite(0.9,1)!3),
			\strum, Pwhite(0.0001,0.01),
			\amp, 0.1,
			\note, Pseq([
				[ 10,5,3, ],
				Pseq([
					Pser([
						[ 10-12,5,3, ].reverse,
						[ 11-12,5,3, ]+12,
					],16*2),
					Pser([
						[ 11-12,5,3, ].reverse,
						[ 11-12,5,3, ]+12,
					],16*2),
				],inf),
			],inf),
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
		),
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\odrums1),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,11,10,
			],inf),
			\octave, 2,
			\lpf, PmodEnv(Pseq([400,1200,4000,8000],1), 8,\exp).loop,
			\legato, 0.91,
			\dur, Pseq([1.5,1/4,1/4],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \lporgan,
			\octave, 4,
			\lpf, PmodEnv(Pseq([700,2000,4000],1), 8,\exp).loop,
			\dur, 1/8,
			\legato, Pseg(Pseq([0.3,0.7,0.2,0.5,1],inf),8),
			\legato, 0.3 * Pseq([
				1,1,1,1, 1,3,1,1,
				1,1,3,1, 1,1,1,1,
			],inf) * Ptuple(Pwhite(0.9,1)!3),
			\strum, Pexprand(0.0001,0.01),
			\amp, 0.1,
			\note, Pseq([
				Pseq([
					Pser([
						[ 10-12,5,3, ].reverse,
						[ 10-12,5,3, ].reverse,
						[ 10-12,5,3, ].reverse,
						[ 11-12,5,3, ]+12,
					],16*2),
					Pser([
						[ 11-12,5,3, ].reverse,
						[ 11-12,5,3, ].reverse,
						[ 11-12,5,3, ].reverse,
						[ 11-12,5,3, ]+12,
					],16*2),
				],inf),
			],inf),
			\isRest, Pseq([
				0,1,1,1, 0,1,1,0,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,1,
				],16),
				Pser([
					-1,0,
				],16),
				//0,-1,
				Pser([
					0,3,
				],16),
				Pser([
					1,3,
				],12),
				Pser([
					5,8,
				],4),
			],inf),
			\lpf, PmodEnv(Pseq([300,200,5002,504],1), 8).loop,
			//\envamt, PmodEnv(Pseq([1,8,4],1), 8).loop,
			\envamt, Pseg(Pseq([8,1],inf),1/5),
			//\legato, 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.2,0.1) ],
				[ Env.adsr(0.01,0.1,0.2,0.1) ],
				[ Env.adsr(0.1,0.1,0.2,0.1) ],
				[ Env.adsr(0.01,0.1,0.2,0.1) ],
				[ Env.adsr(0.01,0.1,0.2,0.1) ],
				[ Env.adsr(0.01,0.1,0.2,0.1) ],
				[ Env.adsr(0.01,0.1,0.2,0.1) ],
				[ Env.adsr(0.1,0.1,0.2,0.1) ],
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sh1, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\sh1, \audio),
			\addAction, \addToTail,
			\hpf, 300,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);


(
// sympa mais pas l'esprit
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \default,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
			\note, Pseq([
				Pser([
					10,5,3,
				],16*2),
				Pser([
					11,5,3,
				],16*2),
				Pser([
					10,6,3,
				],16*2),
				Pser([
					10,7,3,
				],16*2),
				Pser([
					11,7,3,
				],16*2),
				Pser([
					12,7,3,
				],16*2),
				Pser([
					12,8,3,
				],16*2),
			],inf),
		),
	])
)).play;
);
