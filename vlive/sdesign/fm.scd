

(
SynthDef(\goto, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var fil1, fil2;
	sig1 = LFSaw.ar(freq) * EnvGen.kr(Env([0,1,0],[0.01,0.8]), 1);
	sig2 = LFPulse.ar(freq * 4/3 * ( sig1 * 1.4 + 1 )) * EnvGen.kr(Env([0,1,0,1],[0.01,0.1,1]), 1);
	sig3 = SinOsc.ar(freq * 1/2 * 1.0001 * ( sig2 * 0.1 + 1 )) * EnvGen.kr(Env([1,2,1],[0.01,4.1]), 1);
	sig4 = SinOsc.ar(freq * 0.9999 * ( sig3 * 0.1 +1 )) * EnvGen.kr(Env([0,2,1],[0.01,0.8]), 1);
	sig5 = SinOsc.ar(freq * 2 * ( sig4 * 0.2 +1 )) * EnvGen.kr(Env([0,0.1,0],[0.01,0.18]), 1);
	sig6 = SinOsc.ar(freq * 1 * 1.001 * ( sig5 * 0.2 +1 )) * EnvGen.kr(Env([0,1,0],[0.01,0.8]), 1);

	fil1 = RLPF.ar(sig2, freq * 2.1 * ( sig1 * 1.2 + 1 ));
	fil2 = RLPF.ar(sig1, freq * 2.1);
	sig = [ sig1 * 0.1, sig2*0.1, sig3*0.5, sig4, sig5,sig6, fil1, fil2 ];
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + [-0.1,0,0.1, 0,0, 0,0], amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \goto,
			\note, Pseq([
				0,3,1,-2,
			],inf),
			\octave,4,
			\dur, 1/4,
			\amp, 0.3,
		),
	])
)).play;
)


///////////////// GUI

Builder(\fm, { arg builder,  
	
})


(
SynthDef(\genfm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sigs;
	var size = 8;
	~specs = ();
	sigs = LocalIn.ar(size) * \fb.kr(1);
	size.do { arg idx;
		var modline = 0;
		size.do { arg cur;
			modline = modline + ( sigs[cur] * (\sig +++ idx +++ \mod +++ cur).kr(1) + 1 );
			~specs[(\sig +++ idx +++ \mod +++ cur)] = ControlSpec(0,4,\lin);
		};
		~specs[\freqratio+++idx] = ControlSpec(1/8,8,\lin);
		~specs[\freqdetune+++idx] = ControlSpec(-200,200,\lin);
		~specs[\env+++idx] = XEnvSpec.adsr();
		~specs[\pan+++idx] = \bipolar;
		~specs[\gain+++idx] = \unipolar;
		sigs[idx] = SinOsc.ar(freq * ( \freqratio+++idx ).kr(1) + ( \freqdetune+++idx ).kr(1) * modline) * EnvGen.kr(( \env+++idx ).kr( Env.adsr(0.1,0.1,0.8,0.1)), gate);
	};
	LocalOut.ar(sigs);
	sigs = sigs * size.collect({ arg idx; ( \gain+++idx ).kr(1) });
	sig = sigs;

	pan = pan + size.collect({ arg idx; ( \pan+++idx ).kr(0) });
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}, metadata:(specs:~specs)).add;
);

(
Pdef(\genfm, 
	Pbind(
		\instrument, \genfm,
		\freq, 50 * Pseq([
			0,3,9,-2,4,
		],inf).midiratio,
		\dur, 1/2,
			\dur, 1/4 * Pseq([1,2,4,1/2],inf),
	)
).play;
);

WindowDef(\PdefEditor).front(Pdef(\genfm))
Pdef(\genfm).envir.clear
~specs
Param(Pdef(\genfm), \env0, XEnvSpec.adsr()).edit

