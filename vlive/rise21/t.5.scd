
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	var freq;
	var lpspread;
	var env1, env2, env3;
	var trig;

	trig = Impulse.kr(1/8*~t);
	env1 = EnvGen.kr(Env([0,1,0],[0.01,9.8],[0,-2]), trig);

	freq = 140 * [-1,5,15,10,20].midiratio;
	freq = freq *.t [1,TChoose.kr(trig, [4,2,1,1/2]),TRand.kr(0,0.01, trig)+1,1/2,TRand.kr(0,0.01, trig) + TChoose.kr(trig, [4,2,1,1/2]),1.001,2];
	freq = freq.flatten;
	freq = env1/100 + 1  * freq;

	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(LFNoise1.kr(0.5).unipolar*2 * env1, [sig1, sig2, sig3]);
	//sig = SelectX.ar(0.3, [sig1, sig2, sig3]);

	sig1 = sig.fold2( SinOsc.kr(1/4/(1..11)).range(0.1,2) * env1);
	sig2 = sig.wrap2( SinOsc.kr(1/4/(1..11).reverse).range(0.1,2) * env1);
	sig = SelectX.ar( LFNoise1.kr(1/2).range(0.0,1.0)*2, [sig, sig1, sig2]);

	sig = sig * SinOsc.kr(1/3/(1..10)).pow(2).range(0,1);

	lpspread = SinOsc.kr(1/5*(1..11)/9)*1.5;
	lpspread = (env1/3 + 0.01).exp.poll;
	//lpspread = 0;
	sig = RLPF.ar(sig, \lpf.kr(400) * (env1 + 1), \rq.kr(0.5));
	sig = HPF.ar(sig, 700);
	sig = sig * 2;
	sig.postln;

	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.2), amp, \pan.kr(0));

	sig = sig * env1;

	sig;
});

