~name = 'alpha_perc1-3';

~pdef_channel.();

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	
	var bufnum = \bufnum.kr(0);
	var speed = \speed.kr(1);
	var trigger = Impulse.kr(\reprate.kr(1*~t));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: ( \pos.kr(0)*BufFrames.kr(bufnum)), doneAction:doneAction, loop: \loop.kr(1));

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name+++\comp, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	
	var bufnum = \bufnum.kr(0);
	var speed = \speed.kr(1);
	var trigger = Impulse.kr(\reprate.kr(1*~t));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: ( \pos.kr(0)*BufFrames.kr(bufnum)), doneAction:doneAction, loop: \loop.kr(1));

	//sig = Limiter.ar(sig,0.3);

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	sig = CompanderD.ar(sig,0.3,1,0.3);
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
