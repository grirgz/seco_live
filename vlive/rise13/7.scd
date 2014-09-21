~name = 'rise13-7';


(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, timeScale=1;
	var sig, sig1, sig2, sig3, sig4, sig5;
	var osig, asig;
	sig1 = LFTri.ar(291);
	sig1 = FreqShift.ar(sig1, 75);
	sig1 = sig1 + FreqShift.ar(sig1, 24);
	sig1 = sig1 * EnvGen.ar(Env.perc(0.0001,0.01), gate, timeScale:timeScale) * 1;

	sig2 = SinOsc.ar(330) + SinOsc.ar(210);
	sig2 = sig2 * EnvGen.ar(Env.perc(0.0001,0.03), gate, timeScale:timeScale) * 1;

	sig3 = SinOsc.ar(100, SinOsc.ar(10, SinOsc.ar(40)) * 122);
	sig3 = SinOsc.ar(615.00, 
		LFSaw.ar(410.87) +
			WhiteNoise.ar(2) +
		SinOsc.ar(487, 
			WhiteNoise.ar(4) +
			SinOsc.ar(4390, 
				WhiteNoise.ar(1) +
				SinOsc.ar(497) * 10.43) 
			* 1.250) 
		* 1.31);
	//sig3 = WhiteNoise.ar(1);
	sig3 = BRF.ar(sig3, [100,800,300,400]*1).sum;
	sig3 = BPF.ar(sig3, [100,100,100,200]*\fratio3.kr(6));
	sig3 = sig3 * EnvGen.ar(Env.perc(0.0001,0.151, 1, \sqr), gate, timeScale:timeScale) * 0.4;

	sig4 = WhiteNoise.ar(1);
	sig4 = BRF.ar(sig4, [100,800,1900,400,900]*2).sum;
	sig4 = HPF.ar(sig4, [500,3000,740,100]*1*XLine.kr(1,0.1100,[0.13,0.1,0.3]));
	sig4 = LPF.ar(sig4, [500,300,740,100]*5*XLine.kr(1,0.8100,[0.13,0.1,0.3]));
	sig4 = sig4 * EnvGen.ar(Env.perc(0.0001,0.051, 1, \cub), gate, timeScale:timeScale);
	asig = sig4;

	sig4 = WhiteNoise.ar(1);
	sig4 = BRF.ar(sig4, [100,800,1900,400,900]*1).sum;
	sig4 = LPF.ar(sig4, [500,3000,740,1000]*1*XLine.kr(1,0.5100,[0.13,0.1,0.3]));
	sig4 = sig4 * EnvGen.ar(Env.perc(0.0001,0.101, 1, -4), gate, timeScale:timeScale);

	sig = 
		0
		+ sig1
		+ sig2 
		+ sig3
		+ sig4
		+ asig
		;
	//sig = (HPF.ar(sig,4000 * XLine.kr(1,0.01,0.02))*4).tanh + LPF.ar(sig, 1200);


	osig = sig;
	sig = AllpassL.ar(sig,0.1,[0.012,0.02,0.014,0.0132] *2,0) + sig;
	sig = AllpassL.ar(sig,0.1,0.001,0) + sig;
	sig = LPF.ar(sig, \elpf.kr(3000));
	sig = HPF.ar(sig, \ehpf.kr(1000));
	//sig = BRF.ar(sig, [100,940,1700,4000,9000]*1) / 2;
	sig = SelectX.ar(\fmix.kr(0.5), [sig, osig]);
	//sig = osig;
	sig.postln;
	//sig = sig * 0.51;


	//sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.00001,0.1,0.1,0.2,1,\sqr)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	DetectSilence.ar(sig, 0.001,0.1,doneAction:2);
	Out.ar(out, sig);
}).add;
);

~pdef_channel.();

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
