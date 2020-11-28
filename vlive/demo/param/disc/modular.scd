
Param(Ndef(\osc1), \inbus).spec
Param(Ndef(\osc1), \inbus).shortLabel
~p = Param(Ndef(\osc1), \inbus)
~p.shortLabel = "iii"
~p.shortLabel
Param(Ndef(\osc1), \inbus).shortLabel = "iui"
Param(Ndef(\osc1), \inbus).shortLabel = nil
Param(Ndef(\osc1), \inbus).tryPerform(\combinator)
\bkbk_.asGetter
ParamValue(Ndef(\osc1), \inbus).tryPerform(\combinator)
~pv = ParamValue()
~pv.combinator = 34
~pv.combinator
~pv.tryPerform()
~pv.asParam.combinator
~pv.asParam.tryPerform(\combinator)
BusDef(\osc1, \audio)

Ndef(\osc1).scope
Ndef(\osc1).edit
ParamCombinator(Param(Ndef(\osc1), \freq)).edit
ParamCombinator(Param(Ndef(\osc1), \freq)).targetParam.get
ParamCombinator(Param(Ndef(\osc1), \freq)).targetParam.get.asBus.getSynchronous
ParamCombinator(Param(Ndef(\osc1), \freq)).targetParam.get.dump

ParamCombinator(Param(Ndef(\osc1), \freq)).inputParam.get
Ndef(\lfo1).monitor
Ndef(\lfo1).play(BusDef(\lfo1))

Bus.new(\control, 6, 1, Server.default)
\c6.asBus
BusDef(\lfo2)

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.5;
	var sig;
	var inputs = \inputs.kr([100,110,120]*2);
	sig = SinOsc.ar(inputs);
	sig = Pan2.ar(sig, pan, amp).sum;
}).play;
);

Ndef(\plop).set(\inputs, [BusDef(\a1, \control).asMap, BusDef(\a2, \control).asMap, BusDef(\a3, \control).asMap])
BusDef(\a1).set(250)
BusDef(\a2).set(450)
BusDef(\a2).set(450)
Param(Ndef(\plop), \inputs).at(2).set(BusDef(\a1, \control).asMap)
Ndef(\plop).clear
Ndef(\plop).get(\inputs)
Ndef(\plop).setBusMode(\inputs)

