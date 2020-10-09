ClipTimeline('vin30_mainTimeline').presetCompileStringSavePath = "capsule/vin30/data/vin30_mainTimeline.scd";

ClipTimeline('vin30_mainTimeline').tracks = [ ( 'index': 0, 'recordArmed': true, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
ClipTimeline('vin30_mainTimeline').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 72.0, \midinote: 0, \playDur: 72.0, \relDur: 72.0, \sustain: 72.0, \timeline: { SampleTimeline('rec_vin30_mainTimeline_t0_200915_171020') }, \type: 'pattern', )),
	(\absTime: 72.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
ClipTimeline('vin30_mainTimeline').recordedEvents = [ PatternEvent((playDur: 72.0, dur: 72.0, sustain: 72.0, midinote: 0, timeline: { SampleTimeline('rec_vin30_mainTimeline_t0_200915_171020') }, relDur: 72.0, type: 'pattern', absTime: 0.0)) ];

SampleTimeline('rec_vin30_mainTimeline_t0_200915_171020').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 72.0, \label: 'start', \playDur: 72.0, \relDur: 72.0, \sustain: 0, \type: 'start', ),
	(\absTime: 72.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin30_mainTimeline_t0_200915_171020').buffer = BufDef('./rec_vin30_mainTimeline_t0_200915_171020.wav');

