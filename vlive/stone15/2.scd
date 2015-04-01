

~pdef_channel.();

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var bufnum = \bufnum.kr(0);
	var range = 100 * SinOsc.ar(1/7).range(4,1) ;
	var pos = SinOsc.ar(1/4).range(0.1,4.3);
	freq = freq * \freqtab.kr([0,4,7].midiratio);
	sig = SinOsc.ar(freq * 
		( 1 + ( SinOsc.kr(\fmfreq.kr(10)) * \fmamp.kr(1) )));
	sig = BufRd.ar(2, bufnum, sig.unipolar + pos * range );
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
~pdef_init.(Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
))
);
BufDef(\amen, "vipere/amenbreak.wav");
