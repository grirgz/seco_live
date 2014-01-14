Pdef(~name +++ \pre, 
	Pbind(
		\instrument, ~name,
		\degree, Pseq([0],inf),
		\shift, Pseq([100,0,50,100,-200],inf) + Pkey(\shift),
		\legato, Pseq([0.1,3,0.7,1,0.5,2],inf),
		\freqfactor, Pseq([1,1.1,0.42],inf) * Pkey(\freqfactor),
	)
	<> Sdef(~name, \mypreset).get_active_score.valpbind 
);

// END

Sdef(~name, \mypreset)
Sdef(~name, \mypreset).get_active_score
MIDIBoard.map(\k5, Sdef(~name, \mypreset), \decay);
MIDIBoard.map(\k6, Sdef(~name, \mypreset), \freqfactor);
//MIDIBoard.map(\k7, Sdef(~name, \mypreset), \freqfactor);
