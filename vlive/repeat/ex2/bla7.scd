
(
ProtoDef(\recorder).fxkey = \fx2;
ProtoDef(\recorder).fxdef = \deltrans;
ProtoDef(\recorder).genfx;
ProtoDef(\recorder).enablefx = true;
~loadbufs.([\kick, \kick2, \kick3, \snare, \snare2, \snare3, \hat], "fix1");
~loadbufs.([\hat2], "fix1_extra");
Ndef('fx2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.071428571428571,
	'gain', 1,
	'fb', 0.00034014403432308,
	'delay', 0.0002006878167665,
	'delay2', 0.0002086064493472,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.6072103808883,
	'pitchlag', 0.125,
	'pitchmix', 0.12605042016807,
	'fb1', 0,
	'fb2', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'deltran1', 0.41848760755187,
	'deltran2', 0.49514382564655,
	'deltran3', 0.40464376119517,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.67226890756303,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'indelay', 0,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));
BufDef(\kick, s.sampleRate * 4);
BufDef(\kick2, s.sampleRate * 4);
BufDef(\kick3, s.sampleRate * 4);
BufDef(\tmp4, s.sampleRate * 4);
BufDef(\tmp4b, s.sampleRate * 4);
BufDef(\snare, s.sampleRate * 4);
BufDef(\snare2, s.sampleRate * 4);
BufDef(\snare3, s.sampleRate * 4);
BufDef(\hat, s.sampleRate * 4);
BufDef(\tmp16, s.sampleRate * 16);
BufDef(\bass, s.sampleRate * 4);
BufDef(\melo, s.sampleRate * 4);
BufDef(\melo2, s.sampleRate * 4);
BufDef(\hat2, s.sampleRate * 2);

BufDef(\moeten, "voices/02_moeten.flac");
BufDef(\amen, "vipere/amenbreak.wav");
BufDef(\table, "field/table.flac");
BufDef(\scream, "vipere/scream.flac");
BufDef(\rocksteady, "vipere/rocksteady.flac");


Ndef(\fx2).put(5, \filter -> { arg in;
	var sig = in;
	FreeVerb2.ar(sig[0], sig[1], \verbmix.kr(0.5), \room.kr(1), \damp.kr(0.4));

});
ParamProto.init;
ProtoDef(\recorder).edit;

//////////////////////////

~kit1 = ~kit1 ?? {~parPlayerGroup.new({ nil } ! 16)};
~kit1.targets = [
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef(\kick))),
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', freq: 192.59125049198, speed: 0.77052049180328, bufnum: BufDef(\snare2))),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef(\hat), pos: 1.2125623582766, sustain: 0.39431594860166)),
	StepEvent.newFrom((instrument: 'playersec', freq: 192.59125049198, speed: 1.1705204918033, bufnum: BufDef(\hat))),
	StepEvent.newFrom((gain: 0.20574427961076, pos: 4.3691383219955, speed: -0.5, instrument: 'playersec', bufnum: BufDef(\rocksteady), sustain: 1)),
	StepEvent.newFrom((pos: 0.0073922902494331, instrument: 'playersec', gain: 0.25, bufnum: BufDef(\hat2), sustain: 1)),
	StepEvent.newFrom((gain: 0.15669805278867, pos: 0.33269841269841, speed: 0.78144808743169, instrument: 'playersec', bufnum: BufDef(\hat2), sustain: 1)),
	StepEvent.newFrom((pos: 1.519387755102, instrument: 'playersec', gain: 0.25, bufnum: BufDef(\hat2), sustain: 1)),
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
];

~kit2 = ~kit2 ?? {~parPlayerGroup.new({ nil } ! 16)};
~kit2.targets = [
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef(\kick))),
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', freq: 192.59125049198, speed: 0.77052049180328, bufnum: BufDef(\snare2))),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef(\hat), pos: 1.2125623582766, sustain: 0.39431594860166)),
	StepEvent.newFrom((instrument: 'playersec', freq: 192.59125049198, speed: 1.1705204918033, bufnum: BufDef(\hat))),
	StepEvent.newFrom((gain: 0.20574427961076, pos: 4.3691383219955, speed: -0.5, instrument: 'playersec', bufnum: BufDef(\rocksteady), sustain: 1)),
	StepEvent.newFrom((pos: 0.0073922902494331, instrument: 'playersec', gain: 0.25, bufnum: BufDef(\hat2), sustain: 1)),
	StepEvent.newFrom((gain: 0.15669805278867, pos: 0.33269841269841, speed: 0.78144808743169, instrument: 'playersec', bufnum: BufDef(\hat2), sustain: 1)),
	StepEvent.newFrom((pos: 1.519387755102, instrument: 'playersec', gain: 0.25, bufnum: BufDef(\hat2), sustain: 1)),
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
];

