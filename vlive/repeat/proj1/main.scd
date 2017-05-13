

TrackDef(\maingrid, TrackDef(\projectgrid));

(
TrackDef(\maingrid).projectDir = "proj1";
TrackDef(\maingrid).source = [
	KitTimeline(\perc),
	NoteTimeline(\bass),
	NoteTimeline(\lead),
	ProtoDef(\rdn)
];
)
