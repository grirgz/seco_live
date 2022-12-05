ClipTimeline('cave44_mainTimeline').presetCompileStringSavePath = "repeat/cavern/cave44/data/ClipTimeline_cave44_mainTimeline.scd";

ClipTimeline('cave44_mainTimeline').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'muted': false, 'recordBus': 0, 'index': 4, 'recordArmed': false, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 5, 'recordArmed': false, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 6, 'recordArmed': false, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 7, 'recordArmed': true, 
  'solo': false ) ];
{
ClipTimeline('cave44_mainTimeline').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PlayerEvent((\absTime: 0.0, \dur: 8.0, \legato: 1, \midinote: 0.0, \playDur: 8.0, \receiver: PlayerWrapper(Ndef('fond1')), \relDur: 8.0, \sustain: 32.0, \type: 'player', )),
	PlayerEvent((\absTime: 8.0, \dur: 7.5, \legato: 1, \midinote: 1.0, \playDur: 7.5, \receiver: PlayerWrapper(Ndef('fond2')), \relDur: 7.5, \sustain: 24.0, \type: 'player', )),
	PatternEvent((\absTime: 15.5, \dur: 0.5, \legato: 1, \midinote: 6.0, \pattern: Pdef('kick1'), \playDur: 0.5, \relDur: 0.5, \sustain: 1.0, \type: 'pattern', )),
	PlayerEvent((\absTime: 16.0, \dur: 16.0, \legato: 1, \midinote: 2.0, \playDur: 16.0, \receiver: PlayerWrapper(Ndef('treb1')), \relDur: 16.0, \sustain: 16.0, \type: 'player', )),
	PatternEvent((\absTime: 32.0, \dur: 0.0, \legato: 1, \midinote: 3.0, \playDur: 0.0, \relDur: 0.0, \sustain: 64.0, \timeline: { SampleTimeline('bla') }, \type: 'pattern', )),
	PlayerEvent((\absTime: 32.0, \dur: 0.0, \event_dropdur: 8.0, \label: "fond1-8", \legato: 1, \midinote: 0.0, \playDur: 0.0, \receiver: PlayerWrapper(Ndef('fond1')), \relDur: 0.0, \sustain: 24.0, \type: 'player', )),
	PlayerEvent((\absTime: 32.0, \dur: 32.0, \legato: 1, \midinote: 1.0, \playDur: 32.0, \receiver: PlayerWrapper(Ndef('fond2')), \relDur: 32.0, \sustain: 24.0, \type: 'player', )),
	PlayerEvent((\absTime: 64.0, \dur: 4.0, \legato: 1, \midinote: 4.0, \playDur: 4.0, \receiver: PlayerWrapper(Ndef('chord1')), \relDur: 4.0, \sustain: 16.0, \type: 'player', )),
	PlayerEvent((\absTime: 68.0, \dur: 12.0, \legato: 1, \midinote: 0.0, \playDur: 12.0, \receiver: PlayerWrapper(Ndef('fond1')), \relDur: 12.0, \sustain: 12.0, \type: 'player', )),
	PlayerEvent((\absTime: 80.0, \dur: 8.0, \legato: 1, \midinote: 5.0, \playDur: 8.0, \receiver: PlayerWrapper(Ndef('chord2')), \relDur: 8.0, \sustain: 16.0, \type: 'player', )),
	PlayerEvent((\absTime: 88.0, \dur: 9.5, \legato: 1, \midinote: 4.0, \playDur: 9.5, \receiver: PlayerWrapper(Ndef('chord1')), \relDur: 9.5, \sustain: 8.0, \type: 'player', )),
	PatternEvent((\absTime: 97.5, \dur: 0.5, \legato: 1, \midinote: 6.0, \pattern: Pdef('kick1'), \playDur: 0.5, \relDur: 0.5, \sustain: 1.0, \type: 'pattern', )),
	PlayerEvent((\absTime: 98.0, \dur: 0.0, \legato: 1, \midinote: 2.0, \playDur: 0.0, \receiver: PlayerWrapper(Ndef('treb1')), \relDur: 0.0, \sustain: 64.0, \type: 'player', )),
	PlayerEvent((\absTime: 98.0, \dur: 0.0, \legato: 1, \midinote: 4.0, \playDur: 0.0, \receiver: PlayerWrapper(Ndef('chord1')), \relDur: 0.0, \sustain: 64.0, \type: 'player', )),
	PatternEvent((\absTime: 98.0, \dur: 0.0, \legato: 1, \midinote: 3.0, \playDur: 0.0, \relDur: 0.0, \sustain: 64.0, \timeline: { SampleTimeline('bla') }, \type: 'pattern', )),
	PlayerEvent((\absTime: 98.0, \dur: 0.0, \legato: 1, \midinote: 0.0, \playDur: 0.0, \receiver: PlayerWrapper(Ndef('fond1')), \relDur: 0.0, \sustain: 64.0, \type: 'player', )),
	PlayerEvent((\absTime: 98.0, \dur: 0.0, \legato: 1, \midinote: 5.0, \playDur: 0.0, \receiver: PlayerWrapper(Ndef('chord2')), \relDur: 0.0, \sustain: 64.0, \type: 'player', )),
	PlayerEvent((\absTime: 98.0, \dur: 64.0, \legato: 1, \midinote: 1.0, \playDur: 64.0, \receiver: PlayerWrapper(Ndef('fond2')), \relDur: 64.0, \sustain: 64.0, \type: 'player', )),
	PatternEvent((\absTime: 162.0, \dur: 1.0, \legato: 1, \midinote: 6.0, \pattern: Pdef('kick1'), \playDur: 1.0, \relDur: 1.0, \sustain: 1.0, \type: 'pattern', )),
	PlayerEvent((\absTime: 163.0, \dur: 0.0, \legato: 1, \midinote: 0.0, \playDur: 0.0, \receiver: PlayerWrapper(Ndef('fond1p2')), \relDur: 0.0, \sustain: 29.0, \type: 'player', )),
	PatternEvent((\absTime: 163.0, \dur: 70.0, \midinote: 7, \playDur: 70.0, \relDur: 70.0, \sustain: 70.0, \timeline: { SampleTimeline('rec_cave44_mainTimeline_t7_220721_021109') }, \type: 'pattern', )),
	(\absTime: 233.0, \dur: 87.0, \label: 'end', \playDur: 87.0, \relDur: 87.0, \type: 'end', ),
	(\absTime: 320.0, \dur: 0, \label: "unnamed", \playDur: 0, \relDur: 0, \type: 'locator', ),
]);
 }.value;
ClipTimeline('cave44_mainTimeline').recordedEvents = [ PatternEvent((playDur: 70.0, dur: 70.0, sustain: 70.0, midinote: 7, timeline: { SampleTimeline('rec_cave44_mainTimeline_t7_220721_021109') }, relDur: 70.0, type: 'pattern', absTime: 163.0)) ];

SampleTimeline('bla').eventList = TimelineEventList.newFrom([
	(\absTime: 2.0, \dur: 121.0, \label: 'start', \playDur: 121.0, \relDur: 121.0, \sustain: 0, \type: 'start', ),
	(\absTime: 123.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('bla').buffer = BufDef('cliprec/rec_bla_220721_012252.wav');
SampleTimeline('rec_cave44_mainTimeline_t7_220721_021109').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 70.0, \playDur: 70.0, \relDur: 70.0, \sustain: 0, \type: 'start', ),
	(\absTime: 70.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave44_mainTimeline_t7_220721_021109').buffer = BufDef('cliprec/rec_cave44_mainTimeline_t7_220721_021109.wav');

