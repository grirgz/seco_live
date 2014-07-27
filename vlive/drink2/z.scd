~name = 'drink2-z';

BufDef(\moeten, "voices/02_moeten.flac");
BufDef(\woodshop, "vipere/woodshop.flac");

SynthDef(~name+++\snare, { |out=0, amp=0.1, pan=0, fratio=1.5, rq=0.5, fratiob=2, dmix=0.5, rqc=0.5, fratioc=2,
					dmix2=0.2, pwidth=0.5, driveamp=0.2, distmix=0.5, drive=2, cliplevel=1,
					doneAction=2, doneActiona=0, doneActionb=0, doneActionc=0,
					modamp=1, timeScale=1|
	var env0, env1, env1m, son;
	var env0b, env1b, env1mb, sonb;
	var env0c, env1c, env1mc, sonc;
	var sondist;
	
	env0 =  EnvGen.ar(\env0.kr(Env.new([0.5, 1, 0.5, 0], [0.05, 0.06, 0.1], [-4, -2, -4])), timeScale: timeScale, doneAction:doneActiona);
	env1 = EnvGen.ar(\env1.kr(Env.new([80, 19, 70], [0.05, 0.09], [-4, 5])), timeScale: timeScale);
	env1m = env1.midicps;

	env0b =  EnvGen.ar(\env0b.kr(Env.new([0.5, 1, 0.5, 0], [0.05, 0.006, 0.1], [-4, -2, -4])), timeScale: timeScale, doneAction:doneActionc);
	env1b = EnvGen.ar(\env1b.kr(Env.new([120, 39, 21], [0.005, 0.29], [4, -5])), timeScale: timeScale);
	env1mb = env1b.midicps;
	
	son = WhiteNoise.ar(1);
	son = BPF.ar(son, env1m*fratio, rq);
	son = son * env0;

	sonb = LFPulse.ar(env1mb, 0, pwidth, 1, -0.5);
	sonb = sonb + WhiteNoise.ar(1);
	sonb = LPF.ar(sonb, env1mb*fratiob);
	sonb = sonb + SinOsc.ar(env1mb, 0.5);
	sonb = sonb * env0b;
	
	son = SelectX.ar(dmix, [son , sonb]);

	sondist = son * drive;
	sondist = sondist.clip2(cliplevel);
	sondist = sondist * driveamp;
	son = SelectX.ar(distmix, [son , sondist]);

	DetectSilence.ar(son, amp:0.1, time:0.1, doneAction:2);
	son = son * amp;
	son = son * modamp;
	son = Pan2.ar(son, pan);
	
	//OffsetOut.ar(out, son);
	Out.ar(out, son);
}, metadata:(specs:(
	env0: \env -> [4, ControlSpec(0.001,8,\exp, 0, 1), nil, nil, Env.new([0.5, 1, 0.5, 0], [0.05, 0.06, 0.1], [-4, -2, -4])],
	env1: \env -> [3, ControlSpec(5,128,\lin, 0, 50), nil, nil, Env.new([80, 19, 70], [0.05, 0.09], [-4, 5])],
	env0b: \env -> [4, ControlSpec(0.001,8,\exp, 0, 1), nil, nil, Env.new([0.5, 1, 0.5, 0], [0.05, 0.06, 0.1], [-4, -2, -4])],
	env1b: \env -> [3, ControlSpec(5,128,\lin, 0, 50), nil, nil, Env.new([80, 19, 70], [0.05, 0.09], [-4, 5])],
	distmix: \unipolar.asSpec,
	dmix: \unipolar.asSpec,
	cliplevel: \wideamp.asSpec,
	driveamp: \wideamp.asSpec,
	pwidth: \unipolar.asSpec,
	modamp: \amp.asSpec,

))).add;

SynthDef(~name+++\kick, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1|
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


Veco(~name).make_mixer;


(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, 
	
	~patfx.(~name+++\patfx) <>
	Pdef(~name +++ \pre) <> Pbind(
	\instrument, \oscsampler,
	\bufnum, BufDef(\moeten),
	\bufnum, BufDef(\woodshop),
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/8,
	\amp, 0.21 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END

