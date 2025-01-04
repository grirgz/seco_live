
(
// model moved to quark, here is gui arp sequencer building

Pbindef(\arp, 
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
);

WindowDef(\Arp, { arg def, arp;
	var num = 8;
	var pgroup = ParamGroup([
		Param(arp, \idx -> \stepseq, ControlSpec(-12,12,\lin,1,0)),
		Param(arp, \velocity -> \stepseq, ControlSpec(0,2,\lin,0,1)),
	]);
	var pdict = pgroup.asPropertyDict;
	var sourcepat = Pbind();
	var arper = ProtoTemplateDef(\Arpegiator).arper(sourcepat, arp);
	pgroup.do(_.initPstepSeq(num));
	VLayout (
		HLayout (
			PlayerWrapperView(arper),
			BasicButton.new.string_("Select source"),
		),
		GridLayout.rows(
			[StaticText.new.string_("Index")] ++
			pdict[\idx].collect { arg subp, idx;
				subp.asNumberBox
			},
		
			[StaticText.new.string_("Velocity")] ++
			pdict[\velocity].collect { arg subp, idx;
				subp.asNumberBox
			},
		),
		nil
	)
	
})
)

// END
WindowDef(\Arpegiator).front(Pbindef(\arp));

Pbindef(\arp).clear
Pbindef(\arp).source.set(\idx, PstepSeq(0!8))
Pbindef(\arp).source.at(\idx).source
Pbindef(\arp).source.at(\velocity).source.list
P
(
Pbindef(\arp, 
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
).play;
);
	Param(Pbindef(\arp), \idx -> \stepseq)
	Param(Pbindef(\arp), \idx -> \stepseq).getRaw
	Param(Pbindef(\arp), \idx -> \stepseq).size
	Param(Pbindef(\arp), \idx2 -> \stepseq).size
	Param(Pbindef(\arp), \idx2 -> \stepseq).default
	Param(Pbindef(\arp), \idx2).parent.default
	~arp = Pbindef(\arp)
Param(~arp, \idx -> \stepseq, ControlSpec(-12,12,\lin,1,0)).parent.default
Param(~arp, \idx -> \stepseq, ControlSpec(-12,12,\lin,1,0)).default
Param(~arp, \idx -> \stepseq, ControlSpec(-12,12,\lin,1,0)).spec
Param(~arp, \idx -> \source, ControlSpec(-12,12,\lin,1,0)).default
Param(~arp, \idx, ControlSpec(-12,12,\lin,1,0)).default
(
~pg = ParamGroup([ 

	Param(~arp, \idx -> \stepseq, ControlSpec(-12,12,\lin,1,0)),
	Param(~arp, \velocity -> \stepseq, ControlSpec(0,2,\lin,0,1)),
])
)
~pg.asDict
	Param(~arp, \velocity -> \stepseq, ControlSpec(0,2,\lin,0,1)).default.first

//////////////////////////////////////////// test demux

(
	Pdef(\demux, 
		ProtoTemplateDef(\Arpegiator).demux(Prout({ arg ev;
			ev = (midinote:60, dur: 1).yield;
			ev = (midinote:61, dur: 1).yield;
			ev = (midinote:62, dur: 1).yield;
			ev = [(midinote:65, dur: 1, delta: 0),(midinote:67, dur: 1)].yield;
			ev = (midinote:59, dur: 1).yield;
			ev = (midinote:59, dur: 1).yield;
		}))
	).play;
)

////////////////////////////////////////////

