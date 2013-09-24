~name = \37;

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, frange=0.8;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq+LFNoise1.kr(4,freq*frange));
	//sig = CombL.ar(sig, 1,0.1,4)+sig;
	//sig.poll;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

~newfx.(\fx);

(
Ndef(~name+++\fx).isource_({
	var sig, sig2;
	sig = InFeedback.ar(BusDef(~name+++\fx), 2);
	sig2 = sig;
	//sig = CombL.ar(sig, 1,0.1,4)+sig;
	4.do {
		sig = CombL.ar(sig, 1,[0.01,0.012]+LFNoise1.kr(1).range(0.1,1.0),LFNoise1.kr(1).range(0.1,0.2)+[0.1,0.2])+sig;
		sig = sig + FreqShift.ar(sig, LFNoise1.kr(1).range(-200,200));
		sig = sig;
	};
	sig = sig;
	//sig = sig2;
	sig.postln;
	sig;
});
Ndef(~name+++\fx_i).isource_(Ndef(~name+++\fx).source);
);
Ndef(~name+++\fx).fadeTime = 4;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1,
	\out, BusDef(~name+++\fx),
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);


// END

Ndef(~name+++\fx).awake = false;
Ndef(~name+++\fx).release
Ndef(~name+++\fx).fadeTime
Ndef(~name+++\fx).play
Ndef(~name+++\fx).wakeUp
Ndef(~name+++\fx).send
Ndef(~name+++\fx).isPlaying

BusDef(~name+++\fx, \audio)
Ndef(~name+++\fx).fadeTime = 0;
NodeProxy.defaultQuant


// init

(
Ndef(~name+++\fx).prime({
	var sig, sig2;
	sig = InFeedback.ar(BusDef(~name+++\fx), 2);
	sig2 = sig;
	//sig = CombL.ar(sig, 1,0.1,4)+sig;
	4.do {
		sig = CombL.ar(sig, 1,[0.01,0.012]+LFNoise1.kr(1).range(0.1,1.0),LFNoise1.kr(1).range(0.1,0.2)+[0.1,0.2])+sig;
		sig = sig + FreqShift.ar(sig, LFNoise1.kr(1).range(-200,200));
		sig = sig;
	};
	sig = sig;
	//sig = sig2;
	sig.postln;
	sig;
});
);

// start

(
Pdef(~name).play;
Ndef(~name+++\fx).play;
)

// stop

(
Pdef(~name).stop;
Ndef(~name+++\fx).end(3); //
)

(
Pdef(~name).stop;
Ndef(~name+++\fx).stop; // synth keep running silently
)

// ---------------------------

(
Ndef(~name+++\fx).prime({
	var sig, sig2;
	sig = InFeedback.ar(BusDef(~name+++\fx), 2);
	sig2 = sig;
	//sig = CombL.ar(sig, 1,0.1,4)+sig;
	4.do {
		sig = CombL.ar(sig, 1,[0.01,0.012]+LFNoise1.kr(1).range(0.1,1.0),LFNoise1.kr(1).range(0.1,0.2)+[0.1,0.2])+sig;
		sig = sig + FreqShift.ar(sig, LFNoise1.kr(1).range(-200,200));
		sig = sig;
	};
	sig = sig;
	//sig = sig2;
	sig.postln;
	sig;
});
Ndef(~name+++\fx_i).prime(Ndef(~name+++\fx).source);
);
Ndef(~name+++\fx).fadeTime = 4;





(
Ndef(~name+++\fx,{
	var sig, sig2;
	sig = InFeedback.ar(BusDef(~name+++\fx), 2);
	sig2 = sig;
	//sig = CombL.ar(sig, 1,0.1,4)+sig;
	4.do {
		sig = CombL.ar(sig, 1,[0.01,0.012]+LFNoise1.kr(1).range(0.1,1.0),LFNoise1.kr(1).range(0.1,0.2)+[0.1,0.2])+sig;
		sig = sig + FreqShift.ar(sig, LFNoise1.kr(1).range(-200,200));
		sig = sig;
	};
	sig = sig;
	//sig = sig2;
	sig.postln;
	sig;
});
//Ndef(~name+++\fx_i).prime(Ndef(~name+++\fx).source);
);
Ndef(~name+++\fx).fadeTime = 4;
