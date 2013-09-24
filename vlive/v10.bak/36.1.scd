Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\sustain, Pseq([0.1,0.3,0.05,Pwhite(0.01,0.5)],inf),
	\pos, 0.1,

	\dur, 0.1,

));

(
t = TempoClock.default.tempo;
Ndef(~name+++\fx, {
	var in;
	var sig;
	var spread = 0.8, amp=1, pan=0;
	in = InFeedback.ar(BusDef(~name+++\fx), 2);
	sig = in;
	sig = RLPF.ar(sig, SinOsc.ar([64/2,64.1,64.11*2]/8*t).range(100,19000));
	sig = FreqShift.ar(sig, SinOsc.ar(1/8+[0.01,0.02,0.03]*[1,0.5,2]*10*t).range(-90,SinOsc.ar(4*8).range(90,500)));
	sig = DelayC.ar(sig, 0.1,[0.1,0.11,0.12]);
	sig = Splay.ar(sig, spread, amp, pan);
	sig;
});
);
[~name, ~namex, ~index].debug("index");

// END
Sdef(~namex, \myaudio).record(4);
Sdef(~namex, \myaudio).record;
~namex
	Sdef(~name, \myaudio).get(0).bufnum;
