TrackDef('bla').childAt(0, 0).score = NoteTimeline('bla.0.0score');


NoteTimeline('bla.0.0score').param = Param(Pdef('NoteTimelineTrack.0.instr'), 'midinote');
NoteTimeline('bla.0.0score').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.125, \label: 'start', \playDur: 0.125, \relDur: 0.125, \sustain: 0, \type: 'start', ),
	(\absTime: 0.125, \dur: 0.25, \midinote: 46.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.375, \dur: 0.5, \midinote: 53.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.1, ),
	(\absTime: 0.875, \dur: 0.25, \midinote: 49.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.125, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);