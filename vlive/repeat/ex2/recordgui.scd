
(
	~recmodel = ~recmodel ?? { () };
	~recmodel.genfx = { arg self; RandDelayNetwork(self.fxdef).make(self.fxkey, self.fxcode, BusDef(self.fxbus, \audio)) };
	Spec.add(\inbus, XBusSpec.new);
	Spec.add(\gate, XGateSpec.new);
	Spec.add(\indelay, ControlSpec(0,0.2,\lin));
	WindowDef(\vertical_paramgroup, { arg def, paramGroup;
		var mainview = View.new;
		var scroll = ScrollView.new.canvas_(mainview).hasHorizontalScroller_(false).hasBorder_(false);
		paramGroup.debug("paramGroup");
		scroll.fixedWidth_(80+80+260+15);
		mainview.layout = 
		VLayout(*
			paramGroup.reject({ arg p;
				[ p, p.type ].debug("param");
				//p.type != \scalar;
				false;
			}).collect({ arg p;
				if(p.property == \bufnum) {
					var pop = PopUpMenu.new;
					p.spec = MenuSpec( BufDef.all.keys.as(Array).sort.collect({ arg key;
						key -> BufDef(key).bufnum;
					}));
					HLayout(
						p.asStaticTextLabel.fixedWidth_(80).maxHeight_(10).font_(Font.default.size_(11)),
						p.asPopUpMenu.fixedWidth_(260).maxHeight_(20),
						p.asTextField.fixedWidth_(80).maxHeight_(20).font_(Font.default.size_(11)),
					).spacing_(0).margins_(0)
				} {

					switch(p.type,
						\env, {
							VLayout(
								HLayout(
									p.asStaticTextLabel.fixedWidth_(76).maxHeight_(10).font_(Font.default.size_(11)),
									p.asTextField.fixedWidth_(340).maxHeight_(20),
								).spacing_(0).margins_(0),
								[p.asEnvelopeView.fixedWidth_(400).maxHeight_(80), align:\right]
							).spacing_(0).margins_(0)
						},
						\scalar, {
							HLayout(
								p.asStaticTextLabel.fixedWidth_(80).maxHeight_(10).font_(Font.default.size_(11)),
								p.asSlider.fixedWidth_(260).orientation_(\horizontal).maxHeight_(20),
								p.asTextField.fixedWidth_(80).maxHeight_(20).font_(Font.default.size_(11)),
							).spacing_(0).margins_(0)
						}
					);
				}
			}).reject(_.isNil) ++ [nil]
		).spacing_(0).margins_(0);
		VLayout(
			scroll,
		);

	});
	WindowDef(\recorder, { arg def, sdlist, model;
		var params;
		//var model = ();
		var instrp = Param(Message(model), \instr, MenuSpec(sdlist));
		var fxp = Param(Message(model), \fxkey);
		var popup = instrp.asPopUpMenu;
		var srcview = View.new;
		var sourcekey = \src;
		var fxview = View.new;
		var curinstr;
		var controller;

		model.fxdef = model.fxdef ? \default;
		model.fxkey = model.fxkey ? \fx1;
		model.fxcode = model.fxcode ? "5--";
		model.fxbus = model.fxbus ? \fx1;
		//model.recbufkey = model.fxbus ? \kick;

		controller = instrp.makeListener({ arg ...args;
			args.debug("listener");
			if(srcview.isClosed) {
				controller.remove;
				args.debug("remove controller");
			} {
				if(curinstr != model.instr) {
					args.debug("listener: refresh");
					curinstr = model.instr;
					params = SynthDesc(model.instr).asParamGroup(Pdef(sourcekey));
					params = params.add(Param(Pdef(sourcekey), \sustain));
					params = params.add(Param(Pdef(sourcekey), \dur));
					Pdef(sourcekey, Pbind(\instrument, model.instr));
					params = params.reject({ arg x; x.property == \out });
					srcview.removeAll;
					srcview.layout = WindowDef(\vertical_paramgroup).asView(params);
				}
			}
		}, popup);
		instrp.set(instrp.get); // refresh;


		if(model.fxkey.notNil) {
			fxview.layout = WindowDef(\vertical_paramgroup).asView(Ndef(model.fxkey).asParamGroup);
		};

		VLayout(
			HLayout (
				popup,
				PlayerWrapper(Pdef(sourcekey)).asView,
				BasicButton.new.string_("Record").action_({ arg view;
					model.recbuf = BufDef(model.recbufkey);
					model.recbuf.debug("recbuf");
					if(model.recbuf.notNil and: { view.value == 0 }) {
						Pdef(\recorder,
							Pseq([
								Ptask({
									"start record!!!!!!!!!!!!!".debug;
									{ 
										s.latency.wait;
										{
											view.background = Color.red;
											view.value = 1;
										}.defer;
									}.fork;
								},0),
								Pbind(
									\instrument, \recorder,
									\sustain, model.recbuf.numFrames / model.recbuf.sampleRate,
									\dur, Pkey(\sustain) * TempoClock.default.tempo,
									\inbus, model.recbus,
									\bufnum, Pn(model.recbuf,1),
								).trace,
								Ptask({
									"end record!!!!!!!!!!!!!".debug;
									{ 
										s.latency.wait;
										{
											view.background = Color.white;
											view.value = 0;
										}.defer;
									}.fork;
								},0)
							]),
						).play;
					}
				}).value_(0),
				BasicButton.new.string_("PlayBuf").action_({
					Pbind(
						\instrument, \player,
						\sustain, model.recbuf.numFrames / model.recbuf.sampleRate,
						\bufnum, BufDef(model.recbufkey),
						\dur, Pn(1,1),
					).play;
				}),
				Param(Message(model), \recbufkey, 
				MenuSpec(BufDef.all.keys.as(Array).sort.select({ arg x; BufDef.all[x].isKindOf(Buffer) }))
			).asPopUpMenu,
			TextField.new.action_({ arg view;
				model.fxdef = view.value.asSymbol;
			}).value_(model.fxdef),
			TextField.new.action_({ arg view;
				model.fxkey = view.value.asSymbol;
			}).value_(model.fxkey),
			TextField.new.action_({ arg view;
				model.fxcode = view.value.asString;
			}).value_(model.fxcode),
			TextField.new.action_({ arg view;
				model.fxbus = view.value.asSymbol;
			}).value_(model.fxbus),
			BasicButton.new.string_("Enable fx").action_({ arg view;
				view.value.debug("en");
				if(view.value == 0) {
					Pdef(sourcekey).set(\out, BusDef(model.fxbus));
					Ndef(model.fxkey).play;
					model.recbus = Ndef(model.fxkey).bus;
					view.background = ParamView.color_ligth;
					view.value = 1;
				} {
					Ndef(model.fxkey).stop;
					//Pdef(sourcekey).set(\out, BusDef(\recbus, \audio));
					Pdef(sourcekey).set(\out, 0);
					model.recbus = BusDef(\recbus, \audio);
					view.background = Color.white;
					view.value = 0;
				};
			}).value_(Ndef(model.fxkey).isPlaying.asInteger),
			BasicButton.new.string_("Gen Fx!").action_({
				"gen1".debug;
				model.genfx;
				"gen2".debug;
				fxview.removeAll;
				fxview.layout = WindowDef(\vertical_paramgroup).asView(Ndef(model.fxkey).asParamGroup);
				"gen3".debug;
			}),
		),
		HLayout(
			srcview,
			fxview,
			nil
		).spacing_(0)
	)

});
~recmodel.instrs = List[\snapkick, \snapsnare, \snaphihat, \playerbeat];
~recmodel.edit = { arg self;
	WindowDef(\recorder).front(self.instrs, self);
};
~savebufs = { arg keys, path;
	var rootpath = ( "~/Musique/sc/reckit/" +/+ path ).standardizePath;
	if(File.exists(rootpath).not) {
		File.mkdir(rootpath);
	};
	keys.do { arg key;
		var buf = BufDef(key);
		var filepath;
		if(buf.notNil) {
			filepath = rootpath +/+ key ++ ".flac";
			//if(File.exists(filepath)) { }; // no protection for the moment
			buf.write(filepath, "FLAC");
		} {
			key.debug("not buffer found at");
		}
	}
};
~loadbufs = { arg keys, path;
	var rootpath = ( "~/Musique/sc/reckit/" +/+ path ).standardizePath;
	if(File.exists(rootpath).not) {
		rootpath.debug("path not found");
	} {
		keys.do { arg key;
			var buf;
			var filepath;
			filepath = rootpath +/+ key ++ ".flac";
			buf = BufDef(key, filepath);
			if(buf.notNil) {
				// NOOP
			} {
				[key, filepath].debug("not file found at");
			}
		}
	};

};
//~recmodel.edit;
)
