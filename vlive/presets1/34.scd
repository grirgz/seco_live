~name = '34';

SynthDef(~name, { | out=0, decay = 3, amp = 0.1, freqfactor = 1, doneAction=2, delayfactor=1, shift=(-200) |
	var sig = WhiteNoise.ar;
	var del;
	sig = LPF.ar(sig, (12000*freqfactor).clip(10,15000));
	//sig = sig + DelayC.ar(sig, 0.1,LFNoise2.ar(1/2).range(0.001,0.01)*delayfactor);
	del = DelayC.ar(sig, 0.1,LFNoise2.ar(1/2).range(0.001,0.01)*delayfactor);
	del = FreqShift.ar(del, shift);
	sig = sig + del;
	sig = HPF.ar(sig, (4000*freqfactor).clip(10,15000), 0.05);
	sig = sig * EnvGen.kr(Env.perc(0.01,decay*0.8), doneAction:doneAction);
	Out.ar(out, 15 * sig.dup * amp);
}, metadata: (
	specs: (
		shift: ControlSpec.new((-2000),2000, \lin, 0, 0)
	)
)).add;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\isRest, Veco(~name).isrest,
	\degree, Pseq([0],inf),
	\legato, 0.8,
	\freqfactor, 2,
	\decay, Pkey(\sustain),
	\dur, 1/8,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
