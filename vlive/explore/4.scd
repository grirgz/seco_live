
~t = 1;
(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var ffac;
	var rq;
	var freqs;
	var lfo1, lfo2, lfo3;

	sig1 = SinOsc.ar([100,200,400,800,1600, 2000, 8000]*2);
	sig1 = SinOsc.ar(Array.series(18,120 * SinOsc.kr(4*2).range(1.1,1),640.2 * SinOsc.kr(1).range(0.1,0.11)) * 8);
	sig2 = WhiteNoise.ar;
	ffac = LFSaw.kr(1/4).range(0.2,2);
	ffac = 1 * LFNoise1.kr(1/4).range(1,1.02);
	rq = 0.5;
	sig2 = 0 
		+ LPF.ar(WhiteNoise.ar, 100*ffac)
		+ BPF.ar(WhiteNoise.ar, 200*ffac, rq)
		+ BPF.ar(WhiteNoise.ar, 400*ffac, rq)
		+ BPF.ar(WhiteNoise.ar, 800*ffac, rq)
		+ BPF.ar(WhiteNoise.ar, 1600*ffac, rq)
		+ BPF.ar(WhiteNoise.ar, 4600*ffac, rq)
		+ HPF.ar(WhiteNoise.ar, 7600*ffac)
		;
	freqs = Array.series(18,720,200) * LFNoise1.kr(1).range(1,1.1);
	freqs = freqs ++ Array.geom(11,120,1.5 * LFNoise1.kr(1/2).range(1.01,1.0));
	freqs = freqs ++ Array.series(8,120* LFNoise1.kr(1/2).range(2.41,1.0),100);


	freqs = sin((1..20)).abs * 800 * Duty.kr(1/~t, 0, Dseq([
		1,7,-5,10,
	],inf)).midiratio.lag(0.5) * MouseX.kr(0.1,2);

	freqs = tanh((1..20)).abs * 400 * Duty.kr(1/~t, 0, Dseq([
		1,7,-5,10,
	],inf)).midiratio.lag(0.5) * 0.1;

	freqs.postln;
	sig2 = freqs.collect { arg fre;
		BPF.ar(WhiteNoise.ar, ( fre*ffac ).clip(1,20000), rq)
	};
	lfo1 = LFNoise1.kr(1/2).range(1.0,1.1);
	sig1 = freqs.collect { arg fre;
		var isig, isig2;
		isig = LFSaw.ar(fre*ffac * lfo1 * SinOsc.kr(1/19, SinOsc.ar((1/19).rand).unipolar * 0.001.rand).range(4.400,1));
		isig2 = WhiteNoise.ar;
		isig2 = RLPF.ar(isig2, 100 *ffac * LFNoise1.kr(1/2).range(1.0,1.2), 0.1 * LFNoise1.kr(1/2).range(1.0,2.2));
		isig = isig + isig2;
		isig = (isig*40).tanh;
		//isig = BPF.ar(isig, 1900 *ffac * LFNoise1.kr(1/2).range(1.0,1.2), 0.1 * LFNoise1.kr(1/2).range(1.0,2.2));
		isig;
	};
	sig = sig1/1.7 + ( sig2 * 0 );
	//sig = sig1;
	//sig = sig2;
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.5) * SinOsc.kr(1/8).range(0,1), amp, pan);
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var ffac;
	var rq;
	var freqs;
	var lfo1, lfo2, lfo3;
	var xx;

	sig1 = SinOsc.ar([100,200,400,800,1600, 2000, 8000]*2);
	sig1 = SinOsc.ar(Array.series(18,120 * SinOsc.kr(4*2).range(1.1,1),640.2 * SinOsc.kr(1).range(0.1,0.11)) * 8);
	sig2 = WhiteNoise.ar;
	ffac = LFSaw.kr(1/4).range(0.2,2);
	ffac = 1 * LFNoise1.kr(1/4).range(1,1.02);
	rq = 0.5;
	sig2 = 0 
		+ LPF.ar(WhiteNoise.ar, 100*ffac)
		+ BPF.ar(WhiteNoise.ar, 200*ffac, rq)
		+ BPF.ar(WhiteNoise.ar, 400*ffac, rq)
		+ BPF.ar(WhiteNoise.ar, 800*ffac, rq)
		+ BPF.ar(WhiteNoise.ar, 1600*ffac, rq)
		+ BPF.ar(WhiteNoise.ar, 4600*ffac, rq)
		+ HPF.ar(WhiteNoise.ar, 7600*ffac)
		;
	freqs = Array.series(18,720,200) * LFNoise1.kr(1).range(1,1.1);
	freqs = freqs ++ Array.geom(11,120,1.5 * LFNoise1.kr(1/2).range(1.01,1.0));
	freqs = freqs ++ Array.series(8,120* LFNoise1.kr(1/2).range(2.41,1.0),100);



	freqs = tanh((1..20)).abs * 400 * Duty.kr(1/~t, 0, Dseq([
		1,7,-5,10,
	],inf)).midiratio.lag(0.5) * 0.1;

	freqs = sin((1..20)*4.40).abs + 1 * 800 * Duty.kr(1/~t, 0, Dseq([
		1,7,-5,10,
	],inf)).midiratio.lag(0.5) * MouseX.kr(0.1,2);

	freqs = sin((1..20)*4.40).abs + 1 * 800  * MouseX.kr(0.1,2);
	freqs = sin(1/(1..20)*0.40).abs + 1 * 800  * MouseX.kr(0.1,2);
	freqs = sin(1/(1..20)*9.40) + 1 * 800  * MouseX.kr(0.1,2);
	xx = (1..40);
	freqs = 10000 + 30*xx - ( 11*(xx**2) ) + (sin(xx*4)*(xx**3)) + (sin((sin(xx*8)*(xx**4)))*(xx**4));
	freqs = sin(xx*5).abs + 1 * 400 + (sin(xx*18).abs * 200);
	freqs.histo;

	
	freqs.postln;
	sig2 = freqs.collect { arg fre;
		BPF.ar(WhiteNoise.ar, ( fre*ffac * 40 * LFNoise1.kr(1/2).range(0.1,4.0) * Duty.kr(2/~t, 0, Dseq([
			4,1,1/10,1,
		],inf)).lag(0.1) ).clip(1,20000), rq)
	};
	lfo1 = LFNoise1.kr(1/2).range(1.0,1.1);
	sig1 = freqs.collect { arg fre;
		var isig, isig2;
		isig = LFSaw.ar(fre*ffac * lfo1 * SinOsc.kr(1/19, SinOsc.ar((1/19).rand).unipolar * 0.001.rand).range(0.400,4));
		isig2 = WhiteNoise.ar * isig;
		isig2 = LFNoise1.ar(fre*ffac);
		//isig2 = RLPF.ar(isig2, 100 *ffac * LFNoise1.kr(1/2).range(1.0,2.2), 0.1 * LFNoise1.kr(1/2).range(1.0,2.2));
		isig = isig + isig2;
		//isig = isig + FreqShift.ar(isig, fre);
		//isig = isig + FreqShift.ar(isig, fre);
		//isig = isig + FreqShift.ar(isig, fre);
		isig = (isig*40).tanh;
		//isig = BPF.ar(isig, 1900 *ffac * LFNoise1.kr(1/2).range(1.0,1.2), 0.1 * LFNoise1.kr(1/2).range(1.0,2.2));
		isig;
	};
	sig = sig1/1.7 + ( sig2 * 0 );
	//sig = sig1;
	//sig = sig2;
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.5) * SinOsc.kr(1/8).range(0,1), amp, pan);
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var ffac;
	var rq;
	var freqs;
	var lfo1, lfo2, lfo3;
	var xx;

	xx = (1..10);
	freqs = sin(xx*8).abs + 1 * 140 + (sin(xx**2).abs +1 * 10) + (xx**2);
	freqs = freqs *.t [3,4.52,2.3554];
	freqs = freqs.flatten;
	//freqs.plot;
	freqs.postln;
	//freqs.histo(32).plot;

	ffac = 1 * LFNoise1.kr(1/4).range(1,1.02);
	rq = 0.5;
	lfo1 = LFNoise1.kr(1/2).range(1.0,1.1);
	sig1 = freqs.collect { arg fre;
		var isig, isig2;
		isig = LFSaw.ar(fre*ffac * lfo1 * SinOsc.kr(1/19, SinOsc.ar((1/19).rand).unipolar * 0.001.rand).range(1.14400,1.14));
		isig2 = WhiteNoise.ar * isig;
		isig2 = LFNoise1.ar(fre*ffac * 1.2) * isig;
		isig2 = DelayL.ar(isig2,0.0001,0.0001) + isig2;
		isig2 = HPF.ar(DelayL.ar(isig2,0.001,0.0017),200) + isig2;
		isig2 = LPF.ar(DelayL.ar(isig2,0.001,0.0004),200) + isig2;
		isig = isig + isig2;
		isig = (isig*40).tanh;
		isig;
	};
	sig = sig1/1.7;
	sig = Splay.ar(sig, \spread.kr(0.5) * SinOsc.kr(1/8).range(0,1), amp, pan);
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var ffac;
	var rq;
	var freqs;
	var lfo1, lfo2, lfo3;
	var xx;

	xx = (1..4);
	freqs = sin(xx*8).abs + 1 * 140 + (sin(xx**2).abs +1 * 10) + (xx**2);
	freqs = xx * 100;
	//freqs = freqs *.t [3,3.052,3*4/5,3*9/10];
	freqs = freqs *.t [1,1.0001,1.001];
	freqs = freqs.flatten;
	//freqs.plot;
	freqs.postln;
	//freqs.histo(32).plot;

	ffac = 1 * LFNoise1.kr(1/4).range(1,1.02);
	rq = 0.5;
	lfo1 = LFNoise1.kr(1/2).range(1.0,1.1);
	sig1 = freqs.collect { arg fre;
		var isig, isig2;
		isig = LFSaw.ar(fre*ffac * lfo1 * SinOsc.kr(1/19, SinOsc.ar((1/19).rand).unipolar * 0.001.rand).range(1.14400,1.14));
		isig = LFSaw.ar( SinOsc.ar( LFSaw.ar( [1,2,3,4,5,6] * ffac * fre/190) * 0.110 + 1 * fre*ffac*1.00) * [1,4,22,1/2] + 1 * fre*ffac);
		isig = LFSaw.ar( SinOsc.ar(  fre / 2) * [1,4,22,1/2] + 1 * fre*ffac);
		isig = DelayL.ar(isig,0.0001,0.00001 * LFNoise1.kr(1/8).range(0,1)) + isig;
		isig = DelayL.ar(isig,0.0001,0.00001 * LFNoise1.kr(1/8).range(0,1)) + isig;
		//isig = isig + isig2;
		//isig = (isig*40).tanh;
		isig = isig.sum;
		isig;
	};
	sig = sig1/2.7;
	sig = RLPF.ar(sig, MouseX.kr(100,18000) * ({ LFNoise1.kr(1/2).range(1.1,1.0) }!sig.size),0.1* ({ LFNoise1.kr(1/2).range(4.1,1.0) }!sig.size));
	sig = sig.clump(2).flat.postln;
	sig = Splay.ar(sig, \spread.kr(1) * LFNoise1.kr(1/8).range(0,1), amp, pan);
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var ffac;
	var rq;
	var freqs;
	var lfo1, lfo2, lfo3;
	var xx;

	xx = (1..4);
	freqs = sin(xx*8).abs + 1 * 140 + (sin(xx**2).abs +1 * 10) + (xx**2);
	//freqs = freqs *.t [3,3.052,3*4/5,3*9/10];
	freqs = xx *.t[1,1.000001,1.000011,1.00002,4.0001,5/3.00001];
	freqs = freqs * 80 * Duty.kr(1/1/~t, 0, Dseq([
		4,-2,0,0,0,0,0,0,
		0,-8,0,0,0,0,0,0,
		16,-2,0,0,0,0,0,0,
		0,-8,0,0,0,0,0,0,
	],inf)).midiratio.lag(0.1);
	freqs = freqs.flatten;
	//freqs.plot;
	freqs.postln;
	//freqs.histo(32).plot;

	ffac = 1 * LFNoise1.kr(1/4).range(1,1.02);
	rq = 0.5;
	lfo1 = LFNoise1.kr(1/2).range(1.0,1.1);
	sig1 = freqs.collect { arg fre;
		var isig, isig2;
		isig = LFSaw.ar(fre*ffac * lfo1 * SinOsc.kr(1/19, SinOsc.ar((1/19).rand).unipolar * 0.001.rand).range(1.14400,1.14));
		isig = LFSaw.ar( SinOsc.ar( LFSaw.ar( [1,2,3,4,5,6] * ffac * fre/190) * 0.110 + 1 * fre*ffac*1.00) * [1,4,22,1/2] + 1 * fre*ffac);
		isig = LFSaw.ar( SinOsc.ar(  fre / 2) * [1,4,22,1/2] + 1 * fre*ffac);
		isig = DelayL.ar(isig,0.0001,0.00001 * LFNoise1.kr(1/48).range(1,1.01)) + isig;
		isig = DelayL.ar(isig,0.0001,0.00001 * LFNoise1.kr(1/48).range(1,1.01)) + isig;
		//isig = isig + isig2;
		isig = (isig*40).tanh;
		isig = isig.sum;
		isig;
	};
	sig = sig1/1.7;
	sig = RLPF.ar(sig, MouseX.kr(100,18000) * ({ LFNoise1.kr(1/2).range(1.1,1.0) }!sig.size),0.1* ({ LFNoise1.kr(1/2).range(4.1,1.0) }!sig.size));
	sig = sig.clump(2).flat.postln;
	sig = Splay.ar(sig, \spread.kr(1) * LFNoise1.kr(1/8).range(0,1), amp, pan);
	RecordBuf.ar(sig, ~buf, loop:0, doneAction:2);
	sig;
}).play;
);

