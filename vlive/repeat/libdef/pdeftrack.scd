// dpends on libdef/track.scd

TrackTemplateDef(\pdefwrapper, TrackTemplateDef(\playerwrapper).putAll((

	prefix: { arg self;
		self.parentTrack.prefix;
	},

	defaultSource: { arg self;
		Pdef("%_%".format(self.prefix, self.index).asSymbol)
	},

)));

TrackTemplateDef(\pdeftrack, TrackTemplateDef(\playertrack).putAll((
	childClass: { TrackDef(\pdefwrapper) },

	prefix: { arg self;
		self.parentTrack.prefix+++self.index;
	},
	mixer: nil,

)));

TrackTemplateDef(\pdefgrid, TrackTemplateDef(\playergrid).putAll((
	childClass: { TrackDef(\pdeftrack) },

	prefix: { arg self;
		self.key;
	},
	mixer:nil,

)));

TrackDef(\pdefgrid, TrackTemplateDef(\pdefgrid))
PlayerWrapper({ "kjk".postln }).play
