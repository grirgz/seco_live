
(

FileSystemProject.load("ex2/main.scd");
FileSystemProject.load("ex2/sco1.scd");
)


PatKitDef(\sco4kit1).edit
ProtoDef(\recorder).edit
PatKitDef(\sco4kit1).presetCompileString.editorInsert
(
PatKitDef(\sco4kit1).targets = [
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix3/kick1.flac'))),
	StepEvent.newFrom((instrument: 'playersec', adsr: Env([ 0, 1, 1, 0 ], [ 0.004, 0, 0.01 ], [ -4, -4, -4 ], 2), bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix3/kick1.flac'), pos: 0.08)),
	nil,
	nil,
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix3/snare1.flac'))),
	nil,
	nil,
	nil,
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('/home/ggz/Musique/sc/reckit/my3/snare2.flac'), pos: 0.031065759637188, sustain: 1)),
	nil,
	nil,
	nil,
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix1/hat.flac'))),
	StepEvent.newFrom((adsr: Env([ 0, 1, 1, 0 ], [ 0.01, 0, 0.1 ], [ -4, -4, -4 ], 2), speed: 1.000875, bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix3/hurl.flac'), instrument: 'playersec', gain: 0.70786947024746, sustain: 1, pos: 0.25433106575964)),
];
);


KitTimeline(\sco4kit1, PatKitDef(\sco4kit1)).edit
KitTimeline(\sco4kit1_p2, PatKitDef(\sco4kit1)).edit
KitTimeline(\drum, PatKitDef(\sco4kit1)).edit
KitTimeline(\drum2, PatKitDef(\sco4kit1)).edit
KitTimeline(\drum4, PatKitDef(\sco4kit1)).edit
KitTimeline(\acodrum, PatKitDef(\sco4kit1)).edit
KitTimeline(\acodrum2, PatKitDef(\sco4kit1)).edit
KitTimeline(\drum2, PatKitDef(\sco4kit1)).presetCompileString.editorInsert
(
);

TrackDef(\sco4).edit
WindowDef(\mixergui).front(TrackDef(\sco4));

KitTimeline(\sco4kit1, PatKitDef(\sco4kit1)).outBus = BusDef(\sendbus0)

Pdef(\trap, Pbind(\instrument, \snapsnare)).play
(
WindowDef(\pdef_editor, { arg def, pdef;
	VLayout(
		PlayerWrapper(pdef).asView,
		pdef.asParamGroup.asView,
	)
}).front(Pdef(\trap));
)

Pdef(\trap).set(\out, BusDef(\sendbus0))
NoteTimeline(\note1).proxy.set(\out, NoteTimeline(\note1).outBus)
NoteTimeline(\hi).proxy.set(\out, NoteTimeline(\note1).outBus)

(
Ndef(\hi1, { arg freq=800, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = Duty.kr(1/~t, 0, Dseq([
		1,0,2,0,
	],inf));
	sig = 0;
	sig = LFPulse.ar(1/3*~t * ( 1 + ( sig * 1 )));
	sig = LFPulse.ar(1/8*~t * ( 1 + ( sig * 1 )));
	sig = SinOsc.ar(2*~t * ( 1 + ( sig * 1 )));
	sig = SinOsc.ar(freq * [1/4,1/3] * ~t * ( 1 + ( sig * 4 )));
	sig = SinOsc.ar(lfo1 * [100,1,1,1/43] * ( 1 + ( sig * 0.2 )));
	sig = SinOsc.ar(freq * [1,lfo1,1/23] * 1/4 * ( 1 + ( sig * 1.2 )));
	sig = SinOsc.ar(freq * ( 1 + ( sig * 1 )));
	sig = ( sig * 10000 ).tanh;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
Ndef(\hi1, { arg freq=800, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var rqfac;
	sig = WhiteNoise.ar(1);
	rqfac = Duty.kr(1/~t, 0, Dseq([
		1,1,1,10,
	],inf));

	sig = BPF.ar(sig, freq* (1..5).reverse, \rq.kr(0.5) * (1..5)/rqfac);
	sig = sig + Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(1) ) + sig;
	
		isig = DelayC.ar(isig,1,1/~t) + isig;
		isig = Limiter.ar(isig);
		isig;
	};
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);



(
TrackDef(\sco4, TrackDef(\playergrid)).source = [
	[
		KitTimeline(\sco4kit1),
		KitTimeline(\sco4kit1_p2),
	],
	[
		NoteTimeline(\sco4note1)
	],
	[
		KitTimeline(\drum),
		KitTimeline(\drum2),
		KitTimeline(\drum3),
		KitTimeline(\drum4),
	],
	[
		KitTimeline(\acodrum),
		KitTimeline(\acodrum2),
	],
	[
		Pdef(\parole),
		nil,
	],
	[
		nil,
	],
	[
		ProtoDef(\rdn),
	],

];
TrackDef(\sco4, TrackDef(\playergrid)).edit
)

ClipTimeline(\sco4).edit

(
Pdef(\parole, Pbind(
	\instrument, \playersec,
	\bufnum, BufDef(\moeten),
	\pos, Pseq([0,0,0,0,5,5,4,3]/16,inf)+Pwhite(0,0.01),

	\degree, Pseq([0],inf),
	\legato, 1,
	\isRest, Pseq([
		1,1,1,1, 0,0,0,0,
		0,0,0,1, 0,0,1,1,
		0,0,1,0, 0,0,0,0,
		0,1,0,1, 0,0,1,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	//\out, BusDef(\sendbus0),
	\amp, 0.1
)).play;
);

(
Pdef(\parole, Pbind(
	\instrument, \playersec,
	\bufnum, BufDef(\moeten),
	\pos, Pseq([
		0,0,0,0,5,5,4,3,
		0,0,0,0,5,5,4,3,
		0,0,0,0,14,4,4,3,
		0,0,0,0,14,4,4,3,
	]/16,inf)+Pwhite(0,0.01),

	\degree, Pseq([0],inf),
	\legato, 1,
	\isRest, Pseq([
		1,0,0,0, 1,0,0,0,
		0,0,0,0, 0,0,1,1,
		0,0,0,0, 0,0,0.51,0.51,
		0,0,0,0, 1,0.51,0,0,

		1,0,1,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0.51,0.51, 0,0,0.51,0.51,
		0,0,0,0, 1,0.51,1,1,

		0,0,0,0, 0,0,0,0,
		0,0,0,0, 1,0.51,1,0,
		0,0,0.51,0.51, 0,0,0.51,0.51,
		0,0,0,0, 1,0.51,1,0,

		1,0,1,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0.51,0.51, 0,0,0.51,0.51,
		0,0,0,0, 1,0.51,1,1,

	],inf).coin.not,
	\dur, 1/8,
	\out, BusDef(\sendbus0),
	\amp, 0.1
)).play;
);

(
Pdef(\parole, Pbind(
	\instrument, \playersec,
	\bufnum, BufDef(\moeten),
	\pos, Pseq([
		Pseq([
			0,0,0,0,5,5,4,3,
		],8),
		Pseq([
			0,0,1,0,5,5,4,3,
			0,4,4,0,15,5,4,3,
		],4),
	]/16,inf)+Pwhite(0,0.01),

	\degree, Pseq([0],inf),
	\legato, 1,
	\isRest, Pseq([
		1,1,1,1, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,1,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,0,1, 1,0,0,1,
		1,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\out, BusDef(\sendbus0),
	\amp, 0.1
)).play;
);

ParamGroupDef(\myfx, Ndef(\fx2).asParamGroup)
ParamGroupDef(\myfx).save(\pos1)
ParamGroupDef(\myfx).save(\pos2)

ParamGroupDef(\myfx).load(\pos1)
ParamGroupDef(\myfx).load(\pos2)
Spec.add(\out, XBusSpec())

ParamMorpher(ParamGroupDef(\myfx), [\pos1, \pos2]).edit
ParamMorpherDef(\myfx).edit
ParamMorpherDef(\myfx).group
ParamMorpherDef(\myfx).presets
ParamMorpherDef(\myfx).set(1)





		(
		"NoteTimeline(\sco4note1)"NoteTimeline(\sco4note1).eventList.collect({ arg ev; 
			"(\n%)\n".format(ev.debug("bla"); ev.keys.as(Array).collect({ arg key; 
				"%: %,\n".format(key.asCompileString, ev[key].asCompileString) 
			}).join) 
		}).join(",");
		)
(

	[
		PatKitDef(\sco4kit1),
		//NoteTimeline(\sco4note1),
		KitTimeline(\drum, PatKitDef(\sco4kit1)),
		KitTimeline(\drum2, PatKitDef(\sco4kit1)),
		KitTimeline(\drum3, PatKitDef(\sco4kit1)),
		KitTimeline(\drum4, PatKitDef(\sco4kit1)),
		KitTimeline(\acodrum, PatKitDef(\sco4kit1)),
		KitTimeline(\acodrum2, PatKitDef(\sco4kit1)),
		KitTimeline(\sco4kit1, PatKitDef(\sco4kit1)),
		KitTimeline(\sco4kit1_p2, PatKitDef(\sco4kit1)),
	].collect({ arg x; x.presetCompileString }).join("\n").editorInsert
)


(
)



(
	KitTimeline(\drum, PatKitDef(\sco4kit1));
	KitTimeline(\drum2, PatKitDef(\sco4kit1));
	KitTimeline(\drum3, PatKitDef(\sco4kit1));
	KitTimeline(\drum4, PatKitDef(\sco4kit1));
	KitTimeline(\acodrum, PatKitDef(\sco4kit1));
	KitTimeline(\acodrum2, PatKitDef(\sco4kit1));
	KitTimeline(\sco4kit1, PatKitDef(\sco4kit1));
	KitTimeline(\sco4kit1_p2, PatKitDef(\sco4kit1));
KitTimeline('drum3', PatKitDef(\sco4kit1)).eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 0.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.0, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.25, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 2.5, \dur: 0.5, \kitIndex: 1.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 3.0, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 3.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 3.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 4.0, \dur: 0.75, \kitIndex: 0.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.5, ),
	(\absTime: 4.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 5.0, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 5.25, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 5.5, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 5.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 6.0, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 6.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 6.5, \dur: 0.5, \kitIndex: 1.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 7.0, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 7.5, \dur: 0.5, \kitIndex: 1.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
KitTimeline('drum').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.5, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 1.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.5, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 2.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 2.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.5, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 3.0, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 3.375, \dur: 0.125, \kitIndex: 0.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 3.5, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 3.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 4.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 4.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 4.5, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 5.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 5.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 5.5, \dur: 0.375, \kitIndex: 4.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 5.875, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 6.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 6.5, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 7.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 7.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 7.5, \dur: 0.375, \kitIndex: 4.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 7.875, \dur: 0.125, \kitIndex: 0.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 8.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 8.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 8.5, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 9.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 9.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 9.5, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 10.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 10.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 10.5, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 11.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 11.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 11.5, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 11.75, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 12.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 12.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 12.5, \dur: 0.375, \kitIndex: 4.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 12.875, \dur: 0.125, \kitIndex: 1.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 13.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 13.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 13.5, \dur: 0.375, \kitIndex: 4.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 13.875, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 14.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 14.5, \dur: 0.375, \kitIndex: 4.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 14.875, \dur: 0.125, \kitIndex: 1.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 15.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 15.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 15.5, \dur: 0.375, \kitIndex: 4.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 15.875, \dur: 0.125, \kitIndex: 0.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 16.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 16.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 16.5, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 17.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 17.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 17.5, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 18.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 18.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 18.5, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 19.0, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 19.375, \dur: 0.125, \kitIndex: 0.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 19.5, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 19.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 20.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 20.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 20.5, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 21.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 21.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 21.5, \dur: 0.375, \kitIndex: 4.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 21.875, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 22.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 22.5, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 23.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 23.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 23.5, \dur: 0.375, \kitIndex: 4.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 23.875, \dur: 0.125, \kitIndex: 0.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 24.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 24.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 24.5, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 25.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 25.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 25.5, \dur: 0.125, \kitIndex: 4.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 25.625, \dur: 0.375, \kitIndex: 1.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 26.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 26.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 26.5, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 27.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 27.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 27.5, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 27.75, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 28.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 28.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 28.5, \dur: 0.375, \kitIndex: 4.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 28.875, \dur: 0.125, \kitIndex: 1.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 29.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 29.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 29.5, \dur: 0.375, \kitIndex: 4.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 29.875, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 30.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 30.5, \dur: 0.375, \kitIndex: 4.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 30.875, \dur: 0.125, \kitIndex: 1.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 31.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 31.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 31.5, \dur: 0.375, \kitIndex: 4.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 31.875, \dur: 0.125, \kitIndex: 0.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 32, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
KitTimeline('drum2').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.5, \kitIndex: 0, \midinote: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 0.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 1.0, \dur: 0.75, \kitIndex: 4.0, \midinote: 4.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 1.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 4.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 2.0, \dur: 0.5, \kitIndex: 0, \midinote: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 2.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 3.0, \dur: 0.75, \kitIndex: 4.0, \midinote: 4.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 3.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 4.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 4.0, \dur: 0.5, \kitIndex: 0, \midinote: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 4.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 5.0, \dur: 0.25, \kitIndex: 4.0, \midinote: 4.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 5.25, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 5.5, \dur: 0.25, \kitIndex: 0.0, \midinote: 4.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 5.75, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 6.125, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 6.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 7.0, \dur: 0.75, \kitIndex: 4.0, \midinote: 4.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 7.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 4.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
KitTimeline('drum4').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.875, \kitIndex: 0.0, \midinote: 0, \playDur: 0.875, \relDur: 0.875, \sustain: 0.375, ),
	(\absTime: 0.875, \dur: 0.625, \kitIndex: 1.0, \midinote: 0, \playDur: 0.625, \relDur: 0.625, \sustain: 0.1, ),
	(\absTime: 1.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 2.0, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.375, ),
	(\absTime: 2.5, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 2.75, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 3.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 3.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 4.0, \dur: 0.75, \kitIndex: 0.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.375, ),
	(\absTime: 4.75, \dur: 0.75, \kitIndex: 1.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.125, ),
	(\absTime: 5.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 6.0, \dur: 0.5, \kitIndex: 4.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.375, ),
	(\absTime: 6.5, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 6.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 7.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 7.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 7.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
KitTimeline('acodrum').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 0.25, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 0.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.75, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0.5, \kitIndex: 12.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 1.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 1.75, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 1.75, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 2.0, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 2.125, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.25, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 2.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 2.75, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 3.0, \dur: 0.5, \kitIndex: 12.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.1, ),
	(\absTime: 3.5, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 3.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 4.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 4.25, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 4.375, \dur: 0.125, \kitIndex: 13.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 4.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 4.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 5.0, \dur: 0.5, \kitIndex: 12.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 5.5, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 5.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 5.75, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 6.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 6.25, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 6.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 6.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 7.0, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 7.125, \dur: 0.375, \kitIndex: 12.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 7.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 7.75, \dur: 0.125, \kitIndex: 13.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 7.875, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 8.0, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 8.125, \dur: 0.375, \kitIndex: 12.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 8.5, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 8.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 8.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 9.0, \dur: 0.375, \kitIndex: 12.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 9.375, \dur: 0.375, \kitIndex: 12.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 9.75, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 10.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 10.25, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 10.375, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 10.625, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 10.875, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 11.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 11.25, \dur: 0.5, \kitIndex: 13.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.1, ),
	(\absTime: 11.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 12.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 12.25, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 12.375, \dur: 0.125, \kitIndex: 13.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 12.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 12.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 13.0, \dur: 0.5, \kitIndex: 12.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 13.5, \dur: 0.0, \kitIndex: 13.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 13.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 13.75, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 14.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 14.25, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 14.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 14.75, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 15.0, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 15.125, \dur: 0.375, \kitIndex: 12.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 15.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 15.75, \dur: 0.125, \kitIndex: 13.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 15.875, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 16, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
KitTimeline('acodrum2').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.5, \kitIndex: 12.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.125, ),
	(\absTime: 0.5, \dur: 0.375, \kitIndex: 12.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 0.875, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0.5, \kitIndex: 8.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 1.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.75, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 2.0, \dur: 0.5, \kitIndex: 13.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.1, ),
	(\absTime: 2.5, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.625, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.75, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 3.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 3.25, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 3.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 3.75, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 4.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 4.25, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 4.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 4.75, \dur: 0.125, \kitIndex: 13.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 4.875, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 5.0, \dur: 0.5, \kitIndex: 8.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 5.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 5.75, \dur: 0.5, \kitIndex: 12.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.125, ),
	(\absTime: 6.25, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 6.5, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 6.625, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 6.75, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 7.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 7.25, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 7.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 7.75, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 8.0, \dur: 0.5, \kitIndex: 12.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.125, ),
	(\absTime: 8.5, \dur: 0.375, \kitIndex: 12.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 8.875, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 9.0, \dur: 0.5, \kitIndex: 8.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 9.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 9.75, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 9.75, \dur: 0.5, \kitIndex: 13.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.1, ),
	(\absTime: 10.25, \dur: 0.25, \kitIndex: 13.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 10.5, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 10.625, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 10.75, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 10.75, \dur: 0.25, \kitIndex: 13.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 11.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 11.25, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 11.375, \dur: 0.375, \kitIndex: 12.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 11.75, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 12.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 12.25, \dur: 0.5, \kitIndex: 13.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.125, ),
	(\absTime: 12.75, \dur: 0.25, \kitIndex: 12.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 13.0, \dur: 0.0, \kitIndex: 12.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 13.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 13.25, \dur: 0.125, \kitIndex: 13.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 13.375, \dur: 0.375, \kitIndex: 12.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 13.75, \dur: 0.25, \kitIndex: 12.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 14.0, \dur: 0.25, \kitIndex: 12.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 14.25, \dur: 0.25, \kitIndex: 13.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 14.5, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 14.625, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 14.75, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 15.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 15.25, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 15.5, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 15.75, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 16, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
KitTimeline('sco4kit1').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 1.0, \kitIndex: 0, \midinote: 0.0, \playDur: 1.0, \relDur: 1.0, \sustain: 1.0, ),
	(\absTime: 1.0, \dur: 2.0, \kitIndex: 8.0, \midinote: 0, \playDur: 2.0, \relDur: 2.0, \sustain: 0.875, ),
	(\absTime: 3.0, \dur: 1.0, \kitIndex: 8.0, \midinote: 0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.25, ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
KitTimeline('sco4kit1_p2').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 2.0, \kitIndex: 2.0, \midinote: 0, \playDur: 2.0, \relDur: 2.0, \sustain: 2.0, ),
	(\absTime: 2.0, \dur: 2.0, \kitIndex: 4.0, \midinote: 0, \playDur: 2.0, \relDur: 2.0, \sustain: 2.0, ),
	(\absTime: 4, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);
