
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				3,0, 2, -1, \r,0,\r,\r,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	~swing= 0.16;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				3,0, 3, 0,  \r,2, \r,-1,
				3,0, 3, 0,  \r,2, \r,-1,
				3,0, 3, 0,  \r,2, \r,-1,
				2, \r, 0,\r,  \r,\r, \r,\r,
			],inf),
			\dur, 1/4,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
		
	])
)).play;
);


(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2, freq2=100;
	var sig, sig1, sig2, sig3;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.2,0.1]), 1);
	env2 = EnvGen.kr(Env([freq,freq,freq2, freq],[0.01,0.08,0.1]), 1, timeScale:2);
	sig = LFSaw.ar(env2 * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * env1, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
	~swing= 0.16;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([
				3,
				3,
				2,
				2,
			],inf),
			\freq2, Pseq([
				60,
				60,
				59,
				59,
			],inf).midicps,
			\dur, 1/2,
			\legato, 1,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
		
	])
)).play;
);
