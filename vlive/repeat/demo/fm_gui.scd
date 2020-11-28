
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
