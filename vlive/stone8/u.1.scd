
(
SynthDef(~namex, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqs;
	var thwack;
	var timeScale = 1/4;
	sig = SinOsc.ar(freq);
	freqs  = \freqs.kr(100!100);
	thwack = EnvGen.ar(Env.perc(0.001,0.001,1), timeScale:timeScale);
	sig    = Klank.ar( Ref( [freqs,0.1,1.1] ), thwack);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(~name+++\pre, Pbind(
	\instrument, ~namex,
	\degree, Pseq([0],inf),
	\freqs, Pfunc({
		[{exprand(300, 2000)}.dup(100)]
	}),
	\dur, 1,
	\amp, 0.1
));
);
