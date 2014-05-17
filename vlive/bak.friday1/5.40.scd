
//~patfx_gate.(~name+++\patfx, Pbind(\isRest, Pseq([false,Pser([true],7)],inf), \legato, 7));

~patfx_gate.(~name+++\patfx, Pbind(\isRest, 
	Pfunc({ arg ev;
		if(ev[\time].debug("time") % 1 == 0) {
			false
		} {
			true
		};

	}),
	//Pseq([false,Pser([true],7)],inf), \legato, 7
	\legato, 8,
));
