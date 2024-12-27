FileSystemProject.load("holis/synthdef.scd");

Pdef(\zed).clear;
(
Pdef(\zed, 
	Ppar([
		Pbind(
			\dur, Pseq([1,1,2,1,4,1,2,4].scramble.normalizeSum*2,inf),
			\amp, 0.1,
			\idx, Pseq((0..7),inf),
			\octave, Pseq([0,0,-1,0,0,1],inf) + Pkey(\octave),
			\degree, Prout({ arg ev;
				//ev[\degree].choose.yield
				ev = ev[\degree].mirror1.wrapAt(ev[\idx]).yield;
				ev;
			}).loop,
		) <>
		Pbind(
			\instrument, \default,
			\degree, Pstep(Pseq([
				[0,3,7],
				[0,3,7]+4,
			],inf),2),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \basicbass,
			\lpf, 1000,
			\degree, Pstep(Pseq([
				[0,3,7],
				[0,3,7]+4,
			],inf),2),
			\octave, 4,
			\amp, 0.1/4,
		),
	]),
).play;
);


////////// try to Pstepize a whole pattern (PEnvGate ???)

(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([
			[0,3,7],
			[0,3,7]+4,
		],inf),
		\amp, 0.1,
	),
).play;
);

(
Pdef(\zed, 
	Ppar([
		Pbind(
			\dur, Pseq([1,1,2,1,4,1,2,4].scramble.normalizeSum*2,inf),
			\amp, 0.1,
			\idx, Pseq((0..7),inf),
			//\octave, Pseq([0,0,-1,0,0,1],inf) + Pkey(\octave),
			\degree, Prout({ arg ev;
				//ev[\degree].choose.yield
				//ev = ev[\degree].mirror1.wrapAt(ev[\idx]).yield;
				ev = ev[\degree].wrapAt(ev[\idx]).yield;
				ev;
			}).loop,
		) <>
		Pstep(Pdef(\melo), 2),
		Pbind(
			\instrument, \basicbass,
			\lpf, 1000,
			\degree, Pstep(Pseq([
				[0,3,7],
				[0,3,7]+4,
			],inf),2),
			\octave, 4,
			\amp, 0.1/4,
		),
	]),
).play;
);


////////// try to Pstepize a NoteTimeline


NoteTimeline(\melo).edit

(
// FAIL
Pdef(\zed, 
	Ppar([
		Pbind(
			\dur, Pseq([1,1,2,1,4,1,2,4].scramble.normalizeSum*2,inf),
			\amp, 0.1,
			\idx, Pseq((0..7),inf),
			//\octave, Pseq([0,0,-1,0,0,1],inf) + Pkey(\octave),
			//\degree, Prout({ arg ev;
				////ev[\degree].choose.yield
				////ev = ev[\degree].mirror1.wrapAt(ev[\idx]).yield;
				//ev = ev[\degree].wrapAt(ev[\idx]).yield;
				//ev;
			//}).loop,
		) <>
		Pstep(NoteTimeline(\melo).asPattern, 2),
		Pbind(
			\instrument, \basicbass,
			\lpf, 1000,
			\degree, Pstep(Pseq([
				[0,3,7],
				[0,3,7]+4,
			],inf),2),
			\octave, 4,
			\amp, 0.1/4,
		),
	]),
).play;
);


(
// independent patterns communicate with an envir variable
// SUCCESS!!!!
~midinotes = nil!128;
Pdef(\zed, 
	Ppar([
		
		Pbind(
			\dur, Pseq([1,1,2,1,4,1,2,4].scramble.normalizeSum*1,inf),
			\dur, Pseq([1,1,2,1,4,1,2,4].scramble/8,inf),
			\dur, 1/2,
			\amp, 0.1,
			\lag, 0.01,
			\idx, Pseq((0..7),inf),
			//\octave, Pseq([0,0,-1,0,0,1],inf) + Pkey(\octave),
			\octaveshift, Pseq([0,0,-1,0,0,1],inf),
			\midinote, Prout({ arg ev;
				//ev[\degree].choose.yield
				//ev = ev[\degree].mirror1.wrapAt(ev[\idx]).yield;
				var notes = topEnvironment[\midinotes].select { arg note;
					note.notNil and: { note[\type] != \rest } and: {note[\midinote].notNil}
				};
				var note = notes.wrapAt(ev[\idx]);
				if(note.notNil) {
					ev = ( note[\midinote] + ( ev[\octaveshift] * 12 ) ).yield;
				} {
					ev = \rest.yield;
				};
				ev;
			}).loop,
		),
		Prout({ arg ev;
			1000.do {
				ev.debug("ev");
				if(ev[\type] == \note) {

					~midinotes[ev[\midinote]] = ev;
					ev = ev.copy;
					ev[\finish] = {
						var xev = ev.copy;
						fork {
							xev[\sustain].wait;
							topEnvironment[\midinotes].debug("midinote");
							topEnvironment[\midinotes][xev[\midinote]] = nil;
						}
					};
				};
				//ev[\type] = \rest;
				ev[\instrument] = \basicbass;
				ev[\lpf] = 600;
				ev[\amp] = 0.1/8;
				ev = ev.yield;
			};
			ev;
		})<>
		NoteTimeline(\melo).asPattern,
		//Pbind(
			//\instrument, \basicbass,
			//\lpf, 1000,
			//\degree, Pstep(Pseq([
				//[0,3,7],
				//[0,3,7]+4,
			//],inf),2),
			//\octave, 4,
			//\amp, 0.1/4,
		//),
	]),
).play;
);


