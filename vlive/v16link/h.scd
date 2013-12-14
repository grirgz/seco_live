~name = 'h';

SynthDef(~name, { |out=0, amp=0.1, pan=0, release=0.46, fratio=2.5, dist=17.7, spread=0.1|
	var env0, env1, env1m, son;
	var envlpf, env2m;
	var envlpf2;
	var son1, son2;
	
	env0 =  EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, release], [-4, -2, -4]), doneAction:2);

	env1 = EnvGen.ar(Env.new([120, 109, 19,0], [0.005, 0.19,0.5], [-4, -5]));
	env1m = env1.midicps;
	env2m = EnvGen.ar(Env.new([110, 109, 19,0], [0.005, 0.19,0.5], [-4, -5])).midicps;

	envlpf = EnvGen.ar(Env.new([4100, 779, 29], [0.005, 0.29], [-4, -5]));
	envlpf2 = EnvGen.ar(Env.new([4100, 179, 29], [0.405, 0.29], [-4, -5]));
	
	son = LFPulse.ar(env1m * SinOsc.ar(800+(200*Rand(-1,1))).range(0.4,1), 0, 0.5, 1, -0.5);
	//son = LFPulse.ar(env1m, 0, 0.5, 1, -0.5);
	//son = DC.ar(0);
	son = LPF.ar(son, envlpf*fratio, env0);
	son1 = son + WhiteNoise.ar(1);
	son1 = LPF.ar(son1, envlpf2*fratio, env0);
	son = son + son1;
	son = HPF.ar(son, 30 * [1,0.71,4.301,0.1,8,1] * 1);
	son = son * 0.8;
	//son = son + SinOsc.ar(env2m, 0.5);
	//son = (son*dist).tanh / dist * 4;
	
	son = son * 1.2;
	son = son.clip2(1);
	son = son * env0;
	son = Splay.ar(son, spread, amp, pan);
	OffsetOut.ar(out, son);
}).add;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	//\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest(32),
	\dur, 1/8,
	\amp, 0.1 * Pkey(\amp),
	) <> Veco(~name).mixer)
);

// END

Veco.force_init
