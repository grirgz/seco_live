
// xTAGS: ndef, complex, note, chord, nappe
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 1900;
	var trig1, trig2, trig3;
	var env1, env2, env3;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fspread;
	var chords;
	var igate;

	chords = Duty.kr(2/~t, 0, Dseq([
		[0,5,7],
		[0,4,7],
		[0,5,8],
		[0,4,7],
	].midiratio,inf));
	//sig = SinOsc.ar(freq * chords);
	fspread = 0.01;
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	sig = chords.collect({ arg x, xn;
		var isig;
		sig1 = SinOsc.ar(freq * x) * SinOsc.kr(1/7*~t / xn).range(0,5);
		sig2 = LFSaw.ar(freq * x) * SinOsc.kr(1/9*~t / xn).range(0,5);
		sig3 = SelectX.ar( LFNoise1.kr(1/11).range(0.0,1.0), [sig1, sig2]);
		isig = SinOsc.ar(freq * x + 1 * sig3);
		isig = RLPF.ar(isig, LFNoise1.kr(1/8).range(50,9751.0), 0.5);
	});
	igate = TDuty.kr(1/8/~t, 0, Dseq([
		Dser([
			0.1,
		],14*4),
		Dser([
			0.0,0.0,
			0.1,0.1,
			0.1,0.1,
			0.0,0.0,
		],2*4),
		Dser([
			0.1,
		],14*4),
		Dser([
			0.0,0.0,
			0.1,0.0,
		],2*4),
	],inf));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), Trig1.kr(igate,igate), doneAction:0);
	sig.postln;
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
