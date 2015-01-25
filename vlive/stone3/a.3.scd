(
// TAGS: ndef, growl, rhytmed, noise, drone, granular
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
	var itrig = \itrig.tr(1);
	var igate = Trig.kr(itrig, \isustain.kr(0.1));
	env1 = EnvGen.kr(Env([0.14,1,2,1],[0.1,0.2,0.1]), itrig) * SinOsc.kr(4*~t).range(1,2);
	clk = Impulse.ar(074 / env1);
	pos = 0.1 * env1/2;
	pos = 0.4;
	pitch_stretch = env1 * 1/4;
	//bufnum = BufDef.mono(\ukraine, "bruit1/07_ukraine.flac");
	bufnum = BufDef.mono(\moeten, "voices/02_moeten.flac");
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);

	//sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.1)),Trig.kr(gate,0.5),doneAction:0);

	ffreqtab = \ffreqtab.kr(1!8);
	//sig = FreqShift.ar(sig, \fshift.kr(0));
	//sig2 = RLPF.ar(sig, \ffreq.kr(200) * ffreqtab, \rq.kr(0.3));
	//sig = SelectX.ar( \lpmix.kr(0), [sig, sig2]);
	//sig2 = HPF.ar(sig, \hpfreq.kr(180) * ffreqtab, \rq.kr);
	//sig = SelectX.ar(\hpmix.kr(0), [sig, sig2]);
	sig = sig * 8;

	amp = amp * \gain.kr(1);
	amp = amp * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.1)), igate, doneAction:0);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});


Ndef(~name+++\fx).put(1, \set -> Pbind(
	\freq, Pseq([1],inf),
	\dur, 1/8,
	\isustain, 0.1,
	\itrig, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf),
	\itrig, Pseq([
		0,0,0,0, 1,0,1,0,
		0,0,1,0, 1,0,1,0,
	],inf),
	\isustain, Pseq([
		0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.4, 0.1,
		0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 2.4, 0.1,

		0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.4, 0.1,
		0.1, 0.1, 2.1, 0.1, 0.1, 0.1, 0.4, 0.1,
	],inf)/4,
));
);

(
	Ndef(~name+++\fx).set(\ffreq, 7500);
	Ndef(~name+++\fx).set(\hpfreq, 500);
	
);

Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	//sig = AllpassL.ar(sig, 4, 1/8/~t * SinOsc.kr(1/45).range(0.9,1.1),0.1) + sig;
	//sig = AllpassL.ar(sig, 4, 1/4/~t * SinOsc.kr(1/25).range(0.9,1.1),0.1) + sig;
	//sig = AllpassL.ar(sig, 4, 1/2/~t,0.1) + sig;
	
	sig;
});
