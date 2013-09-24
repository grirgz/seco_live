Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	//\bufnum, Sdef(~namex, \myaudio).bufnum;
));
[~name, ~namex, ~index].debug("index");

Ndef(~name+++\fx, {
	var in;
	var sig;
	var spread = 0.8, amp=1, pan=0;
	in = InFeedback.ar(BusDef(~name+++\fx), 2);
	sig = RLPF.ar(in, SinOsc.ar([64,64.1,64.11]).range(100,19000));
	sig = FreqShift.ar(in, SinOsc.ar([0.4,0.41,0.42]).range(100,-100));
	sig = DelayC.ar(in, 0.1,[0.1,0.11,0.12]);
	sig = Splay.ar(sig, spread, amp, pan);
	sig;
});
Ndef(~name+++\fx).fadeTime=0.5;
// END
Sdef(~namex, \myaudio).record(4);
Sdef(~namex, \myaudio).record;
~namex
