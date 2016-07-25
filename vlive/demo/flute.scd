
(
SynthDef(\flute, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var bandfac;
	sig1 = LFSaw.ar(freq);
	//sig1 = sig1.lag(1/freq);
	sig1 = LPF.ar(sig1, freq/2);

	sig2 = LFSaw.ar(freq+[1,0]*(2 + SinOsc.ar(1.6, mul:[1,1]/100)));
	sig2 = LPF.ar(sig2, freq * 2);
	sig2 = sig2 * 4;

	sig3 = WhiteNoise.ar(1);
	sig3 = sig3 * EnvGen.kr(Env([0,1,0.52,0.5],[0.01,0.1,3.8,0.2],[1]), 1);
	bandfac = 1;
	sig3 = LPF.ar(sig3, freq*bandfac + 300);
	sig3 = HPF.ar(sig3, freq/bandfac);
	sig3 = sig3 * 4;

	sig4 = sig1 + sig3;
	sig4 = CombC.ar(sig4, 0.1, 1/( freq*2 ), 0.101) + sig4;

	sig = sig4 + sig2;

	//sig = FreeVerb1.ar(sig)

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig.debug("sig");
	sig = Pan2.ar(sig, [-1,1], amp).flop;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\flute, Pbind(
	\instrument, \flute,
	\degree, Pseq([0,2,[1,4],1,Ptuple([Prand([-1,0,5]),2]),3,Prand([1,2,5,-3],2)],inf),
	\scale, Scale.gong,
	\legato, Pseq([0.5,Prand([0.1,1,0.5,0.3],3)],inf),
	//\out, Ndef(\verb).get(\inbus),
	\dur, Pseq([1,1/4, 1/2,1/8],inf),
	\amp, 0.1
)).play;
);
