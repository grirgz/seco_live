
//// steps
// - init
// - write a pattern base and play it
// - write the mod sequencer pattern and play it
// - write a WindowDef that show the sequencer
// - add inBusMode button and mod \dur
// - add PlayerWrapper for base and mod and base paramGroup
// - add a mixer
// - add some fx
// - add a ControllerSelectorView for seq and piano
// - add a ParamSelectorView

/// nice to have:
// - sequencer for base degree
// - keyboard piano view
// - presets
// - morphing
// - integration in TrackList

(
Pbindef(\base, 
	\instrument, \saw,
	\degree, Pseq([0,3,2,5],inf),
	\dur, 1/4,
	\amp, 0.1,
).play;
);

(
Pbindef(\mod, 
	\type, \paramSet,
	\param, Param( Pbindef(\base), \lpfr, ControlSpec(0.1,7,\exp) ),
	\val, PstepSeq((1..8)/3.2,inf),
	\play, {
		~param.set(~val)
	}
).play;
);

(
WindowDef(\win, { arg def;
	var seqparam = Param( Pbindef(\mod), \val -> \stepseq, Pbindef(\mod).source.at(\param).source.spec );
	var seqtarget = Param( Message( Pbindef(\mod).source.at(\param) ), \source );
	VLayout (
		HLayout (
			PlayerWrapper(Pdef(\mod)),
			Param( Pbindef(\mod), \dur, ControlSpec(0.01,2,\exp) ).asView,
			WindowDef(\ParamSelectorView).asView( seqtarget ),
			WindowDef(\ControllerSelectorView).asView( seqparam ),
		),
		seqparam.asView,
		HLayout (
			PlayerWrapper(Pdef(\base)),
			Param( Message( Pbindef(\mod).source.at(\param).source ), \inBusMode, ParamBoolSpec()).asButton,
			WindowDef(\ControllerSelectorView).asView( Param(Pbindef(\base), \midinote )),
		),
		HLayout (
			Pbindef(\base).asParamGroup.asView,
			TrackMixerDef(\track1).asView,
		)
	)
	
}).front;
);
