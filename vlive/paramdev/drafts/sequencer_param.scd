
(
Pbindef(\base, 
		\instrument, \saw,
		\degree, Pseq([0,3,2,5],inf),
		\dur, 1/4,
		\amp, 0.1,
);
);
~param = Param(Pdef(\base), \lpfr)

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



///////////////////
// with param selector and controller selector
FileSystemProject.load("libdef/ControllerSelectorView.scd");


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
Pbindef(\basex).source = Pbindef(\basex).source ? PbindProxy.new(

			\instrument, \saw,
			\degree, PstepSeq([0,3,2,5],inf),
			\dur, 1/4,
			\amp, 0.1,
)
)
Pbindef(\base).source.at(\dur).source
Pbindef(\basex).source.at(\dur).source
Pbindef(\base, \dur, 1)
		(
		Pbindef(\base,
			\instrument, \saw,
			\degree, PstepSeq([0,3,2,5],inf),
			\dur, 1/4,
			\amp, 0.1,
		);
		)


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
		var name = me.key;
		Pdef(name+++\zed, 
			Pbind(
				\instrument, \default,
				\degree, Pseq([0,4,2,-1],inf),
				\dur, 1,
				\amp, 0.1,
			)
		);
		me.proxy = Pdef(name+++\zed);
		me.editor = WindowDef(name+++\demoedit, { WindowDef(\PdefEditor).asView(me.proxy) });

	}).build;
	Builder(\default_builder, { arg me;
		me.proxy = EventPatternProxy.new.source(Pbind());
		me.editor = ();
	}).build;

	FileSystemProject.load("libdef/tracklist_buildertrack.scd");

/// the godel builder create a TrackList and put itself as the template for each cell
// so each cell have its pattern and its GUI
// But there is only one shared GUI at the root builder level that update its content according to \selectedPart message from the TrackList
// it use old .instrument scheme, new scheme is .trackTemplate_
// demo_builder is not used in godel_builder 
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
						tlist.changed(\selectedPart);
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
Log

PlayerWrapper(Builder(\demo_builder)).outBus
PlayerWrapper(Builder(\demo_builder)).play
Builder(\demo_builder).play
Pdef(\zed).play
Pdef(\zed).source
Builder(\godel_builder).edit
PlayerWrapper(Builder(\godel_builder)).outBus_(0)
PlayerWrapper(Builder(\godel_builder)).target
PlayerWrapper(Builder(\godel_builder)).wrapper
Param(Builder(\godel_builder), \outBus, ParamBusSpec()).set(0)
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


Builder(\bla, { arg me, bli; bli.debug("bli") })
Builder(\bla).build
Builder(\bla).set(\bli, 1000)
Builder(\bla2, Builder(\bla))
Builder(\bla2).build


////////:


