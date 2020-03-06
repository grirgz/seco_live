ClipTimeline('vin15').presetCompileStringSavePath = "capsule/ClipTimeline_vin15.scd";

ClipTimeline('vin15').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': true, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': BusDef(\trackMixerDef_mixer1), 'muted': false ), ( 'index': 4, 'recordArmed': false, 'recordBus': BusDef(\trackMixerDef_mixer2), 'muted': false ), ( 'index': 5, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
ClipTimeline('vin15').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 5.0, \midinote: 0, \playDur: 5.0, \relDur: 5.0, \sustain: 9.0, \timeline: { SampleTimeline('rec_vin15_t0_200229_204549') }, \type: 'pattern', )),
	PatternEvent((\absTime: 5.0, \dur: 4.0, \event_dropdur: 0, \label: "rec_vin15_t0_200229_203731-6", \midinote: 1.0, \playDur: 4.0, \relDur: 4.0, \sustain: 4.0, \timeline: { SampleTimeline('rec_vin15_t0_200229_203731') }, \type: 'pattern', )),
	PatternEvent((\absTime: 9.0, \dur: 22.0, \midinote: 2.0, \playDur: 22.0, \relDur: 22.0, \sustain: 22.0, \timeline: { SampleTimeline('rec_vin15_t2_200229_210804') }, \type: 'pattern', )),
	(\absTime: 31.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
ClipTimeline('vin15').recordedEvents = [ PatternEvent((playDur: 6.0, dur: 6.0, sustain: 6.0, midinote: 0, timeline: { SampleTimeline('rec_vin15_t0_200229_203731') }, relDur: 6.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 5.0, dur: 5.0, sustain: 9.0, midinote: 0, timeline: { SampleTimeline('rec_vin15_t0_200229_204549') }, relDur: 5.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 5.0, dur: 5.0, sustain: 30.0, midinote: 2, timeline: { SampleTimeline('rec_vin15_t2_200229_205535') }, relDur: 5.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 5.0, dur: 5.0, sustain: 30.0, midinote: 3, timeline: { SampleTimeline('rec_vin15_t3_200229_205535') }, relDur: 5.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 5.0, dur: 5.0, sustain: 30.0, midinote: 4, timeline: { SampleTimeline('rec_vin15_t4_200229_205535') }, relDur: 5.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 5.0, dur: 5.0, sustain: 4.0, midinote: 2, timeline: { SampleTimeline('rec_vin15_t2_200229_210654') }, relDur: 5.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 5.0, dur: 5.0, sustain: 4.0, midinote: 3, timeline: { SampleTimeline('rec_vin15_t3_200229_210654') }, relDur: 5.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 5.0, dur: 5.0, sustain: 4.0, midinote: 4, timeline: { SampleTimeline('rec_vin15_t4_200229_210654') }, relDur: 5.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 22.0, dur: 22.0, sustain: 22.0, midinote: 2.0, timeline: { SampleTimeline('rec_vin15_t2_200229_210804') }, relDur: 22.0, type: 'pattern', absTime: 9.0)) ];

SampleTimeline('rec_vin15_t2_200229_210804').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 22.0, \playDur: 22.0, \relDur: 22.0, \sustain: 0, \type: 'start', ),
	(\absTime: 22.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin15_t2_200229_210804').buffer = BufDef('./rec_vin15_t2_200229_210804.wav');
SampleTimeline('rec_vin15_t0_200229_204549').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 16.0, \playDur: 16.0, \relDur: 16.0, \sustain: 0, \type: 'start', ),
	(\absTime: 16.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin15_t0_200229_204549').buffer = BufDef('./rec_vin15_t0_200229_204549.wav');
SampleTimeline('rec_vin15_t0_200229_203731').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 10.0, \label: 'start', \playDur: 10.0, \relDur: 10.0, \sustain: 0, \type: 'start', ),
	(\absTime: 10.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin15_t0_200229_203731').buffer = BufDef('./rec_vin15_t0_200229_203731.wav');