(
	~route_bus_spec = MenuSpec(
		[
			\osc1,
			\osc2,
		].collect({ arg key; key -> BusDef(key, \audio, 1) })
	);
	~lfo_bus_spec = MenuSpec(
		[
			\zero,
			\lfo1,
			\lfo2,
		].collect({ arg key; key -> BusDef(key, \control).asMap })
	);
	~make_standard_layout = { arg label, pg;
		VLayout(
			[StaticText.new.string_(label).background_(ParamViewToolBox.color_dark), stretch:0],
			* pg.collect({ arg pa;
				HLayout(
					XStaticText.new.value_(pa.shortLabel).fixedWidth_(100),
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
					pa.asTextField.fixedWidth_(100),
					if(pa.combinator.notNil) {
						pa.combinator.rangeParam.at(0).set(1);
						pa.combinator.inputParam.at(0).spec_(~lfo_bus_spec).asPopUpMenu.fixedWidth_(60);
					} {
						XStaticText.new.fixedWidth_(50)
					},
					nil
				)
			}) ++ [nil]
		)

	};

	~out_chooser = {

	};

~lfo_builder = ProtoClass((
	new: { arg self, name;
		self = self.deepCopy;
	
		self.name = name;
		
		self.init_oscbuilder;
	
		self;
	},

	init_oscbuilder: { arg self;
		Builder(self.name, { arg oscmode=\sin;
			Ndef(self.name, { arg freq=200;
				var sig = switch(oscmode,
					\sin, { 
						SinOsc.kr( freq ).unipolar
					},
					\saw, { 
						LFSaw.kr( freq ).unipolar
					},
				);
				sig * \amp.kr(1);
			});
			Ndef(self.name).bus = BusDef(self.name);
		}).build;
	},

	params: { arg self;
		ParamGroupDef.update(self.name, [
			//Param(Method(Ndef(self.name)), \bus, XBusSpec(1)),
			Param(Builder(self.name), \oscmode, MenuSpec([\sin, \saw])),
			//ParamCombinator.bus(Param(Ndef(self.name), \freq, \lofreq)).baseParam,
			Param(Ndef(self.name), \freq, \lofreq),
			Param(Ndef(self.name), \amp, \amp),
		])
		
	},

	make_layout: { arg self;
		~make_standard_layout.(self.name, self.params)
	},

	edit: { arg self;
		WindowDef(self.name, { self.make_layout }).front;
	},

	isPlaying: { arg self;
		true
	},

	play: { arg self;
		//Ndef(self.name).play(BusDef(self.name));
	},
	stop: { arg self;
		//Ndef(self.name).stop;
	},
));

~osc_builder = ProtoClass((
	new: { arg self, name;
		self = self.deepCopy;
	
		self.name = name;
		
		self.init_oscbuilder;
	
		self;
	},

	init_oscbuilder: { arg self;
		Builder(self.name, { arg oscmode=\sin;
			Ndef(self.name, { arg freq=200;
				var sig = switch(oscmode,
					\sin, { 
						SinOsc.ar( freq )
					},
					\saw, { 
						LFSaw.ar( freq )
					},
				);
				sig;
			})
		}).build;
	},

	params: { arg self;
		ParamGroupDef.update(self.name, [
			//Param(Method(Ndef(self.name)), \bus, XBusSpec(1)),
			Param(Builder(self.name), \oscmode, MenuSpec([\sin, \saw])),
			ParamCombinator.bus(Param(Ndef(self.name), \freq, \freq)).baseParam,
		])
		
	},

	make_layout: { arg self;
		~make_standard_layout.(self.name, self.params)
	},

	edit: { arg self;
		WindowDef(self.name, { self.make_layout }).front;
	},

	isPlaying: { arg self;
		Ndef(self.name).monitor.isPlaying;
	},

	play: { arg self;
		Ndef(self.name).play(BusDef(self.name));
	},
	stop: { arg self;
		Ndef(self.name).stop;
	},
));

~mixer_builder = ProtoClass((
	new: { arg self, name;
		self = self.deepCopy;
	
		self.name = name;
		
		self.init_oscbuilder;
	
		self;
	},

	init_oscbuilder: { arg self;
		Builder(self.name, { 
			Ndef(self.name, { arg inbus=100, pan=0, fader=1;
				var in = InFeedback.ar(inbus, 1);
				Pan2.ar(in, pan, fader);
			})
		}).build
	},

	params: { arg self;
		ParamGroupDef.update(self.name, [
			Param(Ndef(self.name), \inbus, ~route_bus_spec),
			Param(Ndef(self.name), \pan, \pan),
			Param(Ndef(self.name), \fader, \unipolar),
		])
	},

	make_layout: { arg self;
		var label = self.name;
		~make_standard_layout.(self.name, self.params)
	},

	edit: { arg self;
		WindowDef(self.name, { self.make_layout }).front;
	},

	play: { arg self;
		Ndef(self.name).play;
	},
	stop: { arg self;
		Ndef(self.name).stop;
	},

	player: { arg self;
		PlayerWrapper(Ndef(self.name));
	}
));

~modular_builder = ProtoClass((
	new: { arg self, name;
		self = self.deepCopy;
	
		self.name = name;
		
		self.init_builder;
	
		self;
	},

	init_builder: { arg self;
		self.modules = (
			mixer1: ~mixer_builder.new(\mixer1),
			osc1: ~osc_builder.new(\osc1),
			osc2: ~osc_builder.new(\osc2),
			lfo1: ~lfo_builder.new(\lfo1),
			lfo2: ~lfo_builder.new(\lfo2),
		)
	},

	make_layout: { arg self;
		var label = self.name;
		self.label = label;
		VLayout(
				PlayerWrapper(self).asView,
				HLayout(
					VLayout(
						self.modules.osc1.make_layout,
						self.modules.osc2.make_layout,
						self.modules.mixer1.make_layout,
						nil,
					),
					VLayout(
						self.modules.lfo1.make_layout,
						self.modules.lfo2.make_layout,
						nil,
					),
				)
		);
	},

	edit: { arg self;
		WindowDef(self.name, { self.make_layout }).front;
	},

	isPlaying: { arg self;
		self.modules.values.any({ arg mod, idx;
			//idx.debug("iiidx");
			mod.player.isPlaying.not;
		}).not;
	},

	play: { arg self;
		self.modules.do(_.play);
	},
	stop: { arg self;
		self.modules.do(_.stop);
	},
));
~modular_builder.new(\mod1).edit;
)
~modular_builder.new(\mod1).play;
~osc_builder.new(\osc1).play;
~osc_builder.new(\osc1).edit;

