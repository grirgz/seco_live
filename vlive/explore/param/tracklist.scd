
TrackDef(\mygrid).clear
TrackDef(\mygrid).childAt(0).mixer.play
TrackDef(\mygrid).isPlaying
TrackDef(\mygrid).children.last.label
TrackDef(\mygrid).children.first.instrument[\edit]
TrackDef(\mygrid).childAt(0).clearChannel
NoteTimeline('mygrid.0.2').asPattern.asStream.nextN(10,())
NoteTimeline('mygrid.0.0').asPattern.asStream.nextN(10,())
(
)

//ProtoDef(\tracklist, TrackDef(\c))
(
ParamProto.init;
FileSystemProject.load("libdef/tracks.scd");
FileSystemProject.load("libdef/drumkit.scd");
FileSystemProject.load("libdef/synthplayrec.scd");
FileSystemProject.load("main_window.scd".resolveRelative);
FileSystemProject.load("PatKitDef_newkit.scd".resolveRelative);
FileSystemProject('ex6', ProtoTemplateDef( \MainProject ));
//FileSystemProject.current = FileSystemProject.current ? ();
FileSystemProject.current = FileSystemProject('ex6');

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

	savePresetCompileString: { arg self;
		if(File.exists(self.presetCompileStringSavePath).not or: {self.loadedFromPath == self.presetCompileStringSavePath}) {
			File.mkdir(self.presetCompileStringSavePath);
			self.loadedFromPath = self.presetCompileStringSavePath;
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

	loadPresetCompileString: { arg self;
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
		self.instrument = nil;
		self.clearAllChannelParts;
		
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
		self.parentTrack.presetCompileStringSavePath ++ "TrackDef_%.%.scd".format(self.parentTrack.key, self.index);
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
		self.score = self.parentTrack.instrument.makeScore(self.grid, self.index);
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
		if(self.score.selected.isNil) {
			self.score.selected = \timeline;
		};
		self.source = self.score[self.score.selected];
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
		grid.presetCompileStringSavePath +/+ "%_%.%.%.scd".format(scoretype, grid.key, self.parentTrack.index, self.index);
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
		self = self.deepCopy;

		self.name = name;
		self.lib = { ProtoDef(\GlobalLibrary) };
		if(libId.first == \SynthDef) {
			libId = self.synthDefToPdefLibId(libId);
		};
		self.libId = libId;
		self.source = self.lib.libIdToTarget(libId);
	
		self;
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
		score.keys.do { arg key;
			if(key != \selected) {
				self.lib.setTrackInstrument(score[key], self)
			}
		}
	},

	edit:{ arg self;
		Log(\Param).debug("trackInstrument: edit % ", self.libId);
		WindowDef(\PdefEditor).front(self.lib.libIdToTarget(self.libId))
	}
	
));
ProtoDef(\trackInstrument, ProtoTemplateDef(\TrackInstrument)); // compat

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
		)
	});
	"i2".debug;
	tracklist.layout.spacing_(0);

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
);



///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

(
NoteTimeline('mygrid.0.0').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.25, \midinote: 67.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.25, \dur: 0.25, \midinote: 77.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.5, \dur: 0.25, \midinote: 73.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.75, \dur: 0.25, \midinote: 81.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.0, \dur: 0.25, \midinote: 78.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.25, \dur: 0.25, \midinote: 74.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.5, \dur: 0.25, \midinote: 82.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.75, \dur: 0.25, \midinote: 86.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
)



TagSpecDef(\TrackList).addUnique(\mygrid -> TrackDef(\mygrid));
TagSpecDef(\TrackList).list
TrackDef(\mygrid) == TrackDef(\mygrid)
WindowDef(\tracklist).clear


