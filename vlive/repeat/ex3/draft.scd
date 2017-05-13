
~a = [1,2,3]
~a.extend(10)
~a
~a = SparseArray[1,2,3]
~a.size
~a.extend(10)
Array.edit
SparseArray.gui
Array.gui

ParamProto.init(true)

(
PatKitDef(\test2).targets = [
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix3/kick1.flac'))),
	StepEvent.newFrom((instrument: 'playersec', adsr: Env([ 0, 1, 1, 0 ], [ 0.004, 0, 0.01 ], [ -4, -4, -4 ], 2), bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix3/kick1.flac'), pos: 0.08)),
	nil,
	nil,
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix3/snare1.flac'))),
	nil,
	nil,
	nil,
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('my3/snare2.flac'), pos: 0.031065759637188, sustain: 1)),
	nil,
	nil,
	nil,
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix1/hat.flac'))),
	StepEvent.newFrom((adsr: Env([ 0, 1, 1, 0 ], [ 0.01, 0, 0.1 ], [ -4, -4, -4 ], 2), speed: 1.000875, bufnum: BufDef('fix3/hurl.flac'), instrument: 'playersec', gain: 0.70786947024746, sustain: 1, pos: 0.25433106575964)),
];
);
PatKitDef(\test2).edit
PatKitDef(\test2).presetCompileString.editorInsert
(
PatKitDef(\test2).targets = [
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix3/kick1.flac'))),
	StepEvent.newFrom((instrument: 'playersec', adsr: Env([ 0, 1, 1, 0 ], [ 0.004, 0, 0.01 ], [ -4, -4, -4 ], 2), bufnum: BufDef('fix3/kick1.flac'), pos: 0.08)),
	nil,
	nil,
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix3/snare1.flac'))),
	nil,
	nil,
	nil,
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('my3/snare2.flac'), pos: 0.031065759637188, sustain: 1)),
	nil,
	nil,
	nil,
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix1/hat.flac'))),
	StepEvent.newFrom((adsr: Env([ 0, 1, 1, 0 ], [ 0.01, 0, 0.1 ], [ -4, -4, -4 ], 2), speed: 1.000875, bufnum: BufDef('fix1/hat.flac'), instrument: 'playersec', gain: 0.70786947024746, sustain: 1, pos: 0.25433106575964)),
	StepEvent.newFrom((instrument: 'playersec', gain: 0.6601092936861, bufnum: BufDef('fix1/hat.flac'), lag: 0)),
];
);

\adsr.asSpec

SCDoc.renderAll
Param(Pdef(\plop), \bla).asCompileString
Param(Pdef(\plop), \bla).asString
SCDoc.indexAllDocuments
SCDoc.parseFileFull("/home/ggz/.local/share/SuperCollider/Extensions/param/HelpSource/Classes/Param.schelp")

