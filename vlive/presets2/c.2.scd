Ndef(~name+++\lfo1, { SinOsc.kr(0.01).range(0.95,1)  });

Pdef(~name +++ \pre, 
	Pbind(

		\mbufnum, BufDef.mono(\ukraine),
		\dur, 1/8,
		//\pitch_stretch, Ndef(~name+++\lfo1),
		\pitch_stretch, 1.0,
		\pitch_stretch, Pseq([
			1.0,2,0.8,0.7,
			2.0,1,0.8,0.4,
		],inf).stutter(4),
		\pitch_stretch, Pseg(Pseq([0.1,4],inf),16),
		//\pos, ~midi.(\k1, nil, ControlSpec(0,0.1,'lin',0,0)).vpattern + 0.3,
		\legato, 0.2,
		\amp, Pkey(\amp) * 2,
		\ffreq, 1000,

		//\adsr, [
		//	Env([ 0.0, 1.0, 0.91, 0.0  ], [ 0.049744102190097, 0.1, 0.064992792344599  ], -4.0, 2)

		//],
		//\adsr, Pfunc({ arg ev;
		//	//var env = [
		//	//	Env([ 0.0, 1.0, 0.91, 0.0  ], [ 0.049744102190097, 0.1, 0.64992792344599  ], -4.0, 2)
		//	//];
		//	var mul = 0.7;
		//	var key = \adsr;
		//	var env = ev[key][0];
		//	env = env.deepCopy;
		//	env.asCompileString.debug("env1");
		//	env.times[env.times.size-1] = env.times[env.times.size-1] * mul;
		//	env.asCompileString.debug("env2");
		//	[env];
		//}),	
		//\adsr, Pfunc({
		//	var env = [
		//		Env([ 0.0, 1.0, 0.91, 0.0  ], [ 0.049744102190097, 0.1, 0.64992792344599  ], -4.0, 2)
		//	];
		//}),	
		//\adsr, ~mul_release.(\adsr, 0.5),
	) <>
	
	Sdef(~name, \mypreset).pbind <> 
	Pbind(
		\time_stretch, 0,
		\freq, 100,
		\pos, Pseq([0.1,0.12,0.3,0.2],inf) + Pwhite(0,0.01),
		\pos, Pseq([
			0.3,0.21,
			0.4,0.31,
		],inf) + Pwhite(0,0.007),
		\pos, 0.3,
	)
)

// END

Sdef(~name, \mypreset).pbind.asStream.next(Event.default);
