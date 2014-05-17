Pdef(~name +++ \pre, 
	//Sdef(~name, \mypreset).morph(\morph, [0,1,2]) 
	Sdef(~name, \mypreset).pbind
	<> Pbind(
	\fratio, Pseq([1.5,2.3,2.7,2.1,1.8],inf).stutter(1),
	\fratio, 4,
	\release, Pseq([0.1,0.7, 0.5,0.1, 1.1]/2,inf),
	\release, 0.05,
	\rq, 0.9,
));

// END

MIDIBoard.map(\k3, Sdef(~name, \mypreset), \dmix)
MIDIBoard.map(\k4, Sdef(~name, \mypreset), \dmix2)
