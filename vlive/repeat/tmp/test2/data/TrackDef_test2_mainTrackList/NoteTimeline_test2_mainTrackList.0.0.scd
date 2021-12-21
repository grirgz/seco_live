NoteTimeline('test2_mainTrackList.0.0').presetCompileStringSavePath = "repeat/tmp/test2/data/TrackDef_test2_mainTrackList/NoteTimeline_test2_mainTrackList.0.0.scd";

NoteTimeline('test2_mainTrackList.0.0').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.125, \midinote: 44.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.125, \dur: 0.25, \midinote: 47.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.375, \dur: 0.375, \midinote: 55.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 0.75, \dur: 7.25, \midinote: 62.0, \playDur: 7.25, \relDur: 7.25, \sustain: 0.1, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);