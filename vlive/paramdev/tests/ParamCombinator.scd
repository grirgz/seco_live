// see  vlive/demo/param/combi1
// see  vlive/demo/param/disc/modular2
(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;


Spec.add(\lpfr, ControlSpec(0.1,4,\lin));

~targetp = Param(Pdef(\param), \freq, \freq);
//Ndef(\default).clear;
//~pc.setBusMode(true);
//Ndef(\default).set(\inputs, [0,0,0]);
//Ndef(\default).set(\ranges, [0,0,0]);
//Ndef(\default).clear;

Ndef(\lfo1, { arg freq=2.5; SinOsc.kr(freq).unipolar  });
Ndef(\lfo2, { LFPulse.kr(4.5).unipolar  });
Ndef(\lfo3, { LFSaw.kr(1.5).unipolar  });
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo1 -> Ndef(\lfo1));
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo2 -> Ndef(\lfo2));
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo3 -> Ndef(\lfo3));

BusDef(\krbus1,\control);
BusDef(\krbus2,\control);
BusDef(\arbus1,\audio);
BusDef(\arbus2,\audio);

Pdef(\plop,
	( 
		Pdef(\param, Pbind(\instrument, \saw)) 
		<> Pbind(
			\freq, Pseq([500],inf),
			\dur, 1,
			\amp, 0.1
		) 
	).trace
).play;
)

// open editor, right click on param name, click Set Combinator mode
Pdef(\param).edit

// or manually create a combinator
~pc = ParamCombinator(Param(Pdef(\param), \lpfr, ControlSpec(0.1,2,\lin)));
~pc.setBusMode(true); // to use lfo
WindowDef(\ParamCombinatorEditor).front(~pc)

///////////////////////////////// drafts

~p =Param(Pdef(\param), \lpfr, ControlSpec(0.1,2,\lin))
~p.combinatorEnabled
~p.combinator
~p.getRaw
~p.target.getHalo(\ParamCombinator_lpfr)

Pdef(\param).clear; Pdef(\param).envir.clear; // reset

Pdef(\param).addHalo(\instrument, \saw)
	~pc = ParamCombinator(Param(Pdef(\param), \freq, \freq));
	~pc = ParamCombinator(Param(Pdef(\param), \lpfr, ControlSpec(0.1,2,\lin)));
	~pc.setBusMode(true);
	~ev = Pdef(\param).asStream.next
	~ev[\lpfr].dump
	~ev.play
Pdef(\param).edit
WindowDef(\ParamCombinatorEditor).front(~pc)

(
	WindowDef(\combi, { arg def, combi;
		var targetParam = Param(Pdef(\param), \freq, \freq);
		VLayout (
			PlayerWrapper(Pdef(\plop)).asView,
			PlayerWrapper(combi.proxy).asView,
			Button.new.string_("convert target param").action_({
				var target = targetParam.target;
				//targetParam.wrapper = targetParam.combinator.baseParam.wrapper;
				//target.changed(\target);
				target.changed(\combinator);
			}),
			targetParam.asView,
			combi.baseParam.asView,
			combi.rangeParam.asView,
			//VLayout(*combi.inputParam.collect(_.asPopUpMenu(TagSpecDef(\BusDef_asMap)))),
			//VLayout(*combi.inputParam.collect(_.asPopUpMenu(TagSpecDef(\BusDef_control_asMap)))),
			VLayout(*combi.inputParam.collect(_.asValuePopUpMenu(TagSpec(
				["-"->0] ++ [\lfo1,\lfo2,\lfo3].collect({ arg x; x -> Ndef(x).asMap })
			)))),
			//combi.inputParam.asView;
			//Param(Pdef(\param), \xlpfr).asPopUpMenu([\bla,\rah]),
		)

		
	}).front(~pc);
)

~targetp.inBusMode
~targetp.get.class
~targetp.get
~targetp.spec
~targetp.wrapper
	~pc.setBusMode(true);

	~pc.edit
~pc.baseParam.get
~pc.baseParam.spec = \freq.asSpec;
~pc.baseParam.spec 
~xx = ~pc.inputParam.get
~pc.inputParam
~pc.rangeParam.get
~pc.baseParam.set(0)
~pc.baseParam.set(600);
~pc.baseParam.set(400);
~pc.rangeParam.at(0).set(0.5);
~pc.inputParam.at(0).set(0.5);
~pc.inputParam.at(0).set(0);
~pc.inputParam.at(0).get;
~pc.inputParam.at(0).set(Ndef(\lfo2).asMap);
~pc.inputParam.at(0).spec = ParamMappedBusSpec()
~pc.baseParam.edit
~pc.targetParam
~pc.proxy.asMap
~pc.targetParam.get
~pc.get
~pc.proxy.clear
~pc.targetParam.getRaw
~pc.targetParam.getRaw.asBus.getSynchronous
~pc.baseParam.set(~pc.targetParam.get)
Pdef(\plop).clear;
Pdef(\plop).envir.clear;
Pdef(\plop).adieu;

