
(
SynthDef(~namex, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, doneAction=2;
	var sig;
	var freqs;
	var thwack;
	var timeScale = 1;
	sig = SinOsc.ar(freq);
	freqs  = \freqs.kr(100!100);
	thwack = EnvGen.ar(Env.perc(0.001,0.001,1), timeScale:\extime.kr(1));
	sig    = Klank.ar( Ref( [freqs,0.1,1.1] ), thwack);
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(~name+++\pre, Pbind(
	\extime, 1,
	\instrument, ~namex,
	\degree, Pseq([0],inf),
	\freqs, Pfunc({
		[{exprand(300, 2000)}.dup(100)]
	}),
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.4,curve:-5) ],
	],inf),
	\legato, 0.1,
	\dur, 1/8,
	\isRest, 
		Pseq([
			Pseq(~euclide.(8,1),1),
			Pseq(~euclide.(8,2),1),
			Pseq(~euclide.(8,3),1),
			Pseq(~euclide.(8,5),1),
		],inf),
	\amp, 0.1/2
));
);
