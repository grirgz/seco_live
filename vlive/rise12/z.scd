
(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3, sig4, sig5;
	sig1 = LFTri.ar(111);
	sig1 = FreqShift.ar(sig1, 175);
	sig1 = sig1 + FreqShift.ar(sig1, 224);
	sig1 = sig1 * EnvGen.ar(Env.perc(0.0001,0.02), gate);

	sig2 = SinOsc.ar(330) + SinOsc.ar(180);
	sig2 = sig2 * EnvGen.ar(Env.perc(0.0001,0.051), gate);

	sig3 = PinkNoise.ar(1);
	sig3 = BRF.ar(sig3, [100,800,300,400]*2).sum;
	sig3 = LPF.ar(sig3, [5000,6000,100,10000]*2);
	sig3 = sig3 * EnvGen.ar(Env.perc(0.0001,0.251), gate);

	sig4 = WhiteNoise.ar(1);
	sig4 = BRF.ar(sig3, [100,800,300,400]*2).sum;
	sig4 = LPF.ar(sig3, [5000,6000,100,10000]*1);
	sig4 = sig3 * EnvGen.ar(Env.perc(0.0001,0.351), gate);

	sig = sig1 + sig2 + sig3 + sig4;
	sig = (HPF.ar(sig,100)*14).distort + LPF.ar(sig, 100);
	sig = sig * 1;




	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.0001,0.1,0.8,0.4)),gate,doneAction:doneAction);
	//sig = DetectSilence.ar(sig, doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3, sig4, sig5;
	sig1 = LFTri.ar(111);
	sig1 = FreqShift.ar(sig1, 175);
	sig1 = sig1 + FreqShift.ar(sig1, 224);
	sig1 = sig1 * EnvGen.ar(Env.perc(0.0001,0.02), gate);

	sig2 = SinOsc.ar(330) + SinOsc.ar(180);
	sig2 = sig2 * EnvGen.ar(Env.perc(0.0001,0.051), gate);

	sig3 = PinkNoise.ar(1);
	sig3 = BRF.ar(sig3, [100,800,300,400]*2).sum;
	sig3 = LPF.ar(sig3, [5000,6000,100,10000]*2);
	sig3 = sig3 * EnvGen.ar(Env.perc(0.0001,0.151, 1, \sqr), gate);

	sig4 = WhiteNoise.ar(1);
	sig4 = BRF.ar(sig4, [100,800,300,400]*4).sum;
	sig4 = LPF.ar(sig4, [500,6000,100,1000]*2*XLine.kr(1,0.100,0.1));
	sig4 = sig4 * EnvGen.ar(Env.perc(0.0001,0.151, 1, \cub), gate);

	sig = sig1 + sig2 + sig3 + sig4;
	//sig = (HPF.ar(sig,100)*14).distort + LPF.ar(sig, 100);
	sig = sig * 2;




	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.0001,0.1,0.8,2.4)),gate,doneAction:doneAction);
	//sig = DetectSilence.ar(sig, doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3, sig4, sig5;
	var osig, asig;
	sig1 = LFTri.ar(291);
	sig1 = FreqShift.ar(sig1, 75);
	sig1 = sig1 + FreqShift.ar(sig1, 24);
	sig1 = sig1 * EnvGen.ar(Env.perc(0.0001,0.01), gate) * 4;

	sig2 = SinOsc.ar(330) + SinOsc.ar(210);
	sig2 = sig2 * EnvGen.ar(Env.perc(0.0001,0.03), gate) * 4;

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
	sig3 = BPF.ar(sig3, [100,100,100,200]*6);
	sig3 = sig3 * EnvGen.ar(Env.perc(0.0001,0.401, 1, \sqr), gate);

	sig4 = WhiteNoise.ar(1);
	sig4 = BRF.ar(sig4, [100,800,1900,400,900]*2).sum;
	sig4 = BPF.ar(sig4, [500,3000,740,1000]*4*XLine.kr(1,0.1100,[0.13,0.1,0.3]));
	sig4 = sig4 * EnvGen.ar(Env.perc(0.0001,0.251, 1, \cub), gate);
	asig = sig4;

	sig4 = BrownNoise.ar(1);
	sig4 = BRF.ar(sig4, [100,800,1900,400,900]*1).sum;
	sig4 = LPF.ar(sig4, [500,3000,740,1000]*4*XLine.kr(1,0.1100,[0.13,0.1,0.3]));
	sig4 = sig4 * EnvGen.ar(Env.perc(0.0111,0.151, 1, \cub), gate);

	sig = 
		0
		+ sig1
		+ sig2 
		+ sig3
		+ sig4
		+ asig
		;
	sig = (HPF.ar(sig,1000 * XLine.kr(4,0.1,0.01))*4).tanh + LPF.ar(sig, 12000);


	osig = sig;
	sig = AllpassL.ar(sig,0.1,[0.012,0.02,0.014,0.0132] *2,0) + sig;
	sig = AllpassL.ar(sig,0.1,0.001,0) + sig;
	sig = LPF.ar(sig, 3000);
	sig = BRF.ar(sig, [100,940,1700,4000,9000]*1) / 2;
	sig = sig + osig;
	//sig = osig;
	sig.postln;
	sig = sig * 0.51;


	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.00001,0.7,0.9,0.2,1,\sqr)),gate,doneAction:doneAction);
	//sig = DetectSilence.ar(sig, doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3, sig4, sig5;
	var osig, asig;
	sig1 = LFTri.ar(291);
	sig1 = FreqShift.ar(sig1, 75);
	sig1 = sig1 + FreqShift.ar(sig1, 24);
	sig1 = sig1 * EnvGen.ar(Env.perc(0.0001,0.01), gate) * 1;

	sig2 = SinOsc.ar(330) + SinOsc.ar(210);
	sig2 = sig2 * EnvGen.ar(Env.perc(0.0001,0.03), gate) * 1;

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
	sig3 = BPF.ar(sig3, [100,100,100,200]*6);
	sig3 = sig3 * EnvGen.ar(Env.perc(0.0001,0.151, 1, \sqr), gate);

	sig4 = WhiteNoise.ar(1);
	sig4 = BRF.ar(sig4, [100,800,1900,400,900]*2).sum;
	sig4 = BPF.ar(sig4, [500,3000,740,1000]*1*XLine.kr(1,0.1100,[0.13,0.1,0.3]));
	sig4 = sig4 * EnvGen.ar(Env.perc(0.0001,0.451, 1, \cub), gate);
	asig = sig4;

	sig4 = WhiteNoise.ar(1);
	sig4 = BRF.ar(sig4, [100,800,1900,400,900]*1).sum;
	sig4 = LPF.ar(sig4, [500,3000,740,1000]*1*XLine.kr(1,0.5100,[0.13,0.1,0.3]));
	sig4 = sig4 * EnvGen.ar(Env.perc(0.0001,0.451, 1, -4), gate);

	sig = 
		0
		+ sig1
		+ sig2 
		+ sig3
		+ sig4
		+ asig
		;
	sig = (HPF.ar(sig,4000 * XLine.kr(1,0.01,0.02))*4).tanh + LPF.ar(sig, 1200);


	osig = sig;
	sig = AllpassL.ar(sig,0.1,[0.012,0.02,0.014,0.0132] *2,0) + sig;
	sig = AllpassL.ar(sig,0.1,0.001,0) + sig;
	sig = LPF.ar(sig, 3000);
	//sig = BRF.ar(sig, [100,940,1700,4000,9000]*1) / 2;
	sig = sig + osig;
	//sig = osig;
	sig.postln;
	sig = sig * 0.51;


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
