
ParamProto.init;
FileSystemProject.loadOnce("libdef/tracks.scd");
FileSystemProject.loadOnce("libdef/drumkit.scd");
FileSystemProject.loadOnce("libdef/synthplayrec.scd");
FileSystemProject.loadOnce("libdef/MainProject.scd");

FileSystemProject.loadOnce("libdef/soundfileview.scd");
FileSystemProject.loadOnce("libdef/tracklist_buildertrack.scd");
FileSystemProject.loadOnce("libdef/default_specs.scd");

// cell API
// - proxy: object that is played
// - source: object that can be set, by default put in a PlayerWrapper then in .proxy



/// base class

(
TrackTemplateDef(\CustomTrackList, (
	parent: TrackTemplateDef(\playergrid),

	eventType: \tracklist,
	childClass: { TrackTemplateDef(\CustomInstrumentTrack) },
	lineClass: { TrackTemplateDef(\CustomTrackListPart) },
	showTrackHeaders: true,
	showRecorderView: true,
	showMixerView: true,

	showRecorderView_: { arg self, val;
		self[\showRecorderView] = val;
		self.changed(\children);
	},

	showTrackHeaders_: { arg self, val;
		self[\showTrackHeaders] = val;
		self.changed(\children);
	},

	showMixerView_: { arg self, val;
		self[\showMixerView] = val;
		self.changed(\children);
	},

	addTrack: { arg self, trackTemplate, label;
		var lastidx = -1;
		var trackidx;

		// find empty track
		block  { arg break;
			self.children.do { arg child, childidx;
				lastidx = childidx;
				if(self.childAt(childidx).isEmpty) {
					//Log(\Param).debug("found empty track: %", childidx);
					trackidx = childidx;
					break.value;
				}
			};
			//Log(\Param).debug("grid.addTrack: no empty track found, use %", lastidx+1);
			trackidx = lastidx+1;
		};

		// define it
		self.defineTrack(trackidx, trackTemplate, label)
	},

	defineTrack: { arg self, trackidx, trackTemplate, label;
		var trackkey;
		var newtrack = self.childAt(trackidx);
		TagSpecDef(\TrackList).addUnique(self.key -> self);
		newtrack.trackTemplate = trackTemplate;
		if(label.notNil) {
			newtrack.label = label
		};
		self.changed(\tracklist);
		
	},

	removeTrack: { arg self, index;
		self.childAt(index).clearTrack;
		self.children[index] = nil;
		self.changed(\tracklist);
	},

	////// others

	keepSamplesInUse: { arg self;
		self.existingChildren.do { arg track, idx;
			track.keepSamplesInUse;
		};

	},


	////// properties

	trackKey: { arg self;
		self.key;
	},

	selectedPart: 0,
	selectedPart_: { arg self, val;
		if(val != self[\selectedPart]) {
			var isPlaying = self.linePlayerAt(self.selectedPart).isPlaying;
			self[\selectedPart] = val;
			self.changed(\selectedPart);
			self.changed(\tracklist);
			//self.isPlaying.debug("test playing");
			if(isPlaying) {
				//self.selectedPart.debug("test playing yes!");
				self.linePlayerAt(self.selectedPart).play;
			};
		}
	},

	areasizex_: { arg self, val;
		self[\areasizex] = val;
		self.changed(\tracklist);
	},

	////// editor

	edit: { arg self;
		WindowDef(( \CTrackList_++self.key ).asSymbol, WindowDef(\CustomTrackList)).front(self);
	},

	editGrid: { arg self;
		WindowDef(( \CTrackGrid_++self.key ).asSymbol, WindowDef(\customgrid)).front(self);
	},

	////// save/load

	savePresetCompileString: { arg self, path, onDoneAction;
		// currently, this require to give an absolute path to a directory that does not 
		//		exist and that will contains all the save files


		// path should be an absolute folder path
		// FIXME: giving path as argument is broken: self.dataPath is not defined
		var savefile;
		if(path.isNil and: {self.presetCompileStringSavePath.isNil}) {
			"savePresetCompileString: presetCompileStringSavePath is nil, can't save".error;
		} {
			var pathexists;
			//path = path ?? { (self.presetCompileStringSavePath +/+ "TrackDef_%.scd".format(self.key)) };
			path = path ? self.presetCompileStringSavePath;
			//path.debug("TrackList.savePresetCompileString");
			savefile = path +/+ "TrackDef_%.scd".format(self.key);
			pathexists = File.exists(path);
			if(pathexists.not or: {self.loadedFromPath == path}) {
				if(pathexists.not) {
					File.mkdir(path);
				};
				self.loadedFromPath = path;
				self.presetCompileStringSavePath = path;
				File.mkdir(self.dataPath);
				PlayerWrapper_Base.savePresetCompileStringHelper(savefile, onDoneAction, self.refCompileString, self.presetCompileString, false);
				self.existingChildren.do({ arg column;
					column.savePresetCompileString;
				});
				self.resources.do { arg res;
					PlayerWrapper(res).savePresetCompileString;
				}; 
				Log(\Param).info("TrackList % saved.", self.key);
			} {
				"savePresetCompileString: can't save on existing project. (loadedFromPath is different)".error;
			}
		}
	},

	refCompileString: { arg self;
		"TrackDef(%)".format(self.key.asCompileString);
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

	loadPresetCompileString: { arg self;
		// this function should not load the main file because it is the main file that call this function
		if(self.isEmpty) {
			self.resources.do { arg res;
				PlayerWrapper(res).loadPresetCompileString;
			}; 
			// FIXME: find a not hardcoded way
			16.do { arg idx;
				self.childAt(idx).loadPresetCompileString;
			};
			if(self.isEmpty.not) {
				self.loadedFromPath = self.presetCompileStringSavePath;
			};
			self.changed(\tracklist);
		} {
			"Can only load on empty project to prevent overriding".error;
		}
	},

	dataPath: { arg self;
		if(self.presetCompileStringSavePath.notNil) {
			self.presetCompileStringSavePath +/+ "TrackDef_%/".format(self.key);
		}
	},

	presetCompileStringSavePath_: { arg self, val;
		// FIXME: path should either be asbsolute or relative
		// savePresetCompileString does not resolve the path
		self[\presetCompileStringSavePath] = val;
		//val.debug("===== setting resources save path. path:");
		self.resources.do { arg track;
			PlayerWrapper(track).presetCompileStringSavePath = "%%_%.scd".format(val, PlayerWrapper(track).targetClass, track.key);
		};
	},

	loadedFromPath: nil,
));

TrackTemplateDef(\CustomInstrumentTrack, (
	parent: TrackTemplateDef(\playertrack),
	eventType: \instrumenttrack,
	childClass: { TrackTemplateDef(\CustomInstrumentTrackPart) },
	makeScoreOnInitTrack: true, // WIP


	new: { arg self, parent, index;
		self = ProtoClass(( parent: self ));

		self.selectChild(0);
		self.index = index.asInteger;
		self.parentTrack = {parent};
		self[\storeOn] = { arg self, str; str << self.refCompileString };
		self;
	},

	initTrack: { arg self;
		if(self.makeScoreOnInitTrack) {
			self.makeScore;
		}
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

	clearTrack: { arg self;
		self.clearAllTrackParts;
		//self.trackTemplate = nil;
		if(self != TrackTemplateDef(\CustomInstrumentTrack)) {
			self.parent = TrackTemplateDef(\CustomInstrumentTrack);
		};
		self.hasTrackTemplate = false;
	},

	clearAllTrackParts: { arg self;
		self.children.do { arg child;
			if(child.notNil) {
				child.clearPart;
			}
		}
	},


	///// properties

	isEmpty: { arg self;
		self.hasTrackTemplate.not;
		// in tracklist view, even tracks without children should appear
		//and: {
			//self.children.every({ arg x; x.isNil or: {x.isEmpty} });
		//}
	},

	trackKey: { arg self;
		if(self.parentTrack.notNil) {
			"%.%".format( self.parentTrack.key , self.index.asInteger).asSymbol;
		} {
			"%".format(self.key).asSymbol;
		}
	},

	name: { arg self;
		self.trackKey;
	},

	label: { arg self;
		if(self.trackTemplate.key == \CustomInstrumentTrack) {
			"T%".format(self.index); 
		} {
			self.trackTemplate.key
		}
	},

	outBus_: { arg self, outBus;
		self[\outBus] = outBus;
		self.existingChildren.do({ arg child;
			child.outBus = outBus
		});
		self.changed(\outBus);
	},


	///// editor

	editTrackTemplate: { arg self;
		WindowDef(\CustomInstrumentTrack_TemplateEditor).front(self)
	},
	editInstrument: { arg self;
		var te = self.trackEditor;
		if(te.notNil) {
			te.front(self);
		} {
			Log(\Param).info("No GUI (self.trackEditor) for %".format(self));
		};
	},


	/////// save/load

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

	refCompileString: { arg self;
		if(self.parentTrack.notNil) {
			"%.childAt(%)".format(self.parentTrack.refCompileString, self.index.asCompileString);
		} {
			"%(%)".format(self.class.asString, self.key.asCompileString);
		};
	},


	savePresetCompileString: { arg self, path, onDoneAction;
		// path should be a file
		if(self.isEmpty.not) {
			var file;
			//[path, self.presetCompileStringSavePath].debug("InstrumentTrack.savePresetCompileString");
			path = path ? self.presetCompileStringSavePath;
			//path.debug("save path");
			PlayerWrapper_Base.savePresetCompileStringHelper(path, onDoneAction, self.refCompileString, self.presetCompileString, false);

			self.existingChildren.do({ arg track;
				track.savePresetCompileString;
			})
		}
	},

	presetCompileStringSavePath: { arg self;
		if(self.parentTrack.dataPath.notNil) {
			self.parentTrack.dataPath +/+ "TrackDef_%.%.scd".format(self.parentTrack.key, self.index);
		}
	},

	loadPresetCompileString: { arg self;
		FileSystemProject.load(self.presetCompileStringSavePath, silent:true);
		32.do({ arg idx;
			self.childAt(idx).loadPresetCompileString;
		});
	},

	/////// mixer

	isMixerEnabled: false,

	isMixerEnabled_: { arg self, val;
		self[\isMixerEnabled] = val;
		if(val == true) {
			if(self.parentTrack.mixer.notNil) {
				self.parentTrack.mixer.tracks[self.index]
			} {
				if(self.mixer_obj.isNil) {
					var mix;
					ParamProto.init;
					self.mixer_obj = ProtoClassDef(\TrackMixerDef).new(self.parentTrack.key+++"."+++self.index);
					self.mixer_obj.define_mixer;

					mix = self.mixer_obj;
					mix.stages[\postdelay] = mix.stages.postfx+1;
					mix.proxy.put(mix.stages.postdelay, \filter -> { arg in, postdelay=0;
						DelayC.ar(in, 0.1, postdelay);
					});

					self.init_mixer_busses;
				};
				self.outBus = self.mixer_obj.inbus;
			}
		} {
			self.outBus = 0;
		};
		self.changed(\mixer);
	},


	mixer: { arg self;
		if(self.isMixerEnabled) {
			self.mixer_obj;
		} {
			nil
		}
	},
));

TrackTemplateDef(\CustomInstrumentTrackPart, (
	parent: TrackTemplateDef(\playerwrapper),
	eventType: \instrumenttrackpart,

	new: { arg self, parent, index;
		self = ProtoClass(( parent: self ));

		self.parentTrack = {parent};
		self.index = index.asInteger;
		self[\storeOn] = { arg iself, str; str << iself.refCompileString };
		self;
	},

	initTrack: { arg self; 
		self.parentTrack.initChild(self);
	},

	//////// properties

	grid: { arg self;
		self.parentTrack.parentTrack;
	},

	name: { arg self;
		self.trackKey;
	},

	isEmpty: { arg self;
		self.score.isNil and: {
			self.proxy.isNil or: { self.proxy.target == nil };
		}
	},

	trackKey: { arg self;
		"%.%".format(self.parentTrack.trackKey, self.index.asInteger).asSymbol;
	},

	outBus: { arg self;
		if(self.proxy.notNil) {
			self.proxy.outBus;
		} {
			self.parentTrack.outBus
		}
	},

	outBus_: { arg self, val;
		if(val.isNil) {
			val = self.parentTrack.outBus ? 0;
		};
		if(self.proxy.notNil) {
			self.proxy.outBus = val;
		}
	},

	//////// editor

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

	editor: { arg self;
		self.parentTrack.editor
	},

	asPreview: { arg self;
		BasicButton.new.string_("No preview for %".format(self.parentTrack.trackTemplate.key)).action_({
			self.edit;
		})
	},

	asView: { arg self ...args;
		self.parentTrack.editor.asView(self, *args);
	},

	selectSourceDialog: { arg self;
		// in playergrid, this open a dialog to select the player 
		// edit is used to edit the player
		// in tracklist, it is used to edit the instrument
		self.parentTrack.editInstrument;
	},

	//////// score

	makeScore: { arg self;
		Log(\Param).debug("no makeScore method implemented in %", self);
		nil;
	},

	score_: { arg self, val;
		self[\score] = val;
		Log(\Param).debug("setting score to: %", self.score.asCompileString);
		self.grid.changed(\tracklist);
	},

	// source is the player in playerwrapper track, but in tracklist we use score
	source_: { arg self, val;
		self.proxy = PlayerWrapper(val);
		self.outBus = nil; // set to default
	},

	clearTrack: { arg self;
		self.clearPart;
		self.parentTrack.children[self.index] = nil; // erase from parent, force recreate with good template
		self.parentTrack.changed(\children);
		Log(\Param).debug("clearTrack: erased %", self.index);
	},

	clearPart: { arg self;
		self.score = nil;
		self.proxy = nil;
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

	//////// others

	asPatternEvent: { arg self;
		if(self.score !? self.score.timeline.notNil) {
			self.score.timeline.asPatternEvent;
		} {
			Event.silent(1) // TODO
		}
	},

	//////// save/load

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
		// i will remove it, unnecessary complication
		if(self.isEmpty) {
			nil
		} {
			var str = List[];

			//str.add("%.score = %;".format(self.refCompileString, self.score.asCompileString));
			str.add("\n\n%".format(self.scorePresetCompileString ?? { "" }));
			str.join($\n)
		}
	},
	refCompileString: { arg self;
		if(self.parentTrack.notNil) {
			if( self.parentTrack.parentTrack.notNil ) {
				"%.childAt(%, %)".format(self.parentTrack.parentTrack.refCompileString, self.parentTrack.index.asCompileString, self.index.asCompileString);
			} {
				"%.childAt(%)".format(self.parentTrack.refCompileString, self.index.asCompileString);
			}
		} {
			"%(%)".format(self.class.asString, self.key.asCompileString);
		}
	},

	scorePresetCompileString: { arg self;
		if(self.score.notNil) {

			"%.score = %;".format(self.refCompileString, self.score.presetCompileString)
		} {
			""
		}
	},

	scorePresetCompileStringSavePath: { arg self, scoretype="NoteTimeline";
		var grid = self.grid;
		if(grid.dataPath.notNil) {
			grid.dataPath +/+ "%_%.%.%.scd".format(scoretype, grid.key, self.parentTrack.index, self.index);
		}
	},

	presetCompileStringSavePath: { arg self;
		self.scorePresetCompileStringSavePath("TrackDef");
	},


	presetCompileStringSavePath_: { arg track, val;
		track[\presetCompileStringSavePath] = val;
	},
));

// TODO: should be named CustomTrackListSection
TrackTemplateDef(\CustomTrackListPart, (
	parent: TrackTemplateDef(\lineplayer),
	eventType: \tracklistpart,
	
	new: { arg self, parent, idx; 
		self = ProtoClass((parent: self));
	
		self.parentTrack = { parent };
		self.index = idx; // line index
	
		self;
	},
	trackKey: { arg self;
		"%.part%".format(self.parentTrack.key, self.index.asInteger).asSymbol;
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

	clipboard: { arg self;
		ParamViewToolBox.clipboard.trackDef
	},
	clipboard_: { arg self, val;
		ParamViewToolBox.clipboard.trackDef = val;
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
				//Log(\Param).debug("specialviews model_: %", track);
				if(track.notNil) {
					recorderView = track.recorderView;
					if(recorderView.notNil) {
						//Log(\Param).debug("specialviews recorderView: %", recorderView);
						view.layout = recorderView;
					}
				}
			}).maxWidth_(self.maxColumnWidth).fixedHeight_(30).background_(Color.gray);
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
							//[ self.trackFaders[x], track, track.mixer, track.isMixerEnabled, x ].debug("set trackFaders model: view, track, mixer, x");
							self.trackFaders[x].model = track.mixer;
							//self.trackHeaders[x].visible = (track.parentTrack.showTrackHeaders == true);
							//self.trackFaders[x].visible = ( track.isMixerEnabled == true );
						}, false); // if true, show ghost mixer model bug
					} {
						//x.debug("set trackHeaders model volume!!!!!");
						self.trackHeaders[x].model = PlayerWrapper(self.maintrack);
						self.trackFaders[x].model = ProtoClassDef(\TrackMixerDef_volume);
						//self.trackFaders[x].slider.mapParam(Param(track, \volume));
						//self.trackFaders[x].textfield.mapParam(Param(track, \volume));
						//Param(track, \volume).debug("volume");
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
			//debug("map players");
			playerviews.do({ arg track, x;
				track.do { arg child, y;
					//[track, x, child, y].debug("set playerview model: track child");
					if(x == 8) {
						child.model = maintrack.linePlayerAt(y+maintrack.gridOffset.y);
					} {
						child.model = maintrack.childAtOffset(Point(x,y));
					}
				};
			});
			specialviews.do({ arg child, x;
				//[child, x].debug("set specialviews model: track idx");
				if(x == 8) {
					child.model = nil
				} {
					child.model = maintrack.childAtOffset(x);
				}
			});
			mixerviews.do({ arg child, x;
				//[child, x].debug("set mixerview model: child");
				if(child.notNil) {
					if(x == 8) {
						child.model = Server.default.volume;
					} {
						child.model = maintrack.childAtOffset(x);
					}
				}
			});

			if(maintrack.showMixerView == true) {
				//Log(\Param).debug("showMixerView enable: %", maintrack.showMixerView);
				mixerviews.do({ arg th; th.visible = true })
			} {
				//Log(\Param).debug("showMixerView disable: %, %", maintrack.showMixerView, mixerviews);
				mixerviews.do({ arg th; th.visible = false })
			};

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

						//[track.first.view, track.first.model, track.first.model.parentTrack].debug("make_view: follower");
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
			//[me, key.asCompileString, modifiers, unicode, keycode].debug("grid keyDownAction");
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
				//Log(\Param).debug("grid keydown: idx %, x %, y %", idx, posx, posy);
				if(posx == 8) {
					PlayerWrapper(maintrack.linePlayerAt(posy+maintrack.gridOffset.y)).togglePlay;
				} {
					PlayerWrapper(maintrack.childAtOffset(Point(posx,posy))).togglePlay;
				}
			}
		});
		
	},

	showGeneralOverlayMenu: { arg self, view, x, y;
		Menu(
			MenuAction("Save", {
				self.maintrack.savePresetCompileStringDialog;
			}),
			MenuAction("Load", {
				self.maintrack.loadPresetCompileStringDialog;
			}),
			MenuAction.separator,
			Param(Message(self.maintrack), \showMixerView, ParamBoolSpec()).asMenuAction,
			Param(Message(self.maintrack), \enableAutoSetOutbus, ParamBoolSpec()).asMenuAction,
			Menu(
				* WindowDef(\TrackMixerDef_advanced).proto.displayOptions.collect { arg item, idx;
					var curval = self.trackFaders.first.proto.perform(item);
					MenuAction(item, {
						self.trackFaders.do { arg mixerview, idx;
							mixerview.proto.perform(item.asSetter, curval.not)
						};
					}).checked_(curval)
				}
				++ [
					Param(Message(self.maintrack), \showTrackHeaders, ParamBoolSpec()).asMenuAction(),
					Param(Message(self.maintrack), \showRecorderView, ParamBoolSpec()).asMenuAction(),
				]
			).title_("Mixer layout"),
			Param(
				Message(self.maintrack),
				\controller, 
				ControllerDef.getTagSpec(\launchpad)
			).asMenu( "Grid controller" ),
		).front
		
	},

	showGeneralOverlayMenu_old: { arg self, view, x, y;
		WindowDef(\OverlayMenu).front(view, x, y, { arg def;
			VLayout (
				HLayout(
					Param(Message(self.maintrack), \showMixerView, ParamBoolSpec()).asButton.addAction({ self.maintrack.changed(\children) }),
				),
				HLayout(
					BasicButton.new.string_("Save").action_({
						self.maintrack.savePresetCompileStringDialog;
					}),
					BasicButton.new.string_("Load").action_({
						self.maintrack.loadPresetCompileStringDialog;
					}),
				),
				HLayout(
					StaticText.new.string_("controller:"),
					Param(
						Message(self.maintrack),
						\controller, 
						ControllerDef.getTagSpec(\launchpad)
					).asPopUpMenu.allowsReselection_(true),
				),
			)
		})
		
	},

	makeToolBar: { arg self;
		HLayout (
			BasicButton.new.string_("^").mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				var mult = 1;
				if(modifiers.isShift or: {buttonNumber == 1}) {
					mult = 8;
				};
				self.maintrack.gridOffset = self.maintrack.gridOffset + Point(0,-1*mult);
			}),
			BasicButton.new.string_("v").mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				var mult = 1;
				if(modifiers.isShift or: {buttonNumber == 1}) {
					mult = 8;
				};
				self.maintrack.gridOffset = self.maintrack.gridOffset + Point(0,1*mult);
			}),
			BasicButton.new.string_("<").mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				var mult = 1;
				if(modifiers.isShift or: {buttonNumber == 1}) {
					mult = 8;
				};
				self.maintrack.gridOffset = self.maintrack.gridOffset + Point(-1*mult,0);
			}),
			BasicButton.new.string_(">").mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				var mult = 1;
				if(modifiers.isShift or: {buttonNumber == 1}) {
					mult = 8;
				};
				self.maintrack.gridOffset = self.maintrack.gridOffset + Point(1*mult,0);
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
			//mixerview.debug("created mixerview");
			mixerview.maxWidth_(200);
			self.trackFaders = self.trackFaders ?? { nil ! self.trackCount };
			//if(trackidx == 0) { // debug
				//~dbfirstmix = mixerview;
			//};
			self.trackFaders[trackidx] = mixerview;
			mixerview;
		};
	},

	makeTrackHeader: { arg self, trackidx;
		var player, playerview;
		if(trackidx != ( self.trackCount - 1 )) { // if not last column
			var child;
			var maintrack = self.maintrack;
			child = maintrack.childAtOffset(trackidx);
			//[child, child.source, trackidx].debug("showTrackHeaders: child");
			player = PlayerWrapperGridCellView(child);
			playerview = player.asView;
			player.rightClickEditorEnabled = true;
			playerview.labelView.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
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
			//"volume!!!".debug;
			playerview;
			//nil;
		}
	},

	makeOverlayMenu: { arg self, view, x, y, amodel;
		var model = amodel;
		var track = model.parentTrack;
		Menu(
			* [
				if(model.isLinePlayer == true) {
					Menu(
						CustomViewAction(
							Param( Message(model), \label, ParamStringSpec()).asTextField.minWidth_(200),
						)
					).title_("Section label")
				} {
					[
						if(track.isEmpty.not) {
							[
								Menu(
									CustomViewAction(
										Param( Message(model), \label, ParamStringSpec()).asTextField.minWidth_(200),
									)
								).title_("Cell label"),
								if(model.isEmpty) {
									[
										MenuAction("Create cell", {
											[model, model[\makeScore].asCompileString].debug("model");
											model.makeScore;
										}),
										MenuAction("Create and edit cell", {
											//[model].debug("model");
											model.makeScore;
											model.edit;
										}),
										MenuAction("Paste cell", {
											if(self.clipboard.notNil) {
												model.parentTrack.children[model.index] = self.clipboard.clone(model.parentTrack, model.index);
												model.parentTrack.changed(\children);
											};
										}),
									]
								} {
									[
										MenuAction("Edit cell", {
											model.edit;
										}),
										MenuAction("Copy cell", {
											self.clipboard = model;
										}),
										MenuAction.separator,
										MenuAction("Erase cell", {
											model.clearTrack;
										}),
									]
								},
								MenuAction.separator,
								Menu(
									CustomViewAction(
										Param( Message(track), \label, ParamStringSpec()).asTextField.minWidth_(200),
									)
								).title_("Track label"),
								MenuAction("Edit track instrument", {
									model.parentTrack.editInstrument;
								}),
								MenuAction("Erase track", {
									model.parentTrack.clearTrack;
								}),
							]
						},
						Param( Message(track), \trackTemplate, TagSpecDef(\CustomTrackTemplate) ).asMenu("Choose track template"),
						MenuAction.separator,
						Param(Message(model.parentTrack), \isMixerEnabled, ParamBoolSpec()).asMenuAction("Enable mixer"),
					]
				}
			].flat.select(_.notNil) 
		).front;
	},

	makeOverlayMenu_old: { arg self, view, x, y, amodel;
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
											//[model].debug("model");
											model.makeScore;
											model.edit;
											def.closeWindow;
										}),

										BasicButton.new.string_("Paste cell").action_({
											if(self.clipboard.notNil) {
												model.parentTrack.children[model.index] = self.clipboard.clone(model.parentTrack, model.index);
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
											self.clipboard = model;
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
								//[model].debug("model");
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


(
WindowDef(\CustomTrackList, (
	asView: { arg self, wdef, model;
		self.mainView = View.new;
		self.model = model;
		self.mainView.layout = VLayout(
			self.makeToolbar,
			self.makeTrackList,
		);
		
		self.mainView;
	},

	makeToolbar: { arg self;
		var model = self.model;
		var playButton;
		playButton = PlayerWrapperView.new;
		self.mainView.followChange(model, \selectedPart, {
			playButton.model = model.linePlayerAt(model.selectedPart);
			//if(model.isPlaying) {
				//model.linePlayerAt(model.selectedPart).play;
			//};
		});

		HLayout (
			playButton.view,
			BasicButton.new.string_("Add").action_({
				WindowDef(\CustomTrackList_NewInstrument).front({ arg trackTemplate, label;
					//Log(\Param).debug("OK! template %, label %", trackTemplate, label);
					model.addTrack(trackTemplate, label);
				})
			}),
			HLayout (
				StaticText.new.string_("Part:"),
				Param(Message(model), \selectedPart, ControlSpec(0,16,\lin,1)).asNumberBox,
			),
			HLayout (
				StaticText.new.string_("Len:"),
				Param(Message(model), \areasizex, ControlSpec(1,128,\lin)).asTextField,
			),
			BasicButton.new.string_("Mixer").action_({
				WindowDef(( \TrackListMixer_++model.key ).asSymbol, WindowDef(\TrackListMixer)).front(model);
			}),
			BasicButton.new.string_("Timeline").action_({
				TrackTimeline(model.key, model).edit;
			}),
			BasicButton.new.string_("Grid").action_({
				model.editGrid;
			}),
			BasicButton.new.string_("Properties").action_({
				model.editProperties;
			}),
		)
	},

	makeTrackList: { arg self;
		var view = View.new;
		var viewSelector = ProtoTemplateDef(\ViewSelector).new(0);
		var oldselidx;
		viewSelector.selected_color = ParamViewToolBox.color_pale;
		viewSelector.deselected_color = Color.clear;
		self.trackButtonSelector = { viewSelector };
		view.followChange(self.model, \tracklist, {
			view.removeAll;
			oldselidx = viewSelector.selected_index;
			viewSelector.views = [];
			view.layout = VLayout (*
				self.model.existingChildren.collect { arg child, idx;
					try {
						self.makeTrackView(child)
					} { arg error;
						Log(\Param).error("ERROR: in WindowDef(\CustomTrackList).makeTrackView idx=%".format(idx));
						error.reportError;
						//error.throw;
						BasicButton.new.string_("error");
					}
				}.as(Array) ++ [nil];
			);
			viewSelector.select_item(oldselidx)
		});
		view;
	},

	makeTrackView: { arg self, child;
		var rowHeight = 80;
		var rowHeight_inset = rowHeight - 5;
		var model = self.model;
		var idx = model.selectedPart.asInteger;
		var cell = child.childAt(idx);
		var linename = "%.%".format(model.key, idx).asSymbol;
		var name = "%.%.%".format(model.key, childidx, idx).asSymbol;
		var playbut = PlayerWrapper(cell).label_("").asView;
		var lay;
		var chanview = View.new;
		var variableView;
		var viewSelector = self.trackButtonSelector;
		var childidx = child.index;

		variableView = View.new.followChange(child, \mixer, { arg view;
			view.removeAll;
			//Log(\Param).debug("mixer variableView: %, %, %", child.label, child.isMixerEnabled, child.mixer);
			if(child.isMixerEnabled) {
				view.layout = StackLayout(
					child.mixer.asParam(\postfader).asSlider.orientation_(\horizontal).background_(Color.clear),
					CompactServerMeterView(nil, 0,2, child.mixer.recbus).orientation_(\horizontal),
				).mode_(\stackAll);
			}
		});

		//playbut.debug("i");
		playbut.button.maxWidth_(30);
		//playbut.parentView.states = [
		//[""],
		//["", Color.black,ParamViewToolBox.color_ligth],
		//];
		//playbut.parentView.update;
		lay = HLayout (
			playbut,
			VLayout (
				BasicButton.new
				.string_("%: %".format(child.index, child.label))
				.action_({
					//Log(\Param).debug("edit: idx%, instr %", childidx, child.instrument.asCompileString);
					child.editInstrument;
				})
				.maxWidth_(200)
				.mouseDownAction_({ arg but, x, y, modifiers, buttonNumber, clickCount;
					//[but, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");

					if(buttonNumber == 1) { // if right-click

						Menu(
							CustomViewAction(
								View.new.layout_(HLayout (
									StaticText.new.string_("label:"),
									Param( Message(child), \label, ParamStringSpec()).asTextField(action:{ arg view;
										self.model.changed(\tracklist);

									}),
								)),
							),
							if(cell.isEmpty) {
								MenuAction("Create and edit score", {
									cell.makeScore;
									self.model.changed(\tracklist); // overkill refresh
									cell.edit;
								})
							} {
								MenuAction("Edit score", {
									cell.edit;
								})
							},
							MenuAction("Edit instrument", {
								child.editInstrument;
							}),
							Param(Message(child), \isMixerEnabled, ParamBoolSpec()).asMenuAction("Enable mixer"),
							MenuAction.separator,
							MenuAction("clear score", {
								cell.clearPart;
							}).enabled_(cell.isEmpty.not),
							MenuAction("remove track", {
								model.removeTrack(childidx);
							}).enabled_(child.isEmpty.not)
						).front;
						//WindowDef(\OverlayMenu).front(but, x, y, { arg def;
							//VLayout (
								//HLayout (
									//StaticText.new.string_("label:"),
									//Param( Message(child), \label, ParamStringSpec()).asTextField,
								//),
								//BasicButton.new.string_("Edit instrument").action_({
									//child.editInstrument;
									//def.closeWindow;
								//}),
								//BasicButton.new.string_("Edit track part").action_({
									//child.edit;
									//def.closeWindow;
								//}),
								//BasicButton.new.string_("Remove track").action_({
									//model.removeTrack(childidx);
									//def.closeWindow;
								//}),
								//Param(Message(child), \isMixerEnabled, ParamBoolSpec()).asButton("Enable mixer"),
							//)
						//})

					}
				})
				,
				HLayout (
					Param(
						Message(child),
						\outBus, 
						TagSpec({[\default -> nil, \0->0] ++ TagSpecDef(\BusDef_object).list})
					).asPopUpMenu.maxWidth_(100),
					Param(
						Message(cell),
						\outBus, 
						TagSpec({[\default -> nil, \0->0] ++ TagSpecDef(\BusDef_object).list})
					).asPopUpMenu.maxWidth_(100),
					nil,
				),
				variableView,
				nil
			),
			[{
				if(cell.isEmpty) {
					BasicButton.new.string_("make score").action_({
						cell.makeScore;
						model.changed(\tracklist);
					}).fixedHeight_(rowHeight_inset)
				} {
					var preview;
					//var preview = cell.score.timeline.asPreview.fixedHeight_(rowHeight_inset);
					//Log(\Param).debug("InstrumentTrackPart: cell %", cell);
					preview = ( cell.asPreview ?? { View.new } ).fixedHeight_(rowHeight_inset);
					//timelinePreviewList.add(preview);
					//preview.timeline.areasize.x = model.areasizex ?? { preview.timeline.areasize.x };
					//preview.timeline.changed(\areasize);
					preview;
				}

			}.value, stretch:100],
		);
		chanview.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			//[view, x, y, modifiers, buttonNumber, clickCount, childidx].debug("mouseDownAction");
			//view.background = ParamViewToolBox.color_dark;
			//view.background = Color.grey;
			viewSelector.select_item(childidx);
			if(FileSystemProject.current.notNil) {

				FileSystemProject.current.tracklist_selected_track = [\TrackListPart, linename -> model.linePlayerAt(idx)];
				FileSystemProject.current.changed(\tracklist_selected_track);
				FileSystemProject.current.tracklist_selected_track = [\InstrumentTrackPart, name -> cell];
				FileSystemProject.current.changed(\tracklist_selected_track);
				//FileSystemProject.current.tracklist_selected_track.debug("sel track");
			}

		});
		lay.spacing_(3);
		lay.margins_(0);
		chanview.fixedHeight_(rowHeight);
		chanview.layout_(lay);
		viewSelector.add_view(chanview);
		chanview;
	},

));

WindowDef(\CustomTrackList_NewInstrument, { arg def, callback;
	var default;	
	var data = ProtoClass();
	var tfield;
	VLayout (
		HLayout (
			StaticText.new.string_("label:"),
			tfield = Param( Message(data), \label, ParamStringSpec()).asTextField,
		),
		// without valueAction, data.trackTemplate is nil if user click ok directly
		Param( Message(data), \trackTemplate, TagSpecDef(\CustomTrackTemplate) ).asPopUpMenu.valueAction_(0),
		nil,
		HLayout (

			BasicButton.new.string_("OK").action_({
				//data.asCompileString.debug("data");
				callback.(data.trackTemplate, data.label ?? {
					var val = tfield.value;
					if(val != "") {
						val
					} {
						nil
					};
				});
				def.closeWindow;
			}),
			BasicButton.new.string_("Cancel").action_({
				def.closeWindow;
			}),
		),
	)
});
);

(
WindowDef(\TrackListMixer, { arg def, tracklist;
	var mixers;
	var mixerTemplate = ProtoClass((
		sendCount: 8,
		nullbuss: BusDef(\null, \audio, 2),
	));
	mixerTemplate.sendKnobCount.do { arg idx;
		var key = ( \sendbus ++ idx ).asSymbol;
		mixerTemplate[key] = { arg self; BusDef(key, \audio, 2) }
	};
	mixers = tracklist.existingChildren.collect { arg track, idx;
		if(track.isMixerEnabled == true) {
			var mixer = track.mixer;
			var boxview = View.new;
			var delayview;
			var mixerview;
			boxview.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
				if(buttonNumber == 1) {
					//WindowDef(\SimpleMixerOverlayMenu).front(simpleMixer, boxview, x, y);
					WindowDef(\TrackListMixerStrip_OverlayMenu).front(mixer, mixerTemplate, view, x, y)
				};
			});
			delayview = TextField.new;
			delayview.mapParam( Param(mixer.proxy, \postdelay, ControlSpec(0,0.1,\lin)) );
			boxview.layout = VLayout (
				PlayerWrapper(mixer.proxy)
				.label_("%: %".format(track.index, mixer.name ?? mixer.key))
				.asView,
				mixerview = WindowDef(\TrackListMixerStrip).asView(mixer, mixerTemplate),
				HLayout(StaticText.new.string_("postdelay:"), delayview),
				Param(Message(mixer), \outbus,TagSpecDef(\BusDef)).asPopUpMenu.minWidth_(60).addAction({ 
					mixer.play;
					"kjkj".postln
				}),
			);
			boxview.background = Color.gray;
			mixerview.slider.minWidth_(10);
			boxview.maxWidth_(260);
			boxview.addUniqueMethod(\model_, { arg me, val;
				mixerview.model = val;
			});
			boxview;
		}
	}.select(_.notNil).as(Array);
	//def.windowName = simpleMixer.key ? "simpleMixer";

	HLayout(* mixers);
});


