(
SynthDef(\bloab, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * (env1 * \lpenvamt.kr(1) + 1), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

// pmodenv time is in seconds !
// to loop, you need to a pair number of segment: 1/4/~t * 4 = 1 beat duration
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bloab,
			\lpfr, Pseq([
				~pmodenv.(Pseq([1/2,2,3,4]/4,1).trace, 1/4/~t).loop,
			],1),
			\octave, 4,
			\note, Pseq([
				1,\r, 4,\r, 6,\r, 1,4,
				//\r,6,\r,7,  Pseq([\r],4)
			],inf),
			\dur, Pseq([1/8],inf),
			\amp, 0.1,
		),
	])
)).play;
);
