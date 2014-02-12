//Pdef(~name)
(
Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	//\isRest, Pseq([Veco(~name).isrest(16,1),Pn(true,4),Pn(false,4)],inf) ,
	\start, Pseq([0.5,0.55],inf)+Pwhite(0,0.5),
	\speed, Pseq([
		0.1,0.2,0.3,0.1,
		0.4,0.02,0.3,0.1,
		0.1,0.2,0.3,0.1,
		0.4,0.52,0.3,0.1,
	],inf)+Pwhite(0,0.01),
	\end, Pkey(\start)+ Pseq([0.06,0.01,0.05,0.09]/10,inf),
	\end, Pkey(\start)+ Pseq([0.1,0.01]/10,inf),
)); 

Ndef(~name+++\fx, { arg freq=100, mix=0.2, nlag=0.2, noisefreq=8, ffreq=2000.5, rq=0.3;
	var in = InFeedback.ar(BusDef(~name+++\fx), 2);
	//var freq;
	var sfreq;
	var sig;
	//freq = LFNoise0.ar([0.21,0.2,0.19]*8).range(50,[1000,2000,500]*LFNoise0.ar(0.2).abs).lag(0.5);
	sig = in * SinOsc.ar(freq);
	//sig = in;
	//sfreq = LFNoise0.ar([0.21,0.2,0.19]*8.01).range(50,[1000,2000,500]*LFNoise0.ar(0.2).abs).lag(0.5);
	sfreq = freq;
	sfreq = LFNoise0.ar([0.21,0.2,0.19]*noisefreq).range(50,freq*[1,2,0.5]*LFNoise0.ar(0.2).abs).lag(nlag);
	sig = FreqShift.ar(sig, sfreq);
	sig = SelectX.ar(mix,[in,sig]);
	sig = RLPF.ar(sig,ffreq.lag(nlag),rq);
	4.do { arg x;
		var del = LFNoise0.ar([0.21,0.2,0.19]*8.01).range(0.250,[1,0.2,0.5]*LFNoise0.ar(0.2).abs).lag(0.5);
		var isig;
		isig = CombC.ar(sig, 0.1,0.1*del*x,0.4) + sig;
		sig = SelectX.ar(0.7, [sig , isig]);
	};
	sig = sig / 8;
	sig = LeakDC.ar(sig);
	sig.postln;

	sig = Splay.ar(sig);
}).play;

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\freq, Pseq([
		500,1000,
		400,300,
		600,700,
		500,300,
		//4500,300,
	],inf),
	\ffreq, Pseq([200,5000,10000],inf),
	\freq, Pseq([100,200,50,60],inf),
	\nlag, 2,
	\noisefreq, Pseq([8,0.2,0.1],inf),
	\mix, Pseq([0.8,0.2],inf),
	\dur, 1/4,
));
Ndef(~name+++\fx).quant = Pdef.defaultQuant;
)

// END

Buffer
	BufDef(\camion).numFrames /

