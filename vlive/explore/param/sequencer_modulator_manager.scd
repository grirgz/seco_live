// proof of concept is in demo/param/sequencer_param.scd

(
FileSystemProject.loadOnce("libdef/ControllerSelectorView.scd");

TrackTemplateDef(\SeqmodTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\SeqmodTrackPart) },
	base: { arg self;
		self[\base] = Pbindef(self.name+++\base,
			\type, \paramSet,
			\val, PstepSeq((0..7),inf),
			\param, Param(Pdef(\base), \lpfr, ControlSpec(0.1,4,\lin)),
			\play, {
				~param.value(currentEnvironment).set(~val);
			},
			\dur, 1,
		);
		self[\base]
	},
	edit: { arg self;
		self.trackEditor.front
	},

	targetParam: { arg self;
		Param(Message(self.base.source.at(\param)), \source)
	},
	trackEditor: { arg self;
		WindowDef(self.name+++\trackeditor, { arg def;
			VLayout (
				Param(self.base, \dur -> \source).asView,
				WindowDef(\ParamSelectorView).asView(self.targetParam),
				WindowDef(\GenericEditor).asView(self.targetParam.get.target),
			);
		});
	},
	editor: { arg self;
		WindowDef(self.name, { arg def, child;
			[self.base, child, child.score].debug("editor call scoreEditor");
			VLayout (
				if(child.score.notNil) {
					//WindowDef(\scoreEditor).asView(self.base, child, child.score);
					VLayout (
						Param(child.score, \val -> \stepseq, self.targetParam.get.spec).asView,
						Param(child.score, \dur -> \source).asView,
					);
				}
				//Slider.new,
			)
		});
	},
	makeScore: { arg self;
		self.isEmpty = false;
	},
));
TrackTemplateDef(\SeqmodTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	outBus_: { arg self, val;
		self.score.set(\out, val);
	},
	outBus: { arg self;
		self.score.get(\out);
	},
	cloneScore: { arg self;
		var oldscore = self.score;
		self.makeScore;
		if(oldscore.source.at(\val).notNil) {
			Pbindef(self.name+++\seq, \val, oldscore.source.at(\val).source.deepCopy);
		};
		if(oldscore.source.at(\dur).notNil) {
			Pbindef(self.name+++\seq, \dur, oldscore.source.at(\dur).source.copy);
		};
		self.score;
	},
	updateSource: { arg self;
	},
	makeScore: { arg self;
		self.proxy.debug("makeScore proxy start");
		self[\score] = Pbindef(self.name+++\seq, 
			\val, PstepSeq(0!8,inf)
		);
		self.proxy = PlayerWrapper(Pdef(self.name+++\part,
			self.score <>
			self.parentTrack.base
		));
		self.proxy.debug("makeScore proxy end");
	}
));

TagSpecDef(\CustomTrackTemplate).addUnique(\SeqmodTrack -> TrackTemplateDef(\SeqmodTrack));
);


Param(Pdef(\base), \lpfr).spec


// END


TrackDef(\seqmod, \CustomTrackList);
TrackDef(\seqmod).childAt(0).trackTemplate = TrackTemplateDef(\SeqmodTrack)
TrackDef(\seqmod).edit

TrackDef(\seqmod2, \CustomTrackList);
TrackDef(\seqmod2).edit

TrackDef(\seqmod3, \CustomTrackList);
TrackDef(\seqmod3).childAt(0).trackTemplate = TrackTemplateDef(\SeqmodTrack)
TrackDef(\seqmod3).edit

TrackDef(\seqmod3).childAt(0).edit

TrackDef(\seqmod3).childAt(0).targetParam.get
TrackDef(\seqmod3).childAt(1).targetParam.get
TrackDef(\seqmod3).childAt(1,0).score
TrackDef(\seqmod3).childAt(1,1).score
TrackDef(\seqmod3).childAt(1,4).score
TrackDef(\seqmod3).childAt(1,4).proxy
TrackDef(\seqmod3).childAt(1,0).proxy

Pdef(\base).edit

(
Pbindef(\base, 
		\instrument, \saw,
		\degree, Pseq([0,3,2,5],inf),
		\dur, 1/4,
		\amp, 0.1,
).play;
Pbindef(\base2, 
		\instrument, \saw,
		\degree, Pseq([4,4,3,2, 0,0,-1,0],inf),
		\dur, 1/4,
		\amp, 0.1,
).play;
)

~trackDef_clipboard.score.source.at(\val).source
~trackDef_clipboard.score.source.at(\dur).source
~trackDef_clipboard.score.source.at(\dur)
~trackDef_clipboard.score.source.at(\val)