/////////////////////////////

~osc_builder.new(\osc1).params[0].type

Ndef(\osc1).sources[0].asCompileString
Ndef(\osc1).play
Ndef(\osc1).edit


(
	Ndef(\name, { arg freq = 440;
		var sig;
		sig = SinOsc.ar(freq);
		sig;
	}).play
)

{ SinOsc.ar(200) ! 2 * 0.1}.play;









/////////////////////////////////// audio rate lfo!!!!
(
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
	~make_standard_layout = { arg label, pg;
		var layout;

		layout = VLayout(
			[StaticText.new.string_(label).background_(ParamView.color_dark), stretch:0],
			* pg.collect({ arg pa;
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
							pa.combinator.inputParam.at(0).spec_(~lfo_bus_spec).asPopUpMenu.fixedWidth_(60),
							pa.combinator.rangeParam.at(0).asKnob.centered_(true).fixedSize_(20),
						)
					} {
						XStaticText.new.fixedWidth_(50)
					},
					nil
				)
			}) ++ [nil]
		)

	};

	~out_chooser = {

	};

~lfo_builder = ProtoClass((
	new: { arg self, name;
		self = self.deepCopy;
	
		self.name = name;
		
		~lfo_bus_spec.add(self.name, BusDef(self.name, \audio, 1).asMap);
		self.init_oscbuilder;
	
		self;
	},

	init_oscbuilder: { arg self;
		Builder(self.name, { arg oscmode=\sin, sigmode=\unipolar;
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
			//Param(Method(Ndef(self.name)), \bus, XBusSpec(1)),
			Param(Builder(self.name), \oscmode, MenuSpec([\sin, \saw, \pulse])),
			Param(Builder(self.name), \sigmode, MenuSpec([\unipolar, \bipolar])),
			//ParamCombinator.bus(Param(Ndef(self.name), \freq, \lofreq)).baseParam,
			Param(Ndef(self.name), \freq, \widefreq),
			Param(Ndef(self.name), \amp, \amp),
		])
		
	},

	make_layout: { arg self;
		~make_standard_layout.(self.name, self.params)
	},

	edit: { arg self;
		WindowDef(self.name, { self.make_layout }).front;
	},

	isPlaying: { arg self;
		true
	},

	play: { arg self;
		//Ndef(self.name).play(BusDef(self.name));
	},
	stop: { arg self;
		//Ndef(self.name).stop;
	},
));

~osc_builder = ProtoClass((
	new: { arg self, name;
		self = self.deepCopy;
	
		self.name = name;
		
		~lfo_bus_spec.add(self.name, BusDef(self.name, \audio, 1).asMap);
		~route_bus_spec.add(self.name, BusDef(self.name, \audio, 1));
		self.init_oscbuilder;
	
		self;
	},

	init_oscbuilder: { arg self;
		Builder(self.name, { arg oscmode=\sin;
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
			})
		}).build;
	},

	params: { arg self;
		ParamGroupDef.update(self.name, [
			//Param(Method(Ndef(self.name)), \bus, XBusSpec(1)),
			Param(Builder(self.name), \oscmode, MenuSpec([\sin, \saw, \pulse])),
			ParamCombinator.ar(Param(Ndef(self.name), \freq, \freq)).baseParam,
		])
		
	},

	make_layout: { arg self;
		~make_standard_layout.(self.name, self.params)
	},

	edit: { arg self;
		WindowDef(self.name, { self.make_layout }).front;
	},

	play: { arg self;
		Ndef(self.name).play(BusDef(self.name));
	},
	stop: { arg self;
		Ndef(self.name).stop;
	},

	player: { arg self;
		PlayerWrapper(Ndef(self.name));
	},

	isPlaying: { arg self;
		self.player.isPlaying;
	},
));

