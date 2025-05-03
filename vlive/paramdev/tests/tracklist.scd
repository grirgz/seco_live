(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
FileSystemProject.load("cavern/lib.scd");
)

TrackDef(\tlist, \TrackList).edit
TrackDef(\tlist2, \TrackList).edit
~td = TrackDef(\tlist2);
~td.editor
ParamViewToolBox.clipboard.trackDef_section
~td.sectionAt(~td.selectedPart).existingChildren.childAt(0)
~td.sectionAt(~td.selectedPart).childAt(2).parentTrack.index
~s = TrackDef(\tlist).childAt(0).source
~s.isKindOf(Pbindef)
BaseParam.getInstrumentFromPbind(~s.source).asCompileString
PdefParam.instrument(~s)

TrackDef(\tlist).childAt(0).source.source.pairs
PdefParam.instrument(TrackDef(\tlist).childAt(0).source)
TrackDef(\tlist, TrackTemplateDef(\TrackList))
TrackDef(\tlist).edit
TrackTimeline(\bla2, TrackDef(\tlist))
TrackTimeline(\bla2).edit
TrackDef(\tlist)
TrackDef(\tlist).children
TrackDef(\tlist).childAt(0,0).refCompileString
TrackDef(\tlist).childAt(0).refCompileString
TrackDef(\tlist).childAt(0).asCompileString = TrackDef(\tlist).childAt(0).refCompileString
TrackDef(\tlist).childAt(0)[\asCompileString] = TrackDef(\tlist).childAt(0)[\refCompileString]
TrackDef(\tlist).childAt(0).asCompileString
TrackDef(\tlist).childAt(0).refCompileString
TrackDef(\tlist).clear
WindowDef(\playergrid).front(TrackDef(\simpleProject_mainTrackList))
WindowDef(\playergrid).front(TrackDef(\tlist))
TrackDef(\tlist).childAt(0).mixer.asParam(\postfader)
TrackDef(\tlist).childAt(0).mixer.edit
TrackDef(\tlist).childAt(0).mixer.inBus
TrackDef(\tlist).childAt(0).outBus
TrackDef(\tlist).childAt(1).outBus
TrackDef(\tlist).childAt(3,0).isEmpty
TrackTimeline(\tlist).clear

TrackDef(\aze)
TrackDef(\aze).storeOn = { arg self, stream; stream << "helo" }
TrackDef(\aze)[\storeOn] = { arg self, stream; stream << "heloii" }
TrackDef(\aze).refCompileString = "kjkj"

TagSpecDef(\TrackList).addUnique(\tlist -> TrackDef(\tlist))
TagSpecDef(\TrackList).clear
TrackDef(\simpleProject_mainTrackList).keys
TrackDef(\simpleProject_mainTrackList).edit

NoteTimeline('simpleProject_mainTrackList.0.2').quant
NoteTimeline('simpleProject_mainTrackList.0.2').play
PlayerWrapper(NoteTimeline('simpleProject_mainTrackList.0.2')).stop

ProtoDef(\GlobalLibrary).init_other_factories

SampleTimeline(\pol).edit
SampleTimeline(\pol).eventList

TrackDef(\tlist).childAt(0,0).score.timeline.presetCompileString.editorInsert
(
NoteTimeline('tlist.0.0').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.125, \label: 'start', \playDur: 0.125, \relDur: 0.125, \sustain: 0, \type: 'start', ),
	(\absTime: 0.125, \dur: 0.0, \midinote: 52.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 0.125, \dur: 0.125, \midinote: 65.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.625, ),
	(\absTime: 0.25, \dur: 0.375, \midinote: 46.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.5, ),
	(\absTime: 0.625, \dur: 0.125, \midinote: 55.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.375, ),
	(\absTime: 0.75, \dur: 0.125, \midinote: 39.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.5, ),
	(\absTime: 0.875, \dur: 0.125, \midinote: 72.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0.125, \midinote: 64.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.5, ),
	(\absTime: 1.125, \dur: 0.25, \midinote: 73.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.375, \dur: 0.0, \midinote: 57.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.375, ),
	(\absTime: 1.375, \dur: 0.25, \midinote: 48.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.625, \dur: 0.0, \midinote: 42.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.375, ),
	(\absTime: 1.625, \dur: 0.375, \midinote: 47.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
NoteTimeline('tlist.0.1').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.125, \label: 'start', \playDur: 0.125, \relDur: 0.125, \sustain: 0, \type: 'start', ),
	(\absTime: 0.125, \dur: 0.25, \midinote: 78.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.5, ),
	(\absTime: 0.375, \dur: 0.5, \midinote: 48.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 0.875, \dur: 0.125, \midinote: 65.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.5, ),
	(\absTime: 1.0, \dur: 0.25, \midinote: 111.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.25, \dur: 0.125, \midinote: 104.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 1.375, \dur: 0.125, \midinote: 97.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 1.5, \dur: 0.125, \midinote: 49.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.5, ),
	(\absTime: 1.625, \dur: 0.375, \midinote: 89.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.375, ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
TrackDef(\tlist, TrackTemplateDef(\TrackList));
TrackDef(\tlist).edit;
);

