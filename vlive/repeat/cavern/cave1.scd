
(
FileSystemProject.loadOnce("cavern/main.scd");
~t = 185/4/60; TempoClock.default.tempo = ~t;



/////////// osc builder

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


	Pbindef(def.key,
		\instrument, def.key,
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


WindowDef(\oscbuilder, { arg def, name=\osc1;
	var oscView = View.new;
	var builder = Builder(name);
	var oscType = Param(builder, \oscType);
	var pdef = Pbindef(name).convertToPbindef;
	var prop = \isRest;
	oscView.followChange(builder, \build, { arg param, view;
		oscView.removeAll;
		oscView.layout = Pdef(name).asParamGroup.asView
	});
	if(pdef.source.at(prop).source.isKindOf(PstepSeq).not) {
		Pbindef(pdef.key, prop, PstepSeq(false!4,inf));
	};
	//oscView.layout = Pdef(name).asParamGroup.asView;
	//oscType.changed(\set);
	VLayout (
		PlayerWrapper(Pdef(name)).asView,
		builder.asParamGroup.asView,
		oscView,
		Param(Message(pdef.source.at(\isRest).source), \list, ParamBoolSpec(true)).asMultiSlider.attachOverlayMenu,
		nil,
	)
});

/////////// mod sequencer

SynthDef(\modseq, { arg out=0, gate=1, seqrate=4, amp=1, lagTime=0;
	var sig;
	sig = Duty.ar(( 1/seqrate ), 0, Dseq([
		Dseq(\seqtab.kr(0!8)),
	],inf));
	sig = sig.lag(lagTime);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
	sig = sig * amp;
	Out.kr(out, sig);
}, metadata:(specs:(
	seqtab: ParamArraySpec(\unipolar),
	lagTime: \unipolar,
))).add;

Pdef(\modseq1, 
	Pmono(
		\modseq,
	)
);

Pdef(\modseq2, 
	Pmono(
		\modseq,
	)
);

WindowDef(\modseq, { arg def, target;
	VLayout (
		PlayerWrapper(target).asView,
		target.asParamGroup.asView,
	)
	
});

/////////// filter builder

Builder(\filterbuilder, { arg def, filterType=\lpf;
	SynthDef(def.key, { arg out=0, gate=1, gain=1, cutoff=500;
		var sig;
		var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 

		sig = in;
		sig = switch(filterType,
			\lpf, { 
				LPF.ar(sig, cutoff)  
			},
			\rlpf, { 
				RLPF.ar(sig, cutoff, \rq.kr(0.5)) 
			},
			\hpf, {
				HPF.ar(sig, cutoff) 
			},
			\rhpf, {
				RHPF.ar(sig, cutoff, \rq.kr(0.5)) 
			},
			\bpf, {
				BPF.ar(sig, cutoff, \rq.kr(0.5)) 
			}
		);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
		sig = sig * gain;
		Out.ar(out, sig);
	}, metadata:(specs:(
		cutoff: \freq,
	))).add;


	Pdef(def.key,
		Pmono( def.key ),
	);
})
.addSpec(\name, ParamNonFloatSpec())
.addSpec(\filterType, TagSpec([\lpf, \rlpf, \hpf, \rhpf, \bpf]))
.build;

WindowDef(\builder_module, { arg def, name=\osc1;
	var synthView = View.new;
	var builder = Builder(name);
	synthView.followChange(builder, \build, { arg view;
		view.removeAll;
		view.layout = Pdef(name).asParamGroup.asView
	});
	//synthView.layout = Pdef(name).asParamGroup.asView;
	//oscType.changed(\set);
	VLayout (
		PlayerWrapper(Pdef(name)).asView,
		builder.asParamGroup.asView,
		synthView,
		nil,
	)
});

Builder(\filter1, Builder(\filterbuilder)).build; 
Builder(\filter2, Builder(\filterbuilder)).build; 


//////////// mod osc builder

Builder(\modoscbuilder, { arg def, oscType=\sin;
	SynthDef(def.key, { arg out=0, gate=1, amp=0.1, freq=200;
		var sig;
		sig = switch(oscType,
			\sin, { SinOsc.kr(freq)  },
			\saw, { LFSaw.kr(freq) },
			\pulse, { LFPulse.kr(freq, 0, \pulseWidth.kr(0.5)) }, // additionnal parameter
		).unipolar;
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
		sig = sig * amp;
		Out.kr(out, sig);
	}, metadata:(specs:(
		freq: \lofreq,
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
.build;

Builder(\modosc1, Builder(\modoscbuilder)).build; 
Builder(\modosc2, Builder(\modoscbuilder)).build; 

//////////// fx builder

SynthDef(\fx_freeverb2, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = FreeVerb2.ar(sig[0],sig[1], \verbmix.kr(1), \room.kr(0.5), \damp.kr(0.5));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0,1,0.01),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_freqshift, { arg out=0, amp=0.1, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = FreqShift.ar(sig, \shift.kr(0));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_simplecomp, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//var sidein = InFeedback.ar(\sideinbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig * \pregain.kr(1);
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
TagSpecDef(\SynthDef_fx).addUnique(\fx_simplecomp);
TagSpecDef(\SynthDef_fx).addUnique(\fx_freeverb2);
TagSpecDef(\SynthDef_fx).addUnique(\fx_freqshift);

WindowDef(\fx_module, { arg def, ndef;
	var paramGroupView = View.new;
	var instrumentPopUp = Param(Message(ndef), \source, TagSpecDef(\SynthDef_fx)).asPopUpMenu;
	instrumentPopUp.addAction({
		paramGroupView.removeAll;
		paramGroupView.layout = ndef.asParamGroup.asView;
	});
	paramGroupView.layout = ndef.asParamGroup.asView;

	VLayout (
		HLayout (
			PlayerWrapper(ndef).asView,
			instrumentPopUp,
			Param(Message(PlayerWrapper(ndef)), \outBus, ParamBusSpec()).asPopUpMenu,
		),
		paramGroupView
	)

});

///////////////////////////////////////////////////
// mod manager

	ProtoTemplateDef(\ModulationTable, (
		slots: { arg self;
			self[\slots] = {
				ProtoClass((
					sourceBus:nil,
					rangeValue:0,
					dest:nil,
				))
			} ! 8;
			self[\slots]
		},


		play: { arg self;
			self.slots.collect({ arg slot;
				if(slot.combinator.notNil) {
					PlayerWrapper(slot.combinator.proxy).play;
				}
			});
		},

		isPlaying: { arg self;
			self.slots.select({ arg slot; slot.sourceBus.notNil and: {slot.dest.notNil} and: {slot.combinator.notNil} }).every({ arg slot;
				slot.combinator.proxy.isPlaying;
			});
		},

		stop: { arg self;
			self.slots.collect({ arg slot;
				if(slot.combinator.notNil) {
					PlayerWrapper(slot.combinator.proxy).stop;
				}
			});
		},
		paramTags: TagSpecDef(\modularRack_param),
		paramTagLabels: TagSpecDef(\modularRack_paramlabel),
		updateCombinators: { arg self;
			var paramdict = Dictionary.new;
			debug("updateCombinators");
			self.slots.collect { arg slot, idx;
				slot.index = idx;
				slot.debug("sort slots");
				if(slot.sourceBus.notNil and: {slot.dest.notNil}) {
					paramdict[slot.dest] = paramdict[slot.dest].add(slot);
				}
			};
			paramdict.keys.debug("paramdict.keys");
			paramdict.keys.collect { arg paramkey, idx;
				var pc, param;
				paramkey.debug("creating combi");
				param = self.paramTags.asDict[paramkey];
				pc = ParamCombinator(param).setBusMode(true);
				paramdict[paramkey].collect { arg slot, inputidx;
					var bus = TagSpecDef(\BusDef).asDict[slot.sourceBus];
					slot.combinator = pc;
					pc.inputParam.at(inputidx).set(bus.asMap);
					//pc.rangeParam.at(inputidx).set(slot.rangeValue ? 0);
					slot.rangeParam = pc.rangeParam.at(inputidx);
					slot.baseParam = pc.targetParam;
					self.changed(\slot, slot.index);
				};
			};
		},

	));

ProtoDef(\modmanager, ProtoTemplateDef(\ModulationTable));

TagSpecDef(\BusDef_label, { TagSpecDef(\BusDef).list.collect({ arg asso; asso.key -> asso.key }) }); // workaround a bug
ProtoDef(\modularRack).modules.collect { arg module, idx;
	var exclude = [\dur, \legato];
	module.asParamGroup.do { arg param, idx;
		if(param.type == \scalar and: { exclude.includes(param.property).not }) {
			TagSpecDef(\modularRack_param).addUnique( param.fullLabel.asSymbol -> param );
			TagSpecDef(\modularRack_paramlabel).addUnique( param.fullLabel.asSymbol -> param.fullLabel.asSymbol );
		}
	};
};

WindowDef(\modmanager, { arg def, model;
	VLayout(
		PlayerWrapper(model).asView,
		* model.slots.collect({ arg slot;
			var rangeSlider;
			var sourcePopUp,
			rangeParam,
			baseKnob,
			destPopUp,
			playButton;

			//rangeSlider = Slider.new.orientation_(\horizontal);
			rangeSlider = Knob.new.minSize_(25);
			baseKnob = Knob.new.minSize_(25);

			sourcePopUp = Param(Message(slot), \sourceBus).asBusPopUpMenu(TagSpecDef(\BusDef_label));
			destPopUp = Param(Message(slot), \dest).asBusPopUpMenu(model.paramTagLabels);

			destPopUp.followChange(model, \slot, { arg view, obj, msg, idx;
				[view, obj, msg, idx, slot].debug("changed slot detected!");
				rangeSlider.mapParam(slot.rangeParam);
				baseKnob.mapParam(slot.baseParam);
			});
			sourcePopUp.addAction({
				debug("source popup!");
				model.updateCombinators;
			});
			destPopUp.addAction({
				slot.debug("destPopUp");
				baseKnob.mapParam( model.paramTags.asDict[Param(Message(slot), \dest).get]);
				model.updateCombinators;
			});

			HLayout(
				sourcePopUp,
				rangeSlider,
				baseKnob,
				destPopUp,
//				playButton,
			)
		})
		
	)

});

//////////////////// main proto

	ProtoDef(\modularRack, (
		modules: [
			Builder(\osc1), Pdef(\osc1),
			Builder(\osc2), Pdef(\osc2),

			Builder(\filter1), Pdef(\filter1),
			Builder(\filter2), Pdef(\filter2),

			Pdef(\modseq1),
			Pdef(\modseq2),

			Builder(\modosc1), Pdef(\modosc1),
			Builder(\modosc2), Pdef(\modosc2),

			Ndef(\fx1),
			Ndef(\fx2),
		],
		presetCompileString: { arg self;
			self.modules.collect { arg module, idx;
				module.asParamGroup.getParamCompilseString;
			}.join("\n\n");
			
		},
		edit: { arg self;
			WindowDef(\modularRack).front;
		},
	));
	FileSystemProject.loadOnce("libdef/SaverHelper.scd");
	ProtoTemplateDef(\SaverHelper).attachSaveMethods(ProtoDef(\modularRack));


//////////////////// rack gui

WindowDef(\modularRack, { arg def;
	HLayout (
		VLayout (
			WindowDef(\oscbuilder).asView(\osc1),
			WindowDef(\oscbuilder).asView(\osc2),
		),
		VLayout (
			HLayout (
				WindowDef(\modseq).asView(Pdef(\modseq1)),
				WindowDef(\modseq).asView(Pdef(\modseq2)),
			),
			HLayout (
				WindowDef(\builder_module).asView(\filter1),
				WindowDef(\builder_module).asView(\filter2),
			)
		),
		VLayout (
			WindowDef(\builder_module).asView(\modosc1),
			WindowDef(\oscbuilder).asView(\modosc2),
		),
		VLayout (
			WindowDef(\fx_module).asView(Ndef(\fx1)),
			WindowDef(\fx_module).asView(Ndef(\fx2)),
			WindowDef(\modmanager).asView(ProtoDef(\modmanager)),
		),
	)
});

8.do { arg x; BusDef(\krbus++x, \control) };
8.do { arg x; BusDef(\ar1bus++x, \audio, 1) };
8.do { arg x; BusDef(\stereobus++x, \audio, 2) };

)

// END

ProtoDef(\modularRack).edit;
WindowDef(\modularRack).front;

(
Pbindef(\osc1, 
	\note, Pseq([
		4,4,4,2, 1,0,0,0,
	],inf),
	\octave, 3,
	\dur, 1/4,
);
Pbindef(\osc2, 
	\note, Pseq([
		4,4,4,2, 1,0,0,0,
	],inf),
	\octave, 3,
	\dur, 1/4,
)
)

(
Pdef(\demo, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[693].value,
			\bufnum, ~buflib.kick[701].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1459].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1329].value,
			\bufnum, ~buflib.snare[1708].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('vipere/amenbreak.wav'),
		\legato, Pseq([1.91,0.4,1],inf),
		\speed, 1 * (~t/( 137/4/60 )),
		\pos, Pseg(Pseq([0,2,1,2],1),Pseq([4,0,1,0],inf)).loop/(137/4/60),
		\isRest, Pseq([
			Plazy({ arg ev;
				Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
				],1)
			}).loop,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
	),
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('vipere/amenbreak.wav'),
		\legato, 1.91,
		\speed, 1/2 * (~t/( 137/4/60 )),
		\pos, Pseg(Pseq([0,2],1),4).loop/(137/4/60),
		\isRest, Pseq([
			Plazy({ arg ev;
				Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
				],1)
			}).loop,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
	),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 0.51,
			\st, ( 92.20/4/60 ) ,
			\speed, 1/1.5 * ~t/ Pkey(\st) ,
			\pos, Pseg(Pseq([
				0,1,1,4,
				0,1,0,3,
				2,1,0,3,
				0,1/2,0,3,
			]/2,1),Pseq([1,0,1,0],inf)).loop/Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
		\isRest, Pseq([
			Plazy({ arg ev;
				Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
				],1)
			}).loop,
		],inf).coin.not,
			\dur, 1/16,
			\gain, 1.01,
		)
	]),
).play
)


