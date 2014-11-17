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
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	var clk;
	var dur = 0.2;
	var pitch_stretch = 1/18;
	var pan = 0;
	var env1, env2;
	clk = Impulse.ar(14 * SinOsc.kr(1/4).range(1,3));
	pos = 0.7;
	bufnum = BufDef.mono(\ukraine, "bruit1/07_ukraine.flac");
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	sig = sig * LFSaw.ar( Duty.kr(1/4/~t, 0, Dseq([
		800,1200,4000,8100
	],inf)).lag(0.1));

	//sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.1)),Trig.kr(gate,0.5),doneAction:0);

	ffreqtab = \ffreqtab.kr(1!8);
	ffreqtab = Array.series(8,1,0.4).scramble;
	ffreqtab = ffreqtab / Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,4,
		8,8,8,8,
	],inf));
	sig = FreqShift.ar(sig, \fshift.kr(-70));
	sig2 = RLPF.ar(sig, \ffreq.kr(40) * ffreqtab, \rq.kr(0.3));
	sig = SelectX.ar( \lpmix.kr(1), [sig, sig2]);
	sig2 = HPF.ar(sig, \hpfreq.kr(50));
	sig = SelectX.ar(\hpmix.kr(1), [sig, sig2]);
	sig = sig * 48;
	sig = sig * Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
	],inf));

	sig.postln;
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

(
	Ndef(~name+++\fx).set(\ffreq, 8500);
	Ndef(~name+++\fx).set(\hpfreq, 4500);
	
);


Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	//sig = AllpassL.ar(sig, 4, 1/8/~t * SinOsc.kr(1/45).range(0.9,1.1),1) + sig;
	//sig = AllpassL.ar(sig, 4, 1/4/~t * SinOsc.kr(1/25).range(0.9,1.1),1) + sig;
	//sig = AllpassL.ar(sig, 4, 1/2/~t,4) + sig;
	
	sig;
});
