
////////////// Builder

1+1
(
Builder(\plop, { arg builder, osctype=0, voices=1;

	builder.key.debug("key");
	"wtf!!!".debug;
	builder.source.debug("WTFF");

	SynthDef(builder.key, { arg out=0, freq=200, doneAction=2, gate=1, amp=0.1, pan=0, spread=0.8, fspread=0.1;

		var oscs, osc;
		var sig;
		freq = voices.clip(1,1000).asInteger.collect({
			freq * ( 1 + ( Rand(0,1) * fspread ) )
		});
		oscs = [
			{ SinOsc.ar(freq) },
			{ LFSaw.ar(freq) },
			{ LFPulse.ar(freq) },
		];
		osc = oscs[osctype];

		sig = osc.();
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
		sig = Splay.ar(sig, spread, amp, pan);
		Out.ar(out, sig);
	}).add;


}).build;
)

Builder(\plop).value
Builder(\plop).envir
Builder(\plop).addSpec(\osctype, ControlSpec(0,2,\lin,1));
Builder(\plop).getSpec(\osctype)

Builder.all

Param(Builder(\plop), \osctype, ControlSpec(0,2,\lin,1)).edit
Param(Builder(\plop), \osctype).spec
Param(Builder(\plop), \osctype, ControlSpec(0,2,\lin,1)).wrapper
Builder(\plop).func
Builder(\plop).func
Builder(\plop).build
nil !? { 3 }

~f = { arg a, bedo=4; }
~f.dump
~f.def.dump.prototypeFrame
~f.def.dump
~f.def.argNames


(
~steps = StepList.newFrom(1!8);
Ppredef(\plop, Pbind(
	\instrument, \plop,
	\degree, Pseq([0],inf),
	\isRest, ~steps.prest.loop,
	\dur, 1/4,
)).play;
~steps.addSpec(\list, \unipolar);
Pdef(\plop).setBusMode(\freq);
Pdef(\plop).addSpec(\fspread, ControlSpec(0.0001,1,\exp));
);

Ppredef(\plop)
Pdef(\plop)
Ppredef(\plop).clear
Pdef.all[\plop] = nil

(
WindowLayout({
	VLayout(
		
		StepListView(~steps).addCursor.view,
		PopUpMenu.new.items_([
			"SinOsc",
			"LFSaw",
			"LFPulse",
		]).mapParam(Param(Builder(\plop), \osctype)),
		ParamGroupLayout.two_panes([
			Param(Builder(\plop), \voices, ControlSpec(1,50,\lin,1)),
			Param(Pdef(\plop), \dur, ControlSpec(1/16,1,\exp)),
			Param(Pdef(\plop), \amp),
			Param(Pdef(\plop), \freq),
			Param(Pdef(\plop), \fspread),
			Param(Pdef(\plop), \adsr, XEnvSpec.adsr),
		])
	)
})
)

29.collect
