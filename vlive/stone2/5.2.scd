
// TAGS: nappe, ndef, futur, dark, granular
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
	var dur = 0.1;
	var pitch_stretch = 1;
	var pan = 0;
	var env1, env2;
	var trig;
	trig = Impulse.kr(1/4*~t);
	env1 = EnvGen.kr(Env([1,8,1],[0.1,0.8]), trig);
	clk = Impulse.ar(40 * env1);
	pos = 0.1;
	bufnum = BufDef.mono(\ukraine, "bruit1/07_ukraine.flac");
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);

	//sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.1)),Trig.kr(gate,0.5),doneAction:0);

	ffreqtab = \ffreqtab.kr(1!8);
	//sig = FreqShift.ar(sig, \fshift.kr(0));
	//sig2 = RLPF.ar(sig, \ffreq.kr(200) * ffreqtab, \rq.kr(0.3));
	//sig = SelectX.ar( \lpmix.kr(0), [sig, sig2]);
	//sig2 = HPF.ar(sig, \hpfreq.kr(180) * ffreqtab, \rq.kr);
	//sig = SelectX.ar(\hpmix.kr(0), [sig, sig2]);
	sig = BPF.ar(sig, [700,3200], 0.1);
	sig = SelectX.ar( SinOsc.kr(1/2*~t).range(0,1), sig);
	sig = sig * 48;

	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

(
	Ndef(~name+++\fx).set(\ffreq, 1500);
	Ndef(~name+++\fx).set(\hpfreq, 500);
	
);


Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	sig = AllpassL.ar(sig, 4, 1/8/~t * SinOsc.kr(1/45).range(0.9,1.1),1) + sig;
	sig = AllpassL.ar(sig, 4, 1/4/~t * SinOsc.kr(1/25).range(0.9,1.1),1) + sig;
	sig = AllpassL.ar(sig, 4, 1/2/~t,4) + sig;
	
	sig;
});
