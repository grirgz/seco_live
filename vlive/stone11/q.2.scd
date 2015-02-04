
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freqtab;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var size = 8;
	var pan;
	var time = 4;
	var nffreq;
	var env1, env2;

	env1 = MouseX.kr(0,1);

	nffreq = LFNoise1.kr(1/32).range(4,1/16);
	nffreq = SelectX.kr(env1, [nffreq, 1/8]);
	freq = LFNoise1.kr(nffreq ! size).range(50,3000);
	freq = SelectX.kr(env1, [freq, 1000]).cpsmidi.round(1).midicps;
	freq = freq *.t [1,2,4];

	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);

	nffreq = LFNoise1.kr(1/32).range(4,1/16);
	nffreq = SelectX.kr(env1, [nffreq, 1/8]);
	sig8 = LFNoise1.kr(nffreq ! size).range(0,2);
	sig8 = SelectX.kr(env1, [freq, 2]);
	sig = SelectX.ar(sig8 , [sig1, sig2, sig3]);

	sig = LFNoise1.ar(1/8!3) * sig;
	sig = sig.flop.mean;

	sig8 = LFNoise1.kr(nffreq ! size).range(50,3000);
	sig8 = SelectX.kr(env1, [freq, 500]);
	sig1 = RLPF.ar(sig, sig8);

	sig8 = LFNoise1.kr(nffreq ! size).range(0,1);
	sig8 = SelectX.kr(env1, [freq, 2]);
	sig = SelectX.ar( sig8, [sig, sig1]);

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

