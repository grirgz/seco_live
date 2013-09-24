~name = '5';

SynthDef(~name, { | out=0, decay = 3, amp = 0.1, freqfactor = 1, doneAction=2, delayfactor=1, shift=(-200), freq2=3000, noisefreq=0.5,
			fbase=4000, fscale=3, fbase2 = 3000, fscale2 = 1, freqfactor2 = 1, decay2=2,
			dbase2=0.01, dscale2=0.5,
			dbase=0.100, dscale=0.9|
	var sig = WhiteNoise.ar;
	var sig2;
	var del = 0;
	var sigo = sig;
	sig = LPF.ar(sig, (fbase*fscale*freqfactor).clip(10,15000));
	//sig = sig + DelayC.ar(sig, 0.1,LFNoise2.ar(1/2).range(0.001,0.01)*delayfactor);
	del = sig + DelayC.ar(sig, 0.1,LFNoise2.ar(noisefreq) * dscale*dbase+dbase);
	del = FreqShift.ar(del, shift);
	sig = sig + del;
	sig = HPF.ar(sig, (fbase*freqfactor).clip(10,15000), 0.05);
	sig2 = sig;

	sig = LPF.ar(sigo, (fbase2*fscale2*freqfactor2).clip(10,15000));
	//sig = sig + DelayC.ar(sig, 0.1,LFNoise2.ar(1/2).range(0.001,0.01)*delayfactor);
	del = sig + DelayC.ar(sig, 0.1,LFNoise2.ar(noisefreq) * dscale2*dbase2+dbase2);
	del = FreqShift.ar(del, shift);
	sig = sig + del;
	sig = HPF.ar(sig, (fbase*freqfactor2).clip(10,15000), 0.05);
	sig = sig * EnvGen.kr(Env.perc(0.01,decay2), doneAction:0);


	sig = sig + sig2;

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
	\amp, 0.05 * Pkey(\amp),
) <> Veco(~name).mixer)
);
