
(
s.waitForBoot{
Window.closeAll;
~seq = Mdef.force_init(true);
//~seq.init_midi;
~synthlib = [
	\seqnode,
	\parnode,
	\audiotrack_expander,
	\monosampler,
	\stereosampler,
	\ss_comb,
	\ss_combfreq,

	"ci op_matrix2",
	"ci mosc",
	"ci moscfilter",
	"ci moscfilter_modfx",
	"ci osc3filter2",
	"ci bufosc_filt",
	"ci bufosc_filt_spread",
	"ci samplerfilter2",

	//"ci inlinefx",
	"ci inlinegen",
	"ci inline_genfx",

	\bufsin1,
	\zegrainer,
	\sampleosc1,
	\sampleosc2,

	\osc1,
	\osc_lag,
	\osc_test,
	\noisecomb,
	\moteur,
	\guitar,
	\guitar2,
	\ch,
	\membraneHex,

	\kick1,
	\kick2,
	\kick3,
	\kicklank,
	\snare1,
	\snare2,
	\kraftySnr,

	\lead2,
	\saxo,
	\organ,
	\noisescape,
	\crackle2,
	\randsaw,
	\klankbell,
	\saklangbell,
	\gris1,
].collect({ arg i; i -> i });
~seq.load_patlib( ~synthlib );


~effectlib = [
	\comb1,
	\combline,
	\p_reverb,
	\p_flanger,
	\p_chorus,
	\p_delay,
	\p_comb,
	"ci insertfx3",
	"ci fxsfilter2",
	\dubecho,
	\dubecho_inmix,
	\dubecho_orig,
	\limiter,
	\bufstut,
	\multitap8,
	\ir_reverb,
].collect({arg i; i -> i });
~seq.load_effectlib( ~effectlib );

~modlib = [
	\setbus,
	\modenv,
	\gater,
	\gated_asr,
	\lfo1,
	\lfo_tri,
	\lfo_asr,
	\line1,
	\varline1,
	"ci mod_osc",
	"ci mod_envosc",
	"ci dadsr_kr",
	"ci custom_env",
	"ci selfgated_env",
	\cuspl,
].collect({arg i; i -> i });
~seq.load_modlib( ~modlib );

~inlinegenlib = [
	\empty,
	"ci ingen_osc",
	"ci sin",
];
~seq.load_inlinegenlib( ~inlinegenlib );

~inlinefxlib = [
	\empty,
	"ci infx_filter",
];
~seq.load_inlinefxlib( ~inlinefxlib );

~seq.set_presetlib_path("mypresets");

Mdef.side_gui;

~windowize = { arg layout;
	var win;
	win = Window.new;
	win.layout = layout;
	win.front;
};

Mdef.main.samplekit_manager.parse_samplekit_dir;
Mdef.main.samplekit_manager.parse_samplekit_dir(~seco_root_path +/+ "hydrogenkits/");

}
)


(
SynthDef(\mylfo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, range=1, offset=100;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig.range(100,1000);
	//sig.poll;
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:2);
	Out.kr(out, sig);
}).add;
)



(
Pdef(\plop2, Pbind(
	\instrument, \osc1,
	\degree, Pseq([0,2,4, 1,3,5, 2,1],inf),
	\scale, Scale.minor,
	\dur, 1/2,
	\amp, 0.1
)).play;
);
Pdef(\plop2).clear

Pdef(\plop2).set(\ffreq, ~mod.busArg)
Pdef(\plop2).map(\ffreq, ~mod)
Pdef(\plop2).set(\ffreq, 200)
~mod.busArg
~mod.play
~mod.awake
~mod.send
~mod.ar
~mod.asMap
~mod.busArg
~mod.play
~mod.wakeUp



~mod = NodeProxy.control
~mod.awake = false
~mod.awake = true
~mod.stop
~mod.release
(

~mod.source = Pbind(
	\instrument, \mylfo,
	\freq, Pseq([1,4],inf),
	\dur, 2,
	//\out, ~bus,
	\amp, 0.1
);
)











///////////////////////:


(
Pdef(\plop3, Pbind(
	\instrument, \osc1,
	\degree, Pseq([0,2,4, 1,3,5, 2,1],inf),
	\scale, Scale.minor,
	\dur, 1/2,
	\amp, 0.1
)).play;
);
Pdef(\plop3).clear

