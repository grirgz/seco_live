
ParamProto.init;
(
( ParamProto.base_path +/+ "track.scd" ).load;
SynthDef(\kick, { arg out=0, amp=0.1, gate=1, pan=0, freq=70;
	var sig;
	var env1, env2;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.ar(\env1.kr(Env([600,65,60],[0.01,0.8], -4)), 1);
	env2 = EnvGen.ar(\env2.kr(Env([1,4,1],[0.001,0.1])), 1);
	
	sig = SinOsc.ar(env1);
	//sig = sig + Pulse.ar(env1/2);
	sig = sig + SinOsc.ar(env1);
	sig = sig + SinOsc.ar(env1, 0.3);
	sig = sig + SinOsc.ar(env1, 0.8);
	sig = 1.collect({ SinOsc.ar(env1, Rand(0, 2*pi )) }).mean;

	sig1 = sig;
	sig1 = sig1 + WhiteNoise.ar(1);
	sig2 = sig1;
	sig1 = LPF.ar(( sig1 * 10 ).tanh, \lpf.kr(300));
	sig1 = HPF.ar(( sig1 * 10 ).tanh, \hpf.kr(20));
	sig1 = sig1 + BPF.ar(sig2, 4500,0.4);
	sig = sig + sig1;
	sig = LPF.ar(sig, env2 * 42);
	sig = sig * EnvGen.ar( \ampenv.kr(Env([0,1,0],[0.001,0.7], -4)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	env1: XEnvSpec(\freq!3),
	env2: XEnvSpec(ControlSpec(0.01,10, \exp)!3),
	ampenv: XEnvSpec(ControlSpec(0.01,2, \exp)!3),
	duration: ControlSpec(0.001,4,\lin, 0, 1)
))).add;

SynthDef(\snare, { arg out=0, amp=0.1, gate=1, pan=0, freq=4700, doneAction=2;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([1000,4400,441],[0.01,0.3])), 1);
	env2 = EnvGen.kr(\env2.kr( Env([4310,440,1641],[0.01,0.1], -4) ), 1);
	env3 = EnvGen.kr(\env3.kr(Env([1,1.02,1],[0.4,0.13])), 1);
	env4 = EnvGen.kr(\env4.kr( Env([4310,440,1641],[0.01,0.1], -4) ), 1);
	sig = WhiteNoise.ar;
	sig = sig + LFNoise1.ar( 200 * env3 );
	//sig = sig + SinOsc.ar(freq);
	sig = Ringz.ar(sig, 
		\ringfreq.kr(
			Array.geom(8,80,1.022) +
			Array.series(8,70,3)
		),
		\ring.kr({ rrand(0.01,0.4) } ! 8)

	).mean * \ringamp.kr(0.4)/10 + sig;
	sig = FreqShift.ar(sig, \shift.kr(-400));
	sig = LPF.ar(sig, [ env1, env4 ]).mean;
	sig = HPF.ar(sig, env2);
	sig = LPF.ar(sig, \lpf.ar(10000));
	sig = BRF.ar(sig, 4500,0.1);
	sig = BRF.ar(sig, 7500,0.1);
	//sig = sig + WhiteNoise.ar;
	//sig = LPF.ar(sig, env1 * 2);
	//sig = HPF.ar(sig, env2);

	sig = Pan2.ar(sig, pan, amp);
	sig = [sig[0], DelayC.ar(sig[1],0.1,\delayr.ar(0.0001)) + sig[1]];
	//sig = sig * EnvGen.ar(Env.adsr(0.0001,0.1,0.8,0.3, 1, -5),gate,doneAction:2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
	Out.ar(out, sig);
}, metadata:(specs:(
	env1: XEnvSpec(\freq!3),
	env2: XEnvSpec(\freq!3),
	env3: XEnvSpec( ControlSpec(0.01,8,\exp)!3),
	env4: XEnvSpec(\freq!3),
	ringfreq: XArraySpec(\freq!8),
	ring: XArraySpec( \unipolar!8),
	adsr: XEnvSpec.adsr,
))).add;

Pdef(\kick, Pbind(
	\instrument, \kick,
	\dur, Pkeyd(\dur,1/2),
)).addHalo(\instrument, \kick);

Pdef(\snare, Pbind(
	\instrument, \snare,
	\legato, Pkeyd(\legato, 0.2),
)).addHalo(\instrument, \snare);

Pdef(\hat, Pbind(
	\instrument, \snare,
	\dur, Pkeyd(\dur, 1/4),
	//\dur, 1/8,
	//\legato, 0.1,
	\legato, Pkeyd(\legato, 0.1),
)).addHalo(\instrument, \snare);

TrackGroupDef(\tg, [Pdef(\kick), Pdef(\snare), Pdef(\hat)]);
);

Pdef(\hat).play

TrackGroupDef(\tg).edit
TrackGroupDef(\tg).clear
TrackGroupDef(\tg)[0].play
TrackGroupDef(\tg)[1].play
TrackGroupDef(\tg)[2].edit
TrackGroupDef(\tg)[3].source  =Pdef(\bla)