~filter_builder = ProtoClass((
	new: { arg self, name;
		self = self.deepCopy;
	
		self.name = name;
		
		~lfo_bus_spec.add(self.name, BusDef(self.name, \audio, 1).asMap);
		~route_bus_spec.add(self.name, BusDef(self.name, \audio, 1));
		self.init_builder;
	
		self;
	},

	init_builder: { arg self;
		Builder(self.name, { arg filtermode=\lpf;
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

	make_layout: { arg self;
		~make_standard_layout.(self.name, self.params)
	},

	edit: { arg self;
		WindowDef(self.name, { self.make_layout }).front;
	},

	play: { arg self;
		Ndef(self.name).play(BusDef(self.name));
	},
	stop: { arg self;
		Ndef(self.name).stop;
	},

	player: { arg self;
		PlayerWrapper(Ndef(self.name));
	},

	isPlaying: { arg self;
		self.player.isPlaying;
	},
));

~mixer_builder = ProtoClass((
	new: { arg self, name;
		self = self.deepCopy;
	
		self.name = name;
		
		self.init_oscbuilder;
	
		self;
	},

	init_oscbuilder: { arg self;
		Builder(self.name, { 
			Ndef(self.name, { arg inbus=100, pan=0, fader=1;
				var in = InFeedback.ar(inbus, 1);
				Pan2.ar(in, pan, fader);
			})
		}).build
	},

	params: { arg self;
		ParamGroupDef.update(self.name, [
			Param(Ndef(self.name), \inbus, ~route_bus_spec),
			Param(Ndef(self.name), \pan, \pan),
			Param(Ndef(self.name), \fader, \unipolar),
		])
	},

	make_layout: { arg self;
		var label = self.name;
		~make_standard_layout.(self.name, self.params)
	},

	edit: { arg self;
		WindowDef(self.name, { self.make_layout }).front;
	},

	play: { arg self;
		Ndef(self.name).play;
	},
	stop: { arg self;
		Ndef(self.name).stop;
	},

	player: { arg self;
		PlayerWrapper(Ndef(self.name));
	},

	isPlaying: { arg self;
		self.player.isPlaying;
	},
));

~modular_builder = ProtoClass((
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
			osc1: ~osc_builder.new(\osc1),
			osc2: ~osc_builder.new(\osc2),
			osc3: ~osc_builder.new(\osc3),
			lfo1: ~lfo_builder.new(\lfo1),
			lfo2: ~lfo_builder.new(\lfo2),
			filter1: ~filter_builder.new(\filter1),
			filter2: ~filter_builder.new(\filter2),
		);
		self.outputs = [
			self.modules.osc1,
			self.modules.osc2,
			self.modules.osc3,
			self.modules.mixer1,
			self.modules.mixer2,
			self.modules.filter1,
			self.modules.filter2,
		];
		self.filters = [
		]
	},

	make_layout: { arg self;
		var label = self.name;
		self.label = label;
		VLayout(
				PlayerWrapper(self).asView,
				HLayout(
					VLayout(
						self.modules.osc1.make_layout,
						self.modules.osc2.make_layout,
						self.modules.osc3.make_layout,
						self.modules.mixer1.make_layout,
						self.modules.mixer2.make_layout,
						nil,
					),
					VLayout(
						self.modules.lfo1.make_layout,
						self.modules.lfo2.make_layout,
						self.modules.filter1.make_layout,
						self.modules.filter2.make_layout,
						nil,
					),
				)
		);
	},

	edit: { arg self;
		WindowDef(self.name, { self.make_layout }).front;
	},

	isPlaying: { arg self;
		self.outputs.any({ arg mod, idx;
			//idx.debug("iiidx");
			[mod.name, mod.isPlaying].debug("is playing ?");
			mod.isPlaying.not;
		}).not;
	},

	play: { arg self;
		self.outputs.do(_.play);
	},
	stop: { arg self;
		self.outputs.do(_.stop);
	},
));
~modular_builder.new(\mod1).edit;
)

~modular_builder.new(\mod1).play
(
	~ms = MenuSpec([]);
)

(
	WindowDef(\yep, { Param(currentEnvironment, \val, ~ms).asView }).front
)
~val
~ms.add(\bla)
~ms.add(\bla2)