TrackDef(\mygrid).childAt(0).instrument.source
WindowDef (\tt, { arg def;
	var playButton;
	var model = TrackDef(\mygrid);
	//PlayerWrapper(TrackDef(\mygrid).linePlayerAt(TrackDef(\mygrid).selectedPart)).asView
	def.followChange(model, \selectedPart, {
		playButton.model = model.linePlayerAt(model.selectedPart);
		playButton.updateView;
	});
	playButton = PlayerWrapperView.new; 
	~p = playButton;
	//playButton.model = model.linePlayerAt(model.selectedPart);
	playButton.view;
	//playButton.model_(TrackDef(\mygrid).linePlayerAt(TrackDef(\mygrid).selectedPart)/).view
	//PlayerWrapperView.new; .model_(TrackDef(\mygrid).linePlayerAt(TrackDef(\mygrid).selectedPart)).view
}).front

~model = TrackDef(\mygrid)
~p.model = ~model.linePlayerAt(~model.selectedPart);

ClipTimeline(\bla).edit
FileSystemProject.current = ()

Pdef(\hey).play

NoteTimeline(\wtf, Pdef(\hey)).edit
NoteTimeline('mygrid.0.0', Pdef(\hey)).edit
NoteTimeline('mygrid.0.0', Pdef(\hey)).outBus
~outbus = NoteTimeline('mygrid.0.0', Pdef(\hey)).outBus


			(
			~p = Param(
Message(NoteTimeline('mygrid.0.0', Pdef(\hey))),
				\outBus, 
				MenuSpec([\default -> nil, \0->0] ++ BusDef.all.keys.as(Array).sort.collect({ arg k; k -> BusDef(k) }) )
			)
			)

			~outbus.index
			~p.get
			~p.edit
			~p.spec.mapIndex(~outbus)
			~p.spec.mapValue(~outbus)
			~p.spec.mapIndex(10)
			~p.spec.list
			~p.type
			~outbus
			~outbus.key

			ProtoDef(\GlobalLibrary).libIdToWrapper([\Pdef, \hey -> Pdef(\hey)]).makeScore(\bla)
			ProtoDef(\GlobalLibrary).libIdToScore([\Pdef, \hey -> Pdef(\hey)], \bla2)
			NoteTimeline(\bla).edit
			NoteTimeline(\bla).target
			NoteTimeline(\bla2).target
			BusDef(\mybus, \audio, 2)

			TrackDef(\mygrid).edit
			TrackDef(\mygrid).childAt(0)
			Pdef.defaultQuant = 2


ClipTimeline(\bla).edit
ClipTimeline(\bla).edit
ParamProto.init(true)
NoteTimeline('mygrid.0.0').presetCompileString.editorInsert
~ev= NoteTimeline('mygrid.0.0').asPatternEvent
~ev[\sustain] = 10
~ev.play
(
);

ProtoDef(\GlobalLibrary).libIdToFactory([\Ndef]).keylist
ProtoDef(\GlobalLibrary).libIdToFactory([\TrackListChannelPart])
ProtoDef(\GlobalLibrary).clipFactories.keys
ProtoDef(\GlobalLibrary).init_default_clip_factories
ClipTimeline(\bla).clipList.clipList
ClipTimeline(\bla).eventList[1].receiver.target.index
KitTimeline('mygrid.1.1').play
TrackDef(\mygrid).childAt(1,0)[\playNow].asCompileString
TrackDef(\mygrid).childAt(1,0).proxy.target.playNow
TrackDef(\mygrid).linePlayerAt(0).makeEventList
TrackDef(\mygrid).linePlayerAt(0).asPattern.asStream.nextN(10,())
TrackDef(\mygrid).linePlayerAt(0).asPattern
TrackDef(\mygrid).linePlayerAt(0)[\asPattern].asCompileString
TrackDef(\mygrid).linePlayerAt(0).children.collect(_.isEmpty)
TrackDef(\mygrid).linePlayerAt(0).children.first.asPatternEvent
~kitTimeline.
TagSpecDef(\KitTimeline).labelList

