~name = \1;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(~name, Pbind(
	\instrument, ~name,
	\degree, Pseq([0,1,2],inf),
	\dur, 1/4,
	\amp, 0.1
))
);
