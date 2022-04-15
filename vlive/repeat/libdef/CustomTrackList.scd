

FileSystemProject.loadOnce("libdef/soundfileview.scd");
FileSystemProject.loadOnce("libdef/tracklist.scd");
FileSystemProject.loadOnce("libdef/tracklist_buildertrack.scd");
FileSystemProject.loadOnce("libdef/default_specs.scd");


/// base class

(
TrackTemplateDef(\CustomTrackList, (
	parent: TrackTemplateDef(\TrackList),
	childClass: { TrackTemplateDef(\CustomInstrumentTrack) },
	showTrackHeaders: true,
	showRecorderView: true,
	edit: { arg self;
		WindowDef(\customgrid).front(self);
	},

	presetCompileString: { arg self;
		"%\n".format([
			"TrackDef(%, %);".format(self.key.asCompileString, "TrackTemplateDef(\\CustomTrackList)"),
			"TrackDef(%).presetCompileStringSavePath = PathName(thisProcess.nowExecutingPath).pathOnly;".format(self.key.asCompileString),
			"",
			self.linePlayers.collect { arg lplayer, idx;
				lplayer.presetCompileString
			}.select(_.notNil).join("\n"),
			"\nTrackDef(%).loadPresetCompileString;".format(self.key.asCompileString),
		].join("\n"))
	},

	keepSamplesInUse: { arg self;
		self.existingChildren.do { arg track, idx;
			track.keepSamplesInUse;
		};

	},

));
TrackTemplateDef(\CustomInstrumentTrack, (
	parent: TrackTemplateDef(\InstrumentTrack),
	childClass: { TrackTemplateDef(\CustomInstrumentTrackPart) },

	editTrackTemplate: { arg self;
		WindowDef(\CustomInstrumentTrack_TemplateEditor).front(self)
	},
	editInstrument: { arg self;
		self.trackEditor.front(self);
	},

	clearTrack: { arg self;

		self.clear;
		
	},

	presetCompileString: { arg self;
		if(self.isEmpty) {
			nil
		} {
			var str = List[];

			str.add("%.trackTemplate = %;".format(self.refCompileString, self.trackTemplate.asCompileString));
			str.add("%.label = %;".format(self.refCompileString, self.label.asCompileString));
			if(self.mixer.notNil) {
				str.add("\n\n");
				str.add("%.isMixerEnabled = %;".format(self.refCompileString, self.isMixerEnabled.asCompileString));
				str.add(( self.mixer.presetCompileString ?? { "" } ));
			};
			str.add("\n\n" ++ ( self.scorePresetCompileString ?? { "" } ));

			str.join($\n);
		}
	},

	label: { arg self;
		if(self.trackTemplate.key == \CustomInstrumentTrack) {
			"T%".format(self.index); 
		} {
			self.trackTemplate.key
		}
	},

	new: { arg self, parent, index;
		self = ProtoClass(( parent: self ));

		self.selectChild(0);
		self.index = index.asInteger;
		self.parentTrack = {parent};
		self[\storeOn] = { arg self, str; str << self.refCompileString };
		self;
	},

	outBus_: { arg self, outBus;
		self[\outBus] = outBus;
		self.existingChildren.collect({ arg child;
			child.outBus = outBus;
		});
		self.changed(\outBus);
	},

	childAt: { arg self, idx;
		var ret;
		//idx.debug("childAt!!!!x");
		//this.dumpBackTrace;	
		self.children = self.children ?? { SparseArray.new };
		ret = self.children[idx] ?? { 
			self.children[idx] = self.childClass.new(self, idx);
			//idx.debug("childAt init!!!!");
			self.children[idx].initTrack;
			self.children[idx];
		};
		ret;
	},

	name: { arg self;
		self.trackKey;
	},

	initTrack: { arg self;
		self.makeScore;
	},

));

TrackTemplateDef(\CustomInstrumentTrackPart, (
	parent: TrackTemplateDef(\InstrumentTrackPart),
	new: { arg self, parent, index;
		self = ProtoClass(( parent: self ));

		self.parentTrack = {parent};
		self.index = index.asInteger;
		self[\storeOn] = { arg iself, str; str << iself.refCompileString };
		self;
	},

	clone: { arg self, parent, index;
		self = self.copy;

		self.parentTrack = {parent};
		self.index = index.asInteger;
		self.score = self.cloneScore;
		self;
	},

	cloneScore: { arg self;
		var newscore = self.score.copy;
		newscore;
	},

	clearTrack: { arg self;
		self[\score] = nil;
		self.proxy = nil;
		self.parentTrack.children[self.index] = nil; // erase from parent, force recreate with good template
		self.parentTrack.changed(\children);
		Log(\Param).debug("clearTrack: erased %", self.index);
	},

	savePresetCompileString: { arg self, path, onDoneAction;
		if(self.isEmpty.not) {
			var file;
			path = path ? self.presetCompileStringSavePath;
			PlayerWrapper_Base.savePresetCompileStringHelper(path, onDoneAction, self.refCompileString, self.presetCompileString, false);
		}
	},
	
	loadPresetCompileString: { arg self;
		if(self.presetCompileStringSavePath.notNil) {
			FileSystemProject.load(self.presetCompileStringSavePath, true);
		}
	},

	presetCompileString: { arg self;
		// FIXME: need to clarify the difference between source and score
		// in tracklist, source is the current score and score is the list of all potential sources
		// when setting score, updateSource is called which select the right score and put it in source
		// logically, we should save score and not source
		// the selected score is inside the score data structure
		if(self.isEmpty) {
			nil
		} {
			var str = List[];

			str.add("%.score = %;".format(self.refCompileString, self.score.asCompileString));
			str.add("\n\n%".format(self.scorePresetCompileString ?? { "" }));
			str.join($\n)
		}
	},

	score: { arg self; self.source }, // if no score defined, use source

	updateSource: { arg self;
		if(self.score.notNil) {
			self[\source] = self.score;
			self.proxy = PlayerWrapper(self.score);
		} {
			self.source = nil
		};
	},

	scorePresetCompileString: { arg self;
		if(self.score.notNil) {

			self.score.presetCompileString
		} {
			""
		}
	},

	selectSourceDialog: { arg self;
		self.parentTrack.editInstrument;
	},

	initTrack: { arg self; 
		self.parentTrack.initChild(self);
	},

	name: { arg self;
		self.trackKey;
	},

	editor: { arg self;
		self.parentTrack.editor
	},

	asView: { arg self ...args;
		self.parentTrack.editor.asView(self, *args);
	},

	edit: { arg self;
		var target = self.source;
		if(self.editor.notNil) {
			self.editor.front(self);
		} {
			if(target.getHalo(\edit).notNil) {
				target.getHalo(\edit).value(target);
			} {
				if(target.isKindOf(Pdef)) {
					target.edit;
					//WindowDef(\PdefEditor).front(target)
				} {
					if(target.isKindOf(Ndef)) {
						WindowDef(\NdefEditor).front(target)
					} {
						target.edit
					}
				};
			};
		};
	},

));
);


