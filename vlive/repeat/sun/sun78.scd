
// venjent dnb
(
~t = 183/2/60; TempoClock.default.tempo = ~t;
~pos = (
	danger: 3.56,
	engine2: 4.226,
);
SynthDef(\rise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1;
	sig = LFSaw.ar(freq * [1,1.02], Rand(0,2));
	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0],[0.1,0.8])), 1);
	sig = RLPF.ar(sig, \lpf.kr(100.1) * (env1 * \lpenvamt.kr(3.2) + 1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

/// lib
(
Pdef(\part, Pdef(\drums3, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1041].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
				],3),
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1821].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],6),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 1.82,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/8,
			\gain, 0.06,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[1690].value,
			\bufnum, ~buflib.hat[1821].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\lag, 0.0152,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.4,0.2,
			],inf)/2,
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[885].value,
			\score, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],3),
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\speed, 0.98,
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,1,
				],3),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.05) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2 * Pkey(\score),
		),
	])
)).play;
);

/// main
(
Pdef(\part, Pdef(\part1, 
	Ppar([
		Pdef(\drums3),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/danger.flac'),
			\pos, ~pos.engine2,
			\speed, 1,
			\loop,1,
			\legato, 1,
			\dur, 8,
			\adsr, Pseq([
				[ Env.adsr(0.4,0.1,0.6,0.1) ],
			],inf),
			\gain, 1/6,
		),
		Ptpar([
			6, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('vipere/danger.flac'),
					\pos, 0.0,
					\speed, 0.8,
					\legato, 1,
					\dur, Pn(1,1),
					\gain, 1/8,
				),
				Pbind(
					\instrument, \rise,
					\freq, PmodEnv(Pseq([100,62.midicps],1), 1).loop,
					\rq, 0.8,
					\lpf, 1800/2,
					\lpf, PmodEnv(Pseq([100,1000],1), 1).loop,
					\legato, 1,

					\dur, Pn(1,1),
					\amp, PmodEnv(Pseq([0,0.1/2],1), 1).loop,
				),
			]),
			7, Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('vipere/danger.flac'),
				\pos, ~pos.danger,
				\legato, 1,
				\dur, Pn(1,1),
				\gain, 1/8,
			),
		],inf),
		
	])
)).play;
);

//////////////////////// drafts
(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0.5,0.5, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				1,0,0,0, 0,0,0,1,
				0,1,0,0, 0,0,0,1,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.05) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1090].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\score, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pkey(\score),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drums2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0.5,0.5, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1041].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1821].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 1.82,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/8,
			\gain, 0.06,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[1690].value,
			\bufnum, ~buflib.hat[1821].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
			],inf).coin.not,
			\lag, 0.0152,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.4,0.2,
			],inf)/2,
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[885].value,
			\score, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf),
			\speed, 0.98,
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				1,0,0,0, 0,0,0,1,
				0,1,0,0, 0,0,0,1,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.05) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2 * Pkey(\score),
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\danger, 
	Ppar([
		Pseq([
			Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('vipere/danger.flac'),
					\pos, 0.0,
					\speed, 0.8,
					\legato, 1,
					\dur, Pn(1,1),
					\gain, 1/8,
				),
				Pbind(
					\instrument, \rise,
					\freq, PmodEnv(Pseq([100,62.midicps],1), 1).loop,
					\rq, 0.8,
					\lpf, 1800/2,
					\lpf, PmodEnv(Pseq([100,1000],1), 1).loop,
					\legato, 1,

					\dur, Pn(1,1),
					\amp, PmodEnv(Pseq([0,0.1/2],1), 1).loop,
				),
			]),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('vipere/danger.flac'),
				\pos, ~pos.danger,
				\legato, 1,
				\dur, Pn(1,1),
				\gain, 1/8,
			),
			Pfindur(8*2,Pdef(\part1)),
		],1),
		
	])
)).play;
);

(
);

