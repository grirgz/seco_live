
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


(
Pdef(\zed, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0,2,5,2],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\simple_instrument, 
	Pbind(
		\instrument, \saw,
	)
);
);

NoteTimeline(\testsaw, Pdef(\simple_instrument)).edit;
NoteTimeline(\testsaw, Pdef(\simple_instrument)).presetCompileString.editorInsert


(
NoteTimeline('testsaw').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.25, \lpfr: 89.076571508657, \midinote: 60.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.25, \dur: 0.25, \lpfr: 11.648191279128, \midinote: 36.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.5, \dur: 0.125, \lpfr: 1.294413681143, \midinote: 43.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 0.625, \dur: 0.125, \lpfr: 11.648191279128, \midinote: 40.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 0.75, \dur: 0.25, \midinote: 45.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


