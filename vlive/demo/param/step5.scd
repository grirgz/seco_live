

////////////// simple sequencer step + degree

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


});


~steps = StepList.newFrom(1!8);
~degree = StepList.newFrom(0!8);
Ppredef(\plop, Pbind(
	\instrument, \plop,
	\isRest, ~steps.prest.loop,
	\degree, ~degree.asPattern.loop,
	\dur, 1/4,
).trace).play;
~steps.addSpec(\list, \unipolar);
~degree.addSpec(\list, ControlSpec(-20,20,\lin));
//Ppredef(\plop).setBusMode(\freq);
Ppredef(\plop).addSpec(\fspread, ControlSpec(0.0001,1,\exp));
//Pdef(\plop).addSpec(\degree, ControlSpec(-20,20,\lin));
//Pdef(\plop).addSpec(\freq, \freq);
);

Pdef(\plop).play

Pdef(\plop).unset(\freq)
Ppredef(\plop)
Pdef(\plop).gui
Ppredef(\plop).clear
Pdef.all[\plop] = nil

(
WindowLayout({
	VLayout(
		
		PlayerWrapperView(Pdef(\plop)).layout,
		StepListView(~steps).addCursor.view,
		StepListView(~degree).addCursor.view,
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




////////////// simple sequencer, StepEventView
// TODO : spec on StepEvent doesnt affect StepList inside
// need a recursive spec system in Param ?
// StepEvent or StepEventView should take the spec of the event and put it on StepList ?
// StepEvent should handle adding of StepList ? with size
// TODO: save/load or Def system

1+1
(
Builder(\plip, { arg builder, osctype=0, voices=1;

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
	}, metadata:(specs:(
		adsr: XEnvSpec.adsr,
		//duration: ControlSpec(0.001,4,\lin, 0, 1)
	))).add;


}).build;


~es = StepEvent.new;
~es[\isRest] = StepList.newFrom(0!8);
~es[\degree] = StepList.newFrom(0!8);
Pdef(\plip, 
	
	~es.loop <>
	Pdef(\yup) <>
	Pbind(
	\instrument, \plip,
	\dur, 1/4,
)).play;
~es.addSpec(\isRest, \unipolar);
~es.addSpec(\degree, ControlSpec(-20,20,\lin));
//Ppredef(\plip).setBusMode(\freq);
Pdef(\yup).addSpec(\fspread, ControlSpec(0.0001,1,\exp));
Pdef(\yup).addHalo(\instrument, \plip);
//Pdef(\plip).addSpec(\degree, ControlSpec(-20,20,\lin));
//Pdef(\plip).addSpec(\freq, \freq);
);

Pdef(\plip).play
Pdef(\plip).get(\adsr)
Pdef(\yup).get(\adsr)
Param(Pdef(\yup), \adsr).spec
Pdef(\yup).asParamGroup

Pdef(\plip).unset(\freq)
Ppredef(\plip)
Pdef(\plip).gui
Ppredef(\plip).clear
Pdef.all[\plip] = nil

(
WindowLayout({
	VLayout(
		
		PlayerWrapperView(Pdef(\plip)).layout,
		StepEventView(~es).view,
		PopUpMenu.new.items_([
			"SinOsc",
			"LFSaw",
			"LFPulse",
		]).mapParam(Param(Builder(\plip), \osctype)),
		ParamGroupLayout.two_panes([
			Param(Builder(\plip), \voices, ControlSpec(1,50,\lin,1)),
			Param(Pdef(\yup), \dur, ControlSpec(1/16,1,\exp)),
			Param(Pdef(\yup), \amp),
			Param(Pdef(\yup), \freq),
			Param(Pdef(\yup), \fspread),
			Param(Pdef(\yup), \adsr, XEnvSpec.adsr),
		])
	)
})
)

Builder(\yup)
