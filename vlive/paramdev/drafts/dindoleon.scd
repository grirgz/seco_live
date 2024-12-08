
this.executeFile( ( "~/code/sc/seco/vlive/repeat/libdef/Graphical_Module/GM_main.scd" ).standardizePath );

~gmo
~gm.at( \simpleButton )
~gm.keys
(
WindowDef(\win, { arg def;
	var my_button = ~gm.at( \simpleButton ).value ; 
	var feedbackButton = ~gm.at( \feedbackButton ).value(
			backColor: Color.red,
			feedbackColor: Color.black,
			borderColor: Color.green,
			backgroundColor: Color.blue,
			font: Font.default,
			fontColor: Color.white,
			hasBorderInset: true,
			borderSize: 16,
			text: "Click me !",
			animationLength: 20;
		); 
	var slider = ~gm.at( \diamondSlider ).value(
		minVal: 55,
		value: 110,
		maxVal: 880,
	);
	VLayout (
		my_button,
		feedbackButton,
		slider
	)
}).front;
);


(
	var win = Window(
		"GM Example",
		Rect(
			100,
			100,300,
			150
		)
	);
	var slider = ~gm.at( \diamondSlider ).value(
		minVal: 55,
		value: 110,
		maxVal: 880,
		setGrowthType: \exp
	);
	var synth;
	SynthDef( \sine, {
		| out = 0, freq = 110, amp = 0.25 |
		var snd = SinOsc.ar( freq, mul: amp );
		Out.ar( out, [ snd, snd ] )
	} ).add;
	slider.bindFunction( { | newValue |
		synth.set( \freq, newValue );
		( "You slided to " ++ newValue.asString ).postln } );
		win.layout_(
			VLayout(
				slider
			)
		);
		SystemClock.sched( 0.01, { synth = Synth( \sine ) } );
		win.front;
)

(
	var win = Window(
		"GM Example",
		Rect(
			100,
			100,300,
			150
		)
	);
	var slider = ~gm.at( \diamondSlider ).value(
		minVal: 55,
		value: 110,
		maxVal: 880,
		setGrowthType: \exp
	);
	var synth;
	SynthDef( \sine, {
		| out = 0, freq = 110, amp = 0.25 |
		var snd = SinOsc.ar( freq, mul: amp );
		Out.ar( out, [ snd, snd ] )
	} ).add;
	slider.bindFunction( { | newValue |
		synth.set( \freq, newValue );
		( "You slided to " ++ newValue.asString ).postln } );
		win.layout_(
			VLayout(
				slider
			)
		);
		SystemClock.sched( 0.01, { synth = Synth( \sine ) } );
		win.front;
)

(
WindowDef(\win, { arg def, param;
	
	var slider = ~gm.at( \diamondSlider ).value(
		minVal: 0,
		value: 0,
		maxVal: 1,
		growthType: \lin
	);
	slider.addUniqueMethod(\mapParam, { arg view, param;

		var con;
		if(param.isNil) {
			slider.bindFunction({});
			slider.getHalo(\paramListener) !? { arg x; x.remove };
			view.addHalo(\paramListener, nil);
		} {
			slider.bindFunction({ arg val;
				val.debug("val");
				param.normSet(val);
			});
			con = param.makeListener({ arg lview, pa;
				if(lview.isClosed) {
					con.remove;
				} {
					lview.setValue(pa.normGet)
				}
		   	}, slider);
			view.addHalo(\paramListener, con);
		}

	});
	slider.mapParam(param);
	//slider.mapParam(nil);
	//slider.bindFunction({ arg val;
		//val.debug("val");
		//param.normSet(val);
	//});
	//slider.followChange(param, \set, {
		//slider.setValue(param.normGet)
	//});
	~slider = slider;
	//slider.debug("slider");
	VLayout (
		param.asView,
		slider,
	)
}).front( Param(~synth, \freq, \freq) );
);

~synth = Synth(\sine);

~slider.setValue(1)

~slider.mapParam(nil)
~slider.mapParam( Param(Pdef(\zed), \freq) )
WindowDef(\win).front( Param(Pdef(\zed), \freq) )
~synth = Synth(\sine); WindowDef(\win).front( Param(~synth, \freq, \freq) );
~synth = Synth(\sine);
~synth.run

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

/////////////////////////////// demo to send

(
// make GM widgets aware of Param

~addParamMethods = { arg mview, param;
	
	mview.addUniqueMethod(\mapParam, { arg view, param;

		var con;
		if(param.isNil) {
			view.bindFunction({});
			view.getHalo(\paramListener) !? { arg x; x.remove };
			view.addHalo(\paramListener, nil);
		} {
			view.bindFunction({ arg val;
				//val.debug("val");
				param.normSet(val);
			});
			view.getHalo(\paramListener) !? { arg x; x.remove };
			con = param.makeListener({ arg lview, pa;
				if(lview.isClosed) {
					con.remove;
				} {
					lview.setValue(pa.normGet)
				}
			   }, view);
			view.addHalo(\paramListener, con);
		}

	});
	mview.addUniqueMethod(\unmapParam, { arg v; v.mapParam(nil) })
}
)


(
// demo GUI
WindowDef(\gmdemo, { arg def, param;
	
	var slider = ~gm.at( \diamondSlider ).value(
		minVal: 0,
		value: 0,
		maxVal: 1,
		growthType: \lin
	);
	~addParamMethods.(slider);
	slider.mapParam(param);
	VLayout (
		PlayerWrapper(param.target),
		param.asView,
		slider,
	)
});
);

(
// some object to control
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

WindowDef(\gmdemo).front( Param(Pdef(\zed), \freq, \freq) );

// note that if freq is defined in Pbind, setting its value with GUI will not work because it use Pdef(...).set
// you can use Pbindef and \source modifier to workaround this limitation of Pdef
(
Pbindef(\zed2, 
	\instrument, \default,
	\degree, Pseq([0,3,1],inf),
	\dur, 1,
	\amp, 0.1,
).play;
);

WindowDef(\gmdemo).front( Param(Pbindef(\zed2), \degree -> \source, ControlSpec(0,12,\lin,1,0)) );
Param(Pbindef(\zed2), \degree -> \source, ControlSpec(0,12,\lin,1,0)).midiLearn
Param(Pbindef(\zed2), \dur -> \source, ControlSpec(0.051,1,\lin,0,1)).midiLearn
Param(Pbindef(\zed2), \degree -> \source, ControlSpec(0,12,\lin,1,0)).midiUnmap
Param(Pbindef(\zed2), \degree -> \source, ControlSpec(0,12,\lin,1,0)).midiMapList
Param(Pbindef(\zed2), \dur -> \source, ControlSpec(0,12,\lin,1,0)).midiMapList
Param.getMidiMappedParams(49)

MIDIdef.trace

Halo.lib




////////////////////// simplify


(
// make GM widgets aware of Param

~addParamMethods = { arg mview, param;
	
	mview.addUniqueMethod(\mapParam, { arg view, param;
		if(param.isNil) {
			view.bindFunction({});
			param.removeListener(view);
		} {
			view.bindFunction({ arg val;
				param.normSet(val);
			});
			param.attachListener(view, { arg lview, pa; lview.setValue(pa.normGet) })
		}
	});
	mview.addUniqueMethod(\unmapParam, { arg v; v.mapParam(nil) })
}
)
