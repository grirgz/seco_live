
Ndef(\dist).clear;

(
Ndef(\dist).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var trig;
	var env;
	trig = Impulse.kr(1/4);
	freq = 200;
	freq = freq * Demand.kr(trig, 0, Dseq([
		0,9,20,18,
		18,
	],inf)).midiratio;
	env = EnvGen.kr(Env.adsr(1.41,0.1,0.8,3.2), Trig1.kr(trig,1), doneAction:0);

	sig = LFSaw.ar(freq *  [0,5,7].midiratio);
	sig = sig.mean;
	sig.postln;
	sig = RLPF.ar(sig, 13000,0.6);

	sig = sig * env;
	
	sig  = Splay.ar(sig, 0.1, amp, 0);
	sig;
}).play
)

(
Ndef(\dist).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var trig;
	var env;
	trig = Impulse.kr(1/4);
	freq = 200;
	freq = freq * Demand.kr(trig, 0, Dseq([
		0,3,5,9
	],inf)).midiratio;
	env = EnvGen.kr(Env.adsr(1.41,0.1,0.8,3.2), Trig1.kr(trig,1), doneAction:0);

	sig = LFSaw.ar(freq *  [0,5,7,12,12+5,12+7].midiratio);
	//sig = sig.mean;
	sig.postln;
	sig = RLPF.ar(sig, 13000,0.6);

	sig = sig * env;
	
	sig  = Splay.ar(sig, 0.1, amp, 0);
	sig;
}).play
)

(
Ndef(\dist).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var trig;
	var env;
	trig = Impulse.kr(8);
	freq = 200;
	freq = freq * Demand.kr(trig, 0, Dstutter(8,
		Dseq([
		0,3,5,9
	],inf)
	),).midiratio;
	env = EnvGen.kr(Env.adsr(0.00001,0.1,0.8,0.2), Trig1.kr(trig,1/8), doneAction:0);

	sig = SinOsc.ar(freq *  [0,5,7,12,12+5,12+7].midiratio);
	//sig = sig.mean;
	sig.postln;
	//sig = RLPF.ar(sig, 13000,0.6);

	sig = sig * env;
	
	sig  = Splay.ar(sig, 0.1, amp, 0);
	sig;
}).play
)

(
Ndef(\dist).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var trig;
	var env;
	trig = Impulse.kr(1/4);
	freq = 200;
	freq = freq * Demand.kr(trig, 0, Dseq([
		0,9,20,18,
		18,
	],inf)).midiratio;
	freq = freq.lag(4);
	freq = SinOsc.ar(1/8).range(100,10000);
	env = EnvGen.kr(Env.adsr(1.41,0.1,0.8,3.2), Trig1.kr(trig,1), doneAction:0);

	sig = LFSaw.ar(freq *  [0,5,7].midiratio);
	sig = sig.mean;
	sig.postln;
	sig = RLPF.ar(sig, 13000,0.6);

	sig = sig * env;
	
	sig  = Splay.ar(sig, 0.1, amp, 0);
	sig;
}).play
)

