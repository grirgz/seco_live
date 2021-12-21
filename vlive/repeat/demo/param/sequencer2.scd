
(
WindowDef(\StepSeqParam, { arg def, param, showDur=false, defaultSize=4;
	var pdef = param.target;
	var prop = param.property;
	var mslider = MultiSliderView.new;
	pdef.convertToPbindef;
	if(pdef.source.at(prop).source.isKindOf(PstepSeq).not) {
		// NOTE: use List instead of Array because Array not implemented in Param
		Pbindef(pdef.key, prop, PstepSeq(List.newFrom(param.spec.default!defaultSize),inf));
	};
	mslider = Param( Message ( pdef.source.at(prop).source) , \list, param.spec).asMultiSlider.attachOverlayMenu;

	mslider
	
});
//.front( Param(Pdef(\bete), \degree, ControlSpec(0,7,\lin,1,0)) );

WindowDef(\myseq, { arg def;
	VLayout (
		PlayerWrapper(Pdef(\bete)),
		WindowDef(\StepSeqParam).asView (
			Param(Pdef(\bete), \degree, ControlSpec(0,7,\lin,1,0))
		),
		WindowDef(\StepSeqParam).asView (
			Param(Pdef(\bete), \lpfr, ControlSpec(0.1,2,\lin))
		),
		WindowDef(\StepSeqParam).asView (
			Param(Pdef(\bete), \rq, ControlSpec(0.1,1,\lin))
		),
		WindowDef(\StepSeqParam).asView (
			Param(Pdef(\bete), \isRest, ParamBoolSpec(reverse:true)),
			true
		),
		//Param(Message(Pdef(\bete).source.at(\dur)), \source, ControlSpec(0.05,4,\lin))
		Param(Pdef(\bete), \dur, ControlSpec(0.05,4,\lin)).asView
	)
}).front;


)

(
Pdef(\bete, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1165].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1549].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

/// TODO: accessor not implemented !!!
(
8.do { arg idx;
	MKtl('icon', "icon-icontrols");
	MKtl('icon')[\kn][idx].mapParam(Param( Message(Pdef(\bete).source.at(\lpfr).source), \list -> idx, ControlSpec(0,4,\lin)))
	
};
)
Param( Message(Pdef(\bete).source.at(\rq).source), \list).spec
Param( Message(Pdef(\bete).source.at(\rq).source), \list, ParamArraySpec(PdefParam.toSpec(nil, Pdef(\bete), \lpfr))).size
Param( Message(Pdef(\bete).source.at(\rq).source), \list, PdefParam.toSpec(nil, Pdef(\bete), \lpfr)).size
(
Param( Message(Pdef(\bete).source.at(\rq).source), \list, ControlSpec(0,4,\lin) ).collect { arg item, idx;
	item.debug("item");
	
};
)
PdefParam.toSpec(nil, Pdef(\bete), \lpfr)
ControllerDef(\icon).startControl((knobs:Param( Message(Pdef(\bete).source.at(\rq).source), \list )));
ControllerDef(\icon).startControl((sliders:Param( Message(Pdef(\bete).source.at(\rq).source), \list, ControlSpec(0,4,\lin) )));

MKtl('icon')[\kn][0].action
Pdef(\bete).source.at(\lpfr).source.list
PstepSeq
Param( Message ( Pdef(\bete).source.at(\lpfr).source) , \list, ControlSpec(0,4,\lin)).at(0).edit
Param( Message ( Pdef(\bete).source.at(\lpfr).source) , \list, ControlSpec(0,4,\lin)).at(0).get
Param( Message ( Pdef(\bete).source.at(\lpfr).source) , \list, ControlSpec(0,4,\lin)).at(0).wrapper
Param( Message ( Pdef(\bete).source.at(\lpfr).source) , \list -> 0, ControlSpec(0,4,\lin)).getRaw
Param( Message ( Pdef(\bete).source.at(\lpfr).source.list[0]) , \value, ControlSpec(0,4,\lin)).get
Param( Pdef(\bete).source.at(\lpfr).source.list , 0, ControlSpec(0,4,\lin)).get
Param( Message ( Pdef(\bete).source.at(\lpfr).source.list[0]) , \value, ControlSpec(0,4,\lin)).edit
