
(
ProtoTemplateDef(\Arp, (

	arper: { arg self, pattern, arp, engine;
		( engine ?? { self.engine } ) <> self.arpize(pattern, arp);
	},

	arperlive: { arg self, notefun, pattern, arp, engine;
		( engine ?? { self.engine } ) <> Pbind(\currentNotes, Pfunc(notefun)) <> arp <> pattern
	},

	arpize: { arg self, pattern, arp;
		Prout({ arg ev;
			var inpstr = pattern.asStream;
			var arpstr = arp.asStream;
			var arpval;
			var inpval;
			var arptime; // arp pattern absolute time cursor
			var inptime; // input pattern absolute time cursor
			var nextarptime; // next time to yield currentNotes from arp.delta
			var notes;
			var delta;

			inptime = 0;
			inpval = inpstr.next(Event.default);
			inpval[\absTime] = inptime;

			arptime = 0;
			arpval = arpstr.next(ev);
			arpval[\absTime] = arptime;

			if(arpval.isNil or: inpval.isNil) {
				nil.yield;
			};
			notes = List[];

			//patval.debug("patval");
			while { 
				inptime == 0;
			} {
				//[arptime, inptime, arpval, inpval].debug("input loop 0");
				notes = notes.add( inpval );
				inptime = inptime + inpval.delta;
				inpval = inpstr.next(Event.default);
				inpval[\absTime] = inptime;
			};
			arpval.currentNotes = notes;

			notes = notes.select { arg note;
				note.notNil and: { [\rest, \start, \end].includes(note[\type]).not } and: {note[\midinote].notNil}
			};

			//[arptime, inptime].debug("yield state 0");
			//notes.collect({ arg ev; ev.use { ~midinote.value } }).debug("currentNotes yield 0");
			ev = arpval.yield; // yield 0


			loop { // unroll arp stream
				// inpval contains note with abstime 2
				//[arptime, inptime, arpval, inpval].debug("arp loop 0");
				arptime = arptime + arpval.delta;
				arpval = arpstr.next(ev);
				arpval[\absTime] = arptime;
				//arpval.debug("arpval");
				if(arpval.isNil or: inpval.isNil) {
					nil.yield;
				};

				//patval.debug("patval");
				while { // unroll input stream until it catch up arp stream time
					inptime <= arptime; // 2 < 1/8
				} {
					//[arptime, inptime, arpval, inpval].debug("input loop 1");
					notes = notes.add( inpval );
					//notes.class.debug("notes in input loop 1");
					inptime = inptime + inpval.delta;
					inpval = inpstr.next(Event.default);
					inpval[\absTime] = inptime;
				};

				notes = notes.select { arg note;
					note.notNil and: { [\rest, \start, \end].includes(note[\type]).not } and: {note[\midinote].notNil}
				};

				notes = notes.select({ arg note;
					var endtime = note[\absTime] + note.use { ~sustain.value };
					//[endtime, arptime, endtime > arptime, note].debug("select note ? ");
					endtime > arptime; // 2 > 1/8
				});

				arpval.currentNotes = notes.copy;
				//[arptime, inptime].debug("yield state 1");
				//notes.collect({ arg ev; ev.use { ~midinote.value } }).debug("currentNotes yield 1");
				ev = arpval.yield; // yield 1 (arptime == 1/8)

			}

		});

	},

	engine_old: { arg self;
		
		Pbind(
			\midinote, Prout({ arg ev;
				//ev[\degree].choose.yield
				//ev = ev[\degree].mirror1.wrapAt(ev[\idx]).yield;
				var note, notes;
				notes = ev[\currentNotes].select { arg note;
					note.notNil and: { [\rest, \start, \end].includes(note[\type]).not } and: {note[\midinote].notNil}
				};
				notes = notes.sort({ arg a, b; a.midinote < b.midinote });
				notes.debug("notes");
				note = notes.wrapAt(ev[\idx]);
				if(note.notNil) {
					ev = ( note[\midinote] + ( ev[\octaveshift] ? 0 * 12 ) ).yield;
				} {
					ev = \rest.yield;
				};
				ev;
			}).loop,
		);
	},

	engine: { arg self;
		// support arrayed idx
		// support rest in arp
		
		Pbind(
			\midinote, Prout({ arg ev;
				//ev[\degree].choose.yield
				//ev = ev[\degree].mirror1.wrapAt(ev[\idx]).yield;
				var note, notes;
				var resnotes;
				var eidx;
				var compose;
				compose = { arg eva, evb;
					eva.merge(evb, { arg a, b; a });
				};
				notes = ev[\currentNotes].select { arg note;
					note.notNil and: { [\rest, \start, \end].includes(note[\type]).not } and: {note[\midinote].notNil}
				};
				notes = notes.sort({ arg a, b; a.midinote < b.midinote });
				//notes.debug("notes");
				eidx = ev[\idx];
				resnotes = notes.wrapAt(eidx);
				if(resnotes.isSequenceableCollection) {
					note = resnotes.last.copy;
					note[\sustain] = nil;
					note[\legato] = nil;
					note[\dur] = nil;
					note[\delta] = nil;
					ev.putAll( compose.(ev, note) );
					ev = resnotes.collect { arg rnote, idx;
						( rnote[\midinote] + ( ev[\octaveshift] ? 0 * 12 ) )
					}.yield;
					
				} {
					if(resnotes.notNil) {
						note = resnotes.copy;
						note[\sustain] = nil;
						note[\legato] = nil;
						note[\dur] = nil;
						note[\delta] = nil;
						//ev.putAll(note);
						ev.putAll( compose.(ev, note) );
						//note.putAll(ev);
						//ev = note;
						ev = ( resnotes[\midinote] + ( ev[\octaveshift] ? 0 * 12 ) ).yield;
					} {
						ev = \rest.yield;
					};
				};
				ev;
			}).loop,
		);
	},

	filterEngine: { arg self;
		
	},

	demux: { arg self, pat;
		Prout({ arg ev;
			pat.do ({ arg item, idx;
				if(item.isSequenceableCollection) {
					//item.drop(-1).do { arg subitem, idx;
						//subitem[\delta] = subitem.delta;
						//subitem[\dur] = 0;
					//};
					item.do { arg subitem, idx;
						ev = subitem.yield;
					};
				} {
					ev = item.yield;
				};
				ev;
			});
		})
		
	},

));

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
	var arper = ProtoTemplateDef(\Arp).arper(sourcepat, arp);
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
WindowDef(\Arp).front(Pbindef(\arp));

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
		ProtoTemplateDef(\Arp).demux(Prout({ arg ev;
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
