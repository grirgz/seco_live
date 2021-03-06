~name = '1';

(
SynthDef(~name, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, pwidth=0.5, gate=1|
	var env0, env1, env1m, son;

	env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, gate, doneAction:2);
	env1 = EnvGen.ar(env1, gate);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m, 0, pwidth, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio, env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);
	
	son = son * 1.2;
	son = son.clip2(1);

	son = son * amp;
	son = Pan2.ar(son, pan);
	
	OffsetOut.ar(out, son);
}, metadata:(specs:(
	env0: \env -> [4, ControlSpec(0.001,8,\exp, 0, 1), nil, nil, Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2])],
	env1: \env -> [3, ControlSpec(5,128,\lin, 0, 50), nil, nil, Env.new([210, 29, 59], [0.105, 0.29], [-4, -5])],
))).add;
);

Sdef(~name, \mypreset, \preset, ~name);

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
	\amp, 0.4 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END

Pdef.defaultQuant

Sdef(\bla, \myaudio, \audio)

(
	
	"~/seco/seco/veco/sdef.scd".standardizePath.load;
Sdef(\1, \mypreset, \preset, \default);
Sdef(\1, \mypreset).get(0).edit;
)
