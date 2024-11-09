// the idea is to name your Pdef(\pdefgrid3_1) then when you open TrackDef(\pdefgrid) it's there in column 3 cell 1
// you can also define TrackDef(\mykey, TrackTemplateDef(\pdefgrid)) to use Pdef(\mykey3_1)


// dpends on libdef/tracks.scd
FileSystemProject.loadOnce("libdef/tracks.scd");

TrackTemplateDef(\pdefwrapper, ().putAll(TrackTemplateDef(\playerwrapper)).putAll((

	prefix: { arg self;
		self.parentTrack.prefix;
	},

	isEmpty: { arg self;
		if(self.source.isKindOf(ProtoClass)) {
			self.source.isEmpty;
		} {
			self.source.source.isNil
		}
	},

	defaultSource: { arg self;
		Pdef("%_%".format(self.prefix, self.index).asSymbol)
	},

	edit: { arg self;
		self.proxy.edit;
	},

)));

TrackTemplateDef(\pdeftrack, ().putAll(TrackTemplateDef(\playertrack)).putAll((
	childClass: { TrackTemplateDef(\pdefwrapper) },

	prefix: { arg self;
		self.parentTrack.prefix+++self.index;
	},
	mixer: nil,

)));

TrackTemplateDef(\pdefgrid, ().putAll(TrackTemplateDef(\playergrid)).putAll((
	childClass: { TrackTemplateDef(\pdeftrack) },

	prefix: { arg self;
		self.key;
	},
	mixer:nil,

)));

TrackDef(\pdefgrid, TrackTemplateDef(\pdefgrid))
