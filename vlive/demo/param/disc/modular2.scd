
(
ParamProto.init;
	~route_bus_spec = MenuSpec(
		[
//			\osc1,
//			\osc2,
//			\osc3,
		].collect({ arg key; key -> BusDef(key, \audio, 1) })
	);
	~lfo_bus_spec = MenuSpec(
		[
			\zero,
//			\lfo1,
//			\lfo2,
//			\osc1,
//			\osc2,
//			\osc3,
		].collect({ arg key; key -> BusDef(key, \audio, 1).asMap })
	);
	~make_standard_layout = { arg label, pg, pre_views;
		var layout;
		var blockview = View.new;

		layout = VLayout(
			HLayout(
				Button.new.states_([
					["-"],
					["+"],
				]).action_({ arg me;
					if(me.value == 0) {
						blockview.visible = true;
					} {
						blockview.visible = false;
					}
				}).fixedWidth_(30),
				[StaticText.new.string_(" "++label).background_(ParamViewToolBox.color_dark), stretch:0],
			).spacing_(0),
			blockview.layout_(VLayout(
				* 
				pre_views ++
				pg.collect({ arg pa;
					HLayout(
						XStaticText.new.value_(pa.shortLabel).fixedWidth_(80),
						case 
							{ pa.spec.isKindOf(MenuSpec)  } {
								pa.asPopUpMenu.fixedWidth_(200);
							}
							//{ pa.spec.isKindOf(XBusSpec)  } {
							//	//Param(pa.target, pa.property, ~route_bus_spec).asView.fixedWidth_(200);
							//}
							{
								pa.asSlider.orientation_(\horizontal).fixedWidth_(200);
							}
						,
						pa.asTextField.fixedWidth_(70),
						if(pa.combinator.notNil) {
							//pa.combinator.rangeParam.at(0).set(1);
							HLayout (
								pa.combinator.inputParam.at(0).spec_(~lfo_bus_spec).asValuePopUpMenu.fixedWidth_(60),
								pa.combinator.rangeParam.at(0).asKnob.centered_(true).fixedSize_(20),
							)
						} {
							XStaticText.new.fixedWidth_(50)
						},
						nil
					)
				}) ++ [nil]
			))
		)

	};

	~out_chooser = {

	};

/////// parent class
~base_builder = ProtoClass((
	new: { arg self, name;
		self = self.deepCopy;
	
		self.name = name;
		
		~lfo_bus_spec.add(self.name, BusDef(self.name, \audio, 1).asMap);
		~route_bus_spec.add(self.name, BusDef(self.name, \audio, 1));
		self.player = PlayerWrapper(Ndef(self.name));
		//self.player.target.set(\out, BusDef(self.name));
		self.set_ndef_out;
		self.init_builder;

		self;
	},

	set_ndef_out: { arg self;
		Ndef(self.name).initMonitor;
		Ndef(self.name).monitor.out = BusDef(self.name).index;
		//Ndef(self.name).play(BusDef(self.name).index);
	},

	make_layout: { arg self;
		~make_standard_layout.(self.name, self.params)
	},

	edit: { arg self;
		WindowDef(self.name, { self.make_layout }).front;
	},

	play_combi: { arg self;
		ParamGroupDef(self.name).do { arg param;
			if(param.combinator.notNil) {
				param.combinator.proxy.wakeUp
			}
		}
	},

	play: { arg self;
		self.play_combi;
		self.player.play;
	},
	stop: { arg self;
		self.player.stop;
	},

	isPlaying: { arg self;
		self.player.isPlaying;
	},

));

/////////// modules

///// modulators
~lfo_builder = ProtoClass((
	parent: ~base_builder,
	new: { arg self, name;
		self = self.deepCopy;
	
		self.name = name;
		
		~lfo_bus_spec.add(self.name, BusDef(self.name, \audio, 1).asMap);
		self.player = PlayerWrapper(Ndef(self.name));
		self.player.target.set(\out, BusDef(self.name));
		self.module_type = \modulator;

		self.init_builder;
		//self.set_ndef_out;
	
		self;
	},


	init_builder: { arg self;
		Builder(self.name, { arg def, oscmode=\sin, sigmode=\unipolar;
			oscmode.debug("oscmode");
			Ndef(self.name, { arg freq=200;
				var sig = switch(oscmode,
					\sin, { 
						SinOsc.ar( freq )
					},
					\pulse, { 
						LFPulse.ar( freq )
					},
					\saw, { 
						LFSaw.ar( freq )
					},
				);
				sig = if(sigmode == \unipolar) {
					sig.unipolar;
				} {
					sig.bipolar;
				};
				sig * \amp.ar(1);
			});
			Ndef(self.name).bus = BusDef(self.name);
		}).build;
	},

	params: { arg self;
		ParamGroupDef.update(self.name, [
			Param(Builder(self.name), \oscmode, MenuSpec([\sin, \saw, \pulse])),
			Param(Builder(self.name), \sigmode, MenuSpec([\unipolar, \bipolar])),
			Param(Ndef(self.name), \freq, \widefreq),
			Param(Ndef(self.name), \amp, \amp),
		])
		
	},

	isPlaying: { arg self;
		true
	},

	play: { arg self;
		self.play_combi;
	},
	stop: { arg self;
	},
));

~seq_builder = ProtoClass((
	parent: ~base_builder,
	new: { arg self, name;
		self = self.deepCopy;
	
		self.name = name;
		
		~lfo_bus_spec.add(self.name, BusDef(self.name, \audio, 1).asMap);
		self.player = PlayerWrapper(Ndef(self.name));
		self.player.target.set(\out, BusDef(self.name));
		self.module_type = \modulator;
		//self.seq_spec = XArraySpec(\levels ! 4);

		self.init_builder;
		//self.set_ndef_out;
	
		self;
	},


	init_builder: { arg self;
		Builder(self.name, { arg def, seqsize = 8;
			self.seq_spec = XArraySpec(\unipolar ! seqsize);
			Ndef(self.name, { 
				var sig;
				sig = Duty.ar(1/\rate.kr(1), 0, Dseq( \levels.kr(0 ! seqsize), inf));
				sig = sig * \amp.ar(1);
				sig
			});
			Ndef(self.name).bus = BusDef(self.name);
		}).build;
	},

	params: { arg self;
		ParamGroupDef.update(self.name, [
			Param(Builder(self.name), \seqsize, ControlSpec(1,32,\lin,1)),
			Param(Ndef(self.name), \rate, \lofreq),
			Param(Ndef(self.name), \amp, \amp),
		])
		
	},

	make_layout: { arg self;
		VLayout(
			~make_standard_layout.(self.name, self.params, [
				Param(Ndef(self.name), \levels, self.seq_spec).asView
			]),
		).margins_(0)
	},

	isPlaying: { arg self;
		true
	},

	play: { arg self;
		self.play_combi;
	},
	stop: { arg self;
	},
));

///// sources
~osc_builder = ProtoClass((
	parent: ~base_builder,
	new: { arg self, name;
		self = self.deepCopy;
	
		self.name = name;
		
		~lfo_bus_spec.add(self.name, BusDef(self.name, \audio, 1).asMap);
		~route_bus_spec.add(self.name, BusDef(self.name, \audio, 1));
		self.player = PlayerWrapper(Ndef(self.name));
		self.init_builder;
		self.set_ndef_out;
	
		self;
	},

	init_builder: { arg self;
		Builder(self.name, { arg def, oscmode=\sin;
			Ndef(self.name, { 
				var sig;
				var freq = \freq.ar(200);
				sig = switch(oscmode,
					\sin, { 
						SinOsc.ar( freq )
					},
					\pulse, { 
						LFPulse.ar( freq )
					},
					\saw, { 
						LFSaw.ar( freq )
					},
				);
				sig;
			});
		}).build;
	},

	params: { arg self;
		ParamGroupDef.update(self.name, [
			Param(Builder(self.name), \oscmode, MenuSpec([\sin, \saw, \pulse])),
			ParamCombinator.ar(Param(Ndef(self.name), \freq, \freq)).baseParam,
		])
		
	},

));

~timeline_builder = ProtoClass((
	parent: ~base_builder,
	new: { arg self, name;
		self = self.deepCopy;
	
		self.name = name;
		
		~lfo_bus_spec.add(self.name, BusDef(self.name, \audio, 1).asMap);
		~route_bus_spec.add(self.name, BusDef(self.name, \audio, 1));
		self.timeline = ~noteTimeline.new(self.name, Param(Pdef(self.name), \midinote));
		self.player = PlayerWrapper(self.timeline);
		Pdef(self.name).set(\out, BusDef(self.name));
		self.init_builder;
	
		self;
	},

	
	init_builder: { arg self;
		Pdef(self.name, Pbind(
			\instrument, self.name,
		));
		Pdef(self.name).setBusMode(\fdetune);

		Builder(self.name, { arg def, oscmode=\sin;
			SynthDef(self.name, { arg gate=1;
				var sig;
				var freq = \freq.ar(200);
				freq = freq + \fdetune.kr(0);
				sig = switch(oscmode,
					\sin, { 
						SinOsc.ar( freq )
					},
					\pulse, { 
						LFPulse.ar( freq )
					},
					\saw, { 
						LFSaw.ar( freq )
					},
				);
				sig;
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
				Out.ar(\out.kr(0), sig);
			}).add;
		}).build;
	},

	params: { arg self;
		ParamGroupDef.update(self.name, [
			Param(Builder(self.name), \oscmode, MenuSpec([\sin, \saw, \pulse])),
			Param(Pdef(self.name), \fdetune, ControlSpec(-100,100)),
		])
	},

	make_layout: { arg self;
		VLayout(
			~make_standard_layout.(self.name, self.params, [
				TimelinePreview.new.mapEventList(self.timeline.eventList).view.mouseDownAction_({ 
					self.timeline.edit;
				}).fixedHeight_(40),
			]),
		).margins_(0)
	},
));


///// filters

~filter_builder = ProtoClass((
	parent: ~base_builder,
	new: { arg self, name;
		self = self.deepCopy;
	
		self.name = name;
		
		~lfo_bus_spec.add(self.name, BusDef(self.name, \audio, 1).asMap);
		~route_bus_spec.add(self.name, BusDef(self.name, \audio, 1));
		self.player = PlayerWrapper(Ndef(self.name));
		self.init_builder;
		self.set_ndef_out;
	
		self;
	},

	init_builder: { arg self;
		Builder(self.name, { arg def, filtermode=\lpf;
			Ndef(self.name, { arg rq=0.1, amp=1;
				var sig;
				var freq = \cutoff.ar(200);
				var in;
				in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 1); 
				sig = in;
				sig = switch(filtermode,
					\lpf, { 
						LPF.ar(sig, freq )
					},
					\rlpf, { 
						RLPF.ar(sig, freq, rq )
					},
					\hpf, { 
						HPF.ar(sig, freq )
					},
					\rhpf, { 
						RHPF.ar(sig, freq )
					},
					\bpf, { 
						BPF.ar(sig, freq, rq )
					},
				);
				sig * amp;
			});
		}).build;
	},

	params: { arg self;
		ParamGroupDef.update(self.name, [
			Param(Ndef(self.name), \inbus, ~route_bus_spec),
			Param(Builder(self.name), \filtermode, MenuSpec([\lpf, \hpf, \bpf, \rlpf, \rhpf])),
			ParamCombinator.ar(Param(Ndef(self.name), \cutoff, \freq)).baseParam,
			Param(Ndef(self.name), \rq, \rq),
			Param(Ndef(self.name), \amp, \amp),
		])
	},

));

