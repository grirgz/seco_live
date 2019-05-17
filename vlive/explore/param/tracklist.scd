
TrackDef(\mygrid).clear
TrackDef(\mygrid).childAt(0).mixer.play
TrackDef(\mygrid).isPlaying
NoteTimeline('mygrid.0.2').asPattern.asStream.nextN(10,())
(
ParamProto.init;
FileSystemProject.load("libdef/tracks.scd");
)
//ProtoDef(\tracklist, TrackDef(\c))
(
TrackDef(\mygrid, TrackTemplateDef(\playergrid));
TrackDef(\mygrid).putAll((
	selectedPart: 0,
	selectedPart_: { arg self, val;
		if(val != self[\selectedPart]) {
			self[\selectedPart] = val;
			self.changed(\selectedPart);
			self.changed(\tracklist);
		}
	},
));

WindowDef(\tracklist, { arg def, model;
	var playButton;
	var tracklist = View.new;
	var viewSelector = ~view_selector.new(0);
	viewSelector.selected_color = Color.grey;
	viewSelector.deselected_color = Color.clear;

	tracklist.followChange(model, \tracklist, {
		viewSelector.views = [];
		tracklist.removeAll;
		tracklist.layout = VLayout (
			* model.children.collect({ arg child, childidx;
				if(child.isEmpty.not or: { child.instrument.notNil }) {
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
						Param(
							Message(child),
							\outBus, 
							MenuSpec([\default -> nil, \0->0] ++ BusDef.all.keys.as(Array).sort.collect({ arg k; k -> BusDef(k).index }) )
						).asPopUpMenu.maxWidth_(100),
						BasicButton.new.string_(child.label).action_({
							WindowDef(\PdefEditor).front(child.instrument.source)
						}).maxWidth_(200),
						{
							if(cell.isEmpty and: { cell.score.isNil }) {
								BasicButton.new.string_("make score").action_({
									if(cell.score.isNil) {
										cell.score = ();
									};
									cell.score.timeline = NoteTimeline(name, child.instrument.source);
									cell.source = cell.score.timeline;
									model.changed(\tracklist);
								}).fixedHeight_(60)
							} {
								cell.score.timeline.asPreview.fixedHeight_(60);
							}
			
						}.value;
					);
					chanview.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
						[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
						//view.background = ParamViewToolBox.color_dark;
						//view.background = Color.grey;
						viewSelector.select_item(childidx)
						FileSystemProject.current.tracklist_selected_track = [model, child, model.selectedPart];
						FileSystemProject.changed(\tracklist_selected_track);
						
					});
					chanview.layout_(lay);
					viewSelector.add_view(chanview);
					chanview;
				};
			}).select(_.notNil).asArray ++ [nil]
		)
	});
	tracklist.layout.spacing_(0);

	playButton = PlayerWrapperView.new;
	tracklist.followChange(model, \selectedPart, {
		playButton.model = model.linePlayerAt(model.selectedPart);
		if(model.isPlaying) {
			model.linePlayerAt(model.selectedPart).play;
		};
	});

	VLayout(
		HLayout (
			playButton.view,
			BasicButton.new.string_("Add").action_({
				WindowDef(\newtrack).front(model)
			}),
			HLayout (
				StaticText.new.string_("Part:"),
				Param(Message(model), \selectedPart, ControlSpec(0,16,\lin,1)).asNumberBox,
			)
		),
		tracklist,
	);


});

WindowDef(\newtrack, { arg def, model;
	var namefield;
	var newtrack;
	var buttons;
	block { arg break;
		8.do{ arg idx;
			if(model.childAt(idx).isEmpty and: { model.childAt(idx).instrument.isNil }) {
				newtrack = model.childAt(idx);
				break.value;
			}
		};
	};
	buttons = [
		'SynthDef' -> {

		},
		'Pdef' -> {
			newtrack.instrument = ProtoDef(\instrument).new(Pdef(namefield.string.asSymbol));
			model.changed(\tracklist);
			def.closeWindow;
		},
		'Ndef' -> {

		},
		'Sample' -> {

		},
		'PatKitDef pad' -> {

		},
	].collect({ arg item;
		BasicButton.new.string_(item.key).action_({
			item.value.value;
		})
	});
	VLayout(
		HLayout(
			StaticText.new.string_("name:"),
			namefield = TextField.new,
		),
		VLayout(*buttons)
	)

	
});

ProtoDef(\instrument, (
	new: { arg self, source;
		self = self.deepCopy;

		self.source = source;
	
		self;
	},
	source_: { arg self, val;
		self[\source] = val;
		
	},
	
));

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

WindowDef(\tracklist).front(TrackDef(\mygrid));
);
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