Pdef(\plop3).set(\ffreq, Ndef(\mod3).kr)
Pdef(\plop3).set(\ffreq, Ndef(\mod3))
Pdef(\plop3).set(\ffreq, Ndef(\mod3).busArg)
Pdef(\plop3).map(\ffreq, Ndef(\mod3).busArg)
Pdef(\plop3).map(\ffreq, ~mod)
Pdef(\plop3).set(\ffreq, 200)
Pdef(\plop3).unset(\ffreq)
(

Ndef(\mod3, Pbind(
	\instrument, \mylfo,
	\freq, Pseq([1,4],inf),
	\dur, 2,
	//\out, ~bus,
	\amp, 0.1
));
)



///////////////////////:


(
Pdef(\plop4, Pbind(
	\instrument, \osc1,
	\degree, Pseq([0,2,4, 1,3,5, 2,1],inf),
	\scale, Scale.minor,
	\dur, 1/2,
	\amp, 0.1
)).play;
);

Pdef(\plop4).set(\ffreq, Pdef(\mod4).kr)
Pdef(\plop4).set(\ffreq, Pdef(\mod4).busArg)
Pdef(\plop4).set(\ffreq, Pdef(\mod4))
Pdef(\plop4).map(\ffreq, Pdef(\mod4).busArg)
Pdef(\plop4).map(\ffreq, ~mod)
Pdef(\plop4).set(\ffreq, 200)
(

Pdef(\mod4, Pbind(
	\instrument, \mylfo,
	\freq, Pseq([1,4],inf),
	\dur, 2,
	//\out, ~bus,
	\amp, 0.1
));
)

Pdef(\mod4).dump


//////////////////////////////////////

"~/code/sc/seco/synthpool.sc".standardizePath.load

(
Pdef(\plop7, Pbind(
	\instrument, \osc1,
	\degree, Pseq([0,2,4, 1,3,5, 2,1],inf),
	\scale, Scale.minor,
	\ffreq, 800,
	\dur, 1/2,
	\amp, 0.7
));
);
Pdef(\plop7, nil)
Pdef(\plop7).free
Pdef(\plop7).clear
Pdef(\plop7).clearAll
Pdef(\plop7).play

Pbindef(\plop7, \ffreq, ~mod)

Pdef(\plop7).set(\ffreq, ~mod)
Pdef(\plop7).set(\amp, 0.1)
Pdef(\plop7).set(\ffreq, 100)
Pdef(\plop7).unset(\ffreq, 200)
Pdef(\plop7).set(\freq, 800)
Pdef(\plop7).unset(\freq, 1800)
~mod = NodeProxy.control
~mod.awake= false
(

~mod.source = Pbind(
	\instrument, \mylfo,
	\freq, Pseq([8,14],inf),
	\dur, 2,
	//\out, ~bus,
	\amp, 0.1
);
)


2
"vim --servername SCVIM --sendremote o"
Document.new

Pseq([Pseq([1,0],4), 1, 0,111,0])
Pseq("101011110100011110".asList.collect(_.))
Pnsym("111000111", (1:5,0:6)).asStream.nextN(4)
"10101".asList.collect(_.asSymbol).dump
"111000111".asList.collect(_.asString.asFloat)
Pstr("1011110001")
~pstr = { arg str; str.asList.collect(_.asString.asFloat) }
~pstr.("1010110")
a = ()
a.pstr = { arg str; str.asList.collect(_.asString.asFloat) }
a.

Pstutter(kk)
Prand
(
Pdef(\plop45, Pbind(
	\instrument, \default,
	\degree, Pnsym("111000111".asList.collect(_.asSymbol), (1:5,0:6)),
	\dur, 1,
	\amp, 0.1
)).play;
);


