
// see libdef/macros.scd

(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5).poll);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\dur, 2,
			\lpfr, ~pnoteEnv_adsr.(Pseq([0.1,2.1],1),0.1,0.2,Pseq([0.3,1],inf),3),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\lpfr, Pseq([
				~pnoteEnv_adsr.(Pseq([0.1,2.1],1),0.1,0.8,0.1),
				~pnoteEnv_adsr.(0.03,Pseq([0.4,0.1],1),0.8,0.1),
			],1),
			\dur, 1,
			\amp, 0.1,
		).trace,
		
	])
)).play;
);

//////////
(
// test event should be same dur
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\lpfr, Pseq([
				~pnoteEnv.([0.5,3,3,0.5],[0.01,1-0.02,0.01]/2).keep(1),
			],1),
			\legato, 1/2,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
// test event should be same dur adsr
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\lpfr, Pseq([
				~pnoteEnv_adsr.(0.01,0,3,0.01).keep(1),
			],1),
			\legato, 1/2,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
// test local bus with overlapping events
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\lpfr, Pseq([
				~pnoteEnv.([Pseq([1,3,0.3],4),0.1,1,8],[1,0.1,2]/2),
			],1),
			\dur, 1,
			\legato, 1.6,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
// test local bus with lot of overlapping events
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\lpfr, Pseq([
				~pnoteEnv.([Pseq([1,3,0.3],4),0.1,1,8],[1,0.1,2]*2),
			],2),
			\dur, 0.1,
			\legato, 0.6,
			\amp, 0.1,
		),
		
	])
)).play;
);
////////// test multi keys
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\lpfr, Pseq([
				~pnoteEnv.([Pseq([1,3,0.3],4),0.1,1,8],[1,0.1,1]/2),
			],2),
			\rq, ~pnoteEnv.([0.1,0.9,0.3],[1,1]/4),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

////////// test free bus

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\lpfr, Pseq([
				~pnoteEnv.([Pseq([1],1),0.1,1,8],[1,0.1,1]/4),
			],1),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\testunroll,
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\lpfr, Pseq([
				//~pnoteEnv.([Pseq([1],1),0.1,1,8],[1,0.1,1]/4, 0,1,0,1,\lpfr),
				~pnoteEnv.([Pseq([1],1),0.1,1,8],[1,0.1,1], 0,1,0,1),
			],4),
			\dur, 4/1,
			\amp, 0.1,
		),
).play;
);
Pdef(\testunroll).stop

///////////



/////////// tests
// tests for freeing resources
// - test when pattern stop by itself
// - test when pattern is stopped by Pfindur
// - test when pattern is stopped by .stop
// - test when pattern is stopped by cmd-dot
// - test when stopped in middle of note


//////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\dur, 2,
			\lpfr, PnoteEnv.adsr(Pseq([0.1,2.1],inf),0.1,0.2,Pseq([0.3,1],inf),3),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\amp, 0.1,
		),
		
	])
)).play;
);

/// test Pmono

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\saw,
			\note, Pseq([1,5,2,0],inf),
			\lpfr, PnoteEnv.adsr(Pseq([0.1,2.1],inf),0.1,0.2,Pseq([0.3,1],inf),3, levelBias:1),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

PnoteEnv.adsr(Pseq([0.1,2.1],1),0.1,0.2,Pseq([0.3,1],inf),3).asStream

SCDoc.indexAllDocuments

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([1,5,2,0],inf),
			\lpfr, Pseq([
				PnoteEnv.adsr(Pseq([0.1,0.8],1),0.1,0.8,0.1),
				PnoteEnv.adsr(0.03,Pseq([0.8,0.2],1),0.2,0.1,2),
			],1),
			\dur, 1,
			\amp, 0.1,
		).trace,
		
	])
)).play;
);

//////////

Pbind(\dur, 1/3, \note, Pstep(Pseq([0,1,2],inf),1/4)).play

/////

(
Pdef(\doc,
	Pbind(
		\instrument, \saw,
		\note, Pseq([1,5,2,0],inf),
		\lpfr, Pseq([
			// no finite pattern mean infinite pattern, so I use .keep to get the first value and stop
			PnoteEnv([0.5,2,1,5],[0.1,0.4,0.4]/2).keep(1),
			PnoteEnv([0.5,Pwhite(0.1,5,1)],[0.4]),
		],4),
		\legato, 1/2,
		\dur, 1,
		\amp, 0.1,
	),

).play;
)