~buf = Buffer.alloc(s, s.sampleRate * 4, 2);


(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var del = 0.000001 * SinOsc.kr(1/4, 1.5).range(0,104.5);
	var env;
	var lfo1, lfo2;
	var seq1;
	freq = Duty.kr(1/~t, 0, Dseq([
		1,0,4,2,
	],inf)).midiratio * 123;
	lfo1 = SinOsc.kr(1/18).range(2,0.1);
	lfo2 = SinOsc.kr(1/28).range(2,0.1);
	seq1 = TDuty.kr(1/4/~t, 0, Dseq([
		Drand([
			Dseq([
				1,0,0,0, 1,0,0,0,
			],1),
			Dseq([
				1,1,1,1, 1,1,1,1,
			],1),
			Dseq([
				1,0,1,0, 1,0,1,0, 
			],1),
		],1),
	],inf));
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.4)), Trig.kr(seq1,0.3 * lfo2), timeScale: lfo1, doneAction:0);
	freq = freq * [1,1+del,1+(del*2)] *.t Array.geom(4,1,1+del);
	sig = LFSaw.ar(freq, 1.5);
	sig.postln;
	sig = sig.flatten;
	sig = sig * env;
	sig = RLPF.ar(sig, \lpf.kr(4444) *.t Array.geom(4,1,1+del), \rq.kr(0.5));
	20.do { arg x;
		sig = DelayC.ar(sig,0.001,0+del + 0.0001.rand) + sig;
		sig = sig / 2;
	};
	sig = sig /4;
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
}).play;
);





