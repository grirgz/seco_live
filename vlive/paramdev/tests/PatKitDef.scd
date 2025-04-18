FileSystemProject.load("libdef/drumkit.scd");
FileSystemProject.load("libdef/synthplayrec.scd");
FileSystemProject.load("sndlib/buflib.scd");
ParamProto.init;
PatKitDef(\bla4).edit
PatKitDef(\bla4).childAt(0).targetData.envir
SynthDesc(\playersec)
Pdef(\xx4, Pbind()).get(\instrument)
Pdef(\xx4, Pbind()).envir[\instrument]
Pdef(\xx4, Pbind()).envir
Pdef(\xx4).envir
Pdef(\xx4).set(\bla, 1)
~p = Param(Pdef(\xx2), \instrument)
~p.default
~p = Param(PatKitDef(\bla2).childAt(10).targetData, \instrument, TagSpecDef(\SynthDef_keys))
~p.default = \playersec
~p.default
~p.getRaw
PatKitDef(\bla2).childAt(10).targetData.envir
TagSpecDef(\SynthDef_keys).default
PatKitDef(\bla).childAt(0).targetData.envir.size
EventPatternProxy.new.envir.size
PatKitDef(\bla3).edit
PatKitDef(\bla10).edit
PatKitDef(\bla9).childAt(40).targetData
PatKitDef(\bla9).childAt(40).target
PatKitDef(\bla9).childAt(40).pattern
PatKitDef(\bla9).childAt(40).isEmpty
PatKitDef(\bla9).childAt(40).addHalo(\bla, 3)
PatKitDef(\bla3).childAt(0).targetData.source.
PatKitDef(\bla8).edit
TagSpecDef(\BusDef_object).labelList


(
PatKitDef(\testme6).targets = [
	Pbind(
		\instrument, \saw,
		\freq, 200,
		\dur, 1,
		\rq, 0.9,
		\lpfr, 3,
		\amp, 0.1,
	),
	Pbind(
		\instrument, \default,
		\freq, Pseq([500,400],inf),
		\dur, 1,
		\amp, 0.1,
	),
];
PatKitDef(\testme6).edit;
)
PatKitDef(\testme5).childAt(0).target.source.pairs
PatKitDef(\testme5).targets[0].pairs

Pbind(\bla, 1).pairs

PatKitDef(\testme)


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
		\pos, idx/8+0.61/Pkey(\st),
		\maxsustain, 0.2,
		\dur, 1/8,
		\gain, 1/4,
	)
});
)

(
PatKitDef(\barrykit7, 32.collect { arg idx;
	Pbind(
		\instrument, \playersecmax,
		\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
		\legato, 1,
		\st, 85/2/60,
		\pos, idx/4+0.61/Pkey(\st),
		\maxsustain, 0.2,
		\dur, 1/8,
		\gain, 1/4,
	)
});
)
(
PatKitDef(\moetenkit, 32.collect { arg idx;
	Pbind(
		\instrument, \playersecmax,
		//\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
		\bufnum, BufDef.stereo(\moeten, "voices/02_moeten.flac"),
		\legato, 1,
		\st, 85/2/60,
		\maxsustain, 1/4/Pkey(\st),
		\pos, Pkey(\maxsustain)*idx,
		\dur, 1/8,
		\gain, 1/4,
	)
});
)
PatKitDef.protoClass