//// GUI

(
WindowDef(\sampleEditor, { arg def, param;
	var popup;
	var spec;
	var curval, editcurval;
	var target = param.target;
	curval = StaticText.new.minWidth_(80).align_(\right);
	editcurval = TextField.new;
	spec = ParamAudioBufferSpec(2)
		.startParamName_(\pos)
		.sustainParamName_(\sustain)
		.speedParamName_(\speed)
		;
	param.spec = spec;

	curval.followChange(Param, \lastTweaked, { arg view; 
		//"there is a change! %: %".format(Param.lastTweaked.asLabel, Param.lastTweaked.stringGet).postln;

		// map the last changed Param to the StaticText and TextField
		curval.mapParamLabel(Param.lastTweaked);
		editcurval.mapParam(Param.lastTweaked);
	});

	VLayout (
		HLayout (
			PlayerWrapper(target),
			curval, 
			editcurval,
		),
		HLayout (
			WindowDef(\ParamAsSoundFileView).asView(param),
			VLayout(
				* [
					Param(target, \pos, \unipolar),
					Param(target, \sustain, ControlSpec(0,10,\lin)),
					Param(target, \speed, ControlSpec(-2,2,\lin,0,1)),
				].collect({ arg pa;
					ParamGroupLayout.knobView(pa);
				}) ++ [nil]
			),
		),
		param.asView,
		Param(target, \gain, \unipolar).asView,
		Param(target, \dur, ControlSpec(0.1,8,\exp)).asView,
		Param(target, \adsr ).asView,
	)
});
);

