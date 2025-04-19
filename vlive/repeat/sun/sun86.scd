
// transform pdefpart into playergrid


(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
s.waitForBoot { FileSystemProject.loadOnce("sun/lib.scd"); };
TrackDef(\split, \PlayerGrid);
FileSystemProject.loadOnce("libdef/controllers.scd");
FileSystemProject.loadOnce("libdef/apc.scd");
FileSystemProject.loadOnce("libdef/tracklist_extensions.scd");

TrackDef(\split_extra, \PlayerGrid);
TrackDef(\split_extra).enableAutoSetOutbus = false;
TrackDef(\split_extra).enableOnePlayerPerTrack = false;
TrackDef(\split_extra).isMixerEnabled = false;
)

FileSystemProject.current.addResource(TrackDef(\split))
TrackDef(\split).edit;



(
ProtoDef(\apc40).extra_playergrid = TrackDef(\split_extra);
TrackDef(\split_extra).source = [ 
	[ Pdef(\part), Pdef(\part2), Pdef(\part3), Pdef(\part4) ],
	[ ProtoDef(\rdn), ProtoDef(\rdn2), ProtoDef(\rdn3), ProtoDef(\rdn4) ],
	[ ProtoDef(\FxManager)],
];

ProtoDef(\apc40).quickpad[0][0] = {
	"quick yes!".debug;
};

ProtoDef(\apc40).gridBank = [ TrackDef(\split, \PlayerGrid), TrackDef(\splitdrum, \PlayerGrid) ];

////// fx pads
ProtoDef(\apc40).quickfxpad[0] = { arg self, apc, track, point;
	var fx = track.mixer.insertFxAt(8+point.y);
	fx.synthName = \ifx_stutter;
	fx.enabled = true;
	apc.ktl.elAt(\kn, \t, point.x).mapParam(fx.getParam(\time).withSpec(TagSpec([1,1/2,1/4,1/8]/~t)));
	fx.getParam(\wet).set(1);
	fx.getParam(\mix).set(1);

	self[\stop] = {
		var fx = track.mixer.insertFxAt(8+point.y);
		fx.getParam(\wet).set(1);
		fx.getParam(\mix).set(0);
	}
};
ProtoDef(\apc40).quickfxpad[1] = { arg self, apc, track, point;
	var fx = track.mixer.insertFxAt(8+point.y);
	fx.synthName = \ifx_rlpf;
	fx.enabled = true;
	apc.ktl.elAt(\kn, \t, point.x).mapParam(fx.getParam(\lpf));
	fx.getParam(\wet).set(1);
	fx.getParam(\mix).set(1);

	self[\stop] = {
		var fx = track.mixer.insertFxAt(8+point.y);
		fx.getParam(\wet).set(1);
		fx.getParam(\mix).set(0);
	}
};
ProtoDef(\apc40).quickfxpad[2] = { arg self, apc, track, point;
	//track.mixer.getParam(\postfader).set(0.ampdb);
	track.mixer.getParam(\send5).set(1);

	self[\stop] = {
		track.mixer.getParam(\send5).set(0);
	}
};
)




////////////////////////////////////////////////

(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
s.waitForBoot { FileSystemProject.load("sun/lib.scd"); };
)
FileSystemProject("sun/sun85").open.edit;
FileSystemProject("sun/sun55").open.edit;
FileSystemProject("sun/sun55").open
FileSystemProject("repeat/tmp/test3").open.edit;
FileSystemProject.current = nil
FileSystemProject.current

ClipTimeline(\bla).edit
~p = ClipTimeline(\bla)
~px = PlayerWrapper(~p)
~px = PlayerWrapper(~px)
PlayerWrapper(ClipTimeline(\bla)).edit

