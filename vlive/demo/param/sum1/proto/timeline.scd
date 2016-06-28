
(
ParamProto.init;
SynthDef(\bri, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq * ( 1 + ( SinOsc.ar(\fmfreq.kr(0)) * \fmamp.kr(1) ));
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpf.kr(7100), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef(\pat, Pbind(
	\instrument, \bri,
	\root, Pseq([0,2,4],inf),
	\midinote, Pkey(\root) + Pkeyd(\midinote, 0),
	\lpf, Pseq([7000,5000,3000, 4000],inf),
	\fmfreq, Pseq([7,5000,30],inf),
	\fmamp, 0.1,
	\dur, 1/4,
	\amp, 0.1
));
)

~noteTimeline.new(\notes4, Param(Pdef(\pat), \midinote)).edit; // default GUI

(
//////// with keyboard
~noteTimeline.new(\notes4, Param(Pdef(\pat), \midinote));
~timeline = ~noteTimeline.new(\notes4);
WindowDef(\gui, { 
	var kb = MIDIKeyboardView.new;
	var curnote = nil;
	kb.keyDownAction = { arg note;
		~timeline.eventFactory.childAt(note).play;
		curnote = note;
	};
	kb.keyUpAction = { arg note;
		~timeline.eventFactory.childAt(note).stop;
	};
	kb.keyTrackAction = { arg note;
		note.debug("trackAction");
		if(curnote != note) {
			curnote !? {~timeline.eventFactory.childAt(curnote).stop };
			curnote = note;
			~timeline.eventFactory.childAt(note).play;
		};
	};
	VLayout(
		~timeline.asView,
		kb.asView.minHeight_(40),
	)
}).frontTop;
)
