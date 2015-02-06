
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;

	var igate, dur, sustain, legato;
	var freq;

	freq = Ndef.ar(~roger+++\freq) * [1,2,3,4,5,6,7];
	freq = Ndef.ar(~roger+++\freq);


	freq.poll;


	sig = SinOsc.ar(freq);

	sig = sig.collect({ arg isig, x;
		var isig1;
		dur = 2;
		legato = 0.9;
		sustain = legato * dur;
		freq[x].debug("freq");

		igate = TDuty.kr(dur/~t * LFNoise1.kr(1/2).range(1.0,2.0), 0, Dseq([
			1,1,1,1,
			Dseq([
				0.3,1.1,0.8,0.5
			],1),
		],inf))*sustain/~t;

		isig1 = isig * LFSaw.ar(freq[x]*(x+1) * [1,1.001,1/2]);
		isig = SelectX.ar( EnvGen.kr(Env([0,1,0.51],[0.2,0.8]), igate), [isig, isig1]);

		isig1 = (isig * 100).tanh;
		isig = SelectX.ar( EnvGen.kr(Env([0,1,0.51],[1.4,0.8]), igate), [isig, isig1]);

		isig1 = RLPF.ar(isig, freq.wrapAt(x+1).poll / 2,0.4);
		isig = SelectX.ar( EnvGen.kr(Env([1,0,1.00],[0.4,0.8]), igate), [isig, isig1]);

		isig = isig * EnvGen.ar(Env.adsr(0.01,0.1,1,1.1),Trig.kr(igate,igate),doneAction:0);

	});
	sig.debug("sig");
	sig = sig.flop.mean;
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