(
WindowDef(\customgrid, (
	trackCount: 9,
	rowCount: 8,
	masterTrackIndex: 8,
	maxColumnWidth: 200,
	showToolBar: true,
	color_header: Color.gray.lighten(ParamViewToolBox.color_dark, 0.7),

	makeMixerViewList: { arg self;
		
	},
	
	asView: { arg self, me, maintrack;
		var viewgrid;
		var mainview;
		var make_view;
		var playerviews;
		var map_players;
		var mixerviews;
		var specialviews;
		maintrack = maintrack ?? { TrackDef(\main) };

		if(me.key == \customgrid) {
			me.windowName = "customgrid: %".format(maintrack.key);
		};

		self.maintrack = maintrack;
		self.windef = me;
		// commented because at caller level
		//if(me.window.notNil) {
		//	me.window.bounds = Rect(144, 217, 1090, 438);
		//};

		mainview = View.new;
		self.mainview = mainview;
		mainview.onChange(maintrack, \gridOffset, { {map_players.()}.defer });

		playerviews = { { PlayerWrapperGridCellView.new } ! self.rowCount } ! self.trackCount;
		playerviews.last.do { arg item, idx;
			item.color_empty = self.color_header;
		};
		//mixerviews = { WindowDef(\mixerView).asView } ! 9;

		specialviews = self.trackCount.collect({ arg x;
			View.new.addUniqueMethod(\model_, { arg view, track;
				var recorderView;
				view.removeAll;
				Log(\Param).debug("specialviews model_: %", track);
				if(track.notNil) {
					recorderView = track.recorderView;
					if(recorderView.notNil) {
						Log(\Param).debug("specialviews recorderView: %", recorderView);
						view.layout = recorderView;
					}
				}
			}).maxWidth_(self.maxColumnWidth);
		});

		mixerviews = self.trackCount.collect({ arg x;
			var boxview;
			var delayview;
			var child;
			var mixer;
			var mixerview;
			boxview = View.new;
			boxview.addUniqueMethod(\model_, { arg view, track;
		   
				// TODO: make listen to \mixer changed and update model
				// 
				if(track.notNil) {
					if(track.isKindOf(Volume).not) {
						//x.debug("set trackHeaders model");
						self.trackHeaders[x].model = track;
						//[ self.trackFaders[x], track, track.mixer, x ].debug("set trackFaders model: view, track, mixer, x");
						self.trackFaders[x].model = track.mixer;
						//debug("set mixer follower");
						view.getHalo(\followChangeController) !? _.remove;
						view.followChange(track, \mixer, {

							// when mixer is created, need to assign it
							[ self.trackFaders[x], track, track.mixer, track.isMixerEnabled, x ].debug("set trackFaders model: view, track, mixer, x");
							self.trackFaders[x].model = track.mixer;
							//self.trackHeaders[x].visible = (track.parentTrack.showTrackHeaders == true);
							//self.trackFaders[x].visible = ( track.isMixerEnabled == true );
						}, false); // if true, show ghost mixer model bug
					} {
						x.debug("set trackHeaders model volume!!!!!");
						self.trackHeaders[x].model = PlayerWrapper(self.maintrack);
						self.trackFaders[x].model = ProtoClassDef(\TrackMixerDef_volume);
						~merde = self;
						//self.trackFaders[x].slider.mapParam(Param(track, \volume));
						//self.trackFaders[x].textfield.mapParam(Param(track, \volume));
						Param(track, \volume).debug("volume");
						self.trackFaders[x].proto.showSends = false;
						self.trackFaders[x].proto.showMuteSolo = false;
						//self.trackFaders[x].model = track;
						
					}
				} {

				}
			});


			boxview.layout = VLayout(
				self.makeTrackHeader(x),
				specialviews[x],
				[self.makeTrackFader(x), stretch:10],
				nil,
			).spacing_(0).margins_(0);

			boxview.maxWidth = self.maxColumnWidth;
			boxview;

		});

		if(me.window.notNil) {
			me.window.name = "playergrid: " ++ maintrack.key;
		};

		map_players = {
			debug("map players");
			playerviews.do({ arg track, x;
				track.do { arg child, y;
					[track, x, child, y].debug("set playerview model: track child");
					if(x == 8) {
						child.model = maintrack.linePlayerAt(y+maintrack.gridOffset.y);
					} {
						child.model = maintrack.childAtOffset(Point(x,y));
					}
				};
			});
			specialviews.do({ arg child, x;
				[child, x].debug("set specialviews model: track idx");
				if(x == 8) {
					child.model = nil
				} {
					child.model = maintrack.childAtOffset(x);
				}
			});
			mixerviews.do({ arg child, x;
				[child, x].debug("set mixerview model: child");
				if(child.notNil) {
					if(x == 8) {
						child.model = Server.default.volume;
					} {
						child.model = maintrack.childAtOffset(x);
					}
				}
			});

			if(maintrack.showTrackHeaders == true) {
				self.trackHeaders.do({ arg th; th.visible = true })
			} {
				self.trackHeaders.do({ arg th; th.visible = false })
			};

			if(maintrack.showRecorderView == true) {
				specialviews.do({ arg th; th.visible = true })
			} {
				specialviews.do({ arg th; th.visible = false })
			};

		};

		make_view = {
			mainview.removeAll;
			mainview.layout = VLayout(
				GridLayout.columns(*
					playerviews.collect({ arg track, idx;

						[track.first.view, track.first.model, track.first.model.parentTrack].debug("make_view: follower");
						track.first.view.followChange(track.first.model.parentTrack, \children, { {map_players.()}.defer });
						track.collect({ arg child;
							var view = child.asView;
							view.button.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
								//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
								if(buttonNumber == 1) {
									if(child.model.isKindOf(PlayerWrapper)) {
										child.model.target.edit;
									} {
										child.model.edit;
									}
								};
							});
							view.layout.margins_(1);
							view.button.fixedWidth_(20);
							//view.labelView.fixedWidth_(49);
							//view.fixedSize_(Point(300,20));
							view.labelView.font_(Font.default.size_(10));
							view.labelView.minWidth_(10);
							//child.model.target.debug("childmodeltarget");
							//if(child.model.target.isEmpty == true) {
							//child.color_deselected = Color.gray;
							//};
							child.selected = false;
							view.labelView.mouseDownAction_({ arg label, x, y, modifiers, buttonNumber, clickCount;
								//"DOWN".debug;
								//view.selected = true
								if(buttonNumber == 1) {
									var model = child.model;
									self.makeOverlayMenu(label, x, y, model);
								};
								if(clickCount == 2) {
									child.model.selectSourceDialog;
								};
							});
							view;
						})
						++ [ 
							[ mixerviews[idx] ],
							//[ specialviews[idx] ],
						]
					})
				).vSpacing_(1).hSpacing_(1),
				nil
			).margins_(0);
			if(self.showToolBar == true) {
				VLayout(
					self.makeToolBar,
					mainview,
				).margins_(5)
			} {
				mainview
			}
		};
		map_players.();
		self.addKeybordBindings;
		make_view.();
	},

	addKeybordBindings: { arg self;
		var anchor = self.windef.windowDo { arg win; win.view } ?? { self.mainview };
		anchor.keyDownAction_({ arg me, key, modifiers, unicode, keycode;
			var matrix;
			var idx, posx, posy;
			var maintrack = self.maintrack;
			[me, key.asCompileString, modifiers, unicode, keycode].debug("grid keyDownAction");
			matrix = [
				"&" ++ -23.asAscii ++ "\"'(-" ++ -24.asAscii ++ "_" ++ -25.asAscii,
				"azertyuio",
				"qsdfghjkl",
				"wxcvbn,;:",
			].join;
			//~matrix
			//~matrix.indexOf($a);
			idx = matrix.indexOf(key);
			if(idx.notNil) {
				posx = idx%9;
				posy = ( idx/9 ).floor;
				Log(\Param).debug("grid keydown: idx %, x %, y %", idx, posx, posy);
				if(posx == 8) {
					PlayerWrapper(maintrack.linePlayerAt(posy+maintrack.gridOffset.y)).togglePlay;
				} {
					PlayerWrapper(maintrack.childAtOffset(Point(posx,posy))).togglePlay;
				}
			}
		});
		
	},

	showGeneralOverlayMenu: { arg self, view, x, y;
		WindowDef(\OverlayMenu).front(view, x, y, { arg def;
			HLayout(
				StaticText.new.string_("controller:"),
				Param(
					Message(self.maintrack),
					\controller, 
					ControllerDef.getTagSpec(\launchpad)
				).asPopUpMenu.allowsReselection_(true),
			);
		})
		
	},

	makeToolBar: { arg self;
		HLayout (
			BasicButton.new.string_("^").action_({
				self.maintrack.gridOffset = self.maintrack.gridOffset + Point(0,-1);
			}),
			BasicButton.new.string_("v").action_({
				self.maintrack.gridOffset = self.maintrack.gridOffset + Point(0,1);
			}),
			BasicButton.new.string_("<").action_({
				self.maintrack.gridOffset = self.maintrack.gridOffset + Point(-1,0);
			}),
			BasicButton.new.string_(">").action_({
				self.maintrack.gridOffset = self.maintrack.gridOffset + Point(1,0);
			}),
			nil,
			BasicButton.new.string_("...").mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
				self.showGeneralOverlayMenu(view, x, y);
			}).maxWidth_(20),
		)
	},

	makeTrackFader: { arg self, trackidx;
		var child, boxview, mixer, mixerview;
		child = self.maintrack.childAtOffset(trackidx);
		if(child.notNil) {
			var win = WindowDef(\customgrid_mixer+++trackidx, WindowDef(\TrackMixerDef_advanced));
			mixer = child.mixer;
			win.proto.showPlay = false;
			//mixerview = win.asView(mixer);
			mixerview = win.asView;
			// model_ is already defined in mixer view
			mixerview.debug("created mixerview");
			mixerview.maxWidth_(200);
			self.trackFaders = self.trackFaders ?? { nil ! self.trackCount };
			if(trackidx == 0) {
				~dbfirstmix = mixerview;
			};
			self.trackFaders[trackidx] = mixerview;
			mixerview;
		};
	},

	makeTrackHeader: { arg self, trackidx;
		var playerview;
		if(trackidx != ( self.trackCount - 1 )) { // if not last column
			var child;
			var maintrack = self.maintrack;
			child = maintrack.childAtOffset(trackidx);
			[child, child.source, trackidx].debug("showTrackHeaders: child");
			playerview = PlayerWrapperGridCellView(child).asView.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
				if(buttonNumber == 1) {
					child.editTrackTemplate;
				};
			});

			playerview.parentView.color_empty = self.color_header;
			playerview.layout.margins_(1);
			playerview.button.fixedWidth_(20);
			playerview.labelView.minWidth_(10);
			playerview.labelView.font_(Font.default.size_(10));
			self.trackHeaders = self.trackHeaders ?? { nil ! self.trackCount };
			self.trackHeaders[trackidx] = playerview;
			playerview;
		} {
			// last column for line players
			playerview = PlayerWrapperGridCellView(nil).asView;
			playerview.parentView.color_empty = self.color_header;
			playerview.layout.margins_(1);
			playerview.button.fixedWidth_(20);
			playerview.labelView.minWidth_(10);
			playerview.labelView.font_(Font.default.size_(10));
			self.trackHeaders = self.trackHeaders ?? { nil ! self.trackCount };
			self.trackHeaders[trackidx] = playerview;
			"volume!!!".debug;
			playerview;
			//nil;
		}
	},

	makeOverlayMenu: { arg self, view, x, y, amodel;
		WindowDef(\OverlayMenu).front(view, x, y, { arg def;
			var model = amodel;
			VLayout (
				* [
					if(model.isLinePlayer == true) {
						HLayout (
							StaticText.new.string_("label:"),
							Param( Message(model), \label, ).asTextField,
						) 
					} {
						[
							if(model.parentTrack.isEmpty.not) {
								[
									HLayout (
										StaticText.new.string_("label:"),
										Param( Message(model), \label, ).asTextField,
									) 
								] ++
								if(model.isEmpty) {
									[
										BasicButton.new.string_("Create cell").action_({
											[model, model[\makeScore].asCompileString].debug("model");
											model.makeScore;
											def.closeWindow;
										}),
										BasicButton.new.string_("Create and edit cell").action_({
											[model].debug("model");
											model.makeScore;
											model.edit;
											def.closeWindow;
										}),

										BasicButton.new.string_("Paste cell").action_({
											if(~trackDef_clipboard.notNil) {
												model.parentTrack.children[model.index] = ~trackDef_clipboard.clone(model.parentTrack, model.index);
												model.parentTrack.changed(\children);
												def.closeWindow;
											};
										}),
									]
								} {
									[
										BasicButton.new.string_("Edit cell").action_({
											model.edit;
											def.closeWindow;
										}),

										BasicButton.new.string_("Copy cell").action_({
											~trackDef_clipboard = model;
											def.closeWindow;
										}),

										StaticText.new,

										BasicButton.new.string_("Erase cell").action_({
											model.clearTrack;
											def.closeWindow;
										}),
									]
								} ++ [
									StaticText.new,
									BasicButton.new.string_("Edit track instrument").action_({
										model.parentTrack.editInstrument;
										def.closeWindow;
									}),
									BasicButton.new.string_("Erase track").action_({
										model.parentTrack.clearTrack;
										def.closeWindow;
									}),
								]
							},
							BasicButton.new.string_("Choose track template").action_({
								[model].debug("model");
								model.parentTrack.editTrackTemplate;
								def.closeWindow;
							}),
							Param(Message(model.parentTrack.parentTrack), \showTrackHeaders, ParamBoolSpec()).asButton("Show track headers"),
							Param(Message(model.parentTrack.parentTrack), \showRecorderView, ParamBoolSpec()).asButton("Show track recorder views"),
							Param(Message(model.parentTrack), \isMixerEnabled, ParamBoolSpec()).asButton("Enable mixer"),
						].flatten
					}
				].flatten.select(_.notNil) ++ [nil]
			)
		})
	},
));


