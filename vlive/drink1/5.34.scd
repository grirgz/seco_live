~patfx_gate.(\modskank, Pbind(
	\degree, [-7,4,7],
	\isRest, Pfunc({ arg ev;
		var beat;
		var time = ev[\time];
		beat = (time*8).round;
		beat = beat % 4;
		//(time*8).debug("time");
		beat.debug("beat");
		beat % 2 == 1;
		

	})
));

// END
~swingamp = ~midi.(\k2, 0, \unipolar.asSpec).valpattern;

(
)

a = List.new
a[14] = 4
~patfx_gate.(\modskank, Pbind(\isRest, (Ptime()*16 % 2) < 1));