(
Pdef(\part, Pdef(\part1, 
	Ppar([
		Pdef(\drums3),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/danger.flac'),
			\pos, ~pos.engine2,
			\speed, 1,
			\loop,1,
			\legato, 1,
			\dur, 8,
			\adsr, Pseq([
				[ Env.adsr(0.4,0.1,0.6,0.1) ],
			],inf),
			\gain, 1/6,
			\out, BusDef(\sendbus4, \audio),
		),
		Ptpar([
			6, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('vipere/danger.flac'),
					\pos, 0.0,
					\speed, 0.8,
					\legato, 1,
					\dur, Pn(1,1),
					\gain, 1/8,
				),
				Pbind(
					\instrument, \rise,
					\freq, PmodEnv(Pseq([100,62.midicps],1), 1).loop,
					\rq, 0.8,
					\lpf, 1800/2,
					\lpf, PmodEnv(Pseq([100,1000],1), 1).loop,
					\legato, 1,

					\dur, Pn(1,1),
					\amp, PmodEnv(Pseq([0,0.1/2],1), 1).loop,
				),
			]),
			7, Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('vipere/danger.flac'),
				\pos, ~pos.danger,
				\legato, 1,
				\dur, Pn(1,1),
				\gain, 1/8,
			),
		],inf),
		
	])
)).play;
);

///////////////////////////// play with basic synthdefs