Pdef(\param).clear;
Pdef(\param).envir.clear;
Pdef(\param).adieu;
			Param(Pdef(\param), \freq, \freq).combinator
			Param(Pdef(\param), \freq, \freq).combinator
			Param(Pdef(\param), \freq, \freq).getRaw.asStream.next
			Param(Pdef(\param), \freq, \freq).getRaw.asBus.getSynchronous
			~combi = Param(Pdef(\param), \freq, \freq).getRaw
			~combi = Param(Pdef(\param), \freq, \freq).target.getHalo(\ParamCombinator_freq)
			~combi.proxy.asMap
			~combi.proxy
			~combi.proxy.edit
			~combi.baseParam.get
			~combi.baseParam.set(100)
			~combi.baseParam.spec
			~combi.baseParam.wrapper.spec
			ParamValue(\freq.asSpec).spec
			~combi.targetParam.spec
			~combi.result.get
			~combi.resultParam.get
			~combi.rangeParam.get
			~combi.computeAndSetTargetValue
			~combi.computeTargetValue(100)

TagSpecDef(\BusDef_control_asMap).list


/////////////////:
// idée d'utiliser une valeur plutot


// test:

(
ProtoDef(\mod, (
	modBus: BusDef(\modbus1, \control),
	set: { arg self, val;
		self.modValue = val;
		self.modBus.set(val);
	},
	get: { arg self;
		self.modValue;
	},
	asControlInput: { arg self;
		"aci".debug;
		self.modBus.asMap
	},
	embedInStream: { arg self, val;
		"eis".debug;
		self.modBus.asMap.embedInStream(val)
	},
	asStream: { arg self;
		"as".debug;
		self.modBus.asMap.asStream;
		
	},
	asPattern: { arg self;
		"ap".debug;
		Pn(self.modBus.asMap)
		
	},
))
)

(
Ndef(\test, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq.poll;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
Ndef(\test).clear

(
Pdef(\test, 
	Pbind(
		\instrument, \default,
		//\freq, 1000,
//		\freq, ProtoDef(\mod),
		//\zfreq, DebugMethodTracer(),
		//\dd, (),
		\dur, 1,
		\amp, 0.1,
	).trace
).play;
);

Pdef(\test).clear
Pdef(\test).set(\freq, ProtoDef(\mod))
DebugMethodTracer().hello
DebugMethodTracer.isKindOf(Param)
DebugMethodTracer.isKindOx

Ndef(\test).set(\freq, ProtoDef(\mod))
Ndef(\test).set(\freq, ProtoDef(\mod))
Ndef(\test).set(\freq, 700)
ProtoDef(\mod).set(410)
ProtoDef(\mod).get
ProtoDef(\mod).asControlInput
ProtoDef(\mod).modBus.getSynchronous
ProtoDef(\mod).asPattern
ProtoDef(\mod).embedInStream
ProtoDef(\mod).asStream

/////////////////////////////:
(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).store;
);
(
Pdef(\rah, 
	Pbind(
		\instrument, \saw,
		//\freq, 1000,
//		\freq, ProtoDef(\mod),
		//\zfreq, DebugMethodTracer(),
		//\dd, (),
	)
).play;
);

Pdef(\rah).edit
Pdef(\rah).asParamGroup.first.instrument

WindowDef(\ParamCombinatorEditor).front(Pdef(\rah).getHalo(\ParamCombinator_freq))
~pc = Pdef(\rah).getHalo(\ParamCombinator_lpfr)
~pc.inputParam.get
Pdef(\rah).getHalo(\ParamCombinator_freq).setBusMode(true)
Pdef(\rah).getHalo(\ParamCombinator_freq).inBusMode
Pdef(\rah).getHalo(\ParamCombinator_freq).ranges.dump
Pdef(\rah).getHalo(\ParamCombinator_freq).inputParam.getRaw
Pdef(\rah).getHalo(\ParamCombinator_freq).inputParam.getRaw.dump
~pc2 = Pdef(\rah).getHalo(\ParamCombinator_freq)
~pc2.inputParam.set([\c2,0,0])
~pc.inputParam.getRaw.dump

Ndef(\lfo1).wakeUp
Ndef(\lfo1).quant = nil
Ndef(\lfo1).free
Ndef(\lfo1).rate
Ndef(\lfo1).isPlaying
PlayerWrapper(Ndef(\lfo1)).stop
Param.trace=true
Param.trace=false
(
	Ndef(\lfo1, { arg lofreq=2.5; SinOsc.kr(lofreq).unipolar  });
	Ndef(\lfo2, { arg lofreq=4.5; LFPulse.kr(lofreq).unipolar  });
	Ndef(\lfo3, { arg lofreq=1.5; LFSaw.kr(lofreq).unipolar  });
)



/////////////////////////

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1060].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1026].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.31,
			),
		]),
		
	])
)).play;
);

