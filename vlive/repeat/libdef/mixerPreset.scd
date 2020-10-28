// see also ndefpreset.scd track_rdnpreset.scd and mixerPreset.scd

/// the goal is to have a trackgrid where each column is an object :
// - mixer (with send)
// - fxManager (with each rdn)
// - playergrid

// l'ideal c'est que les colonnes soient dynamiques, qu'on puisse degrouper ou grouper des parametres a l'envie


(
	//ParamProto.init;
	//s.boot;
	//FileSystemProject.load("libdef/tracks.scd");
	//FileSystemProject.load("libdef/simplemixer.scd");
	//FileSystemProject.load("libdef/FxManager.scd");


ProtoDef(\GridPresetWrapper, (
	new: { arg self, grid;
		self = self.deepCopy;
	
		self.grid = { grid };
	
		self;
	},

	presetCompileString: { arg self;
		self.grid.children.collect({ arg child, colidx;
			//child.index -> child.activeIndex;
			if(child.isPlaying) {
				"%.childAt(%,%).play;".format(self.grid.asCompileString, colidx, child.activeIndex)
			} {
				"%.childAt(%).stop;".format(self.grid.asCompileString, colidx)
			}
		}).join("\n")
	},
));

TrackTemplateDef(\MixerPresetClip, ().putAll(TrackTemplateDef(\playerwrapper)).putAll((

	label: { arg self; 
		"%: %".format(self.index, 
			self.presetName ??  ( self.source !? _.key ?? "" )
		)
	},

	source: { arg self;
		self.parentTrack.target
	},

	takeSnapshot: { arg self;
		var mixer = self.source;
		var str;
		if(mixer.notNil) {
			str = mixer.presetCompileString;
			self.snapshot = str;
			self.changed(\content);
		}
	},

	eraseSnapshot: { arg self;
		Log(\Param).info("Erase %".format(self.label));
		self.snapshot.postln;
		"//////////// END of erased snapshot".postln;
		self.snapshot = nil;
		self.presetName = nil;
		self.changed(\content);
	},

	isEmpty: { arg self;
		self.snapshot.isNil;
	},

	play: { arg self;
		self.parentTrack.activeIndex = self.index;
		if(self.snapshot.notNil) {
			self.snapshot.interpret;
			//self.source.play;
		}
	},

	isPlaying: { arg self;
		var mixer = self.source;
		mixer.notNil and: { mixer.isPlaying == true and: { self.isActive == true and: { self.isEmpty.not } } }; 
	},

	stop: { arg self;
		var mixer = self.source;
		mixer.stop;
	},

	presetCompileString: { arg self;
		var str = "";
		var splitCompileString = { arg str;
			if(str.isNil) {
				nil.asCompileString
			} {
				str.clump(8000).collect({ arg istr;
					istr.asCompileString
				}).join("\n++ ");
			}
		};
		if(self.presetName.notNil) {
			str = str ++ "%.childAt(%,%).presetName = %;\n".format(self.parentTrack.parentTrack.asCompileString, self.parentTrack.index, self.index, self.presetName.asCompileString);
		};
		str = str ++ "%.childAt(%,%).snapshot = %;".format(self.parentTrack.parentTrack.asCompileString, self.parentTrack.index, self.index, splitCompileString.(self.snapshot));
		str;
	},

	savePresetCompileString: { arg self;
		if(self.isEmpty.not and: { self.presetCompileStringSavePath.notNil }) {
			var path = self.presetCompileStringSaveFile;
			File.use(path, "w") { arg file;
				file.write(self.presetCompileString)
			};
			Log(\Param).info("Saved MixerPresetClip: %".format(path));
		}
	},

	presetCompileStringSaveFile: { arg self;
		self.presetCompileStringSavePath +/+ "%.%.%.scd".format(self.parentTrack.parentTrack.key, self.parentTrack.index, self.index);
		
	},

	loadPresetCompileString: { arg self;
		if(self.isEmpty and: { self.presetCompileStringSavePath.notNil }) {
			var path = self.presetCompileStringSaveFile;
			if(File.exists(path)) {
				FileSystemProject.load(path)
			}
		}
	},

	presetCompileStringSavePath_: { arg self, val;
		self[\presetCompileStringSavePath] = val;
	},

	edit: { arg self;
		if(self.source.notNil) {
			WindowDef(\MixerPresetOverlay, { arg def, model;
				VLayout (
					PlayerWrapper(model).asView,
					HLayout(
						StaticText.new.string_("name:"),
						Param(Message(model), \presetName).asTextField,
					),
					Button.new.string_("Take snapshot").action_({
						self.takeSnapshot;
					}),
					Button.new.string_("Erase").action_({
						self.eraseSnapshot;
					}),
					nil,
				)
			}).front(self);
		} {
			Log(\Param).info("No target in this track column to snapshot");
		}
	},
)));

TrackTemplateDef(\MixerPresetTrack, ().putAll(TrackTemplateDef(\playertrack)).putAll((
	childClass: { TrackTemplateDef(\MixerPresetClip) },

	new: { arg self, parent, index, target;
		self = self.copy;

		self.selectChild(0);
		self.index = index;
		self.parentTrack = {parent};
		self.target = { target.value };
		self;
	},

	//presetCompileString: { arg self;
		//self.children.collect(_.presetCompileString).join("\n\n");
	//},

	prefix: { arg self;
		self.parentTrack.prefix+++self.index;
	},
	mixer: nil,
)));

TrackTemplateDef(\MixerPresetGrid, ().putAll(TrackTemplateDef(\playergrid)).putAll((
	childClass: { TrackTemplateDef(\MixerPresetTrack) },
	lineClass: { TrackTemplateDef(\MixerPresetLine) },

	children: { arg self;
		self[\obj_children] ?? { 
			//self[\obj_children] = SparseArray.new;
			self[\obj_children] = SparseArray[
				self.childClass.new(self, 0, { ProtoDef(\GridPresetWrapper).new(self.target.mainTrackGrid) }),
				self.childClass.new(self, 1, { self.target.mainMixer }),
				self.childClass.new(self, 2, { self.target.fxManager }),
			];
			self[\obj_children];
		};
	},

	target: { arg self;
		// FIXME: currently, changing project change the target of the new snapshots but not the snapshots already taken
		if(FileSystemProject.current.isNil) {
			// FIXME: hardcoded default project again
			FileSystemProject.current = FileSystemProject('repeat/simpleProject');
		};
		FileSystemProject.current
	},

	presetCompileString: { arg self;
		"TrackDef(%, TrackTemplateDef(\\MixerPresetGrid));\n".format(self.key.asCompileString);
	},

	savePresetCompileString: { arg self;
		var mainfile = self.presetCompileStringSavePath +/+ "Grid_%.scd".format(self.key);
		File.use(mainfile, "w") { arg file;
			file.write(self.presetCompileString)
		};
		Log(\Param).info("Saved MixerPresetGrid: %".format(mainfile));
		self.children.do({ arg column;
			column.savePresetCompileString;
			column.children.do({ arg track;
				track.savePresetCompileString;
			})
		});
		self.resources.do { arg res;
			PlayerWrapper(res).savePresetCompileString;
		}; 
	},

	presetCompileStringSavePath_: { arg self, val;
		if(val.endsWith("/data") or: { val.endsWith("/data/") }) {
			val = val +/+ "Grid_%/".format(self.key);
			File.mkdir(val);
		};
		self[\presetCompileStringSavePath] = val;
		self.children.do({ arg column;
			column.presetCompileStringSavePath = val;
			column.children.do({ arg track;
				track.presetCompileStringSavePath = val;
			})
		});
		"===== setting path of resources".debug;
		self.resources.do { arg track;
			PlayerWrapper(track).presetCompileStringSavePath = "%%_%.scd".format(val, PlayerWrapper(track).targetClass, track.key);
		};
	},

	prefix: { arg self;
		self.key;
	},
	enableMixer:false,
	mixer:nil,
)));

TrackTemplateDef(\MixerPresetLine, ().putAll(TrackTemplateDef(\lineplayer)).putAll((
	label: { arg self;
		if(self.presetName.notNil) {
			"line %: %".format(self.index, self.presetName)
		} {
			"% line %".format(self.parentTrack.label, self.index)
		};
	},
	edit: { arg self;
		WindowDef(\MixerPresetOverlay, { arg def, model;
			VLayout (
				PlayerWrapper(model).asView,
				HLayout(
					StaticText.new.string_("name:"),
					Param(Message(model), \presetName).asTextField,
				),
				Button.new.string_("Take snapshot").action_({
					model.children.do { arg child, idx;
						if(child.source.notNil) {
							child.takeSnapshot;
							if(model.presetName.notNil) {
								child.presetName = model.presetName;
							}
						}
					};
				}),
				Button.new.string_("Erase").action_({
					self.presetName = nil;
					model.children.do { arg child, idx;
						if(child.source.notNil) {
							child.eraseSnapshot;
						}
					};
				}),
				nil,
			)
		}).front(self);
		
	},

)));

TrackDef(\MixerPresetGrid, TrackTemplateDef(\MixerPresetGrid));
//TrackDef(\MixerPresetGrid).childAt(0).target = { ProtoDef(\simpleMixer) };
//TrackDef(\MixerPresetGrid).childAt(1).target = { ProtoDef(\GridPresetWrapper).new(TrackDef(\xxx)) };
//TrackDef(\MixerPresetGrid).childAt(2).target = { ProtoDef(\FxManager) };
)


