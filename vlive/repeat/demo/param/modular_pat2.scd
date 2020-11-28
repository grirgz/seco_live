
// keep this code simple as a demo
// but more advanced than modular_pat.scd
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
	FileSystemProject.load("libdef/SaverHelper.scd");
ProtoTemplateDef(\modular_module, (
	init: { arg self, parent, idx;
		self.proxy = self.proxy ?? { EventPatternProxy.new.source_(Pbind(\type,\rest)) };
		self.model = { parent };
		self.idx = idx;
		ProtoTemplateDef(\SaverHelper).attachSaveMethods(self);
		self;
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

	presetCompileString: { arg self;
		var str = self.paramGroup.collect { arg param, idx;
			var val, mapmode;
			param.spec.debug("spec");
			if(param.spec.isKindOf(ParamMappedBusSpec)) {
				param.spec.debug("mapmode");
				mapmode = "Bus";
				val = param.getBus;
				if(val.notNil) {
					val = "%.asMap".format(val.asBusDef.asCompileString);
				} {
					val = nil;
				}
			} {
				mapmode = "";
				val = param.get.asCompileString;
			};
			"Param(ProtoDef(%).proxy, %).set%(%);".format(self.key.asCompileString, param.property.asCompileString, mapmode, val)
		}.join("\n");
		str = "ProtoDef(%).instrument = %;\n".format(self.key.asCompileString, self.instrument.asCompileString  ) ++ str;
		str;
	},


));

ProtoDef(\modular_pat, (
	init: { arg self;
		"init modular".debug;
		ProtoTemplateDef(\SaverHelper).attachSaveMethods(self);
		self.slots = 8.collect { arg idx;
			ProtoDef(\module+++idx, ProtoTemplateDef(\modular_module)).init(self, idx);
			ProtoDef(\module+++idx);
		};
	},
	asPattern: { arg self;
		Ppar(self.slots.collect(_.proxy))
	},
	edit: { arg self;
		WindowDef(\modular_pat).front(self);
	},
	presetCompileString: { arg self;
		self.slots.collect(_.presetCompileString).join("\n\n");
	},
)).init;

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
	VLayout (
		GridLayout.rows(
			* model.slots.collect({ arg x, idx; x.asView(model, idx) }).clump(4)
		)
	)
});

)

ProtoDef(\modular_pat).edit;
//////////////////////////////////////////

//ProtoDef(\modular_pat).slots[0].edit
//ProtoDef(\modular_pat).slots[0].edit
Param(ProtoDef(\modular_pat).slots[0].proxy, \freq).asCompileString
ProtoDef(\modular_pat).slots[0].presetCompileString
ProtoDef(\modular_pat).slots[0].proxy
ProtoDef(\modular_pat).slots[0].savePresetCompileStringDialog
ProtoDef(\modular_pat).slots
ProtoDef(\modular_pat).asPattern
ProtoDef(\modular_pat).presetCompileString
ProtoDef(\modular_pat).savePresetCompileStringDialog
FileSystemProject.load("libdef/filedialog.scd")
ProtoDef(\modular_pat)[\init].asCompileString
BusDef(\modbus1, \audio, 2).asMap.asBus.key
BusDef(\modbus1, \audio, 2).asMap.asBusDef
BusDef(\modbus1, \audio, 2).asMap.key
BusDef.all.detect({ arg x; x.index.debug("idx"); true })
().dsfsd.dfk
ParamProto.init
ParamProto.init(true)
1

(init: { 'bla' }).init
ProtoDef(\hey, (init: { "bla" })).init
WindowDef(\bla, { Button.new }).front

			(
			WindowDef(\filedialog_save).front(nil,{ arg path;
				path.debug;
			})
			)

Window

(
{
var window = Window.new;
var layout;
layout = VLayout(
	Button.new
);
window.layout = layout;
//window.alwaysOnTop = true;
window.front;
try {
	
Window.availableBounds.extent == window.bounds.extent;
}
}.value
)