// with mixer
(
Pdef(\demo, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[693].value,
			\bufnum, ~buflib.kick[701].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1459].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		\out, BusDef(\mixer3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1329].value,
			\bufnum, ~buflib.snare[1708].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		\out, BusDef(\mixer4, \audio),
		),
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('vipere/amenbreak.wav'),
		\legato, Pseq([1.91,0.4,1],inf),
		\speed, 1 * (~t/( 137/4/60 )),
		\pos, Pseg(Pseq([0,2,1,2],1),Pseq([4,0,1,0],inf)).loop/(137/4/60),
		\isRest, Pseq([
			Plazy({ arg ev;
				Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
				],1)
			}).loop,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
		\out, BusDef(\mixer5, \audio),
	),
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('vipere/amenbreak.wav'),
		\legato, 1.91,
		\speed, 1/2 * (~t/( 137/4/60 )),
		\pos, Pseg(Pseq([0,2],1),4).loop/(137/4/60),
		\isRest, Pseq([
			Plazy({ arg ev;
				Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
				],1)
			}).loop,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
		\out, BusDef(\mixer6, \audio),
	),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 0.51,
			\st, ( 92.20/4/60 ) ,
			\speed, 1/1.5 * ~t/ Pkey(\st) ,
			\pos, Pseg(Pseq([
				0,1,1,4,
				0,1,0,3,
				2,1,0,3,
				0,1/2,0,3,
			]/2,1),Pseq([1,0,1,0],inf)).loop/Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
		\out, BusDef(\mixer7, \audio),
		\isRest, Pseq([
			Plazy({ arg ev;
				Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
				],1)
			}).loop,
		],inf).coin.not,
			\dur, 1/16,
			\gain, 1.01,
		)
	]),
).play
)

