

(
KitTimeline(\kit_workspace, PatKitDef(\kit_workspace));
KitTimeline(\kit_workspace2, PatKitDef(\kit_workspace));

Pdef(\kitwork_sampler, StepEventDef(\kitwork_sampler).putAll((
	instrument: \playersec,
	dur: 4,
)).asPattern).addHalo(\edit, {
	WindowDef(\sampler).front(StepEventDef(\kitwork_sampler), true, Pdef(\kitwork_sampler))
});

TrackDef(\kit_workspace, TrackDef(\playergrid));
TrackDef(\kit_workspace).source = [
	[
		Pdef(\kick, Pbind(
			\instrument, \zkick,
			\freq, 200,
			//\dur, 1,
			\amp, 0.1
		)),
		Pdef(\snare, Pbind(
			\instrument, \zsnare,
			\freq, 200,
			\dur, 1,
			\amp, 0.1
		)),
		Pdef(\hat, Pbind(
			\instrument, \zhat,
			\freq, 200,
			\dur, 1,
			\amp, 0.1
		)),
		Pdef(\snapkick, Pbind(
			\instrument, \snapkick,
			\freq, 200,
			//\dur, 1,
			\amp, 0.1
		)),
		Pdef(\snapsnare, Pbind(
			\instrument, \snapsnare,
			\freq, 200,
			//\dur, 1,
			\amp, 0.1
		)),
		Pdef(\snaphat, Pbind(
			\instrument, \snaphihat,
			\freq, 200,
			\dur, 1,
			\amp, 0.1
		)),
		Pdef(\kitwork_sampler),
		Pdef(\kit_workspace),
	],
	[
		KitTimeline(\kit_workspace),
	],
	[
		KitTimeline(\kit_workspace2),
	],
	[
		ProtoDef(\kit_workspace_rdn, ProtoTemplateDef(\rdn))
	],
	[
		ProtoDef(\kit_workspace_rdn2, ProtoTemplateDef(\rdn))
	],
	[
		ProtoDef(\basicrecorder)
	],

];

ProtoDef(\basicrecorder).inbus = BusDef(\sendbus3);
ProtoDef(\kit_workspace_rdn).inbus = BusDef(\sendbus0);
);

TrackDef(\kit_workspace).edit;

WindowDef(\multigrid).front;

// END

Pdef(\kitwork_sampler).source.play
Pdef(\kitwork_sampler).source
Pdef(\kitwork_sampler).source = StepEventDef(\kitwork_sampler).asPattern
Pdef(\kitwork_sampler).asStream.next(())
StepEvent.newFrom((instrument: \plaxyersec)).asParamGroup
StepEvent.newFrom((instrument: \default)).play
EventPatternProxy.new.source_(StepEvent.newFrom((instrument: \default))).play
PlayerWrapper(EventPatternProxy.new.source_(StepEvent.newFrom((instrument: \default)))).play
SynthDesc(\bla).asParamGroup(Pdef(\bla))
SynthDesc(\bla).params
SynthDesc(\bliia)


Log(\Param).level = \debug

PatKitDef(\kit_workspace).clear;
TrackDef(\kit_workspace).clear;
PlayerWrapper(Pdef(\kick)).edit
~w = WindowDef(\playergrid).front(TrackDef(\kit_workspace)).window
~w.bounds = Rect(Window.screenBounds.origin.x, Window.screenBounds.origin.y, 100,110)
~w.bounds
WindowDef(\playergrid).window.bounds =  Rect(144, 217, 1090, 438);

BufDef('/home/ggz/Musique/sc/reckit/fix4/kick1.flac').free
BufDef('/home/ggz/Musique/sc/reckit/fix4/kick1.flac').play

(
)
Pdef(\kick).asParamGroup.edit
PlayerWrapper(NoteTimeline(\test3)).edit
NoteTimeline(\test3, Param(Pdef(\default), \midinote)).edit
Pdef(\default, Pbind(
	\instrument, \default,
	\dur, 1,
	\amp, 0.1
));


(
Pdef(\kit_workspace, Pbind(
	\instrument, \default,
	\degree, Pseq((1..8)*4,inf),
	\octave, 3,
	\dur, 1/8,
	\amp, 0.1
)).play;
);

Ndef(\nd)
ProtoDef(\rdn).keys
Ndef(\kit_workspace_rdn).stop
Ndef(\kit_workspace_rdn).end
s.latency = 0.2


// transform everything in soundscape : 6-233A-DN2C (\default ?)
// spece reverb \defdefault 6-TA6O-5EMF
// perfect bad reverb  \defdefault 6-IPBV-363F

StepEventDef(\bla).putAll(( bli:12 ))
StepEventDef(\bla)
