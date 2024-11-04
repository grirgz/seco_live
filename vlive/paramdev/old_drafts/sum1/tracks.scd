
"~/code/sc/seco/vlive/explore/mars/drumkit.scd".standardizePath.load
(
TempoClock.default.tempo = 1;
ParamProto.init;
TrackDef(\proxy_player, (
	play: { arg self;
		self.proxy.play;
		if(self.mixer.notNil) {
			self.mixer.play;
		};
		self.changed(\play, self.proxy.quant);
	},

	stop: { arg self;
		self.proxy.stop;
		if(self.mixer.notNil) {
			//self.mixer.stop; // never stop mixers!
		};
		self.changed(\stop, self.proxy.quant);
	},

	quant: { arg self;
		self.proxy.quant;
	},

	quant_: { arg self, val;
		self.proxy.quant = val;
	},

	isPlaying: { arg self;
		self.proxy.isPlaying and: {
			self.mixer.isNil or: { self.mixer.isPlaying }
		};
	},
));
TrackDef(\drum, TrackDef(\proxy_player).copy.putAll((

	label: { arg self; self.key },
	stepevent: { arg self; StepEventDef(self.key) },
	tracktype: \drum,

	init: { arg self;
		"hello!".debug;
		self.proxy = EventPatternProxy.new;
		self.stepevent[\isRest] = self.stepevent[\isRest] ?? { StepList.newFrom(0!8) };
		//StepEventDef(self.key)[\freq] = StepEventDef(self.key)[\freq] ?? { StepList.newFrom(400!8) };
		"hello!".debug;
		self.stepevent.repeats = inf;
		"hello!".debug;
		self.stepevent.addSpec(\isRest, \unipolar);
		"hello!".debug;
		self.stepevent[\isRest].addSpec(\list, \unipolar);
		"hello!".debug;
		self.mixer = ~trackMixerDef.new(self.key);
		self.mixer.define_mixer;
		self.init_mixer_busses;
		self.proxy.set(\out, self.mixer.inbus);
		self.children = SparseArray.new;
		self.childProxy = EventPatternProxy.new.source_(Pbind());
	},

	init_mixer_busses: { arg self;
		8.do { arg x;
			self.mixer.proxy.set(\sendbus+++x, BusDef(\sendbus+++x, \audio, self.mixer.numchannels))
		}
	},

	source_: { arg self, val;
		var pat;
		val.debug("source set");
		self[\source] = val;
		pat = self.stepevent.asPattern <> val;
		//if( self.children.size > 0 ) {
			pat = self.childProxy <> pat;
		//};
		self.proxy.source = pat;
		self.proxy.source.debug("source set");
		self;
	},

	childAt: { arg self, idx;
		self.children[idx] ?? {
			self.children[idx] = TrackDef(\subdrum).new(self, idx);
			self.children[idx];
		};
	},

	quant: { arg self;
		self.proxy.quant;
		//self.childProxy.quant;
	},

	quant_: { arg self, val;
		self.proxy.quant = val;
		self.childProxy.quant = val;
	},

	stopPart: { arg self;
		self.proxy.stop;
		self.changed(\stop, self.proxy.quant);
	},

	selectChild: { arg self, idx;
		self.selectedChild = idx; // to be deprecated, should be an object instead an index
		self.selectedIndex = idx;
		self.childProxy.source = self.childAt(idx).asPattern;
	},

	asParamGroup: { arg self;
		ParamGroup(self.source.asParamGroup.collect{ arg par;
			Param(self.stepevent, par.property, par.spec).default_(par.get)
		})
	},

	edit: { arg self;
		WindowDef(self.key, { 
			VLayout(
				PlayerWrapper(self).asView,
				~stepEventCoinView.new(self.stepevent).hasCursor_(true).asView,
				ParamGroupLayout.inline_groups(self.asParamGroup),
			)
		}).front;
	},
)));

TrackDef(\subdrum, TrackDef(\drum).copy.putAll((
	label: { arg self; self.parentTrack.label ++ " " ++ self.index.asString },
	tracktype: { arg self; self.parentTrack.tracktype },
	new: { arg self, parent, idx;
		self = self.deepCopy;

		self.index = idx;
		self.parentTrack = {parent};
		self[\play].asCompileString.debug("play fun!!!");
	
		self[\stepevent] = StepEvent.new;
		self.init;
		self[\play].asCompileString.debug("play fun!!!222");
		
	
		self;
	},

	quant: { arg self;
		self.parentTrack.quant;
	},

	quant_: { arg self, val;
		self.parentTrack.quant = val;
	},

	source: { arg self;
		self.parentTrack.source; 
	},

	play: { arg self;
		self.parentTrack.selectChild(self.index);
		self.parentTrack.play;
		self.changed(\play , self.quant);
	},

	stop: { arg self;
		self.parentTrack.stopPart;
		self.changed(\stop, self.quant);
	},

	isPlaying: { arg self;
		self.isSelected and: { self.parentTrack.isPlaying };
	},

	asPattern: { arg self;
		self.stepevent.asPattern;
	},

	isSelected: { arg self;
		self.parentTrack.selectedChild == self.index;
	},

)));

TrackDef(\main, TrackDef(\proxy_player).copy.putAll((
	label: { arg self; self.key },
	children: PlayerWrapperGroup([
		TrackDef(\kick),
		TrackDef(\snare),
		TrackDef(\hat),
		TrackDef(\fx1),
	]),

	grouptype: \par,

	proxy: { arg self; self.children },

	edit: { arg self;
		WindowDef(self.key, { 
			var editview = View.new;
			VLayout(
				HLayout(
					PlayerWrapper(self).asView,
					Param(TempoClock.default, \tempo).asTextField,
				),
				VLayout( *
					self.children.collect({ arg child;
						HLayout(
							PlayerWrapperSelectorView(child).selectAction_({
								editview.removeAll;
								editview.layout_(
									VLayout(
										child.target.asParamGroup.asView,
										[nil, stretch:10]
									)
								) 
							}).asView.fixedWidth_(100),
							child.target.mixer.asParam(\postfader).asKnob,
							~stepEventCoinView.new(child.target.stepevent).hasCursor_(true).asView
						).margins_(0).spacing_(5)
					})
					++ [nil]
				).margins_(0).spacing_(0),
				editview,
				nil,
			)
		}).front;
	},

	mixer: { arg self;
		ProtoClass((
			isPlaying: true,
			edit: {
				WindowDef(\mixer_+++self.key, { arg me, trackgroup;
					HLayout(
						HLayout(*
							trackgroup.collect { arg track;
								var mixer;
								if(track.isKindOf(PlayerWrapper)) {
									track = track.target;
								};
								mixer = track.mixer;
								VLayout(
									//StaticText.new.string_(track.label).background_(track.color ? ParamView.color_ligth),
									PlayerWrapperSelectorView(PlayerWrapper(track)).asView,
									mixer.asParam(\postfader).asStaticTextLabel,
									mixer.asParam(\postfader).asSlider.orientation_(\vertical),
									mixer.asParam(\postfader).asTextField,
								);
							}
						),
						VLayout (
							PlayerWrapperSelectorView(trackgroup).asView,
							Param(Server.default.volume, \volume).asStaticTextLabel,
							Param(Server.default.volume, \volume).asSlider.orientation_(\vertical),
							Param(Server.default.volume, \volume).asTextField,
						)
					)
				}).front(self.children)
			}
		))
		
	},

)));
TrackDef(\ndef, TrackDef(\proxy_player).copy.putAll((
	label: { arg self;
		self.key
	},
	source_: { arg self, val;
		self.proxy = val
	},

	play: { arg self;
		self.proxy.play(self.outbus.index, self.outbus.numChannels);
		self.mixer.play;
	},

	outbus: { arg self;
		self.mixer.inbus;
	},

	source: { arg self;
		self.proxy
	},

	init_mixer_busses: { arg self;
		8.do { arg x;
			self.mixer.proxy.set(\sendbus+++x, BusDef(\sendbus+++x, \audio, self.mixer.numchannels))
		}
	},

	asParamGroup: { arg self;
		self.proxy.asParamGroup
	},

	editor: { arg self;
		ParamGroupLayout.inline_groups(self.asParamGroup);
	},

	isPlaying: { arg self;
		PlayerWrapper(self.proxy).isPlaying and: {
			self.mixer.isNil or: { self.mixer.isPlaying }
		};
	},

	mixer: { arg self;
		if(self.mixer_obj.isNil) {
			self.mixer_obj = ~trackMixerDef.new(self.key);
			self.mixer_obj.define_mixer;
			self.init_mixer_busses;
		};
		self.mixer_obj;
	},

)));
TrackDef(\kick, TrackDef(\drum)).init;
TrackDef(\kick).source = Pdef(\kick);
TrackDef(\snare, TrackDef(\drum)).init;
TrackDef(\snare).source = Pdef(\snare);
TrackDef(\hat, TrackDef(\drum)).init;
TrackDef(\hat).source = Pdef(\hat);
TrackDef(\fx1, TrackDef(\ndef)).source = Ndef(\fx1, {
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio, 2)), 2);
	var sig;
	sig = in;
	sig = CombL.ar(sig, 1, \delay.kr(0.1), \decay.kr(1));
	sig;
});
TrackDef(\fx1).proxy.set(\inbus, BusDef(\sendbus0, \audio, 2));
TrackDef(\fx1).proxy.addSpec(\inbus, XBusSpec());
)

