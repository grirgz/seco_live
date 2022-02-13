
FileSystemProject.load("libdef/buttonselector.scd");
FileSystemProject.load("libdef/pmodenv.scd");
(
SynthDef(\fmop, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var opprefix = \op;
	var opcount = 4;
	var fbtab;
	var ope = { arg prefix, ifreq, intab;
		var isig;
		//SynthDesc(\fmop).addSpec((prefix+++\env), ParamEnvSpec.adsr);
		
		//ifreq = Select.kr(( prefix+++\freqmode ).kr(0), [ifreq, 1]);

		isig = LFSaw.ar( freq * (prefix+++\ratio).kr(1) + (prefix+++\offset).kr(0) * ( intab * (prefix+++\amptab).kr(0!opcount) + 1 ) );
		//isig.poll(label:prefix);
		isig = isig * EnvGen.kr((prefix+++\env).kr( Env.adsr(0.1,0.1,0.8,0.1) ), gate, timeScale:1);
		isig;
	};
	fbtab = LocalIn.ar(opcount);
	sig = opcount.collect({ arg opidx;
		var pre = opprefix+++opidx+++"_";
		ope.(pre, freq, fbtab)
	});
	LocalOut.ar(sig);
	sig = sig * opcount.collect({ arg opidx;
		var pre = opprefix+++opidx+++"_";
		(pre+++\amp).kr(1);
	});
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\fmop, 
	Pbind(
		\instrument, \fmop,
		\degree, Pseq([0,2,3,1],inf),
		\dur, 1/2,
	)
).play;
);
Pdef(\fmop).clear
Pdef(\fmop).envir.clear

(
WindowDef(\fmop, { arg def, pdef;
	var opcount = 4;
	var opprefix = \op;
	var butsel;
	var ratio_knob, offset_knob, amp_knob;
	var fb_mslider, fb_text;
	var opadsr_env, opadsr_text;
	var lay;
	var makeKnob;

	butsel = ProtoDef(\ButtonSelector).new({ arg selector, idx;
		var pre = opprefix +++ idx +++ "_";

		ratio_knob.mapParam( Param(pdef, pre+++\ratio, ControlSpec(1/4,4,\lin)) );
		offset_knob.mapParam( Param(pdef, pre+++\offset, \widefreq) );
		amp_knob.mapParam( Param(pdef, pre+++\amp, ControlSpec(0,1,\lin)) );

		fb_mslider.mapParam( Param(pdef, pre+++\amptab, ParamArraySpec(ControlSpec(0,2,\lin))) );
		fb_text.mapParam( Param(pdef, pre+++\amptab, ParamArraySpec(ControlSpec(0,2,\lin))) );
		opadsr_env.mapParam( Param(pdef, pre+++\env, ParamEnvSpec.adsr) );
		opadsr_text.mapParam( Param(pdef, pre+++\env, ParamEnvSpec.adsr) );
	});

	makeKnob = { 
		var label = StaticText.new, knob = Knob.new, field = TextField.new;
		VLayout (
			label,
			knob,
			field,
		).addUniqueMethod(\mapParam, { arg view, param;
			label.mapParamLabel(param).align_(\center);
			knob.mapParam(param);
			field.mapParam(param).maxWidth_(80);
		})
	};

	lay = HLayout (
		VLayout (
			* opcount.collect({ arg idx; 
				butsel.makeButton.string_("op %".format(idx)) 
			}) ++ [nil]
		),
		VLayout(
			HLayout (
				PlayerWrapper(pdef),
				Param(pdef, \amp).asSlider.orientation_(\horizontal).maxWidth_(200)
			),
			HLayout (
				VLayout (
					HLayout (
						ratio_knob = makeKnob.(),
						offset_knob = makeKnob.(),
						amp_knob = makeKnob.(),
						nil,
					),
					VLayout (
						opadsr_env = FixedEnvelopeView.new,
						opadsr_text = TextField.new,
					)
				),
				VLayout (
					VLayout (
						fb_mslider = MultiSliderView.new.elasticMode_(1).isFilled_(true).showIndex_(true).indexThumbSize_(1000),
						fb_text = TextField.new,
					),
					VLayout (
						Param(pdef, \adsr).asEnvelopeView,
						Param(pdef, \adsr).asTextField,
					),
				),
			)
		)
	);

	butsel.selectButton(0);
	lay;
	
}).front(Pdef(\fmop));
)

Param(Pdef(\fmop), \op1)
Pdef(\fmop).setModel((edit:{WindowDef(\fmop).front(Pdef(\fmop))}))
Pdef(\fmop).edit
Pdef(\fmop).asParamGroup.getPbindCompileString.editorInsert

