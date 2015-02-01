
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var env1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	freq = Duty.kr(4/~t, 0, Dseq([
		70,72,71,75,
	],inf));
	freq = freq * Duty.kr(8/~t, 0, Dseq([
		[0,3,7,11,19],
		[0+12,3,7,10,17],
	],inf)).midiratio *.t [1,4];
	freq = freq.flat;
	sig = SinOsc.ar(freq);
	sig = sig *.t [DC.ar(1), LFSaw.ar(180 * SinOsc.kr(1/17).range(1/2,1))];
	sig = SelectX.ar( SinOsc.kr(1/20).range(0,1), [sig, sig.flop] );
	sig = SelectX.ar( SinOsc.kr(1/24).range(0,1), sig );

	sig = LPF.ar(sig, 100 * SinOsc.kr(1/17 * (1..sig.size).normalizeSum).range(1,10));



	sig = sig *.t [DC.ar(1), LFPulse.ar(100* SinOsc.kr(1/47).range(1/2,1))];
	sig = SelectX.ar( SinOsc.kr(1/29).range(0,1), [sig, sig.flop] );
	sig = SelectX.ar( SinOsc.kr(1/23).range(0,1), sig );

	sig = RLPF.ar(sig, 210 * SinOsc.kr(1/37 * (1..sig.size).normalizeSum).range(1,10));
	//sig = SelectX.ar( SinOsc.ar(101/2 * SinOsc.kr(1/14).range(0,1)).range(0,1), [sig2, sig3]);
	//sig = SelectX.ar( SinOsc.ar(1/2 * SinOsc.kr(1/14).range(0,1)).range(0,2), [sig2, sig3, sig4]);
	//sig = SelectX.ar( SinOsc.ar(1/2 * SinOsc.kr(1/14).range(0,1)).range(0,1), [sig2, sig3]);
	sig.debug("sig");
	sig = sig;
	sig = sig ;

	sig = LPF.ar(sig,170);
	sig = sig * Duty.kr(1/2/~t, 0, Dseq([
		1,1,1,1,
		1,1,0,0,
	],inf));
	//sig = HPF.ar(sig,70);

	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
})
