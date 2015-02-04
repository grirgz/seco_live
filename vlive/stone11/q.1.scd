
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freqtab;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var size = 8;
	var pan;
	freq = 60;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		1,0,3,2,
	],inf)).midiratio *.t [1,2,4];

	freqtab = LFNoise1.ar(1/44 * (1..8)).range(0,1).round(1/8);
	
	sig = LFSaw.ar(freq * ( 1+( freqtab * 0.2 + 0.1 ) ));
	sig = sig * [1,0.5,0.3] * LFNoise1.ar(1/8 ! 3);
	sig = sig.flatten;

	sig1 = sig + FreqShift.ar(sig, 1 * freqtab.linlin(0,1,-0.00100,0.0100));
	sig = SelectX.ar( XLine.ar(0.01,1,16) + ( LFNoise1.ar(1/4)**2 /2 ), [sig, sig1]);

	sig1 = sig + DelayL.ar(sig, 1, 1 * freqtab.linlin(0,1,0.01,0.1));
	sig = SelectX.ar( XLine.ar(0.01,1,16), [sig, sig1]);

	sig1 = RLPF.ar(sig, SinOsc.kr(1/4 * (1..8)/20).range(100,7000), 0.5 * SinOsc.kr(1/4*(1..8)/16).range(0.1,1));
	sig = SelectX.ar( XLine.ar(0.01,1,16) + ( LFNoise1.ar(1/4) /2 ), [sig, sig1]);

	sig1 = sig.tanh;
	sig = SelectX.ar( XLine.ar(0.01,1,16) + ( LFNoise1.ar(1/4) /2 ), [sig, sig1]);

	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig.debug("sig");
	pan = LFNoise1.kr(1/2 * (1..size)/8).range(-1.0,1.0);
	sig1 = DC.kr(-1);
	sig2 = DC.kr(1);
	sig3 = DC.kr(0);
	sig4 = SelectX.kr( ( LFNoise1.kr(1/1).range(0,1) ) * 2, [sig1, sig2, sig3]);
	pan = SelectX.kr( ( LFNoise1.kr(1/1).range(0,1) ) * 1, [pan, sig4]);
	pan.debug("pan");
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig");
	sig;
})

