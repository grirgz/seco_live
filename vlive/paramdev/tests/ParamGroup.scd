(
SynthDef(\saw_help, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpfr: ControlSpec(0.5,4,\lin, 0, 1)
))).add;

Pdef(\help, 
	Pbind(
		\instrument, \saw_help,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
)

(
ParamGroupDef(\group1, [
	Param(Pdef(\help), \lpfr),
	Param(Pdef(\help), \rq),
]);
)

ParamGroupDef(\group1).save(\preset1)
ParamGroupDef(\group1).load(\preset1)
ParamGroupDef(\group1).edit
ParamGroupDef(\group1).getPreset(\preset1)
ParamGroupDef(\group1).getPreset(1)


(
WindowDef(\help, { arg def, pg;
	VLayout (
		WindowDef(\PresetSelectorView).asView(pg),
		pg.asView,
	)
	
}).front(ParamGroupDef(\group1));
)

ParamGroupDef(\group1).presetCompileString

// this create a morpher on a preset list named \preset0 to \preset7
~morpher = PresetListMorpher(ParamGroupDef(\group1), 8);
~morpher.normSet(0.5); // morph between presets at the center

(
WindowDef(\help, { arg def, pg;
	VLayout (
		WindowDef(\PresetListMorpherView).asView(pg),
		pg.asView,
	)
	
}).front(ParamGroupDef(\group1));
)
