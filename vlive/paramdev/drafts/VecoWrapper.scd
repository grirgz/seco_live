
FileSystemProject.load("demo/param/CustomTrackList.scd");


(
TrackTemplateDef(\VecoWrapper, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\VecoWrapperTrack) },
));
TrackTemplateDef(\VecoWrapperTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\VecoWrapperTrackPart) },
	define_variables: { arg self;
		~name = self.trackKey;
		~pdef_init = {

		};
		~pdef_channel = {

		}
	},
));
TrackTemplateDef(\VecoWrapperTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
));

);
