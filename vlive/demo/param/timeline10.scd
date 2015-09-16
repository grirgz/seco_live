// API design draft

XEventList.newFrom(
	Pdef(\bla)
)

Pdef(\main,
	MidinoteTimeline(\plop) <> Pdef(\plop)
);

Pdef(\main,
	Pseq([
		MidinoteTimeline(\plop),
		MidinoteTimeline(\plop2),
	]) <> Pdef(\plop)
);

~bank = BankList.newFrom( {MidinoteTimeline.newInstance } ! 8);


PbankDict
DictStepList.newFrom([0,1,0,1,0])
Pdict(~bank, Pseq([0,1,0,2]));

MidinoteTimeline.edit;

ParamTimeline(\hey, Param(Ndef(\bla), \freq));

ParamTimeline.newInstance(Param(Ndef(\bla), \freq))

ClipTimeline(\main)

// don't work: paramtimeline need at least the spec of level
ParamTimeline(\niak) <> ParamEnv(Param(Ndef(\bla), \freq))


// need to choose if the event types are independent of high level class or not

(
	type, \paramTimeline,
	timeline: ParamTimeline(\hey),
	sustain : 4,
	dur: 1,
)

(
	type, \noteTimeline,
	timeline: MidinoteTimeline(\hey),
	sustain : 4,
	dur: 1,
)

(
	type, \clipTimeline,
	timeline: MidinoteTimeline(\hey),
	sustain : 4,
	dur: 1,
)

(
	type, \pattern,
	pattern: Pdef(\plop),
	sustain : 4,
	dur: 1,
)

(
	type, \player,
	pattern: Ndef(\plop),
	sustain : 4,
	dur: 1,
)

MidinoteTimeline : NoteTimeline {
	NoteTimeline(master: Pdef(\xx), key: \midinote, spec:)
}

MidinoteTimeline(\plop, Param(Pdef(\yaa), \midinote))
NoteTimeline(\plop, Param(Pdef(\yaa), \midinote))
NoteTimeline(\plop, Param(Pdef(\yaa), \freq))

NoteTimeline(\plop, Param(StepSeq(\yaa).track(0), \freq))

NoteTimeline.newInstance.asEvent // ready to embed in a ClipTimeline

NoteEvent(\hey).edit; // in window, define instrument and based on specs of this instrument appear different parameters
NoteEvent(\hey).paramGroup; // return a paramGroup controlling all the fields of this NoteEvent
// must have a way to define a set of shortcut params we want to tweak, like a group of eight

NoteTimeline(\plop, Param(NoteEvent(\hey), \freq))

// kinds of instrument like
// - just an event with different value for parameters of synthdef and an instrument
// - same but based on a Pdef
// - includes concurrent instruments, used by DrumRack
// - includes concurrent instruments, modulators, envTimelines, effects

/////////////////////////////////////////// scenario

// define some sounds
(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
});

Ndef(\plop2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
});

SynthDef(\sinosc, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef(\sinosc, Pbind(
	\instrument, \sinosc,
	\degree, Pseq([0],inf),
	\lpfac, Pkeyd(\lpfac, 1),
	\dur, 1,
	\amp, 0.1
));


);

ClipTimeline(\main).edit; // add plop and plop2 to timeline with two tracks

ParamTimeline(\freq, Param(Ndef(\plop2), \freq));
ParamTimeline(\mainfreq, Param(BusDef(\mainenv, \control), \freq));
ParamTimeline(\lpfac, Param(Pdef(\sinosc), \lpfac));

// add freq and mainfreq to two others tracks of cliptimeline main

NoteTimeline(\melo, Param(SynthDesc(\sinosc), \midinote)) // not sure if really the way to do
NoteTimeline(\melo, Param(Pdef(\sinosc), \midinote))


DrumRack(\perc, StepSeq(\score).asCoinStep <> Pbind(\dur, 1/8)); // add drumrack perc to a track of clip timeline

//-------
StepSeq(\score).edit;
DrumRack(\test).edit;
//-------
StepSeq(\score).stepseq.playerWrapper.target = Pdef(\main)

StepSeq(\score).stepseq.set_track_count(8)

//////////////////// after

//StepEvent.newFrom(SynthDesc(\sinosc))

NdefMixerChannel(\yep); // now can choose this channel for out argument of Pdef and Ndef and choose this channel for in argument of Ndef effects




// add 

Ppar(
	ClipTimeline(\main),

)

Project(\lib).load;
Project(\project1).open;

ParamTimeline.newFrom(\automat, 
	[
		Param(Ndef(\plop2), \freq),
		Param(Ndef(\plop2), \lpfac),
	].collect({ arg x; ParamTimeline.newInstance(x) })
);
ProjectLib(\main) = ClipTimeline(\main)