PlayerWrapper( TrackGroupDef(\tg)[0] ).label

(
( ParamProto.base_path +/+ "track.scd" ).load;
~player_grid_view.(TrackGroupDef(\tg));
)
Pdef.all.keys

(
WindowLayout ( { arg w;
	w.alwaysOnTop_(true);
	~x = PlayerWrapperSelectorView(PlayerWrapper(Pdef(\kick)));
	~x.asView;
});
)
(
WindowLayout  {
	~x = View.new;
	//~x.asView;
};
)
~x.selected = true
~x.selected = false
~x.selected
ParamView.color_ligth
~x.color_selected = Color.red
~x.color_deselected = Color.yellow
~x.view.background = Color.red
~x.view.background = Color.yellow
~x.view.background_(Color.red)
~x.view.background
~x.view.selected
~x.view.selected = true
~x.view.refresh
~x.refresh
~x.background =  Color.red
~x.background =  Color.yellow
~x.background
~x.view.selected
~x.view.isSelected
Color.red

a = 5;
a.addUniqueMethod(\sayHello, { |to| "hello " ++ to ++ ", I am 5"  });
a.sayHello;
TrackGroupDef(\tg)[0].label = "kjkj"
(
WindowLayout  {
	PlayerWrapperSelectorView(PlayerWrapper(TrackGroupDef(\tg)[0])).asView
};
)
(
WindowLayout  {
	VLayout (*
		TrackGroupDef(\tg).collect({ arg track;
			PlayerWrapperSelectorView(track).asView
		}).asArray.debug("tracks")
	)
};
)
		Pdef.all.keys.asArray.collect({ arg x; x.asString }).sort



		(
		~trackstream = Routine({
			var trackgroup = TrackGroupDef(\tg);
			trackgroup.do { arg track, i;
				i.debug("i");
				track.yield;
			};
			//inf.do { nil.yield }
		}).asStream;
		)

		~trackstream.next
TrackGroupDef(\tg).wrapper.doChildren({ arg x; x.debug("x") });
TrackGroupDef(\tg).wrapper
TrackGroupDef(\tg).do
TrackGroupDef(\tg).wrapper.isKindOf(ProtoClass)


	(
	~inline_groups = { arg pg, label_mode;

		var layout;
		var gridlayout;
		var biglayout;
		var scalarlist, biglist;
		var layout_type;
		var scrollview;

		var vertical_slider_group = { arg params, size=8;
			var lay;
			lay = GridLayout.rows(
				* size.collect({ arg idx;
					var param = params[idx];
					param.debug("what param");
					if(param.isNil) {
						nil ! 3;
						//{ Button.new } ! 3
					} {
						[
							if(label_mode == \full) {
								param.asStaticTextLabel;
							} {
								StaticText.new.string_(param.property)
							},
							param.asSlider.orientation_(\horizontal).minWidth_(150),
							param.asTextField.minWidth_(70),
						]
					}
				}) ++ [{ View.new }!3]
			).vSpacing_(2);

			lay;
		};

		label_mode = label_mode ? \property; // \full, \property

		scalarlist = pg.select({ arg param; 
			param.type == \scalar;
		});
		biglist = pg.select({ arg param;
			param.type != \scalar and: { 
				param.spec.isKindOf(AudioSpec).not
				and: { 
					// FIXME: find a better way to handle this
					param.type != \other 
				}
			}
		});

		gridlayout = GridLayout.rows(*
			scalarlist.collect({ arg param;
				[
					if(label_mode == \full) {
						param.asStaticTextLabel;
					} {
						StaticText.new.string_(param.property)
					},
					param.asSlider.orientation_(\horizontal),
					param.asTextField,
				]
			})
		);
		gridlayout.setColumnStretch(0,2);
		gridlayout.setColumnStretch(1,6);
		gridlayout.setColumnStretch(2,2);

		// chipotage
		//if(biglist.size < 5 and: { scalarlist.size < 6 } ) {
		//	layout_type = VLayout;
		//} {
		//	layout_type = HLayout;
		//};
		layout_type = HLayout;

		biglayout = HLayout(*
			biglist.collect({ arg param;

				[
				View.new.layout_(VLayout(
					if(label_mode == \full) {
						param.asStaticTextLabel;
					} {
						StaticText.new.string_(param.property).maxHeight_(10)
					},
					param.asView,
					param.asTextField,
					View.new,
					nil,
				).margins_(0)).minWidth_(300).maxHeight_(200),
				align: \top,
				]
			})
		);

		layout = layout_type.new(
			HLayout(*scalarlist.clump(8).collect({ arg gr; gr.debug("gr"); vertical_slider_group.(gr) })),
			biglayout
		);
		layout;
		scrollview = ScrollView.new.canvas_(View.new.layout_(layout));
		VLayout(scrollview)
	};
	ParamGroupLayout.windowize(~inline_groups.(Pdef(\gris).asParamGroup))
	)
	WindowLayout({ ~inline_groups.(Pdef(\snare).asParamGroup) })
~inline_groups.(Pdef(\snare).asParamGroup)