NoteTimeline(\note1).edit
NoteTimeline(\note1).presetCompileString.editorInsert
(
SynthDef(\sh101, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq, vcfmod;
	freq = freq * ( \vcomod.kr(0) + 1 );
	sig = LFPulse.ar(freq,0,\pwidth.kr(0.5)) * \pulse.kr(0.5);
	sig = sig + (LFSaw.ar(freq) * \saw.kr(0.5));
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.8)), gate, doneAction:0) * \envamt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	//sig = RLPF.ar(sig, ( \lpf.kr(130) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	vcfmod = \vcfmod.kr(0) + 1;
	sig = MoogFF.ar(sig, ( \lpf.kr(930) * lpenv * lpfreq * vcfmod ).clip(20,20000), 1/\rq.kr(0.8)) * 3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\acid, 
	Pbind(
		\instrument, \sh101,
		\lpadsr, Pseq([
			[ Env.adsr(0.01,0.1,1.2,0.1) ],
		],inf),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.01,1,0.01) ],
		],inf),
		\kbamt, 0,
		//\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
		\lpf, Pseg(Pseq([150,600],1), 8).loop,
		//\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
		\rq, 0.4,
		\envamt, 2,
		\amp, 0.06,
	)
);
NoteTimeline('note1', Pdef(\acid)).param = Param(Pdef('NoteTimeline_default'), 'midinote');
NoteTimeline('note1').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \clockTime: 583.109852935, \dur: 0.0, \legato: 0.8, \midinote: 53.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.93369389, \velocity: 53, ),
	(\absTime: 0.0, \clockTime: 583.110859679, \dur: 0.0, \legato: 0.8, \midinote: 60.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.9660456829999, \velocity: 61, ),
	(\absTime: 0.0, \clockTime: 583.107515502, \dur: 0.0, \legato: 0.8, \midinote: 57.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.8934384089999, \velocity: 52, ),
	(\absTime: 0.0, \dur: 2.0, \label: 'start', \playDur: 2.0, \relDur: 2.0, \sustain: 0, \type: 'start', ),
	(\absTime: 2.0, \clockTime: 585.18966787, \dur: 0.0, \legato: 0.8, \midinote: 52.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.830685956, \velocity: 109, ),
	(\absTime: 2.0, \clockTime: 585.147520506, \dur: 0.0, \legato: 0.8, \midinote: 60.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.8634524859999, \velocity: 32, ),
	(\absTime: 2.0, \clockTime: 585.178597548, \dur: 2.0, \legato: 0.8, \midinote: 56.0, \playDur: 2.0, \relDur: 2.0, \sustain: 1.82908029, \velocity: 108, ),
	(\absTime: 4.0, \clockTime: 587.287097453, \dur: 0.0, \legato: 0.8, \midinote: 53.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.703773855, \velocity: 31, ),
	(\absTime: 4.0, \clockTime: 587.274100565, \dur: 0.0, \legato: 0.8, \midinote: 50.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.691062823, \velocity: 68, ),
	(\absTime: 4.0, \clockTime: 587.250007113, \dur: 2.0, \legato: 0.8, \midinote: 57.0, \playDur: 2.0, \relDur: 2.0, \sustain: 1.7426179620001, \velocity: 78, ),
	(\absTime: 6.0, \clockTime: 589.179389116, \dur: 0.0, \legato: 0.8, \midinote: 52.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.8593019370001, \velocity: 16, ),
	(\absTime: 6.0, \clockTime: 589.15926883, \dur: 0.0, \legato: 0.8, \midinote: 59.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.8590327639999, \velocity: 57, ),
	(\absTime: 6.0, \clockTime: 589.126435022, \dur: 2.0, \legato: 0.8, \midinote: 55.0, \playDur: 2.0, \relDur: 2.0, \sustain: 1.929359633, \velocity: 49, ),
	(\absTime: 8.0, \clockTime: 591.238488516, \dur: 0.0, \legato: 0.8, \midinote: 57.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.649289653, \velocity: 87, ),
	(\absTime: 8.0, \clockTime: 591.273035275, \dur: 0.0, \legato: 0.8, \midinote: 53.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.7557427989999, \velocity: 74, ),
	(\absTime: 8.0, \clockTime: 591.272650853, \dur: 2.0, \legato: 0.8, \midinote: 60.0, \playDur: 2.0, \relDur: 2.0, \sustain: 1.64076268, \velocity: 53, ),
	(\absTime: 10.0, \clockTime: 593.18431283, \dur: 0.0, \legato: 0.8, \midinote: 62.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.690437307, \velocity: 40, ),
	(\absTime: 10.0, \clockTime: 593.219265086, \dur: 0.0, \legato: 0.8, \midinote: 53.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.639697632, \velocity: 36, ),
	(\absTime: 10.0, \clockTime: 593.205329399, \dur: 2.0, \legato: 0.8, \midinote: 59.0, \playDur: 2.0, \relDur: 2.0, \sustain: 1.663059937, \velocity: 45, ),
	(\absTime: 12.0, \clockTime: 595.275562993, \dur: 0.0, \legato: 0.8, \midinote: 64.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.731977892, \velocity: 59, ),
	(\absTime: 12.0, \clockTime: 595.276174347, \dur: 0.0, \legato: 0.8, \midinote: 55.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.844382447, \velocity: 81, ),
	(\absTime: 12.0, \clockTime: 595.240615892, \dur: 2.0, \legato: 0.8, \midinote: 60.0, \playDur: 2.0, \relDur: 2.0, \sustain: 1.748917332, \velocity: 72, ),
	(\absTime: 14.0, \clockTime: 597.191080282, \dur: 0.0, \legato: 0.8, \midinote: 55.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.621896092, \velocity: 16, ),
	(\absTime: 14.0, \clockTime: 597.206739732, \dur: 0.0, \legato: 0.8, \midinote: 59.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.5736331869999, \velocity: 36, ),
	(\absTime: 14.0, \clockTime: 597.207195105, \dur: 2.0, \legato: 0.8, \midinote: 62.0, \playDur: 2.0, \relDur: 2.0, \sustain: 1.555279906, \velocity: 67, ),
	(\absTime: 16.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		~parp.(NoteTimeline(\note1).asPattern, Pbind(
			\idx, Pseq([1,0,2,0],inf),
			\legato, 1,
			\dur, Pseq([1/8],inf),
		))
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		~parp.(NoteTimeline(\note1).asPattern, Pbind(
			\idx, Pseq([[ 0,1 ],4,3,4,3, [0,1,2]],inf),
			\dur, Pseq([1/4,Rest(1/4),1/2,1/2]/2,inf),
		)),
		~parp.(NoteTimeline(\note1).asPattern, Pbind(
			\octaveshift, Pseq([1,2,1,1],inf),
			\idx, Pseq([0,4,4,3,3,2,2,1,1,0,[ 0,1 ],4,3,4,3, [0,1,2]],inf),
			\lpf, 200 * Pwhite(0.8,1.2),
			\adsr, Pseq([
				[ Env.adsr(0.04,0.1,0.8,0.6) ],
			],inf),
			\lpadsr, Pseq([
				PpatEnv.adsr(0.04,0.1,0.8,Pwhite(0.1,0.8)),
			],inf),
			\envamt, 8,
			\legato, Pseq([
				1,1,2,0, 3,0,0,1,
				2,0,1,1, 0,1,0,1,
				1,1,1,0, 0,1,0,1,
				4,0,0,0, 0,1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			//\dur, Pseq([
				//1/2,Rest(1/2),Rest(1/2),Rest(1/2),
				//1/2,Rest(1/2),Rest(1/2),1/2,
			//]/4,inf),
		)),
	])
)).play;
);

