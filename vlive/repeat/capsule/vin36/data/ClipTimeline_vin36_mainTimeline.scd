ClipTimeline('vin36_mainTimeline').presetCompileStringSavePath = "capsule/vin36/data/ClipTimeline_vin36_mainTimeline.scd";

ClipTimeline('vin36_mainTimeline').tracks = [ ( 'index': 0, 'recordArmed': true, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('vin36_mainTimeline').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 4.0, \midinote: 0, \playDur: 4.0, \relDur: 4.0, \sustain: 4.0, \timeline: { SampleTimeline('rec_vin36_mainTimeline_t0_201119_164209') }, \type: 'pattern', )),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;
ClipTimeline('vin36_mainTimeline').recordedEvents = [ PatternEvent((playDur: 4.0, dur: 4.0, sustain: 4.0, midinote: 0, timeline: { SampleTimeline('rec_vin36_mainTimeline_t0_201119_164209') }, relDur: 4.0, type: 'pattern', absTime: 0.0)) ];

SampleTimeline('rec_vin36_mainTimeline_t0_201119_164209').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 4.0, \label: 'start', \playDur: 4.0, \relDur: 4.0, \sustain: 0, \type: 'start', ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin36_mainTimeline_t0_201119_164209').buffer = BufDef('./rec_vin36_mainTimeline_t0_201119_164209.wav');

