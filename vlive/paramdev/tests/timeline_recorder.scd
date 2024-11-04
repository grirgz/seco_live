
SampleTimeline(\blia8).edit
SampleTimeline(\blia6).buffer.asCompileString
SampleTimeline(\blia6).bufferInfo.fileName
SampleTimeline(\blia8).presetCompileString.editorInsert
(
SampleTimeline('blia8').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 4.0, \label: 'start', \playDur: 4.0, \relDur: 4.0, \sustain: 0, \type: 'start', ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('blia8').buffer = BufDef('/tmp/rec_blia8_190714_194515.wav');
);

(
SampleTimeline('blia7').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 10.0, \label: 'start', \playDur: 10.0, \relDur: 10.0, \sustain: 0, \type: 'start', ),
	(\absTime: 10.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('blia7').buffer = BufDef('/tmp/rec_blia7_190714_194153.wav');
);


BufDef.paths = BufDef.paths ++ ["~/Musique/sc/cliprec".standardizePath]

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pseq([
			Pbind(
				\instrument, \default,
				\freq, Pseq([200,852]).stutter(4),
				\dur, 1/4,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \basicbass,
				\freq, Pseq([300,103]).stutter(4),
				\lpf, 9000,
				\dur, 1/4,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \default,
				\freq, Pseq([380,703]).stutter(8),
				\lpf, 9000,
				\dur, 1/8,
				\amp, 0.1,
			),
		],1),
		
	])
)).play;
);


///////////////////

ParamProto.init(true)
ClipTimeline(\bla12).edit
ClipTimeline(\bla12).tracks.asCompileString
ClipTimeline(\bla12).add_track
ClipTimeline(\bla12).areasize
ClipTimeline(\bla14).presetCompileString.editorInsert

(
ClipTimeline('bla15').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 22, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': true, 'recordBus': 66, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 78, 'muted': true ) ];
ClipTimeline('bla14').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 8, \label: 'start', \playDur: 8, \relDur: 8, \sustain: 0, \type: 'start', ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

(
ClipTimeline('bla12').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 2.0, \label: 'start', \playDur: 2.0, \relDur: 2.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 2.0, \dur: 0.0, \midinote: 1, \playDur: 0.0, \relDur: 0.0, \sustain: 6.0, \timeline: { SampleTimeline('rec_bla10_t1_190716_192738') }, \type: 'pattern', )),
	PatternEvent((\absTime: 2.0, \dur: 0.0, \midinote: 2, \playDur: 0.0, \relDur: 0.0, \sustain: 6.0, \timeline: { SampleTimeline('rec_bla10_t2_190716_192738') }, \type: 'pattern', )),
	PatternEvent((\absTime: 2.0, \dur: 6.0, \midinote: 3, \playDur: 6.0, \relDur: 6.0, \sustain: 6.0, \timeline: { SampleTimeline('rec_bla10_t3_190716_192738') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

ClipTimeline(\bla9).eventList



(
Pdef(\part, Pdef(\zed, 
	Ppar([
			Pbind(
				\instrument, \default,
				\freq, Pseq([200,852],inf).stutter(4),
				\dur, 1/4,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(
				\instrument, \basicbass,
				\freq, Pseq([300,103],inf).stutter(4),
				\lpf, 9000,
				\dur, 1/4,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
			Pbind(
				\instrument, \default,
				\freq, Pseq([380,703],inf).stutter(8),
				\lpf, 9000,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
		
	])
)).play;
);

////////////////


ParamProto.init(true)
ClipTimeline(\bla1).edit
ClipTimeline(\bla1).clear
ClipTimeline(\bla1).tracks.asCompileString
ClipTimeline(\bla1).add_track
ClipTimeline(\bla1).areasize


/////////////////////////////// NoteTimeline

(
Pdef(\testpdef, 
	Pbind(
		\instrument, \default,
	)
).play;
);

NoteTimeline(\test1, Pdef(\testpdef)).edit
NoteTimeline(\test1).eventList.print
NoteTimeline(\test1).clear
