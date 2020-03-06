ClipTimeline('vin12_p1').presetCompileStringSavePath = "capsule/ClipTimeline_vin12_p1.scd";

ClipTimeline('vin12_p1').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': true ), ( 'index': 1, 'recordArmed': true, 'recordBus': BusDef(\mixer0), 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 4, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 5, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 6, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 7, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
ClipTimeline('vin12_p1').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \label: 'rec_intro_perc', \midinote: 3.0, \playDur: 0.0, \relDur: 0.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_vin12_p1_t2_200216_192348') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \label: 'rec_perc1ghost', \midinote: 6.0, \playDur: 0.0, \relDur: 0.0, \sustain: 114.0, \timeline: { SampleTimeline('rec_vin12_p1_t1_200216_211303') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 5.75, \event_dropdur: 2, \label: 'rec_intro2', \midinote: 1.0, \playDur: 5.75, \relDur: 5.75, \sustain: 4.0, \timeline: { SampleTimeline('rec_vin12_p1_t1_200216_212021') }, \type: 'pattern', )),
	PatternEvent((\absTime: 5.75, \dur: 2.25, \legato: 1, \midinote: 4.0, \playDur: 2.25, \relDur: 2.25, \sustain: 96.25, \timeline: { SampleTimeline('wishing') }, \type: 'pattern', )),
	PatternEvent((\absTime: 8.0, \dur: 0.0, \legato: 1, \midinote: 0.0, \pattern: Pdef('part'), \playDur: 0.0, \relDur: 0.0, \sustain: 99.75, \type: 'pattern', )),
	PatternEvent((\absTime: 8.0, \dur: 0.0, \label: 'rec_perc_basic', \midinote: 5.0, \playDur: 0.0, \relDur: 0.0, \sustain: 108.0, \timeline: { SampleTimeline('rec_vin12_p1_t2_200216_193941') }, \type: 'pattern', )),
	PatternEvent((\absTime: 8.0, \dur: 108.0, \event_dropdur: 2, \label: 'rec_bass', \midinote: 2.0, \playDur: 108.0, \relDur: 108.0, \sustain: 96.0, \timeline: { SampleTimeline('rec_vin12_p1_t1_200216_195941') }, \type: 'pattern', )),
	(\absTime: 116.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);