TrackDef(\kick).mixer.proxy.edit
TrackDef(\kick).init_mixer_busses
Ndef(\fx1).clear
Ndef(\fx1).edit
Ndef(\fx1).play(0)
Ndef(\fx1).play(58,2)
Ndef(\fx1).play(58,2)
(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\out, TrackDef(\fx1).mixer.inbus,
	\dur, 1,
	\amp, 0.1
)).stop;
);
Ndef(\fx1).play(TrackDef(\fx1).mixer.inbus)
TrackDef(\fx1).mixer.proxy.edit

TrackDef(\fx1).proxy.get(\inbus)
TrackDef(\fx1).proxy.edit
TrackDef(\fx1).play
TrackDef(\fx1).outbus.numChannels
TrackDef(\fx1).outbus
TrackDef(\fx1).outbus
1+1

(
	TrackDef(\kick).childAt(0).stepevent[\isRest][0] = 1;
	TrackDef(\kick).childAt(0).stepevent[\dur] = 1/8;
	TrackDef(\kick).selectChild(0);
	TrackDef(\snare).childAt(0).stepevent[\isRest][4] = 1;
	TrackDef(\snare).childAt(0).stepevent[\dur] = 1/8;
	TrackDef(\snare).selectChild(0);
	TrackDef(\hat).childAt(0).stepevent[\isRest][2] = 1;
	TrackDef(\hat).childAt(0).stepevent[\isRest][6] = 1;
	TrackDef(\hat).childAt(0).stepevent[\dur] = 1/8;
	TrackDef(\hat).selectChild(0);
)

