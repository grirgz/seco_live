

TrackDef('glu2_mainTrackList').childAt(5, 1).score = ClipTimeline('glu2_mainTrackList.5.1score');
ClipTimeline('glu2_mainTrackList.5.1score').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'recordSourceLabel': "lastTweaked", 'muted': false, 'index': 1, 'recordArmed': false, 
  'recordBus': 0, 'recordSource': 'lastTweaked' ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'recordSourceLabel': "lastTweaked", 'muted': false, 'index': 4, 'recordArmed': true, 
  'recordBus': 0, 'recordSource': 'lastTweaked', 'solo': false ) ];
{
ClipTimeline('glu2_mainTrackList.5.1score').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \legato: 1, \midinote: 2.0, \pattern: Pdef('fx_nimp1'), \playDur: 0.0, \relDur: 0.0, \sustain: 16.0, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 14.0, \midinote: 4.0, \playDur: 14.0, \relDur: 14.0, \sustain: 16.0, \timeline: { ParamTimeline('rec_glu2_mainTrackList.5.1score_t4_250507_214035') }, \type: 'pattern', )),
	PatternEvent((\absTime: 14.0, \dur: 0.25, \legato: 1, \midinote: 0.0, \pattern: Pdef('trans1'), \playDur: 0.25, \relDur: 0.25, \sustain: 2.0, \type: 'pattern', )),
	PatternEvent((\absTime: 14.25, \dur: 1.75, \legato: 1, \midinote: 3.0, \playDur: 1.75, \relDur: 1.75, \sustain: 1.875, \timeline: { SampleTimeline('claprev') }, \type: 'pattern', )),
	(\absTime: 16.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;
ClipTimeline('glu2_mainTrackList.5.1score').recordedEvents = [ PatternEvent((playDur: 14.0, dur: 14.0, sustain: 16.0, midinote: 1.0, timeline: { ParamTimeline('rec_glu2_mainTrackList.5.1score_t1_250505_023849') }, relDur: 14.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 14.0, dur: 14.0, sustain: 16.0, midinote: 4.0, timeline: { ParamTimeline('rec_glu2_mainTrackList.5.1score_t4_250507_214035') }, relDur: 14.0, type: 'pattern', absTime: 0.0)) ];

SampleTimeline('claprev').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \label: 'start', \playDur: 8, \relDur: 8, \sustain: 0, \type: 'start', ),
	(\absTime: 1.7779297006243, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('claprev').buffer = BufDef('reckit/ramp/clap.flac');
SampleTimeline('claprev').postPatternPreset = ( 'gain': 0.12249443207127 );


