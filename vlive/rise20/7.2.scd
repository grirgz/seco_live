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

	//gate = Impulse.kr(1/4/~t);
	gate = TDuty.kr(4/~t,0,1);
	freq = \freq.kr(100);

	bufnum = BufDef(\table);
	osc = SinOsc.ar(freq*1);
	//osc = osc.sum;
	pos = \pos.kr(0.35) * [1,1.001];
	pos = EnvGen.kr(\posenv.kr(Env([0,0.018,0,0.0002, 0.012].integrate, [1.2,0.1,0.1,4.1])),gate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	//phase = osc * \range.kr(0.000001) + pos + \finepos.kr(0).lag(\fineposlag.kr(0));
	phase = osc * \frange.kr(5) + (pos + \finepos.kr(0).lag(\fineposlag.kr(0)) * BufFrames.kr(bufnum));

	bufsig = BufRd.ar(2, bufnum, phase, 1);
	bufsig = bufsig.sum;
	bufsig = bufsig * 1880;

	bufsig = bufsig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.1)),Trig.kr(gate,0.5),doneAction:0);
	ou = bufsig;

	ffreqtab = \ffreqtab.kr(1!8);
	ou = FreqShift.ar(ou, \fshift.kr(0));
	ou2 = RLPF.ar(ou, \ffreq.kr(200) * ffreqtab, \rq.kr(0.3));
	ou = SelectX.ar( \lpmix.kr(1), [ou, ou2]);
	ou2 = HPF.ar(ou, \hpfreq.kr(180) * ffreqtab, \rq.kr);
	ou = SelectX.ar(\hpmix.kr(1), [ou, ou2]);

	sig = ou;
	//sig = bufsig;
	
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
	sig = AllpassL.ar(sig, 4, 1/8/~t * SinOsc.kr(1/45).range(0.9,1.1),14) + sig;
	sig = AllpassL.ar(sig, 4, 1/4/~t * SinOsc.kr(1/25).range(0.9,1.1),8) + sig;
	sig = AllpassL.ar(sig, 4, 1/2/~t,8) + sig;
	
	sig;
});