KitTimeline(\tcha, PatKitDef(\test2));
KitTimeline(\tcha).edit;
KitTimeline(\tchaki, PatKitDef(\test2));
KitTimeline(\tchaki).edit;
NoteTimeline(\tchak)
NoteTimeline(\tchaki, Param(Pdef(\babass), \midinote)).edit
KitTimeline(\tcha).presetCompileString.editorInsert
(
KitTimeline('tcha').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 0.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.25, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 0.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.5, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 0.5, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 1.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 1.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 1.25, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 1.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 1.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 2.0, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 2.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.25, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 2.25, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.5, \dur: 0.125, \kitIndex: 13.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 2.625, \dur: 0.125, \kitIndex: 1.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 2.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 3.0, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 3.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 3.25, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 3.5, \dur: 0.25, \kitIndex: 14.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 3.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 4.0, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 4.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 4.25, \dur: 0.25, \kitIndex: 14.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 4.5, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 4.5, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 4.75, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 4.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 5.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 5.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 5.25, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 5.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 5.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 6.0, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 6.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 6.25, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 6.25, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 6.5, \dur: 0.125, \kitIndex: 13.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 6.625, \dur: 0.125, \kitIndex: 1.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 6.75, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 6.75, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 7.0, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 7.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 7.25, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 7.5, \dur: 0.25, \kitIndex: 14.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 7.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 8.0, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 8.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 8.25, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 8.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 8.5, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 8.5, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 8.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 9.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 9.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 9.25, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 9.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 9.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 10.0, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 10.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 10.25, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 10.25, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 10.5, \dur: 0.125, \kitIndex: 13.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 10.625, \dur: 0.125, \kitIndex: 1.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 10.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 11.0, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 11.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 11.25, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 11.5, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 11.5, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 11.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 12.0, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 12.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 12.25, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 12.25, \dur: 0.25, \kitIndex: 8.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 12.5, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 12.5, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 12.75, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 12.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 13.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 13.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 13.25, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 13.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 13.75, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 13.75, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 14.0, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 14.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 14.25, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 14.25, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 14.5, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 14.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 14.75, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 14.75, \dur: 0.125, \kitIndex: 1.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 14.875, \dur: 0.125, \kitIndex: 1.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 15.0, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 15.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 15.25, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 15.25, \dur: 0.125, \kitIndex: 8.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 15.375, \dur: 0.375, \kitIndex: 14.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 15.75, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 15.75, \dur: 0.25, \kitIndex: 8.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 16.0, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 16.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 16.25, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 16.25, \dur: 0.0, \kitIndex: 8.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 16.25, \dur: 0.125, \kitIndex: 1.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 16.375, \dur: 0.125, \kitIndex: 1.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 16.5, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 16.5, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 16.75, \dur: 0.0, \kitIndex: 8.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 16.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 17.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 17.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 17.25, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 17.25, \dur: 0.125, \kitIndex: 0.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 17.375, \dur: 0.125, \kitIndex: 1.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 17.5, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 17.5, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 17.75, \dur: 0.125, \kitIndex: 13.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 17.875, \dur: 0.125, \kitIndex: 8.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 18.0, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 18.0, \dur: 0.125, \kitIndex: 0.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 18.125, \dur: 0.125, \kitIndex: 8.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 18.25, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 18.25, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 18.5, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 18.5, \dur: 0.125, \kitIndex: 8.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 18.625, \dur: 0.125, \kitIndex: 1.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 18.75, \dur: 0.125, \kitIndex: 13.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 18.875, \dur: 0.125, \kitIndex: 4.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 19.0, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 19.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 19.25, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 19.5, \dur: 0.25, \kitIndex: 14.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 19.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 20.0, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 20.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 20.25, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 20.25, \dur: 0.125, \kitIndex: 1.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 20.375, \dur: 0.125, \kitIndex: 8.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 20.5, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 20.5, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 20.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 21.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 21.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 21.25, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 21.25, \dur: 0.25, \kitIndex: 8.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 21.5, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 21.625, \dur: 0.125, \kitIndex: 8.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 21.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 22.0, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 22.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 22.0, \dur: 0.25, \kitIndex: 8.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 22.25, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 22.25, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 22.5, \dur: 0.125, \kitIndex: 13.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 22.625, \dur: 0.125, \kitIndex: 1.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 22.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 23.0, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 23.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 23.25, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 23.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 23.5, \dur: 0.0, \kitIndex: 1.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 23.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 23.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 24.0, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 24.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 24.25, \dur: 0.0, \kitIndex: 8.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 24.25, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 24.25, \dur: 0.125, \kitIndex: 1.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 24.375, \dur: 0.125, \kitIndex: 1.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 24.5, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 24.5, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 24.75, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 24.75, \dur: 0.25, \kitIndex: 8.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 25.0, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 25.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 25.25, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 25.25, \dur: 0.0, \kitIndex: 0.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 25.25, \dur: 0.125, \kitIndex: 4.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 25.375, \dur: 0.125, \kitIndex: 1.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 25.5, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 25.5, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 25.75, \dur: 0.125, \kitIndex: 13.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 25.875, \dur: 0.125, \kitIndex: 8.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 26.0, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 26.0, \dur: 0.125, \kitIndex: 0.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 26.125, \dur: 0.125, \kitIndex: 8.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 26.25, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 26.25, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 26.5, \dur: 0.0, \kitIndex: 8.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 26.5, \dur: 0.125, \kitIndex: 13.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 26.625, \dur: 0.125, \kitIndex: 1.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 26.75, \dur: 0.125, \kitIndex: 13.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 26.875, \dur: 0.125, \kitIndex: 4.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 27.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 27.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 27.25, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 27.5, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 27.5, \dur: 0.25, \kitIndex: 8.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 27.75, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 27.75, \dur: 0.25, \kitIndex: 8.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 28.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 28.0, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 28.25, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 28.25, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 28.25, \dur: 0.25, \kitIndex: 8.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 28.5, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 28.5, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 28.5, \dur: 0.25, \kitIndex: 8.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 28.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 29.0, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 29.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 29.25, \dur: 0.0, \kitIndex: 8.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 29.25, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 29.5, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 29.5, \dur: 0.25, \kitIndex: 8.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 29.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 30.0, \dur: 0.0, \kitIndex: 8.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 30.0, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 30.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 30.25, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 30.25, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 30.25, \dur: 0.25, \kitIndex: 8.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 30.5, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 30.5, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 30.5, \dur: 0.25, \kitIndex: 4.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 30.75, \dur: 0.0, \kitIndex: 4.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 30.75, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 30.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 31.0, \dur: 0.0, \kitIndex: 4.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 31.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 31.25, \dur: 0.125, \kitIndex: 0.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 31.375, \dur: 0.125, \kitIndex: 8.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 31.5, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 31.5, \dur: 0.125, \kitIndex: 1.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 31.625, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 31.75, \dur: 0.0, \kitIndex: 4.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 31.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 32.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);



