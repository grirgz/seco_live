~name = 'lab1-q';


~pdef_channel.();

(
// nord modular bell (5.5)
SynthDef(\nm_bell, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var imp;
	var fbin;
	var fm1amp = 4100.1;
	var fm2amp = 40.01;
	var env1;
	var lfo1, lfo2;

	env1 = EnvGen.kr(Env.adsr(0.0066,0.520,0.5,1.2), gate, doneAction:doneAction);

	freq = 987.8;
	freq = 200 + Rand(0.0,10);

	lfo1 = LFTri.kr(0.397, Rand(0,1));
	lfo2 = LFTri.kr(1/4, Rand(0,1));

	sig4 = DynKlang.ar(Ref([[1, 1.0595, 1.3366, 2.3784, 3.1491, 4.2169], [ 0.8, 0.8 * lfo2, 0.8 * lfo1, 0.8, 0.8, 0.9 ]]), freq) ;


	sig = sig4;
	sig = sig * env1;
	sig = sig  * 2;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);


(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \nm_bell,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
