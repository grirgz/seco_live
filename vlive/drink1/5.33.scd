~patfx_gate.(\modskank, Pbind(
	//\degree, [-7,0,2],
	//\legato, 4.5,
	//\sustain, 0.08,
	\ffreq, Prand([5000,7000],inf),
));

// END
~swingamp = ~midi.(\k2, 0, \unipolar.asSpec).valpattern;

(
)

a = List.new
a[14] = 4
~patfx_gate.(\modskank, Pbind(\isRest, (Ptime()*16 % 2) < 1));
Veco.force_init
