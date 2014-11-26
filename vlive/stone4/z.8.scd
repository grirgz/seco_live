

(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 200;
	var trig1, trig2, trig3;
	var env1, env2, env3;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fspread;
	var chords;
	var sel1, sel2, sel3, sel4, sel5, sel6, sel7;
	var sellag;
	var panspread = 1;
	sellag = \sellag.kr(0.1);
	sel1 = \sel1.kr(1).lag(sellag);
	sel2 = \sel2.kr(1).lag(sellag);
	sel3 = \sel3.kr(1).lag(sellag);
	sel4 = \sel4.kr(1).lag(sellag);
	sel5 = \sel5.kr(1).lag(sellag);
	sel6 = \sel6.kr(1).lag(sellag);
	sel7 = \sel7.kr(1).lag(sellag);

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
		var asig;
		var asig2;
		var asig3;
		var asig4;
		var mix1;
		var isig0;
		isig0 = SinOsc.ar(freq * x);
		sig1 = LFPulse.ar(freq * x );
		sig2 = LFCub.ar(freq * x);
		sig3 = LFSaw.ar(freq * x * [1/2,1.001,1,SinOsc.kr(1/3).range(1,1.01)]);
		mix1 = LFNoise1.kr(1/2 / 1.0.rand).range(0.0,2.0);
		mix1 = SelectX.kr(sel3, [DC.kr(0), mix1]);
		asig = SelectX.ar(mix1 , [sig1, sig2, sig3]);
		x = SelectX.ar(sel2, [isig0, asig]);
		asig = x * (1+SinOsc.ar(freq * 4 * SinOsc.kr(1/45).range(1,1.1), mul:0.7 * LFNoise1.kr(1/3).range(0,1)));
		x = SelectX.ar(sel4, [x, asig]);
		asig = x * LFNoise1.kr(1/4).range(0.1,1);
		x = SelectX.ar(sel5, [x, asig]);
		asig = RLPF.ar(x, 700 * LFNoise1.kr(1/3).range(0.33,7), LFNoise1.kr(1/2).range(0.051,1.0));
		x = SelectX.ar(sel6, [x, asig]);
		asig = x * LFPulse.ar(1/(xn+1)*~t).unipolar.lag(0.01);
		asig2 = x * LFPulse.ar(1*(xn+1)*~t).unipolar.lag(0.01);
		asig3 = x * LFPulse.ar(1/(chords-xn)*~t).unipolar.lag(0.01);
		x = SelectX.ar(sel7, [x, asig, asig2, asig3]);
	});
	sig = sig.flop.mean;
	amp = amp * \gain.kr(1);
	panspread = \panspread.kr(0);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0) * panspread} ! sig.size + \pan.kr(0), amp).flop;
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

Ndef(~name+++\fx).put(1, \pset -> Pbind(
	\sel2, Pseq([1,0],inf).stutter(7),
	\sel3, Pseq([1,0],inf).stutter(6),
	\sel4, Pseq([1,0],inf).stutter(5),
	\sel5, Pseq([1,0],inf).stutter(4),
	\sel6, Pseq([1,0],inf).stutter(3),
	\sel7, Pseq([1,0,2,0,3],inf).stutter(2),
	\sellag, 12 / ~t,
	\dur, 12,
));

)
// END
Ndef(~name+++\fx).edit
Ndef(~name+++\fx).addSpec(\sel1, \unipolar.asSpec);
Ndef(~name+++\fx).addSpec(\sel2, \unipolar.asSpec);
Ndef(~name+++\fx).addSpec(\sel3, \unipolar.asSpec);
Ndef(~name+++\fx).addSpec(\sel4, \unipolar.asSpec);
Ndef(~name+++\fx).addSpec(\sel5, \unipolar.asSpec);
Ndef(~name+++\fx).addSpec(\sel6, \unipolar.asSpec);
Ndef(~name+++\fx).addSpec(\sel7, ControlSpec(0,2,\lin,0,1));

ChordSymbol.shapes.keys.asArray.sort

\c.asNotes
ChordSymbol.shapes
[\c].chordProg