(
	Pdef(\fmop, 
		Pbind(
			\instrument, \fmop,
			\degree, Pseq([0],inf),
			\dur, 1,
			\amp, 0.1,
			'op0_amp', ~pmodenv.(Pseq([0,2,0,4],inf), 1/4),
		).trace
		<>
		Pbind(
			'dur', 1.0,
			'legato', 0.8,
			'out', 0,
			'amp', 0.23132703258591,
			'pan', 0.0,
			'freq', 261.6255653006,
			'op0_freqmode', 1.0,
			'op0_freq', 200.20887,
			'op0_amptab', [ [ 0.0, 0.0, 0.0, 0.0 ] ],
			'op0_env', [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.32, 0.16, 0.16 ], [ -4, -4, -4 ], 2) ],
			'op1_freqmode', 0.0,
			'op1_freq', 2,
			'op1_amptab', [ [ 0.0, 0.0, 0.0, 0.0 ] ],
			'op1_env', [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.0, 0.24, 0.88 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			'op2_freqmode', 0.0,
			'op2_freq', 1.25,
			'op2_amptab', [ [ 0.38999998569489, 0.37000000476837, 0.36000001430511, 0.37000000476837 ] ],
			'op2_env', [ Env([ 0, 1, 0.8, 0 ], [ 0.9, 0.24, 0.08 ], [ -4, -4, -4 ], 2) ],
			'op3_freqmode', 0.0,
			'op3_freq', 1,
			'op3_amptab', [ [ 0.75598084926605, 0.9856458902359, 0.64114832878113, 0.0 ] ],
			'op3_env', [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.0, 0.24, 0.08 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			'op0_amp', 0.0,
			'op1_amp', 0.0,
			'op2_amp', 0.0,
			'op3_amp', 1.0,
			'adsr', [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0, 0.20000000298023, 0.061711743474007 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
		)
	).play;
);



/////////////////////////////////////////////////////
//// advanced

(
FileSystemProject.load("libdef/buttonselector.scd");
FileSystemProject.load("libdef/pmodenv.scd");
WavetableDef.addPath("/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/");
WavetableDef(\sin, "Classic - Sine/Sine.wav");
WavetableDef(\square, "Classic - Square/Square1.wav");
WavetableDef(\triangle, "Classic - Triangle/Triangle Up.wav");
WavetableDef(\triangle_down, "Classic - Triangle/Triangle Down.wav");
WavetableDef(\saw, "Classic - Saw/Saw Up.wav");
WavetableDef(\saw_down, "Classic - Saw/Saw Down.wav");
);

(
SynthDef(\fmop, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var opprefix = \op;
	var opcount = 6;
	var modcount = opcount+2;
	var fbtab;
	var amptabval;
	var sigfilt, signoise;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var modfactor = 1/30;
	var cutoff;
	var makeEnv = { arg name;
		EnvGen.kr(name.kr( Env.adsr(0.1,0.1,0.8,0.1) ), gate, timeScale:1);
	};
	var ope = { arg prefix, ifreq, intab;
		var isig;
		isig = Osc.ar(( prefix+++\wavetable ).kr(0), freq * (prefix+++\ratio).kr(1) + (prefix+++\offset).kr(0) * ( ( intab * (prefix+++\modamptab).kr(0!modcount) * modfactor ).sum + 1 ) );
		isig = isig * EnvGen.kr((prefix+++\env).kr( Env.adsr(0.1,0.1,0.8,0.1) ), gate, timeScale:1);
		isig;
	};
	fbtab = LocalIn.ar(modcount);
	sig = opcount.collect({ arg opidx;
		var pre = opprefix+++opidx+++"_";
		ope.(pre, freq, fbtab)
	});

	//// noise + saturator
	sig4 = RLPF.ar(WhiteNoise.ar( \noise_amp.kr(0) ) , \noise_cutoff.kr(1000), \noise_res.kr(0.5)) + (fbtab * \noise_modamptab.kr(0!modcount) * modfactor).sum;
	signoise = ( sig4 * \dist_gain.kr(1) ).clip(* \dist_level.kr(1) * [-1 + \dist_asym.kr(0),1]);
	signoise = signoise * makeEnv.(\noise_env);



	//// filter

	sig3 = (fbtab * \filter_modamptab.kr(0!modcount) * modfactor).sum;
	cutoff = \filter_cutoff.kr(1) * freq * ( makeEnv.(\filter_env) * \filter_envamt.kr(1) * 16 + 1 );
	cutoff = cutoff.clip(20,19990);
	sig1 = DFM1.ar(sig3, cutoff, \filter_res1.kr(0.5), 1 - \filter_type1.kr(0));
	sig2 = DFM1.ar(SelectX.ar(\filter_seq.kr, [sig3, sig1]), cutoff * ( \filter_spread.kr(0) + 1 ), \filter_res2.kr(0.5), 1 - \filter_type2.kr(0));
	sig2 = SelectX.ar(\filter_seq.kr, [sig1 + sig2, sig2 ]);
	// when first filter is selected, seq/par is irrelevant
	sigfilt = SelectX.ar(\filter_mix.kr(0), [sig1, sig2]);

	sig = sig ++ [
		signoise,
		sigfilt,

	];

	LocalOut.ar(sig);
	amptabval = 0!modcount;
	amptabval[0] = 1;
	sig = sig * \amptab.kr(amptabval);
	sig = Pan2.ar(sig, pan + \pantab.kr(0!modcount), amp);
	sig = sig.mean;
	sig.debug("sig");
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\fmop, 
	Pbind(
		\instrument, \fmop,
		\degree, Pseq([0,2,3,1],inf),
		\dur, 1/2,
		\dur, 2,
	)
).play;
);

////////////// gui


(
WindowDef(\opmatrix, { arg def, proxy;
	var opcount = 6;
	var modcount = opcount+2;
	var opprefix = \op;
	var nbwidth = 40;
	var modampspec = ParamArraySpec( ControlSpec(0,1,\lin,0,0)!modcount );
	VLayout(
		* opcount.collect { arg xidx;
			var key = "%%_modamptab".format(opprefix, xidx).asSymbol;
			HLayout (
				StaticText.new.string_("%".format(xidx)).fixedSize_(30),
				* Param(proxy, key, modampspec).collect({ arg param, yidx;
					VLayout (
						param.asNumberBox.step_(0.1).scroll_step_(0.1).shift_scale_(0.1)
							.maxWidth_(nbwidth)
							.background_(if(xidx == yidx) { Color.grey } { Color.white }),
						//param.asKnob,
					)
				}) 
			)
		} ++ [
			HLayout (
				StaticText.new.string_("noi").fixedSize_(30),
				*Param(proxy, \noise_modamptab, modampspec).collect{ arg param, yidx;
					param.asNumberBox.step_(0.1).scroll_step_(0.1).shift_scale_(0.1)
							.maxWidth_(nbwidth)
							.background_(if(opcount == yidx) { Color.grey } { Color.white });
				}
			),
			HLayout (
				StaticText.new.string_("fil").fixedSize_(30),
				*Param(proxy, \filter_modamptab, modampspec).collect{ arg param, yidx;
					param.asNumberBox.step_(0.1).scroll_step_(0.1).shift_scale_(0.1)
							.maxWidth_(nbwidth)
							.background_(if(opcount+1 == yidx) { Color.grey } { Color.white });
				}
			),
			HLayout (
				StaticText.new.string_("pan").fixedSize_(30),
				*Param(proxy, \pantab, ParamArraySpec( \pan!modcount )).collect{ arg param;
					param.asNumberBox.step_(0.1).scroll_step_(0.1).shift_scale_(0.1)
							.maxWidth_(nbwidth)
				}
			),
			HLayout (
				StaticText.new.string_("amp").fixedSize_(30),
				*Param(proxy, \amptab, ParamArraySpec( \amp!modcount )).collect{ arg param;
					param.asNumberBox.step_(0.1).scroll_step_(0.1).shift_scale_(0.1)
							.maxWidth_(nbwidth);
				}
			),
			nil
		];
	)
});
);


(
	WindowDef(\fmop_adv, (
		makeOpLayout: { arg self, idx;
			var proxy = self.proxy;
			var pre = self.opprefix +++ idx +++ "_";
			var modampspec = self.modampspec;
			ParamGroup([

				Param(proxy, \amptab, ParamArraySpec( ControlSpec(0,1,\lin,0,0)!self.modcount )).at(idx),
				Param(proxy, pre+++\wavetable, TagSpecDef(\WavetableDef_object)),
				Param(proxy, pre+++\ratio, ControlSpec(1/4,4,\lin)),
				Param(proxy, pre+++\offset, \widefreq),

				Param(proxy, pre+++\modamptab, modampspec),
				Param(proxy, pre+++\env, ParamEnvSpec.adsr),
			]).asView;
		},
		makeNoiseLayout: { arg self;
			var proxy = self.proxy;
			var modampspec = ParamArraySpec( ControlSpec(0,1,\lin,0,0)!self.modcount );
			var pgroup = ParamGroup([

				Param(proxy, \amptab, ParamArraySpec( ControlSpec(0,1,\lin,0,0)!self.modcount )).at(self.opcount),
				Param(proxy, \noise_cutoff, \freq),
				Param(proxy, \noise_amp, \amp),
				Param(proxy, \noise_res, \amp),

				Param(proxy, \dist_gain, ControlSpec(0,4,\lin,0,1)),
				Param(proxy, \dist_level, \unipolar),
				Param(proxy, \dist_asym, \unipolar),

				Param(proxy, \noise_modamptab, modampspec),
				Param(proxy, \noise_env, ParamEnvSpec.adsr),
			]);
			VLayout (
				*pgroup.collect { arg item, idx;
					ParamGroupLayout.formEntry(item)
				};
			);
		},
		makeFilterLayout: { arg self;
			var proxy = self.proxy;
			var modampspec = self.modampspec;
			var pgroup = ParamGroup([

				Param(proxy, \amptab, ParamArraySpec( ControlSpec(0,1,\lin,0,0)!self.modcount )).at(self.opcount+1),
				Param(proxy, \filter_cutoff, ControlSpec(0,4,\lin)),
				Param(proxy, \filter_spread, \unipolar),
				Param(proxy, \filter_res1, \amp),
				Param(proxy, \filter_type1, \unipolar),
				Param(proxy, \filter_res2, \amp),
				Param(proxy, \filter_type2, \unipolar),
				Param(proxy, \filter_mix, \unipolar),
				Param(proxy, \filter_seq, \unipolar),

				Param(proxy, \filter_modamptab, modampspec),
				Param(proxy, \filter_env, ParamEnvSpec.adsr),
				Param(proxy, \filter_envamt, \bipolar),
			]);
			VLayout (
				*pgroup.collect { arg item, idx;
					ParamGroupLayout.formEntry(item)
				};
			);
		},
		makeMasterLayout: { arg self;
			var proxy = self.proxy;
			var modampspec = self.modampspec;
			var pgroup = ParamGroup([

				Param(proxy, \amp),

				Param(proxy, \adsr),
				//Param(proxy, pre+++\env, ParamEnvSpec.adsr),
			]);
			VLayout (
				*pgroup.collect { arg item, idx;
					ParamGroupLayout.formEntry(item)
				};
			);
		},
		asView: { arg self, def, proxy;
			var opcount = 6;
			var opprefix = \op;
			var butsel;
			var ratio_knob, offset_knob, amp_knob;
			var fb_mslider, fb_text;
			var opadsr_env, opadsr_text;
			var lay;
			var makeKnob;
			var wavepopup = PopUpMenu.new;
			var layout_selector;
			var editor_view = View.new;
			var matrix_view = WindowDef(\opmatrix).asView(proxy);

			self.proxy = proxy;
			self.opprefix = opprefix;
			self.opcount = opcount;
			self.modcount = opcount + 2;
			self.modampspec = ParamArraySpec( ControlSpec(0,1,\lin,0,0)!self.modcount );

			butsel = ProtoDef(\ButtonSelector).new({ arg selector, idx;
				var pre = opprefix +++ idx +++ "_";

				editor_view.removeAll;
				case(
					{ idx < opcount }, {
						editor_view.layout = self.makeOpLayout(idx);
					},
					{ idx == opcount }, {
						editor_view.layout = self.makeNoiseLayout;
					},
					{ idx == ( opcount+1 ) }, {
						editor_view.layout = self.makeFilterLayout;
					},
					{ idx == ( opcount+2 ) }, {
						editor_view.layout = self.makeMasterLayout;
					}, {
						
					}
				);

			});

			layout_selector = VLayout (
				* ( opcount.collect({ arg idx; 
					butsel.makeButton.string_("op %".format(idx)).minWidth_(30) 
				}) ++ [
					butsel.makeButton.string_("noise").minWidth_(40),
					butsel.makeButton.string_("filter").minWidth_(40),
				] ).clump(2).collect({ arg pair;
					HLayout (
						*pair
					)
				}) ++ [
					butsel.makeButton.string_("master"),
					nil
				]
			);
			lay = VLayout(
				
				HLayout(
					PlayerWrapper(proxy),
				),
				HLayout (

					layout_selector,
					[ editor_view, stretch:10 ],
					[matrix_view, stretch:0],
				),
			);
			butsel.selectButton(0);
			lay;

		},
		
	)).front(Pdef(\fmop));
);

///////// controller

~initialize_jack.();
FileSystemProject.load("libdef/piano.scd")
ProtoDef(\piano).startControl(Pdef(\fmop))


NumberBox
Param(Pdef(\fmop), \amptab, ParamArraySpec( \amp!8 )).size
Param(Pdef(\fmop), \amptab, ParamArraySpec( \amp!8 )).unset

Pdef(\fmop).clear
Pdef(\fmop).envir.clear




(
)
WavetableDef(\parabol, "Classic - Saw/Saw Up.wav");
WavetableDef(\saw_negative_down, "Classic - Saw/Saw Negative Down.wav");


//////////
(
	// old
WindowDef(\fmop, { arg def, pdef;
	var opcount = 6;
	var opprefix = \op;
	var butsel;
	var ratio_knob, offset_knob, amp_knob;
	var fb_mslider, fb_text;
	var opadsr_env, opadsr_text;
	var lay;
	var makeKnob;
	var wavepopup = PopUpMenu.new;

	butsel = ProtoDef(\ButtonSelector).new({ arg selector, idx;
		var pre = opprefix +++ idx +++ "_";

		ratio_knob.mapParam( Param(pdef, pre+++\ratio, ControlSpec(1/4,4,\lin)) );
		offset_knob.mapParam( Param(pdef, pre+++\offset, \widefreq) );
		amp_knob.mapParam( Param(pdef, \amptab, ParamArraySpec(ControlSpec(0,1,\lin))).at(idx) );

		fb_mslider.mapParam( Param(pdef, pre+++\modamptab, ParamArraySpec(ControlSpec(0,2,\lin))) );
		fb_text.mapParam( Param(pdef, pre+++\modamptab, ParamArraySpec(ControlSpec(0,2,\lin))) );
		opadsr_env.mapParam( Param(pdef, pre+++\env, ParamEnvSpec.adsr) );
		opadsr_text.mapParam( Param(pdef, pre+++\env, ParamEnvSpec.adsr) );
		wavepopup.mapParam( Param(pdef, pre+++\wavetable, TagSpecDef(\WavetableDef)) );
	});

	makeKnob = { 
		var label = StaticText.new, knob = Knob.new, field = TextField.new;
		VLayout (
			label,
			knob,
			field,
		).addUniqueMethod(\mapParam, { arg view, param;
			label.mapParamLabel(param).align_(\center);
			knob.mapParam(param);
			field.mapParam(param).maxWidth_(80);
		})
	};

	lay = HLayout (
		VLayout (
			* opcount.collect({ arg idx; 
				butsel.makeButton.string_("op %".format(idx)) 
			}) ++ [nil]
		),
		VLayout(
			HLayout (
				PlayerWrapper(pdef),
				Param(pdef, \amp).asSlider.orientation_(\horizontal).maxWidth_(200)
			),
			HLayout (
				VLayout (
					wavepopup,
					HLayout (
						ratio_knob = makeKnob.(),
						offset_knob = makeKnob.(),
						amp_knob = makeKnob.(),
						nil,
					),
					VLayout (
						opadsr_env = FixedEnvelopeView.new,
						opadsr_text = TextField.new,
					)
				),
				VLayout (
					VLayout (
						fb_mslider = MultiSliderView.new.elasticMode_(1).isFilled_(true).showIndex_(true).indexThumbSize_(1000),
						fb_text = TextField.new,
					),
					VLayout (
						Param(pdef, \adsr).asEnvelopeView,
						Param(pdef, \adsr).asTextField,
					),
				),
			)
		),
		WindowDef(\opmatrix).asView(pdef),
	);

	butsel.selectButton(0);
	lay;
	
}).front(Pdef(\fmop));
)


Pdef(\fmop).get(\op0_wavetable)
WavetableDef(\saw_down).plotWavetable



/////////////////////////////////////////////////////// wavetable tests

WavetableDef	

WavetableDef.addPath("/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/");

WavetableDef(\saw2, "Classic - Saw/Cos Saw.wav");
WavetableDef(\saw, "/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Saw/Cos Saw.wav");
WavetableDef(\sin, "/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine.wav");
WavetableDef(\sinpower2, "/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine Power2.wav");

"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/*/*.wav".pathMatch.size
(
"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/*/*.wav".pathMatch.collect { arg item, idx;
	WavetableDef(PathName(item).fileName.asSymbol, item)
};
)

(
"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Saw Filtered/Band*.wav".pathMatch.collect { arg item, idx;
	WavetableDef(PathName(item).fileName.asSymbol, item)
};
)


1/( 2048/s.sampleRate ) * 32 * 2
1/( 2048/s.sampleRate ) * 16
1/( 88000/s.sampleRate )

WavetableDef(\saw16, Wavetable.sineFill(2048, (1..16).reciprocal));
WavetableDef(\saw16)
WavetableDef.all[\saw16].numFrames
Wavetable.sineFill(2048, (1..16).reciprocal).size
~sawwt = Wavetable.sineFill(2048, (1..16).reciprocal)
~sawwt.size
~sawwt.numChannels
~sawbuf = Buffer.alloc(s, 4096, 1)
~sawbuf.loadCollection(~sawwt)
WavetableDef(\saw16, "~/Musique/sc/wavetable/saw16.wav".standardizePath)
WavetableDef.all
~fsawbuf = Buffer.alloc(s, 2048, 1)
~sig = Signal.sineFill(2048, (1..16).reciprocal)
~fsawbuf.loadCollection(~sig)
~fsawbuf.write("~/Musique/sc/wavetable/saw16.wav".standardizePath)



///////////////////////////////////////////////////////

Pdef(\fmop).asParamGroup.getSetCompileString.editorInsert
(
	// this is FM8 "08-15" patch
Pdef('fmop').set('dur', 1.0);
Pdef('fmop').set('legato', 0.8);
Pdef('fmop').set('out', 0);
Pdef('fmop').set('amp', 4);
Pdef('fmop').set('pan', 0.0);
Pdef('fmop').set('op0_wavetable', WavetableDef('sin'));
Pdef('fmop').set('op0_ratio', 0);
Pdef('fmop').set('op0_offset', 1.5);
Pdef('fmop').set('op0_modamptab', [ [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ] ]);
Pdef('fmop').set('op0_env', Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.0, 0.10669862478971, 0.86124438792467 ], [ -4, -4, 1.4 ], 2));
Pdef('fmop').set('op1_wavetable', WavetableDef('saw'));
Pdef('fmop').set('op1_ratio', 1.0005);
Pdef('fmop').set('op1_offset', 0.0);
Pdef('fmop').set('op1_modamptab', [ [ 0.3, 0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ] ]);
Pdef('fmop').set('op1_env', Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.608020991414, 0.05012672596367, 0.78345598262233 ], [ -4, -4, -1.1 ], 2));
Pdef('fmop').set('op2_wavetable', WavetableDef('sin'));
Pdef('fmop').set('op2_ratio', 0);
Pdef('fmop').set('op2_offset', 1.03);
Pdef('fmop').set('op2_modamptab', [ [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ] ]);
Pdef('fmop').set('op2_env', Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.0, 0.21196174710989, 0.82861258298159 ], [ -4.0, -4.0, 0.7 ], 2.0));
Pdef('fmop').set('op3_wavetable', WavetableDef('saw'));
Pdef('fmop').set('op3_ratio', 0.9997);
Pdef('fmop').set('op3_offset', 0.0);
Pdef('fmop').set('op3_modamptab', [ [ 0.0, 0.0, 0.3, 0.4, 0.0, 0.0, 0.0, 0.0 ] ]);
Pdef('fmop').set('op3_env', Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.71000001847744, 0.096196178197861, 0.7838038033247 ], [ -4, -4, -1.2 ], 2));
Pdef('fmop').set('op4_wavetable', WavetableDef('sin'));
Pdef('fmop').set('op4_ratio', 0);
Pdef('fmop').set('op4_offset', 2.06);
Pdef('fmop').set('op4_modamptab', [ [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ] ]);
Pdef('fmop').set('op4_env', Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.0, 0.14736799895763, 0.78526319563389 ], [ -4, -4, 1.0 ], 2));
Pdef('fmop').set('op5_wavetable', WavetableDef('saw'));
Pdef('fmop').set('op5_ratio', 1.0);
Pdef('fmop').set('op5_offset', 0.0);
Pdef('fmop').set('op5_modamptab', [ [ 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.0, 0.0 ] ]);
Pdef('fmop').set('op5_env', Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.70000000393371, 0.1071770124207, 0.79282288364559 ], [ -0.4, -4, -1.1 ], 2));
Pdef('fmop').set('noise_amp', 0.0);
Pdef('fmop').set('noise_cutoff', 650.31948984895);
Pdef('fmop').set('noise_res', 0.13169875130073);
Pdef('fmop').set('noise_modamptab', [ [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ] ]);
Pdef('fmop').set('dist_gain', 4.0);
Pdef('fmop').set('dist_level', 0.57661290322581);
Pdef('fmop').set('dist_asym', 0.72983870967742);
Pdef('fmop').set('noise_env', nil);
Pdef('fmop').set('filter_modamptab', [ [ 0.0, 0.9, 0.0, 0.9, 0.0, 0.9, 0.0, 0.0 ] ]);
Pdef('fmop').set('filter_cutoff', 1.0322580645161);
Pdef('fmop').set('filter_env', Env([ 0, 0.4, 0.23, 0 ], [ 1.6, 2.28, 2.29 ], [ 0.5, -6.1, -4 ], 2));
Pdef('fmop').set('filter_envamt', 0.45967741935484);
Pdef('fmop').set('filter_res1', 0.89028355879292);
Pdef('fmop').set('filter_type1', 0.0);
Pdef('fmop').set('filter_seq', 1.0);
Pdef('fmop').set('filter_spread', 0.125);
Pdef('fmop').set('filter_res2', 0.12591050988554);
Pdef('fmop').set('filter_type2', 0.0);
Pdef('fmop').set('filter_mix', 0.0);
Pdef('fmop').set('amptab', [ [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0 ] ]);
Pdef('fmop').set('pantab', [ [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ] ]);
Pdef('fmop').set('adsr', Env([ 0, 1, 1, 0 ], [ 0, 0.28134, 0.866 ], [ -4, -4, 0.1 ], 2));

);




