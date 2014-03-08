~patfx_gate.(\gpatfx,  Pbind(\finepos, 0))

// END
~patfx_gate.(~name+++\patfx, Pbind(\isRest, false))

(

~mul_release = { arg key, mul=1;
	Pfunc({ arg ev;
		var env = ev[key][0];
		var times;
		env = env.deepCopy;
		env.asCompileString.debug("env1");
		times = env.times;
		times[env.times.size-1] = times[env.times.size-1] * mul;
		env.times = times;
		env.asCompileString.debug("env2");
		[env];
	})
};
~emul_release = { arg key, mul;
	Pbind(
		key, ~mul_release.(key, mul)
	)
};
)
~a = Env([0.0,0.55,0.0],[0.3,0.2])
~a.times[~a.times.size-1] = 4.1
~a.array = nil
~a.asCompileString
~a.times
~mul_release.(\adsr, 0.2)
~a.plot
~a.test
~a