NoteTimeline(\notetest).edit
NoteTimeline(\notetest).eventList.print
~t = 1; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		~parp.(NoteTimeline(\notetest).asPattern, Pbind(
			\idx, Pseq([1,0,2,0],inf),
			\legato, 1,
			\dur, Pseq([1/8],inf),
		))
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		~parplive.({ ~currentNotes }, Pdef(\acid), Pbind(
			\idx, Pseq([[ 0,1 ],4,3,4,3, [0,1,2]],inf),
			\dur, Pseq([1/4,Rest(1/4),1/2,1/2]/2,inf),
		)),
		~parplive.({ ~currentNotes }, Pdef(\acid), Pbind(
			\octaveshift, Pseq([1,2,1,1],inf),
			\idx, Pseq([0,4,4,3,3,2,2,1,1,0,[ 0,1 ],4,3,4,3, [0,1,2]],inf),
			\lpf, 200 * Pwhite(0.8,1.2),
			\adsr, Pseq([
				[ Env.adsr(0.04,0.1,0.8,0.6) ],
			],inf),
			\lpadsr, Pseq([
				PpatEnv.adsr(0.04,0.1,0.8,Pwhite(0.1,0.8)),
			],inf),
			\envamt, 8,
			\legato, Pseq([
				1,1,2,0, 3,0,0,1,
				2,0,1,1, 0,1,0,1,
				1,1,1,0, 0,1,0,1,
				4,0,0,0, 0,1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			//\dur, Pseq([
				//1/2,Rest(1/2),Rest(1/2),Rest(1/2),
				//1/2,Rest(1/2),Rest(1/2),1/2,
			//]/4,inf),
		)),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		~parplive.({ ~currentNotes }, Pdef(\acid), Pbind(
			\idx, Pseq([2,3,[ 0,1 ],4,3,4,3, [0,1,2]],inf),
			\dur, Pseq([1/4]/2,inf),
		)),
		~parplive.({ ~currentNotes }, Pdef(\acid), Pbind(
			\octaveshift, Pseq([1,2,1,1],inf),
			\idx, Pseq([0,1,0,2,0,3,0,4,0,5],inf),
			\lpf, 200 * Pwhite(0.8,1.2),
			\adsr, Pseq([
				[ Env.adsr(0.04,0.1,0.8,0.6) ],
			],inf),
			\lpadsr, Pseq([
				PpatEnv.adsr(0.04,0.1,0.8,Pwhite(0.1,0.8)),
			],inf),
			\envamt, 8,
			\legato, Pseq([
				1/4,1,1/2,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			//\dur, Pseq([
				//1/2,Rest(1/2),Rest(1/2),Rest(1/2),
				//1/2,Rest(1/2),Rest(1/2),1/2,
			//]/4,inf),
		)),
	])
)).play;
);


(
~bla = {
	var spg = ProtoTemplateDef(\SeqPlayerGroup).new(Pbind(\type, \rest));
	~currentNotes = nil!128;
	spg.makeListener({ arg child, msg, idx;
		//args.debug("args");
		[msg, idx].debug("arp note");
		if(msg == \play) {
			~currentNotes[idx] = (midinote:idx);
		} {
			~currentNotes[idx] = nil;
		}
   
	});
	ProtoDef(\piano).nektar(spg)
	
};
~bla.();
)

(
ControllerDef(\piano_arp, { arg def, target;
	var playergroup;
	playergroup = ProtoTemplateDef(\SeqPlayerGroup).new(target);
	MIDIdef.noteOn(\piano, { arg ... args;
		var midinote = args[1];
		var velocity = args[0];
		args.debug("generic on");
		playergroup.elAt(midinote).play((velocity:velocity, type:\rest));
	}).fix;
	MIDIdef.noteOff(\piano_off, { arg ... args;
		var midinote = args[1];
		args.debug("generic off");
		playergroup.elAt(midinote).stop;
	}).fix;
})
)

ControllerDef(\piano_arp).startControl(Pdef(\acid))
