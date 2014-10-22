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
	gate = TDuty.kr(1/~t,0,Dseq([1,0],inf));
	freq = \freq.kr(100);

	bufnum = BufDef(\table);
	osc = SinOsc.ar(freq*1);
	//osc = osc.sum;
	pos = \pos.kr(0.35) * [1,1.001] + LFNoise1.kr(1/24).range(0.0,0.001);
	pos = EnvGen.kr(Env([0,0.018,0,0.0002, 0.012].integrate, [0.2,0.1,0.1,2.1]),gate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	//phase = osc * \range.kr(0.000001) + pos + \finepos.kr(0).lag(\fineposlag.kr(0));
	phase = osc * \frange.kr(5) + (pos + \finepos.kr(0).lag(\fineposlag.kr(0)) * BufFrames.kr(bufnum));

	bufsig = BufRd.ar(2, bufnum, phase, 1);
	bufsig = bufsig.sum;
	bufsig = bufsig * 280;

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
	var shift;
	shift = Duty.kr(1/~t, 0, Dseq([
		100,0,-200,300,
	],inf));
	sig = sig + Fb { arg fb;
		var isig;
		isig = fb*0.89 + sig;
		isig = AllpassL.ar(isig, 4, (1/4+2)/~t,0);
		isig = FreqShift.ar(isig, shift);
		isig = AllpassL.ar(isig, 4, (1/4+2)/~t,0);
		isig = isig.tanh;
		isig = AllpassL.ar(isig, 4, (1/4+2)/~t,0);
	
	};
	
	sig;
});
