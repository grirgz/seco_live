// korg m1 organ from show me love

(
SynthDef(\m1_organ2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lpenv, lpfreq;
	sig1 = LFTri.ar(freq/2);
	sig2 = LFPulse.ar(freq*7.midiratio);
	sig = [ sig1, sig2 ].mean;
	lpenv = EnvGen.kr(\lpenv.kr(Env([0, 1,0.45,0],[0.001,0.1,0.01])), 1, doneAction:0) * \lpenvamt.kr(8) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(180) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.4,0.2,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpenv: ParamEnvSpec(\amp!4),
))).add;
);

(
// not exact notes but you get the idea
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \xm1_organ2,
			\note, Pseq([
				-3,-3,-3,-3, -3,-3,-3,0,
				-8,-8,-8,-8, -8,-8,-8,-7,
				-7,-7,-7,-7, -7,-7,-7,-7,
				-7,-7,-7,-7, -7,-7,-5,-7,
			],inf),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\amp, 0.1,
		),
	])
)).play;
);
