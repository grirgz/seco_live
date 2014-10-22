
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trig;
	var lpfenv;

	trig = Dust.kr(1/9);

	freq = EnvGen.kr(
		Env([400,200,200,120],[4.1,0.8,8.1], [-4]) , trig, timeScale:0.1) 
		* TRand.kr(0.3,1.5, trig);
	freq =  TChoose.kr(trig, [500,250,750]) + TRand.kr(0.3,8.5, trig);
	freq = freq * [1,1+EnvGen.kr(Env([1,2,1]/100,[4.1,8.8], trig)),-3.midiratio + TRand.kr(0.000,0.001, trig)];
	
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( EnvGen.kr(Env([2,1,0],[1.1,0.8]), trig, timeScale:0.1), [sig1, sig2, sig3]);

	lpfenv = EnvGen.kr(Env([1,TRand.kr(0.7,2.6,trig),1],[TRand.kr(0.1,1.6,trig),0.8]), trig, timeScale:0.1);
	sig1 = RLPF.ar(sig, TRand.kr(400,12000,trig) * lpfenv + 0.5, \rq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);

	sig = sig * EnvGen.ar(Env.adsr(0.1,0.4,0.4,0.1),Trig.kr(trig,0.5),doneAction:0);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	//sig = AllpassL.ar(sig, 4, 1/8/~t * SinOsc.kr(1/45).range(0.9,1.1),14) + sig;
	//sig = AllpassL.ar(sig, 4, 1/4/~t * SinOsc.kr(1/25).range(0.9,1.1),8) + sig;
	sig = AllpassL.ar(sig, 4, SinOsc.kr(1/45).unipolar(0.3) + 1 * 1/2/~t ,18) + sig;
	
	sig;
});

);
