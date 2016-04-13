~name = 'toucan2-1';



(
SynthDef(~name, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1|
	var env0, env1, env1m, son;
	var son1, son2, son3, son4;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sig;
	var env2, env3, env4;
	var distlim = 1;

	//freqpan = [-1,0,1] * freqpan;
	freqpan = 1 + ([1,0,-1] * freqpan);
	env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
	
	son1 = LFSaw.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son2 = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son3 = SinOsc.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = SelectX.ar(\oscmix.kr(0.5)*2, [son1, son2, son3]);
	son = son + WhiteNoise.ar(1);
	env2 = \env2.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5]));
	//env3 = EnvGen.ar(\env3.kr(Env.new([0, 1, 0.5, 0], [0.105, 0.16, 00.41], [-4, -2, -4])),timeScale:timeScale,doneAction:2);
	env3 = EnvGen.ar(\env3.kr(Env([0, 1, 0.5, 0], [0.105, 0.016, 00.011], [-4, -2, -4])),timeScale:timeScale,doneAction:0);
	son = LPF.ar(son, env1m*fratio) * env3;

	son1 = LFSaw.ar(env1m);
	son1 = RLPF.ar(son1, env1m * \fratio1.kr(1));
	son2 = LFPulse.ar(env1m);
	son2 = RLPF.ar(son2, env1m * \fratio2.kr(1));
	son3 = SinOsc.ar(env1m,0.5);
	sig1 = SelectX.ar(\osc2mix.kr(0.999)*2, [son1, son2, son3]);
	sig1 = sig1 * env0;
	son = son + sig1;
	
	son = son * \distamp.kr(1.2);
	sig = son;
	distlim = \distlim.kr(0.1);
	sig1 = sig.clip2(distlim);
	sig2 = sig.distort(distlim);
	sig3 = sig.tanh(distlim);
	sig4 = sig.wrap2(distlim);
	sig5 = sig.fold2(distlim);
	sig = SelectX.ar(\distmix.kr(0.5)*4, [sig1, sig2, sig3, sig4, sig5]);

	son = sig / 2;

	son = son * amp;
	son = Splay.ar(son, spread, amp, pan);
	
	OffsetOut.ar(out, son);
}).add;
);

(
SynthDef(~name+++\mix, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1|
	var env0, env1, env1m, son;
	var son1, son2, son3, son4;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sig;
	var env2;

	//freqpan = [-1,0,1] * freqpan;
	freqpan = 1 + ([1,0,-1] * freqpan);
	env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
	
	son1 = LFSaw.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son2 = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son3 = SinOsc.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = SelectX.ar(\oscmix.kr(0.5)*2, [son1, son2, son3]);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio, env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);
	
	son = son * 1.2;
	sig = son;
	sig1 = sig.clip2(1);
	sig2 = sig.distort(1);
	sig3 = sig.tanh(1);
	sig = SelectX.ar(\distmix.kr(0.5)*2, [sig1, sig2, sig3]);

	son = sig;

	son = son * amp;
	son = Splay.ar(son, spread, amp, pan);
	
	OffsetOut.ar(out, son);
}).store;
);



~pdef_channel.();

Pdef(~name+++\macro, Pbind());

(
	~pdef_init.(
		Pbind(
			\instrument, ~name,
			\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.1], [-4, -2, -4]) ],
			\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
			\degree, Pseq([0],inf),
			\isRest, Veco(~name).isrest,
			\fratio, 2,
			\dur, 1/8,
			\amp, 0.4 * Pkey(\amp),
		)
	)
)

// END

Veco(~name).mixer.asStream.next(Event.default)

~set_macro.(\k1, Pdef(~name+++\macro), \fratio1, ControlSpec(0.1,5,\lin,0,1))

~fx1
