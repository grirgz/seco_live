(
ParamProto.init;

ProtoTemplateDef(\simpleMixer, (

	sendCount: 8,
	trackCount_: { arg self, val;
		var sendcount = self.sendCount;
		self[\trackCount] = val.asInteger;

		self.tracks = self.trackCount.collect { arg index;
			// trackMixerDef is defined in Param/proto/TrackMixerDef
			var mix = ~trackMixerDef.new(\mixer+++index);
			debug("create mixer: "++index);

			mix.inbus = BusDef(\mixer+++index, \audio, 2);
			mix.define_mixer;
			mix.stages[\postdelay] = mix.stages.postfx+1;
			mix.proxy.put(mix.stages.postdelay, \filter -> { arg in, postdelay=0;
				DelayC.ar(in, 0.1, postdelay);
			});
			sendcount.do { arg x;
				mix.proxy.set(\sendbus+++x, BusDef(\sendbus+++x, \audio, 2));
			};

			mix;
		};

		sendcount.do { arg idx;
			self[\sendbus +++ idx] = { arg self;
				self.tracks.first.proxy.get(\sendbus+++idx)
		   	};
			self[\sendbus +++ idx +++ '_'] = { arg self, val;
				self.tracks.do({ arg track;
					track.proxy.set(\sendbus+++idx, val);
				})
		   	}
		};


	},

	clearAll: { arg self;
		self.tracks.do { arg track;
			track.proxy.clear;
			track.clear;
		};
		self.clear;
	},

	init: { arg self;
		//if(self.initialized.isNil) {
			self.trackCount = 10;
			self.initialized = true;
		//}
	},

	edit: { arg self;
		if(self.key != \simpleMixer) {
			WindowDef(self.key, WindowDef(\simpleMixer)).front(self);
		} {
			WindowDef(\simpleMixer).front(self);
		};
	},

	play: { arg self;
		self.tracks.do(_.play);
		self.sidePlayers.do(_.play);
		self;
	},
	
	isPlaying: { arg self;
		self.tracks.notNil 
			and:{ self.tracks.every({ arg tr; PlayerWrapper(tr.proxy).isPlaying  })
			and:{ self.sidePlayers.isNil or: {self.sidePlayers.every(_.isPlaying);
		}}}
	},

	stop: { arg self;
		self.tracks.do(_.stop);
		self.sidePlayers.do(_.stop);
		self.changed(\isPlaying);
		self;
	},

	nullbus: { arg self;
		BusDef(\null, \audio, 2);
	},

	presetCompileString: { arg self;
		"%\n\n%".format(
			"%.trackCount = %;".format(self.refCompileString, self.trackCount),
			self.tracks.collect({ arg track, idx;
				track.asParamGroup.getSetCompileString("%.tracks[%]".format(self.refCompileString, idx))
				++
				"%.tracks[%].outBus = %;".format(self.refCompileString, idx, track.outbus.asCompileString);
			}).join("\n\n")
		);
	},

	refCompileString: { arg self;
		self.asCompileString
	},

	savePresetCompileString: { arg self, path, onDoneAction;
		[self.presetCompileStringSavePath, path].debug("trying to save mixerr");
		if(File.exists(self.presetCompileStringSavePath).not or: {self.loadedFromPath == self.presetCompileStringSavePath}) {
			File.mkdir(self.presetCompileStringSavePath);
			self.loadedFromPath = self.presetCompileStringSavePath;
			path = path ? (self.presetCompileStringSavePath +/+ "TrackDef_%.scd".format(self.key));
			PlayerWrapper_Base.savePresetCompileStringHelper(path, onDoneAction, self.refCompileString, self.presetCompileString, false);
			self.children.do({ arg column;
				column.savePresetCompileString;
			});
			self.resources.do { arg res;
				PlayerWrapper(res).savePresetCompileString;
			}; 
			Log(\Param).info("TrackList % saved.", self.key);
		} {
			"savePresetCompileString: can't save on existing project".error;
		}
	},
));
ProtoDef(\simpleMixer, ProtoTemplateDef(\simpleMixer)).init;
	//ProtoDef(\simpleMixer).stop;
	//ProtoDef(\simpleMixer).changed(\isPlaying, false)
	//ProtoDef(\simpleMixer).tracks[0].proxy.isPlaying
	//PlayerWrapper(ProtoDef(\simpleMixer).tracks[0]y).isPlaying
	//ProtoDef(\simpleMixer).play;

WindowDef(\simpleMixer, { arg def, simpleMixer;
	var mixerView = { arg mixer;
		var sendKnobCount = 8;
		var param;
		var sends = [], allsends = [];
		var layout;
		var slider, knobs = List.new, textfield;
		var stack;
		var meterin = SimpleServerMeterView(nil, 0,2, mixer.inbus.debug("out"));
		var meterout = SimpleServerMeterView(nil, 0,2, mixer.outbus.debug("out"));
		slider = Slider.new.orientation_(\vertical).background_(Color.clear);


		stack = StackLayout(
			slider, 
			meterin.view,
			// FIXME: no way to make ticks less wide, so with both in and out displayed, meter is too small
			//View.new.layout_(HLayout (
				//meterin.view,
				//meterout.view,
			//).spacing_(0).margins_(0))
		).mode_(\stackAll);
		layout = VLayout(
			HLayout(
				VLayout (
					//slider,
					stack,
					textfield = TextField.new,
				),
				VLayout(*
					knobs = sendKnobCount.collect({ 
						Knob.new;
					})
				)
			)
		);
		layout.addUniqueMethod(\model_, { arg me, mixer;
			if(mixer.isKindOf(Volume)) {
				"volume".debug;
				param = Param(mixer, \volume);
				sends = simpleMixer.sendCount.collect({ arg x; x -> nil });
			} {
				"mixer".debug;
				param = mixer.asParam(\postfader);
				allsends = simpleMixer.sendCount.collect({ arg x; x -> mixer.asParam(\send+++x) });
				sends = allsends.select{ arg assoidx;
					var idx = assoidx.key;
					var bus = simpleMixer[\sendbus +++ idx].value(simpleMixer);
					bus != simpleMixer.nullbus
				};
			};
			//[slider, param].debug("slider, param: what ?");
			slider.mapParam(param);
			textfield.mapParam(param);
			knobs.do({ arg k, idx; 
				var send = sends[idx] ?? { allsends[idx] }; 
				k.mapParam(send.value); 
				k.toolTip = "%: %".format(send.key, simpleMixer[\sendbus +++ send.key].value(simpleMixer));
			})
		});
		if(mixer.notNil) {
			layout.model = mixer;
		};
		layout.addUniqueMethod(\slider, { slider });
		layout.addUniqueMethod(\textfield, { textfield });
		layout.addUniqueMethod(\knobs, { knobs });
		layout;

	};

	var mixers = simpleMixer.tracks.collect({ arg mixer, x;
			var boxview = View.new;
			var delayview;
			var mixerview;
			boxview.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
				if(buttonNumber == 1) {
					WindowDef(\SimpleMixerOverlayMenu).front(simpleMixer, boxview, x, y);
				};
			});
			delayview = TextField.new;
			delayview.mapParam( Param(mixer.proxy, \postdelay, ControlSpec(0,0.1,\lin)) );
			boxview.layout = VLayout (
				PlayerWrapper(mixer.proxy).label_(mixer.key).asView,
				mixerview = mixerView.(mixer),
				HLayout(StaticText.new.string_("postdelay:"), delayview),
				Param(Message(mixer), \outbus,TagSpecDef(\BusDef)).asPopUpMenu.minWidth_(60).addAction({ 
					mixer.play;
					"kjkj".postln
			   	}),
			);
			boxview.background = Color.gray;
			mixerview.slider.minWidth_(10);
			boxview.maxWidth_(260);
			boxview.addUniqueMethod(\model_, { arg me, val;
				mixerview.model = val;
			});
			boxview;
	});

	def.windowName = simpleMixer.key ? "simpleMixer";

	HLayout(* mixers);
});

