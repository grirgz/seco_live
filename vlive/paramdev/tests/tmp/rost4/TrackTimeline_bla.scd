TrackTimeline('bla').presetCompileStringSavePath = "paramdev/tests/tmp/rost4/TrackTimeline_bla.scd";

TrackTimeline('bla').tracks = TrackDef('bla');
{
TrackTimeline('bla').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 3.75, \label: 'start', \playDur: 3.75, \relDur: 3.75, \sustain: 0, \type: 'start', ),
	PlayerEvent((\absTime: 3.75, \dur: 4.25, \legato: 1, \midinote: 0.0, \playDur: 4.25, \receiver: PlayerWrapper(TrackDef('bla').sectionAt(0)), \relDur: 4.25, \sustain: 1.0, \type: 'player', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;



