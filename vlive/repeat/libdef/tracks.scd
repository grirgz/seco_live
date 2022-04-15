

(
TrackTemplateDef(\playerwrapper, (
	label: { arg self; 
		"%: %".format(self.index, if(self.proxy.notNil, { self.proxy.label }, { "-" }))
	},

	defaultSource: nil,

	new: { arg self, parent, index;
		self = self.copy;

		self.parentTrack = {parent};
		self.index = index.asInteger;
		self[\storeOn] = { arg self, str; str << self.refCompileString };
		self;
	},

	makeListener: { arg self, fun;
		var controller;
		var listenfun = { arg target ... args;
			fun.(self, *args);
		};
		//this.target.debug("makeListener");
		controller = SimpleController(self)
			.put(\play, listenfun)
			.put(\stop, listenfun)
			.put(\userPlayed, listenfun)
			.put(\userStopped, listenfun)
			.put(\playing, listenfun)
			.put(\stopped, listenfun)
			.put(\PlayerWrapper, listenfun)
		;
		self.controller = controller;
		controller
	},

	asPlayerEvent: { arg self;
		PlayerEvent((
			midinote: self.parentTrack.index,
			receiver: "{ % }".format(self.refCompileString).interpret
		))
	},

	isEmpty: { arg self;
		self.proxy.isNil or: { self.proxy.target == nil };
	},

	clearTrack: { arg self;
		self.proxy = nil;
	},


	source_: { arg self, val;
		self.proxy = PlayerWrapper(val);
		if(self.mixer.notNil and: { self.parentTrack.enableAutoSetOutbus == true }) {
			self.proxy.outBus = self.mixer.inbus;
		}
	},

	source: { arg self;
		self.proxy.target;
	},

	refCompileString: { arg self;
		"%.childAt(%)".format(self.parentTrack.refCompileString, self.index);
	},

	proxy: { arg self;
		if(self[\obj_proxy].isNil) {
			self[\obj_proxy] = PlayerWrapper(self.defaultSource);
		};
		self[\obj_proxy];
	},

	asParamGroup: { arg self;
		self.source.asParamGroup;
	},

	edit: { arg self;
		var target = self.source;
		if(target.notNil) {

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
		} {
			self.selectSourceDialog;
		};
		//WindowDef(\playerwrapper, {
			//var track = self;
			//VLayout(
				//PlayerWrapper(track).asView,
				//ParamGroupLayout.two_panes(track.asParamGroup)
			//)
		//}).front;
	},

	selectSourceDialog: { arg self;
		var source;
		var default;
		if(self.source.isKindOf(PlayerWrapper)) {
			source = self.source.target;
		} {
			source = self.source;
		};
	   	default = ProtoDef(\GlobalLibrary).targetToLibId(source);
		WindowDef(\GlobalLibrary_select).front(default, { arg player;
			//~child = child;
			self.source = player.last.value;
		}, [\Clip])
	},

	stopInternal: { arg self;
		// this is called when another child start playing
		// can be overridden when parentTrack.proxy should not be stopped, like in FileCodeTrack
		self.stop;
		
	},

	play: { arg self;
		var stopchild;
		if(self.isEmpty == true) {
			if(self.parentTrack.recordArmed == true) {
				self.startRecordingNewScore;
			} {
				self.parentTrack.stop;
			}
		} {
			if(self.parentTrack.activeIndex != self.index) {
				stopchild = self.parentTrack.activeChild;
			};
			self.parentTrack.activeIndex = self.index;
			if(stopchild.notNil) { stopchild.stopInternal }; // changed message but arrive after deselect
			self.proxy.play;
			self.playHook;
			self.parentTrack.childPlayed;
			self.changed(\play, self.quant);
			self.changed(\PlayerWrapper, \userPlayed); // the view put directly the ProtoDef so need to simulate PlayerWrapper
			self.proxy.doWithQuant {
				self.changed(\PlayerWrapper, \playing); // the view put directly the ProtoDef so need to simulate PlayerWrapper
				self.parentTrack.childPlayed({ arg me;
					me.changed(\PlayerWrapper, \playing); 
				});

			};
			// it's not a good design this mean i should do it on every ProtoDef!
		}
	},

	resetPlay: { arg self;
		var stopchild;
		if(self.isEmpty == true) {
			self.parentTrack.stop;
		} {
			if(self.parentTrack.activeIndex != self.index) {
				stopchild = self.parentTrack.activeChild;
			};
			self.parentTrack.activeIndex = self.index;
			if(stopchild.notNil) { stopchild.stop }; // changed message but arrive after deselect
			// TODO: make it in PlayerWrapper
			if(self.proxy.target.isKindOf(EventPatternProxy)) {
				Log(\Param).debug("playerwrapper track: reset play");
				self.proxy.target.reset;
				self.proxy.play;
			} {
				self.proxy.play;
			};
			self.resetPlayHook;
			self.parentTrack.childPlayed;
			self.changed(\play, self.quant);
			self.changed(\PlayerWrapper, \playing); 
		}
		
	},

	playNow: { arg self;
		var stopchild;
		if(self.isEmpty == true) {
			self.parentTrack.stop;
		} {
			self.parentTrack.activeIndex = self.index;
			self.proxy.playNow;
			self.playNowHook;
			self.parentTrack.childPlayed;
			self.changed(\play, self.quant);
			self.changed(\PlayerWrapper, \playing); 
		}
	},

	stop: { arg self;
		if(self.isEmpty.not) {
			self.proxy.stop;
			self.stopHook;
			if(self.parentTrack.recordArmed == true) {
				self.stopRecording;
			};
			self.parentTrack.childStopped;
			self.changed(\stop, self.quant);
			self.changed(\PlayerWrapper, \userStopped); 
			self.proxy.doWithQuant {
				self.changed(\PlayerWrapper, \stopped); 
				self.parentTrack.childStopped({ arg me; me.changed(\PlayerWrapper, \stopped) });
			}
		} 
	},

	stopNow: { arg self;
		self.proxy.stopNow;
		self.stopNowHook;
		self.parentTrack.childStopped;
		self.changed(\stop, self.quant);
		self.changed(\PlayerWrapper, \stopped); 
	},

	quant: { arg self;
		self.proxy.quant;
	},

	quant_: { arg self, val;
		self.proxy.quant = val;
	},

	isPlaying: { arg self;
		(self.proxy.isPlaying == true) and: {
			self.mixer.isNil or: { self.mixer.isPlaying == true }
		};
	},

	isActive: { arg self;
		self.parentTrack.activeIndex == self.index;
	},

	mixer: { arg self;
		self.parentTrack.mixer;
	},

	savePresetCompileString: { arg self;
		if(self.isEmpty.not and: { self.proxy.presetCompileStringSavePath.notNil }) {
			self.proxy.savePresetCompileString;
		}
	},

	loadPresetCompileString: { arg self;
		if(self.isEmpty.not and: { self.proxy.presetCompileStringSavePath.notNil }) {
			self.proxy.loadPresetCompileString;
		}
	},

	presetCompileStringSavePath: { arg self;
		if(self.proxy.notNil) {
			self.proxy.presetCompileStringSavePath;
		}
	},

	presetCompileStringSavePath_: { arg track, val;
		var playerwrapper;
		var player_prefix;
		var savepath;
		var player;
		//"--------- try setting save path of %".format(track).debug;
		try {
			playerwrapper = track.proxy;
			player = playerwrapper.target;
			player_prefix = playerwrapper.targetClass;
			if(player.notNil) {

				savepath = val +/+ "%_%.scd".format(player_prefix, player.key);
				savepath.debug("savepath");

				playerwrapper.presetCompileStringSavePath = savepath;
			}
		} { arg ex;
			ex.reportError;
			"Above error means track % can't infer saving path of player from name: %".format(track.key, player).postln;
		}
	
	},
));
TrackTemplateDef(\playertrack, (
	childClass: { TrackTemplateDef(\playerwrapper) },
	label: { arg self; 
		"%: playertrack".format(self.index)
	},

	new: { arg self, parent, index;
		self = ProtoClass((parent: self));

		self.index = index.asInteger;
		self.parentTrack = {parent};
		self[\storeOn] = { arg self, str; str << self.refCompileString };
		self.selectChild(0);
		self;
	},

	trackTemplate: { arg self;
		self.parent;
	},
	trackTemplate_: { arg self, val;
		self[\parent] = val;
		self.updateChildren;
	},

	updateChildren: { arg self;
		"updateChildren x".debug;
		self.initTrack;
		"updateChildren2".debug;
		self.children.do { arg child, idx;
			if(child.notNil) {
				if(child.isEmpty) {
					self.children[idx] = nil
				}
			}
		};	
		self.changed(\children);
	},


	activateChild: { arg self, idx;
		self.childAt(idx).play;
	},

	activeChild: { arg self;
		self.childAt(self.activeIndex ? 0);
	},

	makeListener: { arg self, fun;
		if(self.controllerList.notNil) {
			self.controllerList.remove;
		};
		self.controllerList = ProtoClass((
			list: List.new, 
			remove: { arg iself;
				iself.list.do(_.remove)
			})
		);
		self.children.do { arg child;
			var controller = child.makeListener(fun);
			self.controllerList.list.add(controller);
		};
		self.controllerList;
	},
	
	asPlayerEvent: { arg self;
		PlayerEvent((
			midinote: self.index,
			receiver: "{ % }".format(self.activeChild.asCompileString).interpret
		))
	},

	isEmpty: { arg self;
		self.children.every({ arg x; x.isNil or: {x.isEmpty} });
	},

	clearTrack: { arg self;
		self.children.do({ arg child, idx; 
			if(child.notNil) {
				child.clearTrack;
				self.children[idx] = nil;
			}
		});
	},


	source_: { arg self, array;
		array.collect({ arg val, idx;
			self.childAt(idx).source = val;
		})
	},

	source: { arg self;
		self.children.collect({ arg x; x.source });
	},

	refCompileString: { arg self;
		if(self.parentTrack.notNil) {
			"%.childAt(%)".format(self.parentTrack.refCompileString, self.index);
		} {
			"%(%)".format(self.class.asString, self.key);
		}
	},

	play: { arg self;
		self.activeChild.play;
		self.playHook;
	},

	playNow: { arg self;
		self.activeChild.playNow;
		self.playNowHook;
	},

	stopNow: { arg self;
		self.activeChild.stopNow;
		self.stopNowHook;
	},

	childPlayed: { arg self, fun;
		if(self.mixer.notNil) {
			self.mixer.play;
		};
		self.childPlayedHook(fun);
		if(fun.notNil) {
			fun.value(self);
		} {
			self.changed(\play, self.quant);
		}
	},

	quant: { arg self;
		self.childAt(0).quant;
	},

	quant_: { arg self, val;
		self.children.do({ arg x; x.quant = val });
	},

	isPlaying: { arg self;
		self.activeChild.isPlaying and: {
			self.mixer.isNil or: { self.mixer.isPlaying }
		};
	},

	stop: { arg self;
		self.activeChild.stop;
		self.stopHook;
		if(self.mixer.notNil) {
			//self.mixer.stop; // never stop mixers!
		};
		self.changed(\stop, self.quant);
	},

	childStopped: { arg self, fun;
		self.childStoppedHook(fun);
		if(fun.notNil) {
			fun.value(self);
		} {
			self.changed(\stop, self.quant);
		}
	},


	childAt: { arg self, idx;
		var ret;
		self.children = self.children ?? { SparseArray.new };
		ret = self.children[idx] ?? { 
			self.children[idx] = self.childClass.new(self, idx);
			self.children[idx];
		};
		ret;
	},

	existingChildren: { arg self;
		self.children.select { arg child, idx;
			child.notNil and: { child.isEmpty.not }
		}
	},

	// mimic modality
	elAt: { arg self ...args;
		self.childAt(*args)
	},

	gridPosToAbsPos: { arg self, pos;
		pos + self.parentTrack.gridOffset.y;
	},

	childAtOffset: { arg self, idx;
		self.childAt(self.gridPosToAbsPos(idx));
	},

	selectChild: { arg self, idx;
		self.selectedChild = idx; // to be deprecated, should be an object instead an index
		self.selectedIndex = idx;
		self.activeIndex = idx; // this one is the good one
		self.childProxy.source = self.childAt(idx).asPattern;
	},

	init_mixer_busses: { arg self;
		8.do { arg x;
			self.mixer.proxy.set(\sendbus+++x, BusDef(\sendbus+++x, \audio, self.mixer.numchannels))
		}
	},

	enableMixer: { arg self; // compat
		self.isMixerEnabled;
	},

	isMixerEnabled: { arg self;
		self.parentTrack.isMixerEnabled;
	},

	isMixerEnabled_: { arg self, val;
		self[\isMixerEnabled] = val;
		self.changed(\mixer);
	},

	enableAutoSetOutbus: { arg self;
		self.parentTrack.enableAutoSetOutbus;
	},

	isActive: { arg self;
		self.parentTrack.activeIndex == self.index;
	},

	mixer: { arg self;
		if(self.isMixerEnabled == true) {
			if(self.parentTrack.mixer.notNil) {
				self.parentTrack.mixer.tracks[self.index]
			} {
				if(self.mixer_obj.isNil and: {self.isEmpty.not}) {
					ParamProto.init;
					self.mixer_obj = ProtoClassDef(\TrackMixerDef).new(self.parentTrack.key+++"."+++self.index);
					self.mixer_obj[\soloModeHook] = { arg mself, val;
						// track is soloed, should mute all other tracks
						// val is true or false
						self.parentTrack.existingChildren.collect { arg child, idx;
							if(child !== self and: { child.mixer.notNil}) {
								child.mixer.muteBySolo(val);
							}
						};
					};
					self.mixer_obj.define_mixer;
					self.init_mixer_busses;
				};
				self.mixer_obj;
			}
		} {
			nil
		}
	},
));
TrackTemplateDef(\playergrid, (
	label: { arg self; "%".format(self.key) },
	protoClass: \playergrid,
	childClass: { TrackTemplateDef(\playertrack) },
	lineClass: { TrackTemplateDef(\lineplayer) },

	source_: { arg self, array;
		array.collect({ arg val, idx;
			self.childAt(idx).source = val;
		})
	},

	isActive: true, // compat when grid used as a cell in another grid

	gridOffset: { arg self;
		if(self.obj_gridOffset.isNil) {
			self.obj_gridOffset = Point(0,0);
		};
		self.obj_gridOffset
	},

	gridOffset_: { arg self, pos;
		//[pos, Point(pos.x.clip(0,inf), pos.y.clip(0,inf))].debug("expliquez moi comment c'est possible!");
		self.obj_gridOffset = Point(pos.x.clip(0,inf), pos.y.clip(0,inf));
		self.changed(\gridOffset);
	},

	makeListener: { arg self, fun;
		if(self.controllerList.notNil) {
			self.controllerList.remove;
		};
		self.controllerList = ProtoClass((
			list: List.new, 
			remove: { arg iself;
				iself.list.do(_.remove)
			})
		);
		self.children.do { arg child;
			var controller = child.makeListener(fun);
			self.controllerList.list.add(controller);
		};
		self.controllerList;
	},

	///////// archive saving system

	saveArchiveData: { arg self;
		FileSystemProjectDictionary(\TrackDef, self)[self.key] = self.asArchiveData;
	},

	fromArchiveData: { arg self, data;
		data.children.do({ arg child, idx; 
			self.children[idx] = child
		})
	},

	asArchiveData: { arg self;
		var data = ();
		data.children = self.children.collect { arg child;
			child.asArchiveData
		};
	},

	///////// presetCompileString saving system

	savePresetCompileString: { arg self;
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

	loadPresetCompileString: { arg self;
		self.resources.do { arg res;
			PlayerWrapper(res).loadPresetCompileString;
		}; 
		self.children.do({ arg column;
			column.children.do({ arg track;
				track.loadPresetCompileString;
			})
		});
	},

	presetCompileStringSavePath_: { arg self, val;
		self[\presetCompileStringSavePath] = val;
		self.children.do({ arg column;
			column.children.do({ arg track;
				track.presetCompileStringSavePath = val;
			})
		});
		"===== setting path of resources".debug;
		self.resources.do { arg track;
			PlayerWrapper(track).presetCompileStringSavePath = val +/+ "%_%.scd".format(PlayerWrapper(track).targetClass, track.key);
		};
	},


	/////////

	source: { arg self;
		self.children.collect({ arg x; x.source });
	},

	proxy: { arg self;
		PlayerWrapperGroup(self.children);
	},

	children: { arg self;
		self[\obj_children] ?? { 
			self[\obj_children] = SparseArray.new;
			self[\obj_children];
		};
	},

	existingChildren: { arg self;
		self.children.select { arg child, idx;
			child.notNil and: { child.isEmpty.not }
		}
	},

	linePlayers: { arg self;
		self[\obj_linePlayers] ?? { 
			self[\obj_linePlayers] = SparseArray.new;
			self[\obj_linePlayers];
		};
	},

	childAt: { arg self, idx, idx2;
		var ret;
		if(idx.isSequenceableCollection) {
			idx.collect({ arg x; self.childAt(x) })
		} {
			if(idx.isKindOf(Point)) {
				idx2 = idx.y;
				idx = idx.x;
			};
			ret = self.children[idx] ?? { 
				self.children[idx] = self.childClass.new(self, idx);
				self.children[idx];
			};
			if(idx2.notNil) {
				ret.childAt(idx2)
			} {
				ret;
			}
		}
	},

	// mimic modality
	elAt: { arg self ...args;
		self.childAt(*args)
	},


	gridPosToAbsPos: { arg self, pos;
		pos + self.gridOffset;
	},

	childAtOffset: { arg self, pos;
		if(pos.isKindOf(Point)) {
			self.childAt(self.gridPosToAbsPos(pos));
		} {
			self.childAt(self.gridPosToAbsPos(Point(pos,0)).x);
		}
	},

	play: { arg self;
		self.children.do(_.play);
	},

	stop: { arg self;
		self.children.do(_.stop);
	},

	isPlaying: { arg self;
		self.children.any({ arg x; x.notNil and: {x.isPlaying} });
	},

	quant: { arg self;
		self.childAt(0).quant;
	},

	quant_: { arg self, val;
		// disable for the moment
		// when PlayerEvent set quant to 0 just before playing, all various quant are lost
		//self.children.do({ arg x; x.quant = val });
	},

	edit: { arg self;
		var wkey = \Grid_ +++ self.key;
		var editor;
		if(WindowDef(\customgrid).notNil) {
			editor = \customgrid;
		} {
			editor = \playergrid;
		};
		if(WindowDef(wkey).isNil) {
			WindowDef(wkey, WindowDef(editor)).front(self);
			{
				WindowDef(wkey).window.bounds =  Rect(144, 217, 1090, 438);
			}.defer(1)
		} {
			WindowDef(wkey, WindowDef(editor)).front(self);
		}
	},

	refCompileString: { arg self;
		self.asCompileString;
	},

	activate: { arg self;
		~launchpad_playergrid.new(self).activate
	},

	linePlayerAt: { arg self, idx;
		if(self.linePlayers[idx].isNil) {
			self.linePlayers[idx] = self.lineClass.new(self, idx);
		}; 
		self.linePlayers[idx];
	},

	linePlayerAtOffset: { arg self, idx;
		self.linePlayerAt(idx + self.gridOffset.y);
	},

	initFromPresetDir: { arg self, path, force=false;
		if(self.presetCompileStringSavePath.isNil or: { force == true }) {
			self.presetCompileStringSavePath = path;
			self.loadPresetCompileString;
		} {
			"Load Aborted! %.presetCompileStringSavePath is already defined, might override current presets".format(self).postln;
		}
	},


	enableAutoSetOutbus: true,
	enableMixer: { arg self; // compat
		self.isMixerEnabled;
	},
	isMixerEnabled: true,
	//mixer:nil, // TODO: make a container for child mixers here with handy methods

	selectChild: { arg self, idx;
		self.activeIndex = idx; // this one is the good one
	},

	activeIndex_: { arg self, val;
		self[\activeIndex] = val;
		self.changed(\activeIndex);
	},

	isEmpty: { arg self;
		self.existingChildren.any({ arg x; x.isEmpty.not })
	},


	//// controller

	controller_: { arg self, con;
		self[\controller] = con;
		con.startControl(self);
	},

));

TrackTemplateDef(\lineplayer, (
	new: { arg self, parent, idx; 
		self = self.deepCopy;
	
		
		self.parentTrack = { parent };
		self.index = idx; // line index
	
		self;
	},
	label: { arg self;
		"% line %".format(self.parentTrack.label, self.index.asInteger)
	},
	isLinePlayer: true,

	quant: { arg self;
		Pdef.defaultQuant;
	},

	play: { arg self;
		["play"].postln;
		self.children.do({ arg x, ii; 
			["play", ii, x].postln;
			x.play;
		});
		self.changed(\play, self.quant);
		self.changed(\PlayerWrapper, \userPlayed); // the view put directly the ProtoDef so need to simulate PlayerWrapper
		PlayerWrapper.doWithQuant(self.quant, {
			self.changed(\PlayerWrapper, \playing); // the view put directly the ProtoDef so need to simulate PlayerWrapper
		});
		//self.play;
	},

	playNow: { arg self;
		["play now"].postln;
		self.children.do({ arg x, ii; 
			["play now", ii, x].postln;
			x.playNow;
		});
		self.changed(\PlayerWrapper, \playing); // the view put directly the ProtoDef so need to simulate PlayerWrapper
	},

	stop: { arg self;
		["stop"].postln;
		self.children.do({ arg x, ii; 
			["stop", ii, x].postln;
			x.stop;
		});
		self.changed(\stop);
		self.changed(\PlayerWrapper, \userStopped); // the view put directly the ProtoDef so need to simulate PlayerWrapper
		PlayerWrapper.doWithQuant(self.quant, {
			self.changed(\PlayerWrapper, \stopped); // the view put directly the ProtoDef so need to simulate PlayerWrapper
		});
		//parent.stop;
	},

	stopNow: { arg self;
		["stop now"].postln;
		self.children.do({ arg x, ii; 
			["stop now", ii, x].postln;
			x.stopNow;
		});
		self.changed(\stop);
		self.changed(\PlayerWrapper, \stopped); // the view put directly the ProtoDef so need to simulate PlayerWrapper
	},

	trackingMethod: \any,

	existingChildren: { arg self;
		self.children.select { arg child, idx;
			child.notNil and: { child.isEmpty.not }
		}
	},

	isEmpty: { arg self;
		self.existingChildren.size == 0
	},

	isPlaying: { arg self;
		// should be:
		// - at least one cell is playing
		//		- allow to stop the cells playing
		// or
		// - every cell that is not empty is playing
		//		- allow to play the cells not playing
		if(self.trackingMethod == \any) {
			// any
			self.children.any({ arg child, idx;
				child.isPlaying;
			})
		} {
			// every
			self.children.every({ arg child, idx;
				child.isNil or: {child.isEmpty or: child.isPlaying};
			})
		}

		//["lineplayer: isPlaying",parent.isPlaying, self.children.every({ arg x; x.activeIndex == idx })].postln;
		//self.parentTrack.isPlaying and: {
			//var atLeastOneIsPlaying = false;
			//self.children.every({ arg x, ii; 
				////["child:", x,ii, x.activeIndex, idx].postln;
				//x.notNil and: {x.parentTrack.isEmpty or: {
					//if(x.parentTrack.activeIndex == self.index) {
						//atLeastOneIsPlaying = true;
						//true;
					//} {
						//false;
					//}
				//}}
			//}) and: { atLeastOneIsPlaying };
		//};
	},

	asPatternAbs: { arg self, startPosition, endPosition, repeatCount;
		var relStartTime, totalDur;
		var eventlist = self.eventList;
		// currentlty, startPosition and endPosition are in absolute time in the GUI, but will be relative to start event in futur
		// this code translate absolute in relative (to start event)

		// this is the time between first event absTime and asked start time
		// because silence before first event can't be counted in Pembed
		// if startPosition is before first event, relStartTime is negative, not handled by Pembed for the moment
		// relStartTime need to be relative to the first event, because Pembed only see the relative time to the first event and doesn't read \absTime
		
		relStartTime = {
			var sp = startPosition.value;
			if(sp.isNil) {
				self.eventList.relStartTime; // start time relative to first event
			} {
				var xx;
				xx = ( sp - self.eventList.firstTime ).clip(0,inf); // now relStartTime is independent of start event
				self.eventList.firstTime max: xx; // now relStartTime is always after first event
			};

		};

		// total dur is absEnd - absStart (eventlist.totalDur is already that)
		totalDur = {
			var absStart = relStartTime.value + self.eventList.firstTime;
			var ep = endPosition.value;
			var xx;
			if(ep.notNil and:{ep - absStart < 0.01}) { // prevent too short cursor loop
				ep = eventlist.endTime;
			};
			//xx = if(ep.isNil) {
				////totalDur = self.eventloop.list.totalDur - (startPosition - eventlist.startTime ).clip(0,inf);
				//self.eventlist.totalDur;
			//} {
				////totalDur = endPosition - (startPosition ? eventlist.startTime);
				//(( ep ? eventlist.endTime ) - absStart);
			//};
			xx = (( ep ? eventlist.endTime ) - absStart);
			// prevent empty (infinite loop)
			if(xx < 0.01) {
				Log(\Param).debug("timeline.asPattern: loop too short, setting it to 2: xx", xx);
				2;
			} {
				xx
			}
		};

		//[startPosition, endPosition, relStartTime, totalDur].collect(_.value).debug("asPatternAbs: start, end, relstart, totdur");
		self.asPattern(relStartTime, totalDur, repeatCount);
	},

	bypass_pattern: { arg self, pat;
		Pcollect({ arg ev;
			//"entering pcollect".debug;
			ev = ev.copy;
			if(self.tracks_bypassed.notNil and: {self.tracks_bypassed.includes(ev.use({ev.midinote}))}) {
				ev[\type] = \rest;
				ev[\eventType] = nil;
				ev[\nodeType] = nil;
			};
			//"ending pcollect".debug;
			ev;
		}, pat)	
	},

	makeEventList: { arg self, totalDur = 1;
		var el = TimelineEventList.new;
		el.start(0);
		self.children.select(_.isEmpty.not).do({ arg child, idx; 
			var ev = child.asPatternEvent;
			ev[\absTime] = 0;
			ev[\sustain] = totalDur;
			el.addEvent(ev)
		});
		el.finish(totalDur);
		el;
	},

	repeatCount: inf,

	refCompileString: { arg self;
		"TrackDef(%).linePlayerAt(%)".format(self.parentTrack.key.asCompileString, self.index.asCompileString);
	},

	presetCompileString: { arg self;
		if(self[\label].isKindOf(Function).not) {
			"%.label = %;".format(self.refCompileString, self.label.asCompileString)
		} {
			nil
		}
	},

	asPattern: { arg self, relStartTime, totalDur=1000, repeatCount;
		var pat;
		pat = Plazy({
			var eventlist = self.makeEventList(totalDur);
			var xrelStartTime, xtotalDur;

			xrelStartTime = relStartTime.value ? eventlist.relStartTime;
			xtotalDur = totalDur.value ? eventlist.totalDur;

			//[xrelStartTime, xtotalDur].debug("clip xasPattern: plazy: relstart, totdur");
			if(xtotalDur <= 0) {
				"ERROR: totalDur is negative or zero".postln;
				xtotalDur = 2
			};

			eventlist.changed(\cursor, \play); // FIXME: should be an event
			Pfindur(xtotalDur, Pembed(
				self.bypass_pattern( Pn(eventlist.clone, 1) ),
				xrelStartTime
			));
		}).repeat(repeatCount ? self.repeatCount);
		pat;
	},

	children: { arg self;
		self.parentTrack.children.asArray.collect({ arg x; x.childAt(self.index) });
	},
));


// backward compat 
TrackDef(\playerwrapper, TrackTemplateDef(\playerwrapper));
TrackDef(\playertrack, TrackTemplateDef(\playertrack));
TrackDef(\playergrid, TrackTemplateDef(\playergrid));

WindowDef(\mixerView_large, { arg me, track;
	var param;
	var sends = [];
	if(track.isKindOf(Volume)) {
		param = Param(track, \volume);
	} {
		param = track.mixer.asParam(\postfader);
		sends = 4.collect({ arg x; track.mixer.asParam(\send+++x) });
	};
	VLayout(
		param.asSlider.orientation_(\vertical),
		param.asTextField,
		VLayout(*
			sends.clump(2).collect { arg subsends;
				HLayout(* subsends.collect({ arg pa;
					pa.asKnob;
				}))
			}
		)
	)
});
WindowDef(\mixerView_static, { arg me, track;
	var param;
	var sends = [];
	if(track.isKindOf(Volume)) {
		param = Param(track, \volume);
	} {
		param = track.mixer.asParam(\postfader);
		sends = 4.collect({ arg x; track.mixer.asParam(\send+++x) });
	};
	VLayout(
		HLayout(
			VLayout (
				param.asSlider.orientation_(\vertical),
				param.asTextField,
			),
			VLayout(*
				sends.clump(2).collect { arg subsends;
					VLayout(* subsends.collect({ arg pa;
						pa.asKnob;
					}))
				}
			)
		)
	)
});
WindowDef(\mixerView, { arg me, track;
	var param;
	var sends = [];
	var layout;
	var slider, knobs = List.new, textfield;
	layout = VLayout(
		HLayout(
			VLayout (
				slider = Slider.new.orientation_(\vertical),
				textfield = TextField.new,
			),
			VLayout(*
				knobs = 4.collect({ 
					Knob.new;
				})
			)
		)
	);
	layout.addUniqueMethod(\model_, { arg me, track;
		if(track.isKindOf(Volume)) {
			//"volume".debug;
			param = Param(track, \volume);
			sends = 4.collect({ arg x; nil });
		} {
			//"track".debug;
			param = track.mixer.asParam(\postfader);
			sends = 4.collect({ arg x; track.mixer.asParam(\send+++x) });
		};
		//[slider, param].debug("slider, param: what ?");
		slider.mapParam(param);
		textfield.mapParam(param);
		knobs.do({ arg x, idx; x.mapParam(sends[idx]) })
	});
	if(track.notNil) {
		layout.model = track;
	};
	layout.addUniqueMethod(\slider, { slider });
	layout.addUniqueMethod(\textfield, { textfield });
	layout.addUniqueMethod(\knobs, { knobs });
	layout;
});

WindowDef(\playergrid, { arg me, maintrack;
	var viewgrid;
	var mainview;
	var make_view;
	var playerviews;
	var map_players;
	var mixerviews;
	maintrack = maintrack ?? { TrackDef(\main) };
	
	// commented because at caller level
	//if(me.window.notNil) {
	//	me.window.bounds = Rect(144, 217, 1090, 438);
	//};

	mainview = View.new;
	mainview.onChange(maintrack, \gridOffset, { {map_players.()}.defer });

	playerviews = { { PlayerWrapperGridCellView.new } ! 8 } ! 9;
	//mixerviews = { WindowDef(\mixerView).asView } ! 9;
	mixerviews = 9.collect({ arg x;
			var boxview;
			var delayview;
			var child;
			var mixer;
			var mixerview;
			if(maintrack.isMixerEnabled == false) {
				nil
			} {
				boxview = View.new;
				child = maintrack.childAtOffset(x);
				if(child.notNil) {
					mixer = child.mixer;
					delayview = TextField.new;
					if(mixer.notNil) {
						delayview.mapParam( Param(mixer.proxy, \postdelay, ControlSpec(0,0.1,\lin)) );
						boxview.layout = VLayout (
							PlayerWrapper(mixer.proxy).label_(mixer.key).asView.font_(Font.default.copy.size_(8)),
							mixerview = WindowDef(\mixerView).asView(child),
							HLayout(StaticText.new.string_("postdelay:"), delayview),
						);
						mixerview.slider.minWidth_(10);
						boxview.background = Color.gray;
						boxview.maxWidth_(260);
						boxview.addUniqueMethod(\model_, { arg me, val;
							mixerview.model = val;
						});
					};
				} {
					boxview.addUniqueMethod(\model_, { arg me, val;
						// NOOP
					});
				};
				if(mixer.notNil) {
					boxview;
				} {
					nil // NOTE: return nil of no mixer defined, change if we want to dynamically load mixer
				}
			}
	});

	if(me.window.notNil) {
		me.window.name = "playergrid: " ++ maintrack.key;
	};

	map_players = {
		playerviews.do({ arg track, x;
			track.do { arg child, y;
				if(x == 8) {
					child.model = maintrack.linePlayerAt(y+maintrack.gridOffset.y);
				} {
					child.model = maintrack.childAtOffset(Point(x,y));
				}
			};
		});
		mixerviews.do({ arg child, x;
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
							} 
						});
						view.layout.margins_(1);
						view.button.fixedWidth_(20);
						//view.labelView.fixedWidth_(49);
						//view.fixedSize_(Point(300,20));
						view.labelView.font_(Font.default.size_(10));
						//child.model.target.debug("childmodeltarget");
						//if(child.model.target.isEmpty == true) {
							//child.color_deselected = Color.gray;
						//};
						child.selected = false;
						view.labelView.mouseDownAction_({ arg label, x, y, modifiers, buttonNumber, clickCount;
							//"DOWN".debug;
							//view.selected = true
						});
						view;
					})
					++ [ mixerviews[idx] ]
				})
			).vSpacing_(1).hSpacing_(1),
			nil
		)
	};
	map_players.();
	make_view.();
});
WindowDef(\playergrid_OLD, { arg me, maintrack;
	var viewgrid;
	var mainview;
	var make_view;
	maintrack = maintrack ?? { TrackDef(\main) };

	mainview = View.new;
	mainview.onChange(maintrack, \gridOffset, { {make_view.()}.defer });

	make_view = {
		mainview.removeAll;
		mainview.layout = VLayout(
			GridLayout.columns(*
				viewgrid = 
				8.collect ({ arg x;
					var track = maintrack.childAtOffset(x);
					8.collect({ arg y;
						var clip = track.childAtOffset(y);
						PlayerWrapperSelectorView(PlayerWrapper(clip)).asView;
					})
					++ WindowDef(\mixerView).asView(track);
				}) 
				++ [
					8.collect({ arg y;
						var clip = maintrack.linePlayerAt(y);
						PlayerWrapperSelectorView(PlayerWrapper(clip)).asView;
					})
					++ WindowDef(\mixerView).asView(Server.default.volume);
				]
			),
			nil
		)
	};
	make_view.()
});