(
TrackTimeline(\bla2, TrackDef(\tlist));
TrackTimeline(\bla2).edit;
)
TrackTimeline(\bla2).clear
p

TrackTimeline(\bla2).presetCompileString.editorInsert
(
TrackTimeline('bla2').tracks = SparseArray[ TrackDef('tlist').childAt(0) ];
{
TrackTimeline('bla2').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 1.0, \label: 'start', \playDur: 1.0, \relDur: 1.0, \sustain: 0, \type: 'start', ),
	PlayerEvent((\absTime: 1.0, \clockTime: 118.0, \dur: 0.0, \midinote: 0, \playDur: 0.0, \receiver: { TrackDef('tlist').childAt(0, 1) }, \relDur: 0.0, \sustain: 0.8, \type: 'player', )),
	PlayerEvent((\absTime: 1.0, \clockTime: 118.0, \dur: 5.734541026, \midinote: 0, \playDur: 5.734541026, \receiver: { TrackDef('tlist').childAt(0, 1) }, \relDur: 5.734541026, \sustain: 4.0, \type: 'player', )),
	(\absTime: 6.734541026, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;




);




TrackDef(\tlist).childAt(1,0).isPlaying
TrackDef(\tlist).childAt(1,0).stop
TrackDef(\tlist).childAt(1,0).play
PlayerWrapper(TrackDef(\tlist).childAt(1,0)).isPlaying
PlayerWrapper(TrackDef(\tlist).childAt(1,0)).togglePlay
PlayerWrapper(TrackDef(\tlist).childAt(1,0)).asView
PlayerWrapperView(TrackDef(\tlist).childAt(1,0)).view
(
WindowDef(\win, { arg def;
	VLayout (
		PlayerWrapper(TrackDef(\tlist).childAt(1,0)).asView,
		PlayerWrapperView(TrackDef(\tlist).childAt(1,0)).view,
	)
	
}).front;
)




/////////////////////
// test mixer save/load

(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
s.waitForBoot { 
	FileSystemProject.load("sun/lib.scd"); 
	FileSystemProject.load("libdef/filedialog_tracklist.scd");
	//TrackDef(\bla, \TrackList).edit;
	TrackDef(\hoo, \PlayerGrid).edit
};
)

"kjk".throw
	TrackDef(\hihi1, \PlayerGrid).edit
TrackDef(\hoo).source
TrackDef(\hoo).loadPresetCompileString
PlayerWrapper(Pdef(\metronome)).savePresetCompileString
TrackDef(\bla, \TrackList);
TrackDef(\bla).edit
TrackDef(\bla).resources
TrackDef(\bla).resources.first.presetCompileStringSavePath
PlayerWrapper(TrackDef(\bla).resources.first).presetCompileStringSavePath
PlayerWrapper(TrackTimeline(\bla)).presetCompileStringSavePath
PlayerWrapper(TrackTimeline(\bla)).savePresetCompileString
FileSystemProject.load("~/tmp/bla/TrackDef_bla.scd")
TrackDef(\bla).clear
TrackDef(\bla).presetCompileString
TrackDef(\bla).linePlayers = nil
TrackDef(\bla).linePlayers 
TrackDef(\bla).childAt(0).presetCompileString
TrackDef(\bla).childAt(0).outBus
TrackDef(\bla).childAt(0,1).source.eventList
TrackDef(\bla).childAt(0,1).source.edit
TrackDef(\bla).mixer
TrackDef(\bla3, TrackTemplateDef(\CustomTrackList));
TrackDef(\bla2).childAt(0).mixer.presetCompileString
TrackDef(\bla2).childAt(0).presetCompileString
TrackDef(\bla2).children[0] = nil
TrackDef(\bla).childAt(0).children[0] = nil
TrackDef(\bla).linePlayerAt(0).parentTrack
TrackDef(\bla).linePlayerAt(0).isLinePlayer
TrackDef(\bla).linePlayerAt(5).isEmpty

TrackDef(\bla3).edit

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([Pwhite(0,12)],inf),
		\dur, 1/3,
		\amp, 0.1,
	)
).play;
);

