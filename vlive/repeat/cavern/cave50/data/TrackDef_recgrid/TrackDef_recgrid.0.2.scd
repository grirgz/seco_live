TrackDef('recgrid').childAt(0, 2).score = SampleTimeline('recgrid.0.2score');


SampleTimeline('recgrid.0.2score').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 2.0, \label: 'start', \playDur: 2.0, \relDur: 2.0, \sustain: 0, \type: 'start', ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('recgrid.0.2score').buffer = BufDef('/tmp/rec_recgrid.0.2score_220921_230526.wav');