~lazy_property = { arg me, name, initfun;
	me[name] = { arg self;
		self['property_'+++name] ?? {
			self['property_'+++name] = initfun.(self);
			self['property_'+++name]
		}
	};
	me[name+++'_'] = { arg self, val;
		self['property_'+++name] = val
	};
};
~launchpad_playergrid = ProtoClass((
	new: { arg self, grid;
		self = self.deepCopy;
	
		self.grid = grid;
		self.flash_colors = self.colors.collect({ arg x; x - 0x0c });
		//~lazy_property.(self, \quickpad, { { nil ! ( self.gridsize.y+1 ) } ! ( self.gridsize.x+1 ) });
		//self.clearAll;
		if(self.ktl.device.notNil) {
			self.ktl.sendSpecialMessage(\enableFlashMode);
		};
	
		self;
	},

	clearAll: { arg self;
		self.ktl.sendSpecialMessage(\clearAll);
		self.ktl.sendSpecialMessage(\enableFlashMode);
	},

	quickpad: { arg self;
		var name = \quickpad;
		self['property_'+++name] ?? {
			self['property_'+++name] = { { nil ! ( self.gridsize.y+1 ) } ! ( self.gridsize.x+1 ) };
			self['property_'+++name]
		}
	},

	quickpad_: { arg self, val;
		var name = \quickpad;
		self['property_'+++name] = val
	},

	colors: (
			red: 0x0f,
			red2: 0x0e,
			dimred: 0x0d,
			green: 0x3c,
			green2: 0x2c,
			dimgreen: 0x1c,
			yellow: 0x3e,
			orange: 0x2f,
			amber: 0x3f,
			off: 4, // set both buffers to black
	),

	gridsize: Point(8,8),

	gridOffset_: { arg self, val;
		self.grid.gridOffset = val;
		self.render_grid;
	},

	gridOffset: { arg self;
		self.grid.gridOffset;
	},

	ktl: { 
		MKtl(\lp, "novation-launchpad-s");
	},

	padAt: { arg self, pos;
		//pos.debug("padAt");
		self.ktl.elAt(\pad, pos.x+( pos.y*self.gridsize.x ));
	},

	setColorAt: { arg self, pos, color, mode;
		//[pos, color].debug("setColorAt");
		if(mode == \flash) {
			color = color - 0x0c;
		};
		self.padAt(pos).elAt(\on).value = color/127;
	},

	render_cell: { arg self, pos, isPlaying, mode;
		// playerWrapper to pad
		var color;
		var child = self.grid.childAtOffset(pos);
		if(child.isEmpty == true) {
			color = \off
		} {
			//[isPlaying, child.isPlaying].debug("render_cell: is, chiisp");
			isPlaying = isPlaying ?? { child.isPlaying };
			if(isPlaying) {
				color = \green;
			} {
				if(child.isActive) {
					color = \red;
				} {
					color = \yellow;
				}
			};
		};
		color = self.colors[color];
		self.setColorAt(pos, color, mode);
	},

	render_linebutton: { arg self, idx;
		var clip = self.grid.linePlayerAt(idx);
		if(clip.isPlaying) {
			self.ktl.elAt(\arr, idx).value = self.colors.green;
		} {
			self.ktl.elAt(\arr, idx).value = self.colors.off;
		};
	},

	render_grid: { arg self;
		self.gridsize.x.do { arg x;
			self.gridsize.y.do { arg y;
				var pos = Point(x, y);
				self.render_cell(pos);
				self.listenAt(pos);
			}
		};
		self.gridsize.y.do { arg x;
			self.render_linebutton(x)
		};
		self.makeListeners;
	},

	controllers: { arg self;
		var k = self.ktl.getHalo(\controllers);
		if(k.isNil) {
			k = { nil ! ( self.gridsize.y + 1 )} ! ( self.gridsize.x + 1 );
			self.ktl.addHalo(\controllers, k)
		};
		k
	},

	controllers_dict: { arg self;
		var k = self.ktl.getHalo(\controllers_dict);
		if(k.isNil) {
			k = IdentityDictionary.new;
			self.ktl.addHalo(\controllers_dict, k)
		};
		k
	},

	listenAt: { arg self, pos;
		var player = PlayerWrapper(self.grid.childAtOffset(pos));
		if(self.controllers[pos.x][pos.y].notNil) {
			self.controllers[pos.x][pos.y].remove;
		};
		self.controllers[pos.x][pos.y] = player.makeListener({ arg me, msg, args;
			//{
			//[msg, args].debug("listenat!!");
				self.render_cell(pos, msg == \play, \flash);
				player.doWithQuant {
					self.render_cell(pos);
				};
			//}.defer(1)
		});
	},

	makeListeners: { arg self;
		if(self.controllers_dict[\gridOffset].notNil) {
			self.controllers_dict[\gridOffset].remove;
		};
		self.controllers_dict[\gridOffset] = SimpleController(self.grid).put(\gridOffset, {
			self.render_grid;
		});
	},

	activate: { arg self;
		var move_in_grid;
		if(FileSystemProject.current.isNil) {
			FileSystemProject.current = ();
		};
		FileSystemProject.current.current_trackgrid = { self.grid };
		self.ktl.elAt(\bt, \bt_user2).action = { arg el;
			self.edit_mode = ( el.value != 0 );
			self.edit_mode.debug("edit mode!");
		};
		self.ktl.elAt(\bt, \bt_mixer).action = { arg el;
			self.modifier_mixer = ( el.value != 0 );
			self.modifier_mixer.debug("mixer mode!");
		};
		self.ktl.elAt(\pad).do { arg pad, idx;
			pad.elAt(\on).action = {
				var point = Point(idx % self.gridsize.x, ( idx/self.gridsize.x ).asInteger);
				if(self.edit_mode == true) {
					{
						self.grid.childAtOffset(point).edit;
					}.defer;
				} {
					if(self.modifier_mixer == true) {
						//point.debug("what ?");
						//self.quickpad[point.x][point.y].debug("2what ?");
						self.quickpad[point.x][point.y].value(self, point);
						//self.quickpad[point.x][point.y].debug("end what ?");
					} {
						PlayerWrapper(self.grid.childAtOffset(point)).togglePlay;
					};
				}
			};
			pad.elAt(\off).action = {
				//self.grid.childAt(idx % self.gridsize.x, ( idx/self.gridsize.x ).asInteger).stop;
			};
		};
		self.ktl.elAt(\arr).do { arg pad, idx;
			pad.action = {
				PlayerWrapper(self.grid.linePlayerAt(idx + self.gridOffset.y)).togglePlay;
			};
			//pad.action = {
			//	//self.grid.childAt(idx % self.gridsize.x, ( idx/self.gridsize.x ).asInteger).stop;
			//};
		};

		// debug
		//self.ktl.elAt(\bt, 0).action = { self.render_grid; "refresh!!!!".debug };
		move_in_grid = { arg el, offset;
			//el.value.debug("drole!!");
			if(el.value == 0) {

			} {
				self.gridOffset = self.gridOffset + offset;
			}
		};
		self.ktl.elAt(\bt, 0).action = { arg el; move_in_grid.(el, Point(0,-1)) };
		self.ktl.elAt(\bt, 1).action = { arg el; move_in_grid.(el, Point(0,1)) };
		self.ktl.elAt(\bt, 2).action = { arg el; move_in_grid.(el, Point(-1,0)) };
		self.ktl.elAt(\bt, 3).action = { arg el; move_in_grid.(el, Point(1,0)) };

		//self.clearAll;
		self.render_grid;
	},
));
ProtoDef(\lauchpad_offsetgrid, (
	parent: ~launchpad_playergrid,
	render_cell: { arg self, pos, isPlaying, mode;
		// playerWrapper to pad
		var color;
		var offsetpos = pos*8;
		var child = self.grid.childAtOffset(offsetpos);
		if(child.isEmpty == true) {
			color = \off
		} {
			//[isPlaying, child.isPlaying].debug("render_cell: is, chiisp");
			isPlaying = isPlaying ?? { child.isPlaying };
			if(isPlaying) {
				color = \green;
			} {
				if(child.isActive) {
					color = \red;
				} {
					color = \yellow;
				}
			};
		};
		color = self.colors[color];
		self.setColorAt(pos, color, mode);
	},
	activate: { arg self;
		var move_in_grid;
		if(FileSystemProject.current.isNil) {
			FileSystemProject.current = ();
		};
		FileSystemProject.current.current_trackgrid = { self.grid };
		self.ktl.elAt(\bt, \bt_user2).action = { arg el;
			self.edit_mode = ( el.value != 0 );
			self.edit_mode.debug("edit mode!");
		};
		self.ktl.elAt(\bt, \bt_mixer).action = { arg el;
			self.modifier_mixer = ( el.value != 0 );
			self.modifier_mixer.debug("mixer mode!");
		};
		self.ktl.elAt(\pad).do { arg pad, idx;
			pad.elAt(\on).action = {
				var point = Point(idx % self.gridsize.x, ( idx/self.gridsize.x ).asInteger);
				if(self.edit_mode == true) {
					{
						self.grid.childAtOffset(point).edit;
					}.defer;
				} {
					if(self.modifier_mixer == true) {
						//point.debug("what ?");
						//self.quickpad[point.x][point.y].debug("2what ?");
						self.quickpad[point.x][point.y].value(self, point);
						//self.quickpad[point.x][point.y].debug("end what ?");
					} {
						self.gridOffset = Point(idx % 8, ( idx / 8 ).trunc);
					};
				}
			};
			pad.elAt(\off).action = {
				//self.grid.childAt(idx % self.gridsize.x, ( idx/self.gridsize.x ).asInteger).stop;
			};
		};
		self.ktl.elAt(\arr).do { arg pad, idx;
			pad.action = {
				PlayerWrapper(self.grid.linePlayerAt(idx + self.gridOffset.y)).togglePlay;
			};
			//pad.action = {
			//	//self.grid.childAt(idx % self.gridsize.x, ( idx/self.gridsize.x ).asInteger).stop;
			//};
		};

		// debug
		//self.ktl.elAt(\bt, 0).action = { self.render_grid; "refresh!!!!".debug };
		move_in_grid = { arg el, offset;
			//el.value.debug("drole!!");
			if(el.value == 0) {

			} {
				self.gridOffset = self.gridOffset + offset;
			}
		};
		self.ktl.elAt(\bt, 0).action = { arg el; move_in_grid.(el, Point(0,-1)) };
		self.ktl.elAt(\bt, 1).action = { arg el; move_in_grid.(el, Point(0,1)) };
		self.ktl.elAt(\bt, 2).action = { arg el; move_in_grid.(el, Point(-1,0)) };
		self.ktl.elAt(\bt, 3).action = { arg el; move_in_grid.(el, Point(1,0)) };

		//self.clearAll;
		self.render_grid;
	},

));
);




