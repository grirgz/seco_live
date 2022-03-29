ClipTimeline('cave37_rec1').presetCompileStringSavePath = "repeat/cavern/ClipTimeline_cave37_rec1.scd";

ClipTimeline('cave37_rec1').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': true ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': BusDef('trackMixerDef_record_fxmixer1'), 'muted': false ), ( 'index': 3, 'recordArmed': true, 'recordBus': BusDef('trackMixerDef_record_fxmixer2'), 'muted': false ), ( 'muted': false, 'recordBus': BusDef('trackMixerDef_record_fxmixer3'), 'index': 4, 'recordArmed': false, 
  'solo': false ), ( 'muted': true, 'recordBus': 0, 'index': 5, 'recordArmed': false, 
  'solo': false ) ];
{
ClipTimeline('cave37_rec1').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 16.0, \midinote: 0.0, \outBus: BusDef('mixer0'), \playDur: 16.0, \relDur: 16.0, \sustain: 232.0, \timeline: { SampleTimeline('rec_cave37_rec1_t0_220311_014225') }, \type: 'pattern', )),
	(\absTime: 16.0, \dur: 20.0, \legato: 1, \midinote: 2.0, \playDur: 20.0, \relDur: 20.0, \sustain: 0.025, ),
	PatternEvent((\absTime: 36.0, \dur: 80.0, \midinote: 1.0, \playDur: 80.0, \relDur: 80.0, \sustain: 80.0, \timeline: { SampleTimeline('rec_cave37_rec1_t1_220320_003520') }, \type: 'pattern', )),
	PatternEvent((\absTime: 116.0, \dur: 0.0, \midinote: 1.0, \playDur: 0.0, \relDur: 0.0, \sustain: 115.96, \timeline: { SampleTimeline('rec_cave37_rec1_t1_220320_003520') }, \type: 'pattern', )),
	PatternEvent((\absTime: 116.0, \dur: 1.4210854715202e-14, \midinote: 2.0, \playDur: 1.4210854715202e-14, \relDur: 1.4210854715202e-14, \sustain: 64.0, \timeline: { SampleTimeline('rec_cave37_rec1_t2_220320_011531') }, \type: 'pattern', )),
	PatternEvent((\absTime: 116.0, \dur: 4.0, \midinote: 4, \playDur: 4.0, \relDur: 4.0, \sustain: 92.0, \timeline: { SampleTimeline('rec_cave37_rec1_t4_220320_012621') }, \type: 'pattern', )),
	PatternEvent((\absTime: 120.0, \dur: 0.0, \midinote: 3.0, \playDur: 0.0, \relDur: 0.0, \sustain: 96.0, \timeline: { SampleTimeline('rec_cave37_rec1_t3_220320_014627') }, \type: 'pattern', )),
	PatternEvent((\absTime: 120.0, \dur: 112.0, \midinote: 5.0, \playDur: 112.0, \relDur: 112.0, \sustain: 92.0, \timeline: { SampleTimeline('rec_cave37_rec1_t3_220320_012621') }, \type: 'pattern', )),
	(\absTime: 232.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;
ClipTimeline('cave37_rec1').recordedEvents = [ PatternEvent((dur: 16.0, outBus: BusDef('mixer0'), playDur: 16.0, midinote: 0.0, type: 'pattern', relDur: 16.0, timeline: { SampleTimeline('rec_cave37_rec1_t0_220311_014225') }, absTime: 0.0, sustain: 42.0)), PatternEvent((playDur: 7.96, dur: 7.96, sustain: 116.0, midinote: 1, timeline: { SampleTimeline('rec_cave37_rec1_t1_220320_003520') }, relDur: 7.96, type: 'pattern', absTime: 0.04)), PatternEvent((playDur: 8.0, dur: 8.0, sustain: 64.0, midinote: 2.0, timeline: { SampleTimeline('rec_cave37_rec1_t2_220320_011531') }, relDur: 8.0, type: 'pattern', absTime: 8.0)), PatternEvent((playDur: 116.0, dur: 116.0, sustain: 72.0, midinote: 3, timeline: { SampleTimeline('rec_cave37_rec1_t3_220320_012250') }, relDur: 116.0, type: 'pattern', absTime: 116.0)), PatternEvent((playDur: 116.0, dur: 116.0, sustain: 72.0, midinote: 4, timeline: { SampleTimeline('rec_cave37_rec1_t4_220320_012250') }, relDur: 116.0, type: 'pattern', absTime: 116.0)), PatternEvent((playDur: 112.0, dur: 112.0, sustain: 92.0, midinote: 5.0, timeline: { SampleTimeline('rec_cave37_rec1_t3_220320_012621') }, relDur: 112.0, type: 'pattern', absTime: 120.0)), PatternEvent((playDur: 4.0, dur: 4.0, sustain: 92.0, midinote: 4, timeline: { SampleTimeline('rec_cave37_rec1_t4_220320_012621') }, relDur: 4.0, type: 'pattern', absTime: 116.0)), PatternEvent((playDur: 4.0, dur: 4.0, sustain: 12.0, midinote: 3, timeline: { SampleTimeline('rec_cave37_rec1_t3_220320_014529') }, relDur: 4.0, type: 'pattern', absTime: 112.0)), PatternEvent((playDur: 0.0, dur: 0.0, sustain: 96.0, midinote: 3.0, timeline: { SampleTimeline('rec_cave37_rec1_t3_220320_014627') }, relDur: 0.0, type: 'pattern', absTime: 120.0)) ];

SampleTimeline('rec_cave37_rec1_t4_220320_012621').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 91.978884353741, \label: 'start', \playDur: 91.978884353741, \relDur: 91.978884353741, \sustain: 0, \type: 'start', ),
	(\absTime: 91.978884353741, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave37_rec1_t4_220320_012621').buffer = BufDef('cliprec/rec_cave37_rec1_t4_220320_012621.wav');
SampleTimeline('rec_cave37_rec1_t0_220311_014225').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 50.40587755102, \label: 'start', \playDur: 50.40587755102, \relDur: 50.40587755102, \sustain: 0, \type: 'start', ),
	(\absTime: 50.40587755102, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave37_rec1_t0_220311_014225').buffer = BufDef('cliprec/rec_cave37_rec1_t0_220311_014225.wav');
SampleTimeline('rec_cave37_rec1_t2_220320_011531').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 64.003482993197, \label: 'start', \playDur: 64.003482993197, \relDur: 64.003482993197, \sustain: 0, \type: 'start', ),
	(\absTime: 64.003482993197, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave37_rec1_t2_220320_011531').buffer = BufDef('cliprec/rec_cave37_rec1_t2_220320_011531.wav');
SampleTimeline('rec_cave37_rec1_t1_220320_003520').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 115.9697414966, \label: 'start', \playDur: 115.9697414966, \relDur: 115.9697414966, \sustain: 0, \type: 'start', ),
	(\absTime: 115.9697414966, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave37_rec1_t1_220320_003520').buffer = BufDef('cliprec/rec_cave37_rec1_t1_220320_003520.wav');
SampleTimeline('rec_cave37_rec1_t3_220320_014627').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 95.991292517007, \playDur: 95.991292517007, \relDur: 95.991292517007, \sustain: 0, \type: 'start', ),
	(\absTime: 95.991292517007, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave37_rec1_t3_220320_014627').buffer = BufDef('cliprec/rec_cave37_rec1_t3_220320_014627.wav');
SampleTimeline('rec_cave37_rec1_t3_220320_012621').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 91.978884353741, \playDur: 91.978884353741, \relDur: 91.978884353741, \sustain: 0, \type: 'start', ),
	(\absTime: 91.978884353741, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave37_rec1_t3_220320_012621').buffer = BufDef('cliprec/rec_cave37_rec1_t3_220320_012621.wav');

