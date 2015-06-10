

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
)

(
Pdef(\fx, Pbind()).addHalo(\instrument, \fx);
Spec.add(\adsr, XEnvSpec.adsr);
~padsr = Param(Pdef(\fx), \adsr);
Pdef(\fx, Pbind()).addHalo(\instrument, \fx);
~pg = Pdef(\fx).asParamGroup(\fx, false, [\gate, \freq, \out, \doneAction]);
)
~padsr.edit;
~pg.edit;

(
	Pdef(\plop, 

		Pbind(
			\instrument, \fx,
			\degree, Pseq([0,1,4,3],inf),
			\dur, 1/4,
			\amp, 0.1
		)
		<> Pdef(\fx) 
	).play;
);










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
	sig = Pan2.ar(sig, pan, amp);
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
