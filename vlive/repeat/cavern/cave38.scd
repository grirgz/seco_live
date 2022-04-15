
~t = 185/4/60; TempoClock.default.tempo = ~t;
(
	// simple
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				0,1,0,1, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08,
		),
		
	])
)).play;
);

(
	// fast + fm
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1261].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1887].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,1,0,0, 1,0,0,1,
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0, 
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \fmmm,
			\freq, 70 * Pseq([1,1.123,2,3,1.234],inf),
			\legato, 1/2,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,0,1, 0,1,0,0,
				0,1,0,0, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	// fast + feyman
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1261].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1887].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
				0,1,0,0, 1,0,0,1,
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0, 
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseg(Pseq([0,1],inf),8) + Pstep(Pseq([0,4],inf),8),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,0,1, 0,1,0,0,
				0,1,0,0, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1,
		)
		
	])
)).play;
);

(
	// break strange
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1261].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseg(Pseq([0,1],inf),8) + Pstep(Pseq([0,4],inf),8)+2,
			\speed, 1.1,
			\legato, 0.1,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,1,0,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseg(Pseq([0,1],inf),8) + Pstep(Pseq([0,4],inf),8),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1,
		)
		
	])
)).play;
);

(
	// break strange + hat
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseg(Pseq([0,1],inf),8) + Pstep(Pseq([0,4],inf),8),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,0,1, 0,1,0,0,
				0,1,0,0, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1,
		)
		
	])
)).play;
);



