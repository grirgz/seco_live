
//////////// mapping MIDI to PlayerWrapper 


(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.8
)).play;
Pdef(\plop).addHalo(\instrument, \default);
);

Pdef(\plop).asParamGroup.edit
MIDIMap.learn

MIDIMap(\a1, PlayerWrapper(Pdef(\plop)))
MIDIMap(\a1, nil)


/////////////////////////// learn last tweaked

Param.lastTweaked
MIDIMap(\loop, { MIDIMap.learn })

/////////////////////////// show currently edited value

(
WindowLayout({
	var pg = Pdef(\plop).asParamGroup;
	var curval = StaticText.new;
	var editcurval = TextField.new;
	curval.string = "---";
	curval.onChange(Param, \lastTweaked, { arg view; 
		"heyxxxxxxxxxxx".debug;
		view.string = "%: %".format(Param.lastTweaked.asLabel, Param.lastTweaked.stringGet);
		editcurval.mapParam(Param.lastTweaked);
	});
	VLayout (
		VLayout(
			*pg.collect({ arg param;
				HLayout(
					param.asStaticTextLabel,
					param.asSlider.orientation_(\horizontal),
				)
			}),
		),
		HLayout(
			curval,
			editcurval,
		)
	)
})
)

~sr = SimpleController(Param).put(\yep, { "yyyy".debug })
Param.changed(\yep)

Param.changed(\lastTweaked)
Param.lastTweaked.stringGet
Param.lastTweaked.name