WindowDef(\CustomInstrumentTrack_TemplateEditor, { arg def, track;
	var default;	
	var parent;
	parent = track.parent;
	VLayout (
		HLayout (
			StaticText.new.string_("label:"),
			Param( Message(track), \label, ).asTextField,
		),
		Param( Message(track), \trackTemplate, TagSpecDef(\CustomTrackTemplate) ).asPopUpMenu,
		nil
	)
});
);



////////////////////
///// custom tracks


(
SynthDef(\seqtrack_sampler, { arg out=0, gate=1, speed=1, pos=0, trigger=1, loop=0, bufnum;
	var sig;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1) * \velamp.kr(1);
	Out.ar(out, sig);
}).add;

TrackTemplateDef(\SeqTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\SeqTrackPart) },
	base: { arg self;
		self[\base] = Pbindef(self.name+++\base,
			\instrument, \seqtrack_sampler,
			\muter, Pfunc({ arg ev; if(ev[\velamp] > 0) {0} {\rest} }),
		);
		self[\base]
	},
	trackEditor: { arg self;
		WindowDef(self.name+++\trackeditor, { arg def, child;
			WindowDef(\sampleEditor).asView(Param(self.base, \bufnum))
		});
	},
	editor: { arg self;
		WindowDef(self.name, { arg def, child;
			[self.base, child, child.score].debug("editor call scoreEditor");
			VLayout (
				if(child.score.notNil) {
					//WindowDef(\scoreEditor).asView(self.base, child, child.score);
					Param(child.score, \velamp -> \stepseq, \unipolar).asMultiSlider;
				}
				//Slider.new,
			)
		});
	},
	makeScore: { arg self;
		self.isEmpty = false;
	},
));
TrackTemplateDef(\SeqTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	outBus_: { arg self, val;
		self.score.set(\out, val);
	},
	outBus: { arg self;
		self.score.get(\out);
	},
	makeScore: { arg self;
		self.proxy.debug("makeScore proxy start");
		self[\score] = Pbindef(self.name+++\seq, \velamp, PstepSeq(0!8,inf));
		self.proxy = PlayerWrapper(Pdef(self.name+++\part,
			self.parentTrack.base <>
			self.score
		));
		self.proxy.debug("makeScore proxy end");
	}
));

