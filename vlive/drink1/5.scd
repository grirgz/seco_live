~name = \5;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=500, rq=0.3, 
			drive=1, distamp=0.8, distmix=0.8, lprange=0.5, frot=0;
	var sig, sig1, sig2, sig3;
	var range, frange;
	var ftab;
	range = LFNoise1.ar(0.0100).range(0,1);
	frange = LFNoise1.ar(4.0100).range(0,1);
	freq = freq*([0.01,0.02,0.03,-0.001]*range+1);
	sig = LFSaw.ar(freq);
	ffreq = ffreq*([0.41,0.02,-0.23,-0.001]*range+1);
	ftab = [1,2,3,4];
	ftab = SelectX.kr(frot, ~rot.(ftab));
	ffreq = ffreq*(ftab*lprange+1);
	sig = RLPF.ar(sig, ffreq.clip(1,19000), rq);
	sig.postln;
	sig1 = (sig*drive).clip(0.5);
	sig1 = distamp * sig1;
	sig1 = HPF.ar(sig1,50);
	sig = SelectX.ar(distmix,[sig, sig1]);


	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

Veco(~name).make_mixer;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, ~patfx.(\modskank) <> Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/8,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);	