(
	// terror subbass
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var fa;
	fa = Array.series(45,21,1.1).postln;
	sig = Klang.ar(Ref([ fa ]));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var fa;
	fa = Array.series(145,71 * SinOsc.kr(1/22).range(1,8),72.1 * SinOsc.kr(1/14).range(0,0.04));
	sig = DynKlang.ar(Ref([ fa, 0.1 ]));
	sig = sig / 4;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var fa;
	var xx;
	xx = (1..100);
	fa = sin(xx*10) * 20 + 200;
	//fa = Array.series(145,71 * SinOsc.kr(1/22).range(1,8),72.1 * SinOsc.kr(1/14).range(0,0.04));
	fa.postln;
	sig = DynKlang.ar(Ref([ fa, 0.1 ]));
	sig = sig * LFSaw.ar(100);
	sig = sig / 4;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var bufnum = ~buf;
	freq = Duty.kr(1/~t, 0, Dseq([
		1,2,4,0,
	],inf)).midiratio * 100;
	sig = BufRd.ar(2, bufnum, SinOsc.ar(freq*[1,1.00001,2]).range(0,1) *.t s.sampleRate/ SinOsc.kr(1/~t).range(1,100 * [1,1.01,2,1/8]), 1);
	sig = sig.flatten;
	sig = sig.collect{ arg sig;
		Pan2.ar(sig, LFNoise1.kr(1/4).range(-1,1), amp);
	}.mean;
	sig;
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var bufnum = ~buf;
	var lfo1;
	lfo1 = Duty.kr(1/4/~t, 0, Dseq([
		5,1,1,1,
		5+8,1,1,1,
		1,3,1,3,
		1,1,5+8,1,
	],inf));
	freq = Duty.kr(1/~t, 0, Dseq([
		1,2,4,0,
	],inf)).midiratio * 100;
	sig = BufRd.ar(2, bufnum, SinOsc.ar(freq*[1,1.00001,2]).range(0,1) *.t s.sampleRate/ SinOsc.kr(lfo1/~t).range(1,100 * [1,1.01,2,1/8]), 1);
	sig = sig.flatten;
	sig = sig.collect{ arg sig;
		Pan2.ar(sig, LFNoise1.kr(1/4).range(-1,1), amp);
	}.mean;
	sig;
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var bufnum = ~buf;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var asig;
	freq = 80;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		1,7,4,1,
		4,1,-4,4,
	],inf)).midiratio;
	sig = BufRd.ar(2, bufnum, SinOsc.ar(SinOsc.ar(45) * 1 + freq * [1,1.01,1.02] ).unipolar * 20110 * SinOsc.ar(100).range(1,2));
	sig1 = RLPF.ar(sig, 1500 * LFNoise1.kr(1/7).range(0.1,4.0));
	sig2 = BPF.ar(sig, 7500 * LFNoise1.kr(1/24).range(0,1));
	asig = List.new;
	asig = asig.add(BPF.ar(sig, 2500 * LFNoise1.kr(1/24).range(0,1)) );
	sig =  sig1 + sig2  + asig.sum;
	sig1 = sig + FreqShift.ar(sig, 1 * SinOsc.kr(1/2).range(0,1));
	sig = SelectX.ar( SinOsc.kr(1/14).range(0,1), [sig, sig1]);
	sig = Pan2.ar(sig.flop, LFNoise1.kr(1/2), amp);
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var bufnum = ~buf;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var asig;
	freq = 80;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		1,7,4,1,
		4,1,-4,4,
	],inf)).midiratio;
	sig = BufRd.ar(2, bufnum, SinOsc.ar(SinOsc.ar(45) * 1 + freq * [1,1.01,1.02] ).unipolar * 20110 * SinOsc.ar(100).range(1,2));
	sig1 = RLPF.ar(sig, 1500 * LFNoise1.kr(1/7).range(0.1,4.0));
	sig2 = BPF.ar(sig, 7500 * LFNoise1.kr(1/24).range(0,1));
	asig = List.new;
	asig = asig.add(BPF.ar(sig, 2500 * LFNoise1.kr(1/24).range(0,1)) );
	asig = asig.add(HPF.ar(sig, 12500 * LFNoise1.kr(1/24).range(0,1)) * 0.5 );
	sig =  sig1 + sig2 + asig.sum;
	sig1 = sig + FreqShift.ar(sig, 1 * SinOsc.kr(1/2).range(0,1));
	sig = SelectX.ar( SinOsc.kr(2).range(0,1), [sig, sig1]);
	sig = Pan2.ar(sig.flop, LFNoise1.kr(1/2), amp);
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var bufnum = ~buf;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var asig;
	freq = 80;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		1,7,4,1,
		4,1,-4,4,
	],inf)).midiratio;
	sig = BufRd.ar(2, bufnum, SinOsc.ar(SinOsc.ar(45) * 1 + freq * [1,1.01,1.02] ).unipolar * 20110 * SinOsc.ar(100).range(1,2));
	asig = List.new;
	asig = asig.add(BPF.ar(sig, 2500 * LFNoise1.kr(1/24).range(0,1), 0.1* XLine.ar(1,4,20)) );
	asig = asig.add(RLPF.ar(sig, 7000 * LFNoise1.kr(1/24).range(0,1))  * XLine.ar(0.001,1,20));
	//asig = asig.add(HPF.ar(sig, 12500 * LFNoise1.kr(1/24).range(0,1)) * 0.5 );
	sig =  asig.sum;
	sig = HPF.ar(sig, 100 * XLine.ar(1,0.01,20));
	sig1 = sig + FreqShift.ar(sig, 1 * SinOsc.kr(1/2).range(0,100));
	sig = SelectX.ar( SinOsc.kr(2).range(0,1), [sig, sig1]);
	sig = Pan2.ar(sig.flop, LFNoise1.kr(1/2), amp);
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var bufnum = ~buf;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var asig;
	var seq1;
	var seq2;
	freq = 80;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		1,7,4,1,
		4,1,-4,4,
	],inf)).midiratio;
	seq1 = Array.series(18, 1, Duty.kr(1/~t, 0, Dseq([
		0.0000001,0.0001,0.000001,
		0.001,0.0000001,0.000001,
	],inf)));
	seq2 = Array.geom(18, 1, Duty.kr(1/~t, 0, Dseq([
		1.12,0.5,
	],inf))).lag(0.2);
	sig = BufRd.ar(2, bufnum, SinOsc.ar( freq * seq1 ).unipolar * 2110 * seq2 );
	sig = sig / 7;
	sig = Pan2.ar(sig.flop, LFNoise1.kr(1/2), amp);
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var bufnum = ~buf;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var asig;
	var seq1;
	var seq2;
	var gate = Impulse.ar(1/~t);
	var env1, env2;

	gate = TDuty.kr(1/~t, 0, Dseq([
		1,1,
	],inf));
	env1 = EnvGen.ar(Env([10500,90,41],[0.0001,0.08]), gate);
	env2 = EnvGen.kr(Env([0,1,0],[0.000001,0.9], [0,-2]), gate);
	//sig = SinOsc.ar(env1);
	sig = BufRd.ar(2, bufnum, SinOsc.ar( env1 * [1,1.01,1/2,1/3] ).unipolar * 1010 + ( env2 * 20100) );
	sig = RLPF.ar(sig, env1);
	sig = sig * 8;
	sig = sig * env2;
	sig = Pan2.ar(sig, LFNoise1.kr(1/2), amp).flop;
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var bufnum = ~buf;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var asig;
	var seq1;
	var seq2;
	var gate = Impulse.ar(1/~t);
	var env1, env2;

	gate = TDuty.kr(1/~t, 0, Dseq([
		1,1,
	],inf));
	env1 = EnvGen.ar(Env([10500,49,54],[0.0001,0.48]), gate);
	env2 = EnvGen.kr(Env([0,1,0],[0.000001,0.9], [0,-2]), gate);
	sig = SinOsc.ar(env1 * [1.01,1/2,1/3,1]);
	//sig = BufRd.ar(2, bufnum, SinOsc.ar( env1 * [1,1.01,1/2,1/3] ).unipolar * 1010 + ( env2 * 20100) );
	sig = sig + WhiteNoise.ar;
	sig = sig + LFSaw.ar(env1 * [2,4,2,1]);
	sig = RLPF.ar(sig, env1);
	sig = sig * 2;
	sig = sig * env2;
	sig = Pan2.ar(sig, LFNoise1.kr(1/2) * 0.1, amp).flop;
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\plop2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var bufnum = ~buf;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var asig;
	var seq1;
	var seq2;
	var gate = Impulse.ar(1/~t);
	var env1, env2;

	gate = TDuty.kr(1/16/~t, 0, Dseq([
		1,0,0,1,
		1,0,1,0,
		1,0,0,0,
		1,0,1,0,
	],inf));
	env1 = EnvGen.ar(Env([10500,40,71],[0.001,0.08]), gate);
	env2 = EnvGen.kr(Env([0,1,0],[0.00001,0.12], [0,-1]), gate);
	//sig = SinOsc.ar(env1);
	sig = BufRd.ar(2, bufnum, SinOsc.ar( env1 * (1..5)/5 ).unipolar * 41 + ( env2 * 10100 * (1..4)) );
	sig = RLPF.ar(sig, env1 * 1/2);
	sig = sig * 8;
	sig = sig * env2;
	sig = Pan2.ar(sig, LFNoise1.kr(1/2) * 0.1, amp).flop;
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\plop2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var bufnum = ~buf;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var asig;
	var seq1;
	var seq2;
	var gate = Impulse.ar(1/~t);
	var env1, env2;

	gate = TDuty.kr(1/2/~t, 0, Dseq([
		1,0,0,1,
		1,0,1,0,
		1,0,0,0,
		1,0,1,0,
	],inf));
	env1 = EnvGen.ar(Env([15500,40,41],[0.001,0.08]), gate);
	env2 = EnvGen.kr(Env([0,1,0],[0.00001,0.62], [0,-5]), gate);
	//sig = SinOsc.ar(env1);
	sig = BufRd.ar(2, bufnum, SinOsc.ar( env1 * (1..5)/5 ).unipolar * 41 + ( env2 * 10100 * (1..4)) );
	sig = RLPF.ar(sig, env1 * 1/2);
	sig = sig * 8;
	sig = sig * env2;
	sig = Pan2.ar(sig, LFNoise1.kr(1/2) * 0.1, amp).flop;
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var bufnum = ~buf;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var asig;
	var seq1;
	var seq2;
	freq = 80;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		1,7,4,1,
		4,1,-4,4,
	],inf)).midiratio;
	seq1 = Array.series(18, 1, Duty.kr(1/~t, 0, Dseq([
		0.0000001,0.0001,0.000001,
		0.001,0.0000001,0.000001,
	],inf)));
	seq1 = Array.series(18, 1, \seqdel.kr(0.0001));
	seq2 = Array.geom(18, 1, Duty.kr(1/~t, 0, Dseq([
		1.12,0.5,
	],inf))).lag(0.2);
	seq2 = 1;
	sig = BufRd.ar(2, bufnum, SinOsc.ar( freq * seq1 ).unipolar * \range.kr(1000) * seq2 );
	sig = sig / 10;
	sig = Pan2.ar(sig.flop, LFNoise1.kr(1/2), amp);
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var bufnum = ~buf;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var asig;
	var seq1;
	var seq2;
	freq = 80;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		1,7,4,1,
		4,1,-4,4,
	],inf)).midiratio;
	seq1 = Array.series(18, 1, Duty.kr(1/~t, 0, Dseq([
		0.0000001,0.0001,0.000001,
		0.001,0.0000001,0.000001,
	],inf)));
	seq1 = Array.series(18, 1, \seqdel.kr(0.0001));
	seq2 = Array.geom(18, 1, Duty.kr(1/~t, 0, Dseq([
		1.12,0.5,
	],inf))).lag(0.2);
	seq2 = 1;
	sig = BufRd.ar(2, bufnum, SinOsc.ar( freq * seq1 ).unipolar * \range.kr(1000) * seq2 );
	sig = sig / 10;
	sig1 = RLPF.ar(sig, \lpf.kr(100));
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = Pan2.ar(sig.flop, LFNoise1.kr(1/2), amp);
}).play;
);