TagSpecDef(\CustomTrackTemplate).addUnique(\SeqTrack -> TrackTemplateDef(\SeqTrack));
);



(
TrackTemplateDef(\SeqCoinTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\SeqCoinTrackPart) },
	base: { arg self;
		self[\base] = Pbindef(self.name+++\base,
			\instrument, \seqtrack_sampler,
			\muter, Pfunc({ arg ev; if(ev[\coin].coin) { 0 } { \rest } }),
		);
		self[\base]
	},
	trackEditor: { arg self;
		WindowDef(self.name+++\trackeditor, { arg def, child;
			WindowDef(\sampleEditor).asView(Param(self.base, \bufnum))
		});
	},
	editor: { arg self;
		WindowDef(self.name, { arg def, child;
			[self.base, child, child.score].debug("editor call scoreEditor");
			VLayout (
				if(child.score.notNil) {
					//WindowDef(\scoreEditor).asView(self.base, child, child.score);
					Param(child.score, \coin -> \stepseq, \unipolar).asMultiSlider;
				}
				//Slider.new,
			)
		});
	},
	makeScore: { arg self;
		self.isEmpty = false;
	},
));
TrackTemplateDef(\SeqCoinTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	makeScore: { arg self;
		self.proxy.debug("makeScore proxy start");
		self[\score] = Pbindef(self.name+++\seq, \coin, PstepSeq(0!8,inf));
		self.proxy = PlayerWrapper(Pdef(self.name+++\part,
			self.parentTrack.base <>
			self.score
		));
		self.proxy.debug("makeScore proxy");
	}
));

