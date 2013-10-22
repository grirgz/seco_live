(
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([700,500,300],inf),
	\n, 0.9,
	\dur, 1,
));
Pdef(~name+++\mono, { arg freq, ins, n=1;
	var fre = freq;
	Pmono(ins.value,
		\type, \monoSet,
		//\instrument, ~name,
		\freq, Pseq([fre.value,fre.value*0.5,fre.value*0.1],inf),
		\dur, Pseq([1/6,1/8],inf) * n.value,
	)
});
);
