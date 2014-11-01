(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, timeScale=1;
	var sig, sig1, sig2, sig3, sig4, sig5;
	var osig, asig;
	sig1 = LFTri.ar(291);
	sig1 = FreqShift.ar(sig1, 75);
	sig1 = sig1 + FreqShift.ar(sig1, 24);
	sig1 = sig1 * EnvGen.ar(Env.perc(0.0001,0.01), gate, timeScale:timeScale) * 1;

	sig2 = SinOsc.ar(330+Rand(0.0,10),mul:0.3) + SinOsc.ar(210+Rand(0.0,10));
	sig2 = sig2 * EnvGen.ar(Env.perc(0.0001,0.19,1,-8), gate, timeScale:timeScale) * 1;

	sig3 = SinOsc.ar( EnvGen.kr(\env.kr(Env([220,190,400,200],[0.1,0.48,0.4].normalizeSum)), gate));
	//sig3 = BRF.ar(sig3, [100,800,300,400]*4).sum;
	//sig3 = BPF.ar(sig3, [100,100,100,200]*\fratio3.kr(6));
	sig3 = sig3 * EnvGen.ar(Env.perc(0.0001,0.4251, 1, \sqr), gate, timeScale:timeScale) * 0.4;

	sig4 = WhiteNoise.ar(1);
	//sig4 = BRF.ar(sig4, [100,800,1900,400,900]*Rand(8.0,11)).sum;
	sig4 = BRF.ar(sig4, Rand(8.0!5,[100,800,1900,400,900])).sum;
	sig4 = HPF.ar(sig4, [500,3000,740,100]*1*XLine.kr(1,0.0100,[0.13,0.1,0.3]));
	sig4 = LPF.ar(sig4, [500,300,740,100]*5*XLine.kr(1,0.0100,[0.13,0.1,0.3]));
	sig4 = sig4 * EnvGen.ar(Env.perc(0.0001,0.101+Rand(0.05,0.1), 1, \cub), gate, timeScale:timeScale);
	asig = sig4;

	sig4 = WhiteNoise.ar(1);
	sig4 = BRF.ar(sig4, [ 25, 31, 1697, 1095, 383  ]*Rand(1.0,4), 0.7).sum;
	sig4 = LPF.ar(sig4, [ 65, 2642, 271, 1060  ]*Rand(3.0,4)*XLine.kr(1,0.100,[0.03,0.1,0.1]));
	//sig4 = BRF.ar(sig4, [100,100,3900,1400,900].rand.postln*1, 0.7).sum;
	//sig4 = LPF.ar(sig4, [500,3100,1240,1320].rand.postln*1.7*XLine.kr(1,0.5100,[0.13,0.1,0.3]));
	sig4 = sig4 * EnvGen.ar(Env.perc(0.0001,0.101+Rand(0.05,0.1), 1, -4), gate, timeScale:timeScale);

	sig5 = WhiteNoise.ar(1);
	sig5 = Klank.ar(Ref([100,300,400,500,900]*1,0.1!5,0.1!5), sig5)/2700;
	sig5 = sig5 * EnvGen.ar(Env.perc(0.0001,0.101+Rand(0.05,0.1), 1, -4), gate, timeScale:timeScale);

	sig = 
		0
		+ sig1
		+ sig2 
		+ sig3
		+ sig4
		//+ sig5
		//+ asig
		;
	//sig = (HPF.ar(sig,4000 * XLine.kr(1,0.01,0.02))*4).tanh + LPF.ar(sig, 1200);


	osig = sig;
	//sig = AllpassL.ar(sig,0.1,[0.012,0.02,0.014,0.0132] *2,0.18) + sig;
	sig = AllpassL.ar(sig,0.1,0.0051 + {0.003.rand}!8,0) + sig;
	//sig = AllpassL.ar(sig,0.1,0.002.rand+0.001,0.01) + sig;
	sig = LPF.ar(sig, \elpf.kr(2999));
	sig = HPF.ar(sig, \ehpf.kr(100));
	//sig = BRF.ar(sig, [100,940,1700,4000,9000]*1) / 2;
	sig = SelectX.ar(\fmix.kr(0.5), [sig, osig]);
	//sig = [sig, osig, sig, osig];
	//sig = osig;
	sig.postln;
	//sig = sig * 0.51;

	//sig = sig.clump(2);

	//sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.00001,0.1,0.1,0.2,1,\sqr)),gate,doneAction:doneAction);
	//sig = Splay.ar(sig, spread, amp, pan);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig.flop;
	//sig.flop.postln;
	DetectSilence.ar(sig, 0.001,0.1,doneAction:2);
	Out.ar(out, sig);
}).add;
);
(
Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1/8,
	\fratio3, Pseg(Pseq([1,5],inf),8),
	\elpf, Pseg(Pseq([100,2000],inf),8),
	\ehpf, Pseg(Pseq([5000,100,2000],inf),8),
	\elpf, 1300,
	\fmix, 0.9981981981982,
	\ehpf, 750,
	\timeScale, 1.04,
	\spread, 0.0,
	\adsr, Pseq([
		[ Env.adsr(0.5,0.1,0.8,1.1) ],
	],inf),
	\amp, Pkey(\amp) * 1.5,
	\amp, Pkey(\amp) * Pseq([1,0.5],inf).stutter(2),
	\lag, 0.02,
	\isRest, Pseq([
			Pseq([
				 0,0,0,0,
				 1,0,0,0,
			],1),
	],inf).coin.not,
	\isRest, Veco(~namex).isrest(8),
));
)

