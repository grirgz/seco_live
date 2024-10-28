
p = ProxySpace.new;
p.push;

~osc1 = { arg freq=100; SinOsc.ar(freq) * 0.1 ! 2  };
~osc1.play;
currentEnvironment

Param(~osc1, \freq).edit;
~osc1.asParamGroup.edit;
~osc1.edit

~osc1 = { arg freq=100; SinOsc.ar(freq * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 )) * 0.1 ! 2  };

ParamProto.init
"")
"~/.local/share/SuperCollider/Extensions/param/Proto/GlobalLibrary.scd".standardizePath.load
FileSystemProject.load("~/.local/share/SuperCollider/Extensions/param/Proto/GlobalLibrary.scd")
FileSystemProject.load("~/.local/share/SuperCollider/Extensions/param/Proto/editors.scd")
PlayerWrapper(~osc1).edit
(
WindowDef(\win, { arg def;

	PlayerWrapper(~osc1).asView
	
}).front;
)
PlayerWrapper(~osc1).label.asCompileString
Pdef(\)
(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
	)
)
);

PlayerWrapper(Pdef(\melo)).edit