(
SynthDef(\mellowpad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.0012) + 1), Rand(0,2));
	sig = sig + LFSaw.ar(freq * 2 * ((0..9)/9 - 0.5 * \fspread2.kr(0.002) + 1), Rand(0,2), mul:0.5);
	env1 = EnvGen.kr(\lpenv.kr(Env.asr(0.1,1,1.1)), gate);
	sig = RLPF.ar(sig, ( \lpf.kr(120) * ( freq * \kbamt.kr(0) +1 ) * (env1 * \lpenvamt.kr(1.2) + 1)).clip(20,20000), \rq.kr(0.3) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.5,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\brasspad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.022) + 1), Rand(0,2));
	sig = LFSaw.ar(freq * LFNoise1.kr(0.1!10,mul:0.02,add:1),Rand(0,2));
	env1 = EnvGen.kr(\lpenv.kr(Env.perc(0.05,3,curve:-3)), gate);
	sig = RLPF.ar(sig, ( \lpf.kr(820) * ( freq * \kbamt.kr(0) +1 ) * (env1 * \lpenvamt.kr(3.2) + 1)).clip(20,20000), \rq.kr(0.5) );
	sig = sig * EnvGen.kr(\perc.kr(Env.perc(0.18,3,curve:-2)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\flutepad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = LFCub.ar(freq * LFNoise1.kr(0.1!4,mul:0.01,add:1),Rand(0,2));
	env1 = EnvGen.kr(\lpenv.kr(Env.adsr(0.05,5,1.8,3.4,curve:-3)), gate);
	sig = RLPF.ar(sig, ( \lpf.kr(2320) * ( freq * \kbamt.kr(0) +1 ) * (env1 * \lpenvamt.kr(2.2) + 1)).clip(20,20000), \rq.kr(0.3) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.45,5,1.2,0.8,0.8,curve:-3)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\stringpad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.022) + 1), Rand(0,2));
	sig4 = LFSaw.ar(freq * LFNoise1.kr(0.1!4,mul:0.01,add:1),Rand(0,2));

	sig = LFSaw.ar(freq,0);
	sig2 = LFSaw.ar(freq * LFNoise1.kr(0.1!4,mul:0.012 * LFTri.kr(0.3,mul:0.3,add:1),add:1),1);
	sig1 = IEnvGen.ar(Env([0,1,-1,0],[0.5,0,0.5],[8,0,-8]), sig.unipolar);
	sig = SelectX.ar( LFTri.kr(0.3).unipolar, [sig1, sig2]);
	sig = LPF.ar(sig, ( freq*6 ).clip(20,20000));

	sig = sig4 + sig;
	//sig = sig;

	//sig = sig + ( LFSaw.ar(freq) * SinOsc.ar(freq*2+0.1) );
	sig = LeakDC.ar(sig);
	env1 = EnvGen.kr(\lpenv.kr(Env.adsr(0.05,5,1.8,3.4,curve:-3)), gate);
	sig = RLPF.ar(sig, ( \lpf.kr(1720) * ( freq * \kbamt.kr(0.1) +1 ) * (env1 * \lpenvamt.kr(2.2) + 1)).clip(20,20000), \rq.kr(0.3) );
	//sig = LPF.ar(sig,4000);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.45,5,1.2,0.8,0.8,curve:-3)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\basspad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.022) + 1), Rand(0,2));
	sig = LFPulse.ar(freq / 2 * LFNoise1.kr(0.1!4,mul:0.001 * Line.kr(1,10,4) ,add:1),Rand(0,2));
	sig = sig + LFSaw.ar(freq  * LFNoise1.kr(0.1!8,mul:0.001,add:1),Rand(0,2),mul:0.5);

	env1 = EnvGen.kr(\lpenv.kr(Env.adsr(0.01,4,0.3,4.4,curve:3)), gate);
	sig = RLPF.ar(sig, ( ( \lpf.kr(1) + ( freq * \kbamt.kr(1.9) ) + 1 ) * (env1 * \lpenvamt.kr(1.2) + 1)).clip(20,20000), \rq.kr(0.3) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.05,5,0.8,0.6,curve:-3)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums3),
		Pbind(
			\instrument, \basspad,
			\note, Pseq([
				2,2,2,-6,
				-2,-2,-3,-6,
			],inf).stutter(2),
			\octave, 4,
			\legato, Pseq([
				6,0,0,0, 0,0,0,1,
				4,0,0,0, 2,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1,
			//\out, BusDef(\sendbus1, \audio),
			//\lag, -0.04,
			\amp, 0.07,
			//\isRest, true,
		),
		Pbind(
			\instrument, \brasspad,
			\note, Pseq([
				[2,-2,-5],
				[2,-3,-6],
			],inf),
			\lpf, PmodEnv(Pseq([200,2400],1), 8*2).loop,
			\perc, Pseq([
				Ptuple(Env.perc(0.04, Pseg(Pseq([0,4],inf),8*2)).asArray).collect({ arg x; [x] }),
			],inf),
			\octave, 5,
			\dur, 2,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \stringpad,
			\note, Pseq([
				2,-2,-5,2,
				2,-3,-6,-3,
			],inf),
			\rq, PmodEnv(Pseq([0.1,1],1), 8*2).loop,
			\legato, Pseg(Pseq([0.1,1],inf),8*2),
			\octave, Pseq([
				5,6,5,5,6,7,
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pseq([
					-2,-5,
				],4),
				Pseq([
					-3,-6,
				],4),
			],inf),
			\lpf, 7800,
			\rq, PmodEnv(Pseq([0.1,1],1), 8*2).loop,
			\legato, Pseg(Pseq([0.1,1],inf),8*2),
			\octave, Pseq([
				7,6,
			],inf).stutter(3),
			\dur, 1/4,
			\amp, 0.12,
		),
		
	])
)).play;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \basspad,
		\amp, 0.05,
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums3),
		Pbind(
			\instrument, \basspad,
			\note, Pseq([
				-3,-3,-3,-3,
				-3,-3,-3,-3,
				-3,-2,-3,-3,
				-3,-3,-2,-3,

				-3,-3,-3,-3,
				-3,-3,-3,-3,
				-3,-2,-3,2,
				-3,-3,-2,-3,
			],inf).stutter(2),
			\octave, 4,
			\legato, Pseq([
				1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.01,0.1,0.1,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
				[ Env.adsr(0.01,0.1,0.1,0.1) ],
			],inf),
			//\out, BusDef(\sendbus1, \audio),
			//\lag, -0.04,
			\amp, 0.05,
			//\isRest, true,
		),
		Pbind(
			\instrument, \brasspad,
			\note, Pseq([
				[2,-2,-5],
				[2,-3,-6],
			],inf),
			\lpf, PmodEnv(Pseq([200,2400],1), 8*2).loop,
			\perc, Pseq([
				Ptuple(Env.perc(0.04, Pseg(Pseq([0.4,4],inf),8*2)).asArray).collect({ arg x; [x] }),
			],inf),
			\octave, 5,
			\dur, 2,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \stringpad,
			\note, Pseq([
				[2,-5],
			],inf),
			\rq, PmodEnv(Pseq([0.1,1],1), 8*2).loop,
			\legato, Pseg(Pseq([0.1,1],inf),8*2),
			\octave, Pseq([
				6,6,6,6,6,6,6,7,
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pseq([
					-2,-5,
				],4),
				Pseq([
					-3,-6,
				],4),
			],inf),
			\lpf, 7800,
			\rq, PmodEnv(Pseq([0.1,1],1), 8*2).loop,
			\legato, Pseg(Pseq([0.1,1],inf),8*2),
			\octave, Pseq([
				7,6,5,
			],inf).stutter(3),
			\dur, 1/4,
			\amp, 0.12,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\decay, 8,
			\delay, 3/2/~t,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);


///////////////////////

