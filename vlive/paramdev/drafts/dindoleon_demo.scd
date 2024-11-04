
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

WindowDef(\gmdemo).front( Param(Pdef(\zed), \freq, \freq) ); // now show the GUI !

// note that if \freq is defined in Pbind, setting its value with GUI will not work because it use Pdef(...).set
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


/////////////////////////////////////

~synth = Synth(\sine); WindowDef(\gmdemo).front( Param(~synth, \freq, \freq) );

~synth = Synth(\sine);
~synth.play