~bp = Ndef(\osc1).getHalo(\ParamCombinator_freq).baseParam
~pc = Ndef(\osc1).getHalo(\ParamCombinator_freq)
~bp
Ndef('ParamCombinator_903876').edit
Ndef('ParamCombinator_903876').isPlaying
Ndef('ParamCombinator_903876').bus
Ndef('ParamCombinator_903876').rebuild
Ndef('ParamCombinator_903876').clear
BusDef(\lfo1)
Ndef(\osc1).index
Ndef(\osc1).get(\freq)
Ndef(\osc1).nodeMap
Ndef(\lfo2).nodeMap
~modular_builder.new(\mod1)

~osc_builder.new(\osc1).edit;
~lfo_builder.new(\osc1).edit;
Ndef(\lfo1).bus

~pc.inputParam.get
~pc.inputParam
~pc.rangeParam.get
~pc.targetParam.get
~pc.rate
~pc.busMode
~route_bus_spec.labelList
~lfo_bus_spec.labelList
~lfo_bus_spec.valueList
~lfo_bus_spec.unmapIndex(\a20)
~lfo_bus_spec.map(0)
~lfo_bus_spec.map(3)

Param(~pc.targetParam.target, ~pc.targetParam.property, ~lfo_bus_spec).edit
~lfo_bus_spec.unmapIndex(~pc.targetParam.get)
~pc.targetParam.spec.unmapIndex(~pc.targetParam.get)

~pc

		// TODO: disable, anyone ?
		var bus;
		busMode = bool;
		name = name ? key;
		bus = BusDef(name, \control);
		proxy = Ndef(name);
		~name = 
		Ndef(~pc.key).clear;
		Ndef(name, {
			var inputs, ranges;
			var fval;
			var sig;
			fval = \base.perform(rate, 0);
			fval = targetParam.spec.unmap(fval);
			inputs = \inputs.perform(rate,0!rangeSize);
			ranges = \ranges.perform(rate,0!rangeSize);

			inputs.do { arg in, x;
				fval = fval + (in * ranges[x])
			};
			sig = targetParam.spec.map(fval);
			//sig.poll;
			sig;
		});
		this.freeAllSimpleControllers;
		baseParam = Param(Ndef(name), \base, targetParam.spec);
		baseParam.set(targetParam.get);
		targetParam.target.set(targetParam.property, Ndef(name).asMap);
		rangeParam = Param(Ndef(name), \ranges, XArraySpec(\bipolar ! rangeSize));
		rangeParam.set(ranges.asArray); // whyyyy list doesnt do anything ????
		inputParam = Param(Ndef(name), \inputs, XArraySpec(\unipolar ! rangeSize));
		inputParam.set(inputs.asArray);


		baseParam.label = targetParam.asLabel;
		baseParam.shortLabel = targetParam.shortLabel.asString + "(m)";
		baseParam.combinator = this;


