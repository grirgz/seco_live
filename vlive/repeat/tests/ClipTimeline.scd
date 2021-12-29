
ClipTimeline(\bla).edit
NoteTimeline(\bla).edit
ParamTimeline(\bla).edit
KitTimeline(\bla).edit
TrackTimeline(\bla).edit
ParamTimeline(\bla).isRecording

/////////// test preview

SampleTimeline(\sss).buffer = BufDef(\amen, "vipere/amenbreak.wav");
SampleTimeline(\sss).edit
ClipTimeline(\bla).edit;

NoteTimeline(\nono).edit

ClipTimeline(\super).edit




(
ClipTimeline('bla').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('bla').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.25, \label: 'start', \playDur: 0.25, \relDur: 0.25, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.25, \dur: 7.75, \legato: 1, \midinote: 2.0, \playDur: 7.75, \relDur: 7.75, \sustain: 3.125, \timeline: { NoteTimeline('nono') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;

NoteTimeline('nono').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.125, \label: 'start', \playDur: 0.125, \relDur: 0.125, \sustain: 0, \type: 'start', ),
	(\absTime: 0.125, \dur: 0.125, \midinote: 73.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 0.25, \dur: 0.25, \midinote: 66.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.5, \dur: 0.25, \midinote: 60.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.75, \dur: 0.375, \midinote: 54.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 1.125, \dur: 0.25, \midinote: 72.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.375, \dur: 0.125, \midinote: 63.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.5, \dur: 0.375, \midinote: 51.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 1.875, \dur: 0.125, \midinote: 47.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);


ClipTimeline(\bla).edit;


);




NoteTimeline(\nono).presetCompileString.editorInsert
ClipTimeline(\bla).presetCompileString.editorInsert

(
NoteTimeline('nono').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.125, \label: 'start', \playDur: 0.125, \relDur: 0.125, \sustain: 0, \type: 'start', ),
	(\absTime: 0.125, \dur: 0.125, \midinote: 73.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 0.25, \dur: 0.25, \midinote: 66.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.5, \dur: 0.25, \midinote: 60.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.75, \dur: 0.375, \midinote: 54.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 1.125, \dur: 0.25, \midinote: 72.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.375, \dur: 0.125, \midinote: 63.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.5, \dur: 0.375, \midinote: 51.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 1.875, \dur: 0.125, \midinote: 47.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);

ClipTimeline('bla').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('bla').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.25, \label: 'start', \playDur: 0.25, \relDur: 0.25, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.25, \dur: 2.75, \legato: 1, \midinote: 2.0, \playDur: 2.75, \relDur: 2.75, \sustain: 3.125, \timeline: { NoteTimeline('nono') }, \type: 'pattern', )),
	PatternEvent((\absTime: 3.0, \dur: 5.0, \legato: 1, \midinote: 1.0, \playDur: 5.0, \relDur: 5.0, \sustain: 4.25, \timeline: { SampleTimeline('sss') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;

SampleTimeline('sss').eventList = TimelineEventList.newFrom([
	(\absTime: 0.375, \dur: 0.625, \label: 'start', \playDur: 0.625, \relDur: 0.625, \sustain: 0, \type: 'start', ),
	(\absTime: 1.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);


);


/////////////////

ClipTimeline(\bla2).edit
