
(
Ndef(\bip, { arg freq=800, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * Duty.kr(1/8/~t, 0, Dseq([
		Dseq([
			1,0,1,0,
		],4),
		Dseq([
			1,1,1,1,
		],3*4),
	],1));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
Ndef(\bip).clear
(
Ndef(\bip2, { arg freq=570, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, 2*freq);
	sig = sig * Duty.kr(1/8/~t, 0, Dseq([
		Dseq([
			1,0,1,0,
		],4),
		Dseq([
			1,1,1,1,
		],3*4),
	],1));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
(
Ndef(\bip3, { arg freq=921, pan=0, amp=0.1;
	var sig;
	freq  = [800, 512];
	sig = LFPulse.ar(freq);
	sig = sig + LFTri.ar(freq * 1.01 / 2);
	sig = RLPF.ar(sig, 4*freq);
	sig = sig * Duty.kr(1/8/~t, 0, Dseq([
		Dseq([
			1,0,1,0,
		],4),
		Dseq([
			1,1,1,1,
		],3*4),
	],1));
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);



TrackTimeline(\grid1, TrackDef(\grid1)).edit
TrackTimeline(\grid1, TrackDef(\grid1)).clear

TrackDef(\grid1).edit
TrackDef(\grid1).childAt(Point(0,0)).play
(
PlayerEvent((
receiver: {PlayerWrapper(TrackDef(\grid1).childAt(0).childAt(0))}
)).play
)
KitTimeline(\smp).edit

////////////////////////////////////////// draft

(

ParamProto.init(true);
ClipTimeline(\bip).clear;
NoteTimeline(\note1, Param(Pdef(\not, Pbind()), \midinote));
ClipTimeline(\bip).edit;
)
ClipTimeline(\bip).eventList;
ClipTimeline(\bip).edit;
ClipTimeline(\bip).asPattern.asStream.nextN(10,())
NoteTimeline(\note1).edit
NoteTimeline(\note1).eventList
Pdef

NoteTimeline(\note1, Param(Pdef(\not, Pbind()), \midinote)).edit;
ClipTimeline(\bip).eventType
ClipTimeline(\bip).eventList[1].timeline
ClipTimeline(\bip).eventList[0].timeline.label
~kitTimeline

Ndef(\bip).quant
Ndef.defaultQuant = 4

NodeProxy
Ndef(\bip).play
Ndef(\bip).spawn
Ndef(\bip).send
Ndef(\bip).wakeUp
Ndef(\bip).stop
Ndef(\bip).end

Ndef(\bip).sendAll;
(
//Ndef(\bip).stop;
Ndef(\bip).send;
Ndef(\bip).monitor.play;
)

ClipTimeline(\bip).eventList
PlayerWrapper(Ndef(\bip)).playNow


(
	Pembed(Pseq([

		PatternEvent((
		  'playDur': 3, 'dur': 3, 'sustain': 2, 'midinote': 0,
		  'timeline': { NoteTimeline(\note1) }, 'relDur': 3, 'absTime': 5, 'type': \pattern 
		))

	],1)).play
)


(
	Pseq([
		PatternEvent((
			'playDur': 3, 'dur': 3, 'sustain': 2, 'midinote': 0,
			'timeline': { NoteTimeline(\note1) }, 'relDur': 3, 'absTime': 5, 'type': \pattern 
		))
	],1).play
)

asPatt

~sampler_synthdef_list = [\playersec, \playerbeat]
PatKitDef(\kit1).edit