/////////////////////////////////////////////////// draft





().source


Param(Ndef('ParamCombinator_180857'), ('ranges' -> 0)).get
Param(Ndef('ParamCombinator_180857'), ('ranges')).get
Param(Ndef('ParamCombinator_180857'), ('ranges' -> 0)).set(0)
Ndef('ParamCombinator_180857').nodeMap

ProtoDef(\modmanager).slots = nil
ProtoDef(\modmanager).slots
TagSpecDef(\modularRack_param).keyList
(
)
(
WindowDef(\win, { arg def;
	
			//Param(Message(ProtoClass(())), \dest).asBusPopUpMenu(TagSpecDef(\modularRack_paramlabel));
			Param(ProtoClass(()), \dest).asBusPopUpMenu(TagSpecDef(\modularRack_paramlabel));
			//Param(Pdef(\osc1), \dest).asValuePopUpMenu(TagSpecDef(\modularRack_paramlabel));
}).front;
)
Param(Message(ProtoClass(())), \dest).set(1)

TagSpecDef(\modularRack_param).list


(
WindowDef(\fx_module).front(Ndef(\fx1))
)

SynthDesc(\fx_freqshift).asParamGroup.collect(_.postln)
SynthDesc(\osc1).asParamGroup.collect(_.postln)
Ndef(\fx2).asParamGroup.collect(_.postln)
Ndef(\fx2).nodeMap
Ndef(\fx2).source = \fx_freqshift
Ndef(\fx1).bus


