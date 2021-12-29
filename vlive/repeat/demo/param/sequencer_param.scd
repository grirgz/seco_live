
(
Pbindef(\zed, 
		\type, \paramSet,
		\val, PstepSeq((0..7),inf),
		\param, Param(Pdef(\base), \lpfr, ControlSpec(0.1,4,\lin)),
		\play, {
			~param.value(currentEnvironment).set(~val);
		},
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
).play;
);

(
WindowDef(\win, { arg def;
	VLayout (
		HLayout (
			PlayerWrapper(Pdef(\zed)),
			PlayerWrapper(Pdef(\base)),
		),
		HLayout (
			Param(Pdef(\zed), \val -> \stepseq, Pbindef(\zed).source.at(\param).source.spec).asView,
			TrackMixerDef(\track1).asView
		),
		Param(Pdef(\zed).source.at(\dur), \dur, ControlSpec(0.01,4,\exp)).asView,
		Param(Message(Pdef(\zed).source.at(\param).source), \inBusMode, ParamBoolSpec() ).asButton,
		Pbindef(\base).asParamGroup.asView,
	)
	
}).front;
)

Slider
Log(\Param).level = \info

ProtoInst(\TrackMixerDef, \track1).edit

(
Pbindef(\base, 
		\instrument, \saw,
		\degree, Pseq([0,3,2,5],inf),
		\dur, 1/4,
		\amp, 0.1,
).play;
);


///////////////////


(
Pbindef(\zed, 
		\type, \paramSet,
		\val, PstepSeq((0..7),inf),
		\param, Param(Pdef(\base), \lpfr, ControlSpec(0.1,4,\lin)),
		\play, {
			~param.value(currentEnvironment).set(~val);
		},
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
).play;
Pbindef(\base, 
		\instrument, \saw,
		\degree, Pseq([0,3,2,5],inf),
		\dur, 1/4,
		\amp, 0.1,
).play;
);

Pdef(\zed).getHalo(\ControllerSelectorView, ( \val -> \stepseq ).asString)
Pdef(\zed).getHalo(\ControllerSelectorView, ( \val -> \stepseq ).asSymbol)
Pdef(\zed).getHalo(\ControllerSelectorView)
Pdef(\zed).addHalo(\ControllerSelectorView, ( \val -> \stepseq ).asSymbol, "bla")
(
WindowDef(\win, { arg def;
	VLayout (
		HLayout (
			VLayout (
				
				HLayout (
					PlayerWrapper(Pdef(\zed)),
					WindowDef(\ParamSelectorView).asView(Param(Message(Pdef(\zed).source.at(\param)), \source)),
					WindowDef(\ControllerSelectorView).asView(Param(Pdef(\zed), \val -> \stepseq, Pbindef(\zed).source.at(\param).source.spec)),
				),
				Param(Pdef(\zed), \val -> \stepseq, Pbindef(\zed).source.at(\param).source.spec).asMultiSlider,
			),
		),
		Param(Pdef(\zed).source.at(\dur), \dur, ControlSpec(0.01,4,\exp)).asView,
		HLayout (
			PlayerWrapper(Pdef(\base)),
			Param(Message(Pdef(\zed).source.at(\param).source), \inBusMode, ParamBoolSpec() ).asButton,
			WindowDef(\ControllerSelectorView).asView(Param(Pdef(\base), \midinote)),
		),
		HLayout (
			Pbindef(\base).asParamGroup.asView,
			TrackMixerDef(\track1).asView,
		)
	)
	
}).front;
)

/////////////////// init
(
~initialize_jack.();
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
//FileSystemProject.load("cavern/lib.scd");
FileSystemProject.load("cavern/ifxsimple.scd");
FileSystemProject.load("libdef/ControllerSelectorView.scd");
Log(\Param).level = \info;
)



////////////////////////


FileSystemProject.load("libdef/controllers.scd");
ProtoInst(\TrackMixerDef, \track1).edit

Param(Pdef(\zed), \val -> \stepseq, Pbindef(\zed).source.at(\param).source.spec).propertyLabel

(
);


