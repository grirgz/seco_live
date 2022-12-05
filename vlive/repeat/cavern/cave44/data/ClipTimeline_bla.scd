SampleTimeline('bla').presetCompileStringSavePath = "repeat/cavern/cave44/data/ClipTimeline_bla.scd";

SampleTimeline('bla').eventList = TimelineEventList.newFrom([
	(\absTime: 2.0, \dur: 121.0, \label: 'start', \playDur: 121.0, \relDur: 121.0, \sustain: 0, \type: 'start', ),
	(\absTime: 123.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('bla').buffer = BufDef('cliprec/rec_bla_220721_012252.wav');