// END
// ==================================================


TrackDef(\MixerPresetGrid).clear; TrackTemplateDef(\MixerPresetGrid).clear; TrackTemplateDef(\MixerPresetClip).clear;

TrackDef(\MixerPresetGrid).edit
TrackDef(\MixerPresetGrid).target.mainMixer
TrackDef(\MixerPresetGrid).target
TrackDef(\MixerPresetGrid).presetCompileString
TrackDef(\MixerPresetGrid).presetCompileStringSavePath = "/tmp/bla1"
TrackDef(\MixerPresetGrid).loadPresetCompileString
TrackDef(\MixerPresetGrid).savePresetCompileString
TrackDef(\MixerPresetGrid).presetCompileStringSavePath = "blaxxx.scd";
TrackDef(\MixerPresetGrid).mixer
TrackDef(\MixerPresetGrid).children
TrackDef(\MixerPresetGrid).edit
TrackDef(\MixerPresetGrid).e
TrackDef(\MixerPresetGrid).source = []
TrackDef(\MixerPresetGrid).source
TrackDef(\MixerPresetGrid).childAt(0).target
TrackDef(\MixerPresetGrid).childAt(0).target = { FileSystemProject.current.mainMixer }
TrackDef(\MixerPresetGrid).childAt(0).target = { ProtoDef(\simpleMixer) }
TrackDef(\MixerPresetGrid).childAt(0,0).isActive
PlayerWrapper(TrackDef(\MixerPresetGrid).childAt(0,0)).isActive
TrackDef(\MixerPresetGrid).childAt(0,0).edit
TrackDef(\MixerPresetGrid).childAt(4,5).edit
TrackDef(\MixerPresetGrid).childAt(0,0).snapshot.action
TrackDef(\MixerPresetGrid).childAt(1,0).snapshot
TrackDef(\MixerPresetGrid).childAt(0,0).snapshot
TrackDef(\MixerPresetGrid).childAt(0,0).presetCompileString
TrackDef(\MixerPresetGrid).childAt(1,0).presetCompileString
TrackDef(\MixerPresetGrid).childAt(1,0).takeSnapshot
TrackDef(\MixerPresetGrid).childAt(0,0).snapshot.compileString
TrackDef(\MixerPresetGrid).childAt(1,0).snapshot.compileString

