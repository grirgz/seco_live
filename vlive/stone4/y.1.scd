
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 200  ;
	var trig1, trig2, trig3;
	var env1, env2, env3;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fspread;
	var chords;
	var sig0;

	//freq = freq * [1,SinOsc.kr(1/7).range(1,1.01)];
	freq = freq * [1, Duty.kr(1/~t, 0, Dseq([
		1,1.0101,1.001,1.0001,
	],inf))];
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,4,5,7,
	],inf)).midiratio;

	sig1 = SinOsc.ar(freq * Duty.kr(1/~t, 0, Dseq([
		0,5,7,0,
	],inf)).midiratio) * 0.5 * SinOsc.kr(1/2).range(0,4);
	sig2 = LFSaw.ar(freq * 2) * SinOsc.kr(1/3).range(0,4);
	sig2 = RLPF.ar(sig2, \lpf.kr(100) * [1,2,3,4,5], \rq.kr(0.5));
	sig0 = sig1 + sig2;
	sig = SinOsc.ar(sig0 * SinOsc.kr(1/7).range(0,[0.1,1,2,3,5]) + 1 * freq);
	sig = SinOsc.ar(sig + 1 * freq);
	sig = sig / 4;
	sig = sig.collect({ arg x; x * SinOsc.kr(1.0.rand).unipolar });

	sig = ( (sig <0 ) * (sig*500).tanh/5  ) + ((sig >0) * sin(sig* SinOsc.kr(1/7).range(0,11)).clip2(0.1));
	sig = sig / 2;

	//sig = Pan2.ar(sig, \pan.kr(0), amp);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

// END

ChordSymbol.shapes.keys.asArray.sort

\c.asNotes
ChordSymbol.shapes
[\c].chordProg
