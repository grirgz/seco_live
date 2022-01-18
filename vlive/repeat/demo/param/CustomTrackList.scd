
(
SynthDef(\sampler, { arg out=0, gate=1, speed=1, pos=0, trigger=1, loop=0, bufnum;
	var sig;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1) * \velamp.kr(1);
	Out.ar(out, sig);
}).add;

BufDef(\amen, "vipere/amenbreak.wav");

FileSystemProject.load("libdef/soundfileview.scd");
FileSystemProject.load("libdef/tracklist.scd");
FileSystemProject.load("libdef/tracklist_buildertrack.scd");
FileSystemProject.load("libdef/default_specs.scd");


);

(
TrackTemplateDef(\CustomTrackList, (
	parent: TrackTemplateDef(\TrackList),
	childClass: { TrackTemplateDef(\CustomInstrumentTrack) },
	showTrackHeaders: true,
	edit: { arg self;
		WindowDef(\customgrid).front(self);
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
					WindowDef(\PdefEditor).front(target)
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



(
TrackTemplateDef(\SeqTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\SeqTrackPart) },
	base: { arg self;
		self[\base] = Pbindef(self.name+++\base,
			\instrument, \sampler,
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
			\instrument, \sampler,
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
TrackTemplateDef(\NoteTimelineTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\NoteTimelineTrackPart) },

	asParamGroup: { arg self;
		self.source.asParamGroup;
	},
	trackEditor: { arg self;
		WindowDef(\PdefInstrumentEditor);
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

	outBus: { arg self, val;
		self.score.outBus = val;
		
	},
	makeScore: { arg self;
		self.proxy.debug("makeScore proxy start");
		self[\score] = NoteTimeline(self.name+++\score, self.parentTrack.source);
		self.proxy = PlayerWrapper(self.score);
		self.proxy.debug("makeScore proxy end");
	}
));

TagSpecDef(\CustomTrackTemplate).addUnique(\NoteTimelineTrack -> TrackTemplateDef(\NoteTimelineTrack));
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
	showToolBar: true,
	color_header: Color.gray.lighten(ParamViewToolBox.color_dark, 0.7),
	
	asView: { arg self, me, maintrack;
		var viewgrid;
		var mainview;
		var make_view;
		var playerviews;
		var map_players;
		var mixerviews;
		maintrack = maintrack ?? { TrackDef(\main) };

		self.maintrack = maintrack;
		// commented because at caller level
		//if(me.window.notNil) {
		//	me.window.bounds = Rect(144, 217, 1090, 438);
		//};

		mainview = View.new;
		mainview.onChange(maintrack, \gridOffset, { {map_players.()}.defer });

		playerviews = { { PlayerWrapperGridCellView.new } ! self.rowCount } ! self.trackCount;
		playerviews.last.do { arg item, idx;
			item.color_empty = self.color_header;
		};
		//mixerviews = { WindowDef(\mixerView).asView } ! 9;
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
						//self.trackFaders[x].model = track;
						
					}
				} {

				}
			});


			boxview.layout = VLayout(
				self.makeTrackHeader(x),
				self.makeTrackFader(x),
				nil,
			).spacing_(0).margins_(0);

			boxview.maxWidth = 200;
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
			mixerviews.do({ arg child, x;
				[child, x].debug("set mixerview model: child");
				if(child.notNil) {
					if(x == 8) {
						child.model = Server.default.volume;
					} {
						child.model = maintrack.childAtOffset(x);
					}
				}
			})

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
						++ [ [ mixerviews[idx] ] ]
					})
				).vSpacing_(1).hSpacing_(1),
				nil
			);
			if(self.showToolBar == true) {
				VLayout(
					self.makeToolBar,
					mainview,
				)
			} {
				mainview
			}
		};
		map_players.();
		make_view.();
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
			nil
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
		if(trackidx != ( self.trackCount - 1 )) {
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
			self.trackHeaders = self.trackHeaders ?? { nil ! self.trackCount };
			self.trackHeaders[trackidx] = playerview;
			playerview;
		} {
			playerview = PlayerWrapperGridCellView(nil).asView;
			playerview.parentView.color_empty = self.color_header;
			playerview.layout.margins_(1);
			playerview.button.fixedWidth_(20);
			playerview.labelView.minWidth_(10);
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
							]
						} {
							[
								BasicButton.new.string_("Edit cell").action_({
									model.edit;
									def.closeWindow;
								}),

								BasicButton.new.string_("Erase cell").action_({
									model.clear;
									def.closeWindow;
								}),
							]
						} ++ [
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
					Param(Message(model.parentTrack), \isMixerEnabled, ParamBoolSpec()).asButton("Enable mixer"),
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

Spec.add(\degree, ControlSpec(0,14,\lin,1,0));
Spec.add(\velamp, \unipolar);

);

