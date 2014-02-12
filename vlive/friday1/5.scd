~name = \5;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, dist=50, distamp=0.4, distmix=0.5, detune=0.0041;
	var sig, sig1, sig2, sig3;
	sig1 = LFSaw.ar(freq * 1 + (detune * [1,-1]));
	sig2 = LFSaw.ar(freq * 0.99 );
	sig3 = LFSaw.ar(freq * 1 );
	sig = sig1 + sig2 + sig3;
	sig1 = (sig*dist).tanh * distamp;
	sig = SelectX.ar(distmix, [sig, sig1]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

Veco(~name).make_mixer;
~rlpfindex = 70;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, ~patfx.(~name+++\patfx) <> Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