(
WindowDef(\genfm, { arg def, pdef;
	var size = 8;
	var paramdict = ();
	pdef.asParamGroup.do { arg param;
		paramdict[param.property] = param;
	};
	HLayout (
		VLayout (
			HLayout (
				PlayerWrapper(pdef).asView,
				paramdict[\freq].setBusMode.asKnob,
				paramdict[\amp].setBusMode.asKnob,
				nil,
			),
			GridLayout.columns(
				* 9.collect({ arg colidx;
					( [nil]++(0..7)++
						[
							"freqratio", 
							"freqdetune",
							"gain",
							"pan",
						]).collect({ arg rowval, rowidx;
						[colidx, rowidx, rowval].debug("col, row, val");
						if(colidx==0) {
								StaticText.new.string_(rowval ? "")
						} {
							if(rowidx==0) {
								StaticText.new.string_(colidx-1)
							} {
								if(rowidx < 9) {
									paramdict[(\sig +++ ( colidx-1 ) +++ \mod +++ ( rowidx-1 ))].setBusMode.asKnob
								} {
									if([ "freqratio", "freqdetune" ].includesEqual(rowval.dump)) {
										paramdict[(rowval.asSymbol +++ ( colidx-1 )).asSymbol.debug("syum")].asTextField
									} {
										paramdict[(rowval.asSymbol +++ ( colidx-1 )).asSymbol.debug("syum")].setBusMode.asKnob
									}
								}
							}
						}
					});
				})
			),
		),
		ScrollView.new.canvas_(View.new.layout_(VLayout(*
				[ VLayout (
					StaticText.new.string_(\adsr),
					paramdict[\adsr].asView,
					paramdict[\adsr].asTextField,
				) ] ++
			size.collect{ arg idx;
				VLayout (
					StaticText.new.string_(\env++idx),
					paramdict[\env+++idx].asView,
					paramdict[\env+++idx].asTextField,
				)
			}
		))).hasVerticalScroller_(true)
	);
	
}).front(Pdef(\genfm))
)

(
Pbindef(\genfm, \note, Pseq([
	0,3,7,-2,9,
],inf))
)
Pdef(\genfx).unset(\freq)
Pdef(\genfx).set(\freq, nil)
Pdef(\genfx).envir[\freq] = nil



///////////////// GUI 2 
// add preset, param value view, filter, module system where each column can be sin,square,pulse,lpf,rlpf,tanh,delay

Builder(\fm, { arg builder,  
	
})


(
	Builder(\genfm, { arg builder, modsel;

		~sd = SynthDef(builder.key, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
			var sig;
			var sigs;
			var size = 8;
			var modline = { arg idx;
				var modline = 0;
				size.do { arg cur;
					modline = modline + ( sigs[cur] * (\sig +++ idx +++ \mod +++ cur).debug("connerie").kr(0) );
					~specs[(\sig +++ idx +++ \mod +++ cur)] = ControlSpec(0,4,\lin);
				};
				modline+1;
			};
			var mkspecs = { arg idx;
				~specs[\freqratio+++idx] = ControlSpec(1/8,8,\lin);
				~specs[\freqdetune+++idx] = ControlSpec(-200,200,\lin);
				~specs[\env+++idx] = XEnvSpec.adsr();
				~specs[\pan+++idx] = \bipolar;
				~specs[\gain+++idx] = \unipolar;
			};
			var modules = (
				\sin: { arg idx;
					mkspecs.(idx);
					sigs[idx] = SinOsc.ar(freq * ( \freqratio+++idx ).kr(1) + ( \freqdetune+++idx ).kr(1) * modline.(idx)) * EnvGen.kr(( \env+++idx ).kr( Env.adsr(0.1,0.1,0.8,0.1)), gate);
				},
				\saw: { arg idx;
					mkspecs.(idx);
					sigs[idx] = LFSaw.ar(freq * ( \freqratio+++idx ).kr(1) + ( \freqdetune+++idx ).kr(1) * modline.(idx)) * EnvGen.kr(( \env+++idx ).kr( Env.adsr(0.1,0.1,0.8,0.1)), gate);
				},
				\pulse: { arg idx;
					mkspecs.(idx);
					sigs[idx] = LFPulse.ar(freq * ( \freqratio+++idx ).kr(1) + ( \freqdetune+++idx ).kr(1) * modline.(idx)) * EnvGen.kr(( \env+++idx ).kr( Env.adsr(0.1,0.1,0.8,0.1)), gate);
				},
				\cub: { arg idx;
					mkspecs.(idx);
					sigs[idx] = LFCub.ar(freq * ( \freqratio+++idx ).kr(1) + ( \freqdetune+++idx ).kr(1) * modline.(idx)) * EnvGen.kr(( \env+++idx ).kr( Env.adsr(0.1,0.1,0.8,0.1)), gate);
				},
				\lpf: { arg idx;
					mkspecs.(idx);
					sigs[idx] = LPF.ar(modline.(idx), freq * ( \freqratio+++idx ).kr(1) + ( \freqdetune+++idx ).kr(1)) * EnvGen.kr(( \env+++idx ).kr( Env.adsr(0.1,0.1,0.8,0.1)), gate);
				},
				\rlpf: { arg idx;
					mkspecs.(idx);
					sigs[idx] = RLPF.ar(modline.(idx), freq * ( \freqratio+++idx ).kr(1) + ( \freqdetune+++idx ).kr(1), ( \argA+++idx ).kr) * EnvGen.kr(( \env+++idx ).kr( Env.adsr(0.1,0.1,0.8,0.1)), gate);
				},
				\hpf: { arg idx;
					mkspecs.(idx);
					sigs[idx] = HPF.ar(modline.(idx), freq * ( \freqratio+++idx ).kr(1) + ( \freqdetune+++idx ).kr(1)) * EnvGen.kr(( \env+++idx ).kr( Env.adsr(0.1,0.1,0.8,0.1)), gate);
				},
				\rhpf: { arg idx;
					mkspecs.(idx);
					sigs[idx] = RHPF.ar(modline.(idx), freq * ( \freqratio+++idx ).kr(1) + ( \freqdetune+++idx ).kr(1), ( \argA+++idx ).kr) * EnvGen.kr(( \env+++idx ).kr( Env.adsr(0.1,0.1,0.8,0.1)), gate);
				},
				\delay: { arg idx;
					mkspecs.(idx);
					sigs[idx] = DelayL.ar(modline.(idx), 1,1/(freq * ( \freqratio+++idx ).kr(1) + ( \freqdetune+++idx ).kr(1))) * EnvGen.kr(( \env+++idx ).kr( Env.adsr(0.1,0.1,0.8,0.1)), gate);
				},
			);
			freq = freq * EnvGen.kr(\freqenv.kr(Env([1,1.002,0.998,1],[0.1,0.8])), 1);
			~specs = ();
			~specs[\freqenv] = XEnvSpec( ControlSpec(0,2,\lin) );
			sigs = LocalIn.ar(size) * \fb.kr(1);
			size.do { arg idx;
				"idx".debug(idx);
				( \argA+++idx ).kr;
				( \argB+++idx ).kr;
				builder.addSpec(\modsel+++idx, MenuSpec(modules.keys.asArray));
				( modules[builder.envir[\modsel+++idx].debug("whu") ? \sin] ? {"error".debug} ).(idx);
			};
			LocalOut.ar(sigs);
			sigs = sigs * size.collect({ arg idx; ( \gain+++idx ).kr(1) });
			sig = sigs;

			pan = pan + size.collect({ arg idx; ( \pan+++idx ).kr(0) });
			sig = Pan2.ar(sig, pan, amp).mean;
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
			Out.ar(out, sig);
		});
		"niark".debug("");
		~sd.metadata = (specs:~specs);
		~sd.add;
	});
