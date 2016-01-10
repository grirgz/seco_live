
(
SynthDef(\golf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pant=1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = XLine.kr(0.001,1, pant) * pan;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
