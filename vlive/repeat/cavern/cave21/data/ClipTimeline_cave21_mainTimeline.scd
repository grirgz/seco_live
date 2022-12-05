ClipTimeline('cave21_mainTimeline').presetCompileStringSavePath = "repeat/cavern/cave21/dataClipTimeline_cave21_mainTimeline.scd";

ClipTimeline('cave21_mainTimeline').tracks = [ ( 'index': 0, 'recordArmed': true, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': true ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('cave21_mainTimeline').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \midinote: 1.0, \playDur: 0.0, \relDur: 0.0, \sustain: 32.0, \timeline: { SampleTimeline('rec_cave21_mainTimeline_t0_210623_220419') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 184.0, \midinote: 0, \playDur: 184.0, \relDur: 184.0, \sustain: 184.0, \timeline: { SampleTimeline('rec_cave21_mainTimeline_t0_210623_221220') }, \type: 'pattern', )),
	PatternEvent((\absTime: 184.0, \dur: 28.0, \midinote: 0, \playDur: 28.0, \relDur: 28.0, \sustain: 24.0, \timeline: { SampleTimeline('rec_cave21_mainTimeline_t0_210623_221647') }, \type: 'pattern', )),
	(\absTime: 212.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;
ClipTimeline('cave21_mainTimeline').recordedEvents = [ PatternEvent((playDur: 8, dur: 8, sustain: 4.0, midinote: 0, timeline: { SampleTimeline('rec_cave21_mainTimeline_t0_210623_220258') }, relDur: 8, type: 'pattern', absTime: 0)), PatternEvent((playDur: 0.0, dur: 0.0, sustain: 32.0, midinote: 1.0, timeline: { SampleTimeline('rec_cave21_mainTimeline_t0_210623_220419') }, relDur: 0.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 184.0, dur: 184.0, sustain: 184.0, midinote: 0, timeline: { SampleTimeline('rec_cave21_mainTimeline_t0_210623_221220') }, relDur: 184.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 28.0, dur: 28.0, sustain: 24.0, midinote: 0, timeline: { SampleTimeline('rec_cave21_mainTimeline_t0_210623_221647') }, relDur: 28.0, type: 'pattern', absTime: 184.0)) ];

SampleTimeline('rec_cave21_mainTimeline_t0_210623_221220').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 184.0, \playDur: 184.0, \relDur: 184.0, \sustain: 0, \type: 'start', ),
	(\absTime: 184.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave21_mainTimeline_t0_210623_221220').buffer = BufDef('cliprec/rec_cave21_mainTimeline_t0_210623_221220.wav');
SampleTimeline('rec_cave21_mainTimeline_t0_210623_221647').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 24.0, \playDur: 24.0, \relDur: 24.0, \sustain: 0, \type: 'start', ),
	(\absTime: 24.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave21_mainTimeline_t0_210623_221647').buffer = BufDef('cliprec/rec_cave21_mainTimeline_t0_210623_221647.wav');
SampleTimeline('rec_cave21_mainTimeline_t0_210623_220419').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 32.0, \playDur: 32.0, \relDur: 32.0, \sustain: 0, \type: 'start', ),
	(\absTime: 32.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave21_mainTimeline_t0_210623_220419').buffer = BufDef('cliprec/rec_cave21_mainTimeline_t0_210623_220419.wav');