WindowDef(\TrackListMixerStrip, { arg def, mixer, mixerTemplate;
		var sendKnobCount = 8;
		var param;
		var sends = [], allsends = [];
		var layout;
		var slider, knobs = List.new, textfield;
		var stack;
		var meterin = SimpleServerMeterView(nil, 0,2, mixer.inbus);
		var meterout = CompactServerMeterView(nil, 0,2, mixer.recbus);
		meterout.ticksView.minWidth_(6);
		slider = Slider.new.orientation_(\vertical).background_(Color.clear);


		stack = StackLayout(
			slider, 
			meterout.view,
			// FIXME: no way to make ticks less wide, so with both in and out displayed, meter is too small
			//View.new.layout_(HLayout (
				//meterin.view,
				//meterout.view,
			//).spacing_(0).margins_(0))
		).mode_(\stackAll);
		layout = VLayout(
			HLayout(
				VLayout (
					//slider,
					stack,
					textfield = TextField.new,
				),
				VLayout(*
					knobs = sendKnobCount.collect({ 
						Knob.new;
					})
				)
			)
		);
		layout.addUniqueMethod(\model_, { arg me, mixer;
			if(mixer.isKindOf(Volume)) {
				//"volume".debug;
				param = Param(mixer, \volume);
				sends = mixerTemplate.sendCount.collect({ arg x; x -> nil });
			} {
				//"mixer".debug;
				param = mixer.asParam(\postfader);
				allsends = mixerTemplate.sendCount.collect({ arg x; x -> mixer.asParam(\send+++x) });
				sends = allsends.select{ arg assoidx;
					var idx = assoidx.key;
					var bus = mixerTemplate[\sendbus +++ idx].value(mixerTemplate);
					bus != mixerTemplate.nullbus
				};
			};
			//[slider, param].debug("slider, param: what ?");
			slider.mapParam(param);
			textfield.mapParam(param);
			knobs.do({ arg k, idx; 
				var send = sends[idx] ?? { allsends[idx] }; 
				k.mapParam(send.value); 
				k.toolTip = "%: %".format(send.key, mixerTemplate[\sendbus +++ send.key].value(mixerTemplate));
			})
		});
		if(mixer.notNil) {
			layout.model = mixer;
		};
		layout.addUniqueMethod(\slider, { slider });
		layout.addUniqueMethod(\textfield, { textfield });
		layout.addUniqueMethod(\knobs, { knobs });
		layout;
});

