
(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\freq, StepList[1000,300,200].asPattern.loop,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
Pdef(\zed).clear;

StepList[1000,300,200].asPattern.asStream.nextN(4)


(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, PstepSeq([1,3],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


(
Pdef(\bete, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([1,0,6,4],inf),
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);

Pbindef(\bete).source.at(\degree).source.list
Pbindef(\bete, \dummy,1).source

////////// simple sequencer

(
WindowDef(\StepSeq, { arg def, targetkey;
	var pdef = Pbindef(targetkey);
	var prop = \degree;
	var param = Param(Pdef(\bete), \degree, ControlSpec(0,7,\lin,1,0));
	var mslider = MultiSliderView.new;
	Pbindef(\bete, \dummy,1); // convert to Pbindef
	if(pdef.source.at(\degree).source.isNil) {
		Pbindef(targetkey, prop, PstepSeq([0,4,4,2],inf));
	};
	//if(Pbindef(tar))
	//8.collect({
		//Button.new.states_([
			//["X"],
			//[" "],
		//]).action_({
			//pdef.source.at(prop).source.list[idx] = view.value;
		//})
	//})
	mslider.value = param.spec.unmap(pdef.source.at(prop).source.list);
	mslider.elasticMode_(true)

			.indexThumbSize_(100)
			.step_(param.spec.step/param.spec.range)
			.isFilled_(true);
	mslider.action_({ arg view;
		pdef.source.at(prop).source.list = param.spec.map(view.value);
	});

	VLayout (
		PlayerWrapper(pdef),
		mslider,
		HLayout (
			Param(Message( pdef.source.at(prop).source), \list).asTextField,
			Param(Message(mslider), \size, ControlSpec(1,32,\lin,1,4)).asNumberBox.maxWidth_(80),
			Param(pdef, \dur, ControlSpec(1/8,2,\lin)).asTextField.maxWidth_(80),
		)
	)
	
}).front(\bete)
)

ControlSpec(0,100,\lin)
\freq.asSpec.map([0.2,1,0])
PstepSeq

ControlSpec(0,7,\lin,1,0).range

Pbindef(\bete, \degree, nil)

/////////////// sequence isRest and degree

(
WindowDef(\StepSeq, { arg def, param, showDur=false;
	var pdef = param.target;
	var prop = param.property;
	var mslider = MultiSliderView.new;
	Pbindef(pdef.key, \dummy,1); // convert to Pbindef
	if(pdef.source.at(prop).source.isNil) {
		Pbindef(pdef.key, prop, PstepSeq(param.spec.default ! 4,inf));
	};
	if(pdef.source.at(prop).source.isKindOf(Pseq)) {
		Pbindef(pdef.key, prop, PstepSeq(pdef.source.at(prop).source.list,inf));
	};
	mslider.value = param.spec.unmap(pdef.source.at(prop).source.list);
	mslider.elasticMode_(true)

			.fillColor_(ParamViewToolBox.color_ligth)
			.strokeColor_(Color.black)
			.indexThumbSize_(100)
			.step_(param.spec.step/param.spec.range)
			.isFilled_(false);
	mslider.action_({ arg view;
		pdef.source.at(prop).source.list = param.spec.map(view.value);
		pdef.source.at(prop).source.changed(\set);
	});
	mslider.followChange(pdef.source.at(prop).source, \cursor, { arg view, obj, msg, idx, idx2;
		[view, obj, msg, idx, idx2].debug("cursor");
		defer {
			mslider.index = idx;
		}
		
	});
	mslider.showIndex = true;

	VLayout (
		mslider,
		HLayout (
			*[
			Param(Message( pdef.source.at(prop).source), \list).asTextField,
			Param(Message(mslider), \size, ControlSpec(1,32,\lin,1,4)).asNumberBox.maxWidth_(80),
			] ++ if(showDur) {
				Param(pdef, \dur, ControlSpec(1/8,2,\lin)).asTextField.maxWidth_(80)
			} { [] }
		)
	)
	
});
//.front( Param(Pdef(\bete), \degree, ControlSpec(0,7,\lin,1,0)) );

// FIXME: dur is not working because does not set Pbindef but envir
//			but can override it with overlay menu
WindowDef(\myseq, { arg def;
	VLayout (
		PlayerWrapper(Pdef(\bete)),
		WindowDef(\StepSeq).asView (
			Param(Pdef(\bete), \degree, ControlSpec(0,7,\lin,1,0))
		),
		WindowDef(\StepSeq).asView (
			Param(Pdef(\bete), \isRest, ParamBoolSpec(reverse:true)),
			true 
		),
	)
}).front;


)

ParamBoolSpec().map(1)
ParamBoolSpec().default
Pbindef(\bete).source.at(\isRest).source.list
Pbindef(\bete).source.at(\dur).source = Pkey(\dur)
Pbindef(\bete).source.at(\dur).source  = 1/2
Pbindef(\bete).source.at(\dur).source  
Pbindef(\bete, \dur, 1/2)
Pbindef(\bete, \degree, 2)



/////////////// select sequencer by slider

(
WindowDef(\MultiStepSeq, { arg def, param, showDur=false;
	var pdef = param.target;
	var prop = param.property;
	var mslider = MultiSliderView.new;
	var vproxy = pdef.source.at(prop);
	var makeMSlider;
	var msliders;
	var whichproxy = PatternProxy.new;
	Pbindef(pdef.key, \dummy,1); // convert to Pbindef
	if(pdef.source.at(prop).source.isNil) {
		Pbindef(pdef.key, prop, PstepSeq(param.spec.default ! 4,inf));
	};
	if(pdef.source.at(prop).source.isKindOf(Pdict).not) {
		whichproxy = PatternProxy.new;
		Pbindef(pdef.key, prop, 
			Pdict([
				PstepSeq([0,0,0,0],1),
				PstepSeq([0,0,0,0],1),
				PstepSeq([0,0,0,0],1),
				PstepSeq([0,0,0,0],1),
			], whichproxy)
		);
	} {
		whichproxy = vproxy.source.which;
	};
	makeMSlider = { arg target;
		var mslider = MultiSliderView.new;
		mslider.value = param.spec.unmap(target.list);
		mslider.elasticMode_(true)

				.fillColor_(ParamViewToolBox.color_ligth)
				.strokeColor_(Color.black)
				.indexThumbSize_(100)
				.step_(param.spec.step/param.spec.range)
				.isFilled_(false);
		mslider.action_({ arg view;
			target.list = param.spec.map(view.value);
			target.changed(\set);
		});
		mslider.followChange(target, \cursor, { arg view, obj, msg, idx, idx2;
			[view, obj, msg, idx, idx2].debug("cursor");
			defer {
				mslider.index = idx;
			}
			
		});
		mslider.showIndex = true;
		mslider;
	};

	msliders = 4.collect({ arg idx;
		makeMSlider.(vproxy.source.dict[idx]);
	});

	VLayout (
		Param(Message(whichproxy), \source, ControlSpec(0,3,\lin,1,0)).asSlider.orientation_(\horizontal),
		VLayout (
			*msliders
		),
		HLayout (
			*[
			//Param(Message( vproxypdef.source.at(prop).source), \list).asTextField,
			Param(Message(mslider), \size, ControlSpec(1,32,\lin,1,4)).asNumberBox.maxWidth_(80),
			] ++ if(showDur) {
				Param(pdef, \dur, ControlSpec(1/8,2,\lin)).asTextField.maxWidth_(80)
			} { [] }
		)
	)
	
});
//.front( Param(Pdef(\bete), \degree, ControlSpec(0,7,\lin,1,0)) );

WindowDef(\myseq, { arg def;
	VLayout (
		PlayerWrapper(Pdef(\bete)),
		WindowDef(\MultiStepSeq).asView (
			Param(Pdef(\bete), \degree, ControlSpec(0,7,\lin,1,0))
		),
		WindowDef(\StepSeq).asView (
			Param(Pdef(\bete), \isRest, ParamBoolSpec(reverse:true)),
			true
		),
	)
}).front;


)


///////////: sequence with a sequencer

Pbindef(\bete, \instrument, \saw);

(
				ParamProto.init;
WindowDef(\SeqStepSeq, { arg def, param, showDur=false;
	var pdef = param.target;
	var prop = param.property;
	var mslider;
	var vproxy;
	var makeMSlider;
	var msliders;
	var whichproxy;
	Pbindef(pdef.key, \dummy,1); // convert to Pbindef
	vproxy = pdef.source.at(prop);
	if(pdef.source.at(prop).source.isKindOf(Pdict).not) {
		Pbindef(pdef.key, prop, 
			Pdict([
				PstepSeq([0,0,0,0],1),
				PstepSeq([0,0,0,0],1),
				PstepSeq([0,0,0,0],1),
				PstepSeq([0,0,0,0],1),
			], PstepSeq([0,0,0,0,],inf))
		);
	};
	whichproxy = vproxy.source.which;
	makeMSlider = { arg target, xspec;
		var mslider = MultiSliderView.new;
		var spec = xspec ? param.spec;
		mslider.value = param.spec.unmap(target.list);
		mslider.elasticMode_(true)

				.fillColor_(ParamViewToolBox.color_ligth)
				.strokeColor_(Color.black)
				.indexThumbSize_(100)
				.step_(spec.step/spec.range)
				.isFilled_(false);
		mslider.action_({ arg view;
			target.list = spec.map(view.value);
			target.changed(\set);
		});
		mslider.followChange(target, \cursor, { arg view, obj, msg, idx, idx2;
			[view, obj, msg, idx, idx2].debug("cursor");
			defer {
				mslider.index = idx;
			}
			
		});
		mslider.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
			if(buttonNumber == 1) {
				WindowDef(\OverlayMenu).front(mslider, x, y, { arg def;
					Param(Message(mslider), \size, ControlSpec(1,32,\lin,1,4)).asNumberBox.maxWidth_(100)
				} );
				false
			};
		});
		mslider.showIndex = true;
		mslider;
	};

	msliders = 4.collect({ arg idx;
		makeMSlider.(vproxy.source.dict[idx]);
	});

	VLayout (
		//Param(Message(whichproxy), \source, ControlSpec(0,3,\lin,1,0)).asSlider.orientation_(\horizontal),
		makeMSlider.(vproxy.source.which, ControlSpec(0,3,\lin,1,0)),
		VLayout (
			*msliders
		),
		HLayout (
			*[
			//Param(Message( vproxypdef.source.at(prop).source), \list).asTextField,
			] ++ if(showDur) {
				Param(pdef, \dur, ControlSpec(1/8,2,\lin)).asTextField.maxWidth_(80)
			} { [] }
		)
	)
	
});
//.front( Param(Pdef(\bete), \degree, ControlSpec(0,7,\lin,1,0)) );

WindowDef(\myseq, { arg def;
	VLayout (
		PlayerWrapper(Pdef(\bete)),
		WindowDef(\SeqStepSeq).asView (
			Param(Pdef(\bete), \degree, ControlSpec(0,7,\lin,1,0))
		),
		WindowDef(\StepSeq).asView (
			Param(Pdef(\bete), \lpfr, ControlSpec(1/4,4,\lin)),
		),
		WindowDef(\StepSeq).asView (
			Param(Pdef(\bete), \isRest, ParamBoolSpec(reverse:true)),
			true
		),
	)
}).front;


)


(
WindowDef(\win, { arg def;
	Param(Message(Pbindef(\bete).source.at(\degree).source.dict[0]), \list).asMultiSlider
}).front;
)

	Param(Message(Pbindef(\bete).source.at(\degree).source.dict[0]), \list).get


(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([1],inf),
		\degree, Pseq([0,0,3,4],inf) + Pkey(\degree),
		\dur, 1/2,
		\amp, 0.1,
	)
).play;
);

