(
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		Prand([
			Pseq([
				700,200,700,400,
				700,200,700,400,
			],2)/2,

			Pseq([
				700,200,700,400,
				700,200,700,400,
			],1)/4,

			Pseq([
				700,200,700,400,
				700,200,700,400,
			],1)/1,

			Pseq([
				700,400,700,200,
				700,400,700,200,
			],1)/2,
		])
	],inf).stutter(1) + Pseq([50,0],inf).stutter(4),
	\freqlag, 0.05,
	\legato, 1.1,
	\n, 1,
	\dur, 1/8,
));
Pdef(~name+++\mono, { arg freq, ins, n=1;
	var fre = freq;
	TempoClock.default.beats.debug("wait what ?");
	Pmono(ins.value,
		\type, \monoSet,
		//\instrument, ~name,
		\ffreq, Pseq([150,230],inf).stutter(1),
		\freq, Pseq([fre.value,fre.value*0.5,fre.value*0.1],inf),
		\dur, Pseq([1/8,7/8],inf) * n.value,
	)
});
);