WindowDef(\TrackListMixerStrip_OverlayMenu, { arg def, mixer, mixerTemplate, view, x=600, y=600;
	var inview, layout;
	var sends;
	//[x, y].debug("xy");
	def.windowDo { arg win;
		var ab = view !? {view.absoluteBounds} ? Rect(0,0,600,600);
		win.bounds = Rect(x+ab.origin.x, Window.screenBounds.height - ab.top - y, 300,100);
		win.endFrontAction = { win.close };
	};
	inview = View.new;

	sends = mixerTemplate.sendCount.collect({ arg idx;
		HLayout(
			StaticText.new.string_("send %".format(idx)),
			Param(mixer.proxy, "%%".format(\sendbus, idx).asSymbol, TagSpecDef(\BusDef_object)).asPopUpMenu,
		)
	});

	layout = VLayout (
		//PlayerWrapper(mixerTemplate).asView,
		//HLayout(
			//StaticText.new.string_("Track count:"),
			//Param(Message(mixerTemplate), \trackCount, ControlSpec(1,16,\lin,1)).asNumberBox,
		//),
		WindowDef(\TrackMixerDef_fxlist).asView(mixer),
		VLayout(
			*sends
		),
		nil
	);
	//def.windowDo { arg win;
		//win.setInnerExtent(view.bounds.extent.min(20));
	//};
	inview.layout_(layout);
	
}).border_(false);
);

