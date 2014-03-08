~patfx_gate.(~name+++\patfx, Pbind(
	//\reprate, Pseq([10,20,30,40],inf),
	\isRest, Pseq([~pkey1.(\isRest),false],inf),
));
currentEnvironment[~name+++\patfxquant] = 1/2;

// END

~a = Pseq((1..16),inf)
~s = ~a.asStream;
~s.next

~xs = Pseq([200, ~s]).asStream
~xs.next

~xtrue = Pfuncn({ arg ev;
	ev[\isRest].not;
	if(ev[\isRest] == false) {
		false
	} {
		true
	}
}, 1)
~pkey1 = { arg key, repeat=1;
	Pfuncn({ arg ev; ev[key] },repeat)
};
