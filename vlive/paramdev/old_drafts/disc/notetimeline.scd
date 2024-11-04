

(
ParamProto.init;
SynthDef(\baca, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(\fm.kr(1)) * 1 )));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef(\piano, Pbind(
	\instrument, \baca,
	\degree, Pseq([0],inf),
	\fm, Pseq([1,100,200],inf),
	\dur, 1,
	\amp, 0.1
));

~noteTimeline.new(\note1, Param(Pdef(\piano), \midinote)); // Param is used to know what pattern to compose
)

~noteTimeline.new(\note1).edit;
~noteTimeline.new(\note1).play;

PlayerWrapper(~noteTimeline.new(\note1)).edit
WindowDef(\yop, { ~pwv = PlayerWrapperView(~noteTimeline.new(\note1)); ~pwv.view }).front
WindowDef(\yop, { ~pwv = TimelinePreview(~noteTimeline.new(\note1)); ~pwv.view }).front
WindowDef(\yop, { ~tv = TimelineView.new; ~tv.mapEventList(~noteTimeline.new(\note1).eventList); ~tv.view }).front

//////////////////////////////////////////////////


