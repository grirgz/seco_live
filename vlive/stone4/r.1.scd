
// TAGS: ndef, richtimbre, note, chord, lead, middle,
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 200 * 2;
	var trig1, trig2, trig3;
	var env1, env2, env3;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fspread;
	var chords;

	chords = Duty.kr(2/~t, 0, Dseq([
		[0,5,7],
		[0,4,7],
		[0,5,8],
		[0,4,7],
	],inf));
	chords = chords.add(chords+12).flat;
	chords.debug("chords");
	chords = chords.midiratio;
	//sig = SinOsc.ar(freq * chords);
	fspread = 0.01;
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	sig = chords.collect({ arg x, xn;
		var isig;
		sig1 = SinOsc.ar(freq * x) * SinOsc.kr(1/7*~t / xn).range(0,5);
		sig2 = LFSaw.ar(freq * x) * SinOsc.kr(1/9*~t / xn).range(0,5);
		sig3 = SelectX.ar( LFNoise1.kr(1/11).range(0.0,1.0), [sig1, sig2]);
		isig = SinOsc.ar(freq * x + 1 * sig3);
		isig = RLPF.ar(isig, LFNoise1.kr(1/8).range(50,1751.0), 0.5);
	});
	sig = sig.flop.mean;
	sig.postln;
	sig = SelectX.ar( TRand.kr(0, sig.size-1, Impulse.kr(1*~t)).round(1).lag(0.1), sig);
	//sig = TChoose.ar(Impulse.kr(1), sig);
	amp = amp * \gain.kr(1);
	//sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig = Pan2.ar(sig, \pan.kr(0), amp);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

// END

ChordSymbol.shapes.keys.asArray.sort

\c.asNotes
ChordSymbol.shapes
[\c].chordProg
