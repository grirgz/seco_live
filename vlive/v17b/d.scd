~name = 'd';

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

SynthDef(~name+++\2, { | out=0, decay = 3, amp = 0.1, lpfreq=12000, hpfreq=4000, freqfactor = 1, doneAction=2, delayfactor=1, shift=(-200)  , gate=1, rq=0.05, noisefreq=0.5|
	var sig = WhiteNoise.ar;
	var del;
	sig = LPF.ar(sig, lpfreq*freqfactor);
	//sig = sig + DelayC.ar(sig, 0.1,LFNoise2.ar(1/2).range(0.001,0.01)*delayfactor);
	del = DelayC.ar(sig, 0.1,LFNoise2.ar(noisefreq).range(0.001,0.01)*delayfactor);
	del = FreqShift.ar(del, shift);
	sig = sig + del;
	sig = HPF.ar(sig, hpfreq*freqfactor, rq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.01,1,0.8)), gate, doneAction:doneAction);
	sig = sig * 10;
	sig = sig.clip(0.001);
	sig = sig / 2;
	Out.ar(out, 15 * sig.dup * amp);
}, metadata: (
	specs: (
		shift: ControlSpec.new((-2000),2000, \lin, 0, 0)
	)
)).add;

Veco(~name).make_mixer;

Pdef(~name+++\pre).quant = [Pdef.defaultQuant,0,0,~outset];

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\isRest, Veco(~name).isrest(32),
	\degree, Pseq([0],inf),
	\legato, 0.8,
	\freqfactor, 2,
	\decay, Pkey(\sustain),
	\dur, 1/8,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END

~q = Quant.new(8,0,0,1)
~q = [8,0,0,8];
Pdef(\bla).quant = ~q;
Pdef(\bla).quant
Pdef(\bla).play;
Pdef(\bla, Pbind(\dur, 1/8, \freq, Pseq([100,200],inf))) 
Pdef(\bla, Pbind(\dur, 1/8, \freq, Pseq([300,400],inf))) 

