Pdef(~name +++ \pre, 
	//~morphpat.(Sdef(~name, \mypreset).getsub(0).pbind, Sdef(~name, \mypreset).getsub(1).pbind, Pseq(Array.series(8,0,1/8),inf))
	~morph.(\morph, 0.5, Sdef(~name, \mypreset).getsub(1).pbind <> Pbind(\amp, 0.1))
	//~morphpat.(Sdef(~name, \mypreset).getsub(0).pbind, Sdef(~name, \mypreset).getsub(1).pbind, 0)
	<> Pbind(
		\freq, 100,
		\legato, 1,
));

// END

Sdef(~namex, \mypreset).edit;
Sdef(~name, \mypreset).rebuild
Sdef(~name, \mypreset).pbind.asStream.next(Event.default)

(
Pdef(~name +++ \pre, Sdef(~name, \mypreset).getsub(0).pbind <> Pbind(
	\freq, 100,
		\legato, 1,
));
)

(
Pdef(~name +++ \pre, Sdef(~name, \mypreset).getsub(1).pbind <> Pbind(
	\freq, 100,
		\legato, 1,
));
)