/////////////////////////
(
SynthDef(\babass2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * ( 1 + ( SinOsc.ar(freq*4 * LFSaw.kr(11).range(1.2,1)) * 0.61 ))) * 1 )));
	sig = sig + SinOsc.ar(freq + [1,2,3,4]);
	sig = sig + LFCub.ar(freq * 2,mul:1/1);
	sig = sig*2;
	sig = sig.tanh;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;

SynthDef(\babass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * ( 1 + ( SinOsc.ar(freq * LFSaw.kr(11).range(1.2,1)) * \fmamp1.kr(0.61) ))) * \fmamp2.kr(1) )));
	//sig = 0;
	sig = sig + SinOsc.ar(freq * [2,1,1/2]);
	//sig = sig + LFCub.ar(freq * 2,mul:1/1);
	//sig = sig*2;
	//sig = sig.tanh;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;

SynthDef(\skakitri, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bpfreq=1400, bprq=0.1;
	var sig;
	sig = LFSaw.ar(freq * [0,3,7].midiratio);
	sig = sig + SinOsc.ar(freq + [1,2,3,4]);
	sig = LPF.ar(sig, freq*2);
	sig = BPF.ar(sig, bpfreq, bprq) + sig;
	sig = sig/2;
	//sig = sig.tanh/4;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,\rel.kr(0.01)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;

SynthDef(\skaki, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bpfreq=1400, bprq=0.1;
	var sig;
	sig = LFSaw.ar(freq);
	sig = sig + SinOsc.ar(freq + [1,2,3,4]);
	sig = LPF.ar(sig, freq*1.6);
	sig = BPF.ar(sig, bpfreq, bprq) + sig;
	sig = sig/2;
	//sig = sig.tanh/4;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,\rel.kr(0.01)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\babass, Pbind(
	\instrument, \babass,
	\degree, Pseq([0,2],inf),
	\octave, 3,
	\dur, 1,
	\amp, 0.1
)).play;
);