/// really independant patterns

// SUCCESS!!!!

(
Pdef(\zed, 
	Ppar([
		
		Prout({ arg ev;
			1000.do {
				ev.debug("ev");
				if(ev[\type] == \note) {

					~midinotes[ev[\midinote]] = ev;
					ev = ev.copy;
					ev[\finish] = {
						var xev = ev.copy;
						fork {
							xev[\sustain].wait;
							topEnvironment[\midinotes].debug("midinote");
							topEnvironment[\midinotes][xev[\midinote]] = nil;
						}
					};
				};
				//ev[\type] = \rest;
				ev[\instrument] = \basicbass;
				ev[\lpf] = 600;
				ev[\amp] = 0.1/8;
				ev = ev.yield;
			};
			ev;
		})<>
		NoteTimeline(\melo).asPattern,
		//Pbind(
			//\instrument, \basicbass,
			//\lpf, 1000,
			//\degree, Pstep(Pseq([
				//[0,3,7],
				//[0,3,7]+4,
			//],inf),2),
			//\octave, 4,
			//\amp, 0.1/4,
		//),
	]),
).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\dur, Pseq([1,1,2,1,4,1,2,4].scramble.normalizeSum*1,inf),
			\dur, Pseq([1,1,2,1,4,1,2,4].scramble/8,inf),
			\dur, 1/9,
			\dur, PdurStutter(Pseq((1..12),inf), 1),
			\amp, 0.1,
			\lag, 0.01,
			\idx, Pseq((0..7),inf),
			//\octave, Pseq([0,0,-1,0,0,1],inf) + Pkey(\octave),
			\octaveshift, Pseq([0,0,-1,0,0,1],inf),
			\midinote, Prout({ arg ev;
				//ev[\degree].choose.yield
				//ev = ev[\degree].mirror1.wrapAt(ev[\idx]).yield;
				var notes = topEnvironment[\midinotes].select { arg note;
					note.notNil and: { note[\type] != \rest } and: {note[\midinote].notNil}
				};
				var note = notes.mirror2.wrapAt(ev[\idx]);
				if(note.notNil) {
					ev = ( note[\midinote] + ( ev[\octaveshift] * 12 ) ).yield;
				} {
					ev = \rest.yield;
				};
				ev;
			}).loop,
		),
	])
)).play;
);



////////////// integrate in NoteTimeline
// SUCCESS!!!!

(
NoteTimeline(\melo).postChain.source = Prout({ arg ev;
	topEnvironment[\midinotes] = nil!128;
	1000.do {
		ev.debug("ev");
		if(ev[\type] == \note) {

			topEnvironment[\midinotes][ev[\midinote]] = ev;
			ev = ev.copy;
			ev[\finish] = {
				var xev = ev.copy;
				fork {
					xev[\sustain].wait;
					topEnvironment[\midinotes].debug("midinote");
					topEnvironment[\midinotes][xev[\midinote]] = nil;
				}
			};
		};
		//ev[\type] = \rest;
		ev[\instrument] = \basicbass;
		ev[\lpf] = 600;
		ev[\amp] = 0.1/8;
		ev = ev.yield;
	};
	ev;
})
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\dur, Pseq([1,1,2,1,4,1,2,4].scramble.normalizeSum*1,inf),
			\dur, Pseq([1,1,2,1,4,1,2,4].scramble/8,inf),
			\dur, 1/9,
			\dur, PdurStutter(Pseq((1..12),inf), 1),
			\amp, 0.1,
			\lag, 0.01,
			\idx, Pseq((0..7),inf),
			//\octave, Pseq([0,0,-1,0,0,1],inf) + Pkey(\octave),
			\octaveshift, Pseq([0,0,-1,0,0,1],inf),
			\midinote, Prout({ arg ev;
				//ev[\degree].choose.yield
				//ev = ev[\degree].mirror1.wrapAt(ev[\idx]).yield;
				var notes = topEnvironment[\midinotes].select { arg note;
					note.notNil and: { note[\type] != \rest } and: {note[\midinote].notNil}
				};
				var note = notes.mirror2.wrapAt(ev[\idx]);
				if(note.notNil) {
					ev = ( note[\midinote] + ( ev[\octaveshift] * 12 ) ).yield;
				} {
					ev = \rest.yield;
				};
				ev;
			}).loop,
		),
	])
)).play;
);


