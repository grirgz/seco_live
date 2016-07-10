
"~/code/sc/seco/vlive/explore/mars/drumkit.scd".standardizePath.load
(
TempoClock.default.tempo = 1;
ParamProto.init;
	~trackMixerDef = ProtoClass((
		all: {PresetDictionary(\trackMixerDef)},
		new: { arg self, key, numchannels=2, outbus=0;
		
			if(self.all[key].isNil) {
				self = self.deepCopy;
				self.key = key;
				self.init(key, numchannels, outbus);
				self.all[key] = self;
			} {
				self = self.all[key];
				//self.val = val;
			};
		
			self;
		},

		clear: { arg self;
			self.all[self.key] = nil;
		},

		init: { arg self, key, numchannels, outbus;
			self.outbus = outbus;
			self.numchannels = numchannels;
			self.define_mixer;
			self.asParam(\inbus).set(self.inbus)
		},

		inbus: { arg self;
			BusDef(\trackMixerDef_+++self.key, \audio, self.numchannels)
		},

		numchannels: 2,

		define_mixer: { arg self;
			//self.proxy = NodeProxy.new;
			self.proxy = Ndef(\trackMixerDef_+++self.key);
			self.proxy[0] = {
				In.ar(\inbus.kr(self.zerobus), self.numchannels);
			};
			self.proxy[1000] = \filter -> { arg in;
				in * \prefader.kr(1).dbamp;
			};
			self.proxy[2000] = \filter -> { arg in;
				in * \postfader.kr(1).dbamp;
			};
			self.proxy.addSpec(\inbus, XBusSpec());
			self.proxy.addSpec(\prefader, \db);
			self.proxy.addSpec(\postfader, \db);
		},

		play: { arg self;
			var outbus = self.outbus;
			if(outbus.isKindOf(Bus)) {
				outbus = outbus.index;
			};
			self.proxy.play(outbus, self.numchannels)
		},

		setOut: { arg self, outbus;
			self.outbus = outbus;
			self.play;
		},

		asParam: { arg self, key;
			if(key.asString.beginsWith("send")) {
				var idx = key.asString.drop(4).asInteger;
				self.build_sender(idx);
				Param(self.proxy, key);
			} {
				Param(self.proxy, key);
			}
		},

		asParamGroup: { arg self;
			self.proxy.asParamGroup
		},

		nullbus: { arg self;
			BusDef(\null+++self.numchannels, \audio, self.numchannels)
		},

		zerobus: { arg self;
			BusDef(\zero+++self.numchannels, \audio, self.numchannels)
		},

		build_sender: { arg self, idx;
			var sendkey = \send+++idx;
			self.proxy.addSpec(sendkey, \unipolar);
			self.proxy[idx+1100] = \filter -> { arg in;
				Out.ar(\sendbus.kr(self.zerobus), in * sendkey.kr(1));
				in;
			}
		},

		stop: { arg self;
			self.proxy.stop;
		},

		isPlaying: { arg self;
			self.proxy.isPlaying;
		},

	));
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
			self.mixer.stop;
		};
		self.changed(\stop, self.proxy.quant);
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
		self.proxy.set(\out, self.mixer.inbus);
		self.children = SparseArray.new;
		self.childProxy = EventPatternProxy.new.source_(Pbind());
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
		self.selectedChild = idx;
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
				~stepEventCoinView.new(self.stepevent).hasCursor_(true).asView,
				PlayerWrapper(self.proxy).asView,
			)
		}).front;
	},
)));

TrackDef(\subdrum, TrackDef(\drum).copy.putAll((
	label: { arg self; self.parentTrack.label ++ " " ++ self.index.asString },
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

TrackDef(\main, (
	children: PlayerWrapperGroup([
		TrackDef(\kick),
		TrackDef(\snare),
		TrackDef(\hat),
	]),

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
		(
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
		)
		
	},

)).putAll(TrackDef(\proxy_player));
TrackDef(\kick, TrackDef(\drum)).init;
TrackDef(\kick).source = Pdef(\kick);
TrackDef(\snare, TrackDef(\drum)).init;
TrackDef(\snare).source = Pdef(\snare);
TrackDef(\hat, TrackDef(\drum)).init;
TrackDef(\hat).source = Pdef(\hat);
)

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

TrackDef(\main).edit;
TrackDef(\main).mixer.edit;

(
	~selectorGroup_set = { arg view, group;
		var idx;
		idx = group.addChild(view);
		view.selectAction = {
			group.selectChild(idx)
		};
		view;
	};
	~selectorGroup = ProtoClass((
		new: { arg self;
			self = self.deepCopy;
		
			self.selectedIndex = 0;
			self.viewList = List.new;
		
			self;
		},

		selectChild: { arg self, idx;
			if(self.selectedIndex.notNil) {
				self.viewList[self.selectedIndex].selected = false;
			};
			self.selectedIndex = idx;
			self.viewList[idx].selected = true;
			self.selectAction(self.viewList[idx], idx);
		},

		addChild: { arg self, view;
			var idx;
			self.viewList.add(view);
			idx = self.viewList.size - 1;
			idx;
		},
	));
	WindowDef(\playergrid, { arg me, maintrack;
		var selectorGroup = ~selectorGroup.new;
		var editview = View.new.fixedHeight_(350);
		var mixerviews = List.new;
		var mixer_visible = { arg val=true;
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
		mixer_visible.(true);
		selectorGroup.selectAction = { arg self, view;
			editview.removeAll;
			editview.layout_(
				VLayout(
					~stepEventCoinView.new(view.model.target.stepevent).hasCursor_(true).asView,
					ParamGroupLayout.inline_groups(view.model.target.asParamGroup),
				)
			)
		};
		VLayout(
			HLayout(
				BasicButton.new.action_({
					maintrack.mixer.edit;
				}).label_("Mixer Window");
				BasicButton.new.action_({
					if(mixerviews.first.visible) {
						mixer_visible.(false);
					} {
						mixer_visible.(true);
					}
				}).label_("show Mixer");
			),
			GridLayout.columns(
				*maintrack.children.collect({ arg track;
					if(track.isKindOf(PlayerWrapper)) {
						track = track.target;
					};
					mixerviews.add(
						View.new.layout_(
							VLayout(
								track.mixer.asParam(\postfader).asSlider.orientation_(\vertical).maxWidth_(100).minHeight_(200),
								track.mixer.asParam(\postfader).asTextField.maxWidth_(100),
							).spacing_(0).margins_(0)
						)
					);
					[ ~selectorGroup_set.(PlayerWrapperSelectorView(track), selectorGroup).asView ] ++
					8.collect({ arg idx;
						~selectorGroup_set.(PlayerWrapperSelectorView(track.childAt(idx)), selectorGroup).asView;
					})
					++ [
						mixerviews.last,
						nil
					]
				}) ++ [ nil!maintrack.children.size]
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

