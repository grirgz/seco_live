~name = 'lab1-i';


~pdef_channel.();

(
// nord modular simple bass drum
SynthDef(\nm_complex_bass_drum, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var imp;
	var fbin;
	var fm1amp = 4100.1;
	var fm2amp = 40.01;
	var env1;
	imp = Trig.ar(Impulse.ar(1), 0.001);
	sig1 = imp;
	//sig = RLPF.ar(sig, \lpf.kr(58), \rq.kr(0.1));

	env1 = EnvGen.ar(Env.perc(0.0005,0.185),gate,doneAction:doneAction);
	freq = 49 + (env1-0.5 * 1.4);

	fbin = LocalIn.ar(1);

	sig1 = SinOsc.ar(fbin * fm1amp + 1 * (freq* 0.1771));
	sig2 = LFSaw.ar(sig1 * fm2amp + 1 * (freq* 5.0397));

	sig3 = SinOsc.ar(freq);

	sig4 = Klang.ar(Ref([[1.8598, 1.8877, 2.7208, 5.3057, 3.6400, 4.5041], [ 1, 0.7, 1, 0.7, 0.8, 0.7 ]]), freq) ;

	LocalOut.ar(sig2);

	sig = (sig2*0.13) + sig3 + sig4;
	sig = sig * env1;
	sig = sig + imp;
	sig = sig  * 2;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

SynthDef(\fm_hat, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var imp;
	var fbin;
	var fm1amp = 1100.1;
	var fm2amp = 100.01;
	var env1;
	imp = Trig.ar(Impulse.ar(1), 0.001);
	sig1 = imp;
	//sig = RLPF.ar(sig, \lpf.kr(58), \rq.kr(0.1));

	env1 = EnvGen.ar(Env.perc(0.0005,0.185),gate,doneAction:doneAction);
	freq = 019 + (env1-0.5 * 1.4);

	fbin = LocalIn.ar(1);

	sig1 = SinOsc.ar(fbin * fm1amp + 1 * (freq* 0.1771));
	sig2 = LFSaw.ar(sig1 * fm2amp + 1 * (freq* 5.0397));

	LocalOut.ar(sig2);

	//sig = (sig2*0.13) + sig3 + sig4;
	sig = sig2;
	sig = sig * env1;
	sig = sig + imp;
	sig = sig  * 2;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \nm_complex_bass_drum,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
