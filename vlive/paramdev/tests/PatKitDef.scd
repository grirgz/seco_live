
(
WindowDef(\win, { arg def;
	Param({ arg x, v; x.postln;  }, { 1 }).asSlider;
}).front;
);
	Param({ Pbindef(\bla).source.at(\freq).source }, { arg p, v; Pbindef(\bla, \freq, p) }).get
	Param({ Pbindef(\bla).source.at(\freq).source }, { arg v, p; Pbindef(\bla).source.at(\freq).source = v }).edit
	(
	Pbindef(\bla,
		\freq, 100,
		\dur, 1/4,
	
	).play;
	)
	Pdef(\bla).quant=8;
	Pdef(\bla).source.at(\freq).quant = 0
	Pdef(\bla).clear

	Pbindef(\bla)
	Pdef(\bla).source

PatKitDef(\bla).edit
FileSystemProject.load("libdef/drumkit.scd")


/////////// test PchainProxy
// in Proto/player_groups.scd

~pc = ProtoInst(\PchainProxy, Pbind(\instrument, \playersec, \note, Pseq([0,2],inf)))
~pc.asPattern.play
~pc.asParamGroup.edit
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		~pc
		
	])
)).play;
);
ProtoInst(\PchainProxy).asPattern.play
ProtoInst(\PchainProxy).source
ProtoInst(\PchainProxy).pattern
ProtoInst(\PchainProxy).class
ProtoInst(\PchainProxy).protoClass


/////////
(
ControllerDef(\piano_launcher, { arg def, targetList, offset=60; 
		var playergroup;
		playergroup = ProtoTemplateDef(\ParPlayerGroup).new(targetList);
		MIDIdef.noteOn(\piano, { arg ... args;
			var midinote = args[1];
			args.debug("generic on");
			playergroup.elAt(midinote-offset).play;
		}).fix;
		MIDIdef.noteOff(\piano_off, { arg ... args;
			var midinote = args[1];
			args.debug("generic off");
			playergroup.elAt(midinote-offset).stop;
		}).fix;
}, [ \launcherline ]);
)


(
~group = 
ControllerDef(\piano_launcher).startControl(~group);
)

~pg = ProtoTemplateDef(\ParPlayerGroup).new(~group)
~pg.elAt(0).play
~pg.elAt(0).stop


(
PatKitDef(\barrykit7, 32.collect { arg idx;
	Pbind(
		\instrument, \playersecmax,
		\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
		\legato, 1,
		\st, 85/2/60,
		\pos, idx/8+0.6/Pkey(\st),
		\maxsustain, 0.2,
		\dur, 1/8,
		\gain, 1/4,
	)
});
)
PatKitDef.protoClass

PatKitDef(\barrykit).elAt(0).play
PatKitDef(\barrykit7).edit
PatKitDef(\barrykit7).presetCompileString
KitTimeline(\kit1, PatKitDef(\barrykit)).edit
