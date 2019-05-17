// dpends on libdef/track.scd

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
	childClass: { TrackDef(\pdefwrapper) },

	prefix: { arg self;
		self.parentTrack.prefix+++self.index;
	},
	mixer: nil,

)));

TrackTemplateDef(\pdefgrid, ().putAll(TrackTemplateDef(\playergrid)).putAll((
	childClass: { TrackDef(\pdeftrack) },

	prefix: { arg self;
		self.key;
	},
	mixer:nil,

)));

TrackDef(\pdefgrid, TrackTemplateDef(\pdefgrid))
