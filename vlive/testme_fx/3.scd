~name = 'testme_fx-3';

SynthDef(~name, { | out=0, decay = 3, amp = 0.1, freqfactor = 1, doneAction=2, delayfactor=1, shift=(-200) |
	var sig = WhiteNoise.ar;
	var del;
	sig = LPF.ar(sig, (12000*freqfactor).clip(10,15000));
	//sig = sig + DelayC.ar(sig, 0.1,LFNoise2.ar(1/2).range(0.001,0.01)*delayfactor);
	del = DelayC.ar(sig, 0.1,LFNoise2.ar(1/2).range(0.001,0.01)*delayfactor);
	del = FreqShift.ar(del, shift);
	sig = sig + del;
	sig = HPF.ar(sig, (\hpfreq.kr(4000)*freqfactor).clip(10,15000), 0.05);
	sig = sig * EnvGen.kr(Env.perc(\attack.kr(0.01),decay*0.8), doneAction:doneAction);
	Out.ar(out, 15 * sig.dup * amp);
}, metadata: (
	specs: (
		shift: ControlSpec.new((-2000),2000, \lin, 0, 0)
	)
)).add;

(
SynthDef(~name+++\b, { | out=0, decay = 3, pan=0,amp = 0.1, freqfactor = 1, doneAction=2, delayfactor=1, shift=(-200) |
	var sig = WhiteNoise.ar;
	var del;
	sig = LPF.ar(sig, (12000*freqfactor * (1..4).rand/8).clip(10,15000));
	sig = sig + DelayC.ar(sig, 0.1,LFNoise2.ar(1/2).range(0.001,0.01)*delayfactor);
	del = DelayC.ar(sig, 0.1,LFNoise2.ar(1/2).range(0.001,0.01)*delayfactor);
	del = FreqShift.ar(del, shift);
	sig = sig + del;
	sig = HPF.ar(sig, (\hpfreq.kr(4000)*(1..4).rand/4*freqfactor).clip(10,15000), 0.05);
	sig = sig * EnvGen.kr(Env.perc(\attack.kr(0.01),decay*0.8), doneAction:doneAction);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, 15 * sig);
}, metadata: (
	specs: (
		shift: ControlSpec.new((-2000),2000, \lin, 0, 0)
	)
)).add;
);

~pdef_channel.();

(
~pdef_init.(Pbind(
	\instrument, ~name,
	\isRest, Veco(~name).isrest,
	\degree, Pseq([0],inf),
	\legato, 0.8,
	\freqfactor, 2,
	\decay, Pkey(\sustain),
	\dur, 1/8,
	\amp, 0.1 * Pkey(\amp),
))
);
