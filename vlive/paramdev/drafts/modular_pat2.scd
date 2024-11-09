
// keep this code simple as a demo
// but more advanced than modular_pat.scd

// FIXME:
// - mod synthdefs should be mono and modbus should be mono
//		- or we find a way to make stereo to mono
//		- or we make modulator input stereo
//		- or we make all modules mono, then add a stereo at the end
(
	s.boot;
	//ParamProto.init; // to have TagSpecDef base definitions

SynthDef(\osc_sin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, scale_modfreq=1, scale_modphase=1;
	var sig;
	sig = SinOsc.ar(freq * ( \modfreq.ar * scale_modfreq + 1), ( \modphase.ar * scale_modphase + 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	out: ParamBusSpec(TagSpecDef(\BusDef_audio_stereo)),
	modfreq: ParamMappedBusSpec(TagSpecDef(\BusDef_audio_mono_asMap)),
	modphase: ParamMappedBusSpec(TagSpecDef(\BusDef_audio_mono_asMap)),
))).add;

SynthDef(\osc_pulse, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, scale_modfreq=1, scale_modphase=1;
	var sig;
	sig = LFPulse.ar(freq * ( \modfreq.ar * scale_modfreq + 1), ( \modphase.ar * scale_modphase + 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	out: ParamBusSpec(TagSpecDef(\BusDef_audio_stereo)),
	modfreq: ParamMappedBusSpec(TagSpecDef(\BusDef_audio_mono_asMap)),
	modphase: ParamMappedBusSpec(TagSpecDef(\BusDef_audio_mono_asMap)),
))).add;

SynthDef(\osc_saw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, scale_modfreq=1;
	var sig;
	sig = LFSaw.ar(freq * ( \modfreq.ar * scale_modfreq + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	out: ParamBusSpec(TagSpecDef(\BusDef_audio_stereo)),
	modfreq: ParamMappedBusSpec(TagSpecDef(\BusDef_audio_mono_asMap)),
))).add;

SynthDef(\fil_rlpf, { arg inbus=0, out=0, gate=1, gain=1, freq=200, rq=0.5, cutoff=500, scale_modcutoff=1, scale_modrq=1;
	var sig;
	//var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var in = InFeedback.ar(inbus, 2); 
	sig = RLPF.ar(in, cutoff * ( \modcutoff.ar * scale_modcutoff + 1 ), rq * ( \modrq.ar * scale_modrq + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}, metadata:(specs:(
	out: ParamBusSpec(TagSpecDef(\BusDef_audio_stereo)),
	modcutoff: ParamMappedBusSpec(TagSpecDef(\BusDef_audio_mono_asMap)),
	modrq: ParamMappedBusSpec(TagSpecDef(\BusDef_audio_mono_asMap)),
	inbus: ParamBusSpec(TagSpecDef(\BusDef_audio_stereo)),
))).add;

SynthDef(\fil_rhpf, { arg inbus=0, out=0, gate=1, gain=1, freq=200, rq=0.5, cutoff=500, scale_modcutoff=1, scale_modrq=1;
	var sig;
	//var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var in = InFeedback.ar(inbus, 2); 
	sig = RHPF.ar(in, cutoff * ( \modcutoff.ar * scale_modcutoff + 1 ), rq * ( \modrq.ar * scale_modrq + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}, metadata:(specs:(
	out: ParamBusSpec(TagSpecDef(\BusDef_audio_stereo)),
	modcutoff: ParamMappedBusSpec(TagSpecDef(\BusDef_audio_mono_asMap)),
	modrq: ParamMappedBusSpec(TagSpecDef(\BusDef_audio_mono_asMap)),
	inbus: ParamBusSpec(TagSpecDef(\BusDef_audio_stereo)),
))).add;

SynthDef(\fil_bpf, { arg inbus=0, out=0, gate=1, gain=1, freq=200, rq=0.5, cutoff=500, scale_modcutoff=1, scale_modrq=1;
	var sig;
	//var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var in = InFeedback.ar(inbus, 2); 
	sig = BPF.ar(in, cutoff * ( \modcutoff.ar * scale_modcutoff + 1 ), rq * ( \modrq.ar * scale_modrq + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}, metadata:(specs:(
	out: ParamBusSpec(TagSpecDef(\BusDef_audio_stereo)),
	modcutoff: ParamMappedBusSpec(TagSpecDef(\BusDef_audio_mono_asMap)),
	modrq: ParamMappedBusSpec(TagSpecDef(\BusDef_audio_mono_asMap)),
	inbus: ParamBusSpec(TagSpecDef(\BusDef)),
))).add;

SynthDef(\fil_envgen, { arg inbus=0, out=0, gate=1, gain=1, pan=0;
	var sig;
	//var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var in = InFeedback.ar(inbus, 2); 
	sig = in;
	sig = sig * EnvGen.kr(\iadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), \igate.kr(0), doneAction:0);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, 1);
	sig = Balance2.ar(sig[0],sig[1], pan);
	sig = sig * gain;
	Out.ar(out, sig);
}, metadata:(specs:(
	out: ParamBusSpec(TagSpecDef(\BusDef_audio_stereo)),
	iadsr: ParamEnvSpec.adsr,
	inbus: ParamBusSpec(TagSpecDef(\BusDef)),
	igate: \unipolar,
))).add;

SynthDef(\mod_seq, { arg out=0, gate=1, amp=0.1, pan=0, seqrate=1/4, scale_modseqrate=1;
	var sig;
	sig = Duty.ar(( 1/seqrate ) * (\modseqrate.ar * scale_modseqrate + 1), 0, Dseq([
		Dseq(\seqtab.kr(0!8)),
	],inf));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}, metadata:(specs:(
	out: ParamAudioBusSpec(TagSpecDef(\BusDef_audio_mono)),
	modseqrate: ParamMappedBusSpec(TagSpecDef(\BusDef_audio_mono_asMap)),
	seqtab: ParamArraySpec(\unipolar)
))).add;

SynthDef(\mod_sin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, ampBias = 0, scale_modfreq=1, scale_modphase=1;
	var sig;
	//out.poll(label:"mod_sinout");
	sig = SinOsc.ar(freq * ( \modfreq.ar * scale_modfreq + 1), ( \modphase.ar * scale_modphase + 1));
	sig = sig + ampBias;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}, metadata:(specs:(
	out: ParamControlBusSpec(TagSpecDef(\BusDef_audio_mono)),
	ampBias: ControlSpec(0,10,\lin),
	modfreq: ParamMappedBusSpec(TagSpecDef(\BusDef_audio_mono_asMap)),
	modphase: ParamMappedBusSpec(TagSpecDef(\BusDef_audio_mono_asMap)),
))).add;

TagSpecDef(\modular_synthdefs, [
	\osc_sin,
	\osc_saw,
	\osc_pulse,
	\fil_rlpf,
	\fil_rhpf,
	\fil_bpf,
	\fil_envgen,
	\mod_sin,
	\mod_seq,
]);

Spec.add(\gain, \unipolar);

8.do { arg idx; BusDef("modbus%".format(idx.asString.padLeft(1,"0")).asSymbol.debug("create bus"), \audio, 1) };
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

	preProxy: { arg self;
		self[\preProxy] = EventPatternProxy.new.source_(Pbind());
		self[\preProxy];
	},

	instrument_: { arg self, val;
		self[\instrument] = val;
		self.proxy.source = Pmono(val) <> self.preProxy;
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
			if(param.type == \scalar and:{ param.spec.isKindOf(ParamMappedBusSpec).not }) {
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
// connect to midi

(
~paramfreq = Param(ProtoDef(\modular_pat).slots[0].proxy, \freq);
~paramfreq.setBusMode(true);
MIDIdef.noteOn(\track1, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	~paramfreq.set(noteNum.midicps);
});
)

// with envgen module

(
~paramgate = Param(ProtoDef(\modular_pat).slots[7].proxy, \igate);
~paramgate.setBusMode(true);
~paramfreq = Param(ProtoDef(\modular_pat).slots[0].proxy, \freq);
~paramfreq.setBusMode(true);
~numnote = 0;
MIDIdef.noteOn(\track1, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	~paramgate.set(1);
	~numnote = ~numnote + 1;
	~paramfreq.set(noteNum.midicps);
});
MIDIdef.noteOff(\track1_off, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	~numnote = ~numnote - 1;
	if(~numnote <= 0) {
		~paramgate.set(0);
	}
});
)

//////////////////////////////////////////
// keyboard gui
(
WindowDef(\pianokeyboard, { arg def;
    var kb = MIDIKeyboardView.new;
	kb.keyDownAction = { arg midinote, old;
		~paramfreq.set(midinote.midicps)
	};
	kb.keyTrackAction = { arg midinote, old;
		~paramfreq.set(midinote.midicps)
	};

    def.windowDo { arg win; // special method of WindowDef to manipulate the Window if available
        win.setInnerExtent(800,120); // set a default size to look nice at first try
    };

    kb.asView;
}).front; // GUI is made generic by taking the pattern as argument
)

//////////////////////////////////////////

ParamAudioBusSpec(TagSpecDef(\BusDef_audio_mono)).tagSpec
~a = ParamAudioBusSpec(TagSpecDef(\BusDef_audio_mono))
~a.tagSpec
~a.tagSpec = TagSpecDef(\BusDef_audio_mono)
TagSpecDef(\BusDef_audio_mono).list
TagSpecDef(\BusDef_audio_stereo).list
TagSpecDef(\BusDef_audio_asMap).list
TagSpecDef(\BusDef_audio_mono_asMap).list
TagSpecDef(\BusDef_audio_stereo_asMap).list

ProtoDef(\modular_pat).presetCompileString

//ProtoDef(\modular_pat).slots[0].edit
//ProtoDef(\modular_pat).slots[0].edit
Param(ProtoDef(\modular_pat).slots[2].proxy, \modfreq).edit
Param(ProtoDef(\modular_pat).slots[2].proxy, \modfreq).inBusMode
Param(ProtoDef(\modular_pat).slots[2].proxy, \modfreq).accessor
~p = Param(ProtoDef(\modular_pat).slots[0].proxy, \modfreq);
~p.get.asCompileString
~p.accessor
~p.wrapper
~p.get
~p.inBusMode
~p = Param(ProtoDef(\modular_pat).slots[1].proxy, \out);
~p.spec.tagSpec
~p.spec
\out.asSpec
Param(ProtoDef(\modular_pat).slots[0].proxy, \modfreq).get
Param(ProtoDef(\modular_pat).slots[2].proxy, \modfreq).set(BusDef(\modbus1).asMap)
Param(ProtoDef(\modular_pat).slots[2].proxy, \modfreq).type
Param(ProtoDef(\modular_pat).slots[2].proxy, \modfreq).spec
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

			(
			Pdef(\zed, 
				ProtoDef(\modular_pat).asPattern
				<>
				Pbind(
					\degree, Pseq([0,2,5],inf),
					\octave, Pwrand([4,5,3,6]+1,[10,2,1,1].normalizeSum,inf),
					\dur, 1/4,
					\amp, 0.1,
				)
			).play;
			);
			ProtoDef(\modular_pat).slots[0].proxy.set(\freq, Pkey(\freq))
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