//////////// use local variable
// can't work this way
// have to reference the notetimeline in the Prout and i don't want to

(
NoteTimeline(\melo).postChain.source = Prout({ arg ev;
	var midinotes = nil!128;
	1000.do {
		ev.debug("ev");
		if(ev[\type] == \note) {

			topEnvironment[\midinotes][ev[\midinote]] = ev;
			ev = ev.copy;
			ev[\finish] = {
				var xev = ev.copy;
				fork {
					xev[\sustain].wait;
					topEnvironment[\midinotes].debug("midinote");
					topEnvironment[\midinotes][xev[\midinote]] = nil;
				}
			};
		};
		//ev[\type] = \rest;
		ev[\instrument] = \basicbass;
		ev[\lpf] = 600;
		ev[\amp] = 0.1/8;
		ev[\arpeggiator] = midinotes;
		ev = ev.yield;
	};
	ev;
})
)

Pdef(\part).clear;
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\dur, Pseq([1,1,2,1,4,1,2,4].scramble.normalizeSum*1,inf),
			\dur, Pseq([1,1,2,1,4,1,2,4].scramble/8,inf),
			\dur, 1/9,
			\dur, PdurStutter(Pseq((1..12),inf), 1),
			\amp, 0.1,
			\lag, 0.01,
			\idx, Pseq((0..7),inf),
			//\octave, Pseq([0,0,-1,0,0,1],inf) + Pkey(\octave),
			\octaveshift, Pseq([0,0,-1,0,0,1],inf),
			\midinote, Prout({ arg ev;
				//ev[\degree].choose.yield
				//ev = ev[\degree].mirror1.wrapAt(ev[\idx]).yield;
				var notes = ( ev[\arpeggiator] ?? { [] } ).select { arg note;
					note.notNil and: { note[\type] != \rest } and: {note[\midinote].notNil}
				};
				var note = notes.mirror2.wrapAt(ev[\idx]);
				if(note.notNil) {
					ev = ( note[\midinote] + ( ev[\octaveshift] * 12 ) ).yield;
				} {
					ev = \rest.yield;
				};
				ev;
			}).loop,
		),
	])
)).play;
);


////////////////////// add arpeggiator to midi controller
// doesnt work because sustain is not available with midi controller


(
Pdef(\arpeg1, Prout({ arg ev;
	var midinotes = nil!128;
	1000.do {
		ev.debug("ev");
		if(ev[\type] == \note) {

			topEnvironment[\midinotes][ev[\midinote]] = ev;
			ev = ev.copy;
			ev[\finish] = {
				var xev = ev.copy;
				fork {
					var sus = ( xev.use { ~sustain.value } );
					sus.debug("sus");
					sus.wait;
					topEnvironment[\midinotes].debug("midinote");
					topEnvironment[\midinotes][xev[\midinote]] = nil;
				}
			};
		};
		//ev[\type] = \rest;
		ev[\instrument] = \basicbass;
		ev[\lpf] = 600;
		ev[\amp] = 0.1/8;
		ev[\arpeggiator] = midinotes;
		ev = ev.yield;
	};
	ev;
}))
)

(
Pdef(\melo2, 
	Pdef(\arpeg1) <>
	Pbind(
		\instrument, \default,
	)
);
);