(
Pdef(\sawline, 
).play;
);

(
Pdef(\part2, Pdef(\sawline, 
	Ppar([
		Pdef(\saw, 
			Pbind(
				\instrument, \saw,
				//\freq, 1000,
				//		\freq, ProtoDef(\mod),
				//\zfreq, DebugMethodTracer(),
				//\dd, (),
				\dur, 1/8,
				\amp, 0.1,
			)
		),
		
	])
));
);

Pdef(\saw).edit
ParamTimeline(\param1, Param(Pdef(\saw), \lpfr)).edit
ParamTimeline(\param1).param = Param(Pdef(\saw), \lpfr)
Spec.add(\lpfr, ControlSpec(0.1,4,\lin))
Pdef.defaultQuant = 8

//////////////////////////


BusDef(\krbus3, \control).rate
BusDef(\krbus3).rate
BusDef(\krbus3).set(1)



///////////////////// kr ar


(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).store;
);
(
Spec.add(\lpfr, ControlSpec(0.1,4,\lin));
	Ndef(\lfo1, { arg lofreq=2.5; SinOsc.kr(lofreq).unipolar  });
	Ndef(\lfo2, { arg lofreq=4.5; LFPulse.kr(lofreq).unipolar  });
	Ndef(\lfo3, { arg lofreq=1.5; LFSaw.kr(lofreq).unipolar  });
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo1 -> Ndef(\lfo1));
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo2 -> Ndef(\lfo2));
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo3 -> Ndef(\lfo3));

	BusDef(\krbus1,\control);
	BusDef(\krbus2,\control);
	BusDef(\arbus1,\audio);
	BusDef(\arbus2,\audio);
Pdef(\rah, 
	Pbind(
		\instrument, \saw,
		//\freq, 1000,
//		\freq, ProtoDef(\mod),
		//\zfreq, DebugMethodTracer(),
		//\dd, (),
	)
).play;
);

Pdef(\rah).edit
~pc = ParamCombinator( Param(Pdef(\rah), \freq) ).setBusMode(true);
~pc.rangeParam.at(0).set(0.51);
~pc.inputParam.at(0).set(Ndef(\lfo1).asMap)
~pc.edit
BusDef(\krbus1).rate


~pc.inputParam.at(0).set(0.51)
~pc.inputParam.get

TagSpecDef(\ParamCombinatorInput).asDict[ TagSpecDef(\ParamCombinatorInput_asMap).unmapKey("c1") ]

Pdef(\rah).asParamGroup.first.instrument
Ndef(\lfo1).asMap
BusDef(\krbus5)
TagSpecDef(\ParamCombinatorInput).list
TagSpecDef(\ParamCombinatorInput_asMap).list
TagSpecDef(\ParamCombinatorInput_asMap).list.collect(_.postln)
TagSpecDef(\ParamCombinatorInput_asMap).list.asDict[\krbus4]
WindowDef(\ParamCombinatorEditor).front(Pdef(\rah).getHalo(\ParamCombinator_freq))
~pc = Pdef(\rah).getHalo(\ParamCombinator_lpfr)
~pc = Pdef(\rah).getHalo(\ParamCombinator_freq)
~pc.inputParam.at(0).setRaw(BusDef(\krbus0).asMap)
~pc.inputParam.at(0).setRaw(Ndef(\lfo2).asMap)
~pc.inputParam.at(0).setRaw(Ndef(\lfo2).asMap)
~pc.inputParam.at(0).set(Ndef(\lfo2).asMap)
~pc.inputParam.at(0).setBus(BusDef(\krbus1))
~pc.inputParam.at(0).set(0.51)
~pc.inputParam.at(0).get
~pc.inputParam.get
~pc.inputParam.setRaw(1)
~pc.inputParam.at(0).getRaw
~pc.inputParam.setRaw([0,0,0])
~pc.rangeParam.at(0).set(0.51)
~pc.inputParam.setRaw([Ndef(\lfo1).asMap,0,0])
~pc.inputParam.at(0).getRaw
~pc.targetParam
~pc.proxy.
Pdef(\rah).getHalo(\ParamCombinator_freq).setBusMode(true)
Pdef(\rah).getHalo(\ParamCombinator_freq).inBusMode
Pdef(\rah).getHalo(\ParamCombinator_freq).ranges.dump
Pdef(\rah).getHalo(\ParamCombinator_freq).inputParam.getRaw
Pdef(\rah).getHalo(\ParamCombinator_freq).inputParam.getRaw.dump
~pc2 = Pdef(\rah).getHalo(\ParamCombinator_freq)
~pc2.inputParam.set([\c2,0,0])
~pc.inputParam.getRaw.dump