ControllerDef.getTagSpec(\knobs).list
ControllerDef.getTagSpec(\knobline).list
ControllerDef.getTagSpec(\piano).list

ControllerDef.getTagSpec(\knobline).list.first.value.source.asCompileString
ControllerDef.getTagSpec(\knobline).list
ControllerDef(\bla, {  }, [\knobline])


///////////
Param(Message(Pdef(\zed).source.at(\param)), \source)
Param(Pdef(\zed), \val -> \stepseq, Pbindef(\zed).source.at(\param).source.spec)
Param(Pdef(\zed), \val -> \stepseq, Pbindef(\zed).source.at(\param).source.spec)
Param(Pdef(\zed).source.at(\dur), \dur, ControlSpec(0.01,4,\exp))
Param(Message(Pdef(\zed).source.at(\param).source), \inBusMode, ParamBoolSpec() )
(
WindowDef(\win, { arg def;
	VLayout (
		HLayout (
			VLayout (
				
				HLayout (
					PlayerWrapper(Pdef(\zed)),
					WindowDef(\ParamSelectorView).asView(Param(Message(Pdef(\zed).source.at(\param)), \source)),
					WindowDef(\ControllerSelectorView).asView(Param(Pdef(\zed), \val -> \stepseq, Pbindef(\zed).source.at(\param).source.spec)),
				),
				Param(Pdef(\zed), \val -> \stepseq, Pbindef(\zed).source.at(\param).source.spec).asMultiSlider,
			),
		),
		Param(Pdef(\zed).source.at(\dur), \dur, ControlSpec(0.01,4,\exp)).asView,
		HLayout (
			PlayerWrapper(Pdef(\base)),
			Param(Message(Pdef(\zed).source.at(\param).source), \inBusMode, ParamBoolSpec() ).asButton,
			WindowDef(\ControllerSelectorView).asView(Param(Pdef(\base), \midinote)),
		),
		HLayout (
			Pbindef(\base).asParamGroup.asView,
			TrackMixerDef(\track1).asView,
		)
	)
	
}).front;
)



/////////////////



(
Builder(\coolseq, { arg me;

	var name = me.key;
	(
		Pbindef(name+++\base, 
			\instrument, \saw,
			\degree, PstepSeq([0,3,2,5],inf),
			\dur, 1/4,
			\amp, 0.1,
		);
	);

	(
		Pbindef(name+++\mod, 
			\type, \paramSet,
			\param, Param( Pbindef(name+++\base), \lpfr, ControlSpec(0.1,7,\exp) ),
			\val, PstepSeq((1..8)/3.2,inf),
			\play, {
				~param.set(~val)
			}
		);
	);
	me.proxy = PlayerWrapperGroup([Pdef(name+++\base), Pdef(name+++\mod), TrackMixerDef(name+++\mixer)]);

	(
		WindowDef(name+++\win, { arg def;
			var seqparam = Param( Pbindef(name+++\mod), \val -> \stepseq, Pbindef(name+++\mod).source.at(\param).source.spec );
			var seqparam_deg = Param( Pbindef(name+++\base), \degree -> \stepseq, ControlSpec(0,14,\lin));
			var seqtarget = Param( Message( Pbindef(name+++\mod).source.at(\param) ), \source );
			VLayout (
				HLayout (
					PlayerWrapper(me.proxy),
					PlayerWrapper(Pdef(name+++\mod)),
					Param( Pbindef(name+++\mod), \dur, ControlSpec(0.01,2,\exp) ).asView,
					WindowDef(\ParamSelectorView).asView( seqtarget ),
					WindowDef(\ControllerSelectorView).asView( seqparam ),
				),
				seqparam.asView,
				HLayout (
					PlayerWrapper(Pdef(name+++\base)),
					Param( Message( Pbindef(name+++\mod).source.at(\param).source ), \inBusMode, ParamBoolSpec()).asButton,
					WindowDef(\ControllerSelectorView).asView( Param(Pbindef(name+++\base), \midinote )),
				),
				seqparam_deg.asView,
				HLayout (
					Pbindef(name+++\base).asParamGroup.asView,
					TrackMixerDef(name+++\mixer).asView,
				)
			)

		});
	);

	me.editor = WindowDef(name+++\win);

});
)

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
);
Pdef(\zed2, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([3,7],inf),
		\dur, 1,
		\amp, 0.1,
	)
);
);
PlayerWrapperGroup([Pdef(\zed), Pdef(\zed2)]).edit
PlayerWrapperGroup([Pdef(\base), Pdef(\mod), TrackMixerDef(\track1)]).play
Builder(\seq1, Builder(\coolseq)).build;
Builder(\seq2, Builder(\coolseq)).build;
Builder(\seq1).edit
Builder(\seq1).play
Builder(\seq2).edit
Builder(\seq2).play
Builder(\seq2).play
TrackMixerDef(\seq2track1).edit
TrackMixerDef(\seq2track1).sendParam(0).set(1)
TrackMixerDef(\seq2track1).proxy.get(\sendbus0)
TrackMixerDef(\seq2track1).build_sender(0)
TrackMixerDef(\rdnmixer).edit

