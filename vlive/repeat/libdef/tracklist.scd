
//// DEPRECATED: we use CustomTrackList now

// END

(
ParamProto.init;
FileSystemProject.load("libdef/tracks.scd");
FileSystemProject.load("libdef/drumkit.scd");
FileSystemProject.load("libdef/synthplayrec.scd");
FileSystemProject.load("libdef/MainProject.scd");

TrackTemplateDef(\TrackList, (
	parent: TrackTemplateDef(\playergrid),

	eventType: \tracklist,
	childClass: { arg self;
		TrackTemplateDef(\InstrumentTrack);
	},
	lineClass: { TrackTemplateDef(\TrackListPart) },

	trackKey: { arg self;
		self.key;
	},

	selectedPart: 0,
	selectedPart_: { arg self, val;
		if(val != self[\selectedPart]) {
			self[\selectedPart] = val;
			self.changed(\selectedPart);
			self.changed(\tracklist);
		}
	},
	addTrack: { arg self, libId, label;
		var lastidx = -1;
		var trackidx;
		block  { arg break;
			self.children.do { arg child, childidx;
				lastidx = childidx;
				if(self.childAt(childidx).isEmpty) {
					Log(\Param).debug("found empty track: %", childidx);
					trackidx = childidx;
					break.value;
				}
			};
			Log(\Param).debug("grid.addTrack: no empty track found, use %", lastidx+1);
			trackidx = lastidx+1;
		};

		self.defineTrack(trackidx, libId, label)
	},

	defineTrack: { arg self, trackidx, libId, label;
		var trackkey;
		var newtrack = self.childAt(trackidx);
		TagSpecDef(\TrackList).addUnique(self.key -> self);
		newtrack.instrumentId = libId;
		newtrack.label = label ?? { newtrack.label };
		//trackkey = "%.%".format(self.key, newtrack.index).asSymbol;
		//newtrack.libId = libId;
		//newtrack.label = label ? ProtoDef(\GlobalLibrary).libIdToStrings(libId).join(" ");
		//newtrack.instrument = ProtoDef(\GlobalLibrary).libIdToTrackInstrument(libId, trackkey);
		//newtrack.instrument.makeSource(self, newtrack.index);
		//newtrack.outBus = 0;
		//TagSpecDef(\TrackList).addUnique(self.key -> self);
		//Log(\Param).debug("newtrack.instrument:%", newtrack.instrument);
		//self.changed(\tracklist);
		
	},

	removeTrack: { arg self, index;
		self.childAt(index).clearChannel;
		self.changed(\tracklist);
	},

	edit: { arg self;
		WindowDef(( \TrackList_++self.key ).asSymbol, WindowDef(\tracklist)).front(self);
	},

	savePresetCompileString: { arg self, path, onDoneAction;
		// currently, this require to give an absolute path to a directory that does not 
		//		exist and that will contains all the save files


		// path should be an absolute folder path
		// FIXME: giving path as argument is broken: self.dataPath is not defined
		var savefile;
		if(path.isNil and: {self.presetCompileStringSavePath.isNil}) {
			"savePresetCompileString: presetCompileStringSavePath is nil, can't save".error;
		} {
			//path = path ?? { (self.presetCompileStringSavePath +/+ "TrackDef_%.scd".format(self.key)) };
			path = path ? self.presetCompileStringSavePath;
			path.debug("TrackList.savePresetCompileString");
			savefile = path +/+ "TrackDef_%.scd".format(self.key);
			if(File.exists(path).not or: {self.loadedFromPath == path}) {
				File.mkdir(path);
				self.loadedFromPath = path;
				PlayerWrapper_Base.savePresetCompileStringHelper(savefile, onDoneAction, self.refCompileString, self.presetCompileString, false);
				File.mkdir(self.dataPath);
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

	isEmpty: { arg self;
		self.children.every(_.isEmpty);
	},

	refCompileString: { arg self;
		"TrackDef(%)".format(self.key.asCompileString);
	},

	presetCompileString: { arg self;
		"%\n".format([
			"TrackDef(%, %);".format(self.key.asCompileString, "TrackTemplateDef(\\TrackList)"),
			"TrackDef(%).presetCompileStringSavePath = PathName(thisProcess.nowExecutingPath).pathOnly;".format(self.key.asCompileString),
			"TrackDef(%).loadPresetCompileString;".format(self.key.asCompileString),
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
		val.debug("===== setting resources save path. path:");
		self.resources.do { arg track;
			PlayerWrapper(track).presetCompileStringSavePath = "%%_%.scd".format(val, PlayerWrapper(track).targetClass, track.key);
		};
	},

	areasizex_: { arg self, val;
		self[\areasizex] = val;
		self.changed(\tracklist);
	},

	loadedFromPath: nil,
));


TrackTemplateDef(\InstrumentTrack, (
	parent: TrackTemplateDef(\playertrack),
	eventType: \instrumenttrack,


	instrumentId_: { arg self, libId;
		var trackkey;
		trackkey = "%.%".format(self.parentTrack.key, self.index).asSymbol;
		self.instrument = ProtoDef(\GlobalLibrary).libIdToTrackInstrument(libId, trackkey);
		if(self.instrument.isNil) {
			self[\instrumentId] = libId;
			self.label = ProtoDef(\GlobalLibrary).libIdToStrings(libId).join(" ");
			self.libId = libId;

			self.instrument.makeSource(self, self.index);
			self.outBus = 0;
			Log(\Param).debug("newtrack.instrument:%", self.instrument);
			self.parentTrack.changed(\tracklist);
			self.changed(\instrumentId);
		} {
			Log(\Param).debug("Can't set instrumentId: no Instrument with this id:%", libId);
		}
		
	},

	childClass: { arg self;
		TrackTemplateDef(\InstrumentTrackPart);
	},

	isEmpty: { arg self;
		self.instrument.isNil and: {
			self.children.every({ arg x; x.isNil or: {x.isEmpty} });
		}
	},

	trackKey: { arg self;
		if(self.parentTrack.notNil) {
			"%.%".format( self.parentTrack.key , self.index.asInteger).asSymbol;
		} {
			"%".format(self.key).asSymbol;
		}
	},

	clearChannel: { arg self;
		self.clearAllChannelParts;
		self.instrument = nil;
	},
	clearAllChannelParts: { arg self;
		self.children.do { arg child;
			child.score = nil;
			child.source = nil;
		}
	},

	outBus_: { arg self, outBus;
		self[\outBus] = outBus;
		self.children.collect({ arg child;
			if(child.notNil) {
				self.instrument.updateScoreOutBus(child.score, outBus);
			}
		});
		self.changed(\outBus);
	},

	presetCompileString: { arg self;
		if(self.isEmpty) {
			nil
		} {
			var str = List[];

			str.add("%.instrument = ProtoTemplateDef('TrackInstrument').new(%);".format(self.refCompileString, self.instrument.libId.asCompileString));
			str.add("%.label = %;".format(self.refCompileString, self.label.asCompileString));

			str.add("\n%\n".format(self.instrument.presetCompileString(self.refCompileString ++ ".instrument")));
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
			[path, self.presetCompileStringSavePath].debug("InstrumentTrack.savePresetCompileString");
			path = path ? self.presetCompileStringSavePath;
			path.debug("save path");
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
	TrackTemplateDef(\TrackListChannel, TrackTemplateDef(\InstrumentTrack)); // compat

TrackTemplateDef(\InstrumentTrackPart, (
	parent: TrackTemplateDef(\playerwrapper),
	eventType: \instrumenttrackpart,
	isEmpty: { arg self;
		self.score.isNil and: {
			self.proxy.isNil or: { self.proxy.target == nil };
		}
	},

	trackKey: { arg self;
		"%.%".format(self.parentTrack.trackKey, self.index.asInteger).asSymbol;
	},

	source_: { arg self, val;
		self.proxy = PlayerWrapper(val);
		self.outBus = nil; // set to default
	},

	outBus: { arg self;
		if(self.proxy.notNil) {
			self.proxy.outBus;
		} {
			nil
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

	asPatternEvent: { arg self;
		if(self.score !? self.score.timeline.notNil) {
			self.score.timeline.asPatternEvent;
		} {
			Event.silent(1) // TODO
		}
	},

	clearPart: { arg self;
		self.score = nil;
		self.proxy = nil;
	},

	presetCompileString: { arg self;
		if(self.isEmpty) {
			nil
		} {
			var str = List[];

			str.add("%.score = %;".format(self.refCompileString, self.score.asCompileString));
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


	savePresetCompileString: { arg self, path, onDoneAction;
		if(self.isEmpty.not) {
			var file;
			path = path ? self.presetCompileStringSavePath;
			PlayerWrapper_Base.savePresetCompileStringHelper(path, onDoneAction, self.refCompileString, self.presetCompileString, false);
			if(self.score.notNil) {
				self.score.keys.do { arg key, idx;
					if(key != \selected) {
						var obj = self.score[key];
						var objtype = ProtoDef(\GlobalLibrary).targetToLibId(obj).first;
						obj.presetCompileStringSavePath = self.scorePresetCompileStringSavePath(objtype.asString);
						obj.savePresetCompileString;
					};
				};
			};
		}
	},

	grid: { arg self;
		self.parentTrack.parentTrack;
	},

	makeScore: { arg self;
		if(self.parentTrack.instrument.notNil) {
			self.score = self.parentTrack.instrument.makeScore(
				self.grid, self.parentTrack.index, self.index, self.parentTrack.outBus ? self.outBus
			);
		} {
			Log(\Param).debug("no instrument, can't make score %", self);
		}
	},

	score_: { arg self, val;
		self[\score] = val;
		Log(\Param).debug("setting score to: %", self.score.asCompileString);
		if(self.parentTrack.instrument.notNil) {
			self.parentTrack.instrument.updateScore(self.score);
		};
		self.updateSource;
		self.grid.changed(\tracklist);
	},

	selectedScore_: { arg self, scorekey=\timeline;
		self.score.selected = scorekey;
		self.updateSource;
		self.grid.changed(\tracklist);
	},

	updateSource: { arg self;
		if(self.score.notNil) {
			if(self.score.selected.isNil) {
				self.score.selected = \timeline;
			};
			self.source = self.score[self.score.selected];
		} {
			self.source = nil
		};
	},

	loadPresetCompileString: { arg self;
		FileSystemProject.load(self.presetCompileStringSavePath, true);
		if(self.score.notNil) {
			self.score.keys.do { arg key, idx;
				if(key != \selected) {
					var obj = self.score[key];
					var objtype = ProtoDef(\GlobalLibrary).targetToLibId(obj).first;
					obj.presetCompileStringSavePath = self.scorePresetCompileStringSavePath(objtype.asString);
					obj.loadPresetCompileString;
				};
			};
		};
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

	asPreview: { arg self;
		self.parentTrack.instrument.asPreview(self.parentTrack.parentTrack, self.score);
	},

	asView: { arg self;
		self.parentTrack.instrument.makePartView(self.score);
	},

	
));
	TrackTemplateDef(\TrackListChannelPart, TrackTemplateDef(\InstrumentTrackPart)); // compat


TrackTemplateDef(\TrackListPart, (
	parent: TrackTemplateDef(\lineplayer),
	eventType: \tracklistpart,
	trackKey: { arg self;
		"%.part%".format(self.parentTrack.key, self.index.asInteger).asSymbol;
	},
));

////////////////// instruments

ProtoTemplateDef(\TrackInstrument, (
	eventType: \trackinstrument,
	new: { arg self, libId, name="noname";
		var instr;
		self = self.deepCopy;

		if(libId.first == \TrackInstrument) {
			// FIXME: use globallib ?
			var instrkey = ( \TrackInstrument_ ++ libId.last.key ).asSymbol;
			instr = ProtoTemplateDef(instrkey);
			if(instr.notNil) {
				instr = instr.new(libId, name);
			};
			//instr = switch(libId.last.key,
				//\ClipTimelineTrack, { ProtoTemplateDef(\TrackInstrument_ClipTimelineTrack).new(libId, name) },
				//\KitTimelineTrack, { ProtoTemplateDef(\TrackInstrument_KitTimelineTrack).new(libId, name) },
				//\SampleTimelineTrack, { ProtoTemplateDef(\TrackInstrument_SampleTimelineTrack).new(libId, name) },
			//);
		};
		//if(libId.first == \SynthDef) {
			//libId = self.synthDefToPdefLibId(libId);
		//};
		if(instr.notNil) {
			self = instr;
			self.name = name;
			self.lib = { ProtoDef(\GlobalLibrary) };
			self.libId = libId;
			//self.source = self.lib.libIdToTarget(libId);

			self;
		} {
			"error: no instrument found for libId: % %".format(libId, name).postln;
			nil
		}
	},

	synthDefToPdefLibId: { arg self, libid;
		var sdkey = libid.last.key;
		var pdef = Pdef("%.%".format(self.name, sdkey).asSymbol, Pbind(
			\instrument, sdkey,
		));
		[\Pdef, pdef.key -> pdef];
	},

	source_: { arg self, val;
		self[\source] = val;
	},

	target: { arg self; // FIXME: need to decide which one to use, source or target, this is ridiculous
		self.source
	},

	makeScore: { arg self,  model, childidx;
		self.lib.libIdToScore(self.libId, "%.%.%".format(model.key, childidx, model.selectedPart).asSymbol);
	},

	updateScoreOutBus: { arg self, score, outBus;
		if(score.notNil) {
			score.timeline.outBus = outBus;
		}
	},

	updateScore: { arg self, score;
		if(score.notNil) {
			score.keys.do { arg key;
				if(key != \selected) {
					//self.lib.setTrackInstrument(score[key], self) // drop wrapper lib for the moment to use child class instead
					self.setTrackInstrumentOfScore(score[key]);
				}
			}
		}
	},

	setTrackInstrumentOfScore: { arg self, scoreinst;
		if(self.source.notNil) {
			scoreinst.setTrackInstrument(self, self.source);
		}
	},

	edit:{ arg self;
		Log(\Param).debug("trackInstrument: edit % ", self.libId);
		WindowDef(\PdefEditor).front(self.lib.libIdToTarget(self.libId))
	},

	asPreview: { arg self, model, score;
		var tlpreview = score.timeline.asPreview;
		tlpreview.timeline.areasize.x = model.areasizex ?? { tlpreview.timeline.areasize.x };
		tlpreview.timeline.changed(\areasize);
		tlpreview;
	},

	presetCompileString: { arg self, refCompileString;
		
		var str = List[];

		str.add("%.source = %;".format(refCompileString, self.source.asCompileString));
		str.join($\n)
	},
	
));
	ProtoDef(\trackInstrument, ProtoTemplateDef(\TrackInstrument)); // compat

ProtoTemplateDef(\TrackInstrument_ClipTimelineTrack, (
	parent: ProtoTemplateDef(\TrackInstrument),

	new: { arg self;
		self = self.copy;
	
		
	
		self;
	},

	edit: { arg self;
		Log(\Param).info("No instrument to edit in ClipTimelineTrack");
	},


	makeScore: { arg self, model, trackIdx, partIdx;
		[model.key, trackIdx, partIdx].debug("TrackInstrument_ClipTimelineTrack makeScore");
		(
			timeline: ClipTimeline("%.%.%".format(model.key, trackIdx, partIdx).asSymbol)
		)
	},

	makeIndependentScore: { arg self, key;
		ClipTimeline(( key ?? { self.name } ).asSymbol);
	},


));

ProtoTemplateDef(\TrackInstrument_SampleTimelineTrack, (
	parent: ProtoTemplateDef(\TrackInstrument),

	new: { arg self;
		self = self.copy;
	
		
	
		self;
	},

	edit: { arg self;
		Log(\Param).info("No instrument to edit in SampleTimelineTrack");
	},


	makeScore: { arg self, model, trackIdx, partIdx, outBus;
		var tl;
		var ret;
		Log(\Param).debug("TrackInstrument_SampleTimelineTrack makeScore: %, %, %".format(model.key, trackIdx, partIdx));
		ret = (
			timeline: tl = SampleTimeline("%.%.%".format(model.key, trackIdx, partIdx).asSymbol)
		);
		outBus !? { arg ob; ret.outBus = ob; };
		ret;
	},

	makeIndependentScore: { arg self, key;
		SampleTimeline(( key ?? { self.name } ).asSymbol);
	},

));

ProtoTemplateDef(\TrackInstrument_NoteTimelineTrack, (
	parent: ProtoTemplateDef(\TrackInstrument),

	new: { arg self, model, trackIdx;
		self = self.copy;
	
	
	
		self;
	},

	edit: { arg self;
		WindowDef(\PdefInstrumentEditor).front(self);
	},

	makeSource: { arg self, model, trackIdx;
		self.source = Pdef("%.%.instr".format(model.key, trackIdx).asSymbol, Pbind());
	},

	setTrackInstrumentOfScore: { arg self, scoreinst;
		if(self.source.notNil) {
			scoreinst.param = self.source;
		}
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



	makeScore: { arg self, model, trackIdx, partIdx, outBus;
		var tl;
		var ret;
		Log(\Param).debug("TrackInstrument_NoteTimelineTrack makeScore: %, %, %".format(model.key, trackIdx, partIdx));
		ret = (
			timeline: tl = NoteTimeline("%.%.%".format(model.key, trackIdx, partIdx).asSymbol)
		);
		outBus !? { arg ob; tl.outBus = ob };
		ret;
	},

	makeIndependentScore: { arg self, key;
		NoteTimeline(( key ?? { self.name } ).asSymbol);
	},

	presetCompileString: { arg self, refCompileString;
		
		var str = List[];

		str.add("%.source = %;".format(refCompileString, self.source.asCompileString));
		str.join($\n)
	},

));

ProtoTemplateDef(\TrackInstrument_ParamTimelineTrack, (
	parent: ProtoTemplateDef(\TrackInstrument),

	new: { arg self, model, trackIdx;
		self = self.copy;
	
		self.source = Param(Message(self), \level, \unipolar);
	
	
		self;
	},

	edit: { arg self;
		//WindowDef(\PdefInstrumentEditor).front(self);
		WindowDef(\ParamSelectDialog).front(nil, { arg param;
			self.source = param;
		}, self.source)
	},

	makeSource: { arg self, model, trackIdx;
		//self.source = Pdef("%.%.instr".format(model.key, trackIdx).asSymbol, Pbind());
		Param(nil)
	},

	setTrackInstrumentOfScore: { arg self, scoreinst;
		if(self.source.notNil) {
			scoreinst.param = self.source;
		}
	},

	playerSynthDef: \SampleTimeline_player,

	playerSynthDef_: { arg self, synthdesc;
		// TagSpecDef(\SynthDef) values are SynthDesc, not SynthDef key
		var instr = synthdesc.def.name;
		Log(\Param).debug("TrackInstrument_NoteTimelineTrack set playerSynthDef %", instr);
		self[\playerSynthDef] = instr;
		Pbindef(self.source.key, \instrument, instr);
		self.source.addHalo(\instrument, instr);
		self.changed(\playerSynthDef);
	},



	makeScore: { arg self, model, trackIdx, partIdx;
		Log(\Param).debug("TrackInstrument_NoteTimelineTrack makeScore: %, %, %".format(model.key, trackIdx, partIdx));
		(
			timeline: ParamTimeline("%.%.%".format(model.key, trackIdx, partIdx).asSymbol, self.source)
		)
	},

	makeIndependentScore: { arg self, key;
		ParamTimeline(( key ?? { self.name } ).asSymbol);
	},

	presetCompileString: { arg self, refCompileString;
		
		var str = List[];

		str.add("%.source = %;".format(refCompileString, self.source.asCompileString));
		str.join($\n)
	},

));

ProtoTemplateDef(\TrackInstrument_KitTimelineTrack, (
	parent: ProtoTemplateDef(\TrackInstrument),

	new: { arg self, libId, name;
		self = self.copy;
		// NOTE: name and libId is stored in this object by creator of this object
	
		
		self.source = PatKitDef("%".format(name).asSymbol);
	
		self;
	},

	edit: { arg self;
		self.source.edit;
	},

	makeScore: { arg self, model, trackIdx, partIdx;
		[model.key, trackIdx, partIdx].debug("TrackInstrument_KitTimelineTrack makeScore");
		(
			timeline: KitTimeline("%.%.%".format(model.key, trackIdx, partIdx).asSymbol, self.source)
		)
	},

	makeIndependentScore: { arg self, key;
		KitTimeline(( key ?? { self.name } ).asSymbol);
	},
));

///////////////////// GUI

WindowDef(\tracklist, { arg def, model;
	var playButton;
	var tracklist = View.new;
	var viewSelector = ~view_selector.new(0);
	viewSelector.selected_color = Color.grey;
	viewSelector.deselected_color = Color.clear;

	"i1".debug;
	tracklist.followChange(model, \tracklist, {
		viewSelector.views = [];
		tracklist.removeAll;
		tracklist.layout = VLayout (
			* model.children.collect({ arg child, childidx;
				var rowHeight = 80;
				var rowHeight_inset = rowHeight - 5;
				if(child.isEmpty.not) {
					var idx = model.selectedPart;
					var cell = child.childAt(idx);
					var linename = "%.%".format(model.key, idx).asSymbol;
					var name = "%.%.%".format(model.key, childidx, idx).asSymbol;
					var playbut = PlayerWrapper(cell).label_("").asView;
					var lay;
					var chanview = View.new;
					var variableView;
				   
					variableView = View.new.followChange(child, \mixer, { arg view;
						view.removeAll;
						Log(\Param).debug("mixer variableView: %, %, %", child.label, child.isMixerEnabled, child.mixer);
						if(child.isMixerEnabled) {
							view.layout = StackLayout(
								child.mixer.asParam(\postfader).asSlider.orientation_(\horizontal).background_(Color.clear),
								CompactServerMeterView(nil, 0,2, child.mixer.recbus).orientation_(\horizontal),
							).mode_(\stackAll);
						}
					});

					playbut.debug("i");
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
								.string_(child.label)
								.action_({
									Log(\Param).debug("edit: idx%, instr %", childidx, child.instrument.asCompileString);
									child.instrument.edit;
								})
								.maxWidth_(200)
								.mouseDownAction_({ arg but, x, y, modifiers, buttonNumber, clickCount;
									[but, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");

									if(buttonNumber == 1) { // if right-click

										WindowDef(\OverlayMenu).front(but, x, y, { arg def;
											VLayout (
												BasicButton.new.string_("Remove track").action_({
													model.removeTrack(childidx);
													def.closeWindow;
												}),
												Param(Message(child), \isMixerEnabled, ParamBoolSpec()).asButton("Enable mixer"),
											)
										})

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
								}).fixedHeight_(rowHeight_inset)
							} {
								var preview;
								//var preview = cell.score.timeline.asPreview.fixedHeight_(rowHeight_inset);
								Log(\Param).debug("InstrumentTrackPart: cell %", cell);
								preview = ( cell.asPreview ?? { View.new } ).fixedHeight_(rowHeight_inset);
								//timelinePreviewList.add(preview);
								//preview.timeline.areasize.x = model.areasizex ?? { preview.timeline.areasize.x };
								//preview.timeline.changed(\areasize);
								preview;
							}

						}.value, stretch:100],
					);
					chanview.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
						[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
						//view.background = ParamViewToolBox.color_dark;
						//view.background = Color.grey;
						viewSelector.select_item(childidx);
						if(FileSystemProject.current.notNil) {

							FileSystemProject.current.tracklist_selected_track = [\TrackListPart, linename -> model.linePlayerAt(idx)];
							FileSystemProject.current.changed(\tracklist_selected_track);
							FileSystemProject.current.tracklist_selected_track = [\InstrumentTrackPart, name -> cell];
							FileSystemProject.current.changed(\tracklist_selected_track);
							FileSystemProject.current.tracklist_selected_track.debug("sel track");
						}
						
					});
					lay.spacing_(3);
					lay.margins_(0);
					chanview.fixedHeight_(rowHeight);
					chanview.layout_(lay);
					viewSelector.add_view(chanview);
					chanview;
				};
			}).select(_.notNil).collect({ arg x; [x, stretch:0] }).asArray ++ [nil]
		);
		tracklist.layout.spacing_(0);
		tracklist.layout.margins_(0);
	});
	"i2".debug;

	playButton = PlayerWrapperView.new;
	tracklist.followChange(model, \selectedPart, {
		playButton.model = model.linePlayerAt(model.selectedPart);
		if(model.isPlaying) {
			model.linePlayerAt(model.selectedPart).play;
		};
	});

	"i3".debug;
	VLayout(
		HLayout (
			playButton.view,
			BasicButton.new.string_("Add").action_({
				WindowDef(\TrackList_NewInstrument).front({}, { arg libId, label;
					Log(\Param).debug("OK! libid %, label %", libId, label);
					model.addTrack(libId, label);
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
				WindowDef(( \TrackGrid_++model.key ).asSymbol, WindowDef(\playergrid)).front(model);
			}),
		),
		tracklist,
	);
});

WindowDef(\TrackList_NewInstrument,{ arg def, selectedHook, okHook;
	var namefield = TextField.new;
	var trackInstrumentLabel = StaticText.new;
	var lib = ProtoDef(\GlobalLibrary);
	var selectedLibId;
	var selectedCallback = { arg libid, strings;
		"selectedCallback".debug;
		trackInstrumentLabel.string = strings.join("   ");
		selectedLibId = libid;
		selectedHook.(libid, strings)
	};
	def.windowDo { arg win;
		win.autoRememberPosition(def.key);
	};
	VLayout(
		View.new.layout_(
			HLayout(
				StaticText.new.string_("Track name:"),
				namefield,
			),
		).background_(Color.grey),
		VLayout (
			HLayout (
				StaticText.new.string_("Track instrument:"),
				trackInstrumentLabel,
			),
			WindowDef(\GlobalLibrary).asView(lib, selectedCallback, [\TrackInstrument]),
		),
		HLayout(
			BasicButton.new.string_("Cancel").action_({
				def.closeWindow;
			}),
			BasicButton.new.string_("OK").action_({
				var label;
				"okHook".debug;
				def.closeWindow;
				if(namefield.string.trim != "") {
					label = namefield.string;
				};
				okHook.(selectedLibId, label);
			})
		)
	)
});

//WindowDef(\TrackList_NewInstrument).front

WindowDef(\PdefInstrumentEditor, { arg def, instr;
	var target = instr.source;
	var pwrapper = PlayerWrapper(target);
	var paramView = View.new;
	paramView.followChange(instr, \source, {
		pwrapper.target = target;
	});
	paramView.followChange(instr, \playerSynthDef, {
		Log(\Param).debug("paramView: followChange playerSynthDef");
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
	mixers = tracklist.children.collect { arg track, idx;
		if(track.isEmpty.not and: { track.isMixerEnabled == true }) {
			var mixer = track.mixer;
			var boxview = View.new;
			var delayview;
			var mixerview;
			boxview.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
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
		var meterin = SimpleServerMeterView(nil, 0,2, mixer.inbus.debug("out"));
		var meterout = CompactServerMeterView(nil, 0,2, mixer.recbus.debug("out"));
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
				"volume".debug;
				param = Param(mixer, \volume);
				sends = mixerTemplate.sendCount.collect({ arg x; x -> nil });
			} {
				"mixer".debug;
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
	[x, y].debug("xy");
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

////////////
// END



SynthDef(\hey, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.kr((1..8)/10) * 1 + 1 )).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef(\hey, 
	Pbind(
		\instrument, \hey,
		\degree, Pseq([0],inf),
		//\lpf, 5000,
		\dur, 1,
		\amp, 0.1,
	)
);

// run
TrackDef(\mygrid).clear
TrackDef(\mygrid, TrackTemplateDef(\TrackList));
TrackDef(\mygrid).edit
TrackDef(\mygrid).savePresetCompileString
TrackDef(\mygrid).dataPath
TrackDef(\mygrid).presetCompileStringSavePath="/tmp/testxxx1"
TrackDef(\mygrid).elAt(0).mixer.proxy.edit
SynthDesc(\fmgen_bla1).key
SynthDesc(\basicbass).
SynthDesc("fmgen_bla1")

ParamProto.init(true)

Pdef('mygrid.0.instr').getHalo(\instrument)
Pdef('mygrid.0.instr').get(\instrument)
Pdef('mygrid.0.instr').source.pairs[1].source

TagSpecDef(\SynthDef).list

WindowDef(\tracklist).front(TrackDef(\mygrid));
TagSpecDef(\TrackList).addUnique(\mygrid, TrackDef(\mygrid));
WindowDef(\MainProject).front(FileSystemProject('ex6'));
TrackDef(\mygrid).presetCompileStringSavePath = "/tmp/ss/";
FileSystemProject('ex6').resources = [TrackDef(\mygrid)];
FileSystemProject('ex6').projectPath = "/tmp/ss/";


SampleTimeline('mygrid.0.0').computeWaveformImage
SampleTimeline('mygrid.0.0').changed(\data)
SampleTimeline('mygrid.0.0').askBufferData
SampleTimeline('mygrid.0.0').bufferInfo.waveformImage.plot
SampleTimeline('mygrid.0.0').refreshBufferData

(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
FileSystemProject.load("cavern/lib.scd");
)

ParamTimeline(\bla3, Param(Pdef(\hoho),\hihi)).edit
ParamTimeline(\bla5).edit;
ParamProto.init(true)

		~p = Param(Message((empty:1)), \empty, \unipolar)
		~p.label
		~p.target
PlayerWrapperView(PlayerWrapper(self.param.target))

(
ProtoDef(\bla, (
	value: { arg self;
		123
	},
))
)
ProtoDef(\bla).value = 1
WindowDef(\tracklist).proto

\freq.asSpec.map((0..10)/10)