(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

Pdef(\plop).set(\amp, 2)
"plop".postln
(
	
Pdef(\plop).set(\freq, 200)
)
Main.version



/////////////////////////////////////////////////



(

~class_score_player = (
	parent: ~class_abstract_node,
	get_main: { Mdef.main },

	new: { arg self;
		self = self.deepCopy;
	
		self.data = Dictionary.new;
		self.data[\noteline] = ~make_noteline_param.(\noteline);
		self.scoreset = { self.data[\noteline].get_scoreset };
	
		self;
	},

	get_mode: { arg self;
		\noteline
	},

	get_scoreset: { arg self;
		self.scoreset;
	},

	pat: { arg self, i, repeat=inf;
		Pbind(
			\noteline, Prout { arg ev;
				repeat.do {
					var notes = self.data[\noteline].get_scoreset.get_sheet(i).get_rel_notes;
					notes.do { arg no;
						ev = no.yield;
					}
				}
			},
			\midinote, Pfunc{ arg ev; ev[\noteline][\midinote] },
			\sustain, Pfunc{ arg ev; ev[\noteline][\sustain] },
			\dur, Pfunc{ arg ev; ev[\noteline][\dur] },
		)
	},

	pindex: { arg self, pat;
		var list;
		list = 8.collect { arg i;
			self.pat(i,1)
		};
		Pindex(list, pat)
	},

	pstr: { arg self;
		
	},

	vpattern: { arg self;
		Pbind(
			\noteline, self.data[\noteline].vpattern,
			\midinote, Pfunc{ arg ev; ev[\noteline][\midinote] },
			\sustain, Pfunc{ arg ev; ev[\noteline][\sustain] },
			\dur, Pfunc{ arg ev; ev[\noteline][\dur] },
		)
		
	},

	edit: { arg self;
		var display;
		var ltracks;
		var node = self;
		display = Mdef.main.panels.side.track_display;
		ltracks = ~class_line_tracks_controller.new(Mdef.main, node, display);
		ltracks.make_gui;
	},
);
~make_note_editor = { arg node;
	var display;
	var ltracks;
	display = Mdef.main.panels.side.track_display;
	ltracks = ~class_line_tracks_controller.new(Mdef.main, node, display);
	ltracks.make_gui;

};
~node = ~class_score_player.new;
	
)

~node.edit
~make_note_editor.(~node);
~node.vpattern.play

~node.get_scoreset.select_sheet(0)
~node.get_scoreset.get_notescore.notes

~node.get_arg(~node.get_mode)
~node.pat(1).play
					~node.data[\noteline].get_scoreset.get_sheet(0).get_rel_notes

					Nil

					PnilSafe
(
Pdef(\plop, Pbind(
	\instrument, \osc1,
	//\degree, Pseq([0],inf),
	\ffreq, Pn(Pseries(100,100,10)),
	//\dur, 1,
	\amp, 0.1
//) <> ~node.pindex(Pseq([0,1, 0,0, 1,1],inf))
) <> ~node.vpattern
).play;
);

(
Pdef(\plop, Pbind(
	\instrument, \osc1,
	//\degree, Pseq([0],inf),
	\ffreq, Pn(Pseries(100,100,10)),
	//\dur, 1,
	\amp, 0.1
) <> Pseq([~node.pat(0,1), ~node.pat(1,1)],inf)
).play;
);


(
Pbind(
	\instrument, \osc1,
	\ffreq, 300,
	\amp, 0.1
).play;
)
~no = ~node.data[\noteline].get_scoreset.get_sheet(0).get_rel_notes.postln
~no

(
	
		DebugPbind(
			\noteline, Prout { 
				inf
					var notes = ~node.data[\noteline].get_scoreset.get_sheet(0).get_rel_notes.postln
			},
			\midinote, Pfunc{ arg ev; ev[\noteline][\midinote] },
			\sustain, Pfunc{ arg ev; ev[\noteline][\sustain] },
			\dur, Pfunc{ arg ev; ev[\noteline][\dur] },
		).trace.play
)

(
	
	var node = ~no;
		DebugPbind(
			\noteline, Prout { 
				Pseq(
					//node
					//node.data[\noteline].get_scoreset.get_sheet(0).get_rel_notes.postln
					[(bla:3),(bla:4)]
				).
			},
		).trace.play
)



(
)t
	Pbind(
		\dur, 1,
		\degree, Pnsym(Pseq([\0,\1],inf),(0: 4, 1:6))

	).trace.play
)

Pindex
					~node.data[\noteline].get_scoreset.get_sheet(4).get_rel_notes;


throw "plop"
"plop".throw


Mdef.node_by_index(0).get_arg(\ffreqtab)



(
	
	~class_array_editor = (
		parent: ~class_param_array_controller,
		new: { arg self, spec, default_value=(1!10);
			spec = spec ?? \widefreq.asSpec;
			self = ~class_param_array_controller[\new].(self, \array_editor, default_value, spec);
		
			
		
			self;
		},

		edit: { arg self;
			var view = ~class_param_array_view.new(Mdef.main, self);
			view.make_window;
		},
	);
	~ae = ~class_array_editor.new;
)

~ae.edit

MIDIClient.init


(
	w = Window();
	m = PopUpMenu(w).focusColor_(Color.clear);
	w.front;

)
