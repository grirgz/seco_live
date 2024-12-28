
// the goal is to have a all-in gui to plug the piano controller and play
// - kind of PbindefEditor, choose instrument, change parameters
// - choose controller
// - virtualkeyboard
// - Arpegiator
// - NoteTimelineTrack to have several buffers
// - AutomationRack
// - TODO: modify virtualkeyboard to hold notes while in arp mode

(
FileSystemProject.load("paramdev/drafts/arpegiator.scd");
FileSystemProject.loadOnce("libdef/ModulatorRack.scd");
ProtoTemplateDef(\PianoCenter, (
	controller_: { arg self, val;
		self[\controller] = val;
		self.startControl;
		self.changed(\controller);
	},

	startControl: { arg self;
		if(self.controller.notNil) {
			self.controller.startControl(self.playerGroup);
		}
	},

	proxy: { arg self;
		Pbindef(\PianoCenter, \initialized, true)
	},

	playerGroup: { arg self;
		if(self[\playerGroup_obj].isNil) {
			self[\playerGroup_obj] = ProtoTemplateDef(\SeqPlayerGroup).new(self.proxy).muted_(self.inArpMode)
		};
		self[\playerGroup_obj];
	},

	inArpMode: { arg self;
		self.arpPreset != \disabled
	},

	arpProxy: { arg self;
		Pdef(\PianoCenter_arp);
	},

	arpPreset: { arg self;
		\disabled
	},

	addArpListener: { arg self;
		~currentNotes = nil!128;
		if(self.arpListener.notNil) {
			self.arpListener.remove;
		};
		self.arpListener = self.playerGroup.makeListener({ arg child, msg, idx;
			//args.debug("args");
			[msg, idx].debug("arp note");
			if(msg == \play) {
				~currentNotes[idx] = (midinote:idx);
			} {
				~currentNotes[idx] = nil;
			}
		});
		self.playerGroup.muted = true;
	},

	removeArpListener: { arg self;
		if(self.arpListener.notNil) {
			self.arpListener.remove;
		};
		self.playerGroup.muted = false;
	},

	arpPreset_: { arg self, val;
		self[\arpPreset] = val;
		if(val != \disabled) {
			self.arpProxy.source = ProtoTemplateDef(\Arp).arperlive({ ~currentNotes }, self.proxy, Pdef(val));
			self.addArpListener;
			self.arpProxy.play;
		} {
			self.removeArpListener;
			self.arpProxy.stop;
		};
		self.startControl;
		self.changed(\arpPreset);
	},

));
TagSpecDef(\ArpPreset).addUnique(\disabled);
WindowDef(\PianoCenter, { arg def, model;
	var pgView = View.new;
	var updateView = {
		pgView.removeAll;
		pgView.layout = model.proxy.asParamGroup.asView;
	};
	pgView.followChange(model.proxy, \set, { arg view, obj, msg ...args;
		//[view, obj, msg, args].debug("vom");
		if(args.first == \instrument) {
			updateView.();
		};
	});
	updateView.();
	VLayout (
		HLayout (
			HLayout (
				StaticText.new.string_("Controller:"),
				Param(
					Message(model),
					\controller, 
					ControllerDef.getTagSpec(\piano),
				).asPopUpMenu,
				nil,
			),
			HLayout (
				StaticText.new.string_("Instr:"),
				Param(
					model.proxy,
					\instrument -> \source, 
					TagSpecDef(\SynthDef_keys),
				).asPopUpMenu,
				nil,
			),
			HLayout (
				StaticText.new.string_("Arp:"),
				HLayout (
					Param(
						Message(model),
						\arpPreset, 
						TagSpecDef(\ArpPreset),
					).asPopUpMenu,
					PlayerWrapper(model.arpProxy).asView.fixedWidth_(20).label_(""),
				).margins_(0).spacing_(0),
				nil,
			),
			nil
		).margins_(0).spacing_(10),
		pgView,
		WindowDef(\TimelinePianoKeyboard).embedView(def, model.playerGroup).minHeight_(50)
	)
}).front(ProtoTemplateDef(\PianoCenter));
)
TagSpecDef(\ArpPreset).valueList
ProtoTemplateDef(\PianoCenter).proxy.play
ProtoTemplateDef(\PianoCenter).controller
ProtoTemplateDef(\PianoCenter).inArpMode
ProtoTemplateDef(\PianoCenter).arpPreset
ProtoTemplateDef(\PianoCenter).arpProxy.source
ProtoTemplateDef(\PianoCenter).arpProxy.play
~currentNotes.select(_.notNil)

~pg = ProtoTemplateDef(\SeqPlayerGroup).new(Pbindef(\PianoCenter))
~pg.elAt(60).play
Param(Message(ProtoTemplateDef(\PianoCenter)), \arpPreset, TagSpecDef(\ArpPreset))

(
Pdef(\basearp,
	Pbind(
		\dur, 1/8,
		\amp, 0.1,
		\idx, Pseq((0..3),inf),
		//\octaveshift, Pseq([0,0,-1,0,0,1],inf),
	)
);
TagSpecDef(\ArpPreset).addUnique(\basearp);
)


(
ProtoTemplateDef(\PianoCombinator, (
	combiList: [
		(source: nil, range: 0, target: nil),
		(source: nil, range: 0, target: nil),
		(source: nil, range: 0, target: nil),
		(source: nil, range: 0, target: nil),
	],

	proxy: { arg self;
		ProtoTemplateDef(\PianoCenter).proxy;
	},

	install: { arg self;
		self.combiList.do { arg item, idx;
			if(item.source.notNil and: { item.target.notNil }) {
				item.target.setRaw(Pfunc({ arg ev; 
					var sourceval = ev.use { currentEnvironment[item.source].value };
					var sourcespec = Param(self.proxy, item.source).spec;
					var targetspec = item.target.spec;



				}));

			};
			
		};
		
	},

	targetSpec: { arg self;
		TagSpec( self.proxy.asParamGroup.collect({ arg p; p.propertyRoot -> p }) )
	},

));
WindowDef(\PianoCombinator, { arg def, model;
	var sources = [
		nil,
		\freq,
		\velocity,
	];
	VLayout (
		* model.combiList.collect { arg item, idx;
			HLayout (
				Param(item, \source, TagSpec(sources)).asPopUpMenu,
				Param(item, \range, \bipolar).asSlider.orientation_(\horizontal),
				Param(item, \target, model.targetSpec).asPopUpMenu,
			)
		} ++ [nil];
		
	)
	
}).front(ProtoTemplateDef(\PianoCombinator));

)
