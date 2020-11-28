
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
	\freq, 400,
	\dur, 1,
	\amp, 0.1,
));
Pdef(\bla3, Pbind(
	\instrument, \default,
	\freq, 800,
	\dur, 1,
	\amp, 0.1,
));
Pdef.defaultQuant = 8;

TrackDef(\mygrid).edit;
)

(
ParamViewToolBox.color_dark = Color.newHex("377811");
ParamViewToolBox.color_playing = ParamViewToolBox.color_dark;

ParamViewToolBox.color_userPlayed = ParamViewToolBox.color_light;
ParamViewToolBox.color_userStopped = ParamViewToolBox.color_light;
TrackDef(\mygrid).edit;
)