(
SynthDef(\fmmm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * XLine.kr(20,1,0.01) * ( SinOsc.ar(100 * XLine.kr(20,1,0.01) * ( SinOsc.ar(2) * 1 + 1 )) * 4 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.01,0.4,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\fmmm2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * XLine.kr(\lhi.kr(20),1,\ldur.kr(0.01)) * ( SinOsc.ar(100 * XLine.kr(\lhi.kr,1,\ldur.kr(0.01)) * ( SinOsc.ar(2) * 1 + 1 )) * 4 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.01,0.4,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig.clip2(0.2);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1261].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1887].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,1,0,0, 1,0,0,1,
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0, 
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \fmmm,
			\freq, 70 * Pseq([1,1.123,2,3,1.234],inf),
			\legato, 1/2,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,0,1, 0,1,0,0,
				0,1,0,0, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
SynthDef(\brouille, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num=40;
	sig = SinOsc.ar(rrand(100,500.0!num) * ( SinOsc.ar(rrand(100,500.0!num) * \mod1.kr(1)) * 10* \mod2.kr(1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\brouille2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num=40;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.05,0.8]), 1);
	env2 = 1;
	sig = SinOsc.ar(rrand(100,500.0!num) * env1 * ( SinOsc.ar(rrand(100,500.0!num) * \mod1.kr(1) * env2) * 10* \mod2.kr(1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \brouille,
		\degree, Pseq([0],inf),
		\mod1, Pseq([
			1,1,1,1, 1,1,1,1,
			1,1,1,1, 1,1,1,1,
			1,1,1,1, 1,1,1,1,
			1,1,2,1, 1,3,1,2,
		],inf),
		\mod2, Pseq([
			10,1,2,10, 1,3,10,2,
			10,1,20,1, 1,30,1,2,
		],inf)/4,
		\dur, 1/16,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1261].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \brouille,
			\degree, Pseq([0],inf),
			\mod1, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,2,1, 1,3,1,2,
			],inf),
			\mod2, Pseq([
				4,1,1,1, 4,1,1,1,
				0,0,0,0, 4,1,1,1,
				4,1,4,1, 4,4,4,1,
				0,8,0,0, 8,0,0,0,
			],inf)/4 * Pseq([1,0.1,4],inf).stutter(32) * Pseg(Pseq([1,4],inf),8*4),
			\dur, 1/16,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1261].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \brouille2,
			\degree, Pseq([0],inf),
			\mod1, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,2,1, 1,3,1,2,
			],inf)*1/12,
			\mod2, Pseq([
				4,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf)*1/10 * Pseq([1,0.1,4],inf).stutter(32) * Pseg(Pseq([1,4],inf),8*4),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,1, 
			],inf),
			\lpfr, Pseq([
				4,1,1,4, 1,1,4,1,
				4,1,4,1, 1,4,1,1,
				1,1,1,1, 1,1,1,1,
				1/4,1,4,1, 1,4,1,1,
				4,1,1,4, 1,1,4,1,
				4,1,4,1, 1,4,1,1,
				2,1,1,2, 1,1,2,1,
				1/4,1,4,1, 1,4,1,1,
			],inf)*2,
			\rq, Pseq([
				0.8,0.1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1261].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\bufnum, ~buflib.kick[1261].value,
			\legato, 0.4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.051,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \brouille,
			\degree, Pseq([0],inf),
			\mod1, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,2,1, 1,3,1,2,
			],inf)/10 * Pseq([
				//Pwhite(1,10)
				Pseq([
					1,10,
				],6),
				Pseq([
					1/10,100,
				],4),
			],inf).stutter(Pseq([8,16,8,8,24,8],inf)),
			\mod2, 2 * Pseq([
				1,1,1,1, 1,1,1,1,
				2,2,1,1, 1,1,2,1,
			],inf),
			\legato, Pseq([
				0,0,0,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				4,0,0,0, 1,0,1,0,
				1,0,2,0, 1,0,1,0,
				2,0,0,0, 2,0,1,0,
				1,0,2,0, 1,0,2,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1261].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\bufnum, ~buflib.kick[1261].value,
			\legato, 0.4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.051,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \brouille,
			\degree, Pseq([0],inf),
			\mod1, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,2,1, 1,3,1,2,
			],inf)/10 * Pseq([
				//Pwhite(1,10)
				Pseq([
					1,10,
				],6),
				Pseq([
					1/10,100,
				],4),
			],inf).stutter(Pseq([8,16,8,8,24,8],inf)),
			\mod2, 2 * Pseq([
				1,1,1,1, 1,1,1,1,
				2,2,1,1, 1,1,2,1,
			],inf),
			\legato, Pseq([
				0,0,0,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				4,0,0,0, 1,0,1,0,
				1,0,2,0, 1,0,1,0,
				2,0,0,0, 2,0,1,0,
				1,0,2,0, 1,0,2,0,
			],inf)/4 * Pseq([
				Pseq([
					4,1,
				],1),
			],inf).stutter(Pseq([8,6,16],inf)),
			\spread, Pseq([
				1,0,0.8,
			],inf),
			\pan, Pseq([
				0,0,0,0, 0,0,0,0,
				0,-0.4,0.5,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\lpfr, Pseq([
				1,10,2,
			],inf).stutter(Pseq([1,1,1,3,4,1,1,1,2],inf)) * Pbrown(0.7,1.5,0.1,inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1261].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\bufnum, ~buflib.kick[1261].value,
			\legato, 0.4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.051,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \brouille,
			\degree, Pseq([0],inf),
			\mod1, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,2,1, 1,3,1,2,
			],inf)/10 * Pseq([
				//Pwhite(1,10)
				Pseq([
					1,10,
				],6),
				Pseq([
					1/10,100,
				],4),
			],inf).stutter(Pseq([8,16,8,8,24,8],inf)),
			\mod2, 2 * Pseq([
				1,1,1,1, 1,1,1,1,
				2,2,1,1, 1,1,2,1,
			],inf),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				1,0,2,0, 1,0,2,0,
				8,0,0,0, 0,0,0,0,
				1,0,2,0, 1,1,1,1,
			],inf)/4 * Pseq([
				Pseq([
					4,1,
				],1),
			],inf).stutter(Pseq([8,6,16],inf)),
			\spread, Pseq([
				1,0,0.8,
			],inf),
			\pan, Pseq([
				0,0,0,0, 0,0,0,0,
				0,-0.4,0.5,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\lpfr, Pseq([
				1,10,2,
			],inf).stutter(Pseq([1,1,1,3,4,1,1,1,2],inf)) * Pbrown(0.7,1.5,0.1,inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp, 0.1,
		),
	])
)).play;
);

