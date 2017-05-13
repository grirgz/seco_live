
////////////////////////////////////////////////////// ClipTimeline presetCompileString


FileSystemProject.load("ex3/part1_PatKitDef.scd");
PatKitDef(\part1).clear;
PatKitDef(\part1).edit;
KitTimeline(\perc, PatKitDef(\part1));
KitTimeline(\perc).asPatternEvent.asCompileString
KitTimeline(\perc).asPlayerEvent;
PlayerEvent((receiver: { KitTimeline('perc')  }, type: 'player'))
 PlayerEvent(('receiver': { KitTimeline('perc')  }, 'type': 'player'))
KitTimeline(\perc).edit;
KitTimeline(\perc).clear;
FileSystemProject.load("ex3/draft_ClipTimeline.scd");
ClipTimeline(\clips).edit;
ClipTimeline(\clips).clear
ClipTimeline(\clips).presetCompileString;
ClipTimeline(\clips).savePresetCompileString
ClipTimeline(\clips).eventList[1]
ClipTimeline(\clips).eventList[1].timeline
ParamProto.init(true)

~ev =  (\absTime: 0.5, \dur: 0.5, \midinote: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 1.0, \timeline: { KitTimeline('perc') }, \type: 'pattern', ) 
~ev.timeline

(
{
	var bla=3;
	{ bla }
}.value.asCompileString
)


(
ProtoClass((
	key: \ibla,
	refCompileString: { arg self;
		"hello(%)".format(self.key)
	
	},
	bla:4
))
)

////////////////////////// saving playergrid

	(
	~presetCompileStringSavePath = { arg self, val;
		self[\presetCompileStringSavePath] = val;
		self.source.do({ arg column;
			column.source.do({ arg player;
				var player_prefix;
				var savepath;
				try {
					player_prefix = player.class.asString;
					if(player_prefix == "ProtoClass") {
						if( player.protoClass.notNil ) {
							player_prefix = player.protoClass;
						} {
							player_prefix = player.all.key;
						}
					};
					savepath = "%%_%.scd".format(val, player_prefix, player.key);
					savepath.debug("savepath");

					//player.presetCompileStringSavePath = "%%".format(val, );
				} {
					postln( "can't deduce saving path of player: "++player );
				}
			
			})
		})
	};
	~presetCompileStringSavePath.(TrackDef(\part1), "ex3/part1_")


	)

/////////////////////// try

(
{
	var bla = 2;
	bla = 3;
	try {
		bla = 4;
		nil.sdfsdf;
		bla = 8;
	} { arg ex;
		bla.debug("bla");
		//ex.class.gui;
		ex.reportError;
		ex.errorString.debug;
	};


}.value
)

////////////// playerWrapper method calling
PlayerWrapper(ProtoClass((bla:3))).

PathName("ex3/part1_data/bla.scd").pathOnly

//////////////////////


		FileSystemProject.load("ex3/lib.scd");
		FileSystemProject.load("libdef/drumkit.scd");
PatKitDef(\blap).edit


///////////////////// save paramgroup preset

(
	{ 
		var xthis = ~pg;
		var ret;
		var params, presets;
		params = xthis.collect({ arg param;
			"\t" ++ param.asCompileString
		}).join(",\n");
		presets = xthis.presets.keys.as(Array).collect({ arg key;
			"\t% -> %".format(key.asCompileString, xthis.presets[key].asCompileString)
		}).join(",\n");
		ret = "ParamGroupDef(%, [\n%\n]);\n".format(xthis.key.asCompileString, params);
		ret = ret ++ "ParamGroupDef(%).presets = IdentityDictionary[\n%\n];\n".format(xthis.key.asCompileString, presets);
		ret;
	}.value
)
(
~pg = ParamGroupDef(\xbla, [
	Param(Ndef(\police), \amp)
])
)
~pg.presets = [ \bla -> [0.21], \bli , 0.23] ]
~pg.presets.asCompileString
~pg.edit
~pg.save(\hi)
~pg.save(\ou)

(
ParamGroupDef(\xbla).presets = IdentityDictionary[
		'hi' -> [ 0.11660878932541 ],
		'ou' -> [ 0.15763746366398 ]
];
)

Param(Ndef(\plop), \bla) == Param(Ndef(\plop), \bla)
PlayerWrapper(Ndef(\police)).presetCompileString
Ndef(\plop).asParamGroup.presetCompileString
Ndef(\plop).asParamGroup.presetCompileString
ParamGroup(Ndef(\plop).asParamGroup)
ParamGroup(Ndef(\plop).asParamGroup)
Ndef(\police).getHalo(\ParamGroup)
Ndef(\police).addHalo(\ParamGroup, nil)

(
ParamGroup([

]).presets = IdentityDictionary[

];

)

(
Ndef('police').addHalo(\ParamGroup,
ParamGroup([

]).presets = IdentityDictionary[

];

);

)

(
Ndef(\draft, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
PlayerWrapper(Ndef(\draft)).presetCompileString
PlayerWrapper(Ndef(\draft)).edit
WindowDef(\NdefEditor).front(Ndef(\draft))
ParamProto.init
EventClass.presetSelectorView.(Ndef(\draft).asParamGroup)

////////////////////////////////// save ndefpreset


(
Ndef(\testpre, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(\fmf1.kr(2/1)*~t * ( 1 + ( SinOsc.ar(\fmf2.kr(1/2)*~t) * 1 ))) * 1 )));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


ProtoDef(\testpre_preset0).protoClass

ProtoDef(\NdefPreset).keys

(
TrackDef(\testpregrid, TrackDef(\playergrid)).source = [
	8.collect { arg x; ProtoDef(\testpre_preset+++x, ProtoDef(\NdefPreset).new(Ndef(\testpre))).debug("kj"); },
	[
		Ndef(\testpre)
	],

]
)

ProtoDe
TrackDef(\testpregrid).edit;
TrackDef(\testpregrid).clear
TrackDef(\testpregrid).presetCompileStringSavePath = "ex3/test_data/"
TrackDef(\testpregrid).savePresetCompileString
TrackDef(\testpregrid).childAt(0,0).proxy.target

//////////////////////////////// tooltip

(
WindowDef(\bla, { arg def;
	Button.new.toolTip_("hello")
}).front
)

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

WindowDef(\PdefEditor).front(Pdef(\plop))
NoteTimeline(\bla, Param(Pdef(\plop), \midinote)).edit

/////////////////////////// WindowName
(
WindowDef(\bla, { arg def;
	def.windowName = "My Window Name";

	Button.new.toolTip_("hello")
}).front
)

(
WindowDef(\blablop, { arg def;
	var vv = WindowDef(\bla).asView;
	def.windowName = "azerty";
	VLayout(
		StaticText.new.string_(vv.windowName),
		vv,
		nil,
	)

}).front
)

///////////////////////////////// NoteTimeline lose sync when adding notes

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
));
);
NoteTimeline(\plop2, Param(Pdef(\plop), \midinote)).edit
