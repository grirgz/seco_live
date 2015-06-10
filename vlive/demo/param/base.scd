
///////////////////////////////// first

(
Spec.add(\mididetune, ControlSpec(-24,24,\lin));
SynthDef(\fx, { arg out=0, amp=0.1, doneAction=2, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var detune1, detune2;
	var lpfratio, hpfratio;
	var freq;
	var pan;
	var stereodetune;
	var rq1, rq2;

	freq = \freq.kr(200);
	detune1 = \detune1.kr(0).midiratio;
	detune2 = \detune2.kr(0.1).midiratio;
	lpfratio = \lpfratio.kr(0).midiratio;
	hpfratio = \hpfratio.kr(1).midiratio;
	pan = \pan.kr(0);
	stereodetune = \stereodetune.kr(0.01);
	rq1 = \rq1.kr(0.4);
	rq2 = \rq2.kr(0.4);

	freq = freq * ( 1 + ( stereodetune * [1, -1] ) );

	sig1 = LFSaw.ar( freq*detune1 );
	sig2 = LFPulse.ar(freq*detune2);

	sig = sig1 + sig2;

	sig = RLPF.ar(sig, freq * lpfratio, rq1);
	sig = RHPF.ar(sig, freq * hpfratio, rq2);

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);

	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}, metadata:(specs:(
	stereodetune: ControlSpec(0.00001,1,\exp),
	lpfratio: \mididetune,
	hpfratio: \mididetune,
	detune1: \mididetune,
	detune2: \mididetune,
	spread: \unipolar,
))).add;

Pdef(\fx, Pbind()).addHalo(\instrument, \fx);
Spec.add(\adsr, XEnvSpec.adsr);
~padsr = Param(Pdef(\fx), \adsr);
Pdef(\fx, Pbind()).addHalo(\instrument, \fx);
~pg = Pdef(\fx).asParamGroup(\fx, false, [\gate, \freq, \out, \doneAction]);
)
~padsr.edit;
~pg.edit;

Pdef(\fx).controlNames
Pdef(\fx).asCompileString
Pdef(\fx).envir

Pdef(\fx).asCompileString
Pdef(\fx).envir = ( 'detune1': -0.375, 'hpfratio': 10.5, 'rq1': 0.20519176157214, 'spread': 0.5625, 'detune2': 0.75, 'lpfratio': 15.75, 'stereodetune': 0.0041417845143644,'rq2': 0.22572217000328 )
Pdef(\fx).asEvent

Pdef(\fx).envir.collect({ arg x; x.asCompileString })
Pdef(\fx).envir.asCompileString
Pdef(\fx).asCompileString
Pdef(\fx).asEnventCompileString
Pdef(\fx).asPatternCompileString.postln
(
	Pdef(\plop, 

		Pseq([
			Psync(Pbind(
				\instrument, \fx,
				\degree, Pseq([0,1,4,3, Prand([1,2,5],Pwhite(-1,5,1))],inf),
				\dur, Pseq([1/4,1/5,Pn(1/8,4), Prand([1/4,1,1/2])],inf),
				\amp, 0.1
			), 3,3),
			Psync(Pbind(
				\instrument, \fx,
				\degree, Pseq([Pwhite(-1,5,1).stutter(4)],inf),
				\dur, Pseq([1/4],inf),
				\amp, 0.1
			), 1,1),
		],inf)
		<> Pdef(\fx) 
	).play;
);

///////////////////////////////// second


(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var gate = LFPulse.kr(1/4).unipolar;
	sig = SinOsc.ar(freq * \freqtab.kr(1!8) * 
		EnvGen.ar(\freqenv.kr(Env([1,2,1],[1,1])),gate,doneAction:0)
	);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0);
	sig = Pan2.ar(sig, pan, amp).mean * 2;
}).play;
Spec.add(\adsr, XEnvSpec.adsr);
Ndef(\plop).addSpec(\freqenv, XEnvSpec( ControlSpec(0.1,4,\exp)!3, ControlSpec(0.1,4,\lin,0,0.1)));
Ndef(\plop).addSpec(\freqtab, XArraySpec( ControlSpec(0.1,4,\exp)!8));
~pg = Ndef(\plop).asParamGroup;
);
~pg.edit
Param( Ndef(\plop), \adsr ).type
Param( Ndef(\plop), \freqenv ).type
Ndef(\plop).asParamGroup.edit



/////////////////////////// combi

~pg1 = Pdef(\fx).asParamGroup(\fx, false, [\gate, \freq, \out, \doneAction]);
~pg2 = Ndef(\plop).asParamGroup;
~pgg = ParamGroup(~pg1 ++ ~pg2);
~pgg.edit


/////////////////////////// draft

Pdef(\fx, Pbind()).addHalo(\instrument, \fx)
Pdef(\fx, Pbind()).addHalo(\instrument, nil)
~pg = Pdef(\fx).asParamGroup(\fx, false, [\freq, \out, \doneAction])
~pg.edit
~pg.reject({})
Pdef(\fx).asParamGroup
Pdef(\fx).unset(\freq)


(
SynthDescLib.global.synthDescs[\fx].controls.reject({ arg con; con.name == '?' }).collect({ arg con;
	var p;
	con.name.debug("name");
	p = Param( Pdef(\fx), con.name );
	p.spec.debug("spec");
	p;
});
)
SynthDescLib.global.synthDescs[\fx].controls
~s = ControlSpec(0,0.0000001,\lin)
~s.map(1)
~s.unmap(0)
~s.unmap(1)

