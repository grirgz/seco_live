~name = '33';

// a netoyer!!!! (mettre envs dans args)
SynthDef(~name, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, rq=0.5, releaseb=0.06, fratiob=2, dmix=0.5, rqc=0.5, fratioc=2,
					dmix2=0.2, releasec=0.4|
	var env0, env1, env1m, son;
	var env0b, env1b, env1mb, sonb;
	var env0c, env1c, env1mc, sonc;
	
	env0 =  EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.05, 0.06, release], [-4, -2, -4]), doneAction:0);
	env1 = EnvGen.ar(Env.new([80, 19, 70], [0.05, 0.09], [-4, 5]));
	env1m = env1.midicps;

	env0c =  EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.05, 0.06, releasec], [-4, -2, -4]), doneAction:0);
	env1c = EnvGen.ar(Env.new([70, 19, 70], [0.0005, 0.009], [-4, 5]));
	env1mc = env1c.midicps;

	env0b =  EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.05, 0.006, releaseb], [-4, -2, -4]), doneAction:0);
	env1b = EnvGen.ar(Env.new([120, 39, 21], [0.005, 0.29], [4, -5]));
	env1mb = env1b.midicps;
	
	son = WhiteNoise.ar(1);
	son = BPF.ar(son, env1m*fratio, rq);
	son = son * env0;

	sonc = WhiteNoise.ar(1);
	sonc = BPF.ar(sonc, env1mc*fratioc, rqc);
	sonc = sonc * env0c;
	//son = son + SinOsc.ar(env1m, 0.5, env0);

	sonb = LFPulse.ar(env1mb, 0, 0.5, 1, -0.5);
	sonb = sonb + WhiteNoise.ar(1);
	sonb = LPF.ar(sonb, env1mb*fratiob);
	sonb = sonb + SinOsc.ar(env1mb, 0.5);
	sonb = sonb * env0b;
	
	son = SelectX.ar(dmix, [sonc , son]);
	son = SelectX.ar(dmix2, [son , sonb]);
	son = son * 1.2;
	son = son.clip2(1);

	son = son * amp;
	son = Pan2.ar(son, pan);
	DetectSilence.ar(son, doneAction:2);
	
	OffsetOut.ar(out, son);
}).store;


(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\release, 0.4,
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.3 * Pkey(\amp),
	) <> Veco(~name).mixer)
);
