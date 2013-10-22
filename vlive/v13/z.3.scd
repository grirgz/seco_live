(
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([700,500,300],inf).stutter(2) + Pseq([50,0],inf),
	\freqlag, 0.05,
	\legato, 0.4,
	\n, 0.2,
	\dur, 1/4,
));
Pdef(~name+++\mono, { arg freq, ins, n=1;
	var fre = freq;
	TempoClock.default.beats.debug("wait what ?");
	Pmono(ins.value,
		\type, \monoSet,
		//\instrument, ~name,
		\ffreq, Pseq([200,300,500,1000],inf),
		\freq, Pseq([fre.value,fre.value*0.5,fre.value*0.1],inf),
		\dur, Pseq([1/6,1/8],inf) * n.value,
	)
});
);
