
TrackDef(\mygrid).childAt(0).activeIndex
ParamProto.init

TrackDef(\mygrid).childAt(0,0).proxy.changed(\bla)
TrackDef(\mygrid).childAt(0,0).target

(
FileSystemProject.load("libdef/tracks.scd");
TrackDef(\mygrid, TrackTemplateDef(\playergrid));

TrackDef(\mygrid).source =[
	[
		Pdef(\bla1),
		Pdef(\bla2),
		Pdef(\bla3),
	],
	[
		Pdef(\mouche1),
		Pdef(\mouche2),
		Pdef(\mouche3),
	],
];


Pdef(\bla1, Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1,
));
Pdef(\bla2, Pbind(
	\instrument, \default,
	\degree, Pstep(Pwhite(0,18).clip(Pseq((1..12),inf), Pseq((3..19),inf)),Pwhite(1,4*4)/8),
	\octave, 3,
	\dur, Pwhite(0.05,1),
	\amp, 0.1,
));
Pdef(\bla3, Pbind(
	\instrument, \default,
	\degree, Pseg(Pwhite(0,30,inf)-35,Pwhite(10,20)),
	\dur, 1,
	\amp, 0.1,
));
Pdef.defaultQuant = 4;

TrackDef(\mygrid).edit;
)

(
WindowDef(\win, { arg def;
	VLayout (
		PlayerWrapper(TrackDef(\mygrid)).asView,
		PlayerWrapper(TrackDef(\simpleProject_mainTrackGrid)).asView,
	)
}).front;
)

TrackDef(\simpleProject_mainTrackGrid)[ \isPlaying ].asCompileString

(
ParamViewToolBox.color_dark = Color.newHex("14232E");
ParamViewToolBox.color_light = Color.newHex("4E8086");
ParamViewToolBox.color_pale = Color.newHex("4E8086").add(Color.grey,0.4);
ParamViewToolBox.color_playing = ParamViewToolBox.color_light;

ParamViewToolBox.color_userPlayed = ParamViewToolBox.color_pale;
ParamViewToolBox.color_userStopped = ParamViewToolBox.color_pale;
TrackDef(\mygrid).edit;
)

PathName("./repeat/simpleMixer").normalizedPath
FileSystemProject.asRelativePath("repeat/simpleProject")

(
TrackDef(\simpleProject_mainTrackGrid).source =[
	[
		Pdef(\bla1),
		Pdef(\bla2),
		Pdef(\bla3),
	],
	[
		Pdef(\mouche1),
		Pdef(\mouche2),
		Pdef(\mouche3),
	],
];
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\degree, Pwhite(0,10),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

Pdef(\part).clear;
Pdef(\part).edit
