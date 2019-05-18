
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
FileSystemProject.load("GlobalLibrary.scd".resolveRelative);
FileSystemProject.load("PatKitDef_newkit.scd".resolveRelative);
FileSystemProject.current = FileSystemProject.current ? ();

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
	
));

ProtoDef(\trackInstrument, (
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

	makeScore: { arg self,  model, childidx;
		self.lib.libIdToScore(self.libId, "%.%.%".format(model.key, childidx, model.selectedPart).asSymbol);
	},

	edit:{ arg self;
		Log(\Param).debug("trackInstrument: edit % ", self.libId);
		WindowDef(\PdefEditor).front(self.lib.libIdToTarget(self.libId))
	}
	
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
									Message(child.childAt(model.selectedPart)),
									\outBus, 
									MenuSpec([\default -> nil, \0->0] ++ BusDef.all.keys.as(Array).sort.collect({ arg k; k -> BusDef(k).index }) )
								).asPopUpMenu.maxWidth_(100),
							),
							nil
						),
						{
							if(cell.isEmpty) {
								BasicButton.new.string_("make score").action_({
									cell.score = child.instrument.makeScore(model, childidx);
									cell.source = cell.score.timeline;
									model.changed(\tracklist);
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
						FileSystemProject.current.tracklist_selected_track = [model, child, model.selectedPart];
						FileSystemProject.changed(\tracklist_selected_track);
						
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
			)
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
);

///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
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


(
WindowDef(\ClipList_NewClip, { arg def, selectedHook, okHook;
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
				StaticText.new.string_("Clip name:"),
				namefield,
			),
		).background_(Color.grey),
		VLayout (
			HLayout (
				StaticText.new.string_("Clip source:"),
				trackInstrumentLabel,
			),
			WindowDef(\GlobalLibrary).asView(lib, selectedCallback, [
				\Clip, \TrackListPart, \TrackListChannelPart,
			]),
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
)
