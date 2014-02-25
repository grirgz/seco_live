
Pdef(~name +++ \pre, 
	Pbind(

		\mbufnum, BufDef.mono(\ukraine),
		\dur, 16,
		\legato, 0.8,
	) <>
	
	Sdef(~name, \mypreset).pbind <> 
	Pbind(
		\freq, 100,
	)
)

// END

Sdef(~name, \mypreset).pbind.asStream.next(Event.default);