////////////////////////////////////////////////////////////////////////////////////////////////////////
// END

TrackDef(\myseq).clear;
TrackDef(\myseq, TrackTemplateDef(\CustomTrackList))
TrackDef(\myseq).edit

TrackDef(\myseq).elAt(0).showTrackHeaders
TrackDef(\myseq).elAt(0).isMixerEnabled
TrackDef(\myseq).showTrackHeaders = true
TrackDef(\myseq).isMixerEnabled = false;
TrackDef(\myseq).isMixerEnabled = true
TrackDef(\myseq).isMixerEnabled 
TrackDef(\myseq).edit

~self.trackFaders[0].model = TrackDef(\myseq).elAt(0).mixer
~self.trackFaders[0].model = nil
TrackDef(\myseq).elAt(0).mixer

TrackMixerDef(\bla)[\storeOn]
TrackMixerDef(\bla2)

TrackDef(\myseq).elAt(0).source = Pbind(\instrument, \default, \degree, PstepSeq(0!8,inf), \velamp, PstepSeq(1!8,inf))
TrackDef(\myseq).elAt(0).preChain.play
TrackDef(\myseq).elAt(0).preChain
TrackDef(\myseq).elAt(0).seqpairs
TrackDef(\myseq).elAt(0).postChain = Pbind()
TrackDef(\myseq).elAt(0).postChain.patternpairs.last.nextFunc.asCompileString
TrackDef(\myseq).elAt(0).asParamGroup
TrackDef(\myseq).elAt(0)[\source_].asCompileString
TrackDef(\myseq).elAt(0).existingChildren
TrackDef(\myseq).elAt(0).parent.parent.parent.parent
TrackDef(\myseq).elAt(0).source
TrackDef(\myseq).elAt(0,0).score.source.pairs
TrackDef(\myseq).elAt(0,0).score.source.pairs.last.source.list
TrackDef(\myseq).elAt(0,0).score.source.pairs[1].source.list
TrackDef(\myseq).elAt(0,0).score.play
TrackDef(\myseq).elAt(0,0).play
TrackDef(\myseq).elAt(0).postChain = nil
TrackDef(\myseq).elAt(0).postChain
T
TrackDef(\myseq).elAt(0,0).score.clear
TrackDef(\myseq).elAt(0,0).makeScore
( TrackDef(\myseq).elAt(0).postChain <> TrackDef(\myseq).elAt(0,0).score <> TrackDef(\myseq).elAt(0).preChain ).play
(  TrackDef(\myseq).elAt(0,0).score <> TrackDef(\myseq).elAt(0).preChain ).trace.play
TrackDef(\myseq).elAt(0,0).source.source.patterns
TrackDef(\myseq).elAt(0,0).source.play
TrackDef(\myseq).elAt(0,0).source
TrackDef(\myseq).elAt(0,0).edit
TrackDef(\myseq).elAt(0).editor.
TrackDef(\myseq).elAt(0,0)[\editor].asCompileString


TrackDef(\myseq).elAt(0).seqpairs
TrackDef(\myseq).elAt(0).editInstrument
TrackDef(\myseq).elAt(0).mixer_obj
TrackDef(\myseq).elAt(0).isMixerEnabled
TrackDef(\myseq).mixer


TrackDef(\myseq).linePlayerAt(0)[\isPlaying].asCompileString
TrackDef(\myseq).linePlayerAt(1)[\isPlaying].asCompileString
TrackDef(\myseq).lineClass[\isPlaying].asCompileString
TrackDef(\myseq).lineClass
TrackTemplateDef(\lineplayer)[\isPlaying].asCompileString
TrackTemplateDef(\TrackListPart)[\isPlaying].asCompileString
TrackTemplateDef(\TrackListPart).clear
TrackDef(\myseq).linePlayers[0].parent
TrackDef(\myseq).linePlayers= nil
TrackDef(\myseq).obj_linePlayers= nil
SparseArray

