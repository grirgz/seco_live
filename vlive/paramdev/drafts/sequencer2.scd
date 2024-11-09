
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
	mslider = Param( pdef, prop -> \stepseq, param.spec).asMultiSlider.attachContextMenu;

	mslider
	
});
//.front( Param(Pdef(\bete), \degree, ControlSpec(0,7,\lin,1,0)) );

Spec.add(\degree, ControlSpec(0,14,\lin,1));

WindowDef(\myseq, { arg def;
	VLayout (
		PlayerWrapper(Pdef(\bete)),
		WindowDef(\StepSeqParam).asView (
			Param(Pdef(\bete), \degree)
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

(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpfr: ControlSpec(0.1,4,\lin, 0, 1)
))).add;
);

MKtl('icon', "icon-icontrols");
MKtl(\icon)[\kn].mapParam(Param( Pdef(\bete), \degree -> \stepseq )); // map sequencer

(
// arbitrary param group mapping
MKtl(\icon)[\kn].mapParam([
	Param( Pdef(\bete), \degree -> \stepseq -> 1 ),
	Param( Pdef(\bete), \rq -> \stepseq -> 1 ),
])
)

ControllerDef(\icon).startControl((knobs:Param( Pdef(\bete), \rq -> \stepseq )));
ControllerDef(\icon).startControl((sliders:Param( Pdef(\bete), \lpfr -> \stepseq )));
ControllerDef(\icon).startControl((sliders:Param( Pdef(\bete), \degree -> \stepseq )));


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



///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
//// transform a Pbindef in a sequencer


(
	Pbindef(\myseq,
		\instrument, \saw,
		\degree, Pseq(0!8,inf),
		\lpfr, PstepSeq(1!8,inf),
		\rq, Pseq(0.1!8,inf),
		\isRest, Pseq(false!8,inf),
		\dur, 1/8,
		\amp, 0.1,
	).play;
	SynthDesc(\saw).addSpec(\lpfr,ControlSpec(0.1,4,\lin) );
Spec.add(\isRest, ParamBoolSpec(reverse:true));
Spec.add(\degree, ControlSpec(0,14,\lin,1));
)

(
WindowDef(\PbindefSeq, { arg def, target;
	VLayout (
		PlayerWrapper(target),
		VLayout (*
			target.source.pairs.clump(2).collect({ arg pair;
				pair.debug("pair");
				if(pair[1].source.isKindOf(ListPattern)) {
					var param = Param(target, pair[0] -> \stepseq);
					HLayout (
						param.asStaticTextLabel.fixedWidth_(60),
						param.asMultiSlider.attachContextMenu,
					)
				}
			}).select(_.notNil)
		)
	)
	
}).front(Pdef(\myseq));
);

//////////////////////////////////////


(
// first define a model which will store the score data, you can also use ProtoDef
~model = (
	bank: [
		PstepSeq(0!8),
		PstepSeq(0!8),
		PstepSeq(0!8),
		PstepSeq(0!8),
	],
	selector: PstepSeq(0!8,inf), // this pattern is the index in the list of sequences
	proxy: Pbindef(\help),
);
// define a pattern which will be our sequencer
Pbindef(\help,
	\instrument, \saw,
	\degree, Pswitch(~model.bank, ~model.selector),
	\amp, 0.1,
);
)

// this Param point to the first sequence in our bank
// we use Message construct since there is no PstepSeq Param wrapper
Param( Message(~model.bank[0] ), \list).edit;

(
// here we build the full GUI
WindowDef(\help, { arg def, model;
	VLayout (
		PlayerWrapper(model.proxy),
		VLayout (* // there is a star because VLayout does not want a list but several arguments
			model.bank.collect { arg seq, idx;
				// for each sequence, we create a label and a MultiSliderView
				HLayout (
					StaticText.new.string_("seq" + idx).fixedWidth_(50),
					Param( Message(seq), \list, ControlSpec(0,12,\lin,1)).asMultiSlider
				)
			};
		),
		// selector sequencer GUI
		HLayout (
			StaticText.new.string_("selector").fixedWidth_(50),
			Param( Message(model.selector), \list, ControlSpec(0,model.bank.size-1,\lin,1)).asMultiSlider,
		),
		// control the dur of the pattern
		Param(Pbindef(\help), \dur, ControlSpec(0.01,1,\exp)),
	)
}).front(~model);
)



// little trick to have your editor with you everywhere
~model[\edit] = { arg self; WindowDef(\help).front(self) }; // add an edit method to the model
Pbindef(\help).setModel(~model); // set it (extension method)
Pbindef(\help).edit; // now you can access the custom editor from your Pbindef





//////////////////////////////////////////
/// param cookbook


Pdefn(\bla, Pseq(0!8))
Param(Pdefn(\bla).source.list, \list).edit
Param(Pdefn(\bla).source.list, \list).edit
Param(Pdefn(\bla).source.list, \list).edit
~list = List[1,4,2,3]
Param(~list, \list).edit
~list

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 200 * PstepSeq(~list,inf),
			\dur, 1/4,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

///////// midi learn

(
// define a pattern
Pdef(\help, 
	Pbind(
		\instrument, \default,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
// the first knob you will turn will be assigned to this Param
MIDIFunc.cc({ arg val ...args;
	Param(Pdef(\help), \freq).normSet(val/127)
}).learn; // learn!
)

(
// you can also use MIDIdef to avoid mapping the same knob to several Param
MIDIdef.cc(\knob1, { arg val ...args;
	Param(Pdef(\help), \freq).normSet(val/127)
}).fix.learn; // fix it so CmdPeriod will not remove it
)


Param(Pdef(\help), \freq).setBusMode(true); // easy bus mode

//////// control a PopUpMenu

note:: You will have to clear the Pbindef if you executed the previous recipes because sequencer data and all other keys will remain::

code::
Pbindef(\help).clear;
Pbindef(\help).envir.clear;
::

Now let's write our three parts: the model, the GUI and the MIDI controller

code::
(
// define a pattern to play
Pbindef(\help,
	\degree, Pseq([3,1,2,0],inf),
).play;

// define a spec, we will select the instrument from this list
TagSpecDef(\instrlist, [\default, \saw]);

// define a GUI
WindowDef(\help, { arg def;
	Param(Pbindef(\help), \instrument, TagSpecDef(\instrlist)).asView; // display the list as a PopUpMenu
}).frontTop;
);

(
MIDIFunc.cc({ arg val ...args;
   	// setting the Param will automatically select the corresponding instrument in the list and update the PopUpMenu
	Param(Pdef(\help), \instrument, TagSpecDef(\instrlist)).normSet(val/127);
}).learn; // learn!
)
::

////////

(
Pdef(\help, 
	Pbind(
		// no instrument key to change it from GUI
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
WindowDef(\help, { arg def, proxy;
	var paramView = View.new;
	// SynthDef_keys is the Spec for all the SynthDefs keys from Param GlobalLibrary
	var instrparam = Param(proxy, \instrument, TagSpecDef(\SynthDef_keys));

	// any view have a followChange method, when view is closed, the hook is automatically removed to avoid errors
	paramView.followChange(proxy, \set, { arg view, model, msg, pairs;
		[view, model, msg, pairs].postln;
		if(pairs.notNil and: {pairs.includes(\instrument)}) {
			paramView.removeAll;
			paramView.layout = proxy.asParamGroup.asView;
		};
	});

	paramView.layout = proxy.asParamGroup.asView; // init

	VLayout (
		instrparam.asPopUpMenu,
		paramView;
	)
}).front(Pdef(\help));
);

PdefParam.instrument(Pdef(\help))
Pdef(\help).get(\instrument)
TagSpecDef(\SynthDef).list

/////////



(
WindowDef(\filedialog_save).front(nil,{ arg path;
	"save to this file %".format(path).debug;
})
)

(
WindowDef(\filedialog).front(nil,{ arg path;
	"load from this file %".format(path).debug;
})
)

(
WindowDef(\filedialog_sample).front(nil,{ arg path;
	"load this sample %".format(path).debug;
})
)

(
WindowDef(\GlobalLibrary).front(nil, { arg val; val.debug("selected") }, [
	\Clip, \AllTracks, \Timeline,
]);
)

(
WindowDef(\GlobalLibrary_open, { arg def, defaultValue, okHook, categories;
	var selected;
	VLayout (
		WindowDef(\GlobalLibrary).asView(nil, { arg val; 
			selected = val;
	   	}, categories),
		HLayout (
			BasicButton.new.string_("Cancel").action_({
				def.closeWindow;
			}),
			BasicButton.new.string_("Ok").action_({
				okHook.(selected);
				def.closeWindow;
			}),
		)
	)
}).front(nil, { arg val; val.debug("selected") })
)

////////

(
Pbindef(\myseq,
	\instrument, \saw,
	\degree, Pseq([4,1,0,2],inf),
	\dur, 1/8,
	\amp, 0.1,
).play;
)

Param(Pbindef(\myseq), \degree -> \stepseq, ControlSpec(0,12,\lin,1)).edit

(
WindowDef(\help, { arg def;
	VLayout (
		PlayerWrapper(Pbindef(\myseq)),
		Param(Pbindef(\myseq), \degree -> \stepseq, ControlSpec(0,12,\lin,1)).asMultiSlider,
		Param(Pbindef(\myseq), \lpfr, ControlSpec(0.1,4,\lin)).asView
	)
}).front;
);


/////
(
Pbindef(\myseq,
	\instrument, \saw,
	\degree, PstepSeq([4,1,0,2],inf),
	\isNote, PstepSeq(true!4,inf),
	\muter, Pif(Pkey(\isNote), 0,\rest),
	\dur, 1/8,
	\amp, 0.1,
).play;
)

(
ParamGroup([
	Param(Pbindef(\myseq), \degree -> \stepseq, ControlSpec(0,12,\lin,1)),
	Param(Pbindef(\myseq), \isNote -> \stepseq, ParamBoolSpec()),
]).edit
)

///////////////////////////////////// timeline
/////////////////// NoteTimeline

(
NoteTimeline(\help).eventList = TimelineEventList.newFrom(
	Pbind(
		\instrument, \default,
		\degree, Pseq((0..9),inf) % Pseq((3..16),inf),
		\dur, 1/8,
		\amp, 0.1,
	),
	64, // how many event to record
);
)

NoteTimeline(\help).edit

(
WindowDef(\help, { arg def;
	VLayout (
		NoteTimeline(\help).asPreview, // minimal view
		NoteTimeline(\help).asView, // full editor
	)
	
}).front;
);

////////////// KitTimeline

// this does not work, how to modify a Pbind ? transform it in a PbindProxy ?
(
~drums = [
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.kick[1010].value,
		\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
		\isRest, Pseq([
			1,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
	),
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.snare[1719].value,
		\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
		\isRest, Pseq([
			0,0,0,0, 1,0,0,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.11,
	),
]
)
KitTimeline(\help, ~drums);
KitTimeline(\help).edit

// OK

	(
	Pbindef(\kick,
		\instrument, \playersec,
		//\bufnum, ~buflib.kick[1010].value,
		\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
		\isRest, Pseq([
			1,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
	).play;
	)

	Pdef(\kick).clear
	Pdef(\snare).clear

(
~drums = [
	Pbindef(\kick,
		\instrument, \playersec,
		\bufnum, ~buflib.kick[1010].value,
		\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
		\isRest, Pseq([
			1,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
	),
	Pbindef(\snare,
		\instrument, \playersec,
		\bufnum, ~buflib.snare[1719].value,
		\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
		\isRest, Pseq([
			0,0,0,0, 1,0,0,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.11,
	),
]
)
(
~drums = [
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.kick[1010].value,
		\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
		\isRest, Pseq([
			1,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
	),
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.snare[1719].value,
		\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
		\isRest, Pseq([
			0,0,0,0, 1,0,0,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.11,
	),
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.hat[1064].value,
		\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
		\isRest, Pseq([
			1,0,1,0, 1,0,1,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.11,
	),
];
PatKitDef(\aze5, ~drums)
)
Pbindef(\kick).play;
PatKitDef(\aze5).edit
PatKitDef(\aze4).targets[0].source.play
KitTimeline(\help3, ~drums);
KitTimeline(\help3).edit

			(
				StepEvent((
					instrument: \playersec,
					bufnum: ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				))
			)
////
(
	PatKitDef(\mykit, [
				StepEvent.newFrom((
					instrument: \playersec,
					bufnum: ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				)),
				StepEvent.newFrom((
					instrument: \playersec,
					bufnum: ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				)),
	])
)
KitTimeline(\help4, PatKitDef(\mykit));
KitTimeline(\help4).edit

KitTimeline(\help5).edit

MIDIdef.trace
{ SinOsc.ar(500) ! 2 * 0.1}.play;



(
// 8 knobs with cc number from 16 to 23
(16..23).do { arg ccnum, idx;
	MIDIdef.cc(\knob+++idx, { arg val, channel, deviceId;
		[ val, channel, deviceId ].debug("cc");
		Param(Pbindef(\help), \lpfr -> \stepseq -> idx).normSet(val/127);
	}, ccnum); 
};
)