WindowDef(\SimpleMixerOverlayMenu, { arg def, model, view, x=600, y=600;
	var inview, layout;
	var sends;
	[x, y].debug("xy");
	def.windowDo { arg win;
		var ab = view !? {view.absoluteBounds} ? Rect(0,0,600,600);
		win.bounds = Rect(x+ab.origin.x, Window.screenBounds.height - ab.top - y, 300,100);
		win.endFrontAction = { win.close };
	};
	inview = View.new;

	sends = 8.collect({ arg idx;
		HLayout(
			StaticText.new.string_("send %".format(idx)),
			Param(Message(model), "%%".format(\sendbus, idx).asSymbol, TagSpecDef(\BusDef_object)).asPopUpMenu,
		)

	});

	layout = VLayout (
		PlayerWrapper(model).asView,
		HLayout(
			StaticText.new.string_("Track count:"),
			Param(Message(model), \trackCount, ControlSpec(1,16,\lin,1)).asNumberBox,
		),
		VLayout(
			*sends
		),
		nil
	);
	//def.windowDo { arg win;
		//win.setInnerExtent(view.bounds.extent.min(20));
	//};
	inview.layout_(layout);
	
}).border_(false);
//WindowDef(\simpleMixer).front(ProtoDef(\simpleMixer));


