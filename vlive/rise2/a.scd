~name = 'a';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, 
		ffreq=200, rq=0.7, mixosc=0.81, drive=50, distamp=0.5, mixdist=0.5;
	var sig, sig1, sig2, sig3;
	var sigd;

	//freq = freq * XLine.ar(1,0.001,0.4);
	freq = SinOsc.ar(40 * [1,2.01]) * 0.8 + 1 * freq;

	sig1 = LFSaw.ar(freq * [1,1.01,1.402,0.919]);
	sig1 = WhiteNoise.ar(1) * SinOsc.ar(freq );
	sig2 = SinOsc.ar(100 * XLine(1,0.001,0.4));

	sig2 = SinOsc.ar(freq * [1,1.01,1.002,0.919]);
	sig = SelectX.ar(mixosc, [sig1, sig2]);

	sigd = (sig * drive).clip2(1) * distamp;
	sig = SelectX.ar(mixdist, [sig, sigd]);
	sig = sig + sig2;
	sig = sig;
	//sig = Decay2.ar(sig2, 0.01,0.1) * sig * 0.0151;

	//ffreq = EnvGen.ar(Env.adsr(0.01,0.01,0.8,0.1),gate,doneAction:0) * ffreq * 0.5 + 150;
	sig = RLPF.ar(sig, ffreq, rq);

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/8,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