TagSpecDef(\CustomTrackTemplate).addUnique(\SeqCoinTrack -> TrackTemplateDef(\SeqCoinTrack));
);



(
TrackTemplateDef(\AutoSeqTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\AutoSeqTrackPart) },
	postChain: { arg self;
		self[\postChain] = Pbind(
			\velamp, Pfunc({ arg ev; 
				if(ev[\velamp].isNil) {
					1
				} {
					if(ev[\velamp] > 0) {ev[\velamp]} {Rest(ev[\velamp])}
				}
			});
		);
		self[\postChain]
	},
	preChain: { arg self;
		
	},

	//base: { arg self;
		//self[\base] = Pdef(self.name+++\base,
			//\instrument, \sampler,
			//\muter, Pif(\velamp > 0, {0}, {\rest}),
		//);
		//self[\base]
	//},
	source_: { arg self, val;
		var seqpairs = List.new;
		var pairs;
		self.preChain = val;
		self[\source] = val;
		if(val.isKindOf(Pbindef) or: val.isKindOf(Pdef)) {
			if(val.source.isKindOf(PbindProxy)) {
				pairs = val.source.pairs;
			} {
				if(val.source.isKindOf(Pbind)) {
					pairs = val.patternpairs;
				} {
					pairs = []; // can't get pairs, do nothing
				}
			}
		} {
			if(val.isKindOf(PbindProxy)) {
				pairs = val.source.pairs;
			} {
				if(val.isKindOf(Pbind)) {
					self.preChain = Pdef(self.name+++\preChain, val).convertToPbindef;
					pairs = val.patternpairs;
				} {
					pairs = []; // can't get pairs, do nothing
				}
			};
		};
		pairs.clump(2).do { arg pair, idx;
			if(pair.last.isKindOf(PstepSeq)) {
				seqpairs.add(pair);
			};
		};

		self.seqpairs = seqpairs;
		
		self.existingChildren.do { arg child, idx;
			seqpairs.do { arg pair, idx;
				child.score.source.set(pair.first, pair.last.copy)
			};
		};
	},
	asParamGroup: { arg self;
		self.preChain.asParamGroup;
	},
	trackEditor: { arg self;
		WindowDef(self.name+++\trackeditor, { arg def, child;
			var pgroup;
			var lay;
		   
			if(self.preChain.notNil) {
				pgroup = self.asParamGroup
			} {
				pgroup = []
			};
			lay = VLayout(
				pgroup.asView,
			);
			if(pgroup.any({ arg pa; pa.property == \bufnum })) {
				lay.add(WindowDef(\sampleEditor).asView(Param(self.preChain, \bufnum)))
			};
			lay;
		});
	},
	editor: { arg self;
		WindowDef(self.name, { arg def, child;
			[self.base, child, child.score].debug("editor call scoreEditor");
			VLayout (
				if(child.score.notNil) {
					//WindowDef(\scoreEditor).asView(self.base, child, child.score);
					VLayout (
						* self.seqpairs.collect { arg pair, idx;
							Param(child.score, pair.first -> \stepseq).asView;
						};
					)
				}
				//Slider.new,
			)
		});
	},
	makeScore: { arg self;
		self.source = Pbind(\instrument, \default, \degree, PstepSeq(0!8,inf), \velamp, PstepSeq(1!8,inf));
		self.isEmpty = false;
	},
));
TrackTemplateDef(\AutoSeqTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	makeScore: { arg self;
		self.proxy.debug("makeScore proxy start");
		self[\score] = Pbindef(self.name+++\seq, \isPbindef, true);
		self.parentTrack.seqpairs.do { arg pair, idx;
			self.score.source.set(pair.first, pair.last.copy)
		};
		self.proxy = PlayerWrapper(Pdef(self.name+++\part,
			self.parentTrack.postChain <>
			self.score <>
			self.parentTrack.preChain
		));
		self.proxy.debug("makeScore proxy end");
	}
));

