ClipTimeline('vin19').presetCompileStringSavePath = "capsule/ClipTimeline_vin19.scd";

ClipTimeline('vin19').tracks = [ ( 'index': 0, 'recordArmed': true, 'recordBus': 0, 'muted': true ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
ClipTimeline('vin19').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \midinote: 1.0, \playDur: 0.0, \relDur: 0.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_vin19_t0_200331_223243') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \midinote: 2.0, \playDur: 0.0, \relDur: 0.0, \sustain: 4.0, \timeline: { SampleTimeline('rec_vin19_t0_200331_225351') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 8.0, \midinote: 3.0, \playDur: 8.0, \relDur: 8.0, \sustain: 120.0, \timeline: { SampleTimeline('rec_vin19_t0_200331_232041') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
ClipTimeline('vin19').recordedEvents = [ PatternEvent((playDur: 0.0, dur: 0.0, sustain: 8.0, midinote: 1.0, timeline: { SampleTimeline('rec_vin19_t0_200331_223243') }, relDur: 0.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 0.0, dur: 0.0, sustain: 4.0, midinote: 2.0, timeline: { SampleTimeline('rec_vin19_t0_200331_225351') }, relDur: 0.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 8.0, dur: 8.0, sustain: 120.0, midinote: 3.0, timeline: { SampleTimeline('rec_vin19_t0_200331_232041') }, relDur: 8.0, type: 'pattern', absTime: 0.0)) ];

SampleTimeline('rec_vin19_t0_200331_223243').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 8.0, \label: 'start', \playDur: 8.0, \relDur: 8.0, \sustain: 0, \type: 'start', ),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin19_t0_200331_223243').buffer = BufDef('./rec_vin19_t0_200331_223243.wav');
SampleTimeline('rec_vin19_t0_200331_225351').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 4.0, \label: 'start', \playDur: 4.0, \relDur: 4.0, \sustain: 0, \type: 'start', ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin19_t0_200331_225351').buffer = BufDef('./rec_vin19_t0_200331_225351.wav');
SampleTimeline('rec_vin19_t0_200331_232041').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 120.0, \playDur: 120.0, \relDur: 120.0, \sustain: 0, \type: 'start', ),
	(\absTime: 120.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin19_t0_200331_232041').buffer = BufDef('./rec_vin19_t0_200331_232041.wav');