1
ParamProto.init
WindowDef(\filedialog_save)

Pdef(\osc1).asParamGroup.getParamCompilseString

(
)

ProtoDef(\modularRack).savePresetCompileStringDialog
ProtoDef(\modularRack).keys


(

WindowDef(\builder_module).front(\filter2)
)


PdefParam.instrument(Pdef(\filter1)).asParamGroup
Pdef(\filter1).asParamGroup.collect(_.postln)



/////////////////////////// debug

ParamCombinator( Param(Pdef(\osc1), \fspread) ).setBusMode(true);
ParamCombinator( Param(Pdef(\osc1), \fspread) ).inputParam.at(0).setBus(BusDef(\krbus0).asMap);
Pdef(\osc1).get(\fspread).dump
Param(Pdef(\osc1), \fspread).getBus.dump
ParamCombinator( Param(Pdef(\osc1), \fspread) ).inputParam.at(0).getBus.dump
ParamCombinator( Param(Pdef(\osc1), \fspread) ).inputParam.at(0).getRaw
~p = ParamCombinator( Param(Pdef(\osc1), \fspread) ).inputParam.at(0)
~p.get
~p.parent.getRaw
~p.parent.get
~p.parent.spec
~p.wrapper.property
~pc = ParamCombinator( Param(Pdef(\osc1), \fspread) )
~pc.proxy.get(\inputs)
~b = ~pc.proxy.get(\inputs).asCachedBus
~b = ~pc.proxy.get(\inputs).asBus
~b.getSynchronous
~b.getn(3)
Bus
~b.getCached
~pc.proxy.getVal(\inputs)
ParamCombinator( Param(Pdef(\osc1), \fspread) ).inputParam.get
ParamCombinator( Param(Pdef(\osc1), \fspread) ).inputParam.getRaw
ParamCombinator( Param(Pdef(\osc1), \fspread) ).inputParam.getRaw



(
TagSpecDef(\BusDef_asMap).list.sort({ arg a, b; 
	"% < % ? %".format(a.key.asCompileString, b.key.asCompileString, a.key < b.key).postln;
	a.key < b.key
}).collect(_.postln)
)

TagSpecDef(\ParamCombinatorInput_asMap, { 
	["-" -> 0] ++ TagSpecDef(\ParamCombinatorInput).list.collect({ arg x; x.key -> x.value.asMap }).sort({ arg x; x.key })
	++ TagSpecDef(\BusDef_asMap).list
});


(
WindowDef(\win, { arg def;
	Param(Pdef(\osc1), \out).asBusPopUpMenu
}).front;
);
