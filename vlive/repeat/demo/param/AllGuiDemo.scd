

FileSystemProject.load("libdef/basicrecorder.scd")
ProtoDef(\basicrecorder).edit


//////////

BufDef(\moeten, "voices/02_moeten.flac")
BufDef(\clap, "rev/clap1.wav");
WindowDef(\BufferEditor).front(BufDef(\moeten));
WindowDef(\BufferEditor).front(BufDef(\clap));

//////////


FileSystemProject.load("libdef/buttonselector.scd");
(
WindowDef(\win, { arg def;
	
	var butsel = ProtoDef(\ButtonSelector).new({ arg idx;
		idx.debug("selected");
	});
	VLayout(
		*8.collect({ arg idx;
			butsel.makeButton.string_("but" + idx);
		}) ++ [nil]
	);
}).front;
);

/////////


FileSystemProject.load("libdef/controllers.scd");

/////////

FileSystemProject.load("libdef/CustomTrackList.scd");
TrackDef(\mygrid, TrackTemplateDef(\CustomTrackList))
TrackDef(\mygrid).edit

///////// custom track : SampleTimeline


FileSystemProject.load("libdef/CustomTrackList.scd");
TrackDef(\mygrid, TrackTemplateDef(\CustomTrackList))
TrackDef(\mygrid).childAt(0).trackTemplate = TrackTemplateDef(\SampleTimelineTrack)
TrackDef(\mygrid).edit
TrackDef(\myseq).
jo


/////////////// record factory


FileSystemProject.load("libdef/wip/RecordFactory.scd");
ProtoDef(\RecordFactory).edit
