~name = \t;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, spread=0.8, noisefreq=1, ffreq=800;
	var sig, sig2, env1, env2;
	sig = ClipNoise.ar(1);
	sig = LPF.ar(sig, 15300);
	sig = BRF.ar(sig, SinOsc.ar(16).range(0.2,2)*5300, 0.5);
	sig = HPF.ar(sig, 130);
	env1 = EnvGen.ar(Env([500,20],[0.05]),gate,doneAction:0);
	//sig2 = SinOsc.ar(env1 * [1,2.101,0.5]);
	sig2 = 0;
	sig = sig + sig2;
	sig = RLPF.ar(sig, ffreq * [0.9,1.1,1,1.01,0.5,2,2.3654].scramble * LFNoise1.ar(noisefreq).range(0.8,1.2));
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig.tanh + sig.distort;
	sig = sig / 2;
	//sig = FreqShift.ar(sig, 2) + sig;
	//sig = sig.sum;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(~name, Pbind(
	\instrument, ~name,
	\degree, Pseq([0,2,4]+10,inf),
	\isRest, ~sceneset.seq.prythm(4),
	\ffreq, ~mybus.asMap,
	\ffreq, Pseq([50,30],inf),
	\ffreq, Pseq([800,500,750,300],inf),
	\noisefreq, Pseq([500,0.1],inf),
	\sustain, 0.1,
	\dur, 1/4,
));
);
