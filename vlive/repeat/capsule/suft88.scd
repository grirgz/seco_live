
~t = 179/4/60; TempoClock.default.tempo = ~t;

(
	~swing=0.06;
Pdef(\part, Pdef(\pdefgrid0_0, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,2,1,3,
			],inf).stutter(2),
			\octave, 3,
			\dur, 1/4,
			\legato, 0.1,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1/10,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,2,1,3,
			],inf).stutter(4),
			\legato, Pseq([
				0,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\isRest, Pseq([
				1,1,0,0, 0,0,0,1,
				1,0,0,0, 0,1,0,1,
				1,0,0,0, 0,1,1,1,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\out, BusDef(\sendbus2, \audio),
		)),
		
	])
)).play;
);


FileSystemProject.load("libdef/pdeftrack.scd");
FileSystemProject.load("libdef/apc.scd");
Pdef(\pdefgrid0_0, Pbind(\note, Pseq([0,1],inf), \dur, 1/8));
Pdef(\pdefgrid0_1, Pbind(\note, Pseq([3,4],inf), \dur, 1/8));
TrackDef(\pdefgrid).edit
ProtoDef(\apc40).activate(TrackDef(\pdefgrid));

ProtoDef(\apc40).map_rdn_to_bank(0, \rdn, [\delay, \delay2]);
ProtoDef(\apc40).activate_bank_selector

ProtoDef(\patkitdef_apc).activate(PatKitDef(\ksh2c))
PatKitDef.all
PatKitDef(\bat).edit
PatKitDef(\ksh2c, PatKitDef(\ksh2b))
PatKitDef(\ksh2c).clear
PatKitDef(\ksh2c).edit
PatKitDef(\ksh2b).edit
PatKitDef(\ksh2c, PatKitDef(\ksh2b).source.deepCopy)
PatKitDef(\ksh2c).presetCompileStringSavePath = "capsule/PatKitDef_ksh2c.scd"
PatKitDef(\ksh2c).presetCompileStringSavePath = "capsule/PatKitDef_ksh2c.scd"
PatKitDef(\bla, PatKitDef(\ksh2c))
PatKitDef(\bla).edit

".".asAbsolutePath
(
WindowDef(\bla, {
	
	BasicButton.new.action_({
		Document.dir.debug;
	})
}).front
)
