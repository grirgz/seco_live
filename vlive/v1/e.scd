~name = \e;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, spread=0.8, lpf=1300, hpf=30, release=0.1;
	var sig, sig2, env1, env2;
	sig = ClipNoise.ar(1);
	sig = LPF.ar(sig, lpf);
	sig = HPF.ar(sig, hpf);
	env1 = EnvGen.ar(Env([500,20],[0.05]),gate,doneAction:0);
	sig2 = SinOsc.ar(env1 * [1,1.101]);
	sig = sig + sig2;
	sig = RLPF.ar(sig, 15800, 0.01);
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.8,release),gate,doneAction:2);
	sig = sig.sum;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(~name, Pbind(
	\instrument, ~name,
	\degree, Pseq([0,2,4]+10,inf),
	\isRest, Veco.main.seq.pryn(~name),
	\lpf, Pseq([1300,500,1200],inf),
	\release, Pseq([0.1,0.01],inf),
	\sustain, 0.1,
	\dur, 1/4,
));
);
