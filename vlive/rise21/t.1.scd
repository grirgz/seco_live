
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	var freq;
	var lpspread;

	freq = 140 * [0,3,5].midiratio;
	freq = freq *.t [1,4,1.01,1/2,4.01,1.001,2];

	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(SinOsc.kr(0.5*(1..11)/12).unipolar*2, [sig1, sig2, sig3]);
	//sig = SelectX.ar(0.3, [sig1, sig2, sig3]);

	sig = sig.fold2( SinOsc.kr(1/4/(1..11)).range(0.1,2));
	sig = sig.wrap2( SinOsc.kr(1/4/(1..11).reverse).range(0.1,2));
	lpspread = SinOsc.kr(1/5*(1..11)/9)*1.5;
	//lpspread = 0;
	sig = RLPF.ar(sig, \lpf.kr(400) * ((0..11)/11 - 0.5 * lpspread + 1), \rq.kr(0.5));
	sig = HPF.ar(sig, 700);

	sig = sig / 5;
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.2), amp, \pan.kr(0));
	sig;
});

