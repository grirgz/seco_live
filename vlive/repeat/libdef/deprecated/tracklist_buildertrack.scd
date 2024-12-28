
Builder(\default_builder, {});

ProtoTemplateDef(\TrackInstrument_BuilderTrack, (
	parent: ProtoTemplateDef(\TrackInstrument),

	new: { arg self, libId, name;
		self = self.copy;
		// NOTE: name and libId is stored in this object by creator of this object
	
		
		self.source = Builder(\default_builder);
		self;
	},

	edit: { arg self;
		WindowDef(\BuilderTrackEdit, { arg def;
			Param(Message(self), \source, TagSpecDef(\BuilderLib)).asView;
		}).front;
	},

	setTrackInstrumentOfScore: { arg self, scoreinst;
		Log(\Param).debug("setTrackInstrumentOfScore: scoreinst %", scoreinst);
		if(self.source.notNil) {
			scoreinst.source = self.source;
			scoreinst.build;
		}
	},

	asPreview: { arg self, model, score;
		BasicButton.new.string_("Builder").action_({
			score.builder.edit;
		})
	},

	makePartView: { arg self, score;
		score.builder.editor.asView;
	},

	makeScore: { arg self, model, trackIdx, partIdx;
		[model.key, trackIdx, partIdx].debug("TrackInstrument_KitTimelineTrack makeScore");
		(
			builder: Builder("%.%.%".format(model.key, trackIdx, partIdx).asSymbol, self.source).buildInit
		)
	},

	updateScoreOutBus: { arg self, score, outBus;
		if(score.notNil) {
			score.builder.set(\outBus, outBus);
		}
	},


	updateScore: { arg self, score;
		if(score.notNil) {
			score.keys.do { arg key;
				if(key != \selected) {
					//self.lib.setTrackInstrument(score[key], self) // drop wrapper lib for the moment to use child class instead
					self.setTrackInstrumentOfScore(score[key]);
				}
			};
			score[\selected] = \builder;
		}
	},

	makeIndependentScore: { arg self, key;
		Builder(key, self.source);
	},
));
TagSpecDef(\TrackInstrument).addUnique(\BuilderTrack);
