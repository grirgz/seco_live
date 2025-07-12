

TrackDef('glu1_mainTrackList').childAt(6, 2).score = NoteTimeline('glu1_mainTrackList.6.2score');
NoteTimeline('glu1_mainTrackList.6.2score').param = Param(Pdef('glu1_mainTrackList.6.instr'), 'midinote');
NoteTimeline('glu1_mainTrackList.6.2score').outBus = 0;
NoteTimeline('glu1_mainTrackList.6.2score').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);