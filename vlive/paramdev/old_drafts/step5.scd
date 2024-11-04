

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
		
		PlayerWrapper(Pdef(\plop)).asView,
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

		sig = RLPF.ar(sig, 
			SelectX.kr(\kb.kr(0), [
				\lpf.kr(500),
				\freq.asSpec.unmap(\lpf.kr).linlin(0,1,0.5,2) * freq,
			])
		, \rq.kr(0.56));

		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
		sig = Splay.ar(sig, spread, amp, pan);
		Out.ar(out, sig);
	}, metadata:(specs:(
		adsr: XEnvSpec.adsr,
		//duration: ControlSpec(0.001,4,\lin, 0, 1)
	))).add;


}).build;


if(~es.isNil) {
	~es = StepEvent.new;
	~es[\isRest] = StepList.newFrom(0!8).addSpec(\list, \unipolar);
	~es[\degree] = StepList.newFrom(0!8).addSpec(\list, ControlSpec(-10,20,\lin,1));
	~es[\lpf] = StepList.newFrom(0!8).addSpec(\list, \freq);
	~es[\rq] = StepList.newFrom(0!8).addSpec(\list, \rq);
};
Pdef(\plip, 
	
	~es.loop <>
	Pdef(\yup, Pbind()) <>
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

(
~make_stepevent_gui = {

	WindowLayout({
		VLayout(
			
			PlayerWrapper(Pdef(\plip)).asView,
			StepEventView(~es).setCursor.view,
			HLayout(
				NumberBox.new.mapParam(Param(Message(~es), \stepCount, ControlSpec(1,128,\lin,1))),
				PopUpMenu.new.items_([
					"SinOsc",
					"LFSaw",
					"LFPulse",
				]).mapParam(Param(Builder(\plip), \osctype)),
			),
			ParamGroupLayout.two_panes([
				Param(Builder(\plip), \voices, ControlSpec(1,50,\lin,1)),
				Param(Pdef(\yup), \dur, ControlSpec(1/16,1,\exp)),
				Param(Pdef(\yup), \amp),
				Param(Pdef(\yup), \freq),
				Param(Pdef(\yup), \fspread),
				Param(Pdef(\yup), \kb, \unipolar),
				Param(Pdef(\yup), \adsr, XEnvSpec.adsr),
			])
		)
	})
};
)

Pdef(\plip).addHalo(\edit, ~make_stepevent_gui)
~clipTimeline.new(\yep).edit

~p = Param(Message(~es), \stepCount, ControlSpec(1,128,\lin,1))
~p.get
~p.set(16)
~es
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

Builder(\yup)


~es
~es[\isRest].setSize(16)
~es.setSize(16)
~es.setSize(8)
~es.changed(\refresh)
~es[\isRest].changed(\refresh)
~es[\degree].changed(\refresh)
~es.extend(16)
~a = List[1,2,3,4,5]
~a.extend(4)
~

(a:4).size

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, PstepSeq([1,2,3,4]),
	\dur, 1,
	\amp, 0.1
)).play;
);

PstepSeq([1,2,3,4])
List[1,2,3,4]

~es.asPattern.asStream.nextN(4, ())
~es.



 Pbind('degree', PstepSeq(StepList[ 0, 0, 0, 0, 0, 0, 0, 0 ]), 'isRest', PstepSeq(StepList[ 0, 0, 0, 0, 0, 0, 0, 0 ]).coin.not).trace.play
 1.isKindOf(Pn)

 ().extend(4)
