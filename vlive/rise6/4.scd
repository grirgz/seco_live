~name = '4';

Veco(~name).make_mixer;

(
SynthDef(~name, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, cuspfreq=1000, hpfreq=200, timeScale=1, spread=0.8, freq=100, lpfreq=1000|
	var env0, env1, env1m, son;
	var son2;

	env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5]));
	env0 = Env.new([0.0, 1, 0.5, 0], [0.155, 0.26, 00.12], [-4, -2, -4]);
	//env1 = Env.new([030, 44, 19], [0.105, 0.09], [-4, -5]);
	env1 = freq;
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	//env1 = EnvGen.ar(env1, timeScale:timeScale).midicps;
	hpfreq = 1000;
	
	son = LFPulse.ar(env1, 0, 0.5, 1, -0.5);
	son = son + LFPulse.ar(env1 * \freqtab.kr(Array.series(8,0.8,0.072)), 0, 0.5, 1, -0.5);
	//son = son * 10;
	son = BMoog.ar(son, lpfreq, 0.02, saturation:0.15);

	
	son2 = son;
	son2 = HPF.ar(son2, hpfreq* [0.99, 1, 1.01]);
	son2 = son2 * 100.2;
	son2 = son2.clip2(1);
	son = son + son2 /2;


	son = son * env0;
	//son = Pan2.ar(son, pan);
	son = Splay.ar(son, spread, amp, pan);
	
	//out.poll;
	OffsetOut.ar(out, son);
}).store;
);

(
SynthDef(~name+++\2, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, cuspfreq=1000, fratiolpf=0.1, lpfmix=0.8|
	var env0, env1, env1m, son;
	var son2;

	env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2);
	env1 = EnvGen.ar(env1);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m, 0, 0.5, 1, -0.5);
	son = son + CuspN.ar(cuspfreq);
	son = SelectX.ar(lpfmix, [son, LPF.ar(son, env1m*fratiolpf)]);
	son = HPF.ar(son, env1m*fratio);
	son = son + SinOsc.ar(env1m, 0.5);
	
	son2 = son;
	son2 = HPF.ar(son2, 200);
	son2 = son2 * 7.2;
	son2 = son2.clip2(1);
	son = son + son2 /2;


	son = son * env0;
	son = son * amp;
	son = Pan2.ar(son, pan);
	
	OffsetOut.ar(out, son);
}).store;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, (
	
	~dPdef.(~name+++\mod) <> 
	Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.1], [-4, -2, -4]) ],
	\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\fratio, 2,
	\dur, 1/8,
	\amp, 0.4 * Pkey(\amp),
) <> Veco(~name).mixer))
);