(
TrackDef(\mygrid).linePlayerAt(0).makeEventList = { arg self, totalDur = 1;
		var el = TimelineEventList.new;
		el.start(0);
		self.children.select(_.isEmpty.not).debug("chd").do({ arg child, idx; 
			var ev = child.asPatternEvent;
			ev.debug("ev");
			ev[\absTime] = 0;
			ev[\sustain] = totalDur;
			ev.debug("eva");
			el.addEvent(ev)
		});
		el.finish(totalDur);
		el;
	};
TrackDef(\mygrid).linePlayerAt(0).makeEventList
)
~el = TimelineEventList.new
~el.addEvent(PatternEvent((absTime:0)))
~el.addEvent(PatternEvent((timeline: { NoteTimeline('mygrid.0.0')  }, absTime: 0, type: 'pattern')))

(
)
Proto

~x = SimpleController(FileSystemProject.current)
~x.put(\tracklist_selected_track, {
	"hhhhhhiiiiiiiii	".debug;
})
						FileSystemProject.current.changed(\tracklist_selected_track);

TrackDef(\mygrid).savePresetCompileString
TrackDef(\mygrid).presetCompileStringSavePath = "/tmp/ss/"

///////////////////////////////////////////////////

//// saved file should looks like:


TrackDef(\mygrid2, TrackTemplateDef(\TrackList));
TrackDef(\mygrid2).childAt(0).instrument = ProtoDef(\trackInstrument).new([\Pdef, \hey -> Pdef(\hey)], "bass");
TrackDef(\mygrid2).childAt(0,0).score = (timeline: NoteTimeline('mygrid2.0.0', Pdef(\hey)));
TrackDef(\mygrid2).linePlayerAt(0).label = "intro";

NoteTimeline('mygrid2.0.0').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.25, \midinote: 67.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.25, \dur: 0.25, \midinote: 77.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.5, \dur: 0.25, \midinote: 73.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.75, \dur: 0.25, \midinote: 81.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.0, \dur: 0.25, \midinote: 78.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.25, \dur: 0.25, \midinote: 74.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.5, \dur: 0.25, \midinote: 82.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.75, \dur: 0.25, \midinote: 86.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);

////////////////////////////////
TrackDef(\mygrid).childAt(0,0).presetCompileString.editorInsert
TrackDef(\mygrid).childAt(0,0).savePresetCompileString
(
TrackDef('mygrid').childAt(0, 0).score = ( 'timeline': NoteTimeline('mygrid.0.0') );
);


TrackDef(\mygrid).childAt(0).savePresetCompileString("/tmp/ss/bla.scd")
TrackDef(\mygrid).childAt(0).presetCompileString.editorInsert
(
TrackDef('mygrid').childAt(0).instrument = ProtoTemplateDef('TrackInstrument').new([ 'Pdef', ('hey' -> Pdef('hey')) ]);
TrackDef('mygrid').childAt(0).label = "hey Pdef";
);

(
TrackDef('mygrid').childAt(0).instrument = ProtoTemplateDef('TrackInstrument').new([ 'Pdef', ('hey' -> Pdef('hey')) ]);
TrackDef('mygrid').childAt(0).label = "hey Pdef";
);

(
TrackDef('mygrid').childAt(0).instrument = ProtoTemplateDef(TrackInstrument).new([ 'Pdef', ('hey' -> Pdef('hey')) ]);
TrackDef('mygrid').childAt(0).label = "hey Pdef";
);

TrackDef(\m)
WindowDef(\tracklist).front(TrackDef(\mygrid2));

TrackDef('mygrid').edit

TrackDef(\mygrid).clear
TrackDef(\mygrid, TrackTemplateDef(\TrackList));
TrackDef(\mygrid).presetCompileStringSavePath = "/tmp/ss/";

