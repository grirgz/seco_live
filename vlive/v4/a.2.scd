
Pdef(~name +++ \pre, Pbind(

	\freq, Pkey(\freq) * Pseq([1,2],inf),
));

// END

(
Pbind(

	//\degree,		Pn(Pseq((0..7)), inf, \step),
	\step, Pseq([true,false],inf),
	\mtranspose,	Pgate(Pwhite(0,5), inf, \step),
	\dur, 0.2
).play
)


