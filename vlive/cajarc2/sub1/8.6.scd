
Pdef(~name +++ \pre, 

	Pseq([
		Pfindur(3.5, Pbind(
			\freq, Pseg(Pseq([1000,500],inf),4),
			\dur, 1/8,
			\isRest, Pseq([
				1,
			],inf).coin.not,
		)),
		Pbind(
			\freq, Pseq([7000,500,1000,300],inf),
			\dur, 1/16,
			\isRest, Pseq([
				1,
			],inf).coin.not,
		),

	])
	
)