TrackDef(\mygrid).savePresetCompileString
TrackDef(\mygrid).presetCompileStringSavePath
TrackDef(\mygrid).loadPresetCompileString
TrackDef(\mygrid).childAt(0).presetCompileStringSavePath
TrackDef(\mygrid).childAt(0).instrument.target
TrackDef(\mygrid).childAt(0).instrument.updateScore(TrackDef(\mygrid).childAt(0,0).score)
TrackDef(\mygrid).childAt(0,0).score.timeline.param
TrackDef(\mygrid).childAt(0,0).score.timeline.trackInstrument == TrackDef(\mygrid).childAt(1).instrument
TrackDef(\mygrid).childAt(1,0).score.timeline.kit
TrackDef(\mygrid).childAt(0,0).proxy.target
TrackDef(\mygrid).childAt(0,0).presetCompileStringSavePath
TrackDef(\mygrid).childAt(0,0).presetCompileStringSavePath
TrackDef(\mygrid).childAt(0,0).score.timeline.presetCompileStringSavePath
TrackDef(\mygrid).childAt(0,0).score.timeline[\loadPresetCompileString]
TrackDef(\mygrid).childAt(0,0).score.timeline
TrackDef(\mygrid).childAt(0,0).score.timeline.edit
TrackDef(\mygrid).childAt(1).instrument.libId
TrackDef(\mygrid).childAt(2).instrument
TrackDef(\mygrid).changed(\tracklist)
TrackDef(\mygrid).isEmpty
PatKitDef(\newkit).edit



/////////////////////////

ParamProto.init(true)

(
	~test = UnitTest.new;
	~t = 135/4/60; TempoClock.default.tempo = ~t;
	Pdef(\test_pdef, Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1
	));
	ParamProto.init;
);
NoteTimeline(\test_notetimeline, Param(Pdef(\test_pdef), \midinote)).edit
NoteTimeline(\test_notetimeline).repeatCount = 1

