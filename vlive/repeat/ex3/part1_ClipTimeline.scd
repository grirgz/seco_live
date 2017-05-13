ClipTimeline('part1').presetCompileStringSavePath = "ex3/part1_ClipTimeline.scd";

ClipTimeline('part1').eventList = XEventList.newFrom([
	(\absTime: 0.0, \dur: 0.5, \label: 'start', \playDur: 0.5, \relDur: 0.5, \sustain: 0, \type: 'start', ),
	PlayerEvent((\absTime: 0.5, \dur: 0.125, \midinote: 1.0, \playDur: 0.125, \receiver: PlayerWrapper(Ndef('gradubid0')), \relDur: 0.125, \sustain: 1.25, \type: 'player', )),
	PatternEvent((\absTime: 0.625, \dur: 3.375, \midinote: 2.0, \pattern: Pdef('plop'), \playDur: 3.375, \relDur: 3.375, \sustain: 1.375, \type: 'pattern', )),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);