(
WindowDef(\PdefInstrumentEditor, { arg def, instr;
	var target = instr.source;
	var pwrapper = PlayerWrapper(target);
	var paramView = View.new;
	paramView.followChange(instr, \source, {
		pwrapper.target = target;
	});
	paramView.followChange(instr, \playerSynthDef, {
		//Log(\Param).debug("paramView: followChange playerSynthDef");
		paramView.removeAll;
		paramView.layout = ParamGroupLayout.two_panes(target.asParamGroup(nil, false, [\gate, \doneAction]));
	});
	VLayout(
		HLayout (
			pwrapper.asView,
			Param(Message(instr), \playerSynthDef, TagSpecDef(\SynthDef_keys)).asPopUpMenu,
			if(target.getHalo(\edit).notNil) {
				BasicButton.new.string_("Special edit").action_({
					target.getHalo(\edit).value(target);
				})
			}
		),
		paramView,
	);
});
);

////////////////////
///// custom tracks


//////// PlayerWrapper

(
TrackTemplateDef(\PlayerWrapperTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\PlayerWrapperTrackPart) },
	editInstrument: { arg self;
		Log(\Param).debug("No GUI for PlayerWrapperTrack");
	},
	makeScore: { arg self;
		//self.isEmpty = false;
	},
));
TrackTemplateDef(\PlayerWrapperTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	selectSourceDialog: { arg self;
		TrackTemplateDef(\playerwrapper)[\selectSourceDialog].value(self);
	},

	asPreview: { arg self;
		StaticText.new.string_(self.proxy.target.asCompileString).mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
			if(buttonNumber == 0) {
				self.selectSourceDialog;
			} {
				self.edit;
			};
		})
		
	},

	makeScore: { arg self;
		self.selectSourceDialog;
		
	},

));

