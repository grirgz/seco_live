KitTimeline('test3').presetCompileStringSavePath = "proj1/KitTimeline_test3.scd";

KitTimeline('test3').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.125, \kitIndex: 15.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 0.125, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.375, ),
	(\absTime: 0.375, \dur: 0.625, \kitIndex: 11.0, \midinote: 0, \playDur: 0.625, \relDur: 0.625, \sustain: 0.25, ),
	(\absTime: 1, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);