(
Pdef(\skaki, Pbind(
	\instrument, \skaki,
	\degree, Pseq([0,0],inf).stutter(8),
	\octave, 5,
	\bpfreq, Ndef(\skaki_bpfreq, { SinOsc.kr(1/9).range(14000,51) }),
	//\rel, Ndef(\skaki_rel, { SinOsc.kr(1/4).range(0.4,0.051) }),
	\rel, Pseq([
		0.1, 0.1, 0.1, 0.1,
		0.1, 0.1, 0.1, 0.1,
		0.1, 0.1, 0.1, 0.1,
		0.1, 0.1, 0.4, 0.4,
	],inf),
//	\isRest, Pseq([
//		0,0,1,0, 0,0,1,0,
//		0,1,1,0, 0,0,1,0,
//	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
));
);
Pdef(\skaki).stop

NoteTimeline(\tchaki, Param(Pdef(\babass), \midinote)).edit
NoteTimeline(\skaki).clear
NoteTimeline(\skaki, Param(Pdef(\skaki), \midinote)).edit
KitTimeline(\tchaki, PatKitDef(\test2));
KitTimeline(\tchaki).edit;
KitTimeline(\tchaki).outBus = BusDef(\fx1, \audio);
KitTimeline(\tchaki).outBus = 0;

TrackDef(\tchagrid, TrackDef(\playergrid));
(

TrackDef(\tchagrid).source = [
	[
		KitTimeline(\tchaki),
	],
	[
		NoteTimeline(\skaki),
	],
	[
		NoteTimeline(\tchaki),
	],
	[
		ProtoDef(\rdn),
	],
];
)
TrackDef(\tchagrid).edit

		(
		~t = 130/2/60;
		TempoClock.default.tempo = ~t;
		)

////////////////// //////////////////////////////////////////////////////


(
PatKitDef(\test3).targets = [
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix3/kick1.flac'))),
	StepEvent.newFrom((instrument: 'playersec', adsr: Env([ 0, 1, 1, 0 ], [ 0.004, 0, 0.01 ], [ -4, -4, -4 ], 2), bufnum: BufDef('fix3/kick1.flac'), pos: 0.08)),
	nil,
	nil,
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix3/snare1.flac'))),
	nil,
	nil,
	nil,
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('my3/snare2.flac'), pos: 0.031065759637188, sustain: 1)),
	nil,
	nil,
	nil,
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('fix1/hat.flac'))),
	StepEvent.newFrom((adsr: Env([ 0, 1, 1, 0 ], [ 0.01, 0, 0.1 ], [ -4, -4, -4 ], 2), speed: 1.000875, bufnum: BufDef('fix1/hat.flac'), instrument: 'playersec', gain: 0.70786947024746, sustain: 1, pos: 0.25433106575964)),
	StepEvent.newFrom((instrument: 'playersec', gain: 0.6601092936861, bufnum: BufDef('fix1/hat.flac'), lag: 0)),
];
KitTimeline(\test3, PatKitDef(\test3));
)
PatKitDef(\test3).edit
PatKitDef(\test3).clear

ParamProto.init(true)
KitTimeline(\test3).edit
KitTimeline(\test3).savePresetCompileString
KitTimeline(\test3).presetCompileStringSavePath.asCompileString
FileSystemProject.resolve(KitTimeline(\test3).presetCompileStringSavePath)
FileSystemProject.load("proj1/KitTimeline_test3.scd")
FileSystemProject.load("proj1/PatKitDef_test3.scd")
KitTimeline(\test3).clear
KitTimeline(\test3).presetCompileString

FileSystemProject.unresolve(FileSystemProject.resolve("proj1/KitTimeline_test3.scd").fullPath)
"jj".beginsWith("j")

	(
	Pdef(\plop, Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1
	));
	);
