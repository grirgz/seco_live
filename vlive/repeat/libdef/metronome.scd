
(
SynthDef(\metronome, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq, mul:1/2);
	sig = sig + Impulse.kr(1/8, mul:4);
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.8,0.001),gate,doneAction:2);
	sig = sig / 1;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef(\metronome, Pbind(
	\instrument, \metronome,
	\degree, Pseq([2,0,0,0,1,0,0,0],inf),
	\sustain, 0.1,
	\dur, 1/2,
));

)
