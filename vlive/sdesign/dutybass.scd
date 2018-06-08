
// the duty cause some new harmonics like fm but discretized
(
SynthDef(\dutybass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.2,1],[0.1,1.8]), 1);
	freq = freq + Duty.ar(\dutytime.kr(1/10), 0, Dseq(\dutyseq.kr([
		0,10,0,0,
		0,0,0,0,
	])));
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);
	sig = sig / 2;
	sig = BPF.ar(sig, freq * env1, 0.1).tanh + sig;

	//sig = sig;
	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig.debug("basicbas");
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \dutybass,
			\octave, 3,
			\note, Pseq([
				0,4,3,7,
			],inf),
			\lpf, 400,
			\dutytime, Pseg(Pseq([1/100,1/30],inf),8),
			\dutyseq, Pseq([
				[
					-1,-2,-3,-4,
					10,20,0,0,
				],
				[
					1,2,3,4,
					10,20,0,0,
				],
			],inf),
			\dur, 1/2,
			\amp, 0.1/4,
		),
	])
)).play;
)
