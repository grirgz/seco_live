
(
SynthDef(\bell, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var fspread = EnvGen.kr(Env([0.0001,0.02,0.001],[0.1,0.8]), 1);
	var freqr = \freqr.kr(0.5);
	freq = { freq * ( rrand(-1,1.0) * freqr + 1 ) }.dup(8);
	sig = LFCub.ar(freq * ( SinOsc.ar( freq * ((0..7)/7 - 0.5 * fspread + 1) ) * 1 + 1 ));
	//sig = RLPF.ar(sig, \lpfr.kr(2.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	pan = pan + LFNoise1.kr(1/8!8, mul: XLine.kr(0.5,1,1));
	sig = Pan2.ar(sig, pan, amp).mean * 2;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pdef(\demomo, 
	Ppar([
		Pbind(
			\instrument, \bell,
			\freq, 1800,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)
