
// xTAGS: ndef, harsh, noise, drone, granular
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;

	
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	var gate;
	var bufnum;
	var pos;
	var freq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	var clk;
	var dur = 0.1;
	var pitch_stretch = [2, 1,1/2 ];
	var pan = 0;
	var env1, env2;
	var range;

	freq = [100,200,500] + XLine.kr(1,23,8/~t);
	sig2 = Duty.kr(1/2/~t, 0, Dseq([
		1,2,1/2,2,
	],inf));
	sig2 = Duty.kr(1/4/~t, 0, Dseq([
		0,2,4,1,
	],inf)).midiratio;
	sig = LFPulse.ar(freq * ( 1 + ( SinOsc.kr(freq * sig2) * XLine.kr(1,13,8/~t) )));
	sig = sig + CombL.ar(sig, 1/20,1/freq * ( 1 + ( LFNoise1.kr(1/2 *(1..8)/8/10).unipolar  * 10.1) ),1);
	sig = sig + CombL.ar(sig, 1/20,1/( freq*sig2 ) * ( 1 + ( LFNoise1.kr(1/2 *(1..8)/8/10).unipolar  * 10.1) ),1);
	sig = LeakDC.ar(sig);
	sig = sig /10;
	sig = LPF.ar(sig, 9000);
	sig = HPF.ar(sig, 60);

	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

(
	Ndef(~name+++\fx).set(\ffreq, 1500);
	Ndef(~name+++\fx).set(\hpfreq, 500);
	
);


Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	//sig = AllpassL.ar(sig, 4, 1/2/~t,4) + sig;
	
	sig;
});
