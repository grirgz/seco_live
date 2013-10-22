~name = \38;


(
SynthDef(\noisecomb2, { arg out, gate=1, pan=0, freq=300, amp=0.1, noiselevel=0.2,
		minfreq=100, decaytime=1, doneAction=2, ffreq=500, rq=0.3, spread=0.8;
	var sig, env;
	sig = WhiteNoise.ar(noiselevel);
	sig = sig + ClipNoise.ar(noiselevel);
	sig = sig + AllpassC.ar(sig, 1/minfreq, 1/freq, decaytime);
	sig = RLPF.ar(sig, ffreq * \ffreqtab.kr(1!10), rq);
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.6,0.1,0.8,0.1)), gate, doneAction:doneAction);
	sig = sig * env;
	sig = Splay.ar(sig, spread, 1, pan);
	sig = sig * amp;
	Out.ar(out, sig);
}).store;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \noisecomb2,
	//\note, Pseq([[0,7],[1,8],[-1,5]]-2,inf),
	//\note, Pseq([0,1,2,3,4],inf)
	//\octave, Pstep(Pseq([3,4],inf),Pseq([5,0.75],inf)),
	\isRest, Veco(~name).isrest,
	\octave, 3,
	\degree, Pseq([0,0,0,0],inf),
	\minfreq, 50,
	\decaytime, 1.0,
	\adsr, Pseq([
		[Env.adsr(0.02,0.1,0.8,0.4,curve:0.5)],
		[Env.adsr(0.02,0.1,0.8,0.4,curve:0.5)],
		[Env.adsr(0.02,0.1,0.8,0.4,curve:0.5)],
		[Env.adsr(0.03,0.1,0.8,0.1,curve:0.5)],
		[Env.adsr(0.03,0.1,0.8,0.1,curve:0.5)],
		[Env.adsr(0.03,0.1,0.8,0.1,curve:0.5)],
	],inf),
	\legato, 0.4,
	\ffreq, [500,610,820,140],
	//\ffreq, 500,
	//\ffreqtab, [[0.8,1,1.1,1.2, 2,4,5,6, 8,10].scramble.postln],
	\ffreqtab, Pfunc{ [[ 0.1, 0.2, 0.3, 0.5,  1,2,3,8, 10, 12  ].scramble] + rrand(0.01,1.0); },
	//\ffreqtab, [ 6, 4, 5, 10, 1, 1.2, 0.8, 1.1, 2, 8  ], // also nice
	//\ffreqtab, [[ 6, 4, 5, 10, 1, 1.2, 0.8, 0.4, 2, 8  ]],
	\dur, Pseq([3,1,1, 0.25,0.25,0.25],inf),
	\dur, 1/8,
	\amp, 0.5 * Pkey(\amp),
) <> Veco(~name).mixer)
);