(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

PlayerWrapper(Ndef(\plop)).edit
Ndef(\plop).isPlaying
Ndef(\plop).play
Ndef(\plop).stop
Ndef(\plop).monitor.isPlaying

~osc_builder.new(\bla).play(0)
~osc_builder.new(\bla).player.target.play(0)
~osc_builder.new(\bla).edit


////////////////////////////// add play_combi to avoid bug when cmdPeriod



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
				[StaticText.new.string_(" "++label).background_(ParamView.color_dark), stretch:0],
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
								pa.combinator.inputParam.at(0).spec_(~lfo_bus_spec).asPopUpMenu.fixedWidth_(60),
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
		Builder(self.name, { arg oscmode=\sin, sigmode=\unipolar;
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
		Builder(self.name, { arg seqsize = 8;
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
				Param(Ndef(self.name), \levels, self.seq_spec).asView.fixedHeight_(50)
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
		Builder(self.name, { arg oscmode=\sin;
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

		Builder(self.name, { arg oscmode=\sin;
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
		Builder(self.name, { arg filtermode=\lpf;
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
							self.modules.noteline1.make_layout,
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

~timeline_builder.new(\noteline1).timeline.play;
~timeline_builder.new(\noteline1).timeline.edit;
~noteTimeline.new(\noteline1, Param(Pdef(\bla, Pbind(\instrument, \noteline1)), \midinote)).edit;

~pc = Ndef(\osc1).getHalo(\ParamCombinator_freq)
~pc.setBusMode(true)
~pc.proxy.rebuild
~pc.proxy.send
~pc.proxy.wakeUp


~osc1 = ~osc_builder.new(\osc1)
~mixer_builder.new(\mixer1).player.target.play
~osc1.edit
~osc1.init_builder
~osc1.play
~osc1.stop
Ndef(\osc1).edit


~osc_builder.new(\osc1).player.target.play(0)
~osc_builder.new(\osc1).player.target.rebuild
~osc_builder.new(\osc1).player.target.edit
~osc_builder.new(\osc1).player.target.set(\freq, 200)
~modular_builder.new(\mod1).modules.mixer1.play
~modular_builder.new(\mod1).modules.osc1.player.target.play(0)
~modular_builder.new(\mod1).modules.osc1.player.target.source.asCompileString
~modular_builder.new(\mod1).modules.osc1.player.target.get(\out)
~modular_builder.new(\mod1).modules.osc1.player.target.set(\out, 0)
~modular_builder.new(\mod1).modules.mixer1.player.target.monitor.out
~modular_builder.new(\mod1).modules.osc1.player.target.monitor.out
~modular_builder.new(\mod1).modules.mixer1.player.target
~modular_builder.new(\mod1).modules.mixer1.player.target.get(\out)
~modular_builder.new(\mod1).modules.mixer1.player.target.monitor.get(\out)

Ndef(\osc1, { SinOsc.ar(200) }).play(0)
Ndef(\osc1, { SinOsc.ar(200) }).clear

Ndef(\gri).get(\out)
Ndef(\gri).play(BusDef(\gri, \audio, 1))
Ndef(\gri2).play
Ndef(\gri2).bus
Ndef(\gri2).get(\out)

Ndef(\gri3, { SinOsc.ar(220) }).play(BusDef(\gri3,\audio,1))
Ndef(\gri3).get(\out)
Ndef(\gri3).bus
BusDef(\gri3, \audio, 1)
Ndef(\gri3, { SinOsc.ar(220) }).play(BusDef(\gri3,\audio,1))
Ndef(\gri3).get(\out)
Ndef(\gri3).bus
(
Ndef(\gri3, { SinOsc.ar(220) });
Ndef(\gri3).monitor.out;
)
Ndef(\gri3).monitor
Ndef(\gri3).play
Ndef(\gri3).free

Ndef(\gri4, { SinOsc.ar(220) })
Ndef(\gri5).initMonitor
Ndef(\gri4).monitor
Ndef(\gri4).monitor.out = BusDef(\gg, \audio, 1).index
Ndef(\gri5).monitor.out = BusDef(\gg, \audio, 1).index

Pdef(\noteline1).play
Pdef(\noteline1).source


////////////////////////////////////

Monitor



(
~ev = (
	parent: (hello: { "23".postln }),
	bla: { arg self;
		self.hello;
	},
)
)
~ev.bla

(
~ev = TestProtoClass((
	parent: (hello: { "23".postln }),
	bla: { arg self;
		self.hello;
	},
))
)

~ev.bla



~you = ()
~you.parent
~you.putAll(~ev)

~you.parent = ~ev.parent
~you.bla
ParamProto.init
			~noteTimeline.new(\tt, Param(Pdef(\tt), \midinote));
			~noteTimeline.new(\tt).asPattern.play
			Pdef(\tt, ~noteTimeline.new(\tt).asPattern.trace <> Pbind(\instrument, \default)).play
"jj"


Ndef(\bla).play(BusDef(\yep, \audio, 1))
Ndef(\bla).nodeMap


Ndef(\bli, { SinOsc.ar(200) }).play
Ndef(\bli, { SinOsc.ar(200) })
Ndef(\bli).set(\out, BusDef(\yop, \audio, 1))
Ndef(\bli).play
Ndef(\ooo, { InFeedback.ar(BusDef(\yop)) }).play

(
)
~seq_builder.new(\seq1);
~seq_builder.new(\seq1).edit


XArraySpec(\bla!4)
Exception("kjkj").throw
ArgumentError("kjkj").throw


(
Ndef(\plop, { arg freq=200, pan=0, amp=0.7;
	var sig;
	freq = freq + Duty.ar(1, 0, 100 * Dseq( \levels.kr(0!4),inf));
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

Param(Ndef(\plop), \levels).edit
