
ParamProto.init(true)
(
ParamProto.init; // for Pembed which is ~pembed

SynthDef(\bri, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq * ( 1 + ( SinOsc.ar(\fmfreq.kr(0)) * \fmamp.kr(1) ));
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpf.kr(7100), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef(\pat1, Pbind(
	\instrument, \bri,
	\degree, Pseq([0,1,2,3,4,5,6,7,8,9],inf),
	\dur, 1/2,
	\amp, 0.1
)).play;

Ndef(\node1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr((1..4)).sum * 1 )));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


// player event Pdef

~e = PlayerEvent((receiver: Pdef(\pat1)));
~e = PlayerEvent((receiver: Pdef(\pat1), sustain: 2));
~e = PlayerEvent((receiver: Pdef(\pat1), sustain: 2, startOffset:0.2));
~e.play
Pseq([~e]).play; 

// player event Ndef


~e = PlayerEvent((receiver: Ndef(\node1)));
Pseq([~e]).play; 
Pseq([~e],inf).play; 
~e.play; // doesnt restart
Ndef(\node1).end; // force restart

// player event timeline

(
~tl = ~noteTimeline.new(\note1, Param(Pdef(\pat1), \midinote));
~tl.eventLoop.list = XEventList.newFrom(Pbind(
	\midinote, Pseq([60,64,67],inf),
	\sustain, 1/2,
	\dur, 1/2,
), 2);
)
~tl.edit;
~e = PlayerEvent((receiver: Ref(~tl)));
~e.play
Pseq([~e]).play; 
Pseq([~e],inf).play; 

~e = PlayerEvent((receiver: Ref(~tl), sustain: 0.5));
Pseq([~e],inf).play; 
Pdef(\yap, ~e.loop).play

// pattern event

~e = PatternEvent((pattern: Pdef(\pat1), sustain: 2, startOffset:0.2));
~e.startOffset = 0.5
~e.play; // startOffset doesnt work in playermode (yet ?)
Pseq([~e]).play; // but work when embeded

// pattern event timeline

~e = PatternEvent((timeline: ~noteTimeline.new(\note1, Param(Pdef(\pat1), \midinote)), sustain: 2, startOffset:0));
~e
~e.play
~noteTimeline.new(\note1, Param(Pdef(\pat1), \midinote)).edit
~noteTimeline.new(\note1).clear
~noteTimeline.new(\note1).play
Pseq([~e]).play;
~s = Pseq([~e]).asStream;
~s.next(())
