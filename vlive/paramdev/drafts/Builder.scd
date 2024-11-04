
(
Builder(\oscbuilder, { arg def, oscType=\sin, numVoices=4;
	SynthDef(\synth1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
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


	Pdef(\synth1,
		Pbind(
			\instrument, \synth1,
		),
	);
})
.addSpec(\oscType, TagSpec([\sin, \saw,\pulse]))
.addSpec(\numVoices, ControlSpec(1,64,\lin,1,1))
.build;

Spec.add(\adsr, ParamEnvSpec.adsr);
Spec.add(\out, ParamBusSpec());
)


(
WindowDef(\oscbuilder, { 
	var oscType = Param(Builder(\oscbuilder), \oscType);
	var oscView = View.new;
	oscType.onChange({ arg param, view;
		oscView.removeAll;
		oscView.layout = Pdef(\synth1).asParamGroup.asView
	}, oscView);
	oscView.layout = Pdef(\synth1).asParamGroup.asView;
	oscType.changed(\set);
	VLayout (
		PlayerWrapper(Pdef(\synth1)),
		Builder(\oscbuilder).asParamGroup.asView,
		oscView,
		nil,
	)
}).front;
)

Builder(\oscbuilder).set(\oscType, \saw); // also work from code

Pbindef(\synth1, \freq, Pseq([100,200],inf)); // you can still change the sound by code
Pbindef(\synth1, \freq, nil);

::


///////////////////////////// generic
/////////////////////:

(
Builder(\oscbuilder, { arg def, name=\osc, oscType=\sin, numVoices=4;
	SynthDef(name, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
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


	Pdef(name,
		Pbind(
			\instrument, name,
		),
	);
})
.addSpec(\name, ParamNonFloatSpec())
.addSpec(\oscType, TagSpec([\sin, \saw,\pulse]))
.addSpec(\numVoices, ControlSpec(1,64,\lin,1,1))
.build;

Spec.add(\adsr, ParamEnvSpec.adsr);
Spec.add(\out, ParamBusSpec());
)


(
WindowDef(\oscbuilder, { arg def, name=\osc;
	var oscView = View.new;
	var builder = Builder(\oscbuilder_+++name, Builder(\oscbuilder)).set(\name, name); // osc is built by opening the GUI
	var oscType = Param(builder, \oscType);
	oscType.onChange({ arg param, view;
		oscView.removeAll;
		oscView.layout = Pdef(name).asParamGroup.asView
	}, oscView);
	oscView.layout = Pdef(name).asParamGroup.asView;
	oscType.changed(\set);
	VLayout (
		PlayerWrapper(Pdef(name)),
		builder.asParamGroup.asView,
		oscView,
		nil,
	)
}).front;
)

WindowDef(\osc1, { WindowDef(\oscbuilder).asView(\osc1) });
WindowDef(\osc2, { WindowDef(\oscbuilder).asView(\osc2) });

WindowDef(\osc1).front;
WindowDef(\osc2).front;

(
WindowDef(\oscboth, { 
	VLayout (
		WindowDef(\oscbuilder).asView(\osc1),
		WindowDef(\oscbuilder).asView(\osc2),
	)
});
)

WindowDef(\oscboth).front;


///////////////////////////
// now create builder outside of GUI

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
	oscView.layout = Pdef(name).asParamGroup.asView;
	oscType.changed(\set);
	VLayout (
		PlayerWrapper(Pdef(name)),
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




////////////////


(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq((1..10),inf) % Pseq((4..12),inf),
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);
