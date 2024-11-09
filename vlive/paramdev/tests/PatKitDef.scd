FileSystemProject.load("libdef/drumkit.scd");
FileSystemProject.load("libdef/synthplayrec.scd");
FileSystemProject.load("sndlib/buflib.scd");
ParamProto.init;
PatKitDef(\bla).edit
PatKitDef(\bla2).edit
PatKitDef(\bla3).edit
TagSpecDef(\BusDef_object).labelList


(
PatKitDef(\testme3).targets = [
	Pbind(
		\instrument, \saw,
		\freq, 200,
		\dur, 1,
		\amp, 0.1,
	),
	Pbind(
		\instrument, \default,
		\freq, Pseq([500,400],inf),
		\dur, 1,
		\amp, 0.1,
	),
];
PatKitDef(\testme3).edit;
)
PatKitDef(\testme1).presetCompileString.editorInsert
(
PatKitDef('testme3').targetsData = [
	( 'freq': 1425.5129668878 ),
	(  ),
];
);

(
PatKitDef('testme1').data = [
	( 'freq': 1425.5129668878 )
,
	(  )
,
];
);


(
Pdef(\testnest, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0,Pwhite(0,12,3)],inf),
		//\lpfr, 0.5,
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);

Pdef(\testnester, Pdef(\testnest)).play
Pdef(\testnester, Pdef(\testnest)).set(\lpfr, 1)
Pdef(\testnester).get(\lpfr)
Pdef(\testnest).get(\lpfr)

(
PatKitDef('testme5').data = [
	( 'out': 0, 'legato': 0.8, 'dur': 1.0, 'spread': 0.80000001192093, 
  'amp': 0.1, 'pan': 0.0, 'freq': 1016.0436093826, 'rq': 0.5, 'lpfr': 1.1000000238419, 
  'adsr': Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) )
,
	( 'out': 0, 'legato': 0.8, 'dur': 1.0, 'amp': 0.1, 
  'pan': 0.0, 'freq': 261.6255653006 )
,
];
);

(
PatKitDef(\testbuf2).targets = [
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.hat[1064].value,
		\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
		\isRest, Pseq([
			1,0,1,0, 1,0,1,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.11,
	),
];
PatKitDef(\testbuf2).edit;
)
PatKitDef(\testme4).targets[0]
PatKitDef(\testbuf4).targets[0].p
PatKitDef(\testme).clear
PatKitDef(\testme).targets[0].asParamGroup
TagSpecDef(\BufDef).unmapKey(Param(PatKitDef(\testbuf).targets[0].proxy, \bufnum).get)
TagSpecDef(\BufDef).unmapKey(123213)
Param(PatKitDef(\testbuf).targets[0].proxy, \bufnum).get
Param(PatKitDef(\testbuf).targets[0].proxy, \bufnum).spec.tagSpec.list
WindowDef(\win, { arg def;
Param(PatKitDef(\testbuf).targets[0].proxy, \bufnum).asValuePopUpMenu
	
}).front;

Param(PatKitDef(\testbuf4).targets[0].proxy, \bufnum).spec.isKindOf(TagSpec)
PatKitDef(\testme2).edit
PatKitDef(\testme2).targets[0]

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

Pdef(\zed).asParamGroup.getEventCompileString

/////////////////////////////////////////////
BusDef(\bla, \audio, 2)
(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5).clip(0.1,1));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpfr: ControlSpec(0.1,4,\lin, 0, 1),
	rq: ControlSpec(0.1,0.9,\lin, 0, 0.5),
))).store;
)
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