BusDef(\sendbus0, \audio, 2);
BusDef(\sendbus1, \audio, 2);
BusDef(\sendbus2, \audio, 2);
BusDef(\sendbus3, \audio, 2);
BusDef(\sendbus4, \audio, 2);
BusDef(\sendbus5, \audio, 2);
BusDef(\sendbus6, \audio, 2);
BusDef(\sendbus7, \audio, 2);
BusDef(\sendbus8, \audio, 2);
BusDef(\sendbus9, \audio, 2);
BusDef(\null, \audio, 2); // use it to discard audio

)

// END
/////////////////////////////////////////////

WindowDef(\simpleMixer).front(ProtoDef(\simpleMixer));
ProtoDef(\simpleMixer).clear
ProtoDef(\simpleMixer).clearAll;
ProtoDef(\simpleMixer).postAllMethods
ProtoDef(\simpleMixer).tracks[0].key
ProtoDef(\simpleMixer).tracks[0].inbus
ProtoDef(\simpleMixer).presetCompileString



ProtoDef(\simpleMixer).tracks[0].asParamGroup.getSetCompileString

ProtoDef(\simpleMixer).play
ProtoDef(\simpleMixer).tracks[0].proxy.edit
ProtoDef(\simpleMixer).tracks[0].inbus
ProtoDef(\simpleMixer).tracks[0].define_mixer
ProtoDef(\simpleMixer).tracks[0].inbus
ProtoDef(\simpleMixer).tracks[0].proxy.edit
ProtoDef(\simpleMixer).tracks[0].proxy
ProtoDef(\simpleMixer).tracks[0].play
ProtoDef(\simpleMixer).tracks[0].proxy.play
ProtoDef(\simpleMixer).tracks[0].proxy.stop
ProtoDef(\simpleMixer).tracks[0].proxy.end
ProtoDef(\simpleMixer).tracks[0].proxy.play(0,2)
ProtoDef(\simpleMixer).tracks[0].proxy.play(BusDef(\mixer2,\audio).index,2)
ProtoDef(\simpleMixer).tracks[0].stop
ProtoDef(\simpleMixer).tracks[1].stop
ProtoDef(\simpleMixer).tracks[1].play
ProtoDef(\simpleMixer).tracks[2].play
ProtoDef(\simpleMixer).tracks[2].stop
Ndef
ProtoDef(\simpleMixer).tracks[0].proxy.inspect
ProtoDef(\simpleMixer).tracks[0].proxy.monitor.inspect
ProtoDef(\simpleMixer).tracks[1].inbus
ProtoDef(\simpleMixer).tracks[5].proxy.get(\inbus)
ProtoDef(\simpleMixer).tracks[0].outbus
BusDef(\mixer0).index
BusDef(\mixer5).index
BusDef(\mixer1).index
BusDef(\mixer5).play
ProtoDef(\simpleMixer).edit
BusDef(\mixer0).scope
BusDef(\mixer0).play
BusDef(\mixer0).stop

ServerTree.add({ ProtoDef(\simpleMixer).play })


(
Pdef(\ixo, Pbind(
	\instrument, \default,
	\degree, Pseq([0,2,4,12],inf) + [0,2],
	\out, BusDef(\mixer0),
	\dur, 1/2,
	\amp, 0.1
)).play;
);

