
(
Builder(\oscbuilder, { arg def, oscType=\sin, numVoices=4;
	SynthDef(def.key, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
		var sig;
		freq = freq * ((0..numVoices)/numVoices - 0.5 * \fspread.kr(0.1) + 1);
		sig = switch(oscType,
			\sin, { SinOsc.ar(freq)  },
			\saw, { LFSaw.ar(freq) },
			\pulse, { LFPulse.ar(freq, 0, \pulseWidth.kr(0.5)) }, // additionnal parameter
		);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
		sig = Pan2.ar(sig, pan, amp).mean;
		Out.ar(out, sig);
	}, metadata:(specs:(
		pulseWidth: \unipolar,
		fspread: ControlSpec(0.001,1,\exp),
	))).add;


	Pdef(def.key,
		Pbind(
			\instrument, def.key,
		),
	);
})
.addSpec(\name, ParamNonFloatSpec())
.addSpec(\oscType, TagSpec([\sin, \saw,\pulse]))
.addSpec(\numVoices, ControlSpec(1,64,\lin,1,1))
.build;

Spec.add(\adsr, ParamEnvSpec.adsr);
Spec.add(\out, ParamBusSpec());

Builder(\osc1, Builder(\oscbuilder)).build; 
Builder(\osc2, Builder(\oscbuilder)).build; 
)


(
WindowDef(\oscbuilder, { arg def, name=\osc1;
	var oscView = View.new;
	var builder = Builder(name);
	var oscType = Param(builder, \oscType);
	oscType.onChange({ arg param, view;
		oscView.removeAll;
		oscView.layout = Pdef(name).asParamGroup.asView
	}, oscView);
	//oscView.layout = Pdef(name).asParamGroup.asView;
	//oscType.changed(\set);
	VLayout (
		PlayerWrapper(Pdef(name)).asView,
		builder.asParamGroup.asView,
		oscView,
		nil,
	)
}).front;
)

(
WindowDef(\oscboth, { 
	VLayout (
		WindowDef(\oscbuilder).asView(\osc1),
		WindowDef(\oscbuilder).asView(\osc2),
	)
}).front;
)

////////////


(
SynthDef(\modseq, { arg out=0, gate=1, seqrate=4, amp=1;
	var sig;
	sig = Duty.ar(( 1/seqrate ), 0, Dseq([
		Dseq(\seqtab.kr(0!8)),
	],inf));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}, metadata:(specs:(
	seqtab: ParamArraySpec(\unipolar)
))).add;
)

(
Pdef(\modseq, 
	Pmono(
		\modseq,
	)
).play;
);
(
Pdef(\modseq2, 
	Pmono(
		\modseq,
	)
).play;
);

(
WindowDef(\modseq, { arg def, target;
	VLayout (
		PlayerWrapper(target).asView,
		target.asParamGroup.asView,
	)
	
}).front(Pdef(\modseq));
);

(
WindowDef(\rack, { arg def;
	HLayout (
		VLayout (
			WindowDef(\oscbuilder).asView(\osc1),
			WindowDef(\oscbuilder).asView(\osc2),
		),
		HLayout (
			WindowDef(\modseq).asView(Pdef(\modseq)),
			WindowDef(\modseq).asView(Pdef(\modseq2)),
		)
	)
}).front;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\speed, 1 / ()
			\dur, 1,
			\gain, 1,
		)
		
	])
)).play;
);