Ndef(\plop).map(\range, Ndef(\line1));
Ndef(\plop).map(\seqdel, Ndef(\line2));
Ndef(\plop).map(\mix, Ndef(\line3));
Ndef(\plop).map(\lpf, Ndef(\line4));
(
Ndef(\line1, { XLine.kr(1,10001,2) });
Ndef(\line2, { XLine.kr(0.001,0.000101) });
);
(
Ndef(\line1, { XLine.kr(1000,100,2) });
Ndef(\line2, { XLine.kr(0.1,0.01) });
);
(
Ndef(\line1, { XLine.kr(1,10001,20) });
Ndef(\line2, { XLine.kr(0.1,0.01,20) });
);
(
Ndef(\line1, { XLine.kr(100,1001,20) });
Ndef(\line2, { XLine.kr(0.2,0.4,20) });
);
(
Ndef(\line1, { SinOsc.kr(1/2).range(1000,100) });
Ndef(\line2, { SinOsc.kr(1/4).range(0.1000,0.000100) });
);
(
Ndef(\line1, { SinOsc.kr(1/2).range(XLine.kr(1,1000,20),10) });
Ndef(\line2, { SinOsc.kr(1/4).range(0.400001000,0.000100) });
);
(
Ndef(\line1, { SinOsc.kr(1/2).range(1000,100) });
Ndef(\line2, { SinOsc.kr(1).range(0.001000,0.000100) });
Ndef(\line3, { SinOsc.kr(1/3).range(0.8000,1) });
Ndef(\line4, { SinOsc.kr(1/2).range(4000,100) });
);
(
Ndef(\line3, { SinOsc.kr(1/3).range(0.0000,0.0) });
);

Ndef(\line1).clear
Ndef(\line1).fadeTime=0.2;
Ndef(\line2).fadeTime=0.2;
