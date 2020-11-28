// seems not used

(
WindowDef(\embedmixer, { arg def, busparam;
	var menuspec;
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

	menuspec = MenuSpec( ProtoDef(\simpleMixer).tracks.collect({ arg track; track.inbus.key -> track.inbus.index }).debug("list") );
	busparam = busparam.copy;
	busparam.spec = menuspec;
	VLayout (
	busparam.asView,
	WindowDef(\embedmixer_helper, { arg def, mixer;
		mixerView.(mixer)
	}).onChange(busparam.target.receiver, \set, { arg me;
		"hkhk".debug;
		//mais pourquoi ???????? :((((((((((
		//me.updateView(
		//	ProtoDef(\simpleMixer).tracks[ menuspec.unmapIndex( busparam.get ) ]
		//)
	}).asView(ProtoDef(\simpleMixer).tracks[ menuspec.unmapIndex( busparam.get ) ])
		
	);
}).front(Param(Message(ProtoDef(\rdn)), \outBus));
)

ProtoDef(\rdn).outBus = BusDef(\mixer0)
ProtoDef(\rdn).outBus
ProtoDef(\rdn).clear
ProtoDef(\rdn).edit
ProtoDef(\rdn).changed(\set)
ProtoDef(\rdn, ProtoTemplateDef(\rdn))
ProtoDef(\simpleMixer).tracks[0].inbus.key
ProtoDef(\simpleMixer).edit

Param(Message(ProtoDef(\rdn)), \outBus).target.class.dumpAllMethods
