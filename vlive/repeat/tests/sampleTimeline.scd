

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, Pseq([300,450,234,699],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);
ParamProto.init(true)
SampleTimeline(\bla2).edit
SampleTimeline(\bla2).clear
SampleTimeline(\bla2).presetCompileString.editorInsert
(
SampleTimeline('bla2').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 4.0, \label: 'start', \playDur: 4.0, \relDur: 4.0, \sustain: 0, \type: 'start', ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('bla2').buffer = BufDef('/tmp/rec_bla2_190719_000541.wav');
);

