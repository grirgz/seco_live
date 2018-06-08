
(
	ProtoDef(\simpleMixer).play;
ProtoDef(\rdn).play;
ProtoDef(\rdn2).play;
)
(
~master=	{
	"yay".debug;
	ProtoDef(\simpleMixer).play;
ProtoDef(\rdn).play;
ProtoDef(\rdn2).play;
	}
)
(
Pdef(\part, Pdef(\part1, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),

		Pdef(\basicbass, Pbind()) <>
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\octave, 3,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\mixer1, \audio),
		),
	])
)).play;
)


ProtoDef(\rdn).edit
ProtoDef(\rdn2, ProtoTemplateDef(\rdn)).edit

ProtoDef(\apc40).startControl
ProtoDef(\apc40).midimap(\tk1, Param(Pdef(\basicbass), \lpf, \freq))
Param(Pdef(\basicbass), \lpf, \freq).setBusMode
(
ProtoDef(\apc40).bank_actions[0] = { arg self;
	self.midimap(\dk1, Param(Ndef(\rdn), \delay));
	self.midimap(\dk2, Param(Ndef(\rdn), \delay2));
	self.midimap(\dk4, Param(Ndef(\rdn), \fb));
	
	self.midimap(\dk5, Param(Ndef(\rdn), \distamp));
	self.midimap(\dk8, Param(Ndef(\rdn), \gain));
};
ProtoDef(\apc40).bank_actions[1] = { arg self;
	self.midimap(\dk1, Param(Ndef(\rdn2), \delay));
	self.midimap(\dk2, Param(Ndef(\rdn2), \delay2));
	self.midimap(\dk3, Param(Ndef(\rdn2), \delay3));
	self.midimap(\dk4, Param(Ndef(\rdn2), \fb));
	
	self.midimap(\dk5, Param(Ndef(\rdn2), \distamp));
	self.midimap(\dk6, Param(Ndef(\rdn2), \distamp2));
	self.midimap(\dk7, Param(Ndef(\rdn2), \distamp3));

	self.midimap(\dk8, Param(Ndef(\rdn2), \gain));
};
)



MIDIMap(\bank_left, {
	m.noteOn(0, MIDIMap.controls[\bank_left][0]);
	ProtoDef(\apc40).clear_flats;
})
MIDIMap.get(\bank_left)
MIDIMap.controls[\bank_left][0]
MIDIMap.controls.keys
MIDIMap.responders.postTree
MultiLevelIdentityDictionary


(
Pdef(\part, Pdef(\part2, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,1, 1,1,0,1,
					0,1,1,1, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.07,
				\dur, 1/8/2,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),

		Pdef(\basicbass, Pbind()) <>
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\octave, 3,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\mixer1, \audio),
		),
	])
)).play;
ProtoDef(\rdn).play;
ProtoDef(\rdn2).play;
)



//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

(
ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
TrackDef(\mygrid, TrackTemplateDef(\playergrid));

TrackDef(\mygrid).childAt(0,0).source = Pdef(\part1);
TrackDef(\mygrid).childAt(0,1).source = Pdef(\part2);
ProtoDef(\apc40).activate(TrackDef(\mygrid));
	~master = {
		"master!".debug;
		ProtoDef(\apc40).render_grid;
		ProtoDef(\simpleMixer).play;
		ProtoDef(\rdn).play;
		ProtoDef(\rdn2).play;
		//Ndef(\drumgroup, \busgroup).set(\inbus, BusDef(\sendbus0)).play(BusDef(\mixer6).index, 2);
	};
);


~master.()


TrackDef(\apc_playergrid).ktl.sendSpecialMessage(\setLiveMode)
TrackDef(\apc_playergrid).ktl.resetActions
TrackDef(\apc_playergrid).ktl.elAt(\bt, \bank, [\up, \left,\down,\up]).do(_.resetAction)


(
Pdef(\echo, 
	Pmono(\fx_echo,
		\inbus, BusDef(\sendbus2),
		\dur, 1,
	),
).play;
Pdef(\echo).addHalo(\instrument, \fx_echo);
Pdef(\echo).addSpec(\pfmix, \unipolar);
		ProtoDef(\apc40).bank_actions[2] = { arg self;
			if(self.shiftModifier) {
				{
				 WindowDef(\PdefEditor).front(Pdef(\echo))
				}.defer;
			} {

				self.debug("se");
				self.mapParam([ \kn, \d, 0 ], Param(Pdef(\echo), \decay).setBusMode);
				self.mapParam([ \kn, \d, 3 ], Param(Pdef(\echo), \mix).setBusMode);

				self.mapParam([ \kn, \d, 4 ], Param(Pdef(\echo), \pfmix).setBusMode);
				self.mapParam([ \kn, \d, 5 ], Param(Pdef(\echo), \lpf).setBusMode);
				self.mapParam([ \kn, \d, 6 ], Param(Pdef(\echo), \hpf).setBusMode);
				self.mapParam([ \kn, \d, 7 ], Param(Pdef(\echo), \gain).setBusMode);

			};
		};
);

Pdef(\echo).asParamGroup
Pdef(\echo).getHalo(\instrument)
PdefParam.instrument(\echo)
