(
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		Prand([
			Pseq([
				700,500,300,
			],1),

			Pseq([
				700,500,300,200,
			],1),
			Pseq([
				700,500,300,200,
				700,400,310,200,
			],1),
		])
	],inf).stutter(2) + Pseq([50,0],inf),
	\freqlag, 0.05,
	\legato, 1.1,
	\n, 1/2,
	\dur, 1/4,
));
Pdef(~name+++\mono, { arg freq, ins, n=1;
	var fre = freq;
	TempoClock.default.beats.debug("wait what ?");
	Pmono(ins.value,
		\type, \monoSet,
		//\instrument, ~name,
		\ffreq, Pseq([200,300,500,1000],inf).stutter(2),
		\freq, Pseq([fre.value,fre.value*0.5,fre.value*0.1],inf),
		\dur, Pseq([1/5,1/8],inf) * n.value,
	)
});
);