// END
TrackDef(\sco4).edit;

MKtl(\lp).elAt(\bt)

~trackTimeline.new(TrackDef(\main)).edit
(
	// ======== init tracks

TrackDef(\main).clear;
TrackDef(\main, TrackDef(\playergrid));
TrackDef(\main).childAt(0,0).source = Pdef(\kick);
TrackDef(\main).childAt(1,0).source = Pdef(\snare);
TrackDef(\main).childAt(2,0).source = Pdef(\hat);
TrackDef(\main).childAt(3,0).source = Pdef(\lide);
TrackDef(\main).childAt(4,0).source = Pdef(\hydro);
TrackDef(\main).childAt(4,1).source = Pdef('hydro.1');
TrackDef(\main).childAt(4,2).source = Pdef('hydro.2');
TrackDef(\main).childAt((0..4)).collect(_.quant_(8));
TrackDef(\main).activate;

)
TrackDef(\main).childAt((0..4))


TrackDef(\main).children
TrackDef(\main).childAt(0,1).source = nil
TrackDef(\main).childAt(0,1).mixer.sendParam(1)

Param(TrackDef(\main).childAt(0,0).proxy.target , \out).get
TrackDef(\main).childAt(0,0).mixer.inbus
TrackDef(\main).childAt(0,0).mixer.isPlaying
TrackDef(\main).childAt(0,0).mixer.outbus
TrackDef(\main).childAt(0,0).mixer.proxy.edit
TrackDef(\main).childAt(0,0).mixer.define_mixer
TrackDef(\main).childAt(0,0).mixer.proxy.stop
TrackDef(\main).childAt(0,0).mixer.play
TrackDef(\main).childAt(0,0).mixer.proxy.clear

