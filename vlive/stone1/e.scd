

(

	SynthDef(\vocali, { arg out=0, pan=0, gate=1, f1=200, f2=300, fund = 70, amp = 0.25, doneAction=2 ;
		var sig;
		var source = Saw.ar(fund);
		var vowel = Normalizer.ar(BPF.ar(source, f1, 0.1))
		+
		Normalizer.ar(BPF.ar(source, f2, 0.1))
		* amp ;
		sig = vowel * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(0, sig)
	}).add ;
);


~pdef_channel.();

(
	SynthDef(~name, { arg out=0, pan=0, gate=1, f1=200, f2=300, fund = 70, amp = 0.25, doneAction=2 ;
		var sig;
		var source;
		var vowel;
		source = LFPulse.ar(fund * [1,1.001,1.0002]);
		source = source + LFSaw.ar(fund);
		source = source + SinOsc.ar(fund);
		vowel = Normalizer.ar(BPF.ar(source, f1, \rq1.kr(0.1)))
		+
		Normalizer.ar(BPF.ar(source, f2, \rq2.kr(0.1)))
		* amp ;
		sig = vowel * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
		sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
		Out.ar(0, sig)
	}).add ;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \vocali,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
