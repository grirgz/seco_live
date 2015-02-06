
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;

	var igate, dur, sustain, legato;
	var freq;

	freq = Ndef.ar(~roger+++\freq) * [1,2,3,4,5,6,7,8];




	sig = SinOsc.ar(freq);

	sig = sig.collect({ arg isig, x;
		var isig1;
		dur = 1/2;
		legato = 0.3;
		sustain = legato * dur;

		igate = TDuty.kr(dur/~t * LFNoise1.kr(1/2).range(1.0,2.0), 0, Dseq([
			1,1,1,1,
			Dseq([
				0.3,1.1,0.8,0.5
			],1),
		],inf))*sustain/~t;

		isig1 = isig * LFSaw.ar(freq[x]/2);
		isig = SelectX.ar( EnvGen.kr(Env([0,1,0.51],[0.2,0.8]), igate), [isig, isig1]);

		isig1 = (isig * 100).tanh;
		isig = SelectX.ar( EnvGen.kr(Env([0,1,0.51],[1.4,0.8]), igate), [isig, isig1]);

		isig = isig * EnvGen.ar(Env.adsr(0.01,0.1,1,0.1),Trig.kr(igate,igate),doneAction:0);

	});
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
