// a simple SynthDef for demo purpose
(
SynthDef(\saw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

// just accessing a key automatically create the timeline since there is no other required arguments
NoteTimeline(\mynotes);

// show the GUI
NoteTimeline(\mynotes).edit;

// play/stop it
NoteTimeline(\mynotes).play;
NoteTimeline(\mynotes).stop;

// embed in a pattern
(
Pdef(\mypat, Ppar([
	Pbind(
		\instrument, Pseq([\default, \saw],inf),
	) <> NoteTimeline(\mynotes).asPattern,
])).play;
)

// use a Pdef as the source of event to be able to change it live
(
Pdef(\myinstrument, 
	// the Pdef should contains a Pbind else NoteTimeline will not find the \instrument key to guess arguments of the SynthDef
	Pbind(
		\instrument, \saw,
		\lpfr, Pseq([1,2],inf),
	)
);
)

NoteTimeline(\mynotes, Pdef(\myinstrument));

// create an event list from a pattern
(
	NoteTimeline(\mynotes).eventList = TimelineEventList.newFrom(
		Pbind(
			\instrument, \default,
			\degree, Pseq((1..32),inf) % Pseq((8..16),inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		128 // maximum number of notes, required else infinite pattern will hang forever (default: FIXME)
	);
)

/////////////////////////////////

NoteTimeline(\mynotes).eventList.print
NoteTimeline(\mynotes).edit

NoteTimeline(\mynotes2).eventList.print
NoteTimeline(\mynotes2).edit

(
	TimelineEventList.newFrom(
		Pbind(
			\instrument, \default,
			\degree, Pseq((1..20),1),
			\midinote, Pkey(\midinote),
			\dur, 1/8,
			\amp, 0.1,
		),
		100 // maximum number of notes, required else infinite pattern will hang forever (default: FIXME)
	);
)

(
	NoteTimeline(\mynotes).eventList = TimelineEventList.newFrom(
		Pbind(
			\instrument, \default,
			\degree, Pseq([0,1,1,1,1,1]),
			\dur, 1/8,
			\amp, 0.1,
		),
		128 // maximum number of notes, required else infinite pattern will hang forever (default: FIXME)
	);
)



NoteTimeline(\mynotes).edit;
NoteTimeline(\mynotes).edit;
NoteTimeline(\mynotes).eventList
ClipTimeline(\bb).edit
NoteTimeline(\xx).edit;
NoteTimeline(\xx2).edit;
NoteTimeline(\xx).editor.isParamAutomated(\velocity)

(
Pdef(\sawtest, 
	Pbind(
		\instrument, \saw,
		\amp, 0.1,
	)
).play;
);

NoteTimeline(\sawtest3, Pdef(\sawtest)).edit
