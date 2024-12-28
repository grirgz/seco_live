
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
