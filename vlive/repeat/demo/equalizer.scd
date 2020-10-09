
//Quarks.install("https://github.com/muellmusik/EQui")


EQui()

//// Ndef way

(
	Ndef(\equi, {
		var sig, in;
		in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
		sig = in.equi;
	});
	WindowDef(\equi, { arg def, model;
		EQui(nil,nil,model)
	}).front(Ndef(\equi));
)

/// Pdef way

(
SynthDef(\fx_equi, { arg out=0, gate=1, amp=0.1;
	var sig, in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in.equi;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\myequi, 
	Pmono(\fx_equi,
		\inbus, BusDef(\fx2, \audio),
		\dur, 1,
	)
).play;
)

Pdef(\myequi).presetCompileString

(
	WindowDef(\equi, { arg def, model;
		EQui(nil,nil,model)
	}).front(Pdef(\myequi));
)

////////////////////////////////////////

SynthDesc(\fx_equi).controlNames
SynthDesc(\fx_equi).asParamGroup
Pdef(\myequi).asParamGroup.presetCompileString
Pdef(\myequi).asParamGroup.presetCompileString
Pdef(\myequi).asParamGroup
PdefParam.instrument(Pdef(\myequi))
Pdef(\myequi).addHalo(\instrument, \fx_equi)
Pdef(\myequi).presetCompileString

Pdef(\myequi).source.synthName


(
ProtoTemplateDef(\equi, (
	equiParams: nil,
	model_: { arg self, val;
		self[\model] = val;
	},
	edit: { arg self;
		WindowDef(\equi, { arg def, model;
			EQui(nil,nil,model)
		}).front(Ndef(\equi));
	},
	asPattern: { arg self;
		
	},
	
));
)


///////////////////////////// freqscope


FreqScope
zero
(
w = Window("My Analyzer", Rect(0, 0, 511, 300));
f = FreqScopeView(w, w.view.bounds);
w.onClose_({ f.kill }); // YOU MUST HAVE THIS
w.front;
)

////////////////:

Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(8, Pdef(\sec1)),
		
	])
)).play;

(
w = Window("My Analyzer", Rect(0, 0, 511, 300)); // width should be 511
f = FreqScopeView(w, w.view.bounds);
f.active_(true); // turn it on the first time;

w.onClose_({ f.kill }); // you must have this
w.front;
{ SinOsc.ar([500, 1000], 0, 0.25).mean.dup }.play(s); // start two sine waves
)
