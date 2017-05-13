
(
	Pdef(\tuba, Pbind(
		\instrument, \default,
		\dur, 1,
		\amp, 0.1
	));

	NoteTimeline(\tuba, Param(Pdef(\tuba), \midinote));
)

ProtoDef(\saver_NoteTimeline).saveObject(NoteTimeline(\tuba), "tuba1", "proj1")

////////////////////////////

NoteTimeline(\tuba).edit
NoteTimeline(\tuba).presetCompileString
NoteTimeline(\tuba).recorder
NoteTimeline(\tuba).asArchiveData
NoteTimeline(\kit, PatKitDef(\barlok1)).keys
