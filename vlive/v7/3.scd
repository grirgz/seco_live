~name = \3;

(
~current_chord = 0;
Pdef(\chords, Pbind(\mtranspose, Pfunc({ ~current_chord })));
Pdef(~name, Pbind(

	\chord, Pdefn(\chord),
	//\chord, Pseq([0,3,1,4],inf),
	\isRest, true,
	\dur, 2,
	\do, Pfunc{ arg ev;
		~current_chord =  ev[\chord];
		~current_chord.debug("curchord");
		1;
	}
))
);
