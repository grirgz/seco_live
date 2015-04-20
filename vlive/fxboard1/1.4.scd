
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq,freq2;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = 710;
	//freq = freq * [1,2,3,4];
	freq = freq * Duty.kr(4/~t, 0, Dseq([
		[0,3,7,9, -17,-12],
	],inf)).midiratio;

	freq2 = \fmfreq.kr(100);
	//freq = freq * Ndef.ar(~name+++\fx).linlin(-1,1, 0.1,1);
	freq = freq2;
	freq = freq * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1);
	freq = freq * SinOsc.ar(freq * LFNoise1.kr(10 * (1..8)/8).range(1,14)).range(0,10);
	in = InFeedback.ar(\inbus.kr(BusDef(\in1, \audio))); 
	sig = Fb { arg fb;
		var sig;
	
		sig = in * 70;
		//sig = SinOsc.ar(540) ;
		sig = sig + ( fb * 1 * \fb.kr(4) * LFSaw.ar(\fbfm.kr(1)).unipolar );
		//freq2 = \fmfreq.kr;
		//sig = HenonC.ar(freq2,0.1,0.01) + sig;

		sig = LPF.ar(sig.abs > \killamp.kr(0.8), \killlpf.kr(10) * LFSaw.ar(\killfm.kr(10)).range(1,2)) * sig;
		sig1 = \lpf.kr(7100) * ((0..7)/7 - 0.5 * \lpfspread.kr(1) + 1);
		sig1 = sig1 ++ [ \lpf2.kr(1000) ];
		sig = RLPF.ar(sig, sig1, \rq.kr(0.5) ! (sig1.size-1) ++ [\rq2.kr(0.5)]);
		//sig[sig.size-1] = sig[sig.size-1] * \lpamp2.kr(800);
		sig = (sig*\distamp.kr(14)).tanh * SelectX.ar(\select.kr(1), [DC.ar(1), sig]);
		sig = sig * \xamp.kr(1.4);
		
		sig = Limiter.ar(sig, 1);
		sig = sig * 1;
		sig = LeakDC.ar(sig);
		//amp = amp * XLine.ar(0.3,1);
		//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
		sig = SelectX.ar(\mix.kr(0),[in, sig]);
		sig = Compander.ar(sig, in, \compt.kr(0.4), \complow.kr(1.001), \comphigh.kr(0.9));
	};
	sig = sig * 4;
	amp = amp * \gain.kr(1);
	amp = amp * \finamp.kr(1);
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	sig;
})

// END

BusDef(\in1).getSynchronous
BusDef(\in1).set(0)

Ndef(~name+++\fx).set(\lpf, 100)