TagSpecDef(\CustomTrackTemplate).addUnique(\PlayerWrapperTrack -> TrackTemplateDef(\PlayerWrapperTrack));
);



//////// Pbindef
(
TrackTemplateDef(\PbindefTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\PbindefTrackPart) },
	makeScore: { arg self;
		//self.isEmpty = false;
	},
));
TrackTemplateDef(\PbindefTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	makeScore: { arg self;
		self.source = Pbindef(self.trackKey, \instrument, \default);
		//self.proxy.debug("makeScore proxy end");
	},
	selectSourceDialog: { arg self;
		TrackTemplateDef(\playerwrapper)[\selectSourceDialog].value(self);
	},

));

TagSpecDef(\CustomTrackTemplate).addUnique(\PbindefTrack -> TrackTemplateDef(\PbindefTrack));
);


//////// NoteTimeline

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
			Param(Message(self), \recordArmed, ParamBoolSpec()).asButton("●").maxWidth_(20),
			Param(Message(self), \inputController, ControllerDef.getTagSpec(\piano)).asPopUpMenu.minWidth_(5),
		).margins_(0).spacing_(0)
	},

	scorePresetCompileString: { arg self;
		var str;
		str = List.new;
		str.add( "%.source = %;".format(self.refCompileString, self.source.asCompileString));
		str.add( "%.playerSynthDef = %;".format(self.refCompileString, self.playerSynthDef.asCompileString));
		str.add( PlayerWrapper(self.source).presetCompileString );
		str.join($\n);
	},

	playerSynthDef: \SampleTimeline_player,

	playerSynthDef_: { arg self, instr;
		// TagSpecDef(\SynthDef) values are SynthDesc, not SynthDef key
		//Log(\Param).debug("TrackInstrument_NoteTimelineTrack set playerSynthDef %", instr);
		self[\playerSynthDef] = instr;
		Pbindef(self.source.key, \instrument, instr);
		self.source.addHalo(\instrument, instr);
		self.changed(\playerSynthDef);
	},
	makeScore: { arg self;
		self[\source] = Pdef("%.%.instr".format(self.key, self.index).asSymbol, Pbind());
		//self.isEmpty = false;
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

	outBus_: { arg self, val;
		if(self.score.notNil) {
			self.score.outBus = val;
		};
	},

	outBus: { arg self;
		if(self.score.notNil) {
			self.score.outBus;
		} {
			nil
		}
	},

	asPreview: { arg self;
		var tlpreview = self.score.asPreview;
		var model = self.parentTrack.parentTrack;
		tlpreview.timeline.areasize.x = model.areasizex ?? { tlpreview.timeline.areasize.x };
		tlpreview.timeline.changed(\areasize);
		tlpreview;
	},

	scorePresetCompileString: { arg self;
		var str;
		str = List.new;
		str.add( "%.score = %;".format(self.refCompileString, self.score.refCompileString));
		str.add( self.score.presetCompileString );
		str.join($\n);
	},

	score_: { arg self, score;
		self[\score] = score;
		self.score.controller = self.parentTrack.inputController;
		self.score.outBus = self.parentTrack.outBus; // does it override when loading ?
		self.proxy = PlayerWrapper(self.score);
		//self.proxy.debug("makeScore proxy end");
	},

	makeScore: { arg self;
		//self.proxy.debug("makeScore proxy start");
		self.score = NoteTimeline(self.name+++\score, self.parentTrack.source);
	}
));

