
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trig;
	var lpfenv;
	var parafil;

	trig = Dust.ar(84);
	trig = Impulse.ar(14 * LFNoise1.kr(1/2).exprange(0.8,8.0));
	trig = trig + Dust.ar(40 * LFNoise1.kr(1/2).range(0.8,2.0));

	sig = Decay2.ar(trig, 0.01, 0.2);
	//sig = Ringz.ar(sig, TRand.kr(200,4700,trig),0.1);
	//sig = BPF.ar(sig, 
	//	LFNoise1.kr(1/9).range(0.8,1.2) * 
	//	Demand.ar(trig, 0, Drand([
	//		100,120,130,440,
	//	]*3,inf)),0.7);
	parafil = LFNoise1.kr(1/8).range(0.0,1.0);
	sig1 = Ringz.ar(sig, TRand.ar(200.0,4700,trig).lag(0.1),0.01) / 10;
	sig2 = SelectX.ar(parafil, [sig1, sig]);
	sig2 = BPF.ar(sig2, 
		LFNoise1.kr(1/2).range(300,14000)
		, 0.2 * LFNoise1.kr(1/2).range(0.8,2.0));
	//sig = SelectX.ar( LFNoise1.kr(1/7).range(0.0,1.0), [sig1, sig2]);
	sig = SelectX.ar( parafil, [sig2, sig1 + sig2]);

	sig = sig * (CuspN.ar(1/24).unipolar/3+0.2);
	sig = sig * 20;


	//sig = sig * EnvGen.ar(Env.adsr(0.1,0.4,0.4,0.1),Trig.kr(trig,0.5),doneAction:0);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));

	sig = sig * Duty.kr(1/~t, 0, Dseq([
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,1,1,
	],inf)).lag(0.1);
	sig;
});

Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	//sig = AllpassL.ar(sig, 4, 1/8/~t * SinOsc.kr(1/45).range(0.9,1.1),14) + sig;
	//sig = AllpassL.ar(sig, 4, 1/4/~t * SinOsc.kr(1/25).range(0.9,1.1),8) + sig;
	//sig = AllpassL.ar(sig, 4, SinOsc.kr(1/45).unipolar(0.3) + 1 * 1/2/~t ,18) + sig;
	
	sig;
});

);
