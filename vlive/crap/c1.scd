SCDoc.indexAllDocuments

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
		\lpfr, 1,
	)
);
)

NoteTimeline(\mynotes, Pdef(\myinstrument));
NoteTimeline(\mynotes).asPattern
NoteTimeline(\mynotes).quant

// create an event list from a pattern
(
	NoteTimeline(\mynotes).eventList = TimelineEventList.newFrom(
		Pbind(
			\instrument, \default,
			\degree, Pseq((1..20),1),
			\dur, 1/8,
			\amp, 0.1,
		),
		100 // maximum number of notes, required else infinite pattern will hang forever (default:100)
	);
)



Prand( 4.collect({ arg x; NoteTimeline(\mynotes).asPattern(x, 1, 1) }) ).play
NoteTimeline(\mynotes).asPattern(1/2, 2, 1).play
NoteTimeline(\mynotes).asPattern(2, 1).play
NoteTimeline(\mynotes).asPatternAbs(1, 2).play
NoteTimeline(\mynotes).asPatternSlices
NoteTimeline(\mynotes).asPatternSlice(\start, "blax")

ClipTimeline(\bla).edit



(
SynthDef(\playersec, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	//speed = speed * ( SinOsc.kr(1.3) * 1 + 1 ); // modulate rate ?
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
)

~mybuffer = Buffer.readChannel(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav", channels:[0,0]); 

(
Pdef(\zed, 
	Pbind(
		\instrument, \playersec,
		\bufnum, ~mybuffer,
		\legato, 1,
		\dur, 2,
		\gain, 1,
	)
).play;
);
