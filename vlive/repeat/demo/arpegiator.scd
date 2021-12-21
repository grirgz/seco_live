
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
