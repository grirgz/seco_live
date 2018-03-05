
(
Ndef(\woof, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var tscale = 1/2;
	sig = WhiteNoise.ar;
	sig = Saw.ar(70 * EnvGen.kr(Env([1,2,7],[2.1 * tscale,0.8]), 1) * ( SinOsc.ar(100) * 0.2  * EnvGen.kr(Env([1,20,2],[2.1,0.8], 1))+ 1 )) + sig;
	sig = LPF.ar(sig, EnvGen.ar(Env([200,5000,5000],[1.1 * tscale,0.8], [1,-1]), 1));
	sig = BPF.ar(sig, EnvGen.kr(Env([201,5000 * [1,1.1,2],1],[1.1 * tscale,0.8]), 1), 1) + ( sig/4 );
	sig = sig * EnvGen.kr(Env([0.01,0.1,1,0],[0.3,3.3 * tscale,0.008], [3,-1]), 1);
	sig = FreeVerb.ar(sig, mix:0.2, room:2.5, damp:0.5);
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.1), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	//sig = SinOsc.ar(freq);
	pan = pan + SinOsc.ar((1..sig.size) * 100/1, mul: EnvGen.kr(Env([0,0.51,0],[1.1,0.8]), 1);); 
	sig = Pan2.ar(sig, pan, amp).mean;
	sig;
}).play;

//)
//(

Ndef(\woof2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var tscale = 2/2;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = WhiteNoise.ar;
	sig = PinkNoise.ar * Duty.kr(1/32/~t, 0, Dseq([
		1,0,0,1,
		1,0,1,0,
		1,0,0,1,
	],inf));
	sig2 = Pulse.ar(70 * EnvGen.kr(Env([8,1,7],[2.1 * tscale,0.8]), 1) * ( SinOsc.ar(400) * 0.2  * EnvGen.kr(Env([1,20,2],[2.1,0.8], 1))+ 1 )) + sig;
	sig2 = sig2  * Duty.kr(1/30/~t, 0, Dseq([
		0,1,0,1,
		1,1,0,1,
		1,0,1,0,
	],inf));
	sig = sig + sig2;
	sig = FreqShift.ar(sig, EnvGen.kr(Env([0,-0.2,-31],[1.1,0.8]), 1)) + sig;
	sig = LPF.ar(sig, EnvGen.ar(Env([14200,500,500],[1.1 * tscale,0.8], [1,-1]), 1));
	sig = sig * EnvGen.kr(Env([0.01,0.1,1,0],[0.3,1.3 * tscale,0.008], [3,-1]), 1);
	sig = FreeVerb.ar(sig, mix:0.2, room:2.5, damp:0.5);
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.1), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	//sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
	sig;
}).play;
);


(
Ndef(\woof, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var tscale = 1/2;
	sig = WhiteNoise.ar;
	sig = Saw.ar(70 * EnvGen.kr(Env([1,2,7],[2.1 * tscale,0.8]), 1) * ( SinOsc.ar(100) * 0.2  * EnvGen.kr(Env([1,20,2],[2.1,0.8], 1))+ 1 )) + sig;
	sig = LPF.ar(sig, EnvGen.ar(Env([200,5000,5000],[1.1 * tscale,0.8], [1,-1]), 1));
	sig = BPF.ar(sig, EnvGen.kr(Env([201,5000 * [1,1.1,2],1],[1.1 * tscale,0.8]), 1), 1) + ( sig/4 );
	//sig = SinOsc.ar(freq);
	pan = pan + SinOsc.ar((1..sig.size) * 1/1, mul: EnvGen.kr(Env([0,0.51,0],[1.1,0.8]), 1);); 
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(Env([0.01,0.1,1,0],[0.3,3.3 * tscale,0.008], [3,-1]), 1);
	sig;
});


Ndef(\woof2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var tscale = 2/2;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = WhiteNoise.ar;
	sig = PinkNoise.ar * Duty.kr(1/32/~t, 0, Dseq([
		1,0,0,1,
		1,0,1,0,
		1,0,0,1,
	],inf));
	sig2 = Pulse.ar(70 * EnvGen.kr(Env([8,1,7],[2.1 * tscale,0.8]), 1) * ( SinOsc.ar(400) * 0.2  * EnvGen.kr(Env([1,20,2],[2.1,0.8], 1))+ 1 )) + sig;
	sig2 = sig2  * Duty.kr(1/30/~t, 0, Dseq([
		0,1,0,1,
		1,1,0,1,
		1,0,1,0,
	],inf));
	sig = sig + sig2;
	sig = FreqShift.ar(sig, EnvGen.kr(Env([0,[ -0.2, 0.2 ],-31],[1.1,0.8]), 1)) + sig;
	sig = LPF.ar(sig, EnvGen.ar(Env([14200,500,500],[1.1 * tscale,0.8], [1,-1]), 1));
	//sig = SinOsc.ar(freq);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	sig = sig * EnvGen.kr(Env([0.01,0.1,1,0],[0.3,1.3 * tscale,0.008], [3,-1]), 1);
	sig;
});


Ndef(\main, {
	var sig;
	var in;
	var fbsig;
	fbsig = LocalIn.ar(2) * \fb.kr(0.1) * EnvGen.kr(Env([0.1,1,0.001],[1.1,0.8]), 1);
	in = [
		Ndef.ar(\woof),
		Ndef.ar(\woof2),
	].sum;
	sig = in + fbsig;
	sig = sig.tanh;
	sig = AllpassL.ar(sig, 0.1, Rand(0.01,0.01!13),0.1).sum + sig;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig = [
		Splay.ar(in, EnvGen.kr(Env([0,0,0],[1.1,0.8]), 1), 1, 0),
		Splay.ar(sig, EnvGen.kr(Env([0,0,0],[1.1,0.8]), 1), 1, 1),
	].sum;
	sig = LeakDC.ar(sig);
	sig = FreeVerb.ar(sig, mix:0.2, room:2.5, damp:0.5);
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.001), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig;
}).play;
);


(
	Ndef(\woof).send;
	Ndef(\woof2).send;
Ndef(\main, {
	var sig;
	var in;
	var fbsig;
	in = [
		Ndef.ar(\woof),
		//Ndef.ar(\woof2),
	].sum;
	sig = in;
	//sig = FreeVerb.ar(sig, mix:0.2, room:2.5, damp:0.5);
	//sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.001), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig;
}).play;
)