TrackDef(\myseq).changed(\gridOffset)
TrackDef(\myseq).elAt(1).base.edit
TrackDef(\myseq).elAt(4).changed(\children)
TrackDef(\myseq).elAt(4)[\updateChildren].asCompileString
TrackDef(\myseq).childAt(0).trackTemplate = TrackTemplateDef(\SeqTrack)
TrackDef(\myseq).children[1] = nil
WindowDef(\customgrid).front(TrackDef(\myseq))
StaticText


////////////////////////////////////// draft
(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\coin, Pseq([0,0.4,1],inf),
		\muter, Pif(Pkey(\coin).coin, {0}, {\rest}),
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);



(
WindowDef(\win, { arg def;
	StaticText.new.string_("long long lon lon lon lon lon lon lon lon longgggggggg").minWidth_(5)
	
}).front;
);
(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([2,5,-4,0],inf),
		\velamp, PstepSeq([1,0,1,1,0],inf),
		\muter, Pfunc({ arg ev; if(ev[\velamp] > 0) {0} {\rest} }),
		\dur, 1/8,
		\amp, 0.1 * Pwhite(0.1,0.5),
	) <>
	Pbind(
		\velamp, PstepSeq([0,0,0,0,0],inf),
	) 
).play;
);

(
Pdef(\zed, 
	Pbind(
		//\velamp, Pfunc({ arg ev; if(ev[\velamp] > 0) {ev[\velamp]} {Rest(ev[\velamp])} }),
			\velamp, Pfunc({ arg ev; 
				if(ev[\velamp].isNil) {
					1
				} {
					if(ev[\velamp] > 0) {ev[\velamp]} {Rest(ev[\velamp])}
				}
			});
	)<>
	Pbind(
		//\velamp, PstepSeq([0,0,0,0,1],inf),
	) <>
	Pbind(
		\instrument, \default,
		\degree, Pseq([2,5,-4,0],inf),
		//\velamp, PstepSeq([1,0,1,1,0],inf),
		//\muter, Pfunc({ arg ev; if(ev[\velamp] > 0) {0} {\rest} }),
		\dur, 1/8,
		\amp, 0.1 * Pwhite(0.1,0.5),
	) 
).play;
);

WindowDef(\TrackMixerDef_advanced).front()

(
WindowDef(\win, { arg def;
	var mix1, mix2;
	var options = (showOutbus:true, showSends:true, showFaderTextField: true, showPlay: true, showDelay:true, showFx:true);
	HLayout (
		mix1 = WindowDef(\TrackMixerDef_advanced).asView(nil, options),
		mix2 = WindowDef(\TrackMixerDef_advanced).asView(nil, options),
		WindowDef(\TrackMixerDef_advanced).asView(nil, options),
		BasicButton.new.string_("bla").action_({
			mix1.model = TrackDef(\myseq).elAt(0).mixer;
			mix2.model = TrackDef(\myseq).elAt(1).mixer;
		}),
		BasicButton.new.string_("remobve").action_({
			mix1.model = nil;
			mix2.model = nil;
		})
	)
	
}).front;
);

TrackDef(\myseq).elAt(0,0).outBus
(
TrackDef(\myseq, TrackTemplateDef(\CustomTrackList));
TrackDef(\myseq).elAt(0).isMixerEnabled = true;
TrackDef(\myseq).elAt(1).isMixerEnabled = true;
)


//////////



