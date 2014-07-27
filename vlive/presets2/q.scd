~name = 'presets2-q';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = Impulse.ar(01 * Array.series(8,1,1.101));
	sig = Klank.ar(Ref([[10,20,30]]), sig, 1*LFNoise1.kr(1).range(0,0.1), freq);
	//sig = HPF.ar(sig, 400);
	//sig = sig * Pulse.ar(102);
	sig =  Pulse.ar(freq * [1,1.01,1.01]);
	sig = SelectX.ar(\mixdelay.kr(1),[sig, DelayC.ar(sig, 0.01,\delay.kr(0.0001)) + sig]);
	sig = RLPF.ar(sig, 1200);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = sig * 4;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

Veco(~name).make_mixer;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