/////// PmodEnv
(
Pdef(\doc,
	Pmono(
		\saw,
		\note, Pseq([1,5,2,0],inf),
		\lpfr, Pseq([
			PmodEnv(Prand([1/2,4,1],10), Pwhite(0.1,2,inf), Prand([-1,0,1],inf)),
		],inf),
		\legato, 1/2,
		\dur, 1/2,
		\amp, 0.1,
	),
).play;
)
/////// PpatEnv

(
SynthDef(\sawenv, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	var env;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	env = EnvGen.kr(\lpadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0, levelBias:\lpfr.kr(1.1));
	sig = RLPF.ar(sig, env * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\doc,
	Pbind(
		\instrument, \sawenv2,
		\note, Pseq([1,5,2,0],inf),
		\lpfr, 1,
		// env must have same size as env in SynthDef
		\lpenv, PpatEnv( Pwhite(0.1,2.9,inf)!4, Pwhite(0.1,1/2,inf)!3 ),
		\legato, 1,
		\dur, 1,
	),
).play;
)


(
SynthDef(\sawenv2, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	var env;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	env = EnvGen.kr(\lpenv.kr(Env([1,2,1,2],[0.1,0.8,0.1].normalizeSum)), gate);
	sig = RLPF.ar(sig, env * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\doc,
	Pbind(
		\instrument, \sawenv2,
		\note, Pseq([1,5,2,0],inf),
		\lpfr, 1,
		// env must have same size as env in SynthDef
		\lpenv, PpatEnv( Pwhite(0.1,2.9,inf)!4, Pwhite(0.1,1/2,inf)!3 ),
		\adsr, PpatEnv.adsr(Pwhite(0.01,0.4,inf),0.1,0.8,Pwhite(0.01,0.4,inf)),
		\legato, 1/3,
		\dur, 1,
	),
).play;
)



(
Pdef(\doc,
	Pbind(
		\instrument, \sawenv,
		\note, Pseq([1,5,2,0],inf),
		\lpadsr, Pseq([
			[ Env.adsr(0.1,0.1,0.2,0.2,3) ],
			[ Env.adsr(0.6,0.1,0.2,0.2,3) ],
		],inf),
		\lpadsr, PpatEnv.adsr(Pseq([0.1,0.6],inf),0.1,0.2,0.2,3),
	),
).play;
)

(
Pdef(\doc,
	Pbind(
		\instrument, \sawenv,
		\note, Pseq([1,5,2,0],inf),
		\lpadsr, Pseq([
			[ Env.adsr(0.1,0.1,0.2,0.2,3) ],
			[ Env.adsr(0.9,0.1,0.2,0.2,3) ],
		],inf),
		\lpadsr, PpatEnv.adsr(Pseq([0.1,0.9],inf),0.1,0.2,0.2,3),
	),
).play;
)

///////////////////////////////////////////////////////////
///////////////////
// new method: yield sub-event and play them in \finish


(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\group, Prout({ arg ev;
			ev[\finish] = { arg ev;
				ev.debug("ev");
				ev.keys.do { arg key, idx;
					if(ev[key].isKindOf(Event)) {
						if([\group, \bus].includes(ev[key][\type])) {
							ev[key].play;
						};
					};
				};
			};
			(\type: \group, \callback: { arg ev; GroupDef(\hey, nodeID:ev[\id].debug("id")); ev.debug("envir"); }).yield;
		}),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
Event
~g = GroupDef(\bla)
~ig = Group.basicNew(s, ~g.nodeID)
~ig.free
~g.nodeID

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\group, Prout({ arg ev;
			ev[\finish] = { arg ev;
				ev.debug("ev");
				ev.keys.do { arg key, idx;
					if(ev[key].isKindOf(Event)) {
						if([\controlBus, \group, \bus].includes(ev[key][\type])) {
							var res;
							res = ev[key].play;
							res.debug("res");
						};
					};
				};
			};
			(\type: \controlBus, \callback: { arg ev; 
				ev[\id].debug("index"); ev.debug("envir"); 


			}).yield;
		}),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
Bus
