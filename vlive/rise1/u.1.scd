
Pdef(~name +++ \pre, 
	Pbind(

		\mbufnum, BufDef.mono(\ukraine),
		\dur, 16,
		\legato, 1.0,
	) <>
	
	Sdef(~name, \mypreset).pbind <> 
	Pbind(
		\freq, 100,
	)
)

// END

785*2
Sdef(~name, \mypreset).pbind.asStream.next(Event.default);
