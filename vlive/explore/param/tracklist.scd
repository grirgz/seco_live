// moved to libdef/tracklist.scd

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
FileSystemProject('ex6').resources = [TrackDef(\mygrid)];
FileSystemProject('ex6').projectPath = "/tmp/ss/";
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


TrackDef(\mygrid).clear
TrackDef(\mygrid).refCompileString

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