(
Pbindef(\hoho, 
		\instrument, \default,
		\degree, Pseq([Pwhite(0,12)],inf),
		\dur, 1/3,
		\amp, 0.1,
		\out, BusDef(\sendbus1, \audio),
).play;
);


(
	Pdef(\part, Pdef(\zedpart, 
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbindef(\hoho, 
				\instrument, \default,
				\degree, Pseq([Pwhite(0,12)],inf),
				\dur, 1/3,
				\amp, 0.1,
			)	
		])
	)).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.kr(12 * ( SinOsc.kr(0.2 * ( SinOsc.kr(0.21) * 1 + 1 )) * 1 + 1 )) * 1 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
Ndef(\zed).quant = 4;

(
WindowDef(\win, { arg def;
	PlayerWrapper(Ndef(\zed)).asView
}).front;
)

SampleTimeline(\bla4).edit
Buffer

s.sendMsg("/b_query", 0);         
OSCdef(\bla, { arg ...args; args.debug("osc:") })




PatKitDef(\ha).edit

TrackDef(\aze, \CustomTrackList).edit
TrackDef(\aze).elAt(0).score.source.at(\bufnum).source
TrackDef(\aze).elAt(0).presetCompileString
FileSystemProject.load("libdef/CustomTrackList.scd")
Param

ParamProto.init(true)
PlayerEvent
Pbindef(\boi, \instrument, \sh101).edit
Pbindef(\boi).edit
Pbindef(\boi).source.at(\instrument).source
Pdef(\boi).source
Param(Pbindef(\boi), \instrument -> \source).set(\saw)
Param(Pbindef(\boi), \instrument -> \source).set(\saw)
Pbindef(\boi).changed(\set, [\instrument])
Pbindef(\boi).asParamGroup.asPropertyDict
(
Pdef(\aaaa, 
	Pbind(
		\instrument, \sh101,
	)
).edit;
);
Pdef(\aaaa).envir
ParamTimeline(\bla, Param(Pdef(\bla), \rah, \freq)).edit
ParamTimeline(\bla2, Param(Pdef(\bla), \aaa, \pan)).edit
// TODO: quant is applied two times when recording param in ClipTimeline
ClipTimeline(\bla2).tracks[0]
RecordButton().view

Pdef(\testrec, Pbind(\instrument, \sh101)).edit
(
TagSpecDef(\SynthDefPresetBank, {
	ProtoTemplateDef(\SynthDefPresetBank).allPresets
});
)
ProtoTemplateDef(\SynthDefPresetBank).allPresets.asDict.keys
Archive.global.at(\Param, \SynthDefPresetBank, \sh101, \presetDict).keys
(
Archive.global.at(\Param, \SynthDefPresetBank).collect({ arg x; x.at(\presetDict).keys.asArray.collect({ arg sx; 
	"%.%".format(x, sx).asSymbol -> x.at(\presetDict, sx)
}) }).values.flat
)

(
Archive.global.at(\Param, \SynthDefPresetBank).do({ arg x;
	x.postln;
})
)
Archive.global.at(\Param, \SynthDefPresetBank)
	(
	{
		var res = List.new;
		
		Archive.global.at(\Param, \SynthDefPresetBank).keysValuesDo({ arg key, val; 
			val.at(\presetDict).keys.do({ arg presetkey; 
				res.add("%.%".format(key, presetkey).asSymbol -> val.at(\presetDict).at(presetkey));
			}) 
		});
		res;
	}.value.asDict.keys;
	)

FileSystemProject.load("sndlib/synthbasic.scd")
Pbindef(\hey, \degree, Pseq([1,5,2,Pwhite(0,12,1)],inf)).edit
Pbindef(\hey).edit
Pbindef(\hey).source.pairs
SynthDesc(\flutepad)
SynthDesc(\saw)

ProtoTemplateDef(\SynthDefPresetBank).presetsBySynthDef(\saw)[\preset1]
ProtoTemplateDef(\SynthDefPresetBank).presetsBySynthDef(\sh101)[\preset3]
ProtoTemplateDef(\SynthDefPresetBank).presetsBySynthDef(\flutepad)[\calm]

(
MIDIdef.cc(\track1, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	
});
)

NoteTimeline
ClipTimeline(\bla).edit
ClipTimeline(\bla).editor.timeline.selNodes
NoteTimeline(\aze, Pbindef(\hello)).edit
ParamTimeline(\aze).edit



FileSystemProject(\hello)

