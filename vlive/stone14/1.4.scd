

~patfx_gate.(~name+++\patfx, Pbind(
	//\timeScale, Pseq([1],inf),
	\fratio1, Pfunc({ arg ev;
		Pdef(~name+++\macro).get(\fratio1)
	}),

))