TagSpecDef(\CustomTrackTemplate).addUnique(\NoteTimelineTrack -> TrackTemplateDef(\NoteTimelineTrack));
);

//////// SampleTimeline
(
TrackTemplateDef(\SampleTimelineTrack, (
	parent: TrackTemplateDef(\NoteTimelineTrack),
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
		});
	},

	recorderView: { arg self;
		HLayout (
			Param(Message(self), \recordArmed, ParamBoolSpec()).asButton("●").maxWidth_(20),
			Param(Message(self), \recBus, ParamAudioBusSpec()).asPopUpMenu.minWidth_(5),
		).margins_(0).spacing_(0)
	},

	makeScore: { arg self;
		//self[\source] = Pdef("%.%.instr".format(self.key, self.index).asSymbol, Pbind());
		self.isEmpty = false;
	},
));

TrackTemplateDef(\SampleTimelineTrackPart, (
	parent: TrackTemplateDef(\NoteTimelineTrackPart),

	cloneScore: { arg self;
		var newscore;
		newscore = SampleTimeline(self.name+++\score);
		newscore.eventList = self.score.eventList.clone;
		newscore.buffer = self.score.buffer;
		newscore.outBus = self.parentTrack.outBus;
		newscore.recorder.recBus = self[\score].recorder.recBus;
		newscore;
	},

	score_: { arg self, score;
		self[\score] = score;
		self.score.outBus = self.parentTrack.outBus; // does it override when loading ?
		self.score.recorder.recBus = self.parentTrack.recBus ?? { self[\score].recorder.recBus  };
		self.proxy = PlayerWrapper(self.score);
		//self.proxy.debug("makeScore proxy end");
	},


	makeScore: { arg self;
		self.score = SampleTimeline(self.name+++\score);
	},

	scorePresetCompileString: { arg self;
		var str;
		str = List.new;
		str.add( "%.score = %;".format(self.refCompileString, self.score.refCompileString));
		str.add( self.score.presetCompileString );
		str.join($\n);
	},
));

