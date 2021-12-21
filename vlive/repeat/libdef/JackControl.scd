
(
ProtoTemplateDef(\JackControl, (
	connection_SystemToSupercollider_: { arg self, val;
		if(val == true) {
			"jack_connect \"PulseAudio JACK Sink:front-left\" SuperCollider:in_1".unixCmd;
			"jack_connect \"PulseAudio JACK Sink:front-right\" SuperCollider:in_2".unixCmd;
		} {

			"jack_disconnect \"PulseAudio JACK Sink:front-left\" SuperCollider:in_1".unixCmd;
			"jack_disconnect \"PulseAudio JACK Sink:front-right\" SuperCollider:in_2".unixCmd;
		}
	},
	connection_SystemToSupercollider: { arg self;
		"jack_lsp -c  SuperCollider:in_1 | grep front-left".unixCmdGetStdOutLines.size >= 1;
	},

	connection_SystemToSpeakers_: { arg self, val;
		if(val == true) {
			"jack_connect \"PulseAudio JACK Sink:front-left\" system:playback_1".unixCmd;
			"jack_connect \"PulseAudio JACK Sink:front-right\" system:playback_2".unixCmd;
		} {
			"jack_disconnect \"PulseAudio JACK Sink:front-left\" system:playback_1".unixCmd;
			"jack_disconnect \"PulseAudio JACK Sink:front-right\" system:playback_2".unixCmd;
		}
	},
	connection_SystemToSpeakers: { arg self;
		"jack_lsp -c  system:playback_1 | grep front-left".unixCmdGetStdOutLines.size >= 1;
	},

));

Ndef(\soundin, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SoundIn.ar([0,1]);
	sig = sig * \gain.kr(1);
	Out.ar(0, sig * \monitor.kr(0));
	sig;
	//sig = sig * ( LFSaw.kr( LFNoise0.kr(1).unipolar * 5600 ) * 1 + 1 );
}).play(BusDef(\soundin, \audio, 2).index, 2);
Ndef(\soundin).end;

WindowDef(\InputManager, { arg def;
	HLayout (
		VLayout (
			PlayerWrapper(Ndef(\soundin)),
			Param(Message(ProtoTemplateDef(\JackControl)), \connection_SystemToSupercollider, ParamBoolSpec()).asButton("System to SuperCollider"),
			Param(Message(ProtoTemplateDef(\JackControl)), \connection_SystemToSpeakers, ParamBoolSpec()).asButton("System to speakers"),
			Param(Ndef(\soundin), \monitor, ControlSpec(0,1,\lin,0,0)).asButton("Monitor"),
			nil,
		),
		VLayout (
			Param(Ndef(\soundin), \gain, ControlSpec(0,4,\lin,0,1)).asSlider,
			Param(Ndef(\soundin), \gain, ControlSpec(0,4,\lin)).asTextField(3),
		),
		SimpleServerMeterView(nil, 2,2).minWidth_(70),
		SimpleServerMeterView(nil, 0,2, BusDef(\soundin, \audio, 2)).minWidth_(50),
	)
});

);