Builder(\genfm).build;
Builder(\genfm2,Builder(\genfm).source).build;
);

Builder(\genfm).set(\modsel, [\osc, \lpf])
Builder(\genfm).set(\modsel, [\lpf, \lpf])
Builder(\genfm).asParamGroup
Param(Builder(\genfm), \modsel0).get
8.do  { arg idx; Param(Builder(\genfm), \modsel+++idx).set(\sin) }

								Param(Builder(\genfm), \modsel).at(0).asPopUpMenu
								Param(Builder(\genfm), \modsel).at(0)
(
Pdef(\genfm, 
	Pbind(
		\instrument, \genfm,
		\freq, 400 * ( Pseq([
			-7,
			0,3,-5,8,-2,-4,
		],inf).stutter(4) + Pseq([-1,0,1],inf) ).midiratio,
 		\dur, 1/4,
		\out, BusDef(\fx1, \audio),
	)
).play;
);

(
Pdef(\bell,Pdef(\genfm2, 
	Pbind(
		\instrument, \genfm2,
		\freq, 200 * Pseq([
			-7,
			0,3,-5,8,-2,-4,
		],inf).midiratio,
		\dur, 1,
		\out, BusDef(\fx1, \audio),
			//\dur, 1/4 * Pseq([1,2,4,1/2],inf),
	)
)).play;
);

ProtoDef(\rdn).edit

(
Pdef(\bell,Pdef(\fmbell, 
	Pbind(
		\instrument, \fmbell,
		\freq, 200 * Pseq([
			0,3,9,-2,4,
		],inf).midiratio,
		\amp, 0.1/2,
		\dur, 1,
			//\dur, 1/4 * Pseq([1,2,4,1/2],inf),
	)
)).play;
);

(
	ProtoDef(\rdn).play;
	Pdef(\part, Pdef(\main, 
		Ppar([
			Pdef(\genfm),
			Pdef(\genfm2),
		])
	)).play;
);
Pdef(\part).clear;