TagSpecDef(\CustomTrackTemplate).addUnique(\AutoSeqTrack -> TrackTemplateDef(\AutoSeqTrack));
);



(
TrackTemplateDef(\PlayerWrapperTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\PlayerWrapperTrackPart) },
	makeScore: { arg self;
		self.isEmpty = false;
	},
));
TrackTemplateDef(\PlayerWrapperTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	selectSourceDialog: { arg self;
		TrackTemplateDef(\playerwrapper)[\selectSourceDialog].value(self);
	},

));

TagSpecDef(\CustomTrackTemplate).addUnique(\PlayerWrapperTrack -> TrackTemplateDef(\PlayerWrapperTrack));
);



(
TrackTemplateDef(\PbindefTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\PbindefTrackPart) },
	makeScore: { arg self;
		self.isEmpty = false;
	},
));
TrackTemplateDef(\PbindefTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	makeScore: { arg self;
		self.source = Pbindef(self.trackKey, \instrument, \default);
		self.proxy.debug("makeScore proxy end");
	},
	selectSourceDialog: { arg self;
		TrackTemplateDef(\playerwrapper)[\selectSourceDialog].value(self);
	},

));

TagSpecDef(\CustomTrackTemplate).addUnique(\PbindefTrack -> TrackTemplateDef(\PbindefTrack));
);



(
TrackTemplateDef(\NoteTimelineTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\NoteTimelineTrackPart) },

	asParamGroup: { arg self;
		self.source.asParamGroup;
	},
	trackEditor: { arg self;
		WindowDef(\PdefInstrumentEditor);
	},


	recorderView: { arg self;
		HLayout (
			Param(Message(self), \recordArmed, XBoolSpec()).asButton("●").maxWidth_(20),
			Param(Message(self), \inputController, ControllerDef.getTagSpec(\piano)).asPopUpMenu.minWidth_(5),
		).margins_(0).spacing_(0)
	},

	scorePresetCompileString: { arg self;
		var str;
		str = List.new;
		str.add( "%.source = %;".format(self.refCompileString, self.source.asCompileString));
		str.add( PlayerWrapper(self.source).presetCompileString );
		str.join($\n);
	},

	playerSynthDef: \SampleTimeline_player,

	playerSynthDef_: { arg self, instr;
		// TagSpecDef(\SynthDef) values are SynthDesc, not SynthDef key
		Log(\Param).debug("TrackInstrument_NoteTimelineTrack set playerSynthDef %", instr);
		self[\playerSynthDef] = instr;
		Pbindef(self.source.key, \instrument, instr);
		self.source.addHalo(\instrument, instr);
		self.changed(\playerSynthDef);
	},
	makeScore: { arg self;
		self[\source] = Pdef("%.%.instr".format(self.key, self.index).asSymbol, Pbind());
		self.isEmpty = false;
	},
));
TrackTemplateDef(\NoteTimelineTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	edit: { arg self;
		self.score.edit;
	},

	startRecordingNewScore: { arg self;
		self.makeScore;
		self.score.startRecording;
	},

	stopRecording: { arg self;
		if(self.score.notNil) {
			self.score.stopRecording;
		}
	},

	cloneScore: { arg self;
		var newscore;
		newscore = NoteTimeline(self.name+++\score, self.parentTrack.source);
		newscore.eventList = self.score.eventList.clone;
		newscore.controller = self.parentTrack.inputController;
		newscore.outBus = self.parentTrack.outBus;
		newscore;
	},

	outBus: { arg self, val;
		self.score.outBus = val;
		
	},
	makeScore: { arg self;
		self.proxy.debug("makeScore proxy start");
		self[\score] = NoteTimeline(self.name+++\score, self.parentTrack.source);
		self.score.controller = self.parentTrack.inputController;
		self.score.outBus = self.parentTrack.outBus;
		self.proxy = PlayerWrapper(self.score);
		self.proxy.debug("makeScore proxy end");
	}
));

TagSpecDef(\CustomTrackTemplate).addUnique(\NoteTimelineTrack -> TrackTemplateDef(\NoteTimelineTrack));
);