PatKitDef(\barrykit).elAt(0).play
PatKitDef(\barrykit7).edit
PatKitDef(\barrykit7).presetCompileString
PatKitDef(\barrykit7).patterns
PatKitDef(\barrykit7).asPattern(KitTimeline(\kit1).eventList.asPattern).play
PatKitDef(\moetenkit).edit
KitTimeline(\kit1, PatKitDef(\barrykit7)).edit
KitTimeline(\kit1).eventList[1].kitIndex = 0
KitTimeline(\kit2).eventList
KitTimeline(\kit1).kit
KitTimeline(\kit1).wrapper.preChain
KitTimeline(\kit1).preChain
KitTimeline(\kit1).postChain
KitTimeline(\kit1).composeParamPattern
KitTimeline(\kit1)[\asPattern].asCompileString
KitTimeline(\kit1).composeParamPattern
KitTimeline(\kit1).kit
~s = KitTimeline(\kit1).kit[0].asStream
~s = PatKitDef(\barrykit7).childAt(0).pattern.asStream
~s = PatKitDef(\barrykit7).childAt(0).target.asStream
PatKitDef(\barrykit7).childAt(0).target
KitTimeline(\kit1).play
~pat.play
~pat.streamDict
~pat.dictNext(0)
~s = ~pat.dictStream(0)
~s = ~pat.asStream
~s = KitTimeline(\kit1).asPattern.asStream
~s.next(())
KitTimeline(\kit2, PatKitDef(\moetenkit)).edit
~t = 185/2/60; TempoClock.default.tempo = ~t;
PdrumStep
(KitTimeline(\kit1).postChain <> PdrumStep(KitTimeline(\kit1).kit, KitTimeline(\kit1).eventList.asPattern, 1, key:\kitIndex)).play
~p = PdrumStep(KitTimeline(\kit1).kit, KitTimeline(\kit1).eventList.asPattern, 1, key:\kitIndex)
~p.dictNext(0)


(
	Pdef(\zed, 
		PdrumStep([
			Pbind(
				\instrument, \saw,
				\freq, 200,
				\dur, 1,
				\rq, 0.9,
				\lpfr, 3,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \default,
				\freq, Pseq([500,400],inf),
				\dur, 1,
				\amp, 0.1,
			),
		], Pbind(
			\kitIndex, Pseq([1,0],inf),
			\dur, 1,
			\amp, 0.1,
		), key:\kitIndex)
	).play;
)


/////////////////////


(
FileSystemProject.load("libdef/drumkit.scd");
FileSystemProject.load("libdef/synthplayrec.scd");
PatKitDef(\barrykit7, 32.collect { arg idx;
	Pbind(
		\instrument, \playersecmax,
		\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
		\legato, 1,
		\st, 85/2/60,
		\pos, idx/4+0.61/Pkey(\st),
		\maxsustain, 0.2,
		\dur, 1/8,
		\gain, 1/4,
	)
});

KitTimeline('kit1').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.125, \kitIndex: 0.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.125, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.375, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 0.625, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
KitTimeline(\kit1, PatKitDef(\barrykit7));
)

KitTimeline(\kit1).edit
KitTimeline(\kit1).play
KitTimeline(\kit1).composeParamPattern

~s = ~pat.dict[0].asStream
~s = ~pat.asStream
~s = ~pat.dictStream(0).asStream
~pat.dictStream(0).next(())
~s.next(())
~pat.streamDict
~pat.dictNext(0)

~pat.


KitTimeline(\bla).edit
KitTimeline(\bla).wrapper.presetCompileString.editorInsert

maxIndex
PatKitDef(\aze2).edit
PatKitDef(\aze2).childAt(0).targetData
PatKitDef(\aze2).childAt(0).targetDataProxy
PatKitDef(\aze2).getTargetDataProxy(0)
PatKitDef(\aze2).childAt(3).isEmpty
PatKitDef(\aze2).childAt(3).target.source.patternpairs
PatKitDef(\aze2).childAt(3).target.envir
PatKitDef(\aze2).childAt(3).pattern.stop
PatKitDef(\aze2).childAt(3).play
PatKitDef(\aze3).edit
PatKitDef(\aze3).targetData
PatKitDef(\aze2).patterns[3] = nil
PatKitDef(\aze2).childAt(3).targetData.envir
PatKitDef(\aze2).childAt(3).targetData.source.patternpairs
FileSystemProject.load("repeat/capsule/PatKitDef_rim.scd")
FileSystemProject.load("repeat/capsule/PatKitDef_ksh.scd")
PatKitDef(\aze2).presetCompileString.editorInsert
(
PatKitDef('aze2').targetsData = [
	('gain': 0.29546471291645, 'pos': 0.88786848072562, 'speed': 0.60838154979432, 'instrument': 'playersec', 'bufnum': BufDef('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'), 'sustain': 0.12950113378685),
	('gain': 0.29546471291645, 'pos': 3.5588662131519, 'speed': 1.2083815497943, 'instrument': 'playersec', 'bufnum': BufDef('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'), 'sustain': 0.066530612244898),
];
);

