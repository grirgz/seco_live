

(

TrackTemplateDef(\CodeFileGrid, (
	parent: TrackTemplateDef(\CustomTrackList),
	childClass: { TrackTemplateDef(\PdefCodeFileTrack) }, // use Pdef as default
	edit: { arg self;
		WindowDef(\CodeFileGrid).front(self);
	},

	refTemplateCompileString: { arg self;
		"\\CodeFileGrid";
	},

	codeFilePath: { arg self;
		if(self.dataPath.notNil) {
			self.dataPath +/+ "code/"
		};
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


TrackTemplateDef(\CodeFileTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\CodeFileTrackPart) },
	//codeFilePath: "~/tmp/testcodefile/".standardizePath,
	//dataPath: "~/tmp/testcodefile/data/".standardizePath,
	initTrack: { arg self;
		if(self.isEmpty.not) {
			TrackDef.all[self.codeFilePrefix.asSymbol] = self; // add shortcut to allow TrackDef(~name)
			self.executeCodeFile;
			if(self.makeScoreOnInitTrack != false) {
				self.makeScore;
			};
			self.loadPresetCompileString;
		}
	},

	editInstrument: { arg self;
		var path = self.codeFileName;
		File.mkdir(self.codeFilePath);
		~name = self.codeFilePrefix;
		~currentTrack = self;
		//Document.open(path); // should use this, but not supported for the moment
		//"vim --servername scvim --remote-send '<Esc>:tabedit %<Enter>'".format(path).unixCmd;
		self.vimOpenFile(path)
	},

	vimOpenFile: { arg self, path;
		"vim --servername scvim --remote-send '<Esc>2gt:drop %<Enter>'".format(path).unixCmd;
	},

	selectSourceDialog: { arg self;
		self.editInstrument;
		//"vim --servername scvim --remote-send '<Esc>:drop %<Enter>'".format(self.presetCompileStringSavePath).unixCmd;
	},

	outBus_: { arg self, outBus;
		self[\outBus] = outBus;
		self.proxy.set(\out, outBus);
		self.changed(\outBus);
	},

	//presetCompileStringSavePath: { arg self;
		////self.codeFilePath +/+ "TrackDef_%.scd".format(self.trackKey);
		//self.codeFilePath;
	//},

	codeFilePrefix: { arg self;
		self.trackKey;
	},

	codeFilePath: { arg self;
		self.parentTrack.codeFilePath;
	},

	codeFileName: { arg self;
		if(self.codeFilePath.notNil) {
			self.codeFilePath +/+ self.codeFilePrefix ++ ".scd";
		};
	},

	cloneHeader: { arg self, parent, index;
		// clone only the track but not its children
		// WARN: CustomTrack cloneScore should assign score while CustomTrackPart cloneScore should return score
		var fromFile = self.codeFileName;
		self = self.copy;

		self.parentTrack = {parent};
		self.index = index.asInteger;
		self.children = SparseArray[]; // remove children

		if(File.exists(self.codeFileName).not) {
			File.copy(fromFile, self.codeFileName)
		} {
			"Can't copy from % to %: destination exists".format(fromFile, self.codeFileName).error;
		};

		self.cloneScore;
		if(self.mixer_obj.notNil) {
			self.mixer_obj = self.mixer_obj.clone("%.%".format(self.parentTrack.key, self.index).asSymbol);
			self.outBus = self.mixer_obj.inbus;
		};
		//self.savePresetCompileString; // have no children yet so should be ok
		self.initTrack;
		parent.children[index] = self;
		self; // should return itself because part.clone depends on it
		
	},

	clone: { arg self, parent, index;
		var sourceself = self;
		// WARN: CustomTrack cloneScore should assign score while CustomTrackPart cloneScore should return score
		self = self.cloneHeader(parent, index);
		sourceself.children.do({ arg item, idx;
			item.clone(self, idx);
		});
		//self.savePresetCompileString; // save twice but ok for the moment
		self;
		
	},

	executeCodeFile: { arg self;
		var path = self.codeFileName;
		~name = self.codeFilePrefix;
		~currentTrack = self;
		FileSystemProject.load(path);
	},

	play: { arg self;
		if(self.mixer.notNil) {
			self.mixer.play;
		};
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

	//loadPresetCompileString: { arg self;
		//FileSystemProject.load(self.presetCompileStringSavePath +/+ "%.init.scd".format(self.codeFilePrefix), silent:false);
	//},

	isEmpty: { arg self;
		if(self.codeFileName.isNil) {
			true
		} {
			File.exists(self.codeFileName.asString).not
		};
	},

	makeScore: { arg self;
		//self.isEmpty = false;
		//self.proxy = Pdef(self.codeFilePrefix);
		//PlayerWrapper(Pdef("%_base".format(self.codeFilePrefix).asSymbol));
	},
));
TrackTemplateDef(\CodeFileTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	isEmpty: { arg self;
		File.exists(self.codeFileName).not
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
	//loadPresetCompileString: { arg self;
		//FileSystemProject.load(self.presetCompileStringSavePath, false);
	//},

	codeFileName: { arg self;
		if(self.parentTrack.codeFilePath.notNil) {
			self.parentTrack.codeFilePath +/+ self.codeFilePrefix ++ ".scd"
		};
	},
	executeCodeFile: { arg self;
		var path = self.codeFileName;
		~name = self.parentTrack.codeFilePrefix;
		~namex = self.codeFilePrefix;
		~currentTrack = self.parentTrack;
		~currentPart = self;
		FileSystemProject.load(path);
	},

	codeFilePrefix: { arg self;
		//self.parentTrack.codeFilePrefix;
		"%.%".format(self.parentTrack.codeFilePrefix, self.index)
	},

	//presetCompileStringSavePath: { arg self;
		//self.parentTrack.presetCompileStringSavePath +/+ self.codeFilePrefix ++ ".scd";
	//},

	selectSourceDialog: { arg self;
		self.edit;
		//"vim --servername scvim --remote-send '<Esc>:drop %<Enter>'".format(self.presetCompileStringSavePath).unixCmd;
	},
	stopInternal: { arg self;
		
		"stop internal".debug;

		// do not stop parent, only refresh button
		if(self.isEmpty.not) {
			self.parentChildStopped;
			self.changed(\stop, self.quant);
			self.changed(\PlayerWrapper, \userStopped); 
			self.proxy.doWithQuant {
				self.changed(\PlayerWrapper, \stopped); 
				self.parentChildStopped({ arg me; me.changed(\PlayerWrapper, \stopped) });
			}
		} 
	},

	quant: { arg self;
		self.parentTrack.proxy.quant;
	},

	play: { arg self;
		var stopchild;
		"play".debug("play");
		if(self.isEmpty) {
			self.stop;
		} {
			if(self.parentActiveIndex != self.index) {
				stopchild = self.parentActiveChild;
			};
			self.parentActiveIndex = self.index;
			[stopchild].debug("stopchild");
			if(stopchild.notNil) { stopchild.stopInternal }; // changed message but arrive after deselect
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

	scorePresetCompileString: { arg self;
		if(self.data.notNil) {
			"%.data = %;".format(self.refCompileString, self.data.asCompileString)
		} {
			""
		}
	},

	edit: { arg self;
		var path = self.codeFileName;
		File.mkdir(self.parentTrack.codeFilePath);
		~name = self.parentTrack.codeFilePrefix;
		~namex = self.codeFilePrefix;
		~currentTrack = self.parentTrack;
		~currentPart = self;
		//Document.open(path); // should use this, but not supported for the moment
		//"vim --servername scvim --remote-send '<Esc>:tabedit %<Enter>'".format(path).unixCmd;
		self.vimOpenFile(path);
	},

	clone: { arg self, parent, index;
		// should be named cloneTo because it inserts the clone into destination
		var fromFile = self.codeFileName;
		
		if(parent.isEmpty) {
			[self.parentTrack, parent.parentTrack, parent.index].debug("clone: cloning header from to");
			parent = self.parentTrack.cloneHeader(parent.parentTrack, parent.index);
			// do not forget to use the new parent now
		};

		self = self.copy;

		self.parentTrack = {parent};
		self.index = index.asInteger;
		parent.children[index] = self;


		if(File.exists(self.codeFileName).not) {
			if(File.exists(fromFile)) {
				File.copy(fromFile, self.codeFileName)
			} {
				// no fromfile, no copy needed
			};
		} {
			"Can't copy from % to %: destination exists".format(fromFile, self.codeFileName).error;
		};


		self.score = self.cloneScore;
		self.data.debug("copy data");
		self.data = self.data.deepCopy;
		self.data.debug("copy data2");
		self.savePresetCompileString;
		self[\cloneScore].asCompileString.debug("cloneScore fun");
		//self.score.outBus.debug("clone: outBus");
		self;
	},

	vimOpenFile: { arg self, path;
		self.parentTrack.vimOpenFile(path);
	},

));

TagSpecDef(\CustomTrackTemplate).addUnique(\CodeFileTrack -> TrackTemplateDef(\CodeFileTrack));
);

/////// specific templates
(

TrackTemplateDef(\PdefCodeFileTrack, (
	parent: TrackTemplateDef(\CodeFileTrack),
	childClass: TrackTemplateDef(\PdefCodeFileTrackPart),

	score: { arg self;
		Pdef(self.codeFilePrefix);
	},

	score_:{ arg self, val;
		self[\score] = val;
		self[\proxy] = PlayerWrapper(self.score);
		self;
	},

	proxy: { arg self;
		self[\proxy] = PlayerWrapper(self.score);
		self[\proxy];
	},

	cloneScore: { arg self;
		self[\proxy] = PlayerWrapper(self.score);
	},

	initPdef: { arg self, val;
		var pre = Pdef(( self.codeFilePrefix ++ \pre ).asSymbol);
		var post = Pdef(( self.codeFilePrefix ++ \post ).asSymbol);
		if(pre.source == nil) { pre.source = Pbind() };
		if(post.source == nil) { post.source = Pbind() };
		Pdef(self.codeFilePrefix,
			pre <> val <> post;
		);
		
	},

	initPmono: { arg self, instrname, val;
		var pre = Pdef(( self.codeFilePrefix ++ \pre ).asSymbol);
		var post = Pdef(( self.codeFilePrefix ++ \post ).asSymbol);
		var instr = Pdef(( self.codeFilePrefix ++ \instr ).asSymbol);
		if(pre.source == nil) { pre.source = Pbind() };
		if(post.source == nil) { post.source = Pbind() };
		if(instr.source == nil) { instr.source = Pmono(instrname) };
		Pdef(self.codeFilePrefix,
			instr <> pre  <> val <> post;
		);
		
	},
));

TrackTemplateDef(\PdefCodeFileTrackPart, (
	parent: TrackTemplateDef(\CodeFileTrackPart),

	isrest: { arg self;
		Plazy({ arg ev;
			if(( self.data !? _.stepSeq ).notNil and: { self.data.stepSeq.size > 0 }) {
				Pfin(self.data.stepSeqSize.max(1) ?? { self.data.stepSeq.size },Pseq(self.data.stepSeq,1)).coin.not
			} {
				Pn(false,1);
			};
		}).loop
	},
	//score_: { arg self, val;
		//if(val.notNil) {
			//self[\score] = val;
			//self[\pchain] = Pdef( (self.trackKey++\_chain).asSymbol, self.score <> self.parentTrack.score );
			//self[\proxy] = PlayerWrapper(self.pchain);
		//} {
			//self[\score] = nil;
			//self[\pchain] = nil;
			//self[\proxy] = nil;
		//};
	//},
	makeScore: { arg self;
		//self.score = Pdef(self.codeFilePrefix);
		//Pdef(self.codeFilePrefix, Pbind());
		//self.proxy.debug("makeScore proxy end");
	},
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


// END

// deprecated
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
// not used
TrackTemplateDef(\CodeFileTrackVolatil, (
	parent: TrackTemplateDef(\CodeFileTrack),
	makeScoreOnInitTrack: false,
));
