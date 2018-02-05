
(
SynthDef(\cpukiller, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(exprand(50.0,20000!15));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).store;
);

(
SynthDef(\cpukiller, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(exprand(50.0,20000!15));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).store;
);

(
Pdef(\cpukiller, Pbind(
	\instrument, \cpukiller,
	\degree, Pseq([0],inf),
	\dur, Pn(4,1),
	\amp, 0.1,
)).render("/tmp/ki2.wav");
);

BufDef('/tmp/ki2.wav').play
BufDef('/tmp/ki2.wav')
BufDef('/tmp/ki2.wav').clear
BufDef.reload("/tmp/ki2.wav")
BufDef.clear
BufferPool