(
Ndef(\dist).put(50, nil)
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 200;
	sig = sig.tanh;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 1120;
	sig = sig.distort;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 20;
	sig = 0
		+ ( (sig < 0) * (sig*4).tanh )
		+ ( (sig > 0) * sig )
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 400.1;
	sig = 0
		+ ( (sig > 0) * sin(1/(1+sig)) )
		+ ( (sig < 0) * sig.clip2(1.3) )
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 40.1;
	sig = 0
		+ ( (sig > 0) * sig * 2 * sin(SinOsc.ar(100).abs/(1+sig)) )
		+ ( (sig < 0) * sin(sig*10) * 3 )
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 400.1;
	sig = 0
		+ ( (sig > 0) * sig * 2 * sin(SinOsc.ar(8).abs/(1+sig)) )
		+ ( (sig < 0) * sin(sig/10) * 3 )
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 40.1;
	sig = 0
		+ ( (sig > 0) * FreqShift.ar(sig, 100) )
		+ ( (sig < 0) * FreqShift.ar(sig, -100) )
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 4000.1;
	sig = 0
		+ ( (sig > 0) * FreqShift.ar(sig, 1000) )
		+ ( (sig < 0) * FreqShift.ar(sig, -1000) )
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 100.1;
	sig = 0
		+ ( (sig > 0) * ( sig + DelayL.ar(sig,0.01,0.01) ))
		+ ( (sig < 0) * ( sig + DelayL.ar(sig,0.04,0.01235) )) 
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 100.1;
	sig = 0
		+ ( (sig > 0) * ( sig ) )
		+ ( (sig < 0) * ( RLPF.ar(sig, 700 * SinOsc.ar(800).abs + 50,0.1) )) 
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 50.1;
	sig = 0
		+ ( (sig > 0) * ( sig * LFSaw.ar(700).range(0.9,4.1) ) )
		+ ( (sig < 0) * ( sig* LFSaw.ar(4900).range(0.1,4.1)) ) 
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 50.1;
	sig = 0
		+ ( (sig > 0) * ( sig % LFSaw.ar(70).range(0.9,4.1) ) )
		+ ( (sig < 0) * ( (sig*4).tanh ) )
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 50.1;
	sig = 0
		+ ( (sig > 0.3) * ( sig % LFSaw.ar(70).range(0.9,4.1) ) )
		+ ( (sig < -0.3) * ( (sig*4).tanh ) )
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 95.1;
	sig = 0
		+ ( (sig < 0.3) * (sig > 0) * ( sin(sig*10)*4 ))
		+ ( (sig > 0.3) * ( sin(sig) ))
		+ ( (sig < 0) * ( (sig*4).tanh ) )
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 95.1;
	sig = 0
		+ ( (sig < 0.3) * (sig > 0) * ( sin(sig*40)*4 ))
		+ ( (sig > 0.3) * ( sin(sig) ))
		+ ( (sig < 0) * ( (sig*4).tanh ) )
		+ ( (sig > -0.3) * (sig < 0) * ( tanh(sig*90)*4 ))
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 95.1;
	sig = 0
		+ ( (sig < 0.3) * (sig > 0) * ( sin(sig*4)*4 ))
		+ ( (sig > 0.3) * ( 0-sig ))
		+ ( (sig < 0) * ( (sig*4).tanh ) )
		+ ( (sig > -0.3) * (sig < 0) * ( tanh(sig*2)*4 ))
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 95.1;
	sig = 0
		+ ( (sig < 0.3) * (sig > 0) * ( CombL.ar(sig, 4, 1/150,1) + sig) )
		+ ( (sig > 0.3) * ( 0-sig ))
		+ ( (sig < 0) * ( (sig*4).tanh ) )
		+ ( (sig > -0.3) * (sig < 0) * ( tanh(sig*2)*4 ))
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 95.1;
	sig = 0
		+ ( (sig < 0.1) * (sig > 0) * WhiteNoise.ar )
		+ ( (sig > 0.1) * ( 0-sig ))
		+ ( (sig < 0) * ( sig ) )
		+ ( (sig > -0.3) * (sig < 0) * ( sig ))
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 95.1;
	sig = 0
		+ ( (sig < 0.5) * (sig > 0) * sig )
		+ ( (sig > 0.5) * ( WhiteNoise.ar ))
		+ ( (sig < 0) * ( sig ) )
		+ ( (sig > -0.3) * (sig < 0) * ( sig ))
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 95.1;
	sig = SinOsc.ar(ZeroCrossing.ar(sig)) * sig;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 50.1;
	sig = LFSaw.ar(ZeroCrossing.ar(sig))/5 * sig;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;

	sig = sig * 50.1;
	sig = CombL.ar(sig, 0.1, 1/ZeroCrossing.ar(sig)) -19.5 * Amplitude.kr(sig);
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;
	var pitch;

	sig = sig * 50.1;
	
	pitch = ZeroCrossing.ar(sig).poll;
	sig = 0
		+ ( (pitch < 1000) * sig  )
		+ ( (pitch >= 1000) * LFSaw.ar(pitch)  )
		;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;
	var pitch;

	sig = sig * 5.1;
	
	pitch = ZeroCrossing.ar(sig);
	sig = LFNoise1.ar(pitch.clip(50,18000)).poll  * sig + sig ;
	sig = LeakDC.ar(sig);
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;
	var pitch;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	sig = sig * 50.1;
	
	sig1 = LPF.ar(sig, 1500);
	sig2 = HPF.ar(sig, 1500);
	sig2 = sig2.tanh;
	sig1 = sig1.clip2(1);
	sig = sig1 + sig2;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;
	var pitch;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	sig = sig * 50.1;
	
	in.poll;
	pitch = LPF.ar(ZeroCrossing.ar(sig),5) * 2;
	
	sig1 = LPF.ar(sig, pitch);
	sig2 = HPF.ar(sig, pitch);
	sig2 = sig2.tanh;
	sig1 = sig1.clip2(1);
	sig = sig1 + sig2;
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;
	var pitch;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	sig = sig * 500.1;
	
	sig1 = HPF.ar(sig,500) * 1;
	sig = FreqShift.ar(sig, ZeroCrossing.ar(sig1)/10) + sig;
	sig = Amplitude.ar(sig).poll/100 * sig;
	
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)

(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;
	var pitch;
	var bands;
	var size = 45;

	sig = sig * 5.1;

	bands = size.collect({ arg x;
		var isig;
		var ifreq = 11000/size * x + 100;
		ifreq.postln;
		isig = BPF.ar(sig, ifreq, 0.7);
		isig = Amplitude.ar(isig) * 10;
		//isig.poll(label:"x"+x);
		isig = SinOsc.ar(ifreq) * isig;
	});
	bands.postln;
	sig = SelectX.ar(SinOsc.ar(ZeroCrossing.ar(sig)).range(0,size-1), bands);
	sig.postln;
	sig = bands.sum;
	
	sig = LeakDC.ar(sig);
	sig = Limiter.ar(sig);
	sig = sig/4;

	sig;
}).play
)


(
Ndef(\dist).put(50, \filter -> { arg in;
	var sig = in;
	var lim;
	var gain;
	
	//sig = sig * SinOsc.ar(120);
	//gain = 18.001;
	gain = \pregain.kr(18);
	lim = \lim.kr(0);
	sig = sig * gain;
	3.do {
		sig = CombL.ar(sig, 4, 0.23.rand,0.4.rand) + sig;
	};
	//sig = CombL.ar(sig, 4/~t, 1/2/~t,1/~t) + sig;
	//sig = CombL.ar(sig, 4/~t, 1/3.23/~t,1/~t) + sig;
	//Amplitude.ar(sig).poll;
	//sig = sig.clip2(0.5);
	sig = 
		0
		//+ ( (sig > lim) * tanh(0-sig.abs*44) )
		//+ ( (sig > lim) * FreqShift.ar(sig,700) )
		+ ( (sig > lim) * sin(1/(1+sig)) )
		//+ ( (sig.abs > lim) * RLPF.ar(sig * sig.abs, 100 ))
		+ ( (sig <= lim) * sig.clip2(0.5) )
		;
	//sig = LPF.ar(sig,9500);
	//sig = HPF.ar(sig,250);
	////sig = sig / gain;
	sig = Limiter.ar(sig);
	sig = sig / 4;

	sig;
}).play;
)
