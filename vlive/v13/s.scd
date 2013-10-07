~name = 's';

SynthDef(~name, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5|
	var env0, env1, env1m, son;
	var envlpf;
	
	env0 =  EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, release], [-4, -2, -4]), doneAction:2);
	env1 = EnvGen.ar(Env.new([110, 59, 29], [0.005, 0.29], [-4, -5]));
	envlpf = EnvGen.ar(Env.new([410, 479, 29], [0.005, 0.29], [-4, -5]));
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, envlpf*fratio, env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);
	
	son = son * 1.2;
	son = son.clip2(1);
	
	OffsetOut.ar(out, Pan2.ar(son * amp));
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

