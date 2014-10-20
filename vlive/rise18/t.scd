~name = 'rise18-t';

SynthDef(~name, { | out=0, amp = 0.1, freqfactor = 1, doneAction=2, delayfactor=1, shift=(-200) |
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var del;

	sig = WhiteNoise.ar;
	sig = LPF.ar(sig, (\lpf.kr(4000)*freqfactor).clip(10,15000));
	//sig = sig + DelayC.ar(sig, 0.1,LFNoise2.ar(1/2).range(0.001,0.01)*delayfactor);
	del = DelayC.ar(sig, 0.1,SinOsc.ar(0.442).range(0.001,0.11)*delayfactor);
	del = FreqShift.ar(del, shift * [1,1.2]);
	sig = sig + del;
	sig = HPF.ar(sig, (\hpf.kr(1140)*freqfactor).clip(10,15000));
	sig = sig * EnvGen.kr(Env.perc(\attack.kr(0.01),\decay.kr(1.8)), doneAction:0);
	sig1 = sig * 8;

	sig = WhiteNoise.ar;
	//sig = sig + SinOsc.ar(1000);
	sig = LPF.ar(sig, (\lpf2.kr(4200)*freqfactor).clip(10,15000));
	//sig = sig + DelayC.ar(sig, 0.1,LFNoise2.ar(1/2).range(0.001,0.01)*delayfactor);
	del = DelayC.ar(sig, 0.1,SinOsc.ar(0.0442).range(0.001,0.11)*delayfactor);
	del = FreqShift.ar(del, shift * [1,1.2]);
	sig = sig + del;
	sig = HPF.ar(sig, (\hpf2.kr(1040)*freqfactor).clip(10,15000));
	sig = sig * EnvGen.kr(Env.perc(\attack2.kr(0.001),\decay2.kr(0.4)), doneAction:0);

	sig2 = sig;

	sig = SelectX.ar(\mix.kr(0.500), [sig1, sig2]);	
	sig = sig * 1;
	DetectSilence.ar(sig, doneAction:doneAction);
	sig = Limiter.ar(sig, 0.8);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(1));
	Out.ar(out, sig);
}, metadata: (
	specs: (
		shift: ControlSpec.new((-2000),2000, \lin, 0, 0)
	)
)).add;

Veco(~name).make_mixer;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, 
	~patfx.(~name+++\patfx) <> 
	Pdef(~name +++ \pre) <> Pbind(
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