Ndef(\lfo1).wakeUp
Ndef(\lfo1).quant = nil
Ndef(\lfo1).free
Ndef(\lfo1).rate
Ndef(\lfo1).isPlaying
PlayerWrapper(Ndef(\lfo1)).stop
Param.trace=true
Param.trace=false
(
)


////////////// test with \source


	(
	Pdef(\plop,
		( 
			Pdef(\param, DebugPbind()) 
			<> Pbind(
				\instrument, \saw,
				\freq, Pseq([500],inf),
				\dur, 1,
				\amp, 0.1
			) 
		).trace
	).play;
	)


(
Pdef(\part, Pbindef(\plop, 
	\instrument, \default,
	\freq, Pseq([400,300],inf),
	\dur, 1,
	\amp, 0.1,
).trace).play;
);

Pdef(\part).stop
(
Pdef(\tes, Pbind( 
	\instrument, \default,
	\freq, Pseq([400,300],inf),
	\dur, 1,
	\amp, 0.1,
).trace).play;
);

(
Pdef(\tes, Pbind( 
	\instrument, \default,
	\freq, ~pc,
	\dur, 1,
	\amp, 0.1,
).trace).play;
);

Pdef(\tes).stop
(
Pdef(\part, Pbindef(\plop, 
	\instrument, \default,
	\freq, ~pc,
	\dur, 1,
	\amp, 0.1,
).trace).play;
);

~p = Param(Pbindef(\plop), \freq -> \source)
~p.get
~p.parent.get
~p.property
~p.set(~pc)
~p.set(1)
~p.inBusMode
~p.get
Pdef(\part).play
Pbindef(\plop).clear

~pc = ParamCombinator(Param(Pbindef(\plop), \freq));
Pbindef(\plop, \freq, ~pc)
~pc.edit
~pc.setBusMode(true)
Pbindef(\plop).source.at(\freq).source

~s = \bla.asStream;
~s.next
~s = ~pc.asStream
~s = ~pc.streamArg

~pc
~pc.inputParam.as(Array)
~pc.inputParam.as(Array).detectIndex{ arg x; x.get == 0 }
Pdef(\part).play
~pc.inputParam.getRaw
~pc.inputParam.at(0).get
~pc.inputParam.at(0).getRaw
~pc.inputParam.at(0).getVal
TagSpecDef(\ParamCombinatorInput_asMap).unmapKey ( ~pc.inputParam.at(0).get )
~pc.inputParam.setRaw(Ndef(\lfo1).asMap)
~pc.inputParam.setRaw(nil)

~pc = ParamCombinator(Param(Pdef(\tes), \freq));


/////////////


(
Ndef(\lfo1, { arg freq=2.5; SinOsc.kr(freq).unipolar  });
Ndef(\lfo2, { LFPulse.kr(4.5).unipolar  });
Ndef(\lfo3, { LFSaw.kr(1.5).unipolar  });
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo1 -> Ndef(\lfo1));
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo2 -> Ndef(\lfo2));
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo3 -> Ndef(\lfo3));
Pdef(\part, Pbindef(\plop, 
	\instrument, \default,
	\freq, Pseq([400,300],inf),
	\dur, 1,
	\amp, 0.1,
).trace).play;
)

~p = Param(Pbindef(\plop), \freq -> \source)
~p.get
~p.parent.get
~p.property
~p.set(~pc)
~p.setRaw(~pc)
~p.getRaw
~p.set(1)
~p.inBusMode
~p.get
Pdef(\part).play
Pbindef(\plop).clear

~pc = ParamCombinator(Param(Pbindef(\plop), \freq));
Pbindef(\plop, \freq, ~pc)
~pc.edit
~pc.setBusMode(true)
Pbindef(\plop).source.at(\freq).source

~s = \bla.asStream;
~s.next
~s = ~pc.asStream
~s = ~pc.streamArg

~pc
~pc.inputParam.as(Array)
~pc.inputParam.as(Array).detectIndex{ arg x; x.get == 0 }
Pdef(\part).play
~pc.inputParam.getRaw
~pc.inputParam.at(0).get
~pc.inputParam.at(0).getRaw
~pc.inputParam.at(0).getVal
TagSpecDef(\ParamCombinatorInput_asMap).unmapKey ( ~pc.inputParam.at(0).get )
~pc.inputParam.setRaw(Ndef(\lfo1).asMap)
~pc.inputParam.setRaw(nil)

~pc = ParamCombinator(Param(Pdef(\tes), \freq));