(

SynthDef(\rdn_terrorbass, { arg out=0, gate=1;
	// code: 5-AC2A-D7LV
	var si, env = ();
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var code, rdnkey;

	var sig;
	var sigin;
	var del, shi;
	var del2, shi2;
	var distamp;
	var hasFreq, afreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchlag;
	var pitchmix;
	var fb, fb1, fb2;
	var gain;
	var mix;
	var indelay;
	//"default_make_graph".debug("!!!");
	rdnkey = rdnkey ? \default;
	code = code ? "4--";
	sig = in;
	mix = \mix.kr(0.5);
	gain = \gain.kr(1);
	fb = \fb.kr(0.001);
	del = \delay.kr(0.001,0.1);
	del2 = \delay2.kr(0.001,0.1);
	shi = \shift.kr(0);
	shi2 = \shift2.kr(0);
	distamp = \distamp.kr(1);
	pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
	pitchmix = \pitchmix.kr(0);

	sig = LPF.ar(sig, \prelpf.kr(17000));
	sig = HPF.ar(sig, \prehpf.kr(17));

	sig = sig + (LocalIn.ar(2) * fb);

	sig = LPF.ar(sig, \lpf.kr(17000));
	sig = HPF.ar(sig, \hpf.kr(17));
	thisThread.randSeed = 433855.0;
	si = sig;
	sig = { arg si, env;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = [
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = [
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);

				].mean;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			}.value(si, env);
			,
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = [
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);

				].mean;
			}.value(si, env);

		].mean;
	}.value(si, env);


	sig1 = sig.tanh * \fbdistamp.kr(1/2);
	sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

	sig = Limiter.ar(sig);

	sig1 = sig;
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	sig = SelectX.ar(pitchmix, [sig, sig1]);

	LocalOut.ar(sig);
	sig = LPF.ar(sig, \postlpf.kr(17000));
	sig = HPF.ar(sig, \posthpf.kr(17));
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1);

	indelay = \indelay.kr(0);
	sigin = DelayL.ar(in, 0.2, indelay);
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig * gain;
	//sig.debug("end sig");
	sig;


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.52521008403361,
	'gain', 0.43697478991597,
	'fb', 0.0001,
	'delay', 0.55962764453196,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.12605042016807,
	'distamp', 57.610839222447,
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
)

		
);

(
Pdef(\part, Pdef(\part1, 
	Ppar([
		Pdef(\drums3),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, BufDef('vipere/danger.flac'),
			//\pos, ~pos.engine2,
			//\speed, 1,
			//\loop,1,
			//\legato, 1,
			//\dur, 8,
			//\adsr, Pseq([
				//[ Env.adsr(0.4,0.1,0.6,0.1) ],
			//],inf),
			//\gain, 1/6,
		//),
		Pbind(
			\instrument, \saw,
			\note, Pseq([
				-3,
				-3,
				-3,
				[5,4],
			],inf),
			\lpfr, 5,
			\legato, 0.2,
			\octave, 3,
			\strum, 2,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\rdn_terrorbass,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> 
Pbind(
	'wet10', 1.0,
	'mix', 0.52521008403361,
	'gain', 0.43697478991597,
	'fb', 0.0001,
	'delay', 0.55962764453196,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.12605042016807,
	'distamp', 57.610839222447,
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
),
		Ptpar([
			8+6, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('vipere/danger.flac'),
					\pos, 0.0,
					\speed, 0.8,
					\legato, 1,
					\dur, Pn(1,1),
					\gain, 1/8,
				),
				Pbind(
					\instrument, \rise,
					\freq, PmodEnv(Pseq([100,62.midicps],1), 1).loop,
					\rq, 0.8,
					\lpf, 1800/2,
					\lpf, PmodEnv(Pseq([100,1000],1), 1).loop,
					\legato, 1,

					\dur, Pn(1,1),
					\amp, PmodEnv(Pseq([0,0.1/2],1), 1).loop,
				),
			]),
			8+7, Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('vipere/danger.flac'),
				\pos, ~pos.danger,
				\legato, 1,
				\dur, Pn(1,1),
				\gain, 1/8,
			),
		],inf),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([
				0,5,3,-3,
			],inf),
			\lpfr, 5,
			\legato, 0.8,
			\octave, 3,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\rdn_terrorbass,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> 
Pbind(
	'wet10', 1.0,
	'mix', 0.52521008403361,
	'gain', 0.13697478991597,
	'fb', 0.0001,
	'delay', 0.50002764453196,
	'delay2', 0.1001,
	'shift', 0.1,
	'shift2', 0.02605042016807,
	'distamp', 57.610839222447,
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
)
		
	])
)).play;
);