ProtoDef(\rdn).
(
	ProtoDef(\rdn).proxy.set(\fb, Ndef(\envfollow, {
		var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus1, \audio)), 2); 
		var sig;
		sig = Amplitude.kr(in).pow(\amppow.kr(1)).lagud(\amplagu.kr(0), \amplagd.kr(0)) * \fac.kr(1/2) + \base.kr(0.1);
		sig.poll;
	}));
	ProtoDef(\rdn2).proxy.set(\fb, Ndef(\envfollow2, {
		var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus2, \audio)), 2); 
		var sig;
		sig = Amplitude.kr(in).pow(\amppow.kr(1)).lagud(\amplagu.kr(0), \amplagd.kr(0)) * \fac.kr(1/2) + \base.kr(0.1);
		sig.poll;
	}))
);
)
Ndef(\envfollow).edit
Ndef(\envfollow2).edit

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq).lag(\slag.kr(0)).poll;
	//sig = SinOsc.ar(freq * ( sig * 1 + 1 )) ;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
Ndef(\zed).edit
Ndef(\zed).stop

(
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1261].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1887].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0, 
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \fmmm,
			\freq, 70 * Pseq([1,1.123,2,3,1.234],inf),
			\legato, 1/2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				1,1,1,1, 1,1,1,1,
				1,0,0,1, 0,1,0,0,
				0,1,0,0, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1261].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1887].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \fmmm,
			\freq, 70 * Pseq([1,1.123,2,3,1.234],inf),
			\legato, 1/2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.1,
		),
		
	])
)).play;
);


FileSystemProject.load("libdef/CustomTrackList.scd");
FileSystemProject.load("cavern/cave38/TrackDef_cave38rec.scd");
TrackDef(\cave38rec, TrackTemplateDef(\CustomTrackList))
TrackDef(\cave38rec).edit
TrackDef(\cave38rec).presetCompileStringSavePath = "~/code/sc/seco/vlive/repeat/cavern/cave38/".standardizePath
TrackDef(\cave38rec).loadedFromPath = "~/code/sc/seco/vlive/repeat/cavern/cave38/".standardizePath
TrackDef(\cave38rec).savePresetCompileString
TrackDef(\cave38rec).save
TrackDef(\cave38rec).childAt(0,3).source.keepRecordedFile
TrackDef(\cave38rec).keepSamplesInUse;
TrackDef(\cave38rec).childAt(6,0).presetCompileString;
TrackDef(\cave38rec).childAt(0,3).source.eventList
Pdef(\glassgong_cool).envir.keys.asArray
Pdef(\glassgong_cool).presetCompileString
Pdef(\glassgong_cool).asParamGroup.selectByKey(Pdef(\glassgong_cool).envir.keys)
FileSystemProject.current.resources

~bla = { var bla = 3; }; ~bla.() // return nil



/////////////////
(
	// intro
Pdef(\part, Pdef(\fk_intro, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1261].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,1, 0,0,1,0,
					0,0,1,1, 0,0,0,1,
				],4*4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1887].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[85].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \fmmm,
			\freq, 370 * Pseq([1,1.123,2,3,1.234],inf),
			\legato, 1/2,
			\legato, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0, 
					16,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

				Pseq([
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
					8,0,0,0, 0,0,0,0,
				],inf),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp, 0.1,
		),
		
	])
)).play;
);
(
	// normal + nokick
Pdef(\part, Pdef(\fk_part1, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1261].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					0,0,1,0, 0,1,0,1,
				],4),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4*4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1887].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,

				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,

				0,0,0,0, 0,1,0,1,
				0,1,0,0, 1,0,0,1,
				1,0,1,0, 0,0,0,0,
				0,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[85].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[121].value,
			\isRest, Pseq([
				//Pseq([
					//0,0,0,0, 0,0,0,0,
				//],4*3),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,

				0,0,1,1, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0, 

				0,0,0,0, 1,1,0,1,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,0,0, 0,0,1,1, 
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \fmmm,
			\freq, 170 * Pseq([1,1.123,2,3,1.234],inf) * Pseg(Pseq([1,1/2,2,3,1/3],inf),8),
			\legato, 1/2,
			\isRest, Pseq([
				8,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,

				1,1,1,1, 1,1,1,1,
				1,0,0,1, 0,1,0,0,
				0,1,0,0, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\fk_part2, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1261].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,1,0,1,
				],4),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4*4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1887].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,

				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,

				0,0,0,0, 0,1,0,1,
				0,1,0,0, 1,0,0,1,
				1,0,1,0, 0,0,0,0,
				0,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[85].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[121].value,
			\isRest, Pseq([
				//Pseq([
					//0,0,0,0, 0,0,0,0,
				//],4*3),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,

				0,0,1,1, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0, 

				0,0,0,0, 1,1,0,1,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,0,0, 0,0,1,1, 
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08,
		),
		
	])
)).play;
);

