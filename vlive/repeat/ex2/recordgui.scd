
(
	~recmodel = ~recmodel ?? { () };
	~recmodel.genfx = { arg self; RandDelayNetwork(self.fxdef).make(self.fxkey, self.fxcode, BusDef(self.fxbus, \audio)) };

	ProtoDef(\recorder, (
		init:{ arg self;
			self.fxdef = self.fxdef ? \default;
			self.fxkey = self.fxkey ? \fx1;
			self.fxcode = self.fxcode ? "5--";
			self.fxbus = self.fxbus ? \fx1;
			self.sourcekey = self.sourcekey ? \src;
			self.enablefx = self.enablefx ? false;
			self.instrs = self.instrs ?? { List.new };
		},

		genfx: { arg self; 
			RandDelayNetwork(self.fxdef).make(self.fxkey, self.fxcode, BusDef(self.fxbus, \audio)) 
		},

		enablefx_: { arg self, val;
			self[\enablefx] = val;
			if(val == true) {
				Pdef(self.sourcekey).set(\out, BusDef(self.fxbus));
				Ndef(self.fxkey).play;
				self.recbus = Ndef(self.fxkey).bus;
			} {
				Ndef(self.fxkey).stop;
				//Pdef(sourcekey).set(\out, BusDef(\recbus, \audio));
				Pdef(self.sourcekey).set(\out, 0);
				self.recbus = BusDef(\recbus, \audio);
			}
		},

		edit: { arg self;
			WindowDef(\recorder).front(self.instrs, self);
		},
	)).init;
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
		var sourcekey = model.sourcekey ? \src;
		var fxview = View.new;
		var curinstr;
		var controller;
		var recordbutton;
		var soundfileview;

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
					Pdef(sourcekey, Pbind(\instrument, model.instr));
					if(curinstr == \playersec) {
						srcview.removeAll;
						srcview.layout = WindowDef(\sampler).asView(Pdef(sourcekey), false);
					} {
						params = SynthDesc(model.instr).asParamGroup(Pdef(sourcekey));
						params = params.add(Param(Pdef(sourcekey), \sustain));
						params = params.add(Param(Pdef(sourcekey), \dur));
						params = params.reject({ arg x; x.property == \out });
						srcview.removeAll;
						srcview.layout = WindowDef(\vertical_paramgroup).asView(params);
					};
				}
			}
		}, popup);
		instrp.set(instrp.get); // refresh;


		if(model.fxkey.notNil) {
			fxview.layout = WindowDef(\vertical_paramgroup).asView(Ndef(model.fxkey).asParamGroup);
		};

		recordbutton = BasicButton.new.string_("Record").action_({ arg view;
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
		}).value_(0);

		VLayout(
			HLayout(
				popup,
				PlayerWrapper(Pdef(sourcekey)).asView,
				recordbutton,
				BasicButton.new.string_("PlayBuf").action_({
					Pbind(
						\instrument, \player,
						\sustain, model.recbuf.numFrames / model.recbuf.sampleRate,
						\bufnum, BufDef(model.recbufkey),
						\dur, Pn(1,1),
					).play;
				}),
				Param(
					Message(model), \recbufkey, 
					MenuSpec(BufDef.all.keys.as(Array).sort.select({ arg x; BufDef.all[x].isKindOf(Buffer) }))
				).asPopUpMenu,
				BasicButton.new.string_("Save as").action_({
					model.recbuf.saveDialog(-1, 0, { arg file;
						BufDef(file.asSymbol, file)
					})
				}),
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
					model.enablefx.debug("enablefx");
					model.enablefx = (model.enablefx ? false).not;
					view.refreshChange;
				}).refreshChangeAction_({ arg view;
					if(model.enablefx == true) {
						view.background = ParamView.color_ligth;
						view.value = 1;
					} {
						view.background = Color.white;
						view.value = 0;
					};
				}).refreshChange,
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

ProtoDef(\recorder).instrs = List[\snapkick, \snapsnare, \snaphihat, \playersec];

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
			buf.path = filepath;
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
//ProtoDef(\recorder).edit;
)

// END

Param.freeAllSimpleControllers
