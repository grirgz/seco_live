~name = 'stone11-a';

(
SynthDef(~name, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5|
	var env0, env1, env1m, son;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freqlim = 100;
	var clipmix;

	env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2);
	env1 = EnvGen.ar(env1);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio);
	son = son + SinOsc.ar(env1m, 0.5);
	
	freqlim = 180;
	freqlim = (1..10)*( \xfreqlim.kr(1) )+\afreqlim.kr(50);
	sig1 = HPF.ar(son, freqlim);
	sig2 = LPF.ar(son, freqlim);
	clipmix = \clipmix.kr(5);
	sig3 = SelectX.ar(clipmix, [sig1, sig2]);
	sig4 = SelectX.ar(1-clipmix, [sig1, sig2]);
	sig3 = sig3 * 100.2;
	sig3 = sig3.clip2(1);
	son = sig3 + sig4;
	son = son/son.size/2;
	son = son * \precompamp.kr(1);

	son = Compander.ar(son, son, \compthresh.kr(0.4), \compbelow.kr(1),\compabove.kr(07), \compclamp.kr(0.01), \comprelax.kr(0.1));
	son = son * \postamp.kr(7);
	son = LPF.ar(son, \lpfreq.ar(400));

	son = son * env0;
	son = son * amp;
	//son = Pan2.ar(son, pan).flop;
	son = Splay.ar(son, 0.1, 1, pan);
	
	OffsetOut.ar(out, son);
}).add;
);


~pdef_channel.();

(
~pdef_init.(Pbind(
	\instrument, ~name,
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.1], [-4, -2, -4]) ],
	\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\fratio, 2,
	\dur, 1/8,
	\amp, Pkey(\amp) * 1/8,
))
);

~set_macro.(\k1, Pdef(~name+++\macro), \lpfreq, \freq);
~set_macro.(\k2, Pdef(~name+++\macro), \xfreqlim, ControlSpec(0,2,\lin,0,1));
~set_macro.(\k3, Pdef(~name+++\macro), \afreqlim, ControlSpec(0,200,\lin,0,1));
~set_macro.(\k4, Pdef(~name+++\macro), \compthresh, ControlSpec(0.0001,2,\exp,0,1));
~set_macro.(\k5, Pdef(~name+++\macro), \compbelow, ControlSpec(0.001,2,\exp,0,1));
~set_macro.(\k6, Pdef(~name+++\macro), \compabove, ControlSpec(0.001,2,\exp,0,1));
~set_macro.(\k7, Pdef(~name+++\macro), \precompamp, ControlSpec(0.1,422,\exp,0,1));
~set_macro.(\k8, Pdef(~name+++\macro), \clipmix, \unipolar);

(
Veco.do { arg name;
	MIDIBoard.map(\play, {
		Veco(name).lib.macros.keep(8).do { arg ma, x; MIDIBoard.map(\s+++(x+1), *ma) }
	})
};
);

// END