ParamProto.init(true)
NoteTimeline(\plop, Param(Pdef(\plop), \midinote)).edit
ClipTimeline(\bla).edit
ClipTimeline(\bla).clear
NoteTimeline(\plop).editor.timeline.chosennode
NoteTimeline(\plop).editor.timeline.selNodes
FileSystemProject.load("proj1/NoteTimeline_plop.scd")
NoteTimeline(\plop).clear
NoteTimeline(\plop).presetCompileString
NoteTimeline(\plop).recorder

			(
			Dialog.savePanel({ arg path;
				var self = KitTimeline(\test3);
				path.postln;
				File.use(path, "w", { arg file;
					file.write(self.presetCompileString)
				})
			},{
				//"cancelled".postln;
			});
			)



					(
					~w = Window.new("Save").layout_(
						VLayout(
							StaticText.new.string_("Save this object to the file "),
							HLayout(
								nil,
								BasicButton.new.string_("OK").action_({ 
								}),
								BasicButton.new.string_("Cancel").action_({
								}),
							)
						)
					);
					~w.setInnerExtent(~w.minSizeHint.width, ~w.minSizeHint.height).front;
					)
					~w.setInnerkk
					~w.minSizeHint


/////////////////////////////// thisThread latency

thisThread.seconds


		thisProcess.mainThread === thisThread
		{ "xx:".debug( thisProcess.mainThread === thisThread ) }.defer
		thisThread.clock
		(
		WindowDef(\bla, {
			"widnow thread:".debug([ thisThread.clock, thisThread === thisProcess.mainThread ]);
			{ "defer window thread:".debug([ thisThread.clock, thisThread === thisProcess.mainThread ]); }.defer;
			Task{ "task window thread:".debug([ thisThread.clock, thisThread === thisProcess.mainThread ]); }.play;
			AppClock.sched(0,{ "task window thread:".debug([ thisThread.clock, thisThread === thisProcess.mainThread ]); });
			Button.new;
		}).front;
		"top thread:".debug(thisThread.clock, thisThread === thisProcess.mainThread);
		{ "top defer thread:".debug(thisThread.clock, thisThread === thisProcess.mainThread); }.defer;
		)
		{ "xx:".debug( thisThread.clock ) }.defer
		Main.showHelp

		(
		WindowDef(\bla2, { arg def;

			VLayout (
				HLayout(*64.collect({ Button.new })),
				def.waitIfNeeded; Button.new,
				HLayout(*64.collect({ Knob.new })),
				def.waitIfNeeded; Button.new,
				HLayout(*64.collect({ Knob.new })),
				def.waitIfNeeded; Button.new,
				HLayout(*64.collect({ Knob.new })),
				def.waitIfNeeded; Button.new,
				HLayout(*64.collect({ Knob.new })),
				def.waitIfNeeded; Button.new,
				HLayout(*64.collect({ Knob.new })),
				def.waitIfNeeded; Button.new,
				HLayout(*64.collect({ Knob.new })),
				def.waitIfNeeded; Button.new,
				HLayout(*64.collect({ Button.new })),
				def.waitIfNeeded; Button.new,
				HLayout(*64.collect({ Knob.new })),
				def.waitIfNeeded; Button.new,
				HLayout(*64.collect({ Knob.new })),
				def.waitIfNeeded; Button.new,
				HLayout(*64.collect({ Knob.new })),
				def.waitIfNeeded; Button.new,
				HLayout(*64.collect({ Knob.new })),
				def.waitIfNeeded; Button.new,
				HLayout(*64.collect({ Knob.new })),
				def.waitIfNeeded; Button.new,
				HLayout(*64.collect({ Knob.new })),
				def.waitIfNeeded; Button.new,
			)
			
		}).front
		)


			Task({ "task window thread:".debug(thisThread.clock, thisThread === thisProcess.mainThread); 0.01.wait }).play(AppClock);

////////////////////


Log(\bla).blo("kjk")
Log(\bla).addEntry("blo")
Log(\bla).log("bla")
