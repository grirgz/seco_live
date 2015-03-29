
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq,freq2;
	freq = 710;
	//freq = freq * [1,2,3,4];
	freq = freq * Duty.kr(4/~t, 0, Dseq([
		[0,3,7,9, -17,-12],
	],inf)).midiratio;

	freq2 = \fmfreq.kr(100);
	freq = freq2;
	freq = freq * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1);
	freq = freq * SinOsc.ar(freq * LFNoise1.kr(10 * (1..8)/8).range(1,14)).range(0,10);
	sig = SinOsc.ar(freq); 
	//freq2 = \fmfreq.kr;
	sig = HenonC.ar(freq2,0.1,0.01) + sig;

	sig = sig.abs > \killamp.kr(0.8) * sig;
	sig = RLPF.ar(sig, \lpf.kr(7100), \rq.kr(0.5));
	sig = (sig*\distamp.kr(14)).tanh * SelectX.ar(\select.kr(1), [DC.ar(1), sig]);
	
	//amp = amp * XLine.ar(0.3,1);
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	sig;
})

// END

Ndef(~name+++\mixer).play(BusDef(\in1).index)
Ndef(~name+++\mixer).play(0)
Ndef(~name+++\mixer).edit
Ndef(~name+++\mixer).get(\amp)
