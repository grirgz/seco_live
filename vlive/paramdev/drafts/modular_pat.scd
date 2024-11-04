// keep this code simple as a demo
(
	s.boot;

SynthDef(\osc_sin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, modfreq=1, modphase=0, scale_modfreq=1, scale_modphase=1;
	var sig;
	sig = SinOsc.ar(freq * ( modfreq * scale_modfreq + 1), ( modphase * scale_modphase + 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	modfreq: ParamMappedBusSpec(TagSpecDef(\BusDef_asMap)),
	modphase: ParamMappedBusSpec(TagSpecDef(\BusDef_asMap)),
))).add;

SynthDef(\osc_pulse, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, modfreq=1, modphase=0, scale_modfreq=1, scale_modphase=1;
	var sig;
	sig = LFPulse.ar(freq * ( modfreq * scale_modfreq + 1), ( modphase * scale_modphase + 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	modfreq: ParamMappedBusSpec(TagSpecDef(\BusDef_asMap)),
	modphase: ParamMappedBusSpec(TagSpecDef(\BusDef_asMap)),
))).add;

SynthDef(\osc_saw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, modfreq=1, scale_modfreq=1;
	var sig;
	sig = LFSaw.ar(freq * ( modfreq * scale_modfreq + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	modfreq: ParamMappedBusSpec(TagSpecDef(\BusDef_asMap)),
))).add;

SynthDef(\fil_rlpf, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, rq=0.5, cutoff=500, modcutoff=1, modrq=1, scale_modcutoff=1, scale_modrq=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = RLPF.ar(in, cutoff * ( modcutoff * scale_modcutoff + 1 ), rq * ( modrq * scale_modrq + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	modcutoff: ParamMappedBusSpec(TagSpecDef(\BusDef_asMap)),
	modrq: ParamMappedBusSpec(TagSpecDef(\BusDef_asMap)),
	inbus: ParamBusSpec(TagSpecDef(\BusDef)),
))).add;

SynthDef(\fil_rhpf, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, rq=0.5, cutoff=500, modcutoff=1, modrq=1, scale_modcutoff=1, scale_modrq=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = RHPF.ar(in, cutoff * ( modcutoff * scale_modcutoff + 1 ), rq * ( modrq * scale_modrq + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	modcutoff: ParamMappedBusSpec(TagSpecDef(\BusDef_asMap)),
	modrq: ParamMappedBusSpec(TagSpecDef(\BusDef_asMap)),
	inbus: ParamBusSpec(TagSpecDef(\BusDef)),
))).add;

SynthDef(\fil_bpf, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, rq=0.5, cutoff=500, modcutoff=1, modrq=1, scale_modcutoff=1, scale_modrq=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = BPF.ar(in, cutoff * ( modcutoff * scale_modcutoff + 1 ), rq * ( modrq * scale_modrq + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	modcutoff: ParamMappedBusSpec(TagSpecDef(\BusDef_asMap)),
	modrq: ParamMappedBusSpec(TagSpecDef(\BusDef_asMap)),
	inbus: ParamBusSpec(TagSpecDef(\BusDef)),
))).add;

SynthDef(\mod_seq, { arg out=0, gate=1, amp=0.1, pan=0, seqrate=1/4, modseqrate=1, scale_modseqrate=1;
	var sig;
	sig = Duty.ar(( 1/seqrate ).poll * (modseqrate * scale_modseqrate + 1), 0, Dseq([
		Dseq(\seqtab.kr(0!8)),
	],inf));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	modseqrate: ParamMappedBusSpec(TagSpecDef(\BusDef_asMap)),
	seqtab: ParamArraySpec(\unipolar)
))).add;

SynthDef(\mod_sin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, modfreq=1, modphase=0, scale_modfreq=1, scale_modphase=1, ampBias = 0;
	var sig;
	sig = SinOsc.ar(freq * ( modfreq * scale_modfreq + 1), ( modphase * scale_modphase + 1));
	sig = sig + ampBias;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	modfreq: ParamMappedBusSpec(TagSpecDef(\BusDef_asMap)),
	modphase: ParamMappedBusSpec(TagSpecDef(\BusDef_asMap)),
))).add;

TagSpecDef(\modular_synthdefs, [
	\osc_sin,
	\osc_saw,
	\osc_pulse,
	\fil_rlpf,
	\fil_rhpf,
	\fil_bpf,
	\mod_sin,
	\mod_seq,
]);

8.do { arg idx; BusDef("modbus%".format(idx.asString.padLeft(1,"0")).asSymbol.debug("create bus"), \audio, 2) };
8.do { arg idx; BusDef("rout%".format(idx.asString.padLeft(1,"0")).asSymbol.debug("create bus"), \audio, 2) };
);

(
ProtoTemplateDef(\modular_module, (
	init: { arg self, parent, idx;
		self.proxy = self.proxy ?? { EventPatternProxy.new.source_(Pbind(\type,\rest)) };
		self.model = { parent };
		self.idx = idx;
	},

	isPlaying: { arg self;
		PlayerWrapper(self.proxy).isPlaying
	},

	isPlaying_: { arg self, val;
		"is it really".debug;
		//if()
		//PlayerWrapper(self.proxy).isPlaying = val;
		//self.changed(\isPlaying);
	},

	play: { arg self;
		self.proxy.play;
	},

	stop: { arg self;
		self.proxy.stop;
	},

	paramGroup: { arg self;
		self.proxy.asParamGroup.select { arg param;
			[\adsr, \legato, \dur].includes(param.property).not;
		};
	},

	instrument_: { arg self, val;
		self[\instrument] = val;
		self.proxy.source = Pmono(val);
		//self.proxy.set(\instrument, val);
		self.proxy.addHalo(\instrument, val);
		self.changed(\instrument)
	},

	asView: { arg self;
		WindowDef(\module+++self.idx, WindowDef(\module)).asView(self, self.model, self.idx)
	},

	edit: { arg self;
		WindowDef(\module+++self.idx, WindowDef(\module)).front(self, self.model, self.idx)
	},

));

ProtoDef(\modular_pat, (
	init: { arg self;
		self.slots = 8.collect { arg idx;
			ProtoDef(\module+++idx, ProtoTemplateDef(\modular_module)).init(self, idx)
		};
	},
	asPattern: { arg self;
		Ppar(self.slots.collect(_.proxy))
	},
	edit: { arg self;
		WindowDef(\modular_pat).front(self);
	},
)).init;
)

(
WindowDef(\module, { arg def, slot, model, idx;
	var paramGroupView = View.new;
	var playbut;
	paramGroupView.followChange(slot, \instrument, { arg view;
		view.removeAll;
		slot.paramGroup.do({ arg param;
			if(param.type == \scalar) {
				param.inBusMode = true;
			}
		});
		view.layout = VLayout( *slot.paramGroup.collect(_.asView)++[nil] );
		nil;
	},true);
	playbut = PlayerWrapper(slot).label_("").asView;
	playbut.button.fixedWidth_(40);
	VLayout (
		HLayout (
			playbut,
			StaticText.new.string_("Module %".format(idx)).background_(ParamViewToolBox.color_ligth).align_(\center),
			Param(Message(slot), \instrument, TagSpecDef(\modular_synthdefs)).asPopUpMenu,
		),
		paramGroupView,
	)
});

WindowDef(\modular_pat, { arg def, model;
	var makeBlock;
	VLayout (
		GridLayout.rows(
			* model.slots.collect({ arg x, idx; x.asView(model, idx) }).clump(4)
		)
	)
});

ProtoDef(\modular_pat).edit;
)


//ProtoDef(\modular_pat).slots[0].edit
