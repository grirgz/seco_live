
(

FileSystemProject.loadOnce("libdef/PlayerTracker.scd");
FileSystemProject.loadOnce("libdef/rdngui.scd");
ProtoDef(\FxManager, (
	edit: { arg self;
		WindowDef(\FxManager).front;
	},

	playerTracker: { arg self;
		// fx have always the same name, no need to update player list
		self[\playerTracker] = ProtoDef(\FxManager_PlayerTracker, ProtoTemplateDef(\PlayerTracker));
		self[\playerTracker];
	},

	presetCompileString: { arg self;
		var string = "";
		[\rdn, \rdn2, \rdn3, \rdn4].do({ arg key;
			var asso = key -> ProtoDef(key);
			if(asso.value[\make].notNil) {
				string = string ++ "ProtoDef(%, \\rdn);\n".format(key.asCompileString);
				string = string ++ ParamGroup([
					Param(Message(asso.value), \inbus, TagSpecDef(\BusDef)),
					//Param(Message(asso.value), \outBus, TagSpecDef(\BusDef_index)),
				]).getSetCompileString;
				string = string ++ "%.outBus = %;".format(asso.value.asCompileString, BusDef(TagSpecDef(\BusDef_index).unmapKey(asso.value.outBus)) ?? 0 !? _.asCompileString);
				string = string ++ "\n" ++ asso.value.presetCompileString ++ "\n";
			};
		});
		string = string ++ "\n\n";
		[\fx1, \fx2, \fx3, \fx4].do({ arg key;
			var asso = key -> Ndef(key);
			string = string ++ "\n" ++ ParamGroup([
				//Param(asso.value, \inbus, TagSpecDef(\BusDef)),
				//Param(asso.value, \out, TagSpecDef(\BusDef_index)),
				Param(Message(asso.value), \source, TagSpecDef(\SynthDef_fx)),
				//Param(asso.value, \gain),
			]).getSetCompileString;
			string = string ++ "PlayerWrapper(%).outBus = %;\n".format(asso.value.asCompileString, BusDef(TagSpecDef(\BusDef_index).unmapKey(asso.value.initMonitor.out)) ?? 0 !? _.asCompileString);
			string = string ++ asso.value.asParamGroup.getSetCompileString;
		});
		string;
	},

	savePresetCompileString: { arg self, path, onDoneAction;
		var pathdir, pathfile;
		if(path.notNil) {
			if(path.isFolder) {
				pathdir = path;
				pathfile = pathdir +/+ "FxManager_preset.scd";
			} {
				pathfile = path;
				pathdir = PathName(path).pathOnly;
			}
		} {
			pathdir = self.presetCompileStringSavePath;
			pathfile = self.presetCompileStringSaveFile;
		};
		if(pathfile.notNil) {
			if(File.exists(pathfile).not or: {self.loadedFromPath == pathdir}) {
				File.mkdir(pathdir);
				self.loadedFromPath = pathdir;
				File.use(pathfile, "w") { arg file;
					file.write(self.presetCompileString);
				};
				Log(\Param).info("FxManager saved to %.".format(pathfile));
			} {
				"savePresetCompileString: can't save on existing project".error;
			};
		} {
			"savePresetCompileString: can't save, no path provided and no path stored".error;
		}
	},

	presetCompileStringSaveFile: { arg self;
		if(self.presetCompileStringSavePath.notNil) {
			if( self.presetCompileStringSavePath.isFolder) {
				self.presetCompileStringSavePath +/+ "FxManager_preset.scd"
			} {
				self.presetCompileStringSavePath
			}
		}
	},

	loadPresetCompileString: { arg self;
		// just run the preset file 
		if(File.exists(self.presetCompileStringSaveFile)) {
			FileSystemProject.load(self.presetCompileStringSaveFile)
		} {
			Log(\Param).error("FxManager: Error: Can't load preset file: not found: %".format(self.presetCompileStringSaveFile));
		}
	},

	play: { arg self;
		self.playerTracker.play;
	},

	stop: { arg self;
		self.playerTracker.stop;
	},

	isPlaying: { arg self;
		self.playerTracker.isPlaying;
	},

	fxKeys: { arg self;
		[\rdn, \rdn2, \rdn3, \rdn4, \fx1, \fx2, \fx3, \fx4];
	},

));


WindowDef(\FxManager, {
	var model = ProtoDef(\FxManager);
	var playerman = model.playerTracker;
	var save_it = { arg mypath;
		Log(\Param).debug("Writing preset to file %".format(mypath.asCompileString));
		File.use(mypath, "w", { arg file;
			file.write(model.presetCompileString);
		});
	};
	VLayout (
		HLayout (
			PlayerWrapper(model).asView,
			BasicButton.new.string_("Save as").action_({
				WindowDef(\filedialog_save).front(
					PathName(Document.current.path).pathOnly +/+ "FxManager_.scd",
					{ arg dir, filename;
						save_it.(dir+/+filename)
					}
				)
			}),
			BasicButton.new.string_("Load").action_({
				WindowDef(\filedialog).front(
					PathName(Document.current.path).pathOnly,
					{ arg filename;
						FileSystemProject.load(filename);
						Log(\Param).info("Loaded FxManager preset from %".format(filename));
					}
				)
			}),
			BasicButton.new.string_("Init").action_({
				FileSystemProject.load("cavern/FxManager_default.scd")
			}),
		),
		*[\rdn, \rdn2, \rdn3, \rdn4].collect({ arg key;
			var asso = key -> ProtoDef(key);
			if(asso.value[\make].isNil) {
				ProtoDef(key, ProtoTemplateDef(\rdn));
			};
			playerman.addPlayer(asso.value);
			asso.key.debug("xx");
			HLayout (
				PlayerWrapper(asso.value).asView,
				BasicButton.new.string_("Edit").action_({
					asso.value.edit;
				}),
				Param(Message(asso.value), \inbus, TagSpecDef(\BusDef)).asPopUpMenu,
				Param(Message(asso.value), \outBus, TagSpecDef(\BusDef_index)).asPopUpMenu,
				Param(asso.value.proxy, \gain).asSlider.orientation_(\horizontal).fixedWidth_(170),
			)
		}) 
		++
		[\fx1, \fx2, \fx3, \fx4].collect({ arg key;
			var asso = key -> Ndef(key);
			asso.key.debug("xx");
			playerman.addPlayer(asso.value);
			HLayout (
				PlayerWrapper(asso.value).asView,
				BasicButton.new.string_("Edit").action_({
					var name;
					var xedit;
					var edit = {
						WindowDef(( \NdefEditor++name ).asSymbol, WindowDef(\NdefEditor)).front(asso.value).windowName_(name);
					};
					name = "%: %".format(asso.key, asso.value.source);
					if(asso.value.source.class == Symbol and: {
						xedit = SynthDesc(asso.value.source).getHalo(\edit);
						xedit.notNil;
					}) {
						edit = xedit;
					};
					edit.(asso.value)
				}),
				Param(asso.value, \inbus, TagSpecDef(\BusDef)).asPopUpMenu,
				//Param(asso.value, \out, TagSpecDef(\BusDef)).asPopUpMenu,
				Param(Message(PlayerWrapper(asso.value)), \outBus, TagSpecDef(\BusDef_index)).asPopUpMenu,
				Param(Message(asso.value), \source, TagSpecDef(\SynthDef_fx)).asPopUpMenu,
				Param(asso.value, \gain).asSlider.orientation_(\horizontal).fixedWidth_(170),
			)
		}) 
		++ [nil]
	)
});

BusDef(\fx1, \audio, 2);
BusDef(\fx2, \audio, 2);
BusDef(\fx3, \audio, 2);
BusDef(\fx4, \audio, 2);
BusDef(\fx5, \audio, 2);
BusDef(\fx6, \audio, 2);
BusDef(\fx7, \audio, 2);
BusDef(\fx8, \audio, 2);
)

// END

~a = (bla:34)
Message(~a, \bla).value

ProtoDef(\FxManager).presetCompileString
ProtoDef(\FxManager).edit

PlayerWrapper(ProtoDef(\rdn).proxy).outBus
ProtoDef(\blaa).eventType
ProtoDef(\rdn).keys
WindowDef(\FxManager).front
Ndef(\fx4).edit
Ndef(\fx4).source.class == Symbol
SynthDesc(Ndef(\fx4).source).getHalo(\edit)

(
	ProtoTemplateDef(\NdefFx, (
		instrument_: { arg self, val;
			self.proxy.source = val;
		},

	));
)

ProtoDef(\rdn).inbus
ProtoDef(\rdn).presetDictionary
ProtoDef(\rdn).readPresetLib

Param(Ndef(\fx1), \out).spec.tagSpec
Param(Ndef(\fx1), \inbus).spec.tagSpec

WindowDef(\bla, { PopUpMenu.new.items_([\bla, \rah]).value_(nil) }).front
