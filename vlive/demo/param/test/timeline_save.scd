
ParamProto.init(true)
~clipTimeline.new(\test1).edit
~clipTimeline.new(\test1).xclear
~clipTimeline.all.save
~clipTimeline.all.load

~e = XEventList.new
~e.add((bla:34))
~e.collect({arg x; x})
~x.collect({arg x; x})
~e.asArray.isKindOf(SequenceableCollection)
~x = XEventList.newFrom(~e.asArray)
~x.


(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
));
);

~noteTimeline.new(\note_test1).edit;

(
~noteTimeline.new(\note_test1, Pdef(\plop));
~noteTimeline.new(\note_test1).eventList.addEvent((absTime:0, midinote:45, sustain:1));
~noteTimeline.new(\note_test1).eventList.addEvent((absTime:0.5, midinote:47, sustain:1));
~noteTimeline.new(\note_test1).eventList.reorder;
)
~noteTimeline.new(\note_test1).eventList.remove((absTime:1.5, midinote:45))
~noteTimeline.new(\note_test1).xclear
~noteTimeline.all[\note_test1] = nil


////////////////// stepTimeline
ParamProto.init(true)

~stepTimeline.new(\step_test1).edit
~stepTimeline.new(\step_test1)
~modStepTimeline.new(\modstep_test1).edit
~modStepTimeline.new(\modstep_test1).asArchiveData
~modStepTimeline.new(\modstep_test1).xclear
~modStepTimeline.all.save
~modStepTimeline.all.load
~modStepTimeline.new(\modstep_test1).drumrack = DrumRack(\yep)