~kit3 = ~kit3 ?? {~parPlayerGroup.new({ nil } ! 16)};
~kit3.targets = [
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix1_extra/kick1.flac'), pos: 0.04, sustain: 1)),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix1_extra/kick1.flac'), pos: 0.13990929705215, sustain: 1)),
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix1_extra/largesnare.flac'))),
	StepEvent.newFrom((pos: 1.1522448979592, instrument: 'playersec', speed: -1, bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix1_extra/largesnare.flac'), sustain: 0.021950113378685)),
	StepEvent.newFrom((pos: 0.60904761904762, instrument: 'playersec', speed: -0.9, bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix1_extra/largesnare.flac'), sustain: 0.010975056689342)),
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix2/bass'))),
	StepEvent.newFrom((pos: 1.125, instrument: 'playersec', bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix2/bass'))),
	StepEvent.newFrom((pos: 0.375, instrument: 'playersec', bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix2/bass'))),
	StepEvent.newFrom((instrument: 'playersec', gain: 1.7266318992368, bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix2/bass2'), pos: 0.04)),
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
];

//~kit1.postChain = Pdef(\kit1post,Pbind(\out, BusDef(\fx3, \audio)));
//~kit2.postChain = Pdef(\kit2post,Pbind(\out, BusDef(\fx3, \audio)));
~kit1.postChain = Pdef(\kit1post,Pbind(\out, 0));
~kit2.postChain = Pdef(\kit2post,Pbind(\out, 0));
~kit3.postChain = Pdef(\kit3post,Pbind(\out, 0));

KitTimeline(\smp, ~kit1);
KitTimeline(\smp2, ~kit3);
KitTimeline(\bass, ~kit2);

);

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////

ProtoDef(\recorder).genfx
ProtoDef(\recorder).edit

KitTimeline(\smp).edit

///////////////// tracks
TrackDef(\grid1).clear
(
	TrackDef(\grid1, TrackDef(\playergrid));
	TrackDef(\grid1).source = [
		[
			KitTimeline(\bass),
		],
		[
			KitTimeline(\smp),
		],
	];
	//TrackDef(\ot).childAt(0).source.do(_.fadeTime_(1));


//TrackDef(\ot).activate;

)
TrackDef(\grid1).edit
TrackDef(\grid1).isPlaying
TrackDef(\grid1).children[0].isEmpty
TrackDef(\grid1).children[0].children[0].isEmpty
TrackDef(\grid1).children[2].activeChild.isEmpty
TrackDef(\grid1).children[0].children[0].isEmpty = false
TrackDef(\grid1).children[0].children[0]
TrackDef(\grid1).children[0].children[0].size
(
TrackDef(\grid1).children.do { arg track, tt;
	track.children.do { arg child, cc;
		[tt, cc, child ].debug("child");
		child.isEmpty.debug("isEmpty")
	}
}
)







KitTimeline(\bass).clear
KitTimeline(\smp).clear
NoteTimeline(\yep).clear
~noteTimeline.new(\yep, ).edit

TrackDef(\grid1).source = []
KitTimeline(\bass, ~kit2).edit
KitTimeline(\bass, ~kit2).reboot
A
KitTimeline(\smp, ~kit1).edit
KitTimeline(\smp2, ~kit3).edit
~kit3.reboot;
KitTimeline(\smp, ~kit1).asPatternAbs(1,4)
KitTimeline(\smp).isPlaying
KitTimeline(\bass).isPlaying

Pseq([Event.silent(2)]).asStream.nextN(2,())

ParamProto.init( true)

FileSystemProject.load("proto1/tracks.scd");
TrackDef(\grid1).clear
TrackDef(\grid1).isPlaying.asCompileString.editorInsert
(
true
);

PlayerWrapper(TrackDef(\grid1).linePlayerAt(0)).isPlaying
TrackDef(\grid1).linePlayerAt(0).isPlaying
TrackDef(\grid1).linePlayerAt(0).children.do(_.stop)
TrackDef(\grid1).linePlayerAt(0).children.asArray.collect({ arg x; x.parentTrack.activeIndex })
TrackDef(\grid1).children.asArray.collect({ arg x; x.activeIndex })
TrackDef(\grid1).children
TrackDef(\grid1).linePlayerAt(0)[ \isPlaying ].asCompileString

(
true
);
TrackDef(\grid1).isPlaying and: TrackDef(\grid1).children.every({ arg x; x.activeIndex == 0 });
(
true
);

TrackDef(\grid1).children.do({ arg x; x.activeIndex.debug("hh") })
TrackDef(\grid1).children.size
TrackDef(\grid1).linePlayerAt(0).isPlaying.asCompileString.editorInsert
TrackDef(\grid1).linePlayerAt(0).isPlaying.asCompileString.editorInsert
(
false
);


TrackDef(\grid1).edit
TrackDef(\grid1).children[2].target
TrackDef(\grid1).childAt(2).isEmpty
TrackDef(\grid1).childAt(0@1).label
TrackDef(\grid1).childAt(0@0).source = KitTimeline(\smp)
TrackDef(\grid1).childAt(0@0).source
TrackDef(\grid1).childAt(0)
PlayerWrapper(KitTimeline(\smp)).outBus = BusDef(\fx1)
PlayerWrapper(KitTimeline(\smp)).wrapper
Param(KitTimeline(\smp), \out, XBusSpec()).set(BusDef(\fx1))
Param(KitTimeline(\smp), \out, XBusSpec()).wrapper
Param(Message(KitTimeline(\smp)), \out, XBusSpec()).wrapper
Param(Message(KitTimeline(\smp)), \out, XBusSpec()).set(BusDef(\fx1))
Param(Message(KitTimeline(\smp)), \out, XBusSpec()).get
(
TrackDef(\grid1).source.collect({ arg row, rowidx;
	row.collect({ arg child, childidx;
		child.debug("child % %".format(rowidx, childidx))
	
	})

})
)

///////////////::
WindowDef(\playergrid)

BufDef(\hat2).clear
BufDef(\hat2)
Ndef(\fx2).play;
ProtoDef(\recorder).edit
KitTimeline(\smp, ~ppg).edit
KitTimeline(\smp, ~kit1).edit
~kit1.reboot
~ppg.postChain = Pbind(\out, BusDef(\fx1))


~kit2.edit

KitTimeline(\bass, ~kit2).edit
KitTimeline(\bass, ~kit2).eventList.playingDur
KitTimeline(\bass, ~kit2).eventList.endTime
KitTimeline(\bass, ~kit2).eventList.startTime
KitTimeline(\bass, ~kit2).quant
KitTimeline(\bass, ~kit2).respondTo(\quant)
KitTimeline(\bass, ~kit2).asPattern.play
KitTimeline(\bass, ~kit2).eventList.relStartTime
KitTimeline(\bass, ~kit2).eventList.print
KitTimeline(\bass, ~kit2).asPattern(0,4).play
(
Ndef(\fx2).play;
Pdef(\main, Ppar([
	KitTimeline(\bass).asPattern,
	KitTimeline(\smp).asPattern,
])).play
)



///////////////////////////////////////:

NoteTimeline(\yep).asPattern(0,4).play
ParamProto.init(true);
NoteTimeline(\yep).clear
(
Pdef(\def, Pbind(\instrument, \default));
NoteTimeline(\yep, Param(Pdef(\def), \midinote)).edit;
)
NoteTimeline(\yep, Param(Pdef(\def), \midinote)).quant
NoteTimeline(\yep).asPattern(3/4*2, 2).play
NoteTimeline(\yep).asPatternAbs(1,4)
NoteTimeline(\yep).asPattern.play
NoteTimeline(\yep).asPatternAbs(1,1+0.5)
NoteTimeline(\yep).eventList.totalDur
NoteTimeline(\yep).eventList.totalDur
NoteTimeline(\yep).eventList.startTime
NoteTimeline(\yep).eventList.endTime

~tp = TaskProxy.new
~tp.play
(
~tp.source = {
	10.do { arg xx;
		("xx="++xx).postln;
		1.wait;
	}
}
)

(
~tt = Task{
	10.do { arg xx;
		("xx="++xx).postln;
		1.wait;
	}
}
)
~tt.play
~tt.isPlaying


/////////////////////////////////////////////::


Pdef(\kit1post,Pbind(\out, BusDef(\fx1)));
Pdef(\kit2post,Pbind(\out, BusDef(\fx1)));
Pdef(\kit3post,Pbind(\out, BusDef(\fx1)));





////////////////////////////////


(
Ndef(\hi, { arg freq=800, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = Duty.kr(1/~t + 0.1, 0, Dseq([
		1,1,1,0,
	],inf));
	lfo2 = Duty.kr(1/~t + 0.2, 0, Dseq([
		1,1,1,0,
	],inf));
	lfo3 = Duty.kr(1/~t + 0.3, 0, Dseq([
		1,1,1,0,
	],inf));
	lfo4 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0, 1,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,1,0,0, 1,0,1,0,
		1,1,1,1, 1,1,1,1,
	],inf));
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(12 * ( 1 + ( SinOsc.kr(1/23 * ( 1 + ( SinOsc.kr(1/3) * 1 * lfo3 ))) * 1 * lfo2 ))) * 1 * lfo1 )));
	sig = SinOsc.ar(freq) + sig * lfo4; 
	sig = ( sig * 1000 ).tanh;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
Ndef(\hi).stop


(
SynthDef(\nap, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var lfotab1j
	lfotab1 = Ndef(\nap_mylfo).kr(5);
	sig = SinOsc.ar(freq * [1,1.01,1.002,2,1/2]);
	sig = sig + LFSaw.ar(freq * ( 1 + ( SinOsc.kr(lfotab1) * 0.01 )) );
	sig = sig.fold2(\fold.kr(1) * lfotab1) * 2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

	Ndef(\nap_mylfo, { SinOsc.kr((1..5)/22*~t).range(0.5,1) })
(
Pdef(\nap, Pbind(
	\instrument, \nap,
	\fold, Ndef(\nap_lfo1, { SinOsc.kr(1/22*~t).range(0.5,1) }),
	\lfo1, Ndef(\nap_lfotab1, { SinOsc.kr(1/22*~t).range(0.5,1) }),
	\degree, Pseq([[0,3,5]],inf) + Pseq([
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0, 0, 2, 1,
	],inf),
	\dur, 1/4,
	\amp, 0.1
)).play;
);

(
Pdef(\nap, Pbind(
	\instrument, \nap,
	\fold, Ndef(\nap_lfo1, { SinOsc.kr(1/22*~t).range(0.5,1) }),
	\degree, Pseq([[0,3,5]],inf) + Pseq([
		0, 0, 2, 1,
	],inf),
	\dur, 2/1,
	\legato,1,
	\amp, 0.2
)).play;
);


Ndef(\briz, {
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2);
	
})


Import("lib")
TrackTemplateDef('lib/black')
TrackDef('black/jazz').play
TrackDef('lib/black/jazz').play
Load


ProtoDef(\recorder).edit
Pdef(\src).get(\bufnum)
BufDef.all.keys
~v = View.new
~v.refreshChangeAction = { "pplo".debug("kkjkj") };
~v.refreshChange

~kit3.asPresetCompileString.editorInsert
BufDef('/home/ggz/Musique/sc/reckit/fix1_extra/kick1.flac')
(
);

KitTimeline(\smp2).presetCompileString.editorInsert
(
KitTimeline('smp2').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 2.0, ),
	(\absTime: 0.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 0.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 1.0, \dur: 0.75, \kitIndex: 2.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 1.75, \dur: 0.25, \kitIndex: 3.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.0, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.5, ),
	(\absTime: 2.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 2.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 3.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 3.5, \dur: 0.125, \kitIndex: 6.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 3.625, \dur: 0.125, \kitIndex: 6.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 3.75, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 3.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 4.0, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.5, ),
	(\absTime: 4.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 4.5, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 4.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 5.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 5.5, \dur: 0.5, \kitIndex: 7.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 6.0, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.25, ),
	(\absTime: 6.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 6.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 7.0, \dur: 0.25, \kitIndex: 2.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 7.25, \dur: 0.0, \kitIndex: 3.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 7.25, \dur: 0.25, \kitIndex: 6.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.375, ),
	(\absTime: 7.5, \dur: 0.125, \kitIndex: 0.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 7.625, \dur: 0.125, \kitIndex: 5.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 7.75, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 7.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 8.0, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 2.0, ),
	(\absTime: 8.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 8.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 9.0, \dur: 1.0, \kitIndex: 2.0, \midinote: 0, \playDur: 1.0, \relDur: 1.0, \sustain: 1.0, ),
	(\absTime: 10.0, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.5, ),
	(\absTime: 10.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 10.5, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 10.75, \dur: 0.25, \kitIndex: 3.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 11.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 11.5, \dur: 0.125, \kitIndex: 6.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 11.625, \dur: 0.125, \kitIndex: 6.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 11.75, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 11.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 12.0, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.5, ),
	(\absTime: 12.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 12.5, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 12.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 13.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 13.5, \dur: 0.5, \kitIndex: 7.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 14.0, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.25, ),
	(\absTime: 14.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 14.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 15.0, \dur: 0.25, \kitIndex: 2.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.625, ),
	(\absTime: 15.25, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 15.25, \dur: 0.375, \kitIndex: 5.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.375, ),
	(\absTime: 15.625, \dur: 0.125, \kitIndex: 6.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 15.75, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 15.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 16.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 4.0, ),
	(\absTime: 16.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.375, ),
	(\absTime: 16.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 17.0, \dur: 1.0, \kitIndex: 2.0, \midinote: 0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.375, ),
	(\absTime: 18.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 18.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 18.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 19.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 19.5, \dur: 0.5, \kitIndex: 1.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 20.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 20.0, \dur: 0.375, \kitIndex: 8.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 2.0, ),
	(\absTime: 20.375, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 20.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 21.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.375, ),
	(\absTime: 21.5, \dur: 0.25, \kitIndex: 3.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 21.75, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 22.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 22.0, \dur: 0.5, \kitIndex: 6.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 1.125, ),
	(\absTime: 22.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 22.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 23.0, \dur: 0.75, \kitIndex: 2.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 23.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 24.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.375, ),
	(\absTime: 24.0, \dur: 0.5, \kitIndex: 8.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 1.0, ),
	(\absTime: 24.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 25.0, \dur: 0.0, \kitIndex: 2.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.375, ),
	(\absTime: 25.0, \dur: 0.375, \kitIndex: 6.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 25.375, \dur: 0.375, \kitIndex: 8.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 25.75, \dur: 0.25, \kitIndex: 5.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 26.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 26.25, \dur: 0.25, \kitIndex: 7.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 26.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 26.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 27.0, \dur: 0.0, \kitIndex: 2.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 27.0, \dur: 0.5, \kitIndex: 8.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 1.0, ),
	(\absTime: 27.5, \dur: 0.5, \kitIndex: 1.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 28.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 28.0, \dur: 0.375, \kitIndex: 8.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 4.0, ),
	(\absTime: 28.375, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 28.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 29.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.375, ),
	(\absTime: 29.5, \dur: 0.25, \kitIndex: 3.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 29.75, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 30.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 30.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 30.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 31.0, \dur: 0.75, \kitIndex: 2.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 31.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 32.0, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.0, ),
	(\absTime: 32.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 32.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 33.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.5, ),
	(\absTime: 33.0, \dur: 0.75, \kitIndex: 2.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 33.75, \dur: 0.25, \kitIndex: 3.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 34.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 34.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 35.0, \dur: 0.0, \kitIndex: 2.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 35.0, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.5, ),
	(\absTime: 35.25, \dur: 0.5, \kitIndex: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.125, ),
	(\absTime: 35.75, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 35.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 36.0, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.0, ),
	(\absTime: 36.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 36.5, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 36.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 37.0, \dur: 0.0, \kitIndex: 2.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 37.0, \dur: 0.25, \kitIndex: 8.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.5, ),
	(\absTime: 37.25, \dur: 0.75, \kitIndex: 5.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.75, ),
	(\absTime: 38.0, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.0, ),
	(\absTime: 38.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 38.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 39.0, \dur: 0.0, \kitIndex: 2.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 39.0, \dur: 0.25, \kitIndex: 4.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.375, ),
	(\absTime: 39.25, \dur: 0.25, \kitIndex: 3.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 39.5, \dur: 0.125, \kitIndex: 0.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 39.625, \dur: 0.125, \kitIndex: 5.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 39.75, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 39.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 40.0, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.625, ),
	(\absTime: 40.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 40.5, \dur: 0.125, \kitIndex: 1.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 40.625, \dur: 0.375, \kitIndex: 4.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.375, ),
	(\absTime: 41.0, \dur: 1.0, \kitIndex: 2.0, \midinote: 0, \playDur: 1.0, \relDur: 1.0, \sustain: 1.0, ),
	(\absTime: 42.0, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.625, ),
	(\absTime: 42.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 42.5, \dur: 0.125, \kitIndex: 1.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 42.625, \dur: 0.125, \kitIndex: 5.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.375, ),
	(\absTime: 42.75, \dur: 0.25, \kitIndex: 3.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 43.0, \dur: 0.0, \kitIndex: 2.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 43.0, \dur: 0.5, \kitIndex: 4.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.625, ),
	(\absTime: 43.5, \dur: 0.125, \kitIndex: 6.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 43.625, \dur: 0.125, \kitIndex: 6.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 43.75, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 43.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 44.0, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.625, ),
	(\absTime: 44.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 44.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 44.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 45.0, \dur: 0.0, \kitIndex: 2.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.5, ),
	(\absTime: 45.0, \dur: 0.5, \kitIndex: 5.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 45.5, \dur: 0.0, \kitIndex: 7.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.5, ),
	(\absTime: 45.5, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 45.75, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 46.0, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 46.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 46.25, \dur: 0.25, \kitIndex: 5.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 46.5, \dur: 0.5, \kitIndex: 1.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 47.0, \dur: 0.0, \kitIndex: 2.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.625, ),
	(\absTime: 47.0, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.375, ),
	(\absTime: 47.25, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 47.75, \dur: 0.0, \kitIndex: 5.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 47.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 48.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 4.0, ),
	(\absTime: 48.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.375, ),
	(\absTime: 48.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 49.0, \dur: 1.0, \kitIndex: 2.0, \midinote: 0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.375, ),
	(\absTime: 50.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 50.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 50.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 51.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 51.5, \dur: 0.5, \kitIndex: 1.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 52.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 52.0, \dur: 0.375, \kitIndex: 8.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 2.0, ),
	(\absTime: 52.375, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 52.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 53.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.375, ),
	(\absTime: 53.5, \dur: 0.25, \kitIndex: 3.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 53.75, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 54.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 54.0, \dur: 0.5, \kitIndex: 6.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 1.125, ),
	(\absTime: 54.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 54.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 55.0, \dur: 0.75, \kitIndex: 2.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 55.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 56.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.375, ),
	(\absTime: 56.0, \dur: 0.5, \kitIndex: 8.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 1.0, ),
	(\absTime: 56.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 57.0, \dur: 0.0, \kitIndex: 2.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.375, ),
	(\absTime: 57.0, \dur: 0.375, \kitIndex: 6.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 57.375, \dur: 0.375, \kitIndex: 8.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 57.75, \dur: 0.25, \kitIndex: 5.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 58.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 58.25, \dur: 0.25, \kitIndex: 7.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 58.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 58.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 59.0, \dur: 0.0, \kitIndex: 2.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 59.0, \dur: 0.5, \kitIndex: 8.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 1.0, ),
	(\absTime: 59.5, \dur: 0.5, \kitIndex: 1.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 60.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 60.0, \dur: 0.375, \kitIndex: 8.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 4.0, ),
	(\absTime: 60.375, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 60.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 61.0, \dur: 0.5, \kitIndex: 2.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.375, ),
	(\absTime: 61.5, \dur: 0.25, \kitIndex: 3.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 61.75, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 62.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 62.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 62.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 63.0, \dur: 0.75, \kitIndex: 2.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 63.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 64.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

