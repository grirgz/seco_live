ClipTimeline('sun38_mainTimeline').presetCompileStringSavePath = "repeat/sun/sun38/data/ClipTimeline_sun38_mainTimeline.scd";

ClipTimeline('sun38_mainTimeline').tracks = [ ( 'index': 0, 'recordArmed': true, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('sun38_mainTimeline').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 16.0, \midinote: 0, \playDur: 16.0, \relDur: 16.0, \sustain: 24.0, \timeline: { SampleTimeline('rec_sun38_mainTimeline_t0_230919_222744') }, \type: 'pattern', )),
	(\absTime: 16.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;
ClipTimeline('sun38_mainTimeline').recordedEvents = [ PatternEvent((playDur: 16.0, dur: 16.0, sustain: 24.0, midinote: 0, timeline: { SampleTimeline('rec_sun38_mainTimeline_t0_230919_222744') }, relDur: 16.0, type: 'pattern', absTime: 0.0)) ];

SampleTimeline('rec_sun38_mainTimeline_t0_230919_222744').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 24.0, \playDur: 24.0, \relDur: 24.0, \sustain: 0, \type: 'start', ),
	(\absTime: 24.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_sun38_mainTimeline_t0_230919_222744').buffer = BufDef('cliprec/rec_sun38_mainTimeline_t0_230919_222744.wav');