(
/// debug customgrid mixer
WindowDef(\customgrid, (
	trackCount: 1,
	rowCount: 2,
	masterTrackIndex: 8,
	showToolBar: true,
	
	asView: { arg self, me, maintrack;
		var viewgrid;
		var mainview;
		var make_view;
		var playerviews;
		var map_players;
		var mixerviews;
		maintrack = maintrack ?? { TrackDef(\main) };

		self.maintrack = maintrack;
		// commented because at caller level
		//if(me.window.notNil) {
		//	me.window.bounds = Rect(144, 217, 1090, 438);
		//};

		mainview = View.new;
		mainview.onChange(maintrack, \gridOffset, { {map_players.()}.defer });

		self.trackFaders = nil ! self.trackCount;
		mixerviews = self.trackCount.collect({ arg x;
			self.makeTrackFader2(x)
		});

		if(me.window.notNil) {
			me.window.name = "playergrid: " ++ maintrack.key;
		};

		map_players = {
			mixerviews.do({ arg child, x;
				[child, x].debug("set mixerview model: child");
				child.model = maintrack.childAtOffset(x).mixer;
			})

		};

		//map_players.();
		VLayout (
			self.makeToolBar,
			HLayout(*mixerviews)
		)
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
			BasicButton.new.string_("debug self").action_({
				~self = self;

			}),
			BasicButton.new.string_("debug model").action_({
				~dbmix.model = self.maintrack.elAt(0).mixer;
				//self.trackFaders[0] = self.maintrack.elAt(0).mixer;
				~dbfirstmix.model = self.maintrack.elAt(0).mixer;

			}),
			BasicButton.new.string_("debug model nil").action_({
				~dbmix.model = nil;
				//self.trackFaders[0] = nil;
				~dbfirstmix.model = nil;
			}),

			~dbmix = WindowDef(\customgrid_mixer+++\azer, WindowDef(\TrackMixerDef_advanced)).asView,
			nil
		)
	},

	makeTrackFader2: { arg self, trackidx;
		var res = WindowDef(\customgrid_mixer+++trackidx, WindowDef(\TrackMixerDef_advanced)).asView;
		self.trackFaders[trackidx] = res;
		if(trackidx == 0) {
			Log(\Param).debug("AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
			~dbfirstmix = res;
		};
		~dbfader = res;
		res
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
			//self.trackFaders = self.trackFaders ?? { nil ! self.trackCount };
			//if(self.trackFaders[trackidx].notNil) {
				//trackidx.throw;
			//};
			if(trackidx == 0) {
				~dbfirstmix = mixerview;
			};
			self.trackFaders[trackidx] = mixerview;
			mixerview;
		};
	},

	makeTrackHeader: { arg self, trackidx;
		var playerview;
		if(trackidx != 8) {
			var child;
			var maintrack = self.maintrack;
			child = maintrack.childAtOffset(trackidx);
			[child, child.source, trackidx].debug("showTrackHeaders: child");
			playerview = PlayerWrapperGridCellView(child).asView.addUniqueMethod(\model_, { arg view, val;
				view.parentView.model = val;
			}).mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
				if(buttonNumber == 1) {
					child.editTrackTemplate;
				};
			});

			playerview.layout.margins_(1);
			playerview.button.fixedWidth_(20);
			playerview.labelView.minWidth_(10);
			self.trackHeaders = self.trackHeaders ?? { nil ! self.trackCount };
			self.trackHeaders[trackidx] = playerview;
			playerview;
		} {
			playerview = PlayerWrapperGridCellView(nil).asView.addUniqueMethod(\model_, { arg me, val;
		   
				//view.parentView.model = val;
			});
			playerview.layout.margins_(1);
			playerview.button.fixedWidth_(20);
			playerview.labelView.minWidth_(10);
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
					if(model.parentTrack.isEmpty.not) {
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
							]
						} {
							[
								BasicButton.new.string_("Edit cell").action_({
									model.edit;
									def.closeWindow;
								}),

								BasicButton.new.string_("Erase cell").action_({
									model.clear;
									def.closeWindow;
								}),
							]
						} ++ [
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
					Param(Message(model.parentTrack), \isMixerEnabled, ParamBoolSpec()).asButton("Enable mixer"),
				].flatten.select(_.notNil) ++ [nil]
			)
		})
	},
));
WindowDef(\customgrid).front(TrackDef(\myseq))
)


//////////////////////////////////////////



TrackTemplateDef(\CodeFileTrackPart)[\play].asCompileString




TrackDef(\bla, TrackTemplateDef(\CustomInstrumentTrack))
TrackDef(\bla).presetCompileStringSavePath = "~/code/sc/seco/vlive/repeat/tests/tmp/cfile/".standardizePath;
TrackDef(\bla).trackTemplate = TrackTemplateDef(\CodeFileTrack);
TrackDef(\bla).elAt(0).play
TrackDef(\bla).elAt(1).play
TrackDef(\bla).elAt(1).stop
TrackDef(\bla).play
TrackDef(\bla).stop