FileSystemProject.current = FileSystemProject('repeat/simpleProject')
FileSystemProject.default
FileSystemProject.current.mainTrackGrid.presetCompileString
FileSystemProject.current.mixerPresetGrid = nil
FileSystemProject.current.mixerPresetGrid.clear
FileSystemProject.current.resources.remove(ProtoDef(\simpleProject_mixerPresetGrid))
FileSystemProject.current.mixerPresetGrid.children
TrackTemplateDef(\MixerPresetGrid).keys

TrackDef(\simpleProject_mixerPresetGrid).clearAll
TrackDef(\simpleProject_mixerPresetGrid).clear
TrackDef(\simpleProject_mixerPresetGrid).presetCompileStringSavePath
TrackDef(\simpleProject_mixerPresetGrid).savePresetCompileString
TrackDef(\simpleProject_mixerPresetGrid).presetCompileStringSavePath = "/tmp/bla1/data/"

(
TrackDef(\testpremix, TrackDef(\playergrid)).source = [
	//8.collect { arg x; ProtoDef(\myndef+++x, ProtoDef(\NdefParamGroupDef).new(Ndef(\testpre))); },
	8.collect { arg x; ProtoDef(\myndef+++x, ProtoDef(\NdefPreset).new(Ndef(\testpre))); },

]
)