(
);

PatKitDef(\aze1).getTargetData(0)
PatKitDef(\aze1).presetCompileString
(
PatKitDef('aze1').targetsData = [
	('gain': 0.29546471291645, 'pos': 3.5588662131519, 'speed': nil, 'instrument': 'playersec', 'bufnum': 0, 'sustain': 0.8),
	('gain': 0.29546471291645, 'pos': 3.5588662131519, 'speed': nil, 'instrument': 'playersec', 'bufnum': 0, 'sustain': 0.8),
];
);

PatKitDef(\aze1).childAt(0).play
PatKitDef(\aze1).childAt(0).stop
PatKitDef(\aze1).clearChild(0)
PatKitDef(\aze1).setTargetData(0, ())
PatKitDef(\aze1).getTargetData(0)
PatKitDef(\aze1).edit

PatKitDef(\aze2).clearChild(1)
PatKitDef(\aze2).childAt(1).pattern.play
PatKitDef(\aze2).childAt(1).play
PatKitDef(\aze2).childAt(1).stream.nextN(5,())
PatKitDef(\aze2).childAt(1)[\play].asCompileString
PatKitDef(\aze2).childAt(1).reboot
~pat.source
~pat.play
PatKitDef(\aze2).childAt(1).stream
PatKitDef(\aze2).childAt(1).preChain
PatKitDef(\aze2).children[1] = nil
PatKitDef(\aze2).getTargetData(1)
PatKitDef(\aze2).getTarget(1).patternpairs
PatKitDef(\aze2).getPattern(1).source.patterns.first.source.patternpairs
PatKitDef(\aze2).getPattern(1).source.patterns.last.envir

PatKitDef(\aze3).targets = [Pbind()]
PatKitDef(\aze3).targetsData = [(\instrument: \saw)]
PatKitDef(\aze3).lastChildIndex


PatKitDef(\aze4).childAt(0).play;


PatKitDef(\aze4).edit
PatKitDef(\aze4).setTarget(0, PatKitDef(\aze1).childAt(0).target.copy)
PatKitDef(\aze4).setTargetData(0, PatKitDef(\aze1).childAt(0).targetData.copy)
PatKitDef(\aze4).getPattern(0)
PatKitDef(\aze4).pasteChild(0, PatKitDef(\aze1).childAt(1))
PatKitDef(\aze4).loadFrom(PatKitDef(\aze1))
PatKitDef(\aze4).childAt(0).reboot
PatKitDef(\aze4).childAt(0).pattern.source.patterns.first.dump
PatKitDef(\aze4).childAt(0).targetDataProxy.dump
PatKitDef(\aze4).childAt(0).play
PatKitDef(\aze4).childAt(0).stream.next(Event.default)

PatKitDef(\aze4).getPattern(0).play
PatKitDef(\aze4).setTargetData(0, (instrument:\saw))
PatKitDef(\azek).setTarget(0, Pbind(\instrument, \saw, \freq,Pseq([300,400],inf)))
PatKitDef(\aze2).setTargetData(0, ())
PatKitDef(\aze2).getTargetData(0)
PatKitDef(\aze2).clearChild(0)
PatKitDef(\aze1).edit
PatKitDef(\aze8).edit