///// out
~mixer_builder = ProtoClass((
	parent: ~base_builder,
	new: { arg self, name;
		self = self.deepCopy;
	
		self.name = name;
		self.player = PlayerWrapper(Ndef(self.name));
		self.init_builder;
	
		self;
	},

	init_builder: { arg self;
		Builder(self.name, { 
			Ndef(self.name, { arg inbus=100, pan=0, fader=1;
				var in = InFeedback.ar(inbus, 1);
				Pan2.ar(in, pan, fader);
			});
		}).build
	},

	params: { arg self;
		ParamGroupDef.update(self.name, [
			Param(Ndef(self.name), \inbus, ~route_bus_spec),
			Param(Ndef(self.name), \pan, \pan),
			Param(Ndef(self.name), \fader, \unipolar),
		])
	},

));


//////////////////////// Main
~modular_builder = ProtoClass((
	parent: ~base_builder,
	new: { arg self, name;
		self = self.deepCopy;
	
		self.name = name;
		
		self.init_builder;
	
		self;
	},

	init_builder: { arg self;
		self.modules = (
			mixer1: ~mixer_builder.new(\mixer1),
			mixer2: ~mixer_builder.new(\mixer2),

			//noteline1: ~timeline_builder.new(\noteline1),
			osc1: ~osc_builder.new(\osc1),
			osc2: ~osc_builder.new(\osc2),
			osc3: ~osc_builder.new(\osc3),
			lfo1: ~lfo_builder.new(\lfo1),
			lfo2: ~lfo_builder.new(\lfo2),
			filter1: ~filter_builder.new(\filter1),
			filter2: ~filter_builder.new(\filter2),

			seq1: ~seq_builder.new(\seq1),
		);
		self.outputs = [
			self.modules.osc1,
			self.modules.mixer1,
			//self.modules.noteline1,
		];
		self.filters = [
		]
	},

	make_layout: { arg self;
		var label = self.name;
		self.label = label;
		ScrollView.new.canvas_(View.new.layout_(
			VLayout(
					PlayerWrapper(self).asView,
					HLayout(
						VLayout(
							self.modules.osc1.make_layout,
							self.modules.osc2.make_layout,
							self.modules.osc3.make_layout,
							self.modules.seq1.make_layout,
							self.modules.mixer1.make_layout,
							self.modules.mixer2.make_layout,
							[nil, stretch: 10],
						),
						VLayout(
							//self.modules.noteline1.make_layout,
							self.modules.lfo1.make_layout,
							self.modules.lfo2.make_layout,
							self.modules.filter1.make_layout,
							self.modules.filter2.make_layout,
							[nil, stretch: 10],
						),
					),
					nil,

			)
		));
	},

	isPlaying: { arg self;
		self.outputs.any({ arg mod, idx;
			//idx.debug("iiidx");
			//[mod.name, mod.isPlaying].debug("is playing ?");
			mod.isPlaying.not;
		}).not;
	},

	play: { arg self;
		self.modules.values.do(_.play);
	},
	stop: { arg self;
		self.modules.values.do(_.stop);
	},
));

~modular_builder.new(\mod1).edit;
)