TagSpecDef(\CustomTrackTemplate).addUnique(\SampleTimelineTrack -> TrackTemplateDef(\SampleTimelineTrack));
);

//////// ParamTimeline
(
TrackTemplateDef(\ParamTimelineTrack, (
	parent: TrackTemplateDef(\NoteTimelineTrack),
	childClass: { TrackTemplateDef(\ParamTimelineTrackPart) },

	asParamGroup: { arg self;
		self.source.asParamGroup;
	},

	scorePresetCompileString: { arg self;
		if(self.score.notNil) {
			self.score.presetCompileString;
			// todo
		} {
			""
		}
	},

	trackEditor: { arg self;
		//WindowDef(\PdefInstrumentEditor);
		WindowDef(\ParamTimelineTrackEditor, { arg def;
			HLayout (
				Param(Message(self),\targetParam,ParamNonFloatSpec()).asView,
				BasicButton.new.string_("Select param").action_({
					WindowDef(\ParamSelectDialog).front(nil, { arg param; 
						//param.debug("selected param");
						self.targetParam = param;
					});
				}),
			);
		});
	},

	recorderView: { arg self;
		HLayout (
			Param(Message(self), \recordArmed, ParamBoolSpec()).asButton("●").maxWidth_(20),
			Param(Message(self), \targetParam, ParamNonFloatSpec()).asPopUpMenu.minWidth_(5),
		).margins_(0).spacing_(0)
	},

	makeScore: { arg self;
		//self[\source] = Pdef("%.%.instr".format(self.key, self.index).asSymbol, Pbind());
		//self.isEmpty = false;
	},
));

TrackTemplateDef(\ParamTimelineTrackPart, (
	parent: TrackTemplateDef(\NoteTimelineTrackPart),

	//cloneScore: { arg self;
		//var newscore;
		//newscore = ParamTimeline(self.name+++\score, self.parentTrack.targetParam);
		//newscore.eventList = self.score.eventList.clone;
		//newscore.buffer = self.score.buffer;
		//newscore.outBus = self.parentTrack.outBus;
		//newscore.recorder.recBus = self[\score].recorder.recBus;
		//newscore;
	//},

	score_: { arg self, score;
		self[\score] = score;
		self.score.outBus = self.parentTrack.outBus; // does it override when loading ?
		self.proxy = PlayerWrapper(self.score);
		//self.proxy.debug("makeScore proxy end");
	},


	makeScore: { arg self;
		self.score = ParamTimeline(self.name+++\score, self.parentTrack.targetParam);
	},

	scorePresetCompileString: { arg self;
		var str;
		str = List.new;
		str.add( "%.score = %;".format(self.refCompileString, self.score.refCompileString));
		str.add( self.score.presetCompileString );
		str.join($\n);
	},
));

TagSpecDef(\CustomTrackTemplate).addUnique(\ParamTimelineTrack -> TrackTemplateDef(\ParamTimelineTrack));
);

