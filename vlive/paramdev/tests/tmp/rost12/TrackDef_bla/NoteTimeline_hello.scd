NoteTimeline('hello').presetCompileStringSavePath = "paramdev/tests/tmp/rost12/TrackDef_bla/NoteTimeline_hello.scd";

NoteTimeline('hello').param = Param(Pdef('NoteTimeline_default'), 'midinote');
NoteTimeline('hello').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.25, \label: 'start', \playDur: 0.25, \relDur: 0.25, \sustain: 0, \type: 'start', ),
	(\absTime: 0.25, \dur: 0.375, \midinote: 43.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 0.625, \dur: 0.5, \midinote: 33.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.75, ),
	(\absTime: 1.125, \dur: 6.875, \midinote: 43.0, \playDur: 6.875, \relDur: 6.875, \sustain: 0.625, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);