FileSystemProject.current.mainTimeline.presetCompileString.editorInsert
ClipTimeline('sun55_mainTimeline').edit
ClipTimeline('sun55_mainTimeline').play
ClipTimeline('sun55_mainTimeline').recordedEvents.do(_.postln)
ClipTimeline('sun55_mainTimeline').recordedEvents.asCompileString
(
ClipTimeline('sun55_mainTimeline').tracks = [ ( 'index': 0, 'recordArmed': true, 'recordBus': BusDef('trackMixerDef_record_mixer0'), 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': BusDef('trackMixerDef_record_mixer1'), 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('sun55_mainTimeline').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \midinote: 1.0, \playDur: 0.0, \relDur: 0.0, \sustain: 100.0, \timeline: { SampleTimeline('rec_sun55_mainTimeline_t0_240423_040239') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 64.0, \label: 'ghostdrums', \midinote: 0, \playDur: 64.0, \relDur: 64.0, \sustain: 12.0, \timeline: { SampleTimeline('rec_sun55_mainTimeline_t0_240423_042626') }, \type: 'pattern', )),
	(\absTime: 64.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;
ClipTimeline('sun55_mainTimeline').recordedEvents = [ PatternEvent((playDur: 8.0, dur: 8.0, sustain: 132.0, midinote: 0, timeline: { SampleTimeline('rec_sun55_mainTimeline_t0_240423_033928') }, relDur: 8.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 8.0, dur: 8.0, sustain: 132.0, midinote: 1, timeline: { SampleTimeline('rec_sun55_mainTimeline_t1_240423_033928') }, relDur: 8.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 8.0, dur: 8.0, sustain: 136.0, midinote: 0, timeline: { SampleTimeline('rec_sun55_mainTimeline_t0_240423_034339') }, relDur: 8.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 8.0, dur: 8.0, sustain: 136.0, midinote: 1, timeline: { SampleTimeline('rec_sun55_mainTimeline_t1_240423_034339') }, relDur: 8.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 8.0, dur: 8.0, sustain: 88.0, midinote: 0, timeline: { SampleTimeline('rec_sun55_mainTimeline_t0_240423_035848') }, relDur: 8.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 8.0, dur: 8.0, sustain: 24.0, midinote: 0, timeline: { SampleTimeline('rec_sun55_mainTimeline_t0_240423_040146') }, relDur: 8.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 0.0, dur: 0.0, sustain: 100.0, midinote: 1.0, timeline: { SampleTimeline('rec_sun55_mainTimeline_t0_240423_040239') }, relDur: 0.0, type: 'pattern', absTime: 0.0)), PatternEvent((dur: 64.0, absTime: 0.0, playDur: 64.0, midinote: 0, type: 'pattern', relDur: 64.0, timeline: { SampleTimeline('rec_sun55_mainTimeline_t0_240423_042626') }, label: 'ghostdrums', sustain: 12.0)) ];

SampleTimeline('rec_sun55_mainTimeline_t0_240423_042626').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 12.0, \label: 'start', \playDur: 12.0, \relDur: 12.0, \sustain: 0, \type: 'start', ),
	(\absTime: 12.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_sun55_mainTimeline_t0_240423_042626').buffer = BufDef('cliprec/rec_sun55_mainTimeline_t0_240423_042626.wav');
SampleTimeline('rec_sun55_mainTimeline_t0_240423_042626').postPatternPreset = (  );

SampleTimeline('rec_sun55_mainTimeline_t0_240423_040239').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 100.0, \playDur: 100.0, \relDur: 100.0, \sustain: 0, \type: 'start', ),
	(\absTime: 100.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_sun55_mainTimeline_t0_240423_040239').buffer = BufDef('cliprec/rec_sun55_mainTimeline_t0_240423_040239.wav');
SampleTimeline('rec_sun55_mainTimeline_t0_240423_040239').postPatternPreset = (  );



);


0.ampdb

TrackDef(\split).childAt(1).mixer.getParam(\postfader).get
TrackDef(\split).childAt(1).mixer.proxy.edit

ProtoDef(\apc40).childAtOffset(Point(0,0)).play
PlayerWrapper(ProtoDef(\apc40).childAtOffset(Point(0,0))).play
~c = ProtoDef(\apc40).childAtOffset(Point(0,0))
~c.play
~c.stop
~c.playMode
~p = PlayerWrapper(ProtoDef(\apc40).childAtOffset(Point(0,0)))
~p.play
~p.stop

PlayerWrapper(ProtoClass((play: {"hhh".debug}))).play

TrackDef(\split).source = [ [ Pdef(\haha) ], [ Pdef(\haha2) ] ];
TrackDef(\split_fx).source = [ [ ProtoDef(\rdn), Pdef(\haha), Pdef(\haha2) ] ];
TrackDef(\split_fx).edit
TrackDef(\split).edit
TrackDef(\split).isMixerEnabled
FileSystemProject.current

(
Pdef(\haha, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\octave, 4,
		\dur, 1,
		\amp, 0.1,

	)
).play;
Pdef(\haha2, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([1,2,4,0],inf),
		\dur, 1/4,
		\amp, 0.1,

	)
).play;
);

TrackDef(\split).childAt(1).mixer.insertFxAt(8).edit
TrackDef(\split).childAt(0).mixer.insertFxAt(8).keys
TrackDef(\split).childAt(0).mixer.insertFxAt(8)
TrackDef(\split).childAt(0).mixer.insertFxAt(8).presetCompileString.editorInsert
(

);

//////////////////// draft fx
(
ProtoDef(\apc40).quickfxpad[0] = { arg self, apc, track;
	"play!!!".debug;

	self[\stop] = {
		"stop!!!".debug;
	}
}
)

(
k=MKtl(\apc, "akai-apc40mkii");
~grid = TrackDef(\split);
~grid.controller = ControllerDef(\apc40);
k.elAt(\bt, \device, 0, \devonoff, \on).action = {
	var fx = ~grid.childAt(~grid.activeIndex).mixer.insertFxAt(8);
	"hey".debug;
	fx.synthName = \ifx_stutter;
	fx.enabled = true;
	k.elAt(\kn, \d, 0, 0).mapParam(fx.getParam(\time).withSpec(TagSpec([1,1/2,1/4,1/8]/~t)));
	fx.getParam(\wet).set(1);
	fx.getParam(\mix).set(1);
};
k.elAt(\bt, \device, 0, \devonoff, \off).action = {
	var fx = ~grid.childAt(~grid.activeIndex).mixer.insertFxAt(8);
	fx.getParam(\wet).set(1);
	fx.getParam(\mix).set(0);
};
k.elAt(\bt, \device, 0, \devlock, \on).action = {
	var fx = ~grid.childAt(~grid.activeIndex).mixer.insertFxAt(9);
	"hey".debug;
	fx.synthName = \ifx_rlpf;
	fx.enabled = true;
	k.elAt(\kn, \d, 0, 0).mapParam(fx.getParam(\lpf));
	fx.getParam(\wet).set(1);
	fx.getParam(\mix).set(1);
};
k.elAt(\bt, \device, 0, \devlock, \off).action = {
	var fx = ~grid.childAt(~grid.activeIndex).mixer.insertFxAt(9);
	fx.getParam(\wet).set(1);
	fx.getParam(\mix).set(0);
};
)


///////////////////////////// draft

~assign_splitpart.(TrackDef(\split), Pdef(\part), 4)
Pdef.defaultQuant = 4
TrackDef(\split).sectionAt(0).source = ~splitpart.(\s1, Pdef(\part));
TrackDef(\split).sectionAt(4).source = ~splitpart.(\s1, Pdef(\part));

TrackDef(\split).key
TrackDef(\split).trackKey
TrackDef(\split).keys
TrackDef(\split).sectionAt(0).trackKey

Pdef(\part).play
FileSystemProject.current.key
FileSystemProject.loadProject("repeat/simpleProject")


~splitpart.(\s1, Pdef(\part))
Pdef(\part1).source
TrackDef(\split).elAt(0,0).source = Pdef(\part)
TrackDef(\split).elAt(0,0).source = nil
TrackDef(\split).elAt(0,0).source
TrackDef(\split).elAt(1,0).source
TrackDef(\split).elAt(0).source = [ Pdef(\part) ]
TrackDef(\split).sectionAt(0).source
TrackDef(\split).sectionAt(0).source = [ Pdef(\part), Pdef(\part2) ]
(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);


k = MKtl(\lp, "novation-launchpad-s");
k.elAt(\pad).elAt(0).elAt(0).elAt(0)
k.elAt(\pad).elAt(0).elAt(0).elAt(0).action = { "0 on pushed".postln; };
k.elAt(\pad).elAt(0).elAt(0).elAt(1).action = { "0 off pushed".postln; };
k.postElements;
k.elAt(\pad).elAt(0).elAt(0).elAt(0).value = 0.05;
MKtl.find
FileSystemProject.load("libdef/pdeftrack.scd");
FileSystemProject.load("libdef/apc.scd");
Pdef(\pdefgrid0_0, Pbind(\note, Pseq([0,1],inf), \dur, 1/8));
Pdef(\pdefgrid0_1, Pbind(\note, Pseq([3,4],inf), \dur, 1/8));
TrackDef(\pdefgrid).edit
ProtoDef(\apc40).activate(TrackDef(\pdefgrid));

ProtoDef(\apc40).map_rdn_to_bank(0, \rdn, [\delay, \delay2]);
ProtoDef(\apc40).activate_bank_selector
MKtl.find(\midi); // when was not connected
k=MKtl(\apc, "akai-apc40mkii");
MKtl(\apc).gui
k.elAt(\bt, \clip, 0,1)
k.elAt(\bt, \clip, 0,0, \on).action
k.elAt(\bt, \shift)
k.elAt(\bt, 8, \up)
k.elAt(\bt)
k.elAt(\bt, \clipS)
k.elAt(\bt, \device)
k.elAt(\bt, \track, \activ, 0, \on)
k.elAt(\sl, \master)
k.elAt(\sl,0,0)
k.elAt(\kn,\t, 0, 4)
k.elAt(\kn,\t, 2, 3)
k.elAt(\kn,\d, 0)

k.elAt(\bt, \clipColor, 0,0,\blink).value = 123/127
k.gui
k.reload
k.sendSpecialMessage(\abletonLiveMode)
k.trace
MKtl.paths
MKtl.postLoadedDescs
MKtlDesc.userFolder.openOS;
MKtlDesc.writeCache;
(
MIDIdef.noteOn(\track1, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	
});
)

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
PlayerWrapper(Pdef(\zed)).doWithQuant { "hello".debug; 0 }

TrackDef(\split).clear
(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
s.waitForBoot { FileSystemProject.loadOnce("sun/lib.scd"); };
TrackDef(\split, \PlayerGrid);
FileSystemProject.loadOnce("libdef/controllers.scd");
FileSystemProject.loadOnce("libdef/apc.scd");
~splitpart = { arg prefix, pat;
	var list = [];
	if(pat.source.isKindOf(Pdef)) {
		pat = pat.source;
	};
	if(pat.source.isKindOf(Ppar)) {
		list = pat.source.list;
		list = list.collect { arg item, idx;
			Pdef("%_%".format(prefix, idx).asSymbol, item);
		};
	};
	list;


};

~assign_splitpart = { arg tl, pat, idx, prefix;
	prefix = prefix ?? { \split };
	tl.sectionAt(idx).source = ~splitpart.("%%".format(prefix, idx), Pdef(\part));
}


)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
));
)
