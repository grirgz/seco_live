
FileSystemProject.loadOnce("libdef/CustomTrackList.scd");

(

TrackTemplateDef(\CodeFileGrid, (
	parent: TrackTemplateDef(\CustomTrackList),
	childClass: { TrackTemplateDef(\CodeFileTrackVolatil) },
	edit: { arg self;
		WindowDef(\CodeFileGrid).front(self);
	},
	initTrack: { arg self;
		64.do { arg idx;
			var child = self.childAt(idx);
			if(child.isEmpty.not) {
				child.initTrack;
			}
			
		};
		
	},

));

TrackTemplateDef(\CodeFileTrackVolatil, (
	parent: TrackTemplateDef(\CodeFileTrack),
	makeScoreOnInitTrack: false,
));

TrackTemplateDef(\CodeFileTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\CodeFileTrackPart) },
	codeFilePath: "~/tmp/testcodefile/".standardizePath,
	dataPath: "~/tmp/testcodefile/data/".standardizePath,
	initTrack: { arg self;
		if(self.isEmpty.not) {
			TrackDef.all[self.codeFilePrefix.asSymbol] = self; // add shortcut to allow TrackDef(~name)
			self.executeCodeFile;
			//self.makeScore;
			self.loadPresetCompileString;
		}
	},

	editInstrument: { arg self;
		var path = self.codeFileName;
		~name = self.codeFilePrefix;
		//Document.open(path); // should use this, but not supported for the moment
		"vim --servername scvim --remote-send '<Esc>:tabedit %<Enter>'".format(path).unixCmd;
	},

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

	codeFileName: { arg self;
		self.codeFilePath +/+ self.codeFilePrefix ++ ".scd";
	},

	executeCodeFile: { arg self;
		var path = self.codeFileName;
		~name = self.codeFilePrefix;
		FileSystemProject.load(path);
	},

	play: { arg self;
		self.proxy.play;
		self.changed(\play, self.quant);
		self.changed(\PlayerWrapper, \userPlayed); // the view put directly the ProtoDef so need to simulate PlayerWrapper
		PlayerWrapper.doWithQuant(self.quant, {
			self.changed(\PlayerWrapper, \playing); // the view put directly the ProtoDef so need to simulate PlayerWrapper
		});
	},

	stop: { arg self;
		PlayerWrapper(self.proxy).stop; // to have quant on Pdef, should think about it
		self.changed(\stop, self.quant);
		self.changed(\PlayerWrapper, \userStopped); // the view put directly the ProtoDef so need to simulate PlayerWrapper
		PlayerWrapper.doWithQuant(self.quant, {
			self.changed(\PlayerWrapper, \stopped); // the view put directly the ProtoDef so need to simulate PlayerWrapper
		});
	},

	quant: { arg self;
		self.proxy.quant;
	},

	isPlaying: { arg self;
		self.proxy.isPlaying;
	},

	loadPresetCompileString: { arg self;
		FileSystemProject.load(self.presetCompileStringSavePath +/+ "%.init.scd".format(self.codeFilePrefix), silent:false);
	},

	isEmpty: { arg self;
		File.exists(self.codeFileName.asString).not
	},

	makeScore: { arg self;
		//self.isEmpty = false;
		//self.proxy = Pdef(self.codeFilePrefix);
		//PlayerWrapper(Pdef("%_base".format(self.codeFilePrefix).asSymbol));
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
			//self.trackPart.loadPresetCompileString;
			self.trackPart.executeCodeFile;
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
		//self.codeFilePlayer = ProtoClass((
			//parent: ProtoTemplateDef(\CodeFilePlayer),
			//trackPart: {self},
		//));
		//self.proxy = PlayerWrapper(self.codeFilePlayer);
	},
	initTrack: { arg self;
		self.makeScore;
	},
	loadPresetCompileString: { arg self;
		FileSystemProject.load(self.presetCompileStringSavePath, false);
	},

	codeFileName: { arg self;
		self.parentTrack.codeFilePath +/+ self.codeFilePrefix ++ ".scd"
	},
	executeCodeFile: { arg self;
		var path = self.codeFileName;
		~name = self.parentTrack.codeFilePrefix;
		~namex = self.codeFilePrefix;
		FileSystemProject.load(path);
	},

	codeFilePrefix: { arg self;
		//self.parentTrack.codeFilePrefix;
		"%.%".format(self.parentTrack.codeFilePrefix, self.index)
	},

	presetCompileStringSavePath: { arg self;
		self.parentTrack.presetCompileStringSavePath +/+ self.codeFilePrefix ++ ".scd";
	},

	selectSourceDialog: { arg self;
		"vim --servername scvim --remote-send '<Esc>:drop %<Enter>'".format(self.presetCompileStringSavePath).unixCmd;
	},
	stopInternal: { arg self;
		
		"stop internal".debug;
	},

	quant: { arg self;
		self.parentTrack.proxy.quant;
	},

	play: { arg self;
		if(self.isEmpty) {
			self.stop;
		} {
			self.parentTrack.activeIndex = self.index;
			self.executeCodeFile;
			self.parentTrack.play;
			self.changed(\play, self.quant);
			self.changed(\PlayerWrapper, \userPlayed); // the view put directly the ProtoDef so need to simulate PlayerWrapper
			PlayerWrapper.doWithQuant(self.quant, {
				self.changed(\PlayerWrapper, \playing); // the view put directly the ProtoDef so need to simulate PlayerWrapper
			});
		}
	},

	stop: { arg self;
		self.parentTrack.stop;
		self.changed(\stop, self.quant);
		self.changed(\PlayerWrapper, \userStopped); // the view put directly the ProtoDef so need to simulate PlayerWrapper
		PlayerWrapper.doWithQuant(self.quant, {
			self.changed(\PlayerWrapper, \stopped); // the view put directly the ProtoDef so need to simulate PlayerWrapper
		});
	},

	isPlaying: { arg self;
		self.parentTrack.isPlaying and: { self.parentTrack.activeIndex == self.index }
	},

	isEmpty: { arg self;
		File.exists(self.codeFileName.asString).not
	},

	edit: { arg self;
		var path = self.codeFileName;
		~name = self.parentTrack.codeFilePrefix;
		~namex = self.codeFilePrefix;
		//Document.open(path); // should use this, but not supported for the moment
		"vim --servername scvim --remote-send '<Esc>:tabedit %<Enter>'".format(path).unixCmd;
	},

));

TagSpecDef(\CustomTrackTemplate).addUnique(\CodeFileTrack -> TrackTemplateDef(\CodeFileTrack));
);

(

TrackTemplateDef(\PdefCodeFileTrack, (

));


);

/////////////


(
WindowDef(\CodeFileGrid, (
	parent: WindowDef(\customgrid).proto,

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
							HLayout (
								StaticText.new.string_("label:"),
								Param( Message(model), \label, ).asTextField,
							), 
							BasicButton.new.string_("Edit part").action_({
								[model, model[\edit].asCompileString].debug("edit");
								model.edit;
								def.closeWindow;
							}),
							BasicButton.new.string_("Edit track instrument").action_({
								model.parentTrack.editInstrument;
								def.closeWindow;
							}),
							BasicButton.new.string_("execute track instrument file").action_({
								model.parentTrack.executeCodeFile;
								def.closeWindow;
							}),
							if(model.parentTrack.isEmpty.not) {
								if(model.isEmpty) {
									[

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

									]
								}
							},
							StaticText.new,
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
)
