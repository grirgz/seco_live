// see  vlive/demo/param/combi1
// see  vlive/demo/param/disc/modular2
~pc.rate
~pc.rate = \kr
(
	SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
		var sig, sig1, sig2, sig3;
		sig = LFSaw.ar(freq * [1.01,1,0.99]);
		sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
		sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
		sig = Splay.ar(sig, spread, amp, pan);
		Out.ar(out, sig);
	}).add;


	~targetp = Param(Pdef(\param), \freq, \freq);
	//Ndef(\default).clear;
	//~pc.setBusMode(true);
	//Ndef(\default).set(\inputs, [0,0,0]);
	//Ndef(\default).set(\ranges, [0,0,0]);
	//Ndef(\default).clear;

	Ndef(\lfo1, { SinOsc.kr(2.5).unipolar  });
	Ndef(\lfo2, { LFPulse.kr(4.5).unipolar  });
	Ndef(\lfo3, { LFSaw.kr(1.5).unipolar  });

	BusDef(\bus1,\control);
	BusDef(\bus2,\control);
	BusDef(\arbus1,\audio);
	BusDef(\arbus2,\audio);

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
Pdef(\param).addHalo(\instrument, \saw)
	~pc = ParamCombinator(Param(Pdef(\param), \freq, \freq));
	~pc.setBusMode(true);
Pdef(\param).edit
WindowDef(\ParamCombinator).front(~pc)

(
	WindowDef(\combi, { arg def, combi;
		var targetParam = Param(Pdef(\param), \freq, \freq);
		VLayout (
			PlayerWrapper(Pdef(\plop)).asView,
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
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

Pdef(\rah).edit
Pdef(\rah).asParamGroup.first.instrument

WindowDef(\ParamCombinator).front(Pdef(\rah).getHalo(\ParamCombinator_freq))
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


