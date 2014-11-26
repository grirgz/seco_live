(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;

	
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	var gate;
	var bufnum;
	var pos;
	var freq;
	var igate;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	var clk;
	var dur = 0.01;
	var pitch_stretch = 1;
	var pan = 0;
	var env1, env2;
	var ffreq;
	clk = Impulse.ar(40);
	pos = 0.41; //+ LFNoise1.kr(1).range(0.0,0.01);
	pitch_stretch = pitch_stretch * Duty.kr(2/~t, 0, Dseq([
		1,1.02,1.012,1.03,
	],inf)).lag(0.5);
	pitch_stretch = 1;
	bufnum = BufDef.mono(\ukraine, "bruit1/07_ukraine.flac");
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);

	//sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.1)),Trig.kr(gate,0.5),doneAction:0);

	ffreqtab = \ffreqtab.kr(1!8);
	sig = FreqShift.ar(sig, \fshift.kr(0));
	//sig2 = RLPF.ar(sig, \ffreq.kr(900).lag(0.1) * ffreqtab, \rq.kr(0.3));
	ffreq = Duty.kr(1/8/~t, 0, Dseq([
		1000,1000,1000,1000, 1000,1000,1000,1000,
		1000,2000,1000,7000, 1000,1000,1000,1000,
		1000,1000,1000,1000, 1000,1000,1000,1000,
		1000,1000,2000,1000, 1000,1000,1000,1000,
	],inf)).lag(0.8);
	ffreq = SinOsc.kr(1.5*~t).range(1100,3500);
	ffreq = SinOsc.kr( Duty.kr(1/4/~t, 0, Dseq([
		2,
	],inf))*~t).range(110,500)*8;
	sig2 = RLPF.ar(sig, ffreq, \rq.kr(0.1));
	sig = SelectX.ar( \lpmix.kr(1), [sig, sig2]);
	sig2 = HPF.ar(sig, \hpfreq.kr(480) * ffreqtab);
	sig = SelectX.ar(\hpmix.kr(0), [sig, sig2]);
	sig = sig * 8;

	//amp = amp * SinOsc.kr(1*~t).range(0.1,1);
	amp = amp * \gain.kr(1);
	igate = Trig.kr(\itrig.tr(1), \isustain.kr(0.01));
	amp = amp * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), igate, levelScale:\iamp.kr(1), doneAction:0);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

Ndef(~name+++\fx).unset(\ffreq);
Ndef(~name+++\fx).put(1, \set -> Pbind(
	\itrig, Pseq([1],inf),
	\isustain, Pseq([
		0.1,0.1,0.1,0.1,
	],inf),
	\ffreq, Pseq([
		5000, 1000, 1000, 1000,
		1000, 5000, 1000, 1000,
	],inf).stutter(1),
	\isRest, Pseq([
		Prand([
			Pseq([
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],1),
		],1),
	],inf).coin.not,
	\iamp, Pseq([
		1,0.3,0.7,0.3,
	],inf),
	\iamp, 1,
	\dur, 1/8,
));
);

(
	Ndef(~name+++\fx).unset(\ffreq, 2500);
	Ndef(~name+++\fx).set(\hpfreq, 1900);
	
);


Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig;
});