//////// ClipTimeline
(
TrackTemplateDef(\ClipTimelineTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\ClipTimelineTrackPart) },

	asParamGroup: { arg self;
		self.source.asParamGroup;
	},
	trackEditor: { arg self;
		//WindowDef(\PdefInstrumentEditor);
	},


	recorderView: { arg self;
		HLayout (
			Param(Message(self), \recordArmed, ParamBoolSpec()).asButton("●").maxWidth_(20),
			Param(Message(self), \inputController, ControllerDef.getTagSpec(\piano)).asPopUpMenu.minWidth_(5),
		).margins_(0).spacing_(0)
	},

	scorePresetCompileString: { arg self;
		var str;
		str = List.new;
		//str.add( "%.source = %;".format(self.refCompileString, self.source.asCompileString));
		//str.add( PlayerWrapper(self.source).presetCompileString );
		str.join($\n);
	},

	makeScore: { arg self;
		//self[\source] = Pdef("%.%.instr".format(self.key, self.index).asSymbol, Pbind());
		//self.isEmpty = false;
	},
));
TrackTemplateDef(\ClipTimelineTrackPart, (
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
		newscore = ClipTimeline(self.name+++\score);
		newscore.eventList = self.score.eventList.clone;
		newscore.controller = self.parentTrack.inputController;
		newscore.outBus = self.parentTrack.outBus;
		newscore;
	},

	outBus_: { arg self, val;
		if(self.score.notNil) {
			self.score.outBus = val;
		}
	},

	outBus: { arg self;
		if(self.score.notNil) {
			self.score.outBus
		}
	},

	asPreview: { arg self;
		var tlpreview = self.score.asPreview;
		var model = self.parentTrack.parentTrack;
		tlpreview.timeline.areasize.x = model.areasizex ?? { tlpreview.timeline.areasize.x };
		tlpreview.timeline.changed(\areasize);
		tlpreview;
	},


	makeScore: { arg self;
		//self.proxy.debug("makeScore proxy start");
		self[\score] = ClipTimeline(self.name+++\score);
		self.score.controller = self.parentTrack.inputController;
		self.score.outBus = self.parentTrack.outBus;
		self.proxy = PlayerWrapper(self.score);
		//self.proxy.debug("makeScore proxy end");
	}
));

TagSpecDef(\CustomTrackTemplate).addUnique(\ClipTimelineTrack -> TrackTemplateDef(\ClipTimelineTrack));
);

//////// experimental sequencing

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
			//[self.base, child, child.score].debug("editor call scoreEditor");
			VLayout (
				if(child.score.notNil) {
					//WindowDef(\scoreEditor).asView(self.base, child, child.score);
					Param(child.score, \velamp -> \stepseq, \unipolar).asMultiSlider;
				}
				//Slider.new,
			)
		});
	},

	scorePresetCompileString: { arg self;
		var str;
		str = List.new;
		str.add( "%".format(self.base.asParamGroup.getSetCompileString("%.base".format(self.refCompileString))));
		str.join($\n);
	},

	makeScore: { arg self;
		//self.isEmpty = false;
	},
));
TrackTemplateDef(\SeqTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	outBus_: { arg self, val;
		if(self.scoreproxy.notNil) {
			self.scoreproxy.set(\out, val);
		};
	},

	outBus: { arg self;
		if(self.scoreproxy.notNil) {
			self.scoreproxy.get(\out);
		} {
			self.parentTrack.outBus
		}
	},
	asPreview: { arg self;
		var view = View.new;
		view.layout = WindowDef(self.parentTrack.name, { arg def, child;
			//[self.base, child, child.score].debug("editor call scoreEditor");
			VLayout (
				if(child.scoreproxy.notNil) {
					//WindowDef(\scoreEditor).asView(self.base, child, child.scoreproxy);
					Param(child.scoreproxy, \velamp -> \stepseq, \unipolar).asMultiSlider.mouseDownAction_({ 
						arg view, x, y, modifiers, buttonNumber, clickCount;
						//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
						if(buttonNumber == 1) { // right click
							self.edit;
							false;
						};
					});
				};
				//Slider.new,
			).spacing_(0).margins_(0)
		}).asView(self);
		view;
		//View.new.layout_(self.parentTrack.editor.asView(self))
	},

	score: { arg self;
		if(self.scoreproxy.notNil) {
			self.scoreproxy.source.at(\velamp).source.list
		};
	},

	score_: { arg self, list;
		if(self.scoreproxy.isNil) {
			self.makeScore;
		}; 
		self.scoreproxy.source.at(\velamp).source.list = list;
	},

	scorePresetCompileString: { arg self;
		var str;
		str = List.new;
		str.add( "%.score = %;".format(self.refCompileString, self.score.asCompileString));
		str.join($\n);
	},

	makeScore: { arg self;
		//self.proxy.debug("makeScore proxy start");
		self[\scoreproxy] = Pbindef(self.name+++\seq, \velamp, PstepSeq(0!8,inf));
		self.proxy = PlayerWrapper(Pdef(self.name+++\part,
			self.parentTrack.base <>
			self.scoreproxy
		));
		//self.proxy.debug("makeScore proxy end");
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
			//[self.base, child, child.score].debug("editor call scoreEditor");
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
		//self.isEmpty = false;
	},
));
TrackTemplateDef(\SeqCoinTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	makeScore: { arg self;
		//self.proxy.debug("makeScore proxy start");
		self[\score] = Pbindef(self.name+++\seq, \coin, PstepSeq(0!8,inf));
		self.proxy = PlayerWrapper(Pdef(self.name+++\part,
			self.parentTrack.base <>
			self.score
		));
		//self.proxy.debug("makeScore proxy");
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
			//[self.base, child, child.score].debug("editor call scoreEditor");
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
		//self.isEmpty = false;
	},
));
TrackTemplateDef(\AutoSeqTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	makeScore: { arg self;
		//self.proxy.debug("makeScore proxy start");
		self[\score] = Pbindef(self.name+++\seq, \isPbindef, true);
		self.parentTrack.seqpairs.do { arg pair, idx;
			self.score.source.set(pair.first, pair.last.copy)
		};
		self.proxy = PlayerWrapper(Pdef(self.name+++\part,
			self.parentTrack.postChain <>
			self.score <>
			self.parentTrack.preChain
		));
		//self.proxy.debug("makeScore proxy end");
	}
));

TagSpecDef(\CustomTrackTemplate).addUnique(\AutoSeqTrack -> TrackTemplateDef(\AutoSeqTrack));
);


//Spec.add(\degree, ControlSpec(0,14,\lin,1,0));
//Spec.add(\velamp, \unipolar);
//BufDef(\amen, "vipere/amenbreak.wav");

