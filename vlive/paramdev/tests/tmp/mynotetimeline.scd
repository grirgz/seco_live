NoteTimeline('bla.1.0score').presetCompileStringSavePath = "paramdev/tests/tmp/mynotetimeline.scd";

NoteTimeline('bla.1.0score').param = Param(Pdef('bla.1.instr'), 'midinote');
NoteTimeline('bla.1.0score').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \label: 'start', \playDur: 8, \relDur: 8, \sustain: 0, \type: 'start', ),
	(\absTime: 8, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);