(
FileSystemProject.load("libdef/multifbdel.scd");
FileSystemProject.load("libdef/rdngui.scd");
FileSystemProject.load("libdef/rdnstring.scd");
)
ProtoDef(\rdn).edit
		(
		WindowDef("%".format(\PlayerWrapperGroup).asSymbol, { arg def, xthis;
			VLayout (
				PlayerWrapperView(xthis).asView,
				StaticText.new,
				VLayout(
					*xthis.collect({ arg player;
						var view = player.asView.rightClickEditorEnabled_(true);
						//var follower = { arg ...args;
				
						//};
						//player.target.addDependant(follower);
						//view.onClose({ plaer.target.removeDependant(follower) });

						//view.button.followChange(player.target, \PlayerWrapper, { arg but, pw, changed, status;
							////if(a)
				
						//});
						view;
					}) ++ [nil]
				)
			)
		}).front(PlayerWrapperGroup([Pdef(\zed)]));
		)
		PlayerWrapper( PlayerWrapperGroup([Pdef(\zed)]) ).edit


////////////////////////

// idea: a NoteTimeline view with no widget, only show the recording, with a record button and a ControllerSelectorView, and play button

(
WindowDef(\win, { arg def;
	NoteTimeline(\note1).asView
	
}).front;
);

//////////////////// drumkit sequencer

PatKitDef(\bla).edit

(
Pdef(\drums, Pdef(\ccc, 
		PatKitDef(\bla).asPattern( 
			Ppar(4.collect { arg idx;
				Pbindef(\seq+++idx,
					\kitIndex, idx,
					\isRest, false,
					\velamp, PstepSeq(0!8,inf),
					\muter, Pif(Pkey(\velamp) > 0, {0}, {\rest}),
					\dur, 1/4,
				)
			});
		)
)).play;
);

(
WindowDef(\win, { arg def;
	VLayout (
		HLayout (
			PlayerWrapper(Pdef(\drums)),
			BasicButton.new.string_("Kit Edit").action_({
				PatKitDef(\bla).edit
			}),
			Param(Pdef(\drums), \out, ParamBusSpec()).asView,
		),
		VLayout (
			* 4.collect { arg idx;
				HLayout (
					//Param(Pbindef(\seq+++idx), \isRest -> \stepseq, ParamBoolSpec(reverse:true)).asView,
					Param(Pbindef(\seq+++idx), \velamp -> \stepseq, \unipolar).asView,
					//Param(Pbindef(\seq+++idx), \kitIndex -> \source, ControlSpec(0,32,\lin,1)).asNumberBox,
					Param(Pbindef(\seq+++idx).source.at(\kitIndex), \source, ControlSpec(0,32,\lin,1)).asNumberBox,
				)
			};
		)
	)
	
}).front;
)


//////////// drumkit seq in tracklist!

(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
FileSystemProject.load("cavern/lib.scd");
)
FileSystemProject.load("libdef/tracklist.scd");

