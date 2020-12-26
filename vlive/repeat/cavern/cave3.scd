
(
	32.do { arg idx;

		SynthDef(\fm7_algo+++idx, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
			var sig;
			sig = FM7.arAlgo(idx, [
				\freqratiotab.kr(1!6) * freq,
				\phasetab.kr(0!6),
				\amptab.kr(0.1!6),
			].flop, \fb.kr(0));
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
			sig = Pan2.ar(sig, pan, amp);
			Out.ar(out, sig);
		}).add;
	}
);

(
Pdef(\zed, 
	Pbind(
//		\instrument, \fm7_algo5,
		\degree, Pseq([0,2,7,5],inf),
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);

Pdef(\zed).edit
(
WindowDef(\win, { arg def;
	VLayout (
		PlayerWrapper(Pdef(\zed)).asView,
		//(Pdef(\zed).asParamGroup ).debug("hein?").asView
		//Param(Pdef(\zed), \instrument, TagSpec(32.collect({ arg x; "Algo "++x -> x }))).asView,
		ParamGroup(
		SynthDesc(\fm7_algo0).asParamGroup(Pdef(\zed)) ++ 
		[
		//Param(Pdef(\zed), \instrument, ParamNonFloatSpec()).asBusPopUpMenu(TagSpec(32.collect({ arg x; "Algo "++x -> ("fm7_algo"++x).asSymbol }))),
		//Param(Pdef(\zed), \instrument, TagSpec(32.collect({ arg x; "Algo "++x -> ("fm7_algo"++x).asSymbol }))),
		]
		).asView,
		Param(Pdef(\zed), \instrument, TagSpec(32.collect({ arg x; "Algo "++x -> ("fm7_algo"++x).asSymbol }))).asBusPopUpMenu,
		//ParamGroup(Pdef(\zed).asParamGroup ++ [
			//Param(Pdef(\zed), \instrument, TagSpec(32.collect({ arg x; "Algo "++x -> x })))
		//]).debug("hein?").asView
	)
	
}).front;
);
