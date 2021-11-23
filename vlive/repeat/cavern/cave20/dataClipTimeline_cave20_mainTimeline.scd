ClipTimeline('cave20_mainTimeline').presetCompileStringSavePath = "repeat/cavern/cave20/dataClipTimeline_cave20_mainTimeline.scd";

ClipTimeline('cave20_mainTimeline').tracks = [ ( 'index': 0, 'recordArmed': true, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('cave20_mainTimeline').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 9.0, \event_dropdur: 0.04, \midinote: 0.0, \playDur: 9.0, \relDur: 9.0, \sustain: 5.0, \timeline: { SampleTimeline('rec_cave20_mainTimeline_t0_211103_015255') }, \type: 'pattern', )),
	PatternEvent((\absTime: 9.0, \dur: 47.0, \midinote: 0.0, \playDur: 47.0, \relDur: 47.0, \sustain: 45.0, \timeline: { SampleTimeline('rec_cave20_mainTimeline_t0_211103_015633') }, \type: 'pattern', )),
	PatternEvent((\absTime: 56.0, \dur: 11.0, \midinote: 1.0, \playDur: 11.0, \relDur: 11.0, \sustain: 10.0, \timeline: { SampleTimeline('rec_cave20_mainTimeline_t1_211103_015959') }, \type: 'pattern', )),
	PatternEvent((\absTime: 67.0, \dur: 13.0, \midinote: 1, \playDur: 13.0, \relDur: 13.0, \sustain: 11.0, \timeline: { SampleTimeline('rec_cave20_mainTimeline_t1_211103_020022') }, \type: 'pattern', )),
	PatternEvent((\absTime: 80.0, \dur: 73.0, \midinote: 2, \playDur: 73.0, \relDur: 73.0, \sustain: 34.0, \timeline: { SampleTimeline('rec_cave20_mainTimeline_t2_211103_020326') }, \type: 'pattern', )),
	PatternEvent((\absTime: 153.0, \dur: 11.0, \midinote: 0, \playDur: 11.0, \relDur: 11.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_cave20_mainTimeline_t0_211103_021634') }, \type: 'pattern', )),
	PatternEvent((\absTime: 164.0, \dur: 0.0, \midinote: 1.0, \playDur: 0.0, \relDur: 0.0, \sustain: 36.0, \timeline: { SampleTimeline('rec_cave20_mainTimeline_t1_211103_020919') }, \type: 'pattern', )),
	PatternEvent((\absTime: 164.0, \dur: 52.0, \event_dropdur: 1, \midinote: 0.0, \playDur: 52.0, \relDur: 52.0, \sustain: 75.0, \timeline: { SampleTimeline('rec_cave20_mainTimeline_t0_211103_021802') }, \type: 'pattern', )),
	PatternEvent((\absTime: 216.0, \dur: 28.0, \event_dropdur: 7.105427357601e-15, \label: "rec_cave20_mainTimeline_t1_211103_015959-7.105e-15", \midinote: 1.0, \playDur: 28.0, \relDur: 28.0, \sustain: 10.0, \timeline: { SampleTimeline('rec_cave20_mainTimeline_t1_211103_015959') }, \type: 'pattern', )),
	PatternEvent((\absTime: 244.0, \dur: 0.0, \midinote: 3.0, \playDur: 0.0, \relDur: 0.0, \sustain: 49.0, \timeline: { SampleTimeline('rec_cave20_mainTimeline_t3_211103_022901') }, \type: 'pattern', )),
	PatternEvent((\absTime: 244.0, \dur: 0.0, \event_dropdur: 1, \midinote: 0.0, \playDur: 0.0, \relDur: 0.0, \sustain: 42.0, \timeline: { SampleTimeline('rec_cave20_mainTimeline_t0_211103_023034') }, \type: 'pattern', )),
	PatternEvent((\absTime: 244.0, \dur: 55.75, \event_dropdur: 2.8421709430404e-14, \label: "rec_cave20_mainTimeline_t1_211103_020919-2.842e-14", \midinote: 1.0, \playDur: 55.75, \relDur: 55.75, \sustain: 36.0, \timeline: { SampleTimeline('rec_cave20_mainTimeline_t1_211103_020919') }, \type: 'pattern', )),
	(\absTime: 299.75, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;
ClipTimeline('cave20_mainTimeline').recordedEvents = [ PatternEvent((dur: 9.0, event_dropdur: 0.04, playDur: 9.0, midinote: 0.0, type: 'pattern', relDur: 9.0, timeline: { SampleTimeline('rec_cave20_mainTimeline_t0_211103_015255') }, absTime: 0.0, sustain: 5.0)), PatternEvent((playDur: 47.0, dur: 47.0, sustain: 45.0, midinote: 0.0, timeline: { SampleTimeline('rec_cave20_mainTimeline_t0_211103_015633') }, relDur: 47.0, type: 'pattern', absTime: 9.0)), PatternEvent((playDur: 11.0, dur: 11.0, sustain: 10.0, midinote: 1.0, timeline: { SampleTimeline('rec_cave20_mainTimeline_t1_211103_015959') }, relDur: 11.0, type: 'pattern', absTime: 56.0)), PatternEvent((playDur: 13.0, dur: 13.0, sustain: 11.0, midinote: 1, timeline: { SampleTimeline('rec_cave20_mainTimeline_t1_211103_020022') }, relDur: 13.0, type: 'pattern', absTime: 67.0)), PatternEvent((playDur: 73.0, dur: 73.0, sustain: 34.0, midinote: 2, timeline: { SampleTimeline('rec_cave20_mainTimeline_t2_211103_020326') }, relDur: 73.0, type: 'pattern', absTime: 80.0)), PatternEvent((playDur: 0.0, dur: 0.0, sustain: 36.0, midinote: 1.0, timeline: { SampleTimeline('rec_cave20_mainTimeline_t1_211103_020919') }, relDur: 0.0, type: 'pattern', absTime: 164.0)), PatternEvent((playDur: 11.0, dur: 11.0, sustain: 8.0, midinote: 0, timeline: { SampleTimeline('rec_cave20_mainTimeline_t0_211103_021634') }, relDur: 11.0, type: 'pattern', absTime: 153.0)), PatternEvent((dur: 90.0, event_dropdur: 1, playDur: 90.0, midinote: 0.0, type: 'pattern', relDur: 90.0, timeline: { SampleTimeline('rec_cave20_mainTimeline_t0_211103_021802') }, absTime: 164.0, sustain: 75.0)), PatternEvent((playDur: 0.0, dur: 0.0, sustain: 49.0, midinote: 3.0, timeline: { SampleTimeline('rec_cave20_mainTimeline_t3_211103_022901') }, relDur: 0.0, type: 'pattern', absTime: 244.0)), PatternEvent((playDur: 10.0, dur: 10.0, sustain: 42.0, midinote: 0.0, timeline: { SampleTimeline('rec_cave20_mainTimeline_t0_211103_023034') }, relDur: 10.0, type: 'pattern', absTime: 244.0)) ];

SampleTimeline('rec_cave20_mainTimeline_t0_211103_015633').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 45.0, \playDur: 45.0, \relDur: 45.0, \sustain: 0, \type: 'start', ),
	(\absTime: 45.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave20_mainTimeline_t0_211103_015633').buffer = BufDef('cliprec/rec_cave20_mainTimeline_t0_211103_015633.wav');
SampleTimeline('rec_cave20_mainTimeline_t0_211103_015255').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 5.0, \playDur: 5.0, \relDur: 5.0, \sustain: 0, \type: 'start', ),
	(\absTime: 5.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave20_mainTimeline_t0_211103_015255').buffer = BufDef('cliprec/rec_cave20_mainTimeline_t0_211103_015255.wav');
SampleTimeline('rec_cave20_mainTimeline_t1_211103_015959').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 10.0, \playDur: 10.0, \relDur: 10.0, \sustain: 0, \type: 'start', ),
	(\absTime: 10.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave20_mainTimeline_t1_211103_015959').buffer = BufDef('cliprec/rec_cave20_mainTimeline_t1_211103_015959.wav');
SampleTimeline('rec_cave20_mainTimeline_t1_211103_020022').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 11.0, \playDur: 11.0, \relDur: 11.0, \sustain: 0, \type: 'start', ),
	(\absTime: 11.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave20_mainTimeline_t1_211103_020022').buffer = BufDef('cliprec/rec_cave20_mainTimeline_t1_211103_020022.wav');
SampleTimeline('rec_cave20_mainTimeline_t2_211103_020326').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 34.0, \playDur: 34.0, \relDur: 34.0, \sustain: 0, \type: 'start', ),
	(\absTime: 34.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave20_mainTimeline_t2_211103_020326').buffer = BufDef('cliprec/rec_cave20_mainTimeline_t2_211103_020326.wav');
SampleTimeline('rec_cave20_mainTimeline_t0_211103_021802').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 75.0, \playDur: 75.0, \relDur: 75.0, \sustain: 0, \type: 'start', ),
	(\absTime: 75.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave20_mainTimeline_t0_211103_021802').buffer = BufDef('cliprec/rec_cave20_mainTimeline_t0_211103_021802.wav');
SampleTimeline('rec_cave20_mainTimeline_t0_211103_021634').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 8.0, \playDur: 8.0, \relDur: 8.0, \sustain: 0, \type: 'start', ),
	(\absTime: 8.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave20_mainTimeline_t0_211103_021634').buffer = BufDef('cliprec/rec_cave20_mainTimeline_t0_211103_021634.wav');
SampleTimeline('rec_cave20_mainTimeline_t1_211103_020919').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 36.0, \playDur: 36.0, \relDur: 36.0, \sustain: 0, \type: 'start', ),
	(\absTime: 36.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave20_mainTimeline_t1_211103_020919').buffer = BufDef('cliprec/rec_cave20_mainTimeline_t1_211103_020919.wav');
SampleTimeline('rec_cave20_mainTimeline_t0_211103_023034').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 42.0, \playDur: 42.0, \relDur: 42.0, \sustain: 0, \type: 'start', ),
	(\absTime: 42.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave20_mainTimeline_t0_211103_023034').buffer = BufDef('cliprec/rec_cave20_mainTimeline_t0_211103_023034.wav');
SampleTimeline('rec_cave20_mainTimeline_t3_211103_022901').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 49.0, \playDur: 49.0, \relDur: 49.0, \sustain: 0, \type: 'start', ),
	(\absTime: 49.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave20_mainTimeline_t3_211103_022901').buffer = BufDef('cliprec/rec_cave20_mainTimeline_t3_211103_022901.wav');

