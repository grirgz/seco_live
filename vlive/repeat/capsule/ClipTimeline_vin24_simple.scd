ClipTimeline('mainTimeline').presetCompileStringSavePath = "capsule/ClipTimeline_vin24_simple.scd";

ClipTimeline('mainTimeline').tracks = [ ( 'index': 0, 'recordArmed': true, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
ClipTimeline('mainTimeline').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 8.0, \midinote: 0, \playDur: 8.0, \relDur: 8.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_mainTimeline_t0_200506_224210') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
ClipTimeline('mainTimeline').recordedEvents = [ PatternEvent((playDur: 8.0, dur: 8.0, sustain: 8.0, midinote: 0, timeline: { SampleTimeline('rec_mainTimeline_t0_200506_224210') }, relDur: 8.0, type: 'pattern', absTime: 0.0)) ];

SampleTimeline('rec_mainTimeline_t0_200506_224210').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 8.0, \label: 'start', \playDur: 8.0, \relDur: 8.0, \sustain: 0, \type: 'start', ),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_mainTimeline_t0_200506_224210').buffer = BufDef('./rec_mainTimeline_t0_200506_224210.wav');