~p = PatKitDef(\aze17)
~p.edit
~p.childAt(0).play
~p.getPattern(0)
~p.targetDataProxyList
~p.getTargetDataProxy(0).dump
~p.childAt(0).targetDataProxy.envir.clear
~p.updatePattern(0)
~p.childAt(0).targetDataProxy.envir = ()
~p.childAt(0).targetDataProxy.envir
~p.childAt(0).targetDataProxy.set(\instrument, \playersec)
~p.childAt(0).targetData
~p.setTargetData(0, ~p.defaultTargetDataProxy.envir) // no
~p.setTargetData(0, EventPatternProxy(Pbind()).set(\instrument, \playersec).envir.copy) // no
~p.setTargetData(0, EventPatternProxy(Pbind()).set(\speed, 1).envir.copy) // yes
~p.setTargetData(0, EventPatternProxy(Pbind()).set(\bla, 1).envir.copy) // yes
~p.setTargetData(0, (\bla: 1)) // yes
~p.setTargetData(0, ()) // no
~p.setTargetData(0, (\instrument: \playersec)) // no
~p.setTargetData(0, (\instrument: \saw)) // yes
~p.setTargetData(0, EventPatternProxy(Pbind()).set(\instrument, \playersec, \bufnum, 1).envir.copy) // yes
~p.setTargetData(0, EventPatternProxy(Pbind()).set(\instrument, \playersec, \speed, 1).envir.copy) // yes
~p.setTarget(0, PatKitDef(\or1).childAt(0).target.copy) // no
~p.setTargetData(0, PatKitDef(\or1).childAt(0).targetData.copy) // yes
~p.loadFrom(PatKitDef(\or2))
~p.loadFrom(PatKitDef(\or1))

PatKitDef(\or1).childAt(0).targetData.parent
().parent

//bug: first play the child, then loadFrom: play does not update
// if setTargetData or loadFrom before getPattern, then loadFrom work

// if i setTargetData(0,()) then play then loadFrom, it is locked
// if i setTargetData(0,()) then play then setTargetData(0,child...) then loadFrom, it is NOT locked

// so if child.isEmpty after setTargetData, then bug, else not bug
// when we create the pattern, the child should not be isEmpty

PatKitDef(\aze7).childAt(0).targetDataProxy.dump
PatKitDef(\aze1).presetCompileString.editorInsert
PatKitDef(\or2).edit
PatKitDef(\or2).presetCompileString.editorInsert


~a = EventPatternProxy(Pbind(\bla, Pseq([1,2],inf)))
~a.source = Pbind(\bla, Pseq([10,20],inf))
~s = ~a.asStream;
~s.next(())

(
FileSystemProject.loadOnce("libdef/drumkit.scd");
FileSystemProject.loadOnce("libdef/synthplayrec.scd");
BufDef(\metal, "vipere/metal.flac");
BufDef(\bomb, "vipere/bomb.flac");
PatKitDef('or1').targetsData = [
	('gain': 0.29546471291645, 'pos': 0.88786848072562, 'speed': 0.60838154979432, 'instrument': 'playersec', 'bufnum': BufDef('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'), 'sustain': 0.12950113378685),
	('gain': 0.29546471291645, 'pos': 3.5588662131519, 'speed': 1.2083815497943, 'instrument': 'playersec', 'bufnum': BufDef('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'), 'sustain': 0.066530612244898),
	('gain': 0.29546471291645, 'pos': 6.7844897959184, 'speed': 1.2083815497943, 'instrument': 'playersec', 'bufnum': BufDef('metal'), 'sustain': 0.25671201814059),
];
PatKitDef('or2').targetsData = [
	('gain': 0.1542418580916, 'instrument': 'playersec', 'bufnum': BufDef('bomb')),
	('gain': 0.20590666945949, 'pos': 0.43419501133787, 'speed': 1.346522113859, 'instrument': 'playersec', 'bufnum': BufDef('bomb'), 'sustain': 0.41716553287982),
];
PatKitDef(\barrykit7, 32.collect { arg idx;
	Pbind(
		\instrument, \playersecmax,
		\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
		\legato, 1,
		\st, 85/2/60,
		\pos, idx/4+0.61/Pkey(\st),
		\maxsustain, 0.2,
		\dur, 1/8,
		\gain, 1/4,
	)
});
);