ProtoDef(\FxManager).edit
	"caplib.scd".loadRelative;
	FileSystemProject.load("capsule/lib.scd")
~a = SparseArray[\a]

~a[10]=123

TrackDef(\xxx, TrackTemplateDef(\playergrid))
TrackDef(\xxx).edit
TrackDef(\xxx).asCompileString
(
TrackDef(\xxx).source = [
	[
		Pdef(\zed1, Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		)),
		Pdef(\zed2, Pbind(
			\instrument, \default,
			\freq, 400,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\mixer0, \audio),
		)),
		Pdef(\zed3, Pbind(
			\instrument, \default,
			\freq, 400,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\mixer0, \audio),
		)),
		Pdef(\zed4, Pbind(
			\instrument, \default,
			\freq, 500,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\mixer0, \audio),
		)),
	]
];
)


FileSystemProject.current.mainMixer.presetCompileString.editorInsert
FileSystemProject.current.mainMixer.clearAll
FileSystemProject.current.mainMixer.edit
FileSystemProject.current.mixerPresetGrid.childAt(0).target.edit
FileSystemProject.current.mixerPresetGrid.childAt(0,0).snapshot
FileSystemProject.current.mixerPresetGrid.childAt(0,0).takeSnapshot
FileSystemProject.current.mixerPresetGrid.childAt(0,0).source
FileSystemProject.current.mixerPresetGrid.childAt(0,0)[\takeSnapshot].asCompileString
(
FileSystemProject.current.mainTrackGrid.source = [
	[
		Pdef(\zed1, Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		)),
		Pdef(\zed2, Pbind(
			\instrument, \default,
			\freq, 400,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\mixer0, \audio),
		)),
		Pdef(\zed3, Pbind(
			\instrument, \default,
			\freq, 400,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\mixer0, \audio),
		)),
		Pdef(\zed4, Pbind(
			\instrument, \default,
			\freq, 500,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\mixer0, \audio),
		)),
	]
];
)

TrackDef(\testproj5_mixerPresetGrid, TrackTemplateDef(\MixerPresetGrid));
TrackDef(\testproj5_mixerPresetGrid).childAt(1,0).snapshot.interpret;
TrackDef(\testproj5_mixerPresetGrid).childAt(1,0).snapshot;
TrackDef(\testproj5_mixerPresetGrid).childAt(1,0).snapshot.size;
TrackDef(\testproj5_mixerPresetGrid).childAt(1,0).snapshot ++ "jjj"
