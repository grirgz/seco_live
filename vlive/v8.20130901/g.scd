~name = \g;

(
SynthDef(~name, { | out=0, decay = 3, pan=0, spread=0.7, amp = 0.1, freqfactor = 1, freqfactor2=1, doneAction=2, delayfactor=1, shift=(-200) |
	var sig = WhiteNoise.ar;
	var del;
	var noisetab;
	var combtab;
	sig = sig + ClipNoise.ar;
	sig = LPF.ar(sig, (12000*freqfactor).clip(10,15000));
	//sig = sig + DelayC.ar(sig, 0.1,LFNoise2.ar(1/2).range(0.001,0.01)*delayfactor);
	noisetab = \noisetab.kr([0.4,7.1,0.3,0.4]);
	combtab = \combtab.kr([2.4,7.1,0.3,0.4].extend(8,0.51));
	del = DelayC.ar(sig, 0.1,LFNoise2.ar(noisetab).range(0.001,0.01)*delayfactor);
	del = FreqShift.ar(del, shift);
	sig = sig + del;
	sig = HPF.ar(sig, (4000*freqfactor*freqfactor2).clip(10,15000), 0.05);
	sig = CombL.ar(sig, 0.4,0.014*combtab*LFNoise1.ar(0.1).range(1,1.1),0.2*combtab) + sig;
	sig = CombL.ar(sig, 0.4,0.14*Line.kr(0.1,0.0001,00.02),0.2*combtab) + sig;
	sig = sig * EnvGen.kr(Env.perc(0.01,decay*0.8), doneAction:doneAction);
	sig = sig.distort;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig * 15);
}, metadata: (
	specs: (
		shift: ControlSpec.new((-2000),2000, \lin, 0, 0)
	)
)).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\isRest, Veco(~name).isrest(16),
	\degree, Pseq([0],inf),
	\legato, 0.8,
	\freqfactor, 2,
	\decay, Pkey(\sustain),
	\dur, 1/8,
	\amp, 0.1
))
);

