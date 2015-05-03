
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var slope;
	var fspread = \fspread.kr(0.01);
	var igate;
	var ifreq;
	ifreq = \ifreq.kr(1)*~t;
	freq = \freq.kr(100);
	sig = SinOsc.ar(freq); 
	slope = (Slope.kr(freq).abs.linexp(0,10,0.01,1) * Slope.kr(freq).sign ).lag(1.3);
	slope = 0;
	freq = freq * (1+slope);
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	freq = freq *.x [0,7,3].midiratio;
	freq = freq * Duty.kr(1/ifreq, 0, Dseq([
		1,0,0,0,
		4,4,3,2,
	],inf)).midiratio;
	freq = freq.clip(20,19000);
	sig = sig * (1+LFSaw.ar(( freq *(1+ \amdetune.kr(1)) * (1+( slope*1 )) ).clip(20,19000),mul:\amamp.kr(1) * (1+slope )));
	
	sig = DelayL.ar(sig, 0.1, SinOsc.kr(1/4 * (1..8)/8 * \delfreq.kr(1)).range(0,0.1) * \del.kr(1)) + sig;
	sig = DelayL.ar(sig, 0.1, LFNoise1.kr(1/4 * (1..8)/8 * \delfreq.kr).range(0,0.1) * \del.kr) + sig;
	sig = RLPF.ar(sig, ( freq * \lpfac.kr(1) ).clip(10,19000), \rq.kr(0.5));

	igate = Impulse.kr(ifreq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.7)), igate);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});
Ndef(~name+++\fx).addSpec(\fspread, ControlSpec(0.0001,1,\exp));
Ndef(~name+++\fx).addSpec(\amdetune, ControlSpec(0.001,100,\exp));


