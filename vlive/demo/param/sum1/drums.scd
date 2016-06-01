

(
SynthDef(\dr_kick, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1|
	var env0, env1, env1m, son;

	//freqpan = [-1,0,1] * freqpan;
	freqpan = [1,0,-1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([110, 32, 29], [0.105, 0.29], [-4, -5]));
	
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
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
	env0: XEnvSpec(\amp!4, ControlSpec(0,5,\lin)),
	env1: XEnvSpec(\midinote!3, ControlSpec(0,5,\lin)),
))).add;

)
XEnvSpec(\amp!4, ControlSpec(0,5,\lin));
"~/code/sc/seco/vlive/cuspn/zdrumkit.scd".standardizePath.load
