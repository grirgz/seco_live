~name = '7';

(
SynthDef(~name, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, pwidth=0.5, gate=1, sawamp=0.3, mixclip=0.5, rq=0.2|
	var env0, env1, env1m, son, env2, env3;
	var son2, son3;

	env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5]));
	env2 = \env2.kr(Env.new([24, 12, 49], [0.015, 0.29], [-4, -5]));
	env3 = \env3.kr(Env.new([24, 12, 49], [0.015, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, gate, doneAction:2);
	env1 = EnvGen.ar(env1);
	env1m = env1.midicps;
	env2 = EnvGen.ar(env2, gate).midicps;
	env3 = EnvGen.ar(env3, gate).midicps;
	
	son = LFPulse.ar(env1m, 0, pwidth, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio);
	son2 = (LFSaw.ar(env2 * \sawtab.kr([1,1.01,1.02,0.5]/3), 0.5).sum * sawamp);
	son2 = RLPF.ar(son2, env3*fratio, rq);
	son2.postln;
	son = son + SinOsc.ar(env1m, 0.5);
	son = son + son2;
	//son = son + LFSaw.ar(env2, 0.5) * env0 /4;
	

	son = son * 1.2;
	son = SelectX.ar(mixclip, [son, son.clip2(1)]);

	son = son * env0;
	son = son * amp;
	son = Pan2.ar(son, pan);
	
	OffsetOut.ar(out, son);
}).store;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\env0, [Env.new([0.0, 1, 0.5, 0], [0.115, 0.06, 00.1], [-4, -2, -4]) ],
	\env2, [Env.new([20, 10, 0.5, 0], [0.015, 0.06, 00.1], [-4, -2, -4]) ],
	\env3, [Env.new([20, 10, 0.5, 0], [0.015, 0.06, 00.1], [-4, -2, -4]) ],
	\sawtab, [ [1,0.5,1.25,2] ],
	\env1, Pseq([
		[Env.new([052, 19, 34], [0.045, 0.09], [-4, -5]) ],
		[Env.new([050, 19, 14], [0.045, 0.09], [-4, -5]) ],
		[Env.new([039, 29, 14], [0.045, 0.09], [-4, -5]) ],
		[Env.new([039, 39, 24], [0.045, 0.09], [-4, -5]) ],
	],inf).stutter(8),
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest(16),
	\legato, 0.5,
	\fratio, 2,
	\dur, 1/8,
	\amp, 0.4 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END

Pdef.defaultQuant