Pdef(\fmop).asParamGroup.getPresetCompileString.editorInsert

(
	// this is FM8 "08-15" patch
ParamGroup([
	Param(Pdef('fmop'), 'dur'),
	Param(Pdef('fmop'), 'legato'),
	Param(Pdef('fmop'), 'out'),
	Param(Pdef('fmop'), 'amp'),
	Param(Pdef('fmop'), 'pan'),
	Param(Pdef('fmop'), 'freq'),
	Param(Pdef('fmop'), 'op0_wavetable'),
	Param(Pdef('fmop'), 'op0_ratio'),
	Param(Pdef('fmop'), 'op0_offset'),
	Param(Pdef('fmop'), 'op0_modamptab'),
	Param(Pdef('fmop'), 'op0_env'),
	Param(Pdef('fmop'), 'op1_wavetable'),
	Param(Pdef('fmop'), 'op1_ratio'),
	Param(Pdef('fmop'), 'op1_offset'),
	Param(Pdef('fmop'), 'op1_modamptab'),
	Param(Pdef('fmop'), 'op1_env'),
	Param(Pdef('fmop'), 'op2_wavetable'),
	Param(Pdef('fmop'), 'op2_ratio'),
	Param(Pdef('fmop'), 'op2_offset'),
	Param(Pdef('fmop'), 'op2_modamptab'),
	Param(Pdef('fmop'), 'op2_env'),
	Param(Pdef('fmop'), 'op3_wavetable'),
	Param(Pdef('fmop'), 'op3_ratio'),
	Param(Pdef('fmop'), 'op3_offset'),
	Param(Pdef('fmop'), 'op3_modamptab'),
	Param(Pdef('fmop'), 'op3_env'),
	Param(Pdef('fmop'), 'op4_wavetable'),
	Param(Pdef('fmop'), 'op4_ratio'),
	Param(Pdef('fmop'), 'op4_offset'),
	Param(Pdef('fmop'), 'op4_modamptab'),
	Param(Pdef('fmop'), 'op4_env'),
	Param(Pdef('fmop'), 'op5_wavetable'),
	Param(Pdef('fmop'), 'op5_ratio'),
	Param(Pdef('fmop'), 'op5_offset'),
	Param(Pdef('fmop'), 'op5_modamptab'),
	Param(Pdef('fmop'), 'op5_env'),
	Param(Pdef('fmop'), 'noise_amp'),
	Param(Pdef('fmop'), 'noise_cutoff'),
	Param(Pdef('fmop'), 'noise_res'),
	Param(Pdef('fmop'), 'noise_modamptab'),
	Param(Pdef('fmop'), 'dist_gain'),
	Param(Pdef('fmop'), 'dist_level'),
	Param(Pdef('fmop'), 'dist_asym'),
	Param(Pdef('fmop'), 'noise_env'),
	Param(Pdef('fmop'), 'filter_modamptab'),
	Param(Pdef('fmop'), 'filter_cutoff'),
	Param(Pdef('fmop'), 'filter_env'),
	Param(Pdef('fmop'), 'filter_envamt'),
	Param(Pdef('fmop'), 'filter_res1'),
	Param(Pdef('fmop'), 'filter_type1'),
	Param(Pdef('fmop'), 'filter_seq'),
	Param(Pdef('fmop'), 'filter_spread'),
	Param(Pdef('fmop'), 'filter_res2'),
	Param(Pdef('fmop'), 'filter_type2'),
	Param(Pdef('fmop'), 'filter_mix'),
	Param(Pdef('fmop'), 'amptab'),
	Param(Pdef('fmop'), 'pantab'),
	Param(Pdef('fmop'), 'adsr')
]).presets_(IdentityDictionary[
	'current' -> [ 1.0, 0.8, 0, 4, 0.0, 261.6255653006, WavetableDef('sin'), 0, 1.5, [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ], Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.0, 0.10669862478971, 0.86124438792467 ], [ -4, -4, 1.4 ], 2), WavetableDef('saw'), 1.0005, 0.0, [ 0.3, 0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ], Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.608020991414, 0.05012672596367, 0.78345598262233 ], [ -4, -4, -1.1 ], 2), WavetableDef('sin'), 0, 1.03, [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ], Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.0, 0.21196174710989, 0.82861258298159 ], [ -4.0, -4.0, 0.7 ], 2.0), WavetableDef('saw'), 0.9997, 0.0, [ 0.0, 0.0, 0.3, 0.4, 0.0, 0.0, 0.0, 0.0 ], Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.71000001847744, 0.096196178197861, 0.7838038033247 ], [ -4, -4, -1.2 ], 2), WavetableDef('sin'), 0, 2.06, [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ], Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.0, 0.14736799895763, 0.78526319563389 ], [ -4, -4, 1.0 ], 2), WavetableDef('saw'), 1.0, 0.0, [ 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.0, 0.0 ], Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.70000000393371, 0.1071770124207, 0.79282288364559 ], [ -0.4, -4, -1.1 ], 2), 0.0, 650.31948984895, 0.13169875130073, [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ], 4.0, 0.57661290322581, 0.72983870967742, [ 0.0, 3.0, 2.0, -99.0, 1.0, 0.10000000149012, 5.0, -4.0, 0.80000001192093, 0.10000000149012, 5.0, -4.0, 0.0, 0.10000000149012, 5.0, -4.0 ], [ 0.0, 0.9, 0.0, 0.9, 0.0, 0.9, 0.0, 0.0 ], 1.0322580645161, Env([ 0, 0.4, 0.23, 0 ], [ 1.6, 2.28, 2.29 ], [ 0.5, -6.1, -4 ], 2), 0.45967741935484, 0.89028355879292, 0.0, 1.0, 0.125, 0.12591050988554, 0.0, 0.0, [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0 ], [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ], Env([ 0, 1, 1, 0 ], [ 0, 0.28134, 0.866 ], [ -4, -4, 0.1 ], 2) ]
]);

);

