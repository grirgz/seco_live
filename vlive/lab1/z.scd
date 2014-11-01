


~pdef_channel.();

(
// nord modular 909 implementation
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var lfo1, lfo2;

	lfo1 = LFTri.ar(330);
	lfo1 = lfo1 * EnvGen.ar(Env.perc(0.0005, 0.055), gate);
	lfo2 = LFTri.ar(185);
	lfo2 = lfo2 * EnvGen.ar(Env.perc(0.0005, 0.075), gate);

	sig = WhiteNoise.ar;
	sig = LPF.ar(sig, 7040);

	sig1 = sig * EnvGen.ar(Env.perc(0.005, 0.400), gate, doneAction:2);

	sig2 = HPF.ar(sig, 523);
	sig2 = sig2 * EnvGen.ar(Env.perc(0.005, 0.283), gate);

	sig = ( sig1 * 0.7 ) + ( sig2 * 0.7 ) + lfo1 + lfo2;
	sig = sig ! 2;
	//sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	//sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

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