(
	~makegui = { arg pg;
		var win = Window.new;
		var layout;

		layout = GridLayout.rows(*
			pg.collect({ arg param;
					[
						
					param.asStaticTextLabel,
					param.asSlider.orientation_(\horizontal),
					param.asTextField,
					]
			})
		);
		layout.setColumnStretch(1,1);
		win.layout = layout;
		win.front;

	};
	~makegui.(~pg)
)

(
	~makegui = { arg pg;
		var win = Window.new;
		var layout;
		var gridlayout;
		var biglayout;
		var scalarlist, biglist;

		scalarlist = pg.select({ arg param; 
			param.type == \scalar;
		});
		biglist = pg.select({ arg param;
			param.type != \scalar;
		});

		gridlayout = GridLayout.rows(*
			scalarlist.collect({ arg param;
				[
					param.asStaticTextLabel,
					param.asSlider.orientation_(\horizontal),
					param.asTextField,
				]
			})
		);
		gridlayout.setColumnStretch(1,1);

		biglayout = VLayout(*
			biglist.collect({ arg param;
				VLayout(
					param.asStaticTextLabel,
					param.asView,
					param.asTextField,
				)
			})
		);

		layout = HLayout(
			gridlayout,
			biglayout
		);
		win.layout = layout;
		win.front;

	};
	~makegui.(~pg)
)

Param(Pdef(\fx), \adsr).spec
(
Pdef(\fx, Pbind()).addHalo(\instrument, \fx);
Spec.add(\adsr, XEnvSpec.adsr);
~p = Param(Pdef(\fx), \adsr);
)
~p.edit
XEnvSpec.adsr


(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var gate = LFPulse.kr(1/4).unipolar;
	sig = SinOsc.ar(freq * \freqtab.kr(1!8) * 
		EnvGen.ar(\freqenv.kr(Env([1,2,1],[1,1])),gate,doneAction:0)
	);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0);
	sig = Pan2.ar(sig, pan, amp).mean * 2;
}).play;
Spec.add(\adsr, XEnvSpec.adsr);
Ndef(\plop).addSpec(\freqenv, XEnvSpec( ControlSpec(0.1,4,\exp)!3, ControlSpec(0.1,4,\lin,0,0.1)));
Ndef(\plop).addSpec(\freqtab, XArraySpec( ControlSpec(0.1,4,\exp)!8));
~pg = Ndef(\plop).asParamGroup;
);
~pg.edit
Param( Ndef(\plop), \adsr ).type
Param( Ndef(\plop), \freqenv ).type
Ndef(\plop).asParamGroup.edit


XEnvSpec(\lofreq!3)


(n=40;
w = Window("MultiSlider Options", Rect(200, Window.screenBounds.height-550, 600, 450));f={    w.view.decorator = FlowLayout( w.view.bounds, 10@10, 10@2  );    m = MultiSliderView(w,Rect(0,0,580,200)); // default thumbWidth is 13    
m.value=Array.fill(n, {|v| 0.5+((0.3*v).sin*0.25)});    m.action = { arg q;q.value.postln;  };

    StaticText(w,380@18).string_("indexThumbSize or thumbSize"); 
	Slider(w,580@10).action_({arg sl; m.indexThumbSize=sl.value*444}).value_(0.5);
	StaticText(w,380@18).string_("valueThumbSize");    Slider(w,580@10).action_({arg sl; m.valueThumbSize=sl.value*24}).value_(0.5);    StaticText(w,580@18).string_("xOffset or gap");    Slider(w,580@10).action_({arg sl; m.xOffset=sl.value*50});    StaticText(w,580@18).string_("startIndex");    Slider(w,580@10).action_({arg sl; m.startIndex = sl.value *m.size};);
    CompositeView(w,580@10);//spaacer  
	Button(w,100@20).states_([["RESET",Color.red]])        .action_({ w.view.removeAll; f.value;  });    h=StaticText(w,450@18).string_("").stringColor_(Color.yellow);    Button(w,100@20).states_([["elasticMode = 0"],["elasticMode = 1",Color.white]])        .action_({|b| m.elasticMode = b.value});    Button(w,160@20).states_([["indexIsHorizontal = false"],["indexIsHorizontal = true",Color.white]])        .action_({|b| m.indexIsHorizontal = b.value.booleanValue}).value_(1);    Button(w,120@20).states_([["isFilled = false"],["isFilled = true",Color.white]])        .action_({|b| m.isFilled = b.value.booleanValue});    Button(w,120@20).states_([["drawRects = false"],["drawRects = true",Color.white]])        .action_({|b| m.drawRects = b.value.booleanValue}).valueAction_(1);    Button(w,100@20).states_([["drawLines = false"],["drawLines = true",Color.white]])        .action_({|b| m.drawLines = b.value.booleanValue});    Button(w,160@20).states_([["readOnly = false"],["readOnly = true",Color.white]])        .action_({|b| m.readOnly = b.value.booleanValue});    Button(w,120@20).states_([["showIndex = false"],["showIndex = true",Color.white]])        .action_({|b| m.showIndex = b.value.booleanValue});    Button(w,120@20).states_([["reference = nil"],["reference filled",Color.white],["reference random",Color.yellow]])        .action_({|b| b.value.booleanValue.if({            (b.value>1).if(                {m.reference=Array.fill(n, {1.0.rand})},                {m.reference=Array.fill(m.size, {0.5})} );                 },{ q=m.value;m.reference=[]; h.string="reference can't be returned to nil presently. please hit RESET." }            )        });    Button(w,180@20).states_([["fillColor = Color.rand"]]).action_({m.fillColor=Color.rand});    Button(w,180@20).states_([["strokeColor = Color.rand"]]).action_({m.strokeColor=Color.rand});    Button(w,180@20).states_([["background = Color.rand"]]).action_({m.background=Color.rand});
};f.value;w.front;
)