Pdef(\fmop).asParamGroup.getParamCompileString.editorInsert
(
	// this is FM8 "08-15" patch
Param(Pdef('fmop'), 'dur').set(1.0);
Param(Pdef('fmop'), 'legato').set(0.8);
Param(Pdef('fmop'), 'out').set(0);
Param(Pdef('fmop'), 'amp').set(4);
Param(Pdef('fmop'), 'pan').set(0.0);
Param(Pdef('fmop'), 'op0_wavetable').set(WavetableDef('sin'));
Param(Pdef('fmop'), 'op0_ratio').set(0);
Param(Pdef('fmop'), 'op0_offset').set(1.5);
Param(Pdef('fmop'), 'op0_modamptab').set([ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ]);
Param(Pdef('fmop'), 'op0_env').set(Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.0, 0.10669862478971, 0.86124438792467 ], [ -4, -4, 1.4 ], 2));
Param(Pdef('fmop'), 'op1_wavetable').set(WavetableDef('saw'));
Param(Pdef('fmop'), 'op1_ratio').set(1.0005);
Param(Pdef('fmop'), 'op1_offset').set(0.0);
Param(Pdef('fmop'), 'op1_modamptab').set([ 0.3, 0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ]);
Param(Pdef('fmop'), 'op1_env').set(Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.608020991414, 0.05012672596367, 0.78345598262233 ], [ -4, -4, -1.1 ], 2));
Param(Pdef('fmop'), 'op2_wavetable').set(WavetableDef('sin'));
Param(Pdef('fmop'), 'op2_ratio').set(0);
Param(Pdef('fmop'), 'op2_offset').set(1.03);
Param(Pdef('fmop'), 'op2_modamptab').set([ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ]);
Param(Pdef('fmop'), 'op2_env').set(Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.0, 0.21196174710989, 0.82861258298159 ], [ -4.0, -4.0, 0.7 ], 2.0));
Param(Pdef('fmop'), 'op3_wavetable').set(WavetableDef('saw'));
Param(Pdef('fmop'), 'op3_ratio').set(0.9997);
Param(Pdef('fmop'), 'op3_offset').set(0.0);
Param(Pdef('fmop'), 'op3_modamptab').set([ 0.0, 0.0, 0.3, 0.4, 0.0, 0.0, 0.0, 0.0 ]);
Param(Pdef('fmop'), 'op3_env').set(Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.71000001847744, 0.096196178197861, 0.7838038033247 ], [ -4, -4, -1.2 ], 2));
Param(Pdef('fmop'), 'op4_wavetable').set(WavetableDef('sin'));
Param(Pdef('fmop'), 'op4_ratio').set(0);
Param(Pdef('fmop'), 'op4_offset').set(2.06);
Param(Pdef('fmop'), 'op4_modamptab').set([ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ]);
Param(Pdef('fmop'), 'op4_env').set(Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.0, 0.14736799895763, 0.78526319563389 ], [ -4, -4, 1.0 ], 2));
Param(Pdef('fmop'), 'op5_wavetable').set(WavetableDef('saw'));
Param(Pdef('fmop'), 'op5_ratio').set(1.0);
Param(Pdef('fmop'), 'op5_offset').set(0.0);
Param(Pdef('fmop'), 'op5_modamptab').set([ 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.0, 0.0 ]);
Param(Pdef('fmop'), 'op5_env').set(Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.70000000393371, 0.1071770124207, 0.79282288364559 ], [ -0.4, -4, -1.1 ], 2));
Param(Pdef('fmop'), 'noise_amp').set(0.0);
Param(Pdef('fmop'), 'noise_cutoff').set(650.31948984895);
Param(Pdef('fmop'), 'noise_res').set(0.13169875130073);
Param(Pdef('fmop'), 'noise_modamptab').set([ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ]);
Param(Pdef('fmop'), 'dist_gain').set(4.0);
Param(Pdef('fmop'), 'dist_level').set(0.57661290322581);
Param(Pdef('fmop'), 'dist_asym').set(0.72983870967742);
Param(Pdef('fmop'), 'noise_env').set([ 0.0, 3.0, 2.0, -99.0, 1.0, 0.10000000149012, 5.0, -4.0, 0.80000001192093, 0.10000000149012, 5.0, -4.0, 0.0, 0.10000000149012, 5.0, -4.0 ]);
Param(Pdef('fmop'), 'filter_modamptab').set([ 0.0, 0.9, 0.0, 0.9, 0.0, 0.9, 0.0, 0.0 ]);
Param(Pdef('fmop'), 'filter_cutoff').set(1.0322580645161);
Param(Pdef('fmop'), 'filter_env').set(Env([ 0, 0.4, 0.23, 0 ], [ 1.6, 2.28, 2.29 ], [ 0.5, -6.1, -4 ], 2));
Param(Pdef('fmop'), 'filter_envamt').set(0.45967741935484);
Param(Pdef('fmop'), 'filter_res1').set(0.89028355879292);
Param(Pdef('fmop'), 'filter_type1').set(0.0);
Param(Pdef('fmop'), 'filter_seq').set(1.0);
Param(Pdef('fmop'), 'filter_spread').set(0.125);
Param(Pdef('fmop'), 'filter_res2').set(0.12591050988554);
Param(Pdef('fmop'), 'filter_type2').set(0.0);
Param(Pdef('fmop'), 'filter_mix').set(0.0);
Param(Pdef('fmop'), 'amptab').set([ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0 ]);
Param(Pdef('fmop'), 'pantab').set([ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ]);
Param(Pdef('fmop'), 'adsr').set(Env([ 0, 1, 1, 0 ], [ 0, 0.28134, 0.866 ], [ -4, -4, 0.1 ], 2));

);