TrackDef(\main).play
TrackDef(\kick).play
TrackDef(\main).stop
TrackDef(\main).edit;
TrackDef(\main).mixer.edit;
TrackDef(\main)[\isPlaying].asCompileString
TrackDef(\main)[\isPlaying].asCompileString
TrackDef(\main).mixer.isPlaying
WindowLayout({ TrackDef(\fx1).editor });
~clipTimeline.new(\yep).edit
~clipTimeline.new(\yep).eventList.print
~clipTimeline.new(\yep).eventList[1].receiver.value.target
Ndef(\fx1).edit
TrackDef(\fx1).mixer.proxy.edit
Ndef(\fx1).clear

cleaR
(
	WindowDef(\playergrid, { arg me, maintrack;
		var mixerview;
		var gridsize = 8@8;
		var selectorGroup = ~selectorGroup.new;
		var editview = View.new.fixedHeight_(315);
		var mixerviews = List.new;
		var mixer_visible;

		mixer_visible = { arg val=true;
			if(val) {
				editview.visible = val.not;
			};
			mixerviews.do( { arg x;
				x.visible = val;
			} );
			if(val.not) {
				editview.visible = val.not;
			};
		};

		mixerview = { arg mixer;
			VLayout(
				mixer.asParam(\postfader).asSlider.orientation_(\vertical).maxWidth_(100).minHeight_(200),
				mixer.asParam(\postfader).asTextField.maxWidth_(100),
				VLayout(*
					2.collect({ arg idx;
						HLayout(
							mixer.asParam(\send+++( idx*2 )).asKnob,
							mixer.asParam(\send+++( idx*2+1 )).asKnob,
						)
					})
				)
			).spacing_(0).margins_(0)
		};

		mixer_visible.(true);

		selectorGroup.selectAction = { arg self, view;
			var target = view.model.target;
			editview.removeAll;
			editview.layout_(
				case
					{ target === maintrack } {
						VLayout(
							*
							target.children.asArray.collect { arg track;
								track = track.target;
								if(track.notNil and: {track.tracktype == \drum}) {
									~stepEventCoinView.new(track.childAt(track.selectedChild).stepevent).hasCursor_(true).asView;
								}
							}
							++ [nil]
						).spacing_(0).margins_(0)

					}
					{ target.isLinePlayer == true } {
						VLayout(
							*
							target.children.asArray.collect { arg track;
								if(track.notNil and: {track.tracktype == \drum}) {
									~stepEventCoinView.new(track.stepevent).hasCursor_(true).asView;
								}
							}
							++ [nil]
						).spacing_(0).margins_(0)
					}
					{ target.tracktype == \drum } {
						VLayout(
							~stepEventCoinView.new(target.stepevent).hasCursor_(true).asView,
							ParamGroupLayout.inline_groups(target.asParamGroup),
						)
					}
					{
						target.editor
					}
				;
			)
		};

		VLayout(
			HLayout(
				//BasicButton.new.action_({
				//	maintrack.mixer.edit;
				//}).label_("Mixer Window");
				BasicButton.new.action_({
					if(mixerviews.first.visible) {
						mixer_visible.(false);
					} {
						mixer_visible.(true);
					}
				}).label_("show Mixer"),
				PlayerWrapper(maintrack).asView,

			),
			GridLayout.columns(
				*maintrack.children.collect({ arg track;
					if(track.isKindOf(PlayerWrapper)) {
						track = track.target;
					};
					[track.keys, track.label].debug("Track");
					mixerviews.add(
						View.new.layout_(
							mixerview.(track.mixer),
						)
					);
					[ ~selectorGroup_set.(PlayerWrapperSelectorView(track), selectorGroup).asView ] ++
					gridsize.y.collect({ arg idx;
						~selectorGroup_set.(PlayerWrapperSelectorView(track.childAt(idx)), selectorGroup).asView;
					})
					++ [
						mixerviews.last,
						nil
					]
				}) 
				++ [{
					var lineplayer;
					var mixerparam = Param(Server.default.volume, \volume);
					mixerviews.add(
						View.new.layout_(
							VLayout(
								mixerparam.asSlider.orientation_(\vertical).maxWidth_(100).minHeight_(200),
								mixerparam.asTextField.maxWidth_(100),
							).spacing_(0).margins_(0)
						)
					);
					[ ~selectorGroup_set.(PlayerWrapperSelectorView(maintrack), selectorGroup).asView ] ++
					8.collect({ arg idx;
						var lineplayer = ProtoClass((
							isLinePlayer: true,
							play: {
								maintrack.children.do({ arg x; x.target.selectChild(idx) });
								maintrack.play;
							}

							stop: { arg self;
								maintrack.stop
							},

							isPlaying: { arg self;
								maintrack.isPlaying and: {
									maintrack.children.asArray.every({ arg x; x.target.selectedChild == idx });
								};
							},

							children: { arg self;
								maintrack.children.asArray.collect({ arg x; x.target.childAt(idx) });
							},
						));
						~selectorGroup_set.(PlayerWrapperSelectorView(lineplayer), selectorGroup).asView;
					})
					++ [
						mixerviews.last,
						nil
					]
				}.value]
				++ [ nil!maintrack.children.size]
			).setColumnStretch(maintrack.children.size, 100),
			//ScrollView.new.canvas_(editview),

			editview,
			nil
		)

	}).front(TrackDef(\main))
)

