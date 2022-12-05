ClipTimeline('cave46_mainTimeline').presetCompileStringSavePath = "repeat/cavern/cave46/data/ClipTimeline_cave46_mainTimeline.scd";

ClipTimeline('cave46_mainTimeline').tracks = [ ( 'index': 0, 'recordArmed': true, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('cave46_mainTimeline').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 605.0, \midinote: 0.0, \playDur: 605.0, \relDur: 605.0, \sustain: 597.0, \timeline: { SampleTimeline('rec_cave46_mainTimeline_t0_220817_013415') }, \type: 'pattern', )),
	(\absTime: 605.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;
ClipTimeline('cave46_mainTimeline').recordedEvents = [ PatternEvent((playDur: 8.0, dur: 8.0, sustain: 151.0, midinote: 0, timeline: { SampleTimeline('rec_cave46_mainTimeline_t0_220817_003255') }, relDur: 8.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 407.0, dur: 407.0, sustain: 401.0, midinote: 0, timeline: { SampleTimeline('rec_cave46_mainTimeline_t0_220817_003931') }, relDur: 407.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 605.0, dur: 605.0, sustain: 597.0, midinote: 0.0, timeline: { SampleTimeline('rec_cave46_mainTimeline_t0_220817_013415') }, relDur: 605.0, type: 'pattern', absTime: 0.0)) ];

SampleTimeline('rec_cave46_mainTimeline_t0_220817_013415').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 597.0, \label: 'start', \playDur: 597.0, \relDur: 597.0, \sustain: 0, \type: 'start', ),
	(\absTime: 597.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave46_mainTimeline_t0_220817_013415').buffer = BufDef('cliprec/rec_cave46_mainTimeline_t0_220817_013415.wav');

