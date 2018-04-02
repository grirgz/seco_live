~bus = Bus.audio(s,2);

(
~name = \kickfb;

SynthDef(~name, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1|
	var env0, env1, env1m, son;

	//freqpan = [-1,0,1] * freqpan;
	freqpan = [1,0,-1] * freqpan;
	env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio, env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);
	
	son = son * 1.2;
	son = son.clip2(1);

	son = son * amp;
	son = Splay.ar(son, spread, amp, pan);
	
	OffsetOut.ar(out, son);
}).add;
);

(

Pdef(~name, Pbind(
	\instrument, ~name,
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
	\env1, [ Env.new([110, 53, 29], [0.015, 0.29], [-4, -5]) ],
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\spread, 0.1,
	\dur, 1/4,
	\out, ~bus,
	\amp, 0.51,
	\isRest, Pseq([1,0,1,0, 0,0,0,0],inf).coin.not,
)).play;

Ndef(~name+++\fx, {
	var in = InFeedback.ar(~bus,2);
	var sig = in;

	sig = Fb({ arg fb;
		var del;
		var freqshift;
		fb = sig + (fb * 0.97 * \fb.kr(1));
		freqshift = \freqshift.kr(1);
		freqshift = Duty.ar(1/4, 0, Dseq([10,0,-20,0]*freqshift,inf) + Dstutter(8,Dseq([0,-50,0,50],inf)));
		fb = fb + FreqShift.ar(fb, (0-[1,2,3,4,5,6,7,8,9].clump(2).scramble*freqshift)).sum/6;
		fb;

	},\delay.kr(0.1));
	sig.postln;
	sig = Normalizer.ar(sig, 0.99,0.01);
	sig = sig * \gain.kr(1);
	sig = sig / 8;
	
	sig;
}).play;
Ndef(~name+++\fx).quant=2;
);

Ndef(~name+++\fx).edit
Ndef(~name+++\fx).end
Ndef(~name+++\fx).play
Ndef(~name+++\fx).set(\fb, 1, \delay, 0.1, \freqshift, 1)
Ndef(~name+++\fx).set(\fb, 1.05, \delay, 1/16, \freqshift, 1)