TrackDef(\snare).childAt(1)
TrackDef(\snare).play

Tra
TrackDef(\kick).childAt(0).isPlaying
TrackDef(\kick).childAt(0).play
TrackDef(\kick).childAt(0).key
TrackDef(\kick).childAt(0)[\play].asCompileString
TrackDef(\subdrum)[\play].asCompileString
TrackDef(\kick).isPlaying
TrackDef(\kick).children
TrackDef(\kick).quant
TrackDef(\kick).childAt(1).play
TrackDef(\main).children.array.do({ arg x;x.quant.debug("qq")})
TrackDef(\kick).childAt(0).quant
TrackDef(\subdrum)[\play].asCompileString
TrackDef(\subdrum).new(TrackDef(\kick), 0)[\play].asCompileString

(bla: 4) <> (bmu:3)
TrackDef(\main).children
Pdef(\kick).quant
Pdef(\kick).
TrackDef(\kick).childAt(0).key

//=========================== record children parts

ParamProto.init(true)
~ef = ~class_track_event_factory.new(TrackDef(\main).children);
~ef.players
~ef.childAt(0).players
TrackDef(\main).children[0].target.childAt(0)
TrackDef(\main).children[0].target.children
~ef.childAt(0).children.size
~ef.children.size
~ef.childAt(0).childAt(1).players
~ef.childAt(0).childAt(0).children
~ef.childAt(0)[\childAt].asCompileString
~ef.players