NoteTimeline(\melo2, Pdef(\melo2))
NoteTimeline(\melo2).edit

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\dur, Pseq([1,1,2,1,4,1,2,4].scramble.normalizeSum*1,inf),
			\dur, Pseq([1,1,2,1,4,1,2,4].scramble/8,inf),
			\dur, 1/9,
			\dur, PdurStutter(Pseq((1..12),inf), 1),
			\amp, 0.1,
			\lag, 0.01,
			\idx, Pseq((0..7),inf),
			//\octave, Pseq([0,0,-1,0,0,1],inf) + Pkey(\octave),
			\octaveshift, Pseq([0,0,-1,0,0,1],inf),
			\midinote, Prout({ arg ev;
				//ev[\degree].choose.yield
				//ev = ev[\degree].mirror1.wrapAt(ev[\idx]).yield;
				var notes = topEnvironment[\midinotes].select { arg note;
					note.notNil and: { note[\type] != \rest } and: {note[\midinote].notNil}
				};
				var note = notes.mirror2.wrapAt(ev[\idx]);
				if(note.notNil) {
					ev = ( note[\midinote] + ( ev[\octaveshift] * 12 ) ).yield;
				} {
					ev = \rest.yield;
				};
				ev;
			}).loop,
		),
	])
)).play;
);

///////////////// filter pattern

NoteTimeline(\melo).edit
NoteTimeline(\melo).presetCompileString.editorInsert
(
NoteTimeline('melo').param = Param(Pdef('NoteTimeline_default'), 'midinote');
NoteTimeline('melo').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.0, \midinote: 67.0, \playDur: 0.0, \relDur: 0.0, \sustain: 2.0, ),
	(\absTime: 0.0, \dur: 0.0, \midinote: 60.0, \playDur: 0.0, \relDur: 0.0, \sustain: 2.0, ),
	(\absTime: 0.0, \dur: 2.0, \midinote: 63.0, \playDur: 2.0, \relDur: 2.0, \sustain: 2.0, ),
	(\absTime: 2.0, \dur: 0.0, \midinote: 68.0, \playDur: 0.0, \relDur: 0.0, \sustain: 2.0, ),
	(\absTime: 2.0, \dur: 0.0, \midinote: 72.0, \playDur: 0.0, \relDur: 0.0, \sustain: 2.0, ),
	(\absTime: 2.0, \dur: 2.0, \midinote: 65.0, \playDur: 2.0, \relDur: 2.0, \sustain: 2.0, ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

(
~arpize = { arg pattern, arp;
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
			[arptime, inptime, arpval, inpval].debug("input loop 0");
			notes = notes.add( inpval );
			inptime = inptime + inpval.delta;
			inpval = inpstr.next(Event.default);
			inpval[\absTime] = inptime;
		};
		arpval.currentNotes = notes;

		notes = notes.select { arg note;
			note.notNil and: { [\rest, \start, \end].includes(note[\type]).not } and: {note[\midinote].notNil}
		};

		[arptime, inptime].debug("yield state 0");
		notes.collect({ arg ev; ev.use { ~midinote.value } }).debug("currentNotes yield 0");
		ev = arpval.yield; // yield 0
		

		loop { // unroll arp stream
			// inpval contains note with abstime 2
			[arptime, inptime, arpval, inpval].debug("arp loop 0");
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
				[arptime, inptime, arpval, inpval].debug("input loop 1");
				notes = notes.add( inpval );
				notes.class.debug("notes in input loop 1");
				inptime = inptime + inpval.delta;
				inpval = inpstr.next(Event.default);
				inpval[\absTime] = inptime;
			};

			notes = notes.select { arg note;
				note.notNil and: { [\rest, \start, \end].includes(note[\type]).not } and: {note[\midinote].notNil}
			};

			notes = notes.select({ arg note;
				var endtime = note[\absTime] + note.use { ~sustain.value };
				[endtime, arptime, endtime > arptime, note].debug("select note ? ");
				endtime > arptime; // 2 > 1/8
			});

			arpval.currentNotes = notes.copy;
			[arptime, inptime].debug("yield state 1");
			notes.collect({ arg ev; ev.use { ~midinote.value } }).debug("currentNotes yield 1");
			ev = arpval.yield; // yield 1 (arptime == 1/8)

		}

	});

};
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		~engine <> ~arpize.(NoteTimeline(\melo).asPattern,  ~arp)
		
	]).trace(label:"aaaa")
)).play;
);
~s= ~arpize.(NoteTimeline(\melo).asPattern,  ~arp).asStream;
~ev = ~s.next(Event.default)

~s=Pdef(\part).asStream
~ev.play

