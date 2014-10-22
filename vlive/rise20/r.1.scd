
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trig;
	var lpfenv;

	trig = Dust.ar(14);

	sig = Decay2.ar(trig, 0.01, 0.2);
	//sig = Ringz.ar(sig, TRand.kr(200,4700,trig),0.1);
	sig = Ringz.ar(sig, 
		LFNoise1.kr(1/9).range(0.8,1.2) * 
		Demand.ar(trig, 0, Drand([
			100,120,130,440,
		]*3,inf)),0.1);
	sig = sig * (CuspN.ar(1/24)+0.2);
	sig = sig * 0.1;


	//sig = sig * EnvGen.ar(Env.adsr(0.1,0.4,0.4,0.1),Trig.kr(trig,0.5),doneAction:0);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
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
