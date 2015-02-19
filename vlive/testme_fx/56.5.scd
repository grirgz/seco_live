
(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	var del = 1/2;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var k=8;
	var kk = (1..k)/k;
	
	sig1 = sig;
	//sig = DynKlank.ar(Ref([[100,200],[1,1]/6,[1,1]/7]),sig);
	sig1 = DynKlank.ar(
		Ref([
			SinOsc.kr(1 * kk, kk+0.1).range(60, Duty.kr(1/~t, 0, Dseq([
				120,200,100,1000,
				100, 70,80,1900,
			],inf))),
			1/15!k,
			1/5!k,
		]),
		sig
	);
	//sig = RLPF.ar(sig, 500);
	//sig = (sig*4).tanh/4;
	sig = sig * 22;
	sig.debug("sk");
	//sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.flop.size, 1).mean;
	Peak.ar(sig).poll(label:"bpeak");
	sig2 = sig;
	sig2 = Compander.ar(sig2, sig, 0.7, 1, 0.30001, clampTime:0.01);
	Peak.ar(sig2).poll(label:"apeak");
	//sig1 = CombL.ar(sig, del, del, 4.9) + sig2;
	sig = sig2;
	//sig =  sig1;
	//Amplitude.ar(sig, 0.2,0.2).poll;
	//sig = sig.clump(2).mean;
	sig = sig /12;
	sig.debug("sk");

	sig;
});
);

// END

(
SynthDef(\plop, {
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sig;

	sig = SinOsc.ar(401) ! 2;
	Amplitude.ar(sig,0.2,0.2).poll;
	Peak.ar(sig).poll(label:"peak");
	sig;
	
}).play;
)
0.7*1.4
7*14
x=(1..8); 1*x*2*x