PatKitDef(\aze1).childAt(0).isEmpty
PatKitDef(\barrykit7).presetCompileString
~a = PatKitDef(\aze1).targetsData.as(Array)

PatKitDef(\aze1).keys
PatKitDef(\aze1).childAt(0).pattern.play
PatKitDef(\aze1).parent[\presetCompileString].asCompileString
PatKitDef(\aze1).parent[\presetCompileString].asCompileString
PatKitDef(\ParPlayerGroup)[\presetCompileString].asCompileString
PatKitDef(\aze).childAt(0).targetData.presetCompileString("kj")
PatKitDef(\aze).childAt(0).targetData.envir
PatKitDef(\aze).childAt(0).targetData.envir.bufnum.asBufDef
PatKitDef(\aze).childAt(0).targetData.envir.bufnum.as(BufDef)
ParamGroup.getPbindefCompileString(PatKitDef(\aze).childAt(0).targetData)

ProtoClassDef(\bla, (hoho:2)).dump
ProtoTemplateDef(\bla, (hoho:2)).dump
ProtoClassDef(\bla).hash
~p = ProtoClass((parent: { ProtoClassDef(\bla) }))
~p.hoho
~p.parent


KitTimeline(\bla, PatKitDef(\aze1))
KitTimeline(\bla).edit

PatKitDef(\aze1).edit
PatKitDef(\aze1).controller.key
PatKitDef(\aze1).startControl