////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmmm2,
			\ldur, 1/38,
			\lhi, 5,
			\freq, 5200,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
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
			\instrument, \playersec,
			\bufnum, SampleTimeline('cave38rec.0.0score').buffer,
			\pos, 80 + Pseq([0,2,4],inf)/~t -0.04,
			\dur, 1/2,
			\legato, 1,
			\legato, Pseq([
				4,0,0,0, 0,0,2,0,
				3,0,0,1, 0,2,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('cave38rec.0.0score').buffer,
			\pos, 51 + Pseq([-1,0,1,2],inf)/~t -0.04,
			\dur, 1,
			\legato, 1,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[85].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);

(
	// kick
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		
	])
)).play;
);

(
	// snare
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);

(
	// hat
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[85].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 1,0,1,0,
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
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('cave38rec.0.2score').buffer,
			\legato, 1,
			\st, 1*~t,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\speed, 1.1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2, 0, 4, 0, 3,
			],1),1).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
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
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('cave38rec.0.2score').buffer,
			\legato, 1,
			\st, 1*~t,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 1
			],1),1).loop / Pkey(\st),
			\legato, Pseq([
				1,0.1,0.1,0.1,
				0.1,0.1,0.1,1,
			],inf),
			\dur, 1/8,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\lag, 0.04,
			\gain, 0.1,
		),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			////\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			//\bufnum, ~buflib.snare[894].value,
			//\isRest, Pseq([
				//0,0,0,0, 1,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.11,
		//),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[121].value,
			\lag, 0.04,
			\isRest, Pseq([
				//Pseq([
					//0,0,0,0, 0,0,0,0,
				//],4*3),
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 1,0.3,0,1,
			]/1.52,inf).coin.not,

			\dur, 1/8,
			\gain, 0.08* Pseq([
				Pwhite(0,1,1),
				Pwhite(0,0.51,1),
				Pwhite(0,0.81,1),
				Pwhite(0,0.41,1),
			],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('cave38rec.0.2score').buffer,
			\legato, 1,
			\st, 1*~t,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 1
			],1),1).loop / Pkey(\st),
			\legato, Pseq([
				1,0.1,0.1,0.1,
				0.1,0.1,0.1,1,
			],inf),
			\dur, 1/8,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\lag, 0.04,
			\gain, 0.1,
		),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			////\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			//\bufnum, ~buflib.snare[894].value,
			//\isRest, Pseq([
				//0,0,0,0, 1,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.11,
		//),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[121].value,
			\lag, 0.04,
			\isRest, Pseq([
				//Pseq([
					//0,0,0,0, 0,0,0,0,
				//],4*3),
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 1,0.3,0,1,
			]/1.52,inf).coin.not,

			\dur, 1/8,
			\gain, 0.08* Pseq([
				Pwhite(0,1,1),
				Pwhite(0,0.51,1),
				Pwhite(0,0.81,1),
				Pwhite(0,0.41,1),
			],inf),
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Pseq([
					12,5,
				],14),
				13,6,
				13,6,
			],inf),
			\octave, [4,5,6],
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

FileSystemProject.load("libdef/controllers.scd")

