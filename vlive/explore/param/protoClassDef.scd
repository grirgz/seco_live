

(
ProtoClassDef(\bla, (
	all: IdentityDictionary.new,
	new: { arg self, key, val;
		if(val.notNil) {
			self.all[key] = val;
		};
		self.all[key];
	},
))
)
ProtoInsDef(\bla, \hey, 23)
ProtoInsDef(\bla, \hey)

ParamProto.init
(
ProtoClassDef(\time, ~clipTimeline)
)
ProtoInsDef(\time, \hot).edit
ProtoInsDef(\time, \hot).edit
ProtoInsDef(\SampleTimelineView, \hot).edit


ProtoInsDict(\hot, \NoteTimeline, Pdef(\bla))
ProtoInsDict(\hot)