TrackDef(\tlist, TrackTemplateDef(\TrackList));
TrackDef(\tlist).edit
TrackDef(\tlist).clear
Log(\Param).level = \debug;
TagSpecDef(\BuilderLib).addUnique(\default_builder -> Builder(\default_builder))
TagSpecDef(\BuilderLib).addUnique(\demo_builder -> Builder(\demo_builder))
TagSpecDef(\BuilderLib).addUnique(\coolseq -> Builder(\coolseq))
TagSpecDef(\BuilderLib).clear

		TrackDef(\godel, TrackTemplateDef(\TrackList));
		TrackDef(\godel).childAt(0).instrument = ProtoTemplateDef(\TrackInstrument).new([\TrackInstrument, (\BuilderTrack -> \BuilderTrack)]);
(

	Builder(\demo_builder, { arg me;
		Pdef(\zed, 
			Pbind(
				\instrument, \default,
				\degree, Pseq([0],inf),
				\dur, 1,
				\amp, 0.1,
			)
		);
		me.proxy = Pdef(\zed);
		me.editor = WindowDef(\demoedit, { WindowDef(\PdefEditor).asView(me.proxy) });

	}).build;
	Builder(\default_builder, { arg me;
		me.proxy = EventPatternProxy.new.source(Pbind());
		me.editor = ();
	}).build;
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
		}
	},

	asPreview: { arg self, model, score;
		BasicButton.new.string_("Builder").action_({
			score.builder.edit;
		})
	},

	makeScore: { arg self, model, trackIdx, partIdx;
		[model.key, trackIdx, partIdx].debug("TrackInstrument_KitTimelineTrack makeScore");
		(
			builder: Builder("%.%.%".format(model.key, trackIdx, partIdx).asSymbol, self.source).buildInit
		)
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


Builder(\godel_builder, { arg me;
	var name = me.key;
	var tlist;
	Pdef(name+++\zed, 
		Pbind(
			\instrument, \default,
			\degree, Pseq([0],inf),
			\dur, 1,
			\amp, 0.1,
		)
	);
	tlist = TrackDef(\godel, TrackTemplateDef(\TrackList));
	tlist.defineTrack(0, [\TrackInstrument, (\BuilderTrack -> \BuilderTrack)]);
	//TrackDef(\godel).childAt(0).instrument = ProtoTemplateDef(\TrackInstrument).new([\TrackInstrument, (\BuilderTrack -> \BuilderTrack)]);
	tlist.childAt(0).instrument.source = Builder(\godel_builder);
	me.proxy = Pdef(name+++\zed);
	me.editor = WindowDef(name+++\demoedit, { 
		var cellplayer;
		var editView = View.new;
		cellplayer = PlayerWrapperView.new;

		editView.followChange(tlist, \selectedPart, {
			var part = tlist.childAt(0,tlist.selectedPart);
			var score = part.score;
			cellplayer.model = PlayerWrapper(part);
			editView.removeAll;
			editView.layout = if(score.notNil) {
				WindowDef(\PdefEditor).asView(score.builder.proxy);
			} {
				VLayout (
					BasicButton.new.string_("Create").action_({
						part.makeScore;
					})
				)
			};
		});

		VLayout (
			HLayout (
				StaticText.new.string_("Part:"),
				Param(Message(tlist), \selectedPart, ControlSpec(0,16,\lin,1)).asNumberBox,
				cellplayer.asView,
			),
			editView,
		)
	});

}).build;
)

PlayerWrapper(Builder(\demo_builder)).outBus
PlayerWrapper(Builder(\demo_builder)).play
Builder(\demo_builder).play
Pdef(\zed).play
Pdef(\zed).source
Builder(\godel_builder).edit
TrackDef('godel').childAt(0,0).play
TrackDef('godel').edit
PlayerWrapper(TrackDef('godel').childAt(0,0)).play
PlayerWrapper(TrackDef('godel').childAt(0,0)).stop
PlayerWrapper(TrackDef('godel').childAt(0,0)).asView
TrackDef('godel').childAt(0,0).label
TrackDef('godel').childAt(0,0).proxy
TrackDef('godel').childAt(0,0)[\label].asCompileString
(
WindowDef(\win, { arg def;
	PlayerWrapper(TrackDef('godel').childAt(0,0)).asView
	
}).front;
);
Pdef(\godel_builderzed).play
