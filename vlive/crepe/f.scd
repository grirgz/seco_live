~name = 'f';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=4000, rq=0.3;
	var sig, sig1, sig2, sig3;
	var gate2;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	//sig = SinOsc.ar(freq * Array.series(1,1,0.15));
	sig = LFSaw.ar(freq * Array.series(1,1,0.01));
	//ffreq = CuspN.ar([1,8,16]/8, [1,0,0.5]) + 1 * ffreq;
	ffreq = SinOsc.ar(\fmodtab.kr([1/4,1,8,1/6])) + 1 * ffreq;
	sig = RLPF.ar(sig, ffreq, rq);
	//sig = DelayC.ar(sig, 0.1,0.1) + sig;
	//gate = DelayC.ar(gate, 0.1,0.1*SinOsc.kr(1).range(0,1)) + gate;
	sig = sig * EnvGen.ar(\adsr.kr(Env.dadsr(0.1,0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = DelayC.ar(sig, 0.1,
		0.001*SinOsc.ar(freq).range(0,1)
		* SinOsc.ar(freq/32).range(0,4)
	) + sig;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

Veco(~name).make_mixer;

BufDef(\moeten, "voices/02_moeten.flac");
BufDef(\woodshop, "vipere/woodshop.flac");
BufDef(\march, "vipere/march.flac");

Sdef(~name, \mypreset, \preset, \oscsampler);
Veco(~name).make_mixer;


(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	//\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);
