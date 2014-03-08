(
Ndef(~name+++\fx).put(100, \filterIn -> { arg in, rrange=30000, clkrate=1000, pitch_stretch=1, dur=0.1, pan=0,
			spread=0.8, amp=1, fb=0.5, maxdelay=0.1, decaytime=3, lpfreq=5000, freqshift=0,
			drive=10, distamp=0.5;
	var freq = 400;
	var sig;
	var sig2;
	var buf;
	var head;
	var numframes;
	var clk, pos;
	in.postln;
	clk = Impulse.ar(clkrate);

	sig = in;
	sig = sig + Fb({ arg fbsig;
		var isig;
		var isig2;
		var time;
	
		isig = fbsig * fb + sig;
		//isig = BPF.ar(isig, 500*SinOsc.ar(1).range(0.5,5),0.3);
		//time = [0.1,0.2,0.3,0.4,0.5].rand*4;
		//time.postln;
		//isig = DelayN.ar(isig, 0.1,0.1*time) + isig;
		//time = [0.1,0.2,0.3,0.4,0.5].rand;
		//isig = DelayN.ar(isig, 0.1,0.1*time) + isig;

		//15.do{isig = AllpassN.ar(isig, 0.01, TRand(0.001,maxdelay, \randtrig.tr(1)), decaytime)}; 
		15.do{isig = AllpassN.ar(isig, 0.01, TRand.kr(0.001,maxdelay, \randtrig.tr(1)), decaytime)}; 
		isig = LPF.ar(isig, lpfreq,0.3);
		isig = FreqShift.ar(isig, freqshift);
		isig = (isig*drive).distort * distamp;
		//sig = sig + (DelayC.ar(LocalIn.ar(2) *0.1, 0.1,0.1) * 0.3);
		//pitch_stretch = 1;
		//clkrate = 1000;
		//LocalOut.ar(sig);
		//sig = BufRd.ar(2, buf, head-3000, 1);
		//sig = sig + in;
		//sig = SelectX.ar(0.5, [in, sig]);
		isig = Limiter.ar(isig, 0.9,0.001);
		isig;
	},0.0);
	//sig = [sig , sig2];
	sig = Splay.ar(sig, spread, amp, pan);
	//sig = Limiter.ar(sig, 0.9,0.001);
	sig;
	//in;
	//in;
	
})
);

(
Veco(~name).lib.macros = [
	[Ndef(~name+++\fx), \wet100],
	[Ndef(~name+++\fx), \amp],
	[Ndef(~name+++\fx), \decaytime],
	[Ndef(~name+++\fx), \maxdelay],
	[Ndef(~name+++\fx), \randtrig],
	[Ndef(~name+++\fx), \freqshift],
	[Ndef(~name+++\fx), \drive],
	[Ndef(~name+++\fx), \distamp],
];
);

// END

Ndef(~name+++\fx).set(\randtrig, 1)

~buf = Buffer.alloc(s, 1*s.sampleRate,1);
Ndef(~name+++\mixer).edit
Ndef(~name+++\mixer).play
Ndef(~name+++\fx).play(BusDef(~name+++\mixer))
Ndef(~name+++\fx).stop
Ndef(~name+++\fx).edit

(
Ndef(~name+++\fx).put(100, \filter -> { arg in, rrange=30000, clkrate=1000, pitch_stretch=1, dur=0.1, pan=0;
	var freq = 400;
	var sig;
	var buf;
	var head;
	var numframes;
	var clk, pos;
	var imp;
	//var clkrate;
	imp = Impulse.ar(1/10);
	imp = 0;
	numframes = 0.2*s.sampleRate;
	//buf = LocalBuf(numframes,2);
	buf = ~buf;
	head = Phasor.ar(0, BufRateScale.kr(buf), 0, BufFrames.kr(buf));
	head.poll;
	in.postln;
	clk = Impulse.ar(clkrate);

	sig = in;
	sig = Fb({ arg fb;
	
		//sig = sig + (DelayC.ar(LocalIn.ar(2) *0.1, 0.1,0.1) * 0.3);
		//pitch_stretch = 1;
		//clkrate = 1000;
		BufWr.ar(sig.sum, buf, head, 1);
		pos = Latch.ar(head, clk);
		pos = pos - LFNoise1.kr(clkrate).range(100,rrange);
		pos = pos / s.sampleRate;
		pos = pos.wrap(0,1);
		//pos.poll;
		//dur = 0.15;
		pan = 0;
		sig = TGrains.ar(2, clk, buf, pitch_stretch, pos, dur, pan, 1, 2);
		//LocalOut.ar(sig);
		//sig = BufRd.ar(2, buf, head-3000, 1);
		//sig = sig + in;
		//sig = SelectX.ar(0.5, [in, sig]);
		sig;
	},0.1);
	sig;
	in;
	//in;
	
})
);