ParamProto.init(true)
~trackTimeline.new(\tracks).clear
~trackTimeline.new(\tracks, TrackDef(\main).children).edit
~trackTimeline.new(\tracks, TrackDef(\main).children)
~trackTimelinePanelView.new(PlayerWrapperGroup([Pdef(\kick)]))
~trackTimelinePanelView.new(~clipTimeline.new(\line))
~trackTimelinePanelView

~clipTimeline.new(\yep).edit

(
//~ef = ~class_player_event_factory.new([
//	Pdef(\pat1),
//	Pdef(\pat2),
//	Ndef(\node1),
//]);
//~ef.eventLoop = ~clipTimeline.new(\line).eventLoop;

~ef = ~class_track_event_factory.new(TrackDef(\main).children);
~clipTimeline.new(\line).eventFactory = ~ef;
~ef.eventLoop = ~clipTimeline.new(\line).eventLoop;
//~ef = ~clipTimeline.new(\line).eventFactory;
//~ef.set_players(TrackDef(\main).children.array);
~player_group = ~ef.players;
//~clipTimeline.new(\line).eventFactory = ~ef;
~event_factory = ~ef;
WindowDef(\test, { arg wd;
	var ms = MenuSpec([\pattern, \trigger, \note, \event]);
	var pms = MenuSpec([\toggle, \gate]);
	var win = wd.window;

	//win.view.keyDownAction_({ arg me, key, modifiers, unicode, keycode;
	//	["down", me, key.asCompileString, modifiers, unicode, keycode].debug("keyDownAction");
	//	"azertyuiop".as(Array).collect({ arg letter, x;
	//		var midinote = x+(5*12);
	//		[letter,key == letter ].asCompileString.debug("letter");
	//		if(key == letter) {
	//			~map_key.(\down, ~event_factory.childAt(midinote))
	//		}
	//	})
	//});

	//win.view.keyUpAction_({ arg me, key, modifiers, unicode, keycode;
	//	["up", me, key.asCompileString, modifiers, unicode, keycode].debug("keyUpAction");
	//	"azertyuiop".as(Array).collect({ arg letter, x;
	//		var midinote = x+(5*12);
	//		["up", letter,key == letter, midinote ].asCompileString.debug("letter");
	//		if(key == letter) {
	//			~map_key.(\up, ~event_factory.childAt(midinote))
	//		}
	//	})
	//});

	HLayout(
		~clipTimeline.new(\line).asView,
		VLayout (
			PopUpMenu.new.mapParam(Param(Message(~event_factory), \mode, ms)),
			PopUpMenu.new.mapParam(Param(Message(~event_factory), \playmode, pms)),
			BasicButton.new.label_("Play Rec").action_({ ~event_factory.eventLoop.play; }),
			Button.new.mapParam(Param(Message(~event_factory), \isRecording, XBoolSpec())).states_([
				["Rec", Color.black, Color.white],
				["Rec", Color.black, Color.red],
			]),
			BasicButton.new.label_("Start Rec").action_({ ~event_factory.startRecording }),
			BasicButton.new.label_("Stop Rec").action_({ ~event_factory.stopRecording }),
			HLayout(
				* ~player_group.collect(_.asView)
			)
			
			//VLayout(
			//	* 10.collect{ arg x;
			//		var but;
			//		var midinote = x+(5*12);
			//		but = Button.new;
			//		but.states = [
			//			[midinote.asString],
			//			[midinote.asString, Color.black, Color.yellow]
			//		];
			//		// TODO: what to use with MIDIMap and Mktl
			//		~map_button.(but, ~event_factory.childAt(midinote));
			//	};
			//)
		)
	)
}).frontTop
)


