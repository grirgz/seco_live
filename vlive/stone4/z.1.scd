
// TAGS: ndef, complex, note, chord, chordProg, nappe
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
		sig1 = SinOsc.ar(freq * x * ((xn +1)*1)/3);
		sig1 = LFPulse.ar(freq * x );
		sig2 = LFCub.ar(freq * x);
		sig3 = LFSaw.ar(freq * x * [1/2,1.001,1,SinOsc.kr(1/3).range(1,1.01)]);
		x = SelectX.ar( LFNoise1.kr(1/2 / 1.0.rand).range(0.0,2.0), [sig1, sig2, sig3]);
		x = x * (1+SinOsc.ar(freq * 4 * SinOsc.kr(1/45).range(1,1.1), mul:0.7 * LFNoise1.kr(1/3).range(0,1)));
		x = x * LFNoise1.kr(1/4).range(0.1,1);
		x = RLPF.ar(x, 700 * LFNoise1.kr(1/3).range(0.33,7), LFNoise1.kr(1/2).range(0.051,1.0));
		x = x * LFPulse.ar(1/xn*~t).unipolar.lag(0.01);
	});
	sig = sig.flop.mean;
	amp = amp * \gain.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

// END

ChordSymbol.shapes.keys.asArray.sort

\c.asNotes
ChordSymbol.shapes
[\c].chordProg
