
(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpfr: ControlSpec(0.1,10,\lin, 0, 1)
))).add;
);

(
Pdef(\bass, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0,7,2,3],inf),
		\octave, 3,
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);

ParamTimeline(\test, Param(Pdef(\bass), \lpfr)).edit;


(
// create a pattern with both the bass pattern and the automation pattern
Pdef(\main, 
	Ppar([
		Pdef(\bass),
		ParamTimeline(\test).asPattern,
	])
).play;
)



// control a Ndef with ParamTimeline
(
Ndef(\sound, { 
	var sig; 
	sig = LFSaw.ar(LFNoise1.kr(1!2) * 20 + 200) * 0.1;
	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
}).play
)

ParamTimeline(\testndef, Param(Ndef(\sound), \lpf, \freq)).edit; // third argument of Param is the spec
