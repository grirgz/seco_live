
(

	// define channels
	Pdef(\kick, Pbind(
		\gain, 1/2,
		\out, BusDef(\mixer0, \audio),
	));
	Pdef(\snare, Pbind(
		\gain, 1/2,
		\out, BusDef(\mixer1, \audio),
	));
	Pdef(\hat, Pbind(
		\gain, 1/3,
		\out, BusDef(\mixer2, \audio),
	));
	Pdef(\bass, Pbind(
		\out, BusDef(\mixer3, \audio),
	));
	Pdef(\pad, Pbind(
		\out, BusDef(\mixer4, \audio),
	));
	Pdef(\piano, Pbind(
		\out, BusDef(\mixer5, \audio),
	));
);


	ProtoDef(\rdn).loadDefaultPreset;
	ProtoDef(\rdn).genfx;
	ProtoDef(\rdn).edit;
(
	FileSystemProject.load("capsule/lib.scd");
	~t = 135/4/60; TempoClock.default.tempo = ~t;

	ProtoDef(\simpleMixer).tracks[0].proxy.set(\send0, 1);
	ProtoDef(\simpleMixer).tracks[1].proxy.set(\send0, 1);
	ProtoDef(\simpleMixer).tracks[2].proxy.set(\send0, 1);
	ProtoDef(\rdn).outBus = BusDef(\mixer7);
	ProtoDef(\rdn).inBus = BusDef(\sendbus1);

	7.do { arg idx;
		ProtoDef(\simpleMixer).tracks[idx].proxy.set(\prefader, 1);
		ProtoDef(\simpleMixer).tracks[idx].proxy.set(\postdelay, 0.04);
	};

	~master = {
		ProtoDef(\simpleMixer).play;
		ProtoDef(\rdn).play;
		Ndef(\drumgroup, \busgroup).set(\inbus, BusDef(\sendbus0)).play(BusDef(\mixer6).index, 2);
	};

	~icon_map_param = { arg input, param;
		var last = thisThread.beats;
		input.action = { arg kn, val; 
			var now = thisThread.beats;
			if(now.isNil or: { ( now - last ).abs > 0.1 }) {
				thisThread.beats.debug("beats");
				param.normSet(kn.value);
				last = now;
			};
		} 
	};

		~startControl_mixer = {
			var k = MKtl('icon', "icon-icontrols");
			k[\sl].do({ arg knob, idx; 
				~icon_map_param.(
					knob,
					ProtoDef(\simpleMixer).tracks[idx].asParam(\postfader)
				)
			});
			k[\kn].do({ arg knob, idx; 
				~icon_map_param.(
					knob,
					ProtoDef(\simpleMixer).tracks[idx].asParam(\send1)
				)
			});

		};
		~startControl_rdn = {
			var k = MKtl('icon', "icon-icontrols");
			var params = [
				\fb,
				\delay,
				\delay2,
				\delay3,

				\distamp,
				\distamp2,
				\distamp3,
				\shiftmix,
				\shift,
			].collect({ arg key;
				Param(ProtoDef(\rdn).proxy, key)
			});
			//params = params ++ [ Param(s, \volume) ];
			params.do({ arg param, idx; 
				k[\sl][idx].action = { arg kn, val; 
					params[idx].normSet(kn.value)
				} 
			});
		};
	~startControl = {
		var k = MKtl('icon', "icon-icontrols");
		~startControl_mixer.();
		k[\tr][0][\on].action = {
			"Mixer mode".debug;
			~startControl_mixer.();
		};
		k[\tr][1][\on].action = {
			"Fx mode".debug;
			~startControl_rdn.();
		};

	};


);

// END

~startControl.();
