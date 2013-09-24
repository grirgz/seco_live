~name = '2';

(
SynthDef(~name, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, pwidth=0.5, gate=1|
	var env0, env1, env1m, son, env2;

	env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5]));
	env2 = \env2.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5])).midicps;
	
	env0 =  EnvGen.ar(env0, gate, doneAction:2);
	env1 = EnvGen.ar(env1, gate);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m, 0, pwidth, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = RLPF.ar(son, env1m*fratio, 0.2)* env0;
	son = son + SinOsc.ar(env1m, 0.5, env0);
	//son = son + LFSaw.ar(env2 * \sawtab.kr([1,1.01,1.02]), 0.5, env0).sum;
	son = son + LFSaw.ar(env2, 0.5, env0);
	
	son = son * 1.2;
	son = son.clip2(1);

	son = son * amp;
	son = Pan2.ar(son, pan);
	
	OffsetOut.ar(out, son);
}).store;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\env0, [Env.new([0.2, 1, 0.5, 0], [0.015, 0.06, 00.4], [-4, -2, -4]) ],
	\env1, Pseq([
		[Env.new([052, 19, 34], [0.045, 0.09], [-4, -5]) ],
		[Env.new([050, 19, 14], [0.045, 0.09], [-4, -5]) ],
		[Env.new([039, 29, 14], [0.045, 0.09], [-4, -5]) ],
		[Env.new([039, 39, 24], [0.045, 0.09], [-4, -5]) ],
	],inf).stutter(8),
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\legato, 0.5,
	\fratio, 2,
	\dur, 1/8,
	\amp, 0.4
))
);

// END

Pdef.defaultQuant
