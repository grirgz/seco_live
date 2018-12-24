(
SynthDef(\scaryfriend, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([4,1,3],[0.151,0.1],-1), 1);
	sig1 = SinOsc.ar(freq* [1.000001,1] * SinOsc.kr(6 * [1,1.0001]).range(0.96,1)) * SinOsc.kr(5).range(0.6,1);
	sig2 = LFSaw.ar(freq* [1,1.0001] * SinOsc.ar(2* [1,1.1]).range(0.93,1)) * SinOsc.kr(5).range(0.6,1);
	sig3 = sig2;
	sig2 = RLPF.ar(sig2, \lpfr.kr(1.1) * freq * env1, \rq.kr(0.5));

	sig3 = FreqShift.ar(sig3.flop, freq*[1,1/2,2,1/4]).mean;
	sig3 = CombL.ar(sig3, 0.1,( 1/( freq * [1,1/2,1/4] ) ) * SinOsc.ar(freq, mul:0.4,add:1) ,0.4)/5;
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.1) * freq * env1, \rq.kr(0.5));
	sig = [sig1, sig2, sig3].mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.5)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Balance2.ar(sig.first, sig.last, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \scaryfriend,
			\note, Pseq([
				[ -12, 3, 7, 12],
				[ -12, 3, 7, 12]-3,
			],inf),
			\strum, 0.02,
			\dur, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \scaryfriend,
			\note, Pseq([
				 3, 7, 10, 12, 10, 7,
				Pseq([
					3, 7, 10, 12, 10, 7
				],1)-3,
			],inf),
			\octave, 6,
			\sustain, 0.1/2,
			\strum, 0.02,
			\dur, 1/6,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \scaryfriend,
			\note, Pseq([
				10,14
			],inf),
			\octave, 7,
			\sustain, 0.1/2,
			\strum, 0.02,
			\dur, Pseq([
				1,1/4,2,1/2
			],inf),
			\amp, 0.1,
		),
		
	])
)).play;
);
