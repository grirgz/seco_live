
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var bpfreq;
	var rfreq;
	
	sig = 4.collect({
		var isig;

		isig = CuspN.ar(1000 * WhiteNoise.ar.range(0.1,2));
		bpfreq = 0
			+ LFNoise1.kr(1/2).range(10,4000.0)
			+ LFNoise1.kr(1/12).range(100,2000.0)
			+ LFNoise1.kr(2).range(1000,20.0)
			;
		//sig = SinOsc.ar(bpfreq.poll);
		//bpfreq = bpfreq * [1,2.1,1/2,1.3];

		bpfreq = bpfreq * (1+ ( SinOsc.ar(1)*0.01 ));
		isig = BPF.ar(isig, bpfreq , LFNoise1.kr(1/13).range(0.051,0.3));
		isig = isig * CuspN.ar(LFNoise1.kr(1/12).range(1.0,1000.0), 1.1.rand);
	});
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
