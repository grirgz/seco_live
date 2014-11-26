
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 200;
	var trig1, trig2, trig3;
	var env1, env2, env3;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fspread;
	var chords;

	chords = Duty.kr(2/~t, 0, Dseq([
		\cdom7,
		\fM7,
		\cdom7,
		\cdim7,
		\cdom7,
		\cM7,
	].chordProg.midiratio,inf));
	//sig = SinOsc.ar(freq * chords);
	sig = chords.collect({ arg x, xn;
		x = SinOsc.ar(freq * x);
	});
	//sig = sig.flop.mean;
	sig = sig / 2;
	amp = amp * \gain.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

// END

Ndef(~name+++\fx).fadeTime=1

ChordSymbol.shapes.keys.asArray.sort

\c.asNotes
ChordSymbol.shapes
[\c].chordProg