KitTimeline(\bla1).edit
KitTimeline(\bla1).eventList.print
NoteTimeline(\bla2).edit
ClipTimeline(\bla).edit
SampleTimeline(\bla).edit
ParamTimeline(\bla2, Param(Pdef(\hoho), \freq)).edit
TrackTimeline(\bla2, TrackDef(\myc)).edit
TrackDef(\myc, \CustomTrackList).edit
FileSystemProject.load("libdef/CustomTrackList.scd")
(
Pdef(\hoho, 
	Pbind(
		\instrument, \default,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

KitTimeline(\bla1, PatKitDef(\or2)).edit
KitTimeline(\bla1).wrapper = PatKitDef(\or1)
KitTimeline(\bla1).wrapper = PatKitDef(\or2)
KitTimeline(\bla1).play
KitTimeline(\bla1).editor.refresh
KitTimeline(\bla4).edit
ControllerDef.getTagSpec(\drumpad).list

KitTimeline(\hoho, [ Pbind(\note,0), Pbind(\note,1), Pbind(\note, 2)]).edit;
KitTimeline(\aaa).edit

(
WindowDef(\win, { arg def;

		def.windowName = "kkkk";
		Button.new;
	
}).front;
)
Window


(
SynthDef.new(\sine3, {
    arg freq=440, atk=0.005, rel=0.3, pan=0, amp=1;
    var sig, env;
    
    sig = SinOsc.ar(Saw.ar(freq).exprange(freq, freq*2));
    env = EnvGen.kr(Env.new([0,1,0],[atk,rel],[1,-1]),doneAction:2);
    sig = Pan2.ar(sig, pan, amp);

    // reverb
    sig = FreeVerb.ar(sig, 0.6, 0.9, 0.9);

    sig = sig * env;
    Out.ar(0, sig);
}).add;
)

//2. load/start tempo

t = TempoClock.new(60/60).permanent_(true).schedAbs(0, {t.beatsPerBar_(4) });

//3. start pbind
(
p =  Pbind(
    \instrument, \sine3,
    \dur, 1.0,
    \degree, Pseq([0, 1, 3, 4, 5, 7, 9], inf).trace,
	//\degree, 0,
    \atk, Pwhite(1.0, 2.0, inf)*0.1,
    \rel, Pwhite(3.0, 6.0, inf),
    \pan, Pwhite(-0.8, 0.8, inf),
);
z = p.play(t, quant: 0);
)



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

Pdef(\zed).condition = { arg ...args; args.postln; false }

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([1],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

x= TaskProxy.new;

~cond = Condition.new;
(
x.source = {
	var s, bpm, beat, tatum;
	bpm = 190;
	beat = 60 / bpm;
	tatum = beat / 4;

	~cond.test.debug("start");
	loop {
		"0123450123450123".do { |i|
			var synth;
			~cond.test.debug("cond0");
			~cond.test = false;
			~cond.test.debug("cond1");
			synth = Synth(\saw, [\freq, rrand(100,200.0), \lpfr, 1]);
			~cond.test.debug("cond2");
			2.wait;
			~cond.test.debug("cond3");
			synth.debug("synth");
			synth.set(\gate, 0);
			~cond.test.debug("cond4");
			~cond.test = true;
			~cond.test.debug("cond5");
			0.wait;
			0.wait;
			~cond.test.debug("cond6");

		};
	}
};
)
x.condition = { arg ...args; args.debug("args");~cond.test.debug("cond test") };
x.play
~cond.test

(
x.source = {
	var s, bpm, beat, tatum;
	bpm = 190;
	beat = 60 / bpm;
	tatum = beat / 4;

	loop {
		"0123450123450123".do { |i|
			var synth;
			x.condition = false;
			synth = Synth(\saw, [\freq, rrand(100,200.0), \lpfr, 2]);
			2.wait;
			synth.set(\gate, 0);
			x.condition = true;
			0.wait;

		};
	}
};
)

x.condition = true
x.condition 


Pdef(\bla).edit

(
Pdef(\aze, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0,5,2,7],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\aze2, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0,5,2,7],inf)+3,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
Pdef(\aze).edit
Param(Pdef(\aze), \adsr).isSet

Pdef
ParamGroupDef(\aze).presets[\preset3]


(
SynthDef(\ringfx, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig * SinOsc.ar(\ringfreq.kr(200));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\ringfx, 
	Pmono(\ringfx,
		\addAction, \addToTail,
		\ringfreq, PnoteEnv([0.1,0.2,2,2,0.1]*700+100,[0.2,0.2,0.2]),
		\lag, 0.0009,
		\dur, 1,
	),
).play;
);
BusDef(\fx1, \audio, 2)
Pdef(\ringfx).set(\inbus, BusDef(\fx1))
Pdef(\aze).set(\out, BusDef(\fx1))
Pdef(\aze1).set(\out, BusDef(\fx1))

WindowDef(\win, { arg def;
	VLayout (
		PlayerWrapperGroup([Pdef(\aze), Pdef(\ringfx)]).asView,
			HLayout (
				Pdef(\aze).asParamGroup.asView, Pdef(\ringfx).asParamGroup.asView,
			)
	)
}).front;



(
Pdef(\ringfx, 
	Pmono(\ringfx,
		\addAction, \addToTail,
		\ringfreq, PnoteEnv([0.1,0.2,2,2,0.1]*1700+400,[0.2,0.2,0.2]/4),
		//\mix, PmodEnv(Pseq([0,1,0.4],1), 8).loop,
		\mix, PnoteEnv([0.1,1,0],[0.1,0.2]),
		\lag, 0.0009,
		\dur, 1,
	),
).play;
);
Pdef(\aze).play
(
Pdef(\ringfx, 
	Pmono(\ringfx,
		\addAction, \addToTail,
		\ringfreq, PmodEnv(Pseq([0.1,0.2,2,2,0.1]*170+40,1),1).loop,
		\mix, PmodEnv(Pseq([0,0.8,0.1],1),1).loop,
		//\mix, PmodEnv(Pseq([0,1,0.4],1), 8).loop,
		//\mix, PnoteEnv([0.1,1,0],[0.1,0.2]),
		\lag, 0.0009,
		\dur, 1,
	),
).play;
);
(
Pdef(\ringfx, 
	Pmono(\ringfx,
		\addAction, \addToTail,
		//\mix, PmodEnv(Pseq([0,0.8,0.1],1),1).loop,
		//\mix, PmodEnv(Pseq([0,1,0.4],1), 8).loop,
		\ringfreq, PmodEnv(Pseq([0.1,0.2,2,2,0.1]*170+40,1),1).loop,
		\mix, PnoteEnv([0.1,1,1,0],[0.1,1/2,0.2]),
		\lag, 0.0009,
		\stretch, 1/2,
		\dur, 1,
		\bla, Pfunc({ arg ev; ev.use { currentEnvironment.postln; ~delta.value.postln }; 1 }),
	),
).play;
);

(
~t = 185/2/60; TempoClock.default.tempo = ~t;
Pdef(\zed, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0,-2,-4,2],inf),
		\legato, 1,
		\dur, 1,
		\amp, 0.1,
		\octave, 4,
		//\bla, Pfunc({ arg ev; currentEnvironment.postln; ev.delta.value.postln; 1 }),
		//\lpfr, PmodEnv(( Pseq([1,3,1,7]-0.5,inf) * Pseq((1..64*8*4)/64*8*4*1,1).trace ), 1/8, Pseq([5,-5],inf)),
		//\lpfr, PmodEnv(Pseq([1,2,1,4]+2,1), 8).loop,
		\lpfr, PmodEnv(( Pseq([1,3,1,7]-0.5,inf) * Pseg(Pseq([0.5,4],1),8) ), 1/8, Pseq([5,-5],inf)).loop.trace,
		//\lpfr, PmodEnv(Pseq([1,3,1,7]-0.5,20), 1/8, Pseq([5,-5],inf)).loop,
		//\rq, PmodEnv(Pseq([1,0.1,1,0.1,0.1],1), 2, Pseq([5,-5],inf)).loop.trace,
	)
).play;
);
Pdef(\zed).stop
Pkey
(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\stretch, 2,
		\dur, Pseq([1,1/2,1/2],inf),
		\amp, 0.1,
		\lvl, Pseq([100,4400,300],inf),
		//\bla, Pfunc({ arg ev; currentEnvironment.postln; ev.delta.value.postln; 1 }),
		\freq, PmodEnv(Pkey(\lvl), \dur).loop,
	)
).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\awa,Pbind(
			\instrument, \saw,
			//\freq, PmodEnv(Prand([0,12,23].midiratio*100,100), Pwhite(0.02,0.2)).loop,
			\note, Pstep(Pseq([
				[ 0,4,7 ],
				[ 0,4,7 ]+4,
				[ 0,4,7 ]+5,
				[ 0,4,7 ]+7,
			],inf),4) + Ptuple(Prand([0,12],inf)!3),
			\octave, 4,
			\lpfr, PmodEnv(Pseq([1,4,7,4],100), Pwhite(0.01,0.4)).loop,
			\rq, PnoteEnv([1,0.3],[1/4]),
			\adsr, Pseq([
				PpatEnv.adsr(Pwhite(0.01,0.41),0.1,0.8,0.1)
			],inf),
			\dur, Pwhite(0.1,1),
			\amp, 0.1,
		)),
		
	])
)).play;
);

Pdef(\awa).edit

(
Pdef(\exxx, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
Pdef(\exxx).edit




TrackDef(\bla, \CustomTrackList).edit
TrackDef(\pp, \playergrid).edit

ClipTimeline(\bla).edit
