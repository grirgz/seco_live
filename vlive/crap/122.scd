
(
~t = 1;
Ndef(\frat, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var fs, fspread;
	var xfreq;
	xfreq = freq/2 * Duty.kr(1/2/~t, 0, Dseq([
		0,0,0,2,
	],inf)).midiratio;
	fspread = SinOsc.kr(1/2).exprange(0.01,1);
	fs = ((0..7)/7 - 0.5 * fspread + 1);
	freq = freq * ( 1 + ( SinOsc.ar( fs ) * 1 ));
	sig = SinOsc.ar(freq);
	sig = sig.fold2( SinOsc.kr(1 * fs).range(0,1) );
	xfreq.postln;
	sig = CombL.ar(sig, 0.1, 1/xfreq * SinOsc.kr(1/18).range(1.2,1)) + sig;
	sig = CombL.ar(sig, 0.1, 1/xfreq * SinOsc.kr(1/16).range(1.2,1)) + sig;
	sig = CombL.ar(sig, 0.1, 1/xfreq * SinOsc.kr(1/14).range(1.2,1)) + sig;
	sig = sig / 2;
	sig = sig.tanh;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
	SynthDef(\qaze, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		//freq = freq * EnvGen.kr(Env([1,1.012,1],[0.1,0.8]), 1) * ( 1 + ( SinOsc.ar(freq) * 0.31 ));
		freq = freq * ( 1 + ( SinOsc.ar(freq/2) * 0.131 ));
		sig = SinOsc.ar(freq);
		sig2 = LFSaw.ar(freq) * EnvGen.kr(Env([1,2,1],[0.3,0.8]), 1)/3;
		sig2 = RLPF.ar(sig, \lpf.kr(100) * (1..8)/4, 0.1) + sig2;
		sig = sig + sig2;
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.41),gate,doneAction:2);
		sig.debug("sig");
		sig = Pan2.ar(sig, LFNoise1.kr((1..8)/16) * 0.7, amp).mean;
		sig.debug("sig2");
		Out.ar(out, sig);
	}).add;
)


EventListDef(\yap).setEventFactory()

(
Ndef(\vf)[0] = EventListDef(\yap) <> Pbind(
	\instrument, \qaze,
	\degree, Pseq([0,0,0,4, 0,3,0,7, 10,0,14,0],inf),
	\lpf, 
	Prout({ arg ev;
		var x;
		x = Ndef(\bla, { arg f; f * SinOsc.kr(1/8).range(4,1/2) });
		loop {
			Ndef(\bla).set(\f, ( ev.use { ~freq.value } ).debug("fff"));
			//( ev.use { ~freq.value } ).debug("kdk");
			//Ndef(\bla).set(\f, ( 400 ).debug("fff"));
			ev = Ndef(\bla).yield;
		}

	}),
	\lpf, Pkey(\freq),
	\octave, 4,
	\dur, Pseq([1,1/4,1/4,1/8],inf),
	\amp, 0.1
);
Ndef(\vf).play;
Ndef(\vf)[1] = \filter -> { arg in;
	var sig = in;
	sig = sig * 303;
	//sig = sig.tanh;
	sig = sig + ( LocalIn.ar(2).tanh * 1.5 );
	sig = sig / 10;
	//sig = sig < 0.1 * sig;
	in.debug("in");
	sig.debug("in2");
	sig = ( [sig] < [0.2,0.4,0.6] * sig ).mean;
	sig.debug("fuck");
	LocalOut.ar(sig);
	sig = sig.tanh;
	sig = sig /4;
	sig.debug("fuck2");
	sig;
}
)
