
(
Ndef(\yup).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	var pan;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var cond = Line.kr(-1,1,16);
	var mix = cond.range(0,1);

	freq = 120 * Duty.kr(1/~t, 0, Dseq([
		[0,3,7,12,-12],
	],inf)).midiratio *.x [1/2,1,2]
	* Duty.kr(1/4/~t, 0, Dseq([
		0,2,
	],inf)).midiratio
	;

	freq = \freq.kr(200) * \freqtab.kr([0,3,7,12,-12]).midiratio;

	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq) * ( SinOsc.kr(1/7/5 * (1..8)/8).range(0,4) * cond.range(1,10) ) )));
	sig1 = sig;
	sig2 = LFSaw.ar(freq/2 * [1,1/2,2]) + sig;
	sig = SelectX.ar(mix, [sig, sig2]);
	sig2 = sig.fold2(1 * SinOsc.kr((1..8)/4/8).range(0.3,1 * cond.range(0,1))) + sig;
	sig = SelectX.ar(mix, [sig, sig2]);
	sig2 = sig.wrap2(1 * SinOsc.kr((1..8)/8*1/5.2).range(0.3,1)) + sig;
	sig = SelectX.ar(mix, [sig, sig2]);
	sig2 = sig & (sig << 1 | LFSaw.ar(1/100 * (1..8)/8).range(0,10000));
	sig = SelectX.ar(mix, [sig, sig2]);
	sig = SelectX.ar( SinOsc.kr(1/7 * (1..8)/8).range(0,1), [sig, sig1]);
	//sig = sig * sig
	sig = sig.collect({ arg isig, x; isig * SinOsc.kr(1/7/5 * x).range(0.2,1) });

	//sig = sig * EnvGen.kr(\iadsr2.kr(Env.adsr(0.001,0.1,0.8,0.1)), Trig.kr(\itrig2.tr(1),\isustain2.kr(1)), doneAction:0);

	pan = 1;
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	amp = amp * \gain.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * pan, amp).mean;
	sig;
});
Ndef(\yup).put(1, \set -> ~noteTimeline.new(\rox).xasPattern);
Ndef(\yup).play;
)

~noteTimeline.new(\rox, Param(Ndef(\yup), \midinote)).edit
~noteTimeline.new(\rox).edit
~noteTimeline.new(\rox).composeParamPattern = false;
ParamProto.init(true)
~noteTimeline


~modStepTimeline.new(\yep).edit
~modStepTimeline.new(\yep).drumrack= DrumRack(\yep)
~clipTimeline.new(\yep).edit
Ndef(\yup).quant = 0


(
SynthDef(\piou, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1,1.0001]);
	sig = RLPF.ar(sig, \lpf.kr(800) * [1.500001,1,1.001,1.5001], \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\piou, Pbind(
	\instrument, \piou,
	\degree, Pseq([[0,3,7]],inf),
	\lpf, 1200,
	\legato, 0.01,
	\dur, 1,
	\amp, 0.1
)).play;
);

~noteTimeline.new(\piou, Param(Pdef(\piou), \midinote)).edit