(
	~arp = Pbind(
		\dur, Pseq([1,1,2,1,4,1,2,4].scramble.normalizeSum*1,inf),
		\dur, Pseq([1,1,2,1,4,1,2,4].scramble/8,inf),
		\dur, 1/9,
		//\dur, PdurStutter(Pseq((1..12),inf), 1),
		\dur, 1/8,
		\amp, 0.1,
		\idx, Pseq((0..3),inf),
		//\octave, Pseq([0,0,-1,0,0,1],inf) + Pkey(\octave),
		//\octaveshift, Pseq([0,0,-1,0,0,1],inf),
	);
	~engine = Pbind(
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
)

////////// use notes properties instead of arp ones

(
Pdef(\meloins, 
	Pbind(
		\instrument, \saw,
	)
);
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		~engine <> ~arpize.(NoteTimeline(\melo).asPattern,  ~arp)
		
	]).trace(label:"aaaa")
)).play;
);

~ev = (sustain:4)
~ev[\sustain] = nil
~ev
~ev2 = (sustain:3)
~ev2.putAll(~ev)
~ev2
kk
(
~engine = Pbind(
	\midinote, Prout({ arg ev;
		//ev[\degree].choose.yield
		//ev = ev[\degree].mirror1.wrapAt(ev[\idx]).yield;
		var note, notes;
		notes = ev[\currentNotes].select { arg note;
			note.notNil and: { [\rest, \start, \end].includes(note[\type]).not } and: {note[\midinote].notNil}
		};
		notes = notes.sort({ arg a, b; a.midinote < b.midinote });
		notes.debug("notes");
		note = notes.wrapAt(ev[\idx]).copy;
		if(note.notNil) {
			note = note.copy; // else arpize is perturbed
			note[\sustain] = nil;
			note[\dur] = nil;
			note[\delta] = nil;
			ev.putAll(note);
			ev = ( note[\midinote] + ( ev[\octaveshift] ? 0 * 12 ) ).yield;
		} {
			ev = \rest.yield;
		};
		ev;
	}).loop,
);
)

//////// use same engine with SeqPlayerGroup

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
	~arp = Pbind(
		\dur, Pseq([1,1,2,1,4,1,2,4].scramble.normalizeSum*1,inf),
		\dur, Pseq([1,1,2,1,4,1,2,4].scramble/8,inf),
		\dur, 1/9,
		\dur, 1/4,
		\amp, 0.1,
		\idx, Pseq((0..8),inf),
		\dur, PdurStutter(Pseq((1..12),inf), 1),
		//\octave, Pseq([0,0,-1,0,0,1],inf) + Pkey(\octave),
		//\octaveshift, Pseq([0,0,-1,0,0,1],inf),
	);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		~engine <> Pbind(\currentNotes, Pfunc({ topEnvironment[\currentNotes] })) <> ~arp
		
	])
)).play;
);

////////////////// use SeqPlayerGroup

(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
		\amp, 0.1,
	)
).play;
);

Pdef(\melo).clear

ParamProto.init
~a = ProtoTemplateDef(\SeqPlayerGroup).new(Pdef(\melo))
~a.elAt(0)
FileSystemProject.load("libdef/piano.scd")
(
~bla = {
	var spg = ProtoTemplateDef(\SeqPlayerGroup).new(Pbind(\type, \rest));
	~midinotes = nil!128;
	spg.makeListener({ arg child, msg, idx;
		//args.debug("args");
		[msg, idx].debug("arp note");
		if(msg == \play) {
			~midinotes[idx] = (midinote:idx);
		} {
			~midinotes[idx] = nil;
		}
   
	});
	ProtoDef(\piano).nektar(spg)
	
};
~bla.();
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\dur, Pseq([1,1,2,1,4,1,2,4].scramble.normalizeSum*1,inf),
			\dur, Pseq([1,1,2,1,4,1,2,4].scramble/8,inf),
			\dur, 1/9,
			\dur, PdurStutter(Pseq((1..12),inf), 1),
			\amp, 0.1,
			\lag, 0.01,
			\idx, Pseq((0..7),inf),
			//\octave, Pseq([0,0,-1,0,0,1],inf) + Pkey(\octave),
			\octaveshift, Pseq([0,0,-1,0,0,1],inf),
			\midinote, Prout({ arg ev;
				//ev[\degree].choose.yield
				//ev = ev[\degree].mirror1.wrapAt(ev[\idx]).yield;
				var notes = topEnvironment[\midinotes].select { arg note;
					note.notNil and: { note[\type] != \rest } and: {note[\midinote].notNil}
				};
				var note = notes.mirror2.wrapAt(ev[\idx]);
				if(note.notNil) {
					ev = ( note[\midinote] + ( ev[\octaveshift] * 12 ) ).yield;
				} {
					ev = \rest.yield;
				};
				ev;
			}).loop,
		),
	])
)).play;
);