//=========================== just record players and not children parts
(
//~ef = ~class_player_event_factory.new([
//	Pdef(\pat1),
//	Pdef(\pat2),
//	Ndef(\node1),
//]);
//~ef.eventLoop = ~clipTimeline.new(\line).eventLoop;
~ef = ~clipTimeline.new(\line).eventFactory;
~ef.set_players(TrackDef(\main).children.array);
~player_group = ~ef.players;
//~clipTimeline.new(\line).eventFactory = ~ef;
~event_factory = ~ef;
WindowDef(\test, { arg wd;
	var ms = MenuSpec([\pattern, \trigger, \note, \event]);
	var pms = MenuSpec([\toggle, \gate]);
	var win = wd.window;

	//win.view.keyDownAction_({ arg me, key, modifiers, unicode, keycode;
	//	["down", me, key.asCompileString, modifiers, unicode, keycode].debug("keyDownAction");
	//	"azertyuiop".as(Array).collect({ arg letter, x;
	//		var midinote = x+(5*12);
	//		[letter,key == letter ].asCompileString.debug("letter");
	//		if(key == letter) {
	//			~map_key.(\down, ~event_factory.childAt(midinote))
	//		}
	//	})
	//});

	//win.view.keyUpAction_({ arg me, key, modifiers, unicode, keycode;
	//	["up", me, key.asCompileString, modifiers, unicode, keycode].debug("keyUpAction");
	//	"azertyuiop".as(Array).collect({ arg letter, x;
	//		var midinote = x+(5*12);
	//		["up", letter,key == letter, midinote ].asCompileString.debug("letter");
	//		if(key == letter) {
	//			~map_key.(\up, ~event_factory.childAt(midinote))
	//		}
	//	})
	//});

	HLayout(
		~clipTimeline.new(\line).asView,
		VLayout (
			PopUpMenu.new.mapParam(Param(Message(~event_factory), \mode, ms)),
			PopUpMenu.new.mapParam(Param(Message(~event_factory), \playmode, pms)),
			BasicButton.new.label_("Play Rec").action_({ ~event_factory.eventLoop.play; }),
			Button.new.mapParam(Param(Message(~event_factory), \isRecording, XBoolSpec())).states_([
				["Rec", Color.black, Color.white],
				["Rec", Color.black, Color.red],
			]),
			BasicButton.new.label_("Start Rec").action_({ ~event_factory.startRecording }),
			BasicButton.new.label_("Stop Rec").action_({ ~event_factory.stopRecording }),
			HLayout(
				* ~player_group.collect(_.asView)
			)
			
			//VLayout(
			//	* 10.collect{ arg x;
			//		var but;
			//		var midinote = x+(5*12);
			//		but = Button.new;
			//		but.states = [
			//			[midinote.asString],
			//			[midinote.asString, Color.black, Color.yellow]
			//		];
			//		// TODO: what to use with MIDIMap and Mktl
			//		~map_button.(but, ~event_factory.childAt(midinote));
			//	};
			//)
		)
	)
}).frontTop
)