Pbindef(\zed, \dur, 1/4).play
Pbindef(\zed, \dur, 1/4)
Pbindef(\zed, \degree, Pseq([0,2,0,4],inf) + Pkey(\degree))
Pbindef(\zed).source.at(\degree).source =2
Pbindef(\zed).convertToPbindef

////////////////////////////////// integrate into param

(
Pdef(\bete, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([1,0,6,4],inf),
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);

(
				ParamProto.init;
WindowDef(\SeqStepSeq, { arg def, param, showDur=false;
	var pdef = param.target;
	var prop = param.property;
	var mslider;
	var vproxy;
	var makeMSlider;
	var msliders;
	var whichproxy;
	Pbindef(pdef.key, \dummy,1); // convert to Pbindef
	vproxy = pdef.source.at(prop);
	if(pdef.source.at(prop).source.isKindOf(Pdict).not) {
		Pbindef(pdef.key, prop, 
			Pdict([
				PstepSeq([0,0,0,0],1),
				PstepSeq([0,0,0,0],1),
				PstepSeq([0,0,0,0],1),
				PstepSeq([0,0,0,0],1),
			], PstepSeq([0,0,0,0,],inf))
		);
	};
	whichproxy = vproxy.source.which;
	makeMSlider = { arg target, xspec;
		var mslider = MultiSliderView.new;
		var spec = xspec ? param.spec;
		mslider.value = param.spec.unmap(target.list);
		mslider.elasticMode_(true)

				.fillColor_(ParamViewToolBox.color_ligth)
				.strokeColor_(Color.black)
				.indexThumbSize_(100)
				.step_(spec.step/spec.range)
				.isFilled_(false);
		mslider.action_({ arg view;
			target.list = spec.map(view.value);
			target.changed(\set);
		});
		mslider.followChange(target, \cursor, { arg view, obj, msg, idx, idx2;
			[view, obj, msg, idx, idx2].debug("cursor");
			defer {
				mslider.index = idx;
			}
			
		});
		mslider.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
			if(buttonNumber == 1) {
				WindowDef(\OverlayMenu).front(mslider, x, y, { arg def;
					HLayout (
						StaticText.new.string_("Step count:"),
						Param(Message(mslider), \size, ControlSpec(1,32,\lin,1,4)).asNumberBox.maxWidth_(100)
					)
				} );
				false
			};
		});
		mslider.showIndex = true;
		mslider;
	};

	msliders = 4.collect({ arg idx;
		makeMSlider.(vproxy.source.dict[idx]);
	});

	VLayout (
		//Param(Message(whichproxy), \source, ControlSpec(0,3,\lin,1,0)).asSlider.orientation_(\horizontal),
		Param(Message(vproxy.source.which), \list, ControlSpec(0,3,\lin,1,0)).asMultiSlider,
		//makeMSlider.(vproxy.source.which, ControlSpec(0,3,\lin,1,0)),
		VLayout (
			*msliders
		),
		HLayout (
			*[
			//Param(Message( vproxypdef.source.at(prop).source), \list).asTextField,
			] ++ if(showDur) {
				Param(pdef, \dur, ControlSpec(1/8,2,\lin)).asTextField.maxWidth_(80)
			} { [] }
		)
	)
	
});
//.front( Param(Pdef(\bete), \degree, ControlSpec(0,7,\lin,1,0)) );

