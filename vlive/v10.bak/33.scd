~name = '33';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, spread=0.8, lpfreq=1000, freqshift=2, hpfreq=1000, rlpfreq=1000;
	var sig, sig2, env1, env2;
	sig = ClipNoise.ar(1);
	sig = LPF.ar(sig, lpfreq);
	sig = HPF.ar(sig, hpfreq);
	env1 = EnvGen.ar(\env.kr(Env([100,20,20],[0.05,0])),gate,doneAction:0);
	sig2 = SinOsc.ar(env1 * \sintab.kr([2.5,2.101,2.5,1]));
	sig = sig + sig2;
	sig = RLPF.ar(sig, rlpfreq);
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig.tanh + sig.distort;
	sig = FreqShift.ar(sig, freqshift) + sig;
	sig = sig.sum;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0,2,4]+10,inf),
	\isRest, Veco(~name).isrest,
	\sustain, 0.1,
	\dur, 1/4,
));
);
