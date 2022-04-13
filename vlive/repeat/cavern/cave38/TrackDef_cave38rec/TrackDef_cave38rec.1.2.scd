TrackDef('cave38rec').childAt(1, 2).score = SampleTimeline('cave38rec.1.2score');


SampleTimeline('cave38rec.1.2score').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 2.0, \label: 'start', \playDur: 2.0, \relDur: 2.0, \sustain: 0, \type: 'start', ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('cave38rec.1.2score').buffer = BufDef('cliprec/rec_cave38rec.1.2score_220412_175532.wav');