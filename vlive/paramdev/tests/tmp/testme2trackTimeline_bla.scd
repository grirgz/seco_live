TrackTimeline('bla').presetCompileStringSavePath = "paramdev/tests/tmp/testme2trackTimeline_bla.scd";

TrackTimeline('bla').tracks = TrackDef('bla');
{
TrackTimeline('bla').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 2.625, \label: 'start', \playDur: 2.625, \relDur: 2.625, \sustain: 0, \type: 'start', ),
	PlayerEvent((\absTime: 2.625, \dur: 5.375, \legato: 1, \midinote: 0.0, \playDur: 5.375, \receiver: PlayerWrapper(TrackDef('bla').sectionAt(0)), \relDur: 5.375, \sustain: 2.5, \type: 'player', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;



