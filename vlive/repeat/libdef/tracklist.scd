
(
ParamProto.init;
FileSystemProject.load("libdef/tracks.scd");
FileSystemProject.load("libdef/drumkit.scd");
FileSystemProject.load("libdef/synthplayrec.scd");
FileSystemProject.load("libdef/MainProject.scd");

TrackTemplateDef(\TrackList, TrackTemplateDef(\playergrid)).putAll((
	childClass: { arg self;
		TrackTemplateDef(\TrackListChannel);
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
		var newtrack;
		var lastidx = -1;
		var trackkey;
		block  { arg break;
			self.children.do { arg child, childidx;
				lastidx = childidx;
				if(self.childAt(childidx).isEmpty) {
					Log(\Param).debug("found empty track: %", childidx);
					newtrack = child;
					break.value;
				}
			};
			Log(\Param).debug("grid.addTrack: no empty track found, use %", lastidx+1);
			newtrack = self.childAt(lastidx+1);
		};

		trackkey = "%.%".format(self.key, newtrack.index).asSymbol;
		newtrack.libId = libId;
		newtrack.label = label ? ProtoDef(\GlobalLibrary).libIdToStrings(libId).join(" ");
		newtrack.instrument = ProtoDef(\GlobalLibrary).libIdToTrackInstrument(libId, trackkey);
		newtrack.outBus = 0;
		Log(\Param).debug("newtrack.instrument:%", newtrack.instrument);
		self.changed(\tracklist);
	},

	removeTrack: { arg self, index;
		self.childAt(index).clearChannel;
		self.changed(\tracklist);
	},

	edit: { arg self;
		WindowDef(\tracklist).front(self);
	},

	savePresetCompileString: { arg self, path, onDoneAction;
		if(File.exists(self.presetCompileStringSavePath).not or: {self.loadedFromPath == self.presetCompileStringSavePath}) {
			File.mkdir(self.presetCompileStringSavePath);
			self.loadedFromPath = self.presetCompileStringSavePath;
			path = path ? (self.presetCompileStringSavePath +/+ "TrackDef_%.scd".format(self.key));
			PlayerWrapper_Base.savePresetCompileStringHelper(path, onDoneAction, self.refCompileString, self.presetCompileString, false);
			self.dataPath.mkdir;
			self.children.do({ arg column;
				column.savePresetCompileString;
			});
			self.resources.do { arg res;
				PlayerWrapper(res).savePresetCompileString;
			}; 
			Log(\Param).info("TrackList % saved.", self.key);
		} {
			"savePresetCompileString: can't save on existing project".error;
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
		self.presetCompileStringSavePath +/+ "TrackDef_%/".format(self.key);
	},

	presetCompileStringSavePath_: { arg self, val;
		self[\presetCompileStringSavePath] = val;
		"===== saving resources".debug;
		self.resources.do { arg track;
			PlayerWrapper(track).presetCompileStringSavePath = "%%_%.scd".format(val, PlayerWrapper(track).targetClass, track.key);
		};
	},

	loadedFromPath: nil,
));

TrackTemplateDef(\TrackListChannel, TrackTemplateDef(\playertrack)).putAll((
	childClass: { arg self;
		TrackTemplateDef(\TrackListChannelPart);
	},

	isEmpty: { arg self;
		self.instrument.isNil and: {
			self.children.every({ arg x; x.isNil or: {x.isEmpty} });
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

	presetCompileString: { arg self;
		if(self.isEmpty) {
			nil
		} {
			var str = List[];

			str.add("%.instrument = ProtoTemplateDef('TrackInstrument').new(%);".format(self.refCompileString, self.instrument.libId.asCompileString));
			str.add("%.label = %;".format(self.refCompileString, self.label.asCompileString));
			str.join($\n)
		}
	},

	refCompileString: { arg self;
		"TrackDef(%).childAt(%)".format(self.parentTrack.key.asCompileString, self.index.asCompileString);
	},


	savePresetCompileString: { arg self, path, onDoneAction;
		if(self.isEmpty.not) {
			//[path, this.presetCompileStringSavePath, args].debug("PlayerWrapper_ProtoClass.savePresetCompileString");

			var file;
			path = path ? self.presetCompileStringSavePath;
			path.debug("save path");
			PlayerWrapper_Base.savePresetCompileStringHelper(path, onDoneAction, self.refCompileString, self.presetCompileString, false);

			self.children.do({ arg track;
				track.savePresetCompileString;
			})
		}
	},

	presetCompileStringSavePath: { arg self;
		self.parentTrack.dataPath +/+ "TrackDef_%.%.scd".format(self.parentTrack.key, self.index);
	},

	loadPresetCompileString: { arg self;
		FileSystemProject.load(self.presetCompileStringSavePath, silent:true);
		32.do({ arg idx;
			self.childAt(idx).loadPresetCompileString;
		});
	},

	mixer: { nil },
	
));

TrackTemplateDef(\TrackListChannelPart, TrackTemplateDef(\playerwrapper)).putAll((
	isEmpty: { arg self;
		self.score.isNil and: {
			self.proxy.isNil or: { self.proxy.target == nil };
		}
	},

	source_: { arg self, val;
		self.proxy = PlayerWrapper(val);
		self.outBus = nil; // set to default
	},

	outBus: { arg self;
		self.proxy.outBus;
	},

	outBus_: { arg self, val;
		if(val.isNil) {
			val = self.parentTrack.outBus ? 0;
		};
		self.proxy.outBus = val;
	},

	asPatternEvent: { arg self;
		if(self.score !? self.score.timeline.notNil) {
			self.score.timeline.asPatternEvent;
		} {
			Event.silent(1) // TODO
		}
	},

	clearPart: { arg self;
		self.score = ();
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
		"TrackDef(%).childAt(%, %)".format(self.parentTrack.parentTrack.key.asCompileString, self.parentTrack.index.asCompileString, self.index.asCompileString);
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
		self.score = self.parentTrack.instrument.makeScore(self.grid, self.parentTrack.index, self.index);
	},

	score_: { arg self, val;
		self[\score] = val;
		Log(\Param).debug("setting score to: %", self.score.asCompileString);
		self.parentTrack.instrument.updateScore(self.score);
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
		grid.dataPath +/+ "%_%.%.%.scd".format(scoretype, grid.key, self.parentTrack.index, self.index);
	},

	presetCompileStringSavePath: { arg self;
		self.scorePresetCompileStringSavePath("TrackDef");
	},


	presetCompileStringSavePath_: { arg track, val;
		track[\presetCompileStringSavePath] = val;
	},
	
));

ProtoTemplateDef(\TrackInstrument, (
	new: { arg self, libId, name="noname";
		var instr;
		self = self.deepCopy;

		if(libId.first == \TrackInstrument) {
			instr = switch(libId.last.key,
				\ClipTimelineTrack, { ProtoTemplateDef(\TrackInstrument_ClipTimelineTrack).new(libId, name) },
				\KitTimelineTrack, { ProtoTemplateDef(\TrackInstrument_KitTimelineTrack).new(libId, name) },
			);
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

	setTrackInstrumentOfScore: { arg self, score;
		self.source.setTrackInstrument(score, self);
	},

	edit:{ arg self;
		Log(\Param).debug("trackInstrument: edit % ", self.libId);
		WindowDef(\PdefEditor).front(self.lib.libIdToTarget(self.libId))
	}
	
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

));

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
				var rowHeight_inset = rowHeight - 20;
				if(child.isEmpty.not) {
					var idx = model.selectedPart;
					var cell = child.childAt(idx);
					var linename = "%.%".format(model.key, idx).asSymbol;
					var name = "%.%.%".format(model.key, childidx, idx).asSymbol;
					var playbut = PlayerWrapper(cell).asView;
					var lay;
					var chanview = View.new;
					playbut.debug("i");
					playbut.button.maxWidth_(30);
					playbut.parentView.states = [
						[""],
						["", Color.black,ParamViewToolBox.color_ligth],
					];
					playbut.parentView.update;
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

										WindowDef(\OverlayMenu).front({ arg def;
											BasicButton.new.string_("Remove track").action_({
												model.removeTrack(childidx);
												def.closeWindow;
											})
										}, but, x, y )

									}
								})
							,
							HLayout (
								Param(
									Message(child),
									\outBus, 
									MenuSpec([\default -> nil, \0->0] ++ BusDef.all.keys.as(Array).sort.collect({ arg k; k -> BusDef(k).index }) )
								).asPopUpMenu.maxWidth_(100),
								Param(
									Message(cell),
									\outBus, 
									MenuSpec([\default -> nil, \0->0] ++ BusDef.all.keys.as(Array).sort.collect({ arg k; k -> BusDef(k).index }) )
								).asPopUpMenu.maxWidth_(100),
							),
							nil
						),
						{
							if(cell.isEmpty) {
								BasicButton.new.string_("make score").action_({
									cell.makeScore;
								}).fixedHeight_(rowHeight_inset)
							} {
								cell.score.timeline.asPreview.fixedHeight_(rowHeight_inset);
							}

						}.value,
					);
					chanview.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
						[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
						//view.background = ParamViewToolBox.color_dark;
						//view.background = Color.grey;
						viewSelector.select_item(childidx);
						FileSystemProject.current.tracklist_selected_track = [\TrackListPart, linename -> model.linePlayerAt(idx)];
						FileSystemProject.current.changed(\tracklist_selected_track);
						FileSystemProject.current.tracklist_selected_track = [\TrackListChannelPart, name -> cell];
						FileSystemProject.current.changed(\tracklist_selected_track);
						FileSystemProject.current.tracklist_selected_track.debug("sel track");
						
					});
					chanview.fixedHeight_(rowHeight);
					chanview.layout_(lay);
					viewSelector.add_view(chanview);
					chanview;
				};
			}).select(_.notNil).collect({ arg x; [x, stretch:0] }).asArray ++ [nil]
		);
		tracklist.layout.spacing_(0);
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
					Log(\Param).debug("OK!");
					model.addTrack(libId, label);
				})
			}),
			HLayout (
				StaticText.new.string_("Part:"),
				Param(Message(model), \selectedPart, ControlSpec(0,16,\lin,1)).asNumberBox,
			),
			BasicButton.new.string_("Main Timeline").action_({
				ClipTimeline(\mainTimeline).edit;
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
					label = namefield.name;
				};
				okHook.(selectedLibId, label);
			})
		)
	)
});

//WindowDef(\TrackList_NewInstrument).front

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
TrackDef(\mygrid, TrackTemplateDef(\TrackList));

WindowDef(\tracklist).front(TrackDef(\mygrid));
TagSpecDef(\TrackList).addUnique(\mygrid, TrackDef(\mygrid));
WindowDef(\MainProject).front(FileSystemProject('ex6'));
TrackDef(\mygrid).presetCompileStringSavePath = "/tmp/ss/";
FileSystemProject('ex6').resources = [TrackDef(\mygrid)];
FileSystemProject('ex6').projectPath = "/tmp/ss/";