(
Pdef(\part, Pdef(\glassgong_stut, 
	Ppar([
		
		Pbind(
			\instrument, \playersec, 
			\bufnum, SampleTimeline('cave38rec.4.2score').buffer,
			\legato, Pseq([
				32,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				20,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 12,0,0,0,
				0,0,1,0, 0,0,0,0,
				32,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,1,0, 0,3,0,0,
			],inf),
			\lag, 0.04,
			\dur, 1/8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\glassgong, 
	Ppar([
		
		Pbind(
			\instrument, \playersec, 
			\bufnum, SampleTimeline('cave38rec.4.4score').buffer,
			\pos, Pseq([0,2,8],inf).stutter(16)/~t,
			\legato, Pseq([
				32,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				20,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 12,0,0,0,
				0,0,1,0, 0,0,0,0,
				32,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,1,0, 0,3,0,0,
			],inf),
			\lag, 0.04,
			\dur, 1/8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\fxmixer0, \audio),
			\gain, 1,
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\glassgong_cool, 
	Ppar([
		
		Pbind(
			\instrument, \playersec, 
			\bufnum, Pseq([
				Pseq([
					SampleTimeline('cave38rec.4.2score').buffer,
					SampleTimeline('cave38rec.4.0score').buffer,
					SampleTimeline('cave38rec.4.3score').buffer,
					SampleTimeline('cave38rec.4.1score').buffer,
				],inf),
				SampleTimeline('cave38rec.4.2score').buffer,
				SampleTimeline('cave38rec.4.3score').buffer,
				SampleTimeline('cave38rec.4.4score').buffer,
			],inf),
			\speed, Pseq([
				Pseq([
					0,-1,-2,0,
					0,11,8,10,
				],3),

				10,1,0,-1,
				10,3,2,0,
			],inf).midiratio,
			\pos, Pseq([0],inf).stutter(16)/~t,
			\legato, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,2,0, 0,0,0,0,
					8,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,2,0,
					4,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,

					1,0,0,0, 0,0,0,0,
					6,0,0,0, 0,0,2,0,
					0,0,4,0, 0,0,0,1,
					8,0,0,0, 0,0,0,0,
				],2),

				3,0,0,3, 0,0,2,0,
				2,0,3,0, 0,3,0,0,
				0,0,4,0, 0,0,0,1,
				8,0,0,0, 0,0,0,0,

				2,0,3,0, 0,3,0,0,
				0,0,4,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,2,0,
			],inf),
			\lag, 0.04,
			\dur, 1/8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1 * Pseq([
				Pwhite(0.7,1,1),
				Pwhite(0.2,0.71,1),
			],inf),
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\calm, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1261].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,1, 0,0,1,0,
					0,0,1,1, 0,0,0,1,
				],4*4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato,2,
			\dur, 1/8,
			\gain, 0.11/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1887].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[85].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
	// kick snare lowtempo
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1156].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,1,1,
				0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.1,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
			\gain, 0.11,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\fiddle, 
	Ppar([
		
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Pseq([
					12,5,
				],14),
				13,6,
				13,6,
			],inf),
			\isRest, Pseq([
				1,1,1,0, 1,0,1,1,
				1,1,0,1, 1,1,1,0,
				1,1,1,0, 1,1,1,1,
				1,0,0,1, 1,1,0,1,
				0,0,1,0, 1,1,0,1,
				1,0,0,0, 0,0,1,1,
				1,0,0,1, 1,1,0,0, 
			],inf).coin.not,
			\octave, [4,5,6],
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);


//////////:


(
Ndef(\ambi, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq+1) * LFNoise1.kr(1/17!10).range(0.0,1.0) + 1 ) * [0,3,4,8,9,14,15,19,21,22].midiratio);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig");
}).play;
);
Ndef(\ambi).clear

TrackDef(\tlist, TrackTemplateDef(\CustomTrackList));
TrackDef(\tlist).edit

(
MIDIdef.noteOn(\piano_ndef, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	Ndef(\ambi).set(\freq, noteNum.midicps)
	
});
)

(
	// drums
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus3, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[894].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);