(
TrackTemplateDef(\SampleTimelineTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\SampleTimelineTrackPart) },

	asParamGroup: { arg self;
		self.source.asParamGroup;
	},

	keepSamplesInUse: { arg self;
		self.existingChildren.do { arg clip, idx;
			if(clip.isEmpty.not and: { clip.source.notNil }) {
				clip.source.keepRecordedFile;
			}
		};
	},

	scorePresetCompileString: { arg self;
		if(self.recBus.notNil) {
			"%.recBus = %;".format(self.refCompileString, self.recBus.asCompileString);
		} {
			""
		}
	},

	trackEditor: { arg self;
		//WindowDef(\PdefInstrumentEditor);
		WindowDef(\SampleTimelineTrackEditor, { arg def;
			VLayout (
				Param(Message(self),\recBus,ParamAudioBusSpec()).asView,
				nil
			);
		}).front;
	},

	recorderView: { arg self;
		HLayout (
			Param(Message(self), \recordArmed, XBoolSpec()).asButton("●").maxWidth_(20),
			Param(Message(self), \recBus, ParamAudioBusSpec()).asPopUpMenu.minWidth_(5),
		).margins_(0).spacing_(0)
	},

	makeScore: { arg self;
		//self[\source] = Pdef("%.%.instr".format(self.key, self.index).asSymbol, Pbind());
		self.isEmpty = false;
	},
));
TrackTemplateDef(\SampleTimelineTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	edit: { arg self;
		self.score.edit;
	},

	startRecordingNewScore: { arg self;
		self.makeScore;
		self.score.startRecording;
	},

	stopRecording: { arg self;
		if(self.score.notNil) {
			self.score.stopRecording;
		}
	},

	outBus: { arg self, val;
		self.score.outBus = val;
		
	},

	cloneScore: { arg self;
		var newscore;
		newscore = SampleTimeline(self.name+++\score);
		newscore.eventList = self.score.eventList.clone;
		newscore.controller = self.parentTrack.inputController;
		newscore.buffer = self.score.buffer;
		newscore.outBus = self.parentTrack.outBus;
		self[\score].recorder.recBus = self.parentTrack.recBus ?? { self[\score].recorder.recBus  };
		newscore;
	},

	makeScore: { arg self;
		self.proxy.debug("makeScore proxy start");
		self[\score] = SampleTimeline(self.name+++\score);
		self[\score].outBus = self.parentTrack.outBus;
		self[\score].recorder.recBus = self.parentTrack.recBus ?? { self[\score].recorder.recBus  };
		self.proxy = PlayerWrapper(self.score);
		self.proxy.debug("makeScore proxy end");
	}
));

TagSpecDef(\CustomTrackTemplate).addUnique(\SampleTimelineTrack -> TrackTemplateDef(\SampleTimelineTrack));
);


(
TrackTemplateDef(\CodeFileTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\CodeFileTrackPart) },
	codeFilePath: "/tmp/bla/",
	initTrack: { arg self;
		self.makeScore;
		self.loadPresetCompileString;
	},
	dataPath: "/tmp/bla",

	outBus_: { arg self, outBus;
		self[\outBus] = outBus;
		self.proxy.set(\out, outBus);
		self.changed(\outBus);
	},

	presetCompileStringSavePath: { arg self;
		//self.codeFilePath +/+ "TrackDef_%.scd".format(self.trackKey);
		self.codeFilePath;
	},

	codeFilePrefix: { arg self;
		self.trackKey;
	},

	loadPresetCompileString: { arg self;
		FileSystemProject.load(self.presetCompileStringSavePath +/+ "%.init.scd".format(self.codeFilePrefix), silent:false);
	},
	makeScore: { arg self;
		self.isEmpty = false;
		self.proxy = PlayerWrapper(Pdef("%_base".format(self.codeFilePrefix).asSymbol));
	},
));
ProtoTemplateDef(\CodeFilePlayer, (
	isPlaying: { arg self;
		self.trackPart.parentTrack.proxy.isPlaying and: { self.trackPart.isActive };
	},
	label: { arg self;
		if(self.trackPart.isEmpty.not and: {self.trackPart.presetCompileStringSavePath.notNil}) {
			PathName(self.trackPart.presetCompileStringSavePath).fileName;
		} {
			"-"
		}
		
	},
	isPlaying_: { arg self, val;
		val.debug("CodeFilePlayer.isPlaying_");
		if(val==true) {
			self.trackPart.loadPresetCompileString;
		};
		self.trackPart.parentTrack.proxy.isPlaying = val;
	},
	play: { arg self;
		self.isPlaying = true;
	},
	stop: { arg self;
		self.isPlaying = false;
	},
));
TrackTemplateDef(\CodeFileTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	isEmpty: { arg self;
		File.exists(self.presetCompileStringSavePath).not
	},
	makeScore: { arg self;
		self.codeFilePlayer = ProtoClass((
			parent: ProtoTemplateDef(\CodeFilePlayer),
			trackPart: {self},
		));
		self.proxy = PlayerWrapper(self.codeFilePlayer);
	},
	initTrack: { arg self;
		self.makeScore;
	},
	loadPresetCompileString: { arg self;
		FileSystemProject.load(self.presetCompileStringSavePath, false);
	},

	codeFilePrefix: { arg self;
		self.parentTrack.codeFilePrefix;
	},

	presetCompileStringSavePath: { arg self;
		self.parentTrack.presetCompileStringSavePath +/+ "%.%.scd".format(self.codeFilePrefix, self.index);
	},

	selectSourceDialog: { arg self;
		"vim --servername scvim --remote-send '<Esc>:drop %<Enter>'".format(self.presetCompileStringSavePath).unixCmd;
	},
	stopInternal: { arg self;
		
		"stop internal".debug;
	},

));

TagSpecDef(\CustomTrackTemplate).addUnique(\CodeFileTrack -> TrackTemplateDef(\CodeFileTrack));
);

//Spec.add(\degree, ControlSpec(0,14,\lin,1,0));
//Spec.add(\velamp, \unipolar);
//BufDef(\amen, "vipere/amenbreak.wav");

