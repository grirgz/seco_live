
ParamProto.init(true)
~clipTimeline.new(\whut).edit
~clipTimeline.new(\whut)
~clipTimeline.new(\whut2)
~clipTimeline.new(\whut2).edit
~clipTimeline.new(\whut).xclear
~clipTimeline.all[\whut] = nil

(
SynthDef(\doc, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = LFSaw.ar(freq * [1,1.001]);
	sig1 = RLPF.ar(sig1, \lpf.kr(1000) * SinOsc.kr(1/4).range(0,1), \rq.kr(0.5));
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = HPF.ar(sig, 100);
	sig = BRF.ar(sig, 1500);

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\miss, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = LFSaw.ar(freq * [1,1.001]);
	sig1 = RLPF.ar(sig1, \lpf.kr(1000) * SinOsc.kr(1/4).range(0,1), \rq.kr(0.5));
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef(\flower, Pbind(
	\instrument, \doc,
	\degree, Pseq([0,4,5, Prand([1,2,3,4])],inf),
	\dur, 1/8,
	\amp, 0.2
));
);

(
Pdef(\bird, Pbind(
	\instrument, \miss,
	\degree, Pseq([0,4,5, Prand([1,2,3,4])],inf),
	\dur, 1/8,
	\amp, 0.2
));


Ndef(\bird, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq.poll;
	freq = freq * ( 1 + ( SinOsc.ar(freq * SinOsc.kr(1/4).range(2,1)) * 1 ));
	sig = SinOsc.ar(freq * [1,2,4]);
	sig = CombL.ar(sig, 0.1,0.01 * SinOsc.kr(1/4).exprange(1.01,1),1.1) + sig;
	sig = sig / 3;
	sig = Pan2.ar(sig, SinOsc.ar(1/4 * [1,2,3]) , amp).flop;
});
);

(
Ndef(\bird2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * ( 1 + ( SinOsc.ar(freq * SinOsc.kr(1/4).range(2,1)) * 1 ));
	sig = SinOsc.ar(freq);
	sig1 = LFSaw.ar(freq * [1,2,4]);
	//sig = SelectX.ar( XLine.kr(0.001,1.0,4).poll, [sig, sig1]);
	sig = SelectX.ar( SinOsc.kr(1/16).range(0,1).poll, [sig, sig1]);
	sig = CombL.ar(sig, 0.1,0.01 * SinOsc.kr(1/4).exprange(1.01,1),1.1) + sig;
	sig = sig / 3;
	sig = Pan2.ar(sig, SinOsc.ar(1/4 * [1,2,3]) , amp).flop;
});
);

~noteTimeline.new(\flower, Param(Pdef(\flower), \midinote))
~noteTimeline.new(\flower, Param(Pdef(\flower), \midinote)).edit
~envTimeline.new(\flower, Param(BusDef(\freqmod, \control), \freq, \freq)).edit
~envTimeline.new(\flower).xclear
~envTimeline.all[\flower] = nil

~noteTimeline.new(\flower).xasPattern.play
~noteTimeline.new(\flower).composeParamPattern
~noteTimeline.new(\flower).param.target.play
~noteTimeline.new(\flower).edit
~noteTimeline.new(\flower).xclear

~envTimeline.new(\flower).param
~envTimeline.new(\flower).outBus
~envTimeline.new(\flower).xasPattern.trace.play
BusDef(\freqmod).getSynchronous
BusDef(\freqmod)
BusDef.all[\freqmod] = nil;
Ndef(\bird).set(\freq, BusDef(\freqmod).asMap)
Ndef(\bird2).set(\freq, BusDef(\freqmod).asMap)
Ndef(\bird).set(\freq, 1200)
Ndef(\bird).play

~modStepTimeline.new(\yak).edit
~modStepTimeline.new(\yak).drumrack = DrumRack(\yak)
~modStepTimeline.new(\yak).xclear
~modStepTimeline.all[\yak] = nil
~modStepTimeline.new(\yak).eventType
~modStepTimeline.new(\yak).eventType