TrackDef(\tlist, TrackTemplateDef(\TrackList));
(
Builder(\godel_builder, { arg me, tlist;
	var name = me.key;
	//var tlist;
	Pdef(name+++\zed, 
		Pbind(
			\instrument, \default,
			\degree, Pseq([0],inf),
			\dur, 1,
			\amp, 0.1,
		)
	);
	tlist = tlist ?? { TrackDef(\godel, TrackTemplateDef(\TrackList)) };
	tlist.defineTrack(0, [\TrackInstrument, (\BuilderTrack -> \BuilderTrack)]);
	//TrackDef(\godel).childAt(0).instrument = ProtoTemplateDef(\TrackInstrument).new([\TrackInstrument, (\BuilderTrack -> \BuilderTrack)]);
	tlist.childAt(0).instrument.source = Builder(\godel_builder);
	tlist.childAt(0).instrument.builderKey = tlist.key;
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
						tlist.changed(\selectedPart);
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


///////////////////

// demo_builder in custom tracklist


(
WindowDef(\demotrack, { arg def, tlist;
	
		var cellplayer;
		var editView = View.new;
		cellplayer = PlayerWrapperView.new;

		tlist.defineTrack(0, [\TrackInstrument, (\BuilderTrack -> \BuilderTrack)]);
		//TrackDef(\godel).childAt(0).instrument = ProtoTemplateDef(\TrackInstrument).new([\TrackInstrument, (\BuilderTrack -> \BuilderTrack)]);
		tlist.childAt(0).instrument.source = Builder(\demo_builder);

		editView.followChange(tlist, \selectedPart, {
			var part = tlist.childAt(0,tlist.selectedPart);
			var score = part.score;
			cellplayer.model = PlayerWrapper(part);
			editView.removeAll;
			editView.layout = if(part.isEmpty.not) {
				score.builder.editor.asView;
			} {
				VLayout (
					BasicButton.new.string_("Create").action_({
						part.makeScore;
						tlist.changed(\selectedPart);
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
}).front(TrackDef(\demotl, TrackTemplateDef(\TrackList)));
);


// choose a track
// broken: to finish
(
WindowDef(\demotrack, { arg def, track;
	
		var cellplayer;
		var editView = View.new;
		var tlist = track.parentTrack;
		cellplayer = PlayerWrapperView.new;

		track.instrumentId = [\TrackInstrument, (\BuilderTrack -> \BuilderTrack)];
		track.instrument.source = Builder(\demo_builder);

		editView.followChange(tlist, \selectedPart, {
			var part = track.childAt(tlist.selectedPart);
			var score = part.score;
			cellplayer.model = PlayerWrapper(part);
			editView.removeAll;
			editView.layout = if(part.isEmpty.not) {
				score.builder.editor.asView;
			} {
				VLayout (
					BasicButton.new.string_("Create").action_({
						part.makeScore;
						tlist.changed(\selectedPart);
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
}).front(TrackDef(\demx, TrackTemplateDef(\TrackList)).elAt(3));
);
TrackDef(\demx).elAt(0).clearAllChannelParts

WindowDef(\demotrack).front(TrackDef(\demx).elAt(0))

(
WindowDef(\win, { arg def;
	VLayout (
		WindowDef(\demotrack).asView(TrackDef(\demx).elAt(0)),
		WindowDef(\demotrack).asView(TrackDef(\demx).elAt(3)),
	)
	
}).front;
);

(
WindowDef(\PartView, { arg def, track;
	
		var cellplayer;
		var editView = View.new;
		var tlist = track.parentTrack;
		cellplayer = PlayerWrapperView.new;

		track.instrumentId = [\TrackInstrument, (\BuilderTrack -> \BuilderTrack)];
		track.instrument.source = Builder(\demo_builder);

		editView.followChange(tlist, \selectedPart, {
			var part = track.childAt(tlist.selectedPart);
			var score = part.score;
			cellplayer.model = PlayerWrapper(part);
			editView.removeAll;
			editView.layout = if(part.isEmpty.not) {
				score.builder.editor.asView;
			} {
				VLayout (
					BasicButton.new.string_("Create").action_({
						part.makeScore;
						tlist.changed(\selectedPart);
					})
				)
			};
		});

			VLayout (
				//StaticText.new.string_("Part:"),
				//Param(Message(tlist), \selectedPart, ControlSpec(0,16,\lin,1)).asNumberBox,
				cellplayer.asView.fixedWidth_(100),
				editView,
			)
}).front(TrackDef(\demx, TrackTemplateDef(\TrackList)).elAt(3));
);

(
WindowDef(\win, { arg def;
	var tlist = TrackDef(\demx);
	VLayout (
		HLayout (
			StaticText.new.string_("Part:"),
			Param(Message(tlist), \selectedPart, ControlSpec(0,16,\lin,1)).asNumberBox,
		),
		HLayout (
			WindowDef(\PartView).asView(tlist.elAt(0)),
			WindowDef(\PartView).asView(tlist.elAt(1)),
			WindowDef(\PartView).asView(tlist.elAt(3)),
		),
		nil
	)
	
}).front;
);

WindowDef(\KitTimeline_PatKitDefEditor).front(PatKitDef(\bla))











///////////////////////////////////////////////////////
///////////////////////
/// from sccode
// dodoleon GUI


(

var win = Window( "Switch", Rect( 0, 300, 200, 300 ) );
var switch;
var demo_view = UserView();
var demo_string = "Hello World";

var demo_states = 	[
	["Never", Color.black, Color.white, Color.red ],
	["Gonna", Color.black, Color.white, Color.green ]
].asList;

~get_switch = { | input_states, default_state, font, has_inside_margin |
	var switch = UserView();
	var states = input_states;
	var current_state = default_state;
	var border_color2_ratio = 0.5;
	var binded_function = nil;

	switch.drawFunc = { | view |
		var margin = view.bounds.height * 0.01;

		if( margin < 4, { margin = 4 } );
		Pen.fillColor_( states[current_state][2] );
		Pen.fillRect(
			Rect(
				0,
				0,
				view.bounds.width,
				view.bounds.height
			)
		);
		Pen.fillColor_(
			Color(
				states[current_state][2].red * border_color2_ratio,
				states[current_state][2].green * border_color2_ratio,
				states[current_state][2].blue * border_color2_ratio
			)
		);
		Pen.fillRect(
			Rect(
				margin / 2,
				margin / 2,
				view.bounds.width - margin,
				view.bounds.height - margin
			)
		);
		if( has_inside_margin, {
			Pen.fillColor_( Color.black );
			Pen.fillRect(
				Rect(
					margin,
					margin,
					view.bounds.width - ( margin * 2 ),
					view.bounds.height - ( margin * 2 )
				)
			);
			margin = margin * 2;
		} );
		Pen.fillColor_( states[current_state][3] );
		Pen.fillRect(
			Rect(
				margin,
				margin,
				view.bounds.width - ( margin * 2 ),
				view.bounds.height - ( margin * 2 )
			)
		);
		Pen.stringCenteredIn(
			states[current_state][0],
			Rect(
				0,
				0,
				view.bounds.width,
				view.bounds.height,
			),
			font,
			states[current_state][1]
		);
	};
	switch.mouseDownAction = {
		current_state = current_state + 1;
		if( current_state == states.size, { current_state = 0 } );
		if( binded_function != nil, { binded_function.value( current_state ) } );
		switch.refresh
	};

	switch.addUniqueMethod( \bindFunction, { | object, function | binded_function = function } );

	switch.addUniqueMethod( \updateStates, { | object, new_states |
		states = new_states;
		if( current_state >= states.size, { current_state = 0 } );
		switch.refresh;
	} );

	switch.addUniqueMethod( \setState, { | object, new_state |
		if( ( ( new_state >= 0 ) && ( new_state <= states.size ) ), {
			current_state = new_state;
			switch.refresh;
		} );
	} );

	switch.addUniqueMethod( \valueState, { | object, new_state |
		if( ( ( new_state >= 0 ) && ( new_state <= states.size ) ), {
			current_state = new_state;
			if( binded_function != nil, { binded_function.value( current_state ) } );
			switch.refresh;
		} );
	} );
	switch
};

demo_states.add( ["Give", Color.black, Color.white, Color.blue ] );

demo_view.drawFunc = { | view |
	Pen.stringCenteredIn(
		demo_string,
		Rect(
			0,
			0,
			view.bounds.width,
			view.bounds.height
		)
	)
};

demo_states.add( ["You", Color.black, Color.white, Color.cyan ] );

switch = ~get_switch.value(
	demo_states,
	0,
	Font.default,
	true
);

demo_states.add( ["Up", Color.black, Color.white, Color.magenta ] );

switch.updateStates( demo_states );
switch.bindFunction( { | index |
	demo_string = demo_states[ index ][0];
	demo_view.refresh;
} );
switch.valueState( 0 );

win.layout_( VLayout( demo_view, switch ) );
win.front

)



a go at making something like metaphysical function from NI reaktor in SC
original instrument design by mike daliot
based on ScopeView helpfile and
https://www.youtube.com/watch?v=l-uuPlAk_FY

how to use:
this instrument generates harsh drones and visuals.
use with caution! protect your hearing! dist goes loud!

1. add a little spin with spin t1, t2 and/or fine
2. detune one of the oscillators using tune/fine

a and b is a bank of 4 sine oscs and 2 pulse oscs with pw 0.5 and 0.2

(
var w, ctr = IdentityDictionary[], gui = IdentityDictionary[];
var syn, scopeSyn, scope, func, bus, buffer;

w = Window("Scope", Rect(0, 0, 800, 500));

ctr[\defaultfreqs] = 60 ! 6;
ctr[\defaultfine] = 0.0 ! 6;
ctr[\defaultamps] = [-12] ++ (-120 ! 5);

gui[\views] = [\topBar, \scopeView, \zoomView, \lowBar];
gui[\basicView] = { View().background_(Color.gray).layout_(HLayout()) };

gui[\views].do({ |view| gui[view] = gui[\basicView].value });

[\a, \b].do({ |ab|
	[\Top, \Mid, \Low].do({ |tier|
		gui[(ab++tier).asSymbol] = gui[\basicView].value;
	})
});

func = {
	arg view, synarg, spec, contr, defaults, i;
	var sl, values;
	sl = Slider(gui[view]).action_({
		values = ctr[contr].collect({|sl| spec.asSpec.map(sl.value)});
		syn.setn(synarg, values);
		//values.postln
	});

	sl.value_(spec.asSpec.unmap(ctr[defaults][i]))
};

// lazy labels
[StaticText(gui[\topBar]).string_("a tune  /  fine  /  amp\t\t       alvl"), View(gui[\topBar]).minWidth_(450), StaticText(gui[\topBar]).string_("blvl\t\t       b tune  /  fine  /  amp")];
[View(gui[\lowBar]).maxWidth_(163), StaticText(gui[\lowBar], Rect(200, 0, 200, 20)).string_(
"a+b                    zoom                    spin t1                    t2                       fine                        fb                       dist                       a*b")];

// the 2 groups of 3 * 6 controls for a and b
ctr[\atune] = {|i| func.(\aTop, \afreqs, [5, 125, \lin, 1 ], \atune, \defaultfreqs, i)} !6;
ctr[\btune] = {|i| func.(\bTop, \bfreqs, [5, 125, \lin, 1 ], \btune, \defaultfreqs, i)} !6;

ctr[\afine] = {|i| func.(\aMid, \afine, [-1, 1], \afine, \defaultfine, i)} !6;
ctr[\bfine] = {|i| func.(\bMid, \bfine, [-1, 1], \bfine, \defaultfine, i)} !6;

ctr[\aamp] = {|i| func.(\aLow, \aamps, [-120, -4, \exp], \aamp, \defaultamps, i)} ! 6;
ctr[\bamp] = {|i| func.(\bLow, \bamps, [-120, -4, \exp], \bamp, \defaultamps, i)} ! 6;

gui[\layout] = VLayout(
	gui[\topBar],
	HLayout(
		VLayout(
			gui[\aTop],
			gui[\aMid],
			gui[\aLow],
		),
		VLayout(
			gui[\scopeView],
			gui[\zoomView].maxHeight_(100),
		),
		VLayout(
			gui[\bTop],
			gui[\bMid],
			gui[\bLow],
		),
	),
	gui[\lowBar]
);

SynthDef("scope", {
	var sig;
	sig = In.ar(\in.kr(0), 2);
	// ScopeOut2 writes the audio to the buffer
	// IMPORTANT - ScopeOut2, not ScopeOut
	ScopeOut2.ar(sig, \bufnum.kr(0));
	Out.ar(0, sig*0.1);
}).add;

SynthDef("test3", {
	var a, b, f, sig;
	var afreqs, bfreqs, aamps, bamps;
	afreqs = \afreqs.kr(ctr[\defaultfreqs]) + \afine.kr(ctr[\defaultfine]);
	bfreqs = \bfreqs.kr(ctr[\defaultfreqs]) + \bfine.kr(ctr[\defaultfine]);

	aamps = \aamps.kr(ctr[\defaultamps]);
	bamps = \bamps.kr(ctr[\defaultamps]);

	a = SinOsc.ar(afreqs[0..3].midicps, 0.0, aamps[0..3].dbamp);
	b = SinOsc.ar(bfreqs[0..3].midicps, 0.0, bamps[0..3].dbamp);

	a = a + Pulse.ar(afreqs[4..].midicps, [0.5, 0.2], aamps[4..].dbamp);
	b = b + Pulse.ar(bfreqs[4..].midicps, [0.5, 0.2], bamps[4..].dbamp);

	sig = ((a+b) * \absum.kr(0.5)) + ((a*b) * \abmul.kr(0.5));

	sig = (sig * \dist.kr(1.0)).tanh;

	f = LocalIn.ar(2, 0);
	f = f * \fb.kr(0.0);

	a =  DelayL.ar(sig+f[0], 2, \aspin.kr(0.0, 0.1));
	b =  DelayL.ar(sig+f[1], 2, \bspin.kr(0.0, 0.1) + \finespin.kr(0.0, 0.2));

	LocalOut.ar([a, b]);

	a = a * \alvl.kr(0.5);
	b = b * \blvl.kr(0.5);

	Out.ar(\out.kr(0), [a, b]);
}).add;

// scope view with lvl controls
Slider(gui[\scopeView]).action_({|sl| syn.set(\alvl, [0.0, 1.0].asSpec.map(sl.value))}).value_(0.5);
scope = ScopeView(gui[\scopeView], Rect(0,0,380,380)); // this is SCScope
Slider(gui[\scopeView]).action_({|sl| syn.set(\blvl, [0.0, 1.0].asSpec.map(sl.value))}).value_(0.5);

// controls below scope
Knob(gui[\zoomView]).action_({|sl| syn.set(\absum, [0.0, 1.0].asSpec.map(sl.value))}).value_(0.5);

Slider(gui[\zoomView]).action_({|sl| scope.yZoom = ([0.125, 20, \exp, 1/8, 1].asSpec.map(sl.value))}).valueAction_(0.0);
Slider(gui[\zoomView]).action_({|sl| syn.set(\aspin, [0.0, 0.49].asSpec.map(sl.value))}).value_(0.0);
Slider(gui[\zoomView]).action_({|sl| syn.set(\bspin, [0.0, 0.49].asSpec.map(sl.value))}).value_(0.0);
Slider(gui[\zoomView]).action_({|sl| syn.set(\finespin, [0.0, 0.1, \lin, 0.001].asSpec.map(sl.value))}).value_(0.0);
Slider(gui[\zoomView]).action_({|sl| syn.set(\fb, [-0.2, 0.2].asSpec.map(sl.value))}).value_(0.5);
Slider(gui[\zoomView]).action_({|sl| syn.set(\dist, [1, 50].asSpec.map(sl.value))}).value_(0.0);

Knob(gui[\zoomView]).action_({|sl| syn.set(\abmul, [0.0, 1.0].asSpec.map(sl.value))}).value_(0.5);

buffer = Buffer.alloc(s, 1024,2);
bus = Bus.audio(s, 1); // why 1?

scope.bufnum = buffer.bufnum;
scope.style = 2;
​
// IMPORTANT
scope.server = s;

scopeSyn = Synth.tail(RootNode(s), "scope", [\in, bus.index, \bufnum, buffer.bufnum]);
syn = Synth("test3", [\out, bus.index]);

scope.start;

w.onClose = {
	syn.free; scopeSyn.free; buffer.free; bus.free;
	syn = scopeSyn = scope = func = buffer = bus = nil };

CmdPeriod.doOnce({w.close});
w.layout = gui[\layout];
w.front;
)


(

var win = Window( "Color Picker", Rect( 0, 300, 600, 300 ) );

var picker1;
var picker2;
var picker3;

~get_color_picker = {

	var color = Color( 1, 0, 0 );
	var hsv = [ 0, 1, 1 ];

	var color_picker_view = UserView(); // Main View

	var h_slider = UserView();
	var h_slider_position = 0;

	var sv_slider = UserView();

	var helper = UserView();

	var binded_function = nil;

	var margin; // Slider half dead zone

	// HSV to Color function
	var hsv_to_color = { | hsv |

		var color = Color( 0, 0, 0 );

		var h = hsv[0];
		var s = hsv[1];
		var v = hsv[2];

		var c = s * v;
		var x = c * ( 1 - ( ( h/60.0 )%2.0 -1 ).abs );
		var m = v - c;

		if( ( h >= 0 ) && ( h < 60 ), {
			color.red = c;
			color.green = x;
			color.blue = 0;
		} );

		if( ( h >= 60 ) && ( h < 120 ), {
			color.red = x;
			color.green = c;
			color.blue = 0;
		} );

		if( ( h >= 120 ) && ( h < 180 ), {
			color.red = 0;
			color.green = c;
			color.blue = x;
		} );

		if( ( h >= 180 ) && ( h < 240 ), {
			color.red = 0;
			color.green = x;
			color.blue = c;
		} );

		if( ( h >= 240 ) && ( h < 300 ), {
			color.red = x;
			color.green = 0;
			color.blue = c;
		} );

		if( ( h >= 300 ) && ( h < 360 ), {
			color.red = c;
			color.green = 0;
			color.blue = x;
		} );

		color.red = color.red + m;
		color.green = color.green + m;
		color.blue = color.blue + m;

		color;
	};

	// Resizing adjustments
	color_picker_view.onResize = { | view |
		margin = ( view.bounds.width * 0.05 );
		h_slider.refresh;
		sv_slider.refresh;
	};

	// Hue Slider setup
	h_slider.background_( Color.black );
	h_slider.drawFunc_( { | view |
		Pen.width = 1;
		( view.bounds.height - ( margin * 2 ) ).do( { | index |
			Pen.strokeColor_(
				hsv_to_color.value(
					[
						index.linlin(
							0,
							( view.bounds.height - ( margin * 2 ) ),
							0,
							360
						),
						hsv[1],
						hsv[2]
					];
				);
			);

			Pen.moveTo( Point( margin, index + margin ) );
			Pen.lineTo( Point( view.bounds.width - margin, index + margin ) );
			Pen.stroke;
		} );

		Pen.addRect(
			Rect(
				margin / 2,
				margin / 2 + ( view.bounds.height - ( margin * 2 ) * h_slider_position ) + margin,
				view.bounds.width - margin,
				margin
			)
		);
		Pen.fillAxialGradient(
			Point( 0, margin / 2 + ( view.bounds.height - ( margin * 2 ) * h_slider_position ) + margin ),
			Point( 0, margin / 2 + ( view.bounds.height - ( margin * 2 ) * h_slider_position ) + ( margin * 2 ) ),
			Color( 0, 0, 0, 1 ),
			Color( 0, 0, 0, 0 )
		);

		Pen.addRect(
			Rect(
				margin / 2,
				margin / 2 + ( view.bounds.height - ( margin * 2 ) * h_slider_position ) - margin,
				view.bounds.width - margin,
				margin
			)
		);
		Pen.fillAxialGradient(
			Point( 0, margin / 2 + ( view.bounds.height - ( margin * 2 ) * h_slider_position ) - margin ),
			Point( 0, margin / 2 + ( view.bounds.height - ( margin * 2 ) * h_slider_position ) ),
			Color( 0, 0, 0, 0 ),
			Color( 0, 0, 0, 1 )
		);

		Pen.fillColor_( color );
		Pen.fillRect(
			Rect(
				margin / 2,
				margin / 2 + ( view.bounds.height - ( margin * 2 ) * h_slider_position ),
				view.bounds.width - margin,
				margin
			)
		)
	} );

	h_slider.mouseDownAction_( { | view, x, y |
		if( y >= margin, {
			if( y <= ( view.bounds.height - margin ), {
				h_slider_position = y.linlin( margin, view.bounds.height - margin, 0, 1 );
				y = y.linlin( margin, view.bounds.height - margin, 0, 360 );
				hsv[0] = y;
				color = hsv_to_color.value( hsv );
				if( binded_function != nil, { binded_function.value( color ) } );
				h_slider.refresh;
				helper.refresh;
				sv_slider.refresh;
			} )
		} )
	} );
	h_slider.mouseMoveAction_( h_slider.mouseDownAction );

	// Saturation Slider setup
	sv_slider.background_( Color.black );
	sv_slider.drawFunc_( { | view |

		( view.bounds.width - ( margin * 2 ) ).do( { | index_x |
			Pen.addRect(
				Rect(
					margin + index_x,
					margin,
					1,
					view.bounds.height - ( margin * 2 )
				)
			);
			Pen.fillAxialGradient(
				Point( 0, margin ),
				Point( 0, view.bounds.height - ( margin * 2 ) ),
				Color.black,
				hsv_to_color.value(
					[
						hsv[0],
						index_x.linlin( 0, view.bounds.width, 0, 1 ),
						1
					]
				)
			);
		} );

		Pen.addWedge(
			Point(
				view.bounds.width - ( margin * 2 ) * hsv[1] + margin,
				view.bounds.height - ( margin * 2 ) * hsv[2] + margin,
			),
			margin * 2,
			0,
			360
		);
		Pen.fillRadialGradient(
			Point(
				view.bounds.width - ( margin * 2 ) * hsv[1] + margin,
				view.bounds.height - ( margin * 2 ) * hsv[2] + margin,
			),
			Point(
				view.bounds.width - ( margin * 2 ) * hsv[1] + margin,
				view.bounds.height - ( margin * 2 ) * hsv[2] + margin,
			),
			margin,
			margin * 1.5,
			Color( 0, 0, 0, 1 ),
			Color( 0, 0, 0, 0 )
		);

		Pen.fillColor_( color );
		Pen.addWedge(
			Point(
				view.bounds.width - ( margin * 2 ) * hsv[1] + margin,
				view.bounds.height - ( margin * 2 ) * hsv[2] + margin,
			),
			margin,
			0,
			360
		);
		Pen.fill;
	} );

	sv_slider.mouseDownAction_( { | view, x, y |

		case
		{ x < margin } { hsv[1] = 0 }
		{ x > ( view.bounds.width + margin ) } { hsv[1] = 1 }
		{ ( ( x >= margin ) && ( x <= ( view.bounds.width - margin ) ) ) } {
			hsv[1] = x.linlin( margin, view.bounds.width - margin, 0, 1 );
		};

		case
		{ y < margin } { hsv[2] = 0 }
		{ y > ( view.bounds.height + margin ) } { hsv[2] = 1 }
		{ ( ( y >= margin ) && ( y <= ( view.bounds.height - margin ) ) ) } {
			hsv[2] = y.linlin( margin, view.bounds.height - margin, 0, 1 );
		};

		color = hsv_to_color.value( hsv );
		if( binded_function != nil, { binded_function.value( color ) } );
		helper.refresh;
		sv_slider.refresh;
		h_slider.refresh;
	} );
	sv_slider.mouseMoveAction_( sv_slider.mouseDownAction );

	helper.drawFunc_( { | view |
		Pen.fillColor_( color );
		Pen.fillRect(
			Rect(
				0,
				0,
				view.bounds.width,
				view.bounds.height
			)
		)
	} );

	// Background Color
	color_picker_view.background_( Color.black );
	color_picker_view.layout_(
		VLayout(
			[ helper, stretch:1 ],
			[ HLayout(
				[ h_slider, stretch: 1 ],
				[ sv_slider, stretch: 2 ]
			), stretch:2 ]
		);
	);

	color_picker_view.addUniqueMethod( \bindFunction, { | object, function | binded_function = function } );

	color_picker_view
};

picker1 = ~get_color_picker.value();
picker2 = ~get_color_picker.value();
picker3 = ~get_color_picker.value();

win.layout_( HLayout( picker1, picker2, picker3 ) );
win.background_( Color( 0.2, 0.2, 0.2 ) );
win.front

)

(

/*

Demonstration of a HSV Color Picker, raw version

Steps :

1) Copy/Paste get_color_picker() alongside a variable which will store the UserView.
( color_picker = get_color_picker.value(); <- color_picker is an UserView )

2) Create a function that the color picker will call when used. As is, only takes a Color() as arg.
( modulate_color_via_picker = { | color | ... }; )

3) Bind the two of them, using : userview_variable.bindFunction( function );
( color_picker.bindFunction( modulate_color_via_picker ) )

Pink ftw, D.

*/

var win = Window.new( bounds:Rect(300,300,300,600) );

var outer_view = UserView();
var modulated_color = Color.red;
var modulate_color_via_picker;

var color_picker;
var get_color_picker;

get_color_picker = {

	var color = Color( 1, 0, 0 );
	var hsv = [ 0, 1, 1 ];

	var color_picker_view = UserView();
	var h_slider = UserView();
	var sv_slider = UserView();
	var helper = UserView();

	var binded_function = nil;

	var hsv_to_color = { | hsv |

		var color = Color( 0, 0, 0 );

		var h = hsv[0];
		var s = hsv[1];
		var v = hsv[2];

		var c = s * v;
		var x = c * ( 1 - ( ( h/60.0 )%2.0 -1 ).abs );
		var m = v - c;

		if( ( h >= 0 ) && ( h < 60 ), {
			color.red = c;
			color.green = x;
			color.blue = 0;
		} );

		if( ( h >= 60 ) && ( h < 120 ), {
			color.red = x;
			color.green = c;
			color.blue = 0;
		} );

		if( ( h >= 120 ) && ( h < 180 ), {
			color.red = 0;
			color.green = c;
			color.blue = x;
		} );

		if( ( h >= 180 ) && ( h < 240 ), {
			color.red = 0;
			color.green = x;
			color.blue = c;
		} );

		if( ( h >= 240 ) && ( h < 300 ), {
			color.red = x;
			color.green = 0;
			color.blue = c;
		} );

		if( ( h >= 300 ) && ( h < 360 ), {
			color.red = c;
			color.green = 0;
			color.blue = x;
		} );

		color.red = color.red + m;
		color.green = color.green + m;
		color.blue = color.blue + m;

		color;
	};

	h_slider.drawFunc_( { | view |
		Pen.width = 1;
		view.bounds.height.do( { | index |
			Pen.strokeColor_(
				hsv_to_color.value(
					[
						index.linlin(
							0,
							view.bounds.height,
							0,
							360
						),
						1,
						1
					];
				);
			);
			Pen.moveTo( Point( 0, index ) );
			Pen.lineTo( Point( view.bounds.width, index ) );
			Pen.stroke;
		} );
	} );

	h_slider.mouseDownAction_( { | view, x, y |
		y = y.linlin( 0, view.bounds.height, 0, 360 );
		hsv[0] = y;
		color = hsv_to_color.value( hsv );
		if( binded_function != nil, { binded_function.value( color ) } );
		helper.refresh;
		sv_slider.refresh;
	} );
	h_slider.mouseMoveAction_( h_slider.mouseDownAction );

	sv_slider.drawFunc_( { | view |

		view.bounds.width.do( { | index_x |
			Pen.addRect(
				Rect(
					index_x,
					0,
					1,
					view.bounds.height
				)
			);
			Pen.fillAxialGradient(
				Point(0,0),
				Point(0,view.bounds.height),
				Color.black,
				hsv_to_color.value(
					[
						hsv[0],
						index_x.linlin( 0, view.bounds.width, 0, 1 ),
						1
					]
				)
			);

		} );
	} );

	sv_slider.mouseDownAction_( { | view, x, y |
		x = x.linlin( 0, view.bounds.width, 0, 1 );
		y = y.linlin( 0, view.bounds.height, 0, 1 );
		hsv[1] = x;
		hsv[2] = y;
		color = hsv_to_color.value( hsv );
		if( binded_function != nil, { binded_function.value( color ) } );
		helper.refresh;
	} );
	sv_slider.mouseMoveAction_( sv_slider.mouseDownAction );

	helper.drawFunc_( { | view |
		Pen.fillColor_( color );
		Pen.fillRect(
			Rect(
				0,
				0,
				view.bounds.width,
				view.bounds.height
			)
		)
	} );

	color_picker_view.background_( Color( 0.5, 0.5, 0.5 ) );
	color_picker_view.layout_(
		VLayout(
			[ helper, stretch:1 ],
			[ HLayout(
				[ h_slider, stretch: 1 ],
				[ sv_slider, stretch: 2 ]
			), stretch:2 ]
		);
	);

	color_picker_view.addUniqueMethod( \bindFunction, { | object, function | binded_function = function } );

	color_picker_view
};


color_picker = get_color_picker.value();
outer_view.drawFunc = { | view |
	Pen.stringCenteredIn(
		"Hey !,\nI'm located OUTSIDE of\nthe color picker !\n:3",
		Rect(
			0,
			0,
			view.bounds.width,
			view.bounds.height
		),
		color: modulated_color
	)
};

//That's probably what you are looking for :
modulate_color_via_picker = { | color |
	modulated_color = color;
	outer_view.refresh;
};
color_picker.bindFunction( modulate_color_via_picker );

win.layout_(
	VLayout(
		[ outer_view, stretch:1 ],
		[ color_picker, stretch:1 ]
	)
);

win.front;

)


(

var win = Window.new( "", Rect( 0, 800, 700, 400 ) ); // This will be our main window

var instrument_file = {};

var main_view = UserView();
var layout = UserView();
var background_color = Color( 0, 0, 0 );

var rythm = Point( 4, 4 );
var rythm_length = ( rythm.x * rythm.y );
var tempo = 1;

var parameters = Array.fill( 4,
	{ Array.fill( ( rythm_length + 1 ), { 0 } ) } );

var colors = [
	Color( 1, 0.8, 0 ),
	Color( 0, 1, 1 ),
	Color( 1, 0.2, 0.2 ),
	Color( 1, 0.6, 0.6 )
];

var button_rack_view = UserView().maxWidth_( 100 );
var selected_view = 0;

var views = Array.fill( parameters.size,
	{ UserView() } );

var synth = SynthDef( \synth, { | out, freq = 200, amp = 0.25 |

	var snd, snd2, release;

	var env, envctl;
	var env2, envctl2;
	var env3, envctl3;
	var env4, envctl4;

	env = Env.newClear(rythm_length);
	envctl = \env.kr(env.asArray);
	env2 = Env.newClear(rythm_length);
	envctl2 = \env2.kr(env2.asArray);
	env3 = Env.newClear(rythm_length);
	envctl3 = \env3.kr(env3.asArray);
	env4 = Env.newClear(rythm_length);
	envctl4 = \env4.kr(env4.asArray);

	release = EnvGen.kr( Env( [0,1,1,0], times: [ 0.1, rythm_length / 4, 0.1 ] ), doneAction: Done.freeSelf );

	snd =
	SinOsc.ar( freq, 0, 0.5 ) +
	SinOsc.ar( freq * 2, 0, 0.4 ) +
	SinOsc.ar( freq * 4, 0, 0.3 ) +
	SinOsc.ar( freq * 8, 0, 0.35  * EnvGen.kr( envctl3 ) ) +
	SinOsc.ar( freq * 16, 0, 0.35  * EnvGen.kr( envctl3 ) );

	snd = RLPF.ar(
		snd,
		freq / 2 + ( freq * EnvGen.kr( envctl2 ) * 2 ),
		0.5
	);

	snd2 =
	SinOsc.ar( freq * 1.001, 0, 0.5 ) +
	SinOsc.ar( freq * 1.001 * 2, 0, 0.4 ) +
	SinOsc.ar( freq * 1.001 * (3/2), 0, 0.3 );

		snd2 = RLPF.ar(
		snd2,
		freq / 2 + ( ( freq * 2 * ( 3/2 ) * EnvGen.kr( envctl4 ) * 4 ) ),
		0.5
	);

	snd = snd * EnvGen.kr( envctl );
	snd2 = snd2 * EnvGen.kr( envctl3 );

	snd = Mix.ar( [ snd, snd2 ] );

	snd = snd * amp * release;

	Out.ar( out, snd )

} ).play;

var routine = Routine.new( {
	loop {
		Synth(\synth, [
			\env, Env( parameters[0], Array.fill( rythm_length -1, { 1 / rythm_length } )),
			\env2, Env( parameters[1], Array.fill( rythm_length -1, { 1 / rythm_length } )),
			\env3, Env( parameters[2], Array.fill( rythm_length -1, { 1 / rythm_length } )),
			\env4, Env( parameters[3], Array.fill( rythm_length -1, { 1 / rythm_length } )),
		]);
		1.wait;
	};
} ).play;

win.layout_(
	VLayout(
		main_view
	).margins_(0)
);

main_view.layout_(
	HLayout(
		button_rack_view,
		layout
	).margins_(3)
);

layout.layout_(
	StackLayout(
		views[0],
		views[1],
		views[2],
		views[3],
	).margins_(3).mode_(1)
);

main_view.background_( background_color );

button_rack_view.drawFunc = { | view |

	var case_height = view.bounds.height / parameters.size;

	Pen.fillColor_( colors[ selected_view ] );
	Pen.fillRect(
		Rect(
			case_height * 0.2,
			case_height * selected_view + ( case_height * 0.2 ),
			view.bounds.width - ( case_height * 0.4 ),
			case_height - ( case_height * 0.4 )
		)
	);
};

button_rack_view.refresh;

button_rack_view.mouseDownAction_( { | view, x, y |

	var selection_y = y.linlin(
		0,
		view.bounds.height,
		0,
		4,
		clip: 'minmax'
	).asInt;

	selected_view = selection_y;

	views.do( { | view, index |
		if( index == selected_view, {
			view.visible_( true )
		}, {
			view.visible_( false )
		} );
	} );

	button_rack_view.refresh;
} );

views.do( { | view, view_index |

	view.background_( Color( 0.25, 0.25, 0.25 ) );

	view.drawFunc_( { | view |

		var case_size = view.bounds.width / rythm_length;

		// Back Shadow Vertical Sections
		Pen.strokeColor_( Color( 0, 0, 0, 0.5 ) );
		Pen.width = case_size * 0.15;
		rythm_length.do( { | index |
			Pen.moveTo(
				Point(
					case_size * index,
					0 )
			);
			Pen.lineTo(
				Point(
					case_size * index,
					view.bounds.height )
			);
		} );
		Pen.stroke;

		// Draw Mountain
		Pen.strokeColor_( Color.black );
		Pen.fillColor_( colors[ view_index ] );
		Pen.width = case_size * 0.2;
		Pen.moveTo(
			Point(
				0,
				view.bounds.height * ( 1 - parameters[ view_index ][ 0 ] ) -
				( view.bounds.height * 0.05 )
			)
		);
		rythm_length.do( { | index |
			Pen.lineTo(
				Point(
					case_size * index + ( case_size * 0.5 ),
					view.bounds.height * ( 1 - parameters[ view_index ][ index ] ) -
					( view.bounds.height * 0.05 )
				)
			);
		} );
		Pen.lineTo(
			Point(
				view.bounds.width,
				view.bounds.height ));
		Pen.lineTo(
			Point(
				0,
				view.bounds.height ));
		Pen.lineTo(
			Point(
				0,
				view.bounds.height * ( 1 - parameters[ view_index ][ 0 ] )));
		Pen.fillStroke;

		// Draw Vertical Sections
		Pen.strokeColor_( Color( 0, 0, 0, 0.25 ) );
		Pen.width = case_size * 0.1;
		rythm_length.do( { | index |
			Pen.moveTo(
				Point(
					case_size * index + ( case_size * 0 ),
					0 )
			);
			Pen.lineTo(
				Point(
					case_size * index + ( case_size * 0.25 ),
					view.bounds.height )
			);
		} );
		Pen.stroke;

		// Draw Mountain 2
		Pen.strokeColor_( Color( 0.2, 0.2, 0.2, 0.75 ) );
		Pen.fillColor_( Color( 0, 0, 0, 0.25 ) );
		Pen.width = case_size * 0.1;
		Pen.moveTo(
			Point(
				0,
				view.bounds.height * ( 1 - parameters[ view_index ][ 0 ] ) +
				( view.bounds.height - ( view.bounds.height * ( 1 - parameters[ view_index ][ 0 ] ) ) * 0.05 )
			)
		);
		rythm_length.do( { | index |
			Pen.lineTo(
				Point(
					case_size * index + ( case_size * 0.5 ),
					view.bounds.height * ( 1 - parameters[ view_index ][ index ] ) +
					( view.bounds.height - ( view.bounds.height * ( 1 - parameters[ view_index ][ index ] ) ) * 0.05 )
				)
			);
		} );
		Pen.lineTo(
			Point(
				view.bounds.width,
				view.bounds.height
			)
		);
		Pen.lineTo(
			Point(
				0,
				view.bounds.height
			)
		);
		Pen.lineTo(
			Point(
				0,
				view.bounds.height * ( 1 - parameters[ view_index ][ 0 ] )
			)
		);
		Pen.fillStroke;

		// Front Vertical Sections
		Pen.strokeColor_( Color( 0, 0, 0, 0.15 ) );
		Pen.width = case_size * 0.05;
		rythm_length.do( { | index |
			Pen.moveTo(
				Point(
					case_size * index,
					0 )
			);
			Pen.lineTo(
				Point(
					case_size * index,
					view.bounds.height )
			);
		} );
		Pen.stroke;

	} );

	view.mouseDownAction_( { | view, x, y |

		var selection_x = x.linlin(
			0,
			view.bounds.width,
			0,
			rythm_length,
			clip: 'minmax'
		).asInt();

		var selection_y = y.linlin(
			0,
			view.bounds.height,
			1,
			0,
			clip: 'minmax'
		);

		if( selection_x == rythm_length, { selection_x = rythm_length- 1 } );

		parameters[ view_index ][ selection_x ] = selection_y;
		view.refresh;

	} );

	view.mouseMoveAction_( view.mouseDownAction );
} );



win.front;
win.onClose = {
	Window.closeAll;
};

)

(
// GrainOTec module for SuperCollider, by Dindoléon
// licensed under GNU GPL v3
// Have fun, but take care with the DBs !

var win, rout, draw_slider, font;

var volume, volume_slider, volume_value, volume_label, volume_color;
var lifetime, lifetime_slider, lifetime_value, lifetime_label, lifetime_color;
var env, env_array, env_points, env_slider, env_duration, env_multiSlider, env_value, env_label, env_color;
var freq, base_freq, freq_value, freq_slider, freq_mul, freq_mul_value, freq_mul_slider, freq_label, freq_mul_label, freq_color, freq_mul_color;
var pan, pan_value, pan_slider, pan_label, pan_color;

var icon_size = 10, stroke_size = 2, outline_size = 15;

font = Font( size: 20 );

base_freq = 220;
freq = [base_freq];
freq_value = 0;

freq_mul = 1;
freq_mul_value = 0;

volume = 0;
volume_value = 0;

lifetime = 0.005;
lifetime_value = 0.6;

pan = 0;
pan_value = 0;

env_duration = 0.005;
env_value = 0.6;

env_points = 8;
env_array = Array.fill(env_points+2, 0);

volume_color = Color( 0.8, 0, 0.3 );
lifetime_color = Color( 0, 0.3, 0.8 );
env_color = Color( 0, 0.8, 0.3 );
freq_color = Color( 0.8, 0.3, 0 );
freq_mul_color = Color( 0.3, 0, 0.8 );
pan_color = Color( 0.3, 0.8, 0 );

env = Env.new(
	levels: env_array,
	times: Array.fill(env_points+1, env_duration/(env_points+1))
);

SynthDef(\grain, { | freq = 220 |
	var snd, env, envctl, envgen, pan, amp;

	env = Env.newClear( 10 );
	envctl = \env.kr( env.asArray );
	envgen = EnvGen.ar( envctl, 1, doneAction: 2 );
	snd = LinPan2.ar( SinOsc.ar( freq ) * envgen * \amp.kr(1), \pan.ar(0) );

	Out.ar( 0, snd ); }).add;

rout = Routine {
	loop {
		freq.do( { |f| Synth(\grain, [\freq, f, \amp, volume/freq.size, \env, env, \pan, pan.asFloat.rand] ) });
		lifetime.yield;
	};
}.play();

win = Window("GrainOTec", Rect( 5, 5, 305, 300 ), false );
win.background_(Color.black);
win.front;

// Volume Slider
volume_slider = UserView( win, Rect( 5, 5, 45, 190 ));
volume_slider.drawFunc = { draw_slider.value( volume_slider, volume_value, volume_color ) };
volume_slider.mouseDownAction = { | volume_slider, x, y, m |
	volume_value = (y).linlin( 0, volume_slider.bounds.height, 1, 0 );
	volume = volume_value;
	volume_slider.refresh };
volume_slider.mouseMoveAction = volume_slider.mouseDownAction;
volume_label = StaticText( volume_slider, Rect( 25, 165, 28, 28 ));
volume_label.string_("a");
volume_label.font_(font);
volume_label.stringColor_(Color(1,1,1,0.75));

// Lifetime Slider
lifetime_slider = UserView( win, Rect( 55, 5, 45, 190 ));
lifetime_slider.drawFunc = { draw_slider.value( lifetime_slider, lifetime_value, lifetime_color ) };
lifetime_slider.mouseDownAction = { | lifetime_slider, x, y, m |
	lifetime_value = (y).linlin( 0, lifetime_slider.bounds.height, 1, 0 );
	lifetime = lifetime_value.linexp( 0, 1, 0.1, 0.001 );
	lifetime_slider.refresh };
lifetime_slider.mouseMoveAction = lifetime_slider.mouseDownAction;
lifetime_label = StaticText( lifetime_slider, Rect( 25, 165, 28, 28 ));
lifetime_label.string_("t");
lifetime_label.font_(font);
lifetime_label.stringColor_(Color(1,1,1,0.75));

// Env Slider
env_slider = UserView( win, Rect( 105, 5, 45, 190 ));
env_slider.drawFunc = { draw_slider.value( env_slider, env_value, env_color ) };
env_slider.mouseDownAction = { | env_slider, x, y, m |
	env_value = (y).linlin( 0, env_slider.bounds.height, 1, 0 );
	env_duration = env_value.linexp( 0, 1, 0.1, 0.001 );
	env.times = Array.fill(env_points+1, env_duration/(env_points+1));
	env_slider.refresh };
env_slider.mouseMoveAction = env_slider.mouseDownAction;
env_label = StaticText( env_slider, Rect( 25, 165, 28, 28 ));
env_label.string_("d");
env_label.font_(font);
env_label.stringColor_(Color(1,1,1,0.75));

// Freq Slider
freq_slider = UserView( win, Rect( 155, 5, 45, 190 ));
freq_slider.drawFunc = { draw_slider.value( freq_slider, freq_value, freq_color ) };
freq_slider.mouseDownAction = { | freq_slider, x, y, m |
	freq_value = (y).linlin( 0, freq_slider.bounds.height, 1, 0 );
	freq = Array.fill(freq_value.linlin( 0, 1, 1, 7 ).asInt, base_freq);
	if( freq_value.linlin( 0, 1, 1, 7 ).asInt > 1, { for( 1, freq_value.linlin( 0, 1, 1, 7 ).asInt -1, { |i| freq[i] = freq[i-1] * freq_mul; } ) });
	freq_slider.refresh };
freq_slider.mouseMoveAction = freq_slider.mouseDownAction;
freq_label = StaticText( freq_slider, Rect( 25, 165, 28, 28 ));
freq_label.string_("h");
freq_label.font_(font);
freq_label.stringColor_(Color(1,1,1,0.75));

// Freq Mul Slider
freq_mul_slider = UserView( win, Rect( 205, 5, 45, 190 ));
freq_mul_slider.drawFunc = { draw_slider.value( freq_mul_slider, freq_mul_value, freq_mul_color ) };
freq_mul_slider.mouseDownAction = { | freq_slider, x, y, m |
	freq_mul_value = (y).linlin( 0, freq_slider.bounds.height, 1, 0 );
	freq_mul = 1 + freq_mul_value;
	freq = Array.fill(freq_value.linlin( 0, 1, 1, 7 ).asInt, base_freq);
	if( freq_value.linlin( 0, 1, 1, 7 ).asInt > 1, { for( 1, freq_value.linlin( 0, 1, 1, 7 ).asInt -1, { |i| freq[i] = freq[i-1] * freq_mul; } ) });
	freq_mul_slider.refresh };
freq_mul_slider.mouseMoveAction = freq_mul_slider.mouseDownAction;
freq_mul_label = StaticText( freq_mul_slider, Rect( 25, 165, 28, 28 ));
freq_mul_label.string_("m");
freq_mul_label.font_(font);
freq_mul_label.stringColor_(Color(1,1,1,0.75));

// Pan Slider
pan_slider = UserView( win, Rect( 255, 5, 45, 190 ));
pan_slider.drawFunc = { draw_slider.value( pan_slider, pan_value, pan_color ) };
pan_slider.mouseDownAction = { | lifetime_slider, x, y, m |
	pan_value = (y).linlin( 0, lifetime_slider.bounds.height, 1, 0 );
	pan = pan_value;
	pan_slider.refresh };
pan_slider.mouseMoveAction = pan_slider.mouseDownAction;
pan_label = StaticText( pan_slider, Rect( 25, 165, 28, 28 ));
pan_label.string_("p");
pan_label.font_(font);
pan_label.stringColor_(Color(1,1,1,0.75));

// Enveloppe MultiSlider
env_multiSlider = MultiSliderView( win, Rect( 5, 200, 295, 90 ) );
env_multiSlider.value = Array.fill(env_points, {0.0});
env_multiSlider.isFilled = true;
env_multiSlider.elasticMode_(true);
env_multiSlider.fillColor = Color(0,0,0.1);
env_multiSlider.strokeColor = Color.red;
env_multiSlider.background_(Color(0,0,0.2));
env_multiSlider.gap = 0;
env_multiSlider.drawRects = false; // Display as bar charts
env_multiSlider.drawLines = true; // Display as plot

env_multiSlider.action = { arg multi;
	var index = multi.index;
	var value = multi.currentvalue;
	env_array[(index+1)] = value;
	env.levels = env_array; };

// Slider Draw Function
draw_slider = { | slider, value, color |
	Pen.width = stroke_size;

	// Draw the frame
	Pen.strokeColor = Color.white;
	Pen.fillColor = Color.black;
	Pen.addRect(Rect(0, 0, slider.bounds.width,slider.bounds.height));
	Pen.draw(3);

	// Draw the losange
	Pen.moveTo( ( slider.bounds.width/2 ) @ ( ( slider.bounds.height - ( slider.bounds.height * value) ) - icon_size ) );
	Pen.lineTo( ( slider.bounds.width/2 -icon_size ) @ ( slider.bounds.height - (slider.bounds.height*value) ) );
	Pen.lineTo( ( slider.bounds.width/2 ) @ ( ( slider.bounds.height - ( slider.bounds.height * value) ) + icon_size ) );
	Pen.lineTo( ( slider.bounds.width/2 + icon_size ) @ ( slider.bounds.height - (slider.bounds.height*value) ) );
	Pen.lineTo( ( slider.bounds.width/2 ) @ ( ( slider.bounds.height - ( slider.bounds.height * value) ) - icon_size ) );

	Pen.fillColor = color;
	Pen.fill;

	Pen.moveTo( ( slider.bounds.width/2 ) @ ( ( slider.bounds.height - ( slider.bounds.height * value) ) - outline_size ) );
	Pen.lineTo( ( slider.bounds.width/2 -outline_size ) @ ( slider.bounds.height - (slider.bounds.height*value) ) );
	Pen.lineTo( ( slider.bounds.width/2 ) @ ( ( slider.bounds.height - ( slider.bounds.height * value) ) + outline_size ) );
	Pen.lineTo( ( slider.bounds.width/2 + outline_size ) @ ( slider.bounds.height - (slider.bounds.height*value) ) );
	Pen.lineTo( ( slider.bounds.width/2 ) @ ( ( slider.bounds.height - ( slider.bounds.height * value) ) - outline_size ) );

	Pen.moveTo( ( slider.bounds.width/2 ) @ 0 );
	Pen.lineTo( ( slider.bounds.width/2 ) @ ( ( slider.bounds.height - ( slider.bounds.height * value) ) - outline_size ) );

	Pen.moveTo( ( slider.bounds.width/2 ) @ ( slider.bounds.height ) );
	Pen.lineTo( ( slider.bounds.width/2 ) @ ( ( slider.bounds.height - ( slider.bounds.height * value) ) + outline_size ) );

	Pen.strokeColor = color;
	Pen.stroke;
};
)


// Color Picker GUIs

( // OSX Only

var res = 20, scrsize = 200, val, set, win, scr;
win = Window.new("SCColorChooser",Rect(400, 400, 2*scrsize+20, scrsize),false).front;
win.view.background_(Color.white);
scr = CompositeView.new(win,Rect(scrsize+20, 0, scrsize, scrsize));
scr.background_(Color.white);
val = Slider(win, Rect(scrsize, 0, 20, scrsize)).value_(1).action_({win.refresh});
m = TabletSlider2D(win, Rect(0, 0, scrsize, scrsize))
	.mouseDownAction_({arg view, x, y; 
		("Color.hsv("++(x)++", "++(1-y)++", "++val.value++", 1)").postln; 
		Color.hsv(min(0.999, x), min(0.999, 1-y), val.value, 1).postln; 
		scr.background_(Color.hsv(min(0.999, x), min(0.999, 1-y), val.value, 1));
	});
win.drawHook = {
	res.do({ arg i;
		res.do({ arg j;
			Color.hsv(1/res*i,1/res*j, val.value, 1).set;
			Pen.fillRect(Rect((scrsize/res)*i, (scrsize/res)*j, (scrsize/res), (scrsize/res)));
		})
	})
};
win.front;

)

// SCColorChooser by scsolar 10.2007




	 (
	 {
		var w,r,g,b,update,color;
		w = Window.new("Color Picker",Rect(100,100,230,68),false);
		r = EZSlider(w, Rect(2,0,150,20),"R",labelWidth:20)
		.action_({ |v| update.(); });
		g = EZSlider(w, Rect(2,22,150,20),"G",labelWidth:20)
		.action_({ |v| update.(); });

		b = EZSlider(w, Rect(2,44,150,20),"B",labelWidth:20)
		.action_({ |v| update.(); });
		
		[r,g,b].do({|item| item.sliderView.canFocus_(false) });

		color = UserView(w,Rect(160,0,64,64))
		.background_(Color.black)
		.enabled_(true)
		.mouseDownAction_({ color.background.postln;})
		.beginDragAction_({color.background})
		.canFocus_(false);

		
		update = { color.background_(Color(r.value,g.value,b.value)) }; 

		w.front;

	}.value
	 )


(
var res = 20, scrsize = 200, val, set, win, scr, currentColor = Color.gray, setColor;
win = Window.new("color picker",Rect(400, 400, 2*scrsize+20, scrsize),false).front;

//win.view.background_(Color.white);

scr = UserView.new(win,Rect(scrsize+20, 0, scrsize, scrsize));
scr.background_(Color.white);

setColor = {|x, y, val, postVal=false|
	//x = x/scrsize;
	//y = y/scrsize;

	currentColor = Color.hsv(min(0.999, x), min(0.999, 1-y), val, 1);
	postVal.if{
//		("Color.hsv("++(x)++", "++(1-y)++", "++val.value++", 1)").postln; 
		"Color.new255(%, %, %)".format(*(currentColor.asArray*255)).postln; 
	};

	scr.background_(
		Color.hsv(min(0.999, x), min(0.999, 1-y), val.value, 1)
	);
};




val = Slider(win, Rect(scrsize, 0, 20, scrsize)).value_(1).action_({|view|
	setColor.(m.x.postln, m.y, view.value);
	
	win.refresh
});

m = Slider2D(win, Rect(0, 0, scrsize, scrsize))
	.mouseDownAction_({|view| 
		setColor.(view.x, view.y, val.value);
		win.refresh
	})
	.mouseMoveAction_({|view|
		setColor.(view.x, view.y, val.value);
		win.refresh
	}).mouseUpAction_({|view| 
		setColor.(view.x, view.y, val.value, true);
		win.refresh
	});

win.front;
)
