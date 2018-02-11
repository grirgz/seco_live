(
ParamProto.init;

ProtoDef(\simpleMixer, (

	trackCount_: { arg self, val;
		self[\trackCount] = val;

		self.tracks = self.trackCount.collect { arg index;
			var mix = ~trackMixerDef.new(\mixer+++index);
			debug("create mixer: "++index);

			mix.inbus = BusDef(\mixer+++index, \audio, 2);
			mix.define_mixer;
			mix.stages[\postdelay] = mix.stages.postfx+1;
			mix.proxy.put(mix.stages.postdelay, \filter -> { arg in, postdelay=0;
				DelayC.ar(in, 0.1, postdelay);
			});
			4.do { arg x;
				mix.proxy.set(\sendbus+++x, BusDef(\sendbus+++x, \audio, 2));
			};

			mix;
		}
	},

	init: { arg self;
		//if(self.initialized.isNil) {
			self.trackCount = 10;
			self.initialized = true;
		//}
	},

	edit: { arg self;
		WindowDef(\simpleMixer).front(ProtoDef(\simpleMixer));
	},

	play: { arg self;
		self.tracks.do(_.play);
		self.sidePlayers.do(_.play);
		self;
	},

	stop: { arg self;
		self.tracks.do(_.stop);
		self.sidePlayers.do(_.stop);
		self;
	},

));
ProtoDef(\simpleMixer).init;

WindowDef(\simpleMixer, { arg def, simpleMixer;
	var mixerView = { arg mixer;
		var param;
		var sends = [];
		var layout;
		var slider, knobs = List.new, textfield;
		layout = VLayout(
			HLayout(
				VLayout (
					slider = Slider.new.orientation_(\vertical),
					textfield = TextField.new,
				),
				VLayout(*
					knobs = 4.collect({ 
						Knob.new;
					})
				)
			)
		);
		layout.addUniqueMethod(\model_, { arg me, mixer;
			if(mixer.isKindOf(Volume)) {
				"volume".debug;
				param = Param(mixer, \volume);
				sends = 4.collect({ arg x; nil });
			} {
				"mixer".debug;
				param = mixer.asParam(\postfader);
				sends = 4.collect({ arg x; mixer.asParam(\send+++x) });
			};
			[slider, param].debug("slider, param: what ?");
			slider.mapParam(param);
			textfield.mapParam(param);
			knobs.do({ arg x, idx; x.mapParam(sends[idx]) })
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
			delayview = TextField.new;
			delayview.mapParam( Param(mixer.proxy, \postdelay, ControlSpec(0,0.1,\lin)) );
			boxview.layout = VLayout (
				PlayerWrapper(mixer.proxy).label_(mixer.key).asView,
				mixerview = mixerView.(mixer),
				HLayout(StaticText.new.string_("postdelay:"), delayview),
			);
			boxview.background = Color.gray;
			mixerview.slider.minWidth_(10);
			boxview.maxWidth_(260);
			boxview.addUniqueMethod(\model_, { arg me, val;
				mixerview.model = val;
			});
			boxview;
	});

	HLayout(* mixers);
});
//WindowDef(\simpleMixer).front(ProtoDef(\simpleMixer));
)

// END
/////////////////////////////////////////////

ProtoDef(\simpleMixer).clear
ProtoDef(\simpleMixer).postAllMethods
ProtoDef(\simpleMixer).tracks[0].key
ProtoDef(\simpleMixer).tracks[0].inbus




ProtoDef(\simpleMixer).play
ProtoDef(\simpleMixer).tracks[0].proxy.edit
ProtoDef(\simpleMixer).tracks[0].inbus
ProtoDef(\simpleMixer).tracks[0].define_mixer
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

