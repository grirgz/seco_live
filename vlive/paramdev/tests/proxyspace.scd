

p = ProxySpace.new;
p.push;

~osc1 = { arg freq=100; SinOsc.ar(freq) * 0.1 ! 2  };
~osc1.play;
currentEnvironment

Param(~osc1, \freq).edit;
~osc1.asParamGroup.edit;
~osc1.edit

~osc1.addSpec(\freq, ControlSpec(90,301,\lin))

~osc1 = { arg freq=100; SinOsc.ar(freq * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 )) * 0.1 ! 2  };

ParamProto.init;

PlayerWrapper(~osc1).edit
(
WindowDef(\win, { arg def;

	PlayerWrapper(~osc1).asView
	
}).front;
)
