
//~pharma = Pbind(\isRest, Pgate(Pseq([false],1), \bla, ~rah))
~patfx_gate.(\modsnare, Pbind(
	\fratio, 
		Pseq([
			Pfuncn({ arg ev; ev[\fratio] },1),
			6
		],inf),
	\isRest, 
		Pseq([
			Pfuncn({ arg ev; ev[\isRest] },1),
			false
		],inf)
	)
);

// END
