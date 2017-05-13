NoteTimeline('plop').presetCompileStringSavePath = "proj1/NoteTimeline_plop.scd";

NoteTimeline('plop').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.25, \label: 'start', \playDur: 0.25, \relDur: 0.25, \sustain: 0, \type: 'start', ),
	(\absTime: 0.25, \dur: 0.25, \midinote: 64.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.5, ),
	(\absTime: 0.5, \dur: 0.125, \midinote: 47.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 0.625, \dur: 0.375, \midinote: 54.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 1, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);