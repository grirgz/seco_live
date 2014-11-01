~name = 'lab1-y';


~pdef_channel.();

(
// nord modular 909 implementation
// modified
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var lfo1, lfo2, lfo3;
	var lfo;

	lfo1 = LFTri.ar(330 * EnvGen.ar(Env([8,1 + Rand(0.0,0.4),1],[0.00001,1.8]), gate) * [1,1.1,1.2]).sum;
	lfo1 = lfo1 * EnvGen.ar(Env.perc(0.0005, 0.0255), gate);
	lfo2 = LFTri.ar(185);
	lfo2 = lfo2 * EnvGen.ar(Env.perc(0.0001, 0.1075), gate);
	lfo3 = LFTri.ar(265 * [1,1.2,1.03,1.14]).sum;
	lfo3 = LPF.ar(lfo3, EnvGen.ar( Env([450,100],[0.051]), gate));
	lfo3 = lfo3 * EnvGen.ar(Env.perc(0.0001, 0.2075), gate);

	sig = WhiteNoise.ar(0.7) + LFNoise1.ar(17000,mul:0.5) + LFNoise1.ar(10000,mul:0.7) + LFNoise1.ar(5000,mul:1);
	sig = LPF.ar(sig, 7040 * [1,1.8,0.2] * EnvGen.kr(Env([1,[0.5+Rand(0.0,0.2),0.1+Rand(0.0,0.2)]],[0.01]), gate)) * [0.4,0.7,1];

	sig1 = sig * EnvGen.ar(Env.perc(0.005, 0.220), gate, doneAction:2);

	sig2 = HPF.ar(sig, 523);
	sig2 = BRF.ar(sig2, [100,200,300,400]+12*2.0).mean;
	sig2 = sig2 * EnvGen.ar(Env.perc(0.005, 0.183), gate);
	sig2 = (sig2*10).tanh;

	lfo =  lfo1 + lfo2 + lfo3;
	lfo = lfo + FreqShift.ar(lfo, -110 + Rand(0.0,30));
	sig = ( sig1 * 0.7 ) + ( sig2 * 0.4 ) + lfo;
	//sig = sig ! 2;
	sig = sig * 4;
	sig.postln;
	sig = Pan2.ar(sig, pan + [-0.1,0.1,0.0], amp).flop;
	//sig = Pan2.ar(sig, pan , amp).flop;
	//sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	//sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

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
