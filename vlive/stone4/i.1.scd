
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 200 ;
	var mou, moy;
	//freq = SinOsc.kr(1).range(1,2) * freq;
	freq = Duty.kr(1/4/~t, 0, Dseq([
		1,2,1,4,
	].midiratio,inf)) * freq;
	freq = freq * [0,5.01,7.0,1.04].midiratio;

	sig = SinOsc.ar(freq);
	//sig = IEnvGen.ar(Env([0,SinOsc.kr(1/7).range(0.1,4),0.2* SinOsc.kr(1/5).range(1,3),3]/3,[1,1,1].normalizeSum,0), sig.range(0,1));
	//sig = IEnvGen.ar(Env([0,1 * XLine.ar(0,10,10),0.2,3]*2 -1,[1,1,1].normalizeSum,0), sig.range(0,1));
	//sig = sin(log(sig+ SinOsc.kr(1/7).range(0,1))*sig * SinOsc.kr(1/4).range(1,10));
	mou = MouseX.kr(0,1000);
	moy = MouseY.kr(0,1);
	//sig = 1/(sig+2 + mou)**(sig);
	sig = sin(log(1/(sig+moy)**(sig * SinOsc.ar(freq/4))));
	sig = LeakDC.ar(sig);
	//sig = ( sig > 0 * sin(sig* SinOsc.kr(1/4 * [1,2.3]).range(1,44)) ) + (sig < 0 * sig);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

// END

{ var sig = SinOsc.ar(200); log(sig) }.plot(0.01)
{ var sig = SinOsc.ar(200); [sig,sin(log(sig))] }.plot(0.01)
{ var sig = SinOsc.ar(200); [sig,1/(sig+2)**(sig)] }.plot(0.01)
sin(log(0.1))