TrackDef(\myseq).clear;
TrackDef(\myseq, TrackTemplateDef(\CustomTrackList))
TrackDef(\myseq).edit
TrackDef(\myseq).isActive
TrackDef(\myseq).childAt(0).presetCompileStringSavePath = "~/code/sc/seco/vlive/repeat/tests/tmp/cfile/".standardizePath;
TrackDef(\myseq).childAt(0,0).presetCompileStringSavePath
TrackDef(\myseq).childAt(0).presetCompileStringSavePath
TrackDef(\myseq).childAt(0).loadPresetCompileString
TrackDef(\myseq).childAt(0).proxy
TrackDef(\myseq).childAt(0).makeScore
TrackDef(\myseq).childAt(0).codeFilePrefix = "bla"




TrackDef(\bla).clear
TrackDef(\bla, TrackTemplateDef(\CodeFileTrack))
TrackDef(\bla).makeScore
TrackDef(\bla).initTrack
TrackDef(\bla).trackKey
TrackDef(\bla).presetCompileStringSavePath
TrackDef(\bla).proxy
TrackDef(\bla).refCompileString
TrackDef(\bla).presetCompileStringSavePath = "~/code/sc/seco/vlive/repeat/tests/tmp/cfile/".standardizePath;
TrackDef(\bla).presetCompileStringSavePath
TrackDef(\bla).loadPresetCompileString
TrackDef(\bla).proxy.play
TrackDef(\bla).activeIndex
TrackDef(\bla).play
TrackDef(\bla).proxy.isPlaying = true
TrackDef(\bla).elAt(1)[\refCompileString].asCompileString
TrackDef(\bla).elAt(1).makeScore
TrackDef(\bla).elAt(1).play
TrackDef(\bla).elAt(1).proxy
TrackDef(\bla).elAt(1).parentTrack.activeIndex
TrackDef(\bla).elAt(1).parentTrack.activeChild
TrackDef(\bla).elAt(1).index
TrackDef(\bla).elAt(1)[\play].asCompileString
TrackDef(\bla).elAt(1)[\play] = nil
TrackDef(\bla).elAt(1).isEmpty
TrackDef(\bla).elAt(2).isEmpty
TrackDef(\bla).elAt(1).proxy.isPlaying = true
TrackDef(\bla).elAt(1).proxy.play
TrackDef(\bla).elAt(0).proxy.play
TrackDef(\bla).elAt(0).makeScore
TrackDef(\bla).elAt(1).makeScore
TrackDef(\bla).elAt(0).play
TrackDef(\bla).elAt(1).play
TrackDef(\bla).elAt(1).stop
TrackDef(\bla).elAt(1).stopInternal
TrackDef(\bla).elAt(0).presetCompileStringSavePath
TrackDef(\bla).elAt(1).proxy.target[\isPlaying_].asCompileString
TrackDef(\bla).elAt(1).proxy.target.isPlaying = true
TrackDef(\bla).elAt(1).proxy.target.trackPart.parentTrack.proxy.play
TrackDef(\bla).elAt(1).presetCompileStringSavePath
TrackDef(\bla).elAt(1).loadPresetCompileString
Tr
TrackTemplateDef(\CodeFileTrackPart)
(
Pdef(\bla_base, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
);
);
TrackDef(\bla).presetCompileStringSavePath = "/tmp/bla/"
TrackDef(\bla).presetCompileStringSavePath
TrackDef(\bla).savePresetCompileString


(
~bla = ProtoClass((
	isPlaying_: { arg self, val;
		Log(\Param).debug("sdkfjsdkfjskdfj %", val);
		
	},
))
)
~bla.isPlaying = 4

(
Pdef(\zed, 
    Pbind(
        \instrument, \default,
        \degree, Prout({ arg ev;
            Pseq([3,2,6,1,1,8]).do { arg x;
                Pser([2,5,1,6,4,2,2,0],x).embedInStream;
            };
        }).repeat(2),
        \dur, 1/8,
        \amp, 0.1,
    ).trace
).play;
);
