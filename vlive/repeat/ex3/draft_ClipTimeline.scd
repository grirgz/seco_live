ClipTimeline('clips').presetCompileStringSavePath = "ex3/draft_ClipTimeline.scd";

ClipTimeline('clips').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 1, \label: 'start', \playDur: 1, \relDur: 1, \sustain: 0, \type: 'start', ),
	(\absTime: 1, \dur: 0.5, \label: 'end', \playDur: 0.5, \relDur: 0.5, \type: 'end', ),
	PatternEvent((\absTime: 1.5, \dur: 0, \midinote: 1.0, \playDur: 0, \relDur: 0, \sustain: 1.5, \timeline: { KitTimeline('perc') }, \type: 'pattern', )),
]);