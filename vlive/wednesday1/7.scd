~name = '7';

Veco(~name).make_mixer;

(
SynthDef(~name, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, spread=0.1|
	var env0, env1, env1m, son;
	var son2;

	env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.4], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2);
	env1 = EnvGen.ar(env1);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio, env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);
	
	//son2 = HPF.ar(son, [3000,200,2000]*SinOsc.kr(1/2).range(0.03,2));
	son2 = HPF.ar(son, 300);
	son2 = son2 * 5.2;
	son2 = son2.clip2(1) * 4.8;
	son = son + son2;

	son = son * amp;
	son = Splay.ar(son, spread, amp, pan);
	
	Out.ar(out, son);
}).store;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.1], [-4, -2, -4]) ],
	\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\fratio, 2,
	\dur, 1/8,
	\amp, 0.4 * Pkey(\amp),
) <> Veco(~name).mixer)
);