WindowDef(\myseq, { arg def;
	VLayout (
		PlayerWrapper(Pdef(\bete)),
		WindowDef(\SeqStepSeq).asView (
			Param(Pdef(\bete), \degree, ControlSpec(0,7,\lin,1,0))
		),
		WindowDef(\StepSeq).asView (
			Param(Pdef(\bete), \lpfr, ControlSpec(1/4,4,\lin)),
		),
		WindowDef(\StepSeq).asView (
			Param(Pdef(\bete), \isRest, ParamBoolSpec(reverse:true)),
			true
		),
	)
}).front;


)


////// integrate simpler

(
WindowDef(\StepSeqParam, { arg def, param, showDur=false;
	var pdef = param.target;
	var prop = param.property;
	var mslider = MultiSliderView.new;
	pdef.convertToPbindef;
	if(pdef.source.at(prop).source.isKindOf(PstepSeq).not) {
		Pbindef(pdef.key, prop, PstepSeq(param.spec.default!4,inf));
	};
	mslider = Param( Message ( pdef.source.at(prop).source) , \list, param.spec).asMultiSlider.attachContextMenu;

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
			Param(Pdef(\bete), \isRest, ParamBoolSpec(reverse:true)),
			true
		),
		//Param(Message(Pdef(\bete).source.at(\dur)), \source, ControlSpec(0.05,4,\lin))
		Param(Pdef(\bete), \dur, ControlSpec(0.05,4,\lin)).asView
	)
}).front;


)

Pdef(\bete).source.at(\dur).source = 1/2
Pdef(\bete).source.at(\dur)
Pdef(\bete).source

//////////////////////// with buttons TODO

(
WindowDef(\StepSeqButton, { arg def, param, showDur=false;
	var pdef = param.target;
	var prop = param.property;
	var mslider = MultiSliderView.new;
	pdef.convertToPbindef;
	if(pdef.source.at(prop).source.isKindOf(PstepSeq).not) {
		Pbindef(pdef.key, prop, PstepSeq(param.spec.default!4,inf));
	};
	mslider = Param( Message ( pdef.source.at(prop).source) , \list, param.spec).asMultiSlider.attachContextMenu;

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
			Param(Pdef(\bete), \isRest, ParamBoolSpec(reverse:true)),
			true
		),
		//Param(Message(Pdef(\bete).source.at(\dur)), \source, ControlSpec(0.05,4,\lin))
		Param(Pdef(\bete), \dur, ControlSpec(0.05,4,\lin)).asView
	)
}).front;


)
