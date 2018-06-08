
(
SynthDef(\lofi, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LocalIn.ar(1) * \fb.kr(1);
	sig = SinOsc.ar(freq * ( sig * 2.4 + 1 ));
	LocalOut.ar(sig + SinOsc.ar(freq, mul:0.1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \lofi,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)