(
SynthDef(\fmbell, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * 2.6706 + 0.13) * \fmamp.kr(2) + 1; 
	sig2 = SinOsc.ar(freq * 0.9998 * sig1);
	sig3 = SinOsc.ar(freq * 2.6629 * sig1 + 2.04);
	sig4 = LFCub.ar(freq * 0.9991 * sig1 + 2.14);
	sig5 = SinOsc.ar(freq * 2.6656 * sig1 - 2);
	sig6 = SinOsc.ar(freq * 1 * sig1 + 1.84);
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar([0,0.5,0.5, 0.5,0.5,0.5]);
	//sig.debug("sig");
	//sig = sig /34;
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0,1,2.1,1,-1) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan + [ 0, -0.5, -0.5, 0.5, 0.5, 0], amp).sum;
	Out.ar(out, sig);
}).add;
)
WindowDef(\genfm2, WindowDef(\genfm)).front(Pdef(\genfm2), Builder(\genfm2))

WindowDef(\PdefEditor).front(Pdef(\genfm))
Pdef(\genfm).envir.clear
~specs
Param(Pdef(\genfm), \env0, XEnvSpec.adsr()).edit

(
WindowDef(\genfm, { arg def, pdef, builder;
	var size = 8;
	var paramdict = ();
	var curval = StaticText.new;
	var editcurval = TextField.new;
	curval.string = "---";
	curval.onChange(Param, \lastTweaked, { arg view; 
		"heyxxxxxxxxxxx".debug;
		view.string = "%:".format(Param.lastTweaked.asLabel);
		editcurval.mapParam(Param.lastTweaked);
	});
	pdef.asParamGroup.do { arg param;
		paramdict[param.property] = param;
	};
	paramdict.keys.asArray.sort.debug("paramdict keys");
	HLayout (
		VLayout (
			HLayout (
				PlayerWrapper(pdef).asView,
				paramdict[\freq].setBusMode.asKnob,
				paramdict[\amp].setBusMode.asKnob,
				nil,
				HLayout(
					curval,
					editcurval,
				),
			),
			GridLayout.columns(
				* 9.collect({ arg colidx;
					( [nil]++["module"]++(0..7)++
					[
						"freqratio", 
						"freqdetune",
						"argA",
						"argB",
						"gain",
						"pan",
					]).collect({ arg rowval, rowidx;
						[colidx, rowidx, rowval].debug("col, row, val");
						case(
							{ colidx==0 }, {
								StaticText.new.string_(rowval ? "")
							},
							{ rowidx==0 }, {
								StaticText.new.string_(colidx-1).align_(\center)
							},
							{ rowidx==1 }, {
								Param(builder, \modsel+++( colidx-1 )).asPopUpMenu
							},
							{ rowidx<10 }, {
								var knob;
								knob = paramdict[(\sig +++ ( colidx-1 ) +++ \mod +++ ( rowidx-2 ))].setBusMode.asKnob;
								if(( colidx-1 ) == ( rowidx-2 )) {
									knob.backColor = Color.gray;
								};
								knob;
							},
							{ [ "freqratio", "freqdetune" ].includesEqual(rowval) }, {
								paramdict[(rowval.asSymbol +++ ( colidx-1 )).asSymbol.debug("syum")].asTextField
							}, {
								paramdict[(rowval.asSymbol +++ ( colidx-1 )).asSymbol.debug("syum")].setBusMode.asKnob
							}
						)
					}).collect({ arg x; x.maxSize = 50@50 });
				}) ++ [ nil!12 ]
			),
		),
		ScrollView.new.canvas_(View.new.layout_(VLayout(*
				[ VLayout (
					StaticText.new.string_(\adsr),
					paramdict[\adsr].asView,
					paramdict[\adsr].asTextField,
					StaticText.new.string_(\freqenv),
					paramdict[\freqenv].asView,
					paramdict[\freqenv].asTextField,
				) ] ++
			size.collect{ arg idx;
				VLayout (
					StaticText.new.string_(\env++idx),
					paramdict[\env+++idx].asView,
					paramdict[\env+++idx].asTextField,
				)
			}
		))).hasVerticalScroller_(true),
	);
	
}).front(Pdef(\genfm), Builder(\genfm))
)

(
Pbindef(\genfm, \note, Pseq([
	0,3,7,-2,9,
],inf))
)
Pdef(\genfx).unset(\freq)
Pdef(\genfx).set(\freq, nil)
Pdef(\genfx).envir[\freq] = nil


/////////////////// store for control MOCKUP


ControlDef(\piano, { arg playergroup;
	k = MKtl('icon', "icon-icontrols");
	k[\kn][0].action = { playergroup[0].play };

});


ControlDef(\piano).connect(Pdef(\genfm))