W
PlayerWrapper(Pdef(\kick)).outBus
PlayerWrapper(Pdef(\kick)).doWithQuant{ "hello".postln }
PlayerWrapper(Pdef(\kick)).play
TrackDef(\main).childAt(0,0).stop
TrackDef(\main).childAt(0,0).play
TrackDef(\main).childAt(0).play
TrackDef(\main).childAt(0,0).proxy.play
TrackDef(\main).edit
TrackDef(\main).activate
TrackDef(\main).linePlayerAt(0).isPlaying
TrackDef(\main).linePlayerAt(0).play
TrackDef(\main).linePlayerAt(1).play
TrackDef(\main).linePlayerAt(0).stop

0.dbamp


(
~launchpad_playergrid.new(TrackDef(\main)).activate
)
MKtl(\lp).postElements
MKtl(\lp).elAt(\pad, 0, \on).value = 0.2
TrackDef(\main).childAt(0).quant = 4

ProjectDef()

FileSystemResolver.new.paths_(["/home"]).resolve("ggz")

FileSystemProject.paths = ["/home/ggz/code/sc/seco/vlive", "/home/ggz/code/sc/seco/vlive/repeat"];
FileSystemProject.addPath(["/home/ggz/code/sc/seco/vlive", "/home/ggz/code/sc/seco/vlive/repeat"]);
FileSystemProject.load("proto1/perc.scd")
FileSystemProject.load("lib/tracks.scd")
FileSystemProject.cwd = "proto1";
FileSystemProject.load("perc.scd")
FileSystemProject(\proto1)
FileSystemProject(\proto1).path
FileSystemProject(\proto1).open
FileSystemProject(\proto1).open
FileSystemProject(\proto1, TrackDef(\basicproject))
ThisProject.defaultQuant = 2;
ThisProject.tempo = 2;
	// run init.scd, protect from recursive call
	// set cwd

