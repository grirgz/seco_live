
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

~set_macro.(\k1, Ndef(~name+++\fx), \fmfreq, \freq);
~set_macro.(\k2, Ndef(~name+++\fx), \lpf, \freq);
~set_macro.(\k3, Ndef(~name+++\fx), \fspread, ControlSpec(0.000001,1,\exp));
~set_macro.(\k4, Ndef(~name+++\fx), \select, \unipolar);
~set_macro.(\k5, Ndef(~name+++\fx), \distamp, ControlSpec(0.01,50,\exp,0,1));
~set_macro.(\k6, Ndef(~name+++\fx), \killamp, ControlSpec(0.01,1,\exp,0,1));
~set_macro.(\k7, Ndef(~name+++\fx), \rq, ControlSpec(0.01,1,\exp,0,1));