NoteTimeline(\test_notetimeline).presetCompileString.editorInsert
(
NoteTimeline('test_notetimeline').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.125, \midinote: 53.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.125, \dur: 0.125, \midinote: 56.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.25, \dur: 0.125, \midinote: 65.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.375, \dur: 0.125, \midinote: 66.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.5, \dur: 0.125, \midinote: 81.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.625, \dur: 0.125, \midinote: 83.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.75, \dur: 0.125, \midinote: 99.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.875, \dur: 0.125, \midinote: 103.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

ClipTimeline(\bla).edit
ProtoDef(\GlobalLibrary).libIdToFactory([\Pdef, \hey -> Pdef(\hey)])

//////////////////////////// test slices

~t = 1/4; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Prand([
			NoteTimeline(\test_notetimeline).asPatternSlice(\start, nil, 1),
			NoteTimeline(\test_notetimeline).asPatternSlice("slice2", nil, 1),
			NoteTimeline(\test_notetimeline).asPatternSlice("slice3", nil, 1),
			NoteTimeline(\test_notetimeline).asPatternSlice("slice4", nil, 1),
		],inf),
	])
)).play;
);
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Prand(
			3.collect({ arg idx;
				NoteTimeline(\test_notetimeline).asPatternSlice(idx);
			})
		,inf),
	])
)).play;
);
NoteTimeline(\test_notetimeline).edit
NoteTimeline(\test_notetimeline).loopMaster.getLocatorAbsTime(\end)
NoteTimeline(\test_notetimeline).loopMaster.getNextLocatorAbsTime(\start)
NoteTimeline(\test_notetimeline).loopMaster.getNextLocatorAbsTime("slice2")
NoteTimeline(\test_notetimeline).loopMaster.getNextLocatorAbsTime(0)
NoteTimeline(\test_notetimeline).loopMaster.getLocatorAbsTime(0)
Prand(NoteTimeline(\test_notetimeline).asPatternSlices,inf).play
SampleTimeline(\bla, BufDef(\amen, "vipere/amenbreak.wav")).edit;
SampleTimeline(\bla2).buffer = BufDef(\amen, "vipere/amenbreak.wav")
SampleTimeline(\bla2).edit
BufDef(\amen).play
BufDef(\moeten, "voices/02_moeten.flac")
BufDef(\crepe, "field/crepe.flac");
BufDef(\oeuf, "field/oeuf.flac");
BufDef(\ukraine, "bruit1/07_ukraine.flac");
BufDef(\table, "field/table.flac");
BufDef(\scream, "vipere/scream.flac");
BufDef(\rocksteady, "vipere/rocksteady.flac");
BufDef(\metal, "vipere/metal.flac");
BufDef(\bomb, "vipere/bomb.flac");
NoteTimeline(\test_notetimeline).presetCompileString.editorInsert
(
NoteTimeline('test_notetimeline').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.125, \midinote: 53.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.125, \dur: 0.125, \midinote: 56.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.25, \dur: 0.125, \midinote: 65.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.375, \dur: 0.125, \midinote: 66.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.5, \dur: 0.125, \midinote: 81.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.625, \dur: 0.125, \midinote: 83.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.75, \dur: 0.125, \midinote: 99.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.875, \dur: 0.125, \midinote: 103.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0.0, \midinote: 53.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0.125, \label: "slice2", \playDur: 0.125, \relDur: 0.125, \type: 'locator', ),
	(\absTime: 1.125, \dur: 0.125, \midinote: 62.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.25, \dur: 0.125, \midinote: 71.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.375, \dur: 0.125, \midinote: 81.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.5, \dur: 0.125, \midinote: 86.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.625, \dur: 0.125, \midinote: 88.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.75, \dur: 0.125, \midinote: 80.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.875, \dur: 0.125, \midinote: 84.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.0, \dur: 0.0, \midinote: 67.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 2.0, \dur: 0.125, \label: "slice3", \playDur: 0.125, \relDur: 0.125, \type: 'locator', ),
	(\absTime: 2.125, \dur: 0.125, \midinote: 70.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.25, \dur: 0.125, \midinote: 79.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.375, \dur: 0.125, \midinote: 80.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.5, \dur: 0.125, \midinote: 71.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.625, \dur: 0.125, \midinote: 59.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.75, \dur: 0.125, \midinote: 75.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.875, \dur: 0.0, \midinote: 79.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 2.875, \dur: 0.125, \label: "slice4", \playDur: 0.125, \relDur: 0.125, \type: 'locator', ),
	(\absTime: 3.0, \dur: 0.125, \midinote: 53.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 3.125, \dur: 0.125, \midinote: 62.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 3.25, \dur: 0.125, \midinote: 71.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 3.375, \dur: 0.125, \midinote: 72.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 3.5, \dur: 0.125, \midinote: 62.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 3.625, \dur: 0.125, \midinote: 64.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 3.75, \dur: 0.125, \midinote: 74.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 3.875, \dur: 0.125, \midinote: 78.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 4, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


///////////////////// ParamTimeline

ParamTimeli



////////////////////// ClipTimeline copySplit


(
NoteTimeline(\cp).eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.25, \midinote: 67.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.25, \dur: 0.25, \midinote: 77.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.5, \dur: 0.25, \midinote: 73.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.75, \dur: 0.25, \midinote: 81.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.0, \dur: 0.25, \midinote: 78.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
(\absTime: 1.25, \dur: 0.25, \midinote: 74.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.5, \dur: 0.25, \midinote: 82.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.75, \dur: 0.25, \midinote: 86.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
ClipTimeline('yep').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.5, \label: 'start', \playDur: 0.5, \relDur: 0.5, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.5, \dur: 3.5, \legato: 1, \midinote: 2.0, \playDur: 3.5, \relDur: 3.5, \sustain: 2.5, \timeline: { NoteTimeline('cp') }, \type: 'pattern', )),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
ClipTimeline(\yep).edit
)

~t = 1; TempoClock.default.tempo = ~t;
ClipTimeline(\yep).presetCompileString.editorInsert
(
ClipTimeline('yep').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.5, \label: 'start', \playDur: 0.5, \relDur: 0.5, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.5, \dur: 3.5, \legato: 1, \midinote: 2.0, \playDur: 3.5, \relDur: 3.5, \sustain: 2.5, \timeline: { NoteTimeline('cp') }, \type: 'pattern', )),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

(
);

ParamProto.init(true)
NoteTimeline(\cp).presetCompileString.editorInsert
ClipTimeline(\yep).cursor.endPosition
ClipTimeline(\yep).cursor.startPosition
ClipTimeline(\yep).eventList.last
