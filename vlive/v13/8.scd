~name = '8';

SynthDef(~name, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, spread=0.8|
	var env0, env1, env1m, son;
	var envlpf, envpulse;
	
	env0 =  EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, release], [-4, -2, -4]), doneAction:2);
	envpulse =  EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.01], [-4, -2, -4]), doneAction:0);
	env1 = EnvGen.ar(Env.new([40, 50, 20], [0.005, 0.71], [-4, -5]));
	envlpf = EnvGen.ar(Env.new([10, 79, 529], [0.005, 0.29], [-4, -5]));
	env1m = env1.midicps;
	
	//son = LFPulse.ar(env1m * [1,1.01,2], 0, 0.5, 1, -0.5);
	son = LFPulse.ar(env1m * Array.series(8,1.0,0.01), 0, 0.5, 1, -0.5) * envpulse;
	son = 0;
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, envlpf*fratio * [1,1.2,1.1], env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);
	
	son = son * 1.7;
	son = son.clip2(1);

	son = Splay.ar(son, spread, amp, pan);
	son = son * amp * 5;
	
	OffsetOut.ar(out, son);
}).add;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	//\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest(16),
	\dur, 1/4,
	\amp, 0